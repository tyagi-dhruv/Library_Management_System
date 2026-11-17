package com.library.librarymanagement.repository;

import com.library.librarymanagement.entity.Book;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository extends JpaRepository<Book, Integer> {

    List<Book> findByCategoryCategoryId(Integer categoryId);
}
