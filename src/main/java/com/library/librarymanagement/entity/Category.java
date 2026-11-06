package com.library.librarymanagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.Instant;

@Entity
@Table(name = "CATEGORY")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Integer categoryId;

    @Column(name = "category_name", nullable = false, unique = true, length = 100)
    private String categoryName;

    @ManyToOne
    @JoinColumn(name = "parent_category_id")
    private Category parentCategory;

    @Column(name = "description", length = 255)
    private String description;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;

    protected Category() {
    }

    public Category(String categoryName, Category parentCategory, String description) {
        this.categoryName = categoryName;
        this.parentCategory = parentCategory;
        this.description = description;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    @JsonIgnore
    public Category getParentCategory() {
        return parentCategory;
    }

    public Integer getParentCategoryId() {
        return parentCategory == null ? null : parentCategory.getCategoryId();
    }

    public String getDescription() {
        return description;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void update(String categoryName, Category parentCategory, String description) {
        this.categoryName = categoryName;
        this.parentCategory = parentCategory;
        this.description = description;
    }
}
