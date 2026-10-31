package com.library.librarymanagement.service;

import com.library.librarymanagement.dto.LoginRequest;
import com.library.librarymanagement.dto.LoginResponse;
import com.library.librarymanagement.dto.RegisterRequest;
import com.library.librarymanagement.dto.RegistrationResponse;
import com.library.librarymanagement.entity.LoginAccount;
import com.library.librarymanagement.entity.Role;
import com.library.librarymanagement.entity.User;
import com.library.librarymanagement.repository.LoginAccountRepository;
import com.library.librarymanagement.repository.UserRepository;
import com.library.librarymanagement.security.JwtUtil;
import java.time.LocalDate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LoginService {

    private final UserRepository userRepository;
    private final LoginAccountRepository loginAccountRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public LoginService(UserRepository userRepository, LoginAccountRepository loginAccountRepository,
                        PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.loginAccountRepository = loginAccountRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
    }

    @Transactional
    public RegistrationResponse register(RegisterRequest request, Role role) {
        if (userRepository.existsByEmailIgnoreCase(request.email())) {
            throw new DuplicateAccountException("Email is already registered");
        }
        if (userRepository.existsByMembershipNumber(request.membershipNumber())) {
            throw new DuplicateAccountException("Membership number is already registered");
        }
        if (loginAccountRepository.existsByUsernameIgnoreCase(request.username())) {
            throw new DuplicateAccountException("Username is already registered");
        }

        User user = userRepository.save(new User(
                request.membershipNumber(), request.firstName(), request.middleName(), request.lastName(),
                request.email(), request.phoneNumber(), request.dateOfBirth(), request.genderId(),
                request.addressId(), request.userTypeId(), LocalDate.now()));
        loginAccountRepository.save(new LoginAccount(
                user, request.username(), passwordEncoder.encode(request.password()), role));

        return new RegistrationResponse(user.getUserId(), request.username(), "Registration successful");
    }

    @Transactional(readOnly = true)
    public LoginResponse login(LoginRequest request) {
        LoginAccount account = loginAccountRepository.findByUsernameOrEmail(request.usernameOrEmail())
                .filter(found -> "ACTIVE".equalsIgnoreCase(found.getStatus()))
                .filter(found -> passwordEncoder.matches(request.password(), found.getPasswordHash()))
                .orElseThrow(InvalidCredentialsException::new);

        return new LoginResponse(jwtUtil.generateToken(account.getUsername(), account.getRole()),
                "Bearer", jwtUtil.getExpirationSeconds(), account.getRole());
    }
}