package com.library.librarymanagement.controller;

import com.library.librarymanagement.dto.LoginRequest;
import com.library.librarymanagement.dto.LoginResponse;
import com.library.librarymanagement.dto.RegisterRequest;
import com.library.librarymanagement.dto.RegistrationResponse;
import com.library.librarymanagement.entity.Role;
import com.library.librarymanagement.service.LoginService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class LoginController {

    private final LoginService loginService;

    public LoginController(LoginService loginService) {
        this.loginService = loginService;
    }

    @PostMapping("/register/user")
    public RegistrationResponse registerUser(@Valid @RequestBody RegisterRequest request) {
        return loginService.register(request, Role.USER);
    }

    @PostMapping("/register/student")
    public RegistrationResponse registerStudent(@Valid @RequestBody RegisterRequest request) {
        return loginService.register(request, Role.STUDENT);
    }

    @PostMapping("/login")
    public LoginResponse login(@Valid @RequestBody LoginRequest request) {
        return loginService.login(request);
    }
}