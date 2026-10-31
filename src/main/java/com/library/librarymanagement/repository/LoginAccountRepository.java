package com.library.librarymanagement.repository;

import com.library.librarymanagement.entity.LoginAccount;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface LoginAccountRepository extends JpaRepository<LoginAccount, Long> {
    boolean existsByUsernameIgnoreCase(String username);

    @Query("select account from LoginAccount account join fetch account.user "
            + "where lower(account.username) = lower(:identity) or lower(account.user.email) = lower(:identity)")
    Optional<LoginAccount> findByUsernameOrEmail(@Param("identity") String identity);
}