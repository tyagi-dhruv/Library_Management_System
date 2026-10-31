package com.library.librarymanagement.repository;

import com.library.librarymanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Integer> {
    boolean existsByEmailIgnoreCase(String email);

    boolean existsByMembershipNumber(String membershipNumber);
}