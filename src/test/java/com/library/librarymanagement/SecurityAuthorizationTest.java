package com.library.librarymanagement;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.library.librarymanagement.config.SecurityConfig;
import com.library.librarymanagement.service.CategoryService;
import com.library.librarymanagement.entity.Role;
import com.library.librarymanagement.security.JwtFilter;
import com.library.librarymanagement.security.JwtUtil;
import java.time.Duration;
import java.security.SecureRandom;
import java.util.Base64;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(properties = {
        "jwt.expiration-ms=3600000"
})
@Import({SecurityConfig.class, JwtFilter.class, JwtUtil.class})
class SecurityAuthorizationTest {

    private static final String TEST_SECRET = createTestSecret();

    @DynamicPropertySource
    static void jwtProperties(DynamicPropertyRegistry registry) {
        registry.add("jwt.secret-base64", () -> TEST_SECRET);
    }

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private JwtUtil jwtUtil;

    @MockitoBean
    private com.library.librarymanagement.service.LoginService loginService;

    @MockitoBean
    private CategoryService categoryService;

    private static String createTestSecret() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return Base64.getEncoder().encodeToString(bytes);
    }

    @Test
    void userTokenCanAccessUserHelloAndCategoryList() throws Exception {
        String token = jwtUtil.generateToken("reader", Role.USER);
        mockMvc.perform(get("/user/hello").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content()
                        .string("Hello User"));
        mockMvc.perform(get("/categories").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }

    @Test
    void librarianTokenCanAccessLibrarianAndCategoryApis() throws Exception {
        String token = jwtUtil.generateToken("librarian", Role.LIBRARIAN);
        mockMvc.perform(get("/librarian/hello").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content()
                        .string("Hello Librarian"));
        mockMvc.perform(get("/categories").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
        mockMvc.perform(post("/categories").header("Authorization", "Bearer " + token)
                        .contentType("application/json").content("{\"categoryName\":\"Fiction\"}"))
                .andExpect(status().isCreated());
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put("/categories/1")
                        .header("Authorization", "Bearer " + token)
                        .contentType("application/json").content("{\"categoryName\":\"Fiction\"}"))
                .andExpect(status().isOk());
    }

    @Test
    void rolesCannotAccessEachOthersApis() throws Exception {
        String userToken = jwtUtil.generateToken("reader", Role.USER);
        String librarianToken = jwtUtil.generateToken("librarian", Role.LIBRARIAN);
        mockMvc.perform(get("/librarian/hello").header("Authorization", "Bearer " + userToken))
                .andExpect(status().isForbidden());
        mockMvc.perform(post("/categories").header("Authorization", "Bearer " + userToken)
                        .contentType("application/json").content("{\"categoryName\":\"Fiction\"}"))
                .andExpect(status().isForbidden());
        mockMvc.perform(get("/user/hello").header("Authorization", "Bearer " + librarianToken))
                .andExpect(status().isForbidden());
    }

    @Test
    void missingInvalidAndExpiredTokensAreUnauthorized() throws Exception {
        mockMvc.perform(get("/user/hello")).andExpect(status().isUnauthorized());
        mockMvc.perform(get("/user/hello").header("Authorization", "Bearer not-a-jwt"))
                .andExpect(status().isUnauthorized());
        String expiredToken = jwtUtil.generateToken("reader", Role.USER, Duration.ofMillis(-1000));
        mockMvc.perform(get("/user/hello").header("Authorization", "Bearer " + expiredToken))
                .andExpect(status().isUnauthorized());
    }
}
