package com.library.librarymanagement.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record BookRequest(
        @Size(max = 20) String isbn,
        @NotBlank @Size(max = 200) String title,
        @NotNull Integer bookTypeId,
        @NotNull Integer categoryId,
        Integer publisherId,
        @Size(max = 60) String language,
        @Size(max = 40) String edition,
        @Min(0) Integer publicationYear,
        @Min(0) Integer pageCount,
        String description) {
}
