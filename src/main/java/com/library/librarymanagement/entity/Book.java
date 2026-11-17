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
@Table(name = "BOOK")
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "book_id")
    private Integer bookId;

    @Column(name = "isbn", unique = true, length = 20)
    private String isbn;

    @Column(name = "title", nullable = false, length = 200)
    private String title;

    @Column(name = "book_type_id", nullable = false)
    private Integer bookTypeId;

    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(name = "publisher_id")
    private Integer publisherId;

    @Column(name = "language", length = 60)
    private String language;

    @Column(name = "edition", length = 40)
    private String edition;

    @Column(name = "publication_year")
    private Integer publicationYear;

    @Column(name = "page_count")
    private Integer pageCount;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;

    protected Book() {
    }

    public Book(String isbn, String title, Integer bookTypeId, Category category, Integer publisherId,
                String language, String edition, Integer publicationYear, Integer pageCount, String description) {
        this.isbn = isbn;
        this.title = title;
        this.bookTypeId = bookTypeId;
        this.category = category;
        this.publisherId = publisherId;
        this.language = language;
        this.edition = edition;
        this.publicationYear = publicationYear;
        this.pageCount = pageCount;
        this.description = description;
    }

    public Integer getBookId() {
        return bookId;
    }

    public String getIsbn() {
        return isbn;
    }

    public String getTitle() {
        return title;
    }

    public Integer getBookTypeId() {
        return bookTypeId;
    }

    @JsonIgnore
    public Category getCategory() {
        return category;
    }

    public Integer getCategoryId() {
        return category == null ? null : category.getCategoryId();
    }

    public Integer getPublisherId() {
        return publisherId;
    }

    public String getLanguage() {
        return language;
    }

    public String getEdition() {
        return edition;
    }

    public Integer getPublicationYear() {
        return publicationYear;
    }

    public Integer getPageCount() {
        return pageCount;
    }

    public String getDescription() {
        return description;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void update(String isbn, String title, Integer bookTypeId, Category category, Integer publisherId,
                       String language, String edition, Integer publicationYear, Integer pageCount,
                       String description) {
        this.isbn = isbn;
        this.title = title;
        this.bookTypeId = bookTypeId;
        this.category = category;
        this.publisherId = publisherId;
        this.language = language;
        this.edition = edition;
        this.publicationYear = publicationYear;
        this.pageCount = pageCount;
        this.description = description;
    }
}
