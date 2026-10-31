package com.library.librarymanagement.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;

@Entity
@Table(name = "`USER`")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "membership_number", nullable = false, unique = true, length = 30)
    private String membershipNumber;

    @Column(name = "first_name", nullable = false, length = 60)
    private String firstName;

    @Column(name = "middle_name", length = 60)
    private String middleName;

    @Column(name = "last_name", nullable = false, length = 60)
    private String lastName;

    @Column(name = "email", nullable = false, unique = true, length = 120)
    private String email;

    @Column(name = "phone_number", length = 20)
    private String phoneNumber;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "gender_id")
    private Integer genderId;

    @Column(name = "address_id")
    private Integer addressId;

    @Column(name = "user_type_id", nullable = false)
    private Integer userTypeId;

    @Column(name = "registration_date", nullable = false)
    private LocalDate registrationDate;

    protected User() {
    }

    public User(String membershipNumber, String firstName, String middleName, String lastName,
                String email, String phoneNumber, LocalDate dateOfBirth, Integer genderId,
                Integer addressId, Integer userTypeId, LocalDate registrationDate) {
        this.membershipNumber = membershipNumber;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.dateOfBirth = dateOfBirth;
        this.genderId = genderId;
        this.addressId = addressId;
        this.userTypeId = userTypeId;
        this.registrationDate = registrationDate;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }
}