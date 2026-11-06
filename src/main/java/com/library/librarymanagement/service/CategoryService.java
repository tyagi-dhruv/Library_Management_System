package com.library.librarymanagement.service;

import com.library.librarymanagement.dto.CategoryRequest;
import com.library.librarymanagement.entity.Category;
import com.library.librarymanagement.repository.CategoryRepository;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public Category create(CategoryRequest request) {
        Category parent = findParent(request.parentCategoryId());
        return categoryRepository.save(new Category(request.categoryName(), parent, request.description()));
    }

    public List<Category> list() {
        return categoryRepository.findAll();
    }

    public Category update(Integer id, CategoryRequest request) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Category not found"));
        category.update(request.categoryName(), findParent(request.parentCategoryId()), request.description());
        return categoryRepository.save(category);
    }

    private Category findParent(Integer parentCategoryId) {
        if (parentCategoryId == null) {
            return null;
        }
        return categoryRepository.findById(parentCategoryId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Parent category not found"));
    }
}
