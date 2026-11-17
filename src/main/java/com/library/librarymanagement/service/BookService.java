package com.library.librarymanagement.service;

import com.library.librarymanagement.dto.BookRequest;
import com.library.librarymanagement.entity.Book;
import com.library.librarymanagement.entity.Category;
import com.library.librarymanagement.repository.BookRepository;
import com.library.librarymanagement.repository.CategoryRepository;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class BookService {

    private final BookRepository bookRepository;
    private final CategoryRepository categoryRepository;

    public BookService(BookRepository bookRepository, CategoryRepository categoryRepository) {
        this.bookRepository = bookRepository;
        this.categoryRepository = categoryRepository;
    }

    public Book create(BookRequest request) {
        return bookRepository.save(new Book(request.isbn(), request.title(), request.bookTypeId(),
                findCategory(request.categoryId()), request.publisherId(), request.language(), request.edition(),
                request.publicationYear(), request.pageCount(), request.description()));
    }

    public List<Book> list() {
        return bookRepository.findAll();
    }

    public Book get(Integer id) {
        return bookRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Book not found"));
    }

    public Book update(Integer id, BookRequest request) {
        Book book = get(id);
        book.update(request.isbn(), request.title(), request.bookTypeId(), findCategory(request.categoryId()),
                request.publisherId(), request.language(), request.edition(), request.publicationYear(),
                request.pageCount(), request.description());
        return bookRepository.save(book);
    }

    public void delete(Integer id) {
        bookRepository.delete(get(id));
    }

    public List<Book> listByCategory(Integer categoryId) {
        findCategory(categoryId);
        return bookRepository.findByCategoryCategoryId(categoryId);
    }

    private Category findCategory(Integer categoryId) {
        return categoryRepository.findById(categoryId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Category not found"));
    }
}
