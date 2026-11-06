package com.library.librarymanagement.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CategoryRequest(
        @NotBlank @Size(max = 100) String categoryName,
        Integer parentCategoryId,
        @Size(max = 255) String description) {
}
