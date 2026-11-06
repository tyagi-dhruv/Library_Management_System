package com.library.librarymanagement.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LibrarianController {

    @GetMapping("/librarian/hello")
    public String hello() {
        return "Hello Librarian";
    }
}
