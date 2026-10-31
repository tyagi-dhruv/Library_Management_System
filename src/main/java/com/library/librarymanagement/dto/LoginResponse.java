package com.library.librarymanagement.dto;

import com.library.librarymanagement.entity.Role;

public record LoginResponse(String accessToken, String tokenType, long expiresIn, Role role) {
}