package com.library.librarymanagement.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

public record RegisterRequest(
        @NotBlank @Size(max = 30) String membershipNumber,
        @NotBlank @Size(max = 60) String firstName,
        @Size(max = 60) String middleName,
        @NotBlank @Size(max = 60) String lastName,
        @NotBlank @Email @Size(max = 120) String email,
        @NotBlank @Size(max = 80) String username,
        @NotBlank @Size(min = 8, max = 72) String password,
        @Size(max = 20) String phoneNumber,
        LocalDate dateOfBirth,
        Integer genderId,
        Integer addressId,
        @NotNull Integer userTypeId) {
}