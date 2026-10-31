package com.library.librarymanagement.controller;

import java.util.Map;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @GetMapping("/profile")
    public Map<String, String> getUserProfile(Authentication authentication) {
        return Map.of("message", "USER profile placeholder", "username", authentication.getName());
    }

    @GetMapping("/dashboard")
    public Map<String, String> getUserDashboard() {
        return Map.of("message", "USER dashboard placeholder");
    }

    @PostMapping("/manage-account")
    public Map<String, String> manageUserAccount() {
        return Map.of("message", "USER account management placeholder");
    }
}