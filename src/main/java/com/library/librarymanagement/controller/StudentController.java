package com.library.librarymanagement.controller;

import java.util.Map;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/student")
public class StudentController {

    @GetMapping("/profile")
    public Map<String, String> getStudentProfile(Authentication authentication) {
        return Map.of("message", "STUDENT profile placeholder", "username", authentication.getName());
    }

    @GetMapping("/dashboard")
    public Map<String, String> getStudentDashboard() {
        return Map.of("message", "STUDENT dashboard placeholder");
    }

    @GetMapping("/library")
    public Map<String, String> accessStudentLibrary() {
        return Map.of("message", "STUDENT library access placeholder");
    }
}