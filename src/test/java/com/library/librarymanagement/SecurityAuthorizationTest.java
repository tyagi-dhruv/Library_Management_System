package com.library.librarymanagement;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.library.librarymanagement.config.SecurityConfig;
import com.library.librarymanagement.entity.Role;
import com.library.librarymanagement.security.JwtFilter;
import com.library.librarymanagement.security.JwtUtil;
import java.time.Duration;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(properties = {
        "jwt.secret-base64=VGhpc0lzQU5vdEFjdHVhbFByb2R1Y3Rpb25TZWNyZXRLZXkxMjM0NQ==",
        "jwt.expiration-ms=3600000"
})
@Import({SecurityConfig.class, JwtFilter.class, JwtUtil.class})
class SecurityAuthorizationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private JwtUtil jwtUtil;

        @MockitoBean
        private com.library.librarymanagement.service.LoginService loginService;

    @Test
    void userTokenCanAccessUserApis() throws Exception {
        String token = jwtUtil.generateToken("reader", Role.USER);
        mockMvc.perform(get("/api/user/profile").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/user/dashboard").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
        mockMvc.perform(post("/api/user/manage-account").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }

    @Test
    void studentTokenCanAccessStudentApis() throws Exception {
        String token = jwtUtil.generateToken("student", Role.STUDENT);
        mockMvc.perform(get("/api/student/profile").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/student/dashboard").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/student/library").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }

    @Test
    void rolesCannotAccessEachOthersApis() throws Exception {
        String userToken = jwtUtil.generateToken("reader", Role.USER);
        String studentToken = jwtUtil.generateToken("student", Role.STUDENT);
        mockMvc.perform(get("/api/student/profile").header("Authorization", "Bearer " + userToken))
                .andExpect(status().isForbidden());
        mockMvc.perform(get("/api/student/dashboard").header("Authorization", "Bearer " + userToken))
                .andExpect(status().isForbidden());
        mockMvc.perform(get("/api/user/dashboard").header("Authorization", "Bearer " + studentToken))
                .andExpect(status().isForbidden());
    }

    @Test
    void missingInvalidAndExpiredTokensAreUnauthorized() throws Exception {
        mockMvc.perform(get("/api/user/profile")).andExpect(status().isUnauthorized());
        mockMvc.perform(get("/api/user/profile").header("Authorization", "Bearer not-a-jwt"))
                .andExpect(status().isUnauthorized());
        String expiredToken = jwtUtil.generateToken("reader", Role.USER, Duration.ofMillis(-1000));
        mockMvc.perform(get("/api/user/profile").header("Authorization", "Bearer " + expiredToken))
                .andExpect(status().isUnauthorized());
    }
}