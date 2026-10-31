CREATE DATABASE IF NOT EXISTS `Library_managment_system`;
USE `Library_managment_system`;

CREATE TABLE GENDER (
    gender_id INT AUTO_INCREMENT PRIMARY KEY,
    gender_name VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE ADDRESS (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    address_line1 VARCHAR(150) NOT NULL,
    address_line2 VARCHAR(150),
    city VARCHAR(80) NOT NULL,
    state VARCHAR(80) NOT NULL,
    postal_code VARCHAR(15),
    country VARCHAR(80) DEFAULT 'India'
);

CREATE TABLE USER_TYPE (
    user_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    max_books INT NOT NULL DEFAULT 3,
    loan_period_days INT NOT NULL DEFAULT 14,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    description VARCHAR(255)
);

CREATE TABLE `USER` (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    membership_number VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(60) NOT NULL,
    middle_name VARCHAR(60),
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    date_of_birth DATE,
    gender_id INT,
    address_id INT,
    user_type_id INT NOT NULL,
    registration_date DATE NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (gender_id) REFERENCES GENDER(gender_id),
    FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id),
    FOREIGN KEY (user_type_id) REFERENCES USER_TYPE(user_type_id)
);

CREATE TABLE MEMBERSHIP (
    membership_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    membership_type VARCHAR(50) NOT NULL,
    status ENUM('ACTIVE', 'EXPIRED', 'CANCELLED') DEFAULT 'ACTIVE',
    renewal_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id)
);

CREATE TABLE LIBRARIAN_ROLE (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(60) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE LIBRARIAN (
    librarian_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_code VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    role_id INT NOT NULL,
    joining_date DATE NOT NULL,
    shift VARCHAR(30),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES LIBRARIAN_ROLE(role_id)
);

CREATE TABLE PUBLISHER (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(150) NOT NULL UNIQUE,
    email VARCHAR(120),
    phone_number VARCHAR(20),
    website VARCHAR(255),
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id)
);

CREATE TABLE CATEGORY (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    parent_category_id INT,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES CATEGORY(category_id)
);

CREATE TABLE BOOK_TYPE (
    book_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(60) NOT NULL UNIQUE,
    description VARCHAR(255),
    loan_allowed BOOLEAN DEFAULT TRUE,
    default_loan_days INT DEFAULT 14,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AUTHOR (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60),
    biography TEXT,
    nationality VARCHAR(80),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE BOOK (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE,
    title VARCHAR(200) NOT NULL,
    book_type_id INT NOT NULL,
    category_id INT NOT NULL,
    publisher_id INT,
    language VARCHAR(60),
    edition VARCHAR(40),
    publication_year YEAR,
    page_count INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_type_id) REFERENCES BOOK_TYPE(book_type_id),
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id),
    FOREIGN KEY (publisher_id) REFERENCES PUBLISHER(publisher_id)
);

CREATE TABLE BOOK_AUTHOR (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    author_order INT DEFAULT 1,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES BOOK(book_id),
    FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id)
);

CREATE TABLE BOOK_COPY (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    accession_number VARCHAR(40) NOT NULL UNIQUE,
    acquisition_date DATE,
    condition_status ENUM('NEW', 'GOOD', 'DAMAGED', 'UNDER_REPAIR') DEFAULT 'GOOD',
    availability_status ENUM('AVAILABLE', 'ISSUED', 'RESERVED', 'LOST') DEFAULT 'AVAILABLE',
    shelf_location VARCHAR(80),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES BOOK(book_id)
);

INSERT INTO GENDER (gender_name, description) VALUES
('Male', 'Male'),
('Female', 'Female'),
('Other', 'Other'),
('Prefer not to say', 'Not specified'),
('Non-binary', 'Non-binary');

INSERT INTO USER_TYPE (type_name, max_books, loan_period_days, status, description) VALUES
('BTech Student', 3, 14, 'ACTIVE', 'Undergraduate engineering student'),
('MTech Student', 4, 21, 'ACTIVE', 'Postgraduate engineering student'),
('Faculty', 5, 30, 'ACTIVE', 'Teaching faculty member'),
('Research Scholar', 4, 21, 'ACTIVE', 'Research scholar'),
('Library Staff', 4, 21, 'ACTIVE', 'Library staff member'),
('Alumni', 2, 14, 'ACTIVE', 'University alumnus');

INSERT INTO LIBRARIAN_ROLE (role_name, description) VALUES
('Admin', 'Manages the library system'),
('Head Librarian', 'Supervises library operations'),
('Librarian', 'Manages issue and return activities'),
('Assistant Librarian', 'Assists students and faculty'),
('Catalog Manager', 'Maintains book catalogue'),
('Library Assistant', 'Helps with daily library work');

INSERT INTO BOOK_TYPE (type_name, description, loan_allowed, default_loan_days) VALUES
('Textbook', 'Academic textbooks for students', TRUE, 14),
('Reference Book', 'Books used for reference in the library', FALSE, 0),
('Programming Book', 'Books about programming and software development', TRUE, 14),
('Research Journal', 'Academic and research journals', FALSE, 0),
('Magazine', 'General and technology magazines', TRUE, 7),
('E-Book', 'Digital books', TRUE, 14),
('General Book', 'General reading books and novels', TRUE, 14);

INSERT INTO ADDRESS (address_line1, address_line2, city, state, postal_code, country) VALUES
('Galgotias University Campus, Knowledge Park II', NULL, 'Greater Noida', 'Uttar Pradesh', '203201', 'India'),
('Knowledge Park I', NULL, 'Greater Noida', 'Uttar Pradesh', '201310', 'India'),
('MIET Campus, NH-58', NULL, 'Meerut', 'Uttar Pradesh', '250005', 'India'),
('Sector 62', NULL, 'Noida', 'Uttar Pradesh', '201309', 'India'),
('Raj Nagar', NULL, 'Ghaziabad', 'Uttar Pradesh', '201002', 'India'),
('Shastri Nagar', NULL, 'Meerut', 'Uttar Pradesh', '250004', 'India');

INSERT INTO `USER`
(membership_number, first_name, middle_name, last_name, email, phone_number, date_of_birth, gender_id, address_id, user_type_id, registration_date, status)
VALUES
('GU-CSE-001', 'Dhruv', NULL, 'Tyagi', 'dhruv.tyagi@example.com', '9876502001', '2002-06-15',
 (SELECT gender_id FROM GENDER WHERE gender_name = 'Male' LIMIT 1),
 (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Galgotias University Campus, Knowledge Park II' ORDER BY address_id DESC LIMIT 1),
 (SELECT user_type_id FROM USER_TYPE WHERE type_name = 'BTech Student' LIMIT 1), '2026-01-10', 'ACTIVE'),
('GU-CSE-002', 'Gagan', NULL, 'Chauhan', 'gagan.chauhan@example.com', '9876502002', '2002-09-12',
 (SELECT gender_id FROM GENDER WHERE gender_name = 'Male' LIMIT 1),
 (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Knowledge Park I' ORDER BY address_id DESC LIMIT 1),
 (SELECT user_type_id FROM USER_TYPE WHERE type_name = 'BTech Student' LIMIT 1), '2026-01-12', 'ACTIVE'),
('GU-CSE-003', 'Aman', 'Kumar', 'Sharma', 'aman.sharma@example.com', '9876502003', '2003-02-18',
 (SELECT gender_id FROM GENDER WHERE gender_name = 'Male' LIMIT 1),
 (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Sector 62' ORDER BY address_id DESC LIMIT 1),
 (SELECT user_type_id FROM USER_TYPE WHERE type_name = 'BTech Student' LIMIT 1), '2026-01-15', 'ACTIVE'),
('GU-CSE-004', 'Priya', NULL, 'Verma', 'priya.verma@example.com', '9876502004', '2002-11-22',
 (SELECT gender_id FROM GENDER WHERE gender_name = 'Female' LIMIT 1),
 (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Raj Nagar' ORDER BY address_id DESC LIMIT 1),
 (SELECT user_type_id FROM USER_TYPE WHERE type_name = 'BTech Student' LIMIT 1), '2026-02-01', 'ACTIVE'),
('GU-CSE-005', 'Rohit', 'Singh', 'Tomar', 'rohit.tomar@example.com', '9876502005', '2001-08-09',
 (SELECT gender_id FROM GENDER WHERE gender_name = 'Male' LIMIT 1),
 (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Shastri Nagar' ORDER BY address_id DESC LIMIT 1),
 (SELECT user_type_id FROM USER_TYPE WHERE type_name = 'MTech Student' LIMIT 1), '2026-02-05', 'ACTIVE'),
('GU-CSE-006', 'Neha', NULL, 'Chaudhary', 'neha.chaudhary@example.com', '9876502006', '2000-12-30',
 (SELECT gender_id FROM GENDER WHERE gender_name = 'Female' LIMIT 1),
 (SELECT address_id FROM ADDRESS WHERE address_line1 = 'MIET Campus, NH-58' ORDER BY address_id DESC LIMIT 1),
 (SELECT user_type_id FROM USER_TYPE WHERE type_name = 'Alumni' LIMIT 1), '2026-02-10', 'ACTIVE');

INSERT INTO MEMBERSHIP (user_id, start_date, end_date, membership_type, status, renewal_date)
SELECT user_id, '2026-01-10', '2027-01-09', 'BTech Student', 'ACTIVE', '2027-01-01' FROM `USER` WHERE membership_number = 'GU-CSE-001'
UNION ALL
SELECT user_id, '2026-01-12', '2027-01-11', 'BTech Student', 'ACTIVE', '2027-01-03' FROM `USER` WHERE membership_number = 'GU-CSE-002'
UNION ALL
SELECT user_id, '2026-01-15', '2027-01-14', 'BTech Student', 'ACTIVE', '2027-01-05' FROM `USER` WHERE membership_number = 'GU-CSE-003'
UNION ALL
SELECT user_id, '2026-02-01', '2027-01-31', 'BTech Student', 'ACTIVE', '2027-01-20' FROM `USER` WHERE membership_number = 'GU-CSE-004'
UNION ALL
SELECT user_id, '2026-02-05', '2027-02-04', 'MTech Student', 'ACTIVE', '2027-01-25' FROM `USER` WHERE membership_number = 'GU-CSE-005'
UNION ALL
SELECT user_id, '2026-02-10', '2027-02-09', 'Alumni', 'ACTIVE', '2027-01-30' FROM `USER` WHERE membership_number = 'GU-CSE-006';

INSERT INTO LIBRARIAN (employee_code, first_name, last_name, email, phone_number, role_id, joining_date, shift, status)
VALUES
('GU-LIB-001', 'Suresh', 'Kumar', 'suresh.kumar@library.example.com', '9876512001', (SELECT role_id FROM LIBRARIAN_ROLE WHERE role_name = 'Admin' LIMIT 1), '2021-04-01', 'Morning', 'ACTIVE'),
('GU-LIB-002', 'Sunita', 'Sharma', 'sunita.sharma@library.example.com', '9876512002', (SELECT role_id FROM LIBRARIAN_ROLE WHERE role_name = 'Head Librarian' LIMIT 1), '2020-06-15', 'General', 'ACTIVE'),
('GU-LIB-003', 'Manoj', 'Tyagi', 'manoj.tyagi@library.example.com', '9876512003', (SELECT role_id FROM LIBRARIAN_ROLE WHERE role_name = 'Librarian' LIMIT 1), '2022-01-10', 'Morning', 'ACTIVE'),
('GU-LIB-004', 'Poonam', 'Rana', 'poonam.rana@library.example.com', '9876512004', (SELECT role_id FROM LIBRARIAN_ROLE WHERE role_name = 'Assistant Librarian' LIMIT 1), '2023-08-20', 'Evening', 'ACTIVE'),
('GU-LIB-005', 'Vivek', 'Chauhan', 'vivek.chauhan@library.example.com', '9876512005', (SELECT role_id FROM LIBRARIAN_ROLE WHERE role_name = 'Catalog Manager' LIMIT 1), '2021-11-05', 'General', 'ACTIVE'),
('GU-LIB-006', 'Kavita', 'Singh', 'kavita.singh@library.example.com', '9876512006', (SELECT role_id FROM LIBRARIAN_ROLE WHERE role_name = 'Library Assistant' LIMIT 1), '2024-02-12', 'Morning', 'ACTIVE');

INSERT INTO PUBLISHER (publisher_name, email, phone_number, website, address_id) VALUES
('Pearson', NULL, NULL, 'https://www.pearson.com', (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Sector 62' ORDER BY address_id DESC LIMIT 1)),
('McGraw Hill', NULL, NULL, 'https://www.mheducation.com', (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Sector 62' ORDER BY address_id DESC LIMIT 1)),
('Oxford University Press', NULL, NULL, 'https://global.oup.com', (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Raj Nagar' ORDER BY address_id DESC LIMIT 1)),
('BPB Publications', NULL, NULL, 'https://www.bpbonline.com', (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Knowledge Park I' ORDER BY address_id DESC LIMIT 1)),
('Prentice Hall', NULL, NULL, 'https://www.pearson.com', (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Sector 62' ORDER BY address_id DESC LIMIT 1)),
('Penguin Random House India', NULL, NULL, 'https://www.penguin.co.in', (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Shastri Nagar' ORDER BY address_id DESC LIMIT 1)),
('MIT Press', NULL, NULL, 'https://mitpress.mit.edu', (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Knowledge Park I' ORDER BY address_id DESC LIMIT 1)),
('Wiley', NULL, NULL, 'https://www.wiley.com', (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Raj Nagar' ORDER BY address_id DESC LIMIT 1)),
('Dhanpat Rai Publications', NULL, NULL, NULL, (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Knowledge Park I' ORDER BY address_id DESC LIMIT 1)),
('Puffin Books', NULL, NULL, 'https://www.penguin.co.in', (SELECT address_id FROM ADDRESS WHERE address_line1 = 'Shastri Nagar' ORDER BY address_id DESC LIMIT 1));

INSERT INTO CATEGORY (category_name, parent_category_id, description) VALUES
('Story Books', NULL, 'Stories, novels and short story collections'),
('Maths', NULL, 'Mathematics books and problem-solving guides'),
('Computer', NULL, 'Computer science, programming and technology books'),
('English', NULL, 'English grammar, language and literature books'),
('General Knowledge', NULL, 'General knowledge and informative books'),
('Children Books', NULL, 'Books written for children and young readers');

INSERT INTO AUTHOR (first_name, last_name, biography, nationality, date_of_birth) VALUES
('R. D.', 'Sharma', 'Indian mathematics author known for school mathematics textbooks.', 'Indian', NULL),
('Herbert', 'Schildt', 'Author of programming language reference books.', 'American', NULL),
('Yashavant', 'Kanetkar', 'Indian author known for programming books.', 'Indian', NULL),
('Ruskin', 'Bond', 'Indian author known for short stories and childrens books.', 'Indian', '1934-05-19'),
('Sudha', 'Murty', 'Indian author known for childrens books and short stories.', 'Indian', '1950-08-19'),
('R. K.', 'Narayan', 'Indian novelist known for stories set in the fictional town of Malgudi.', 'Indian', '1906-10-10'),
('P. C.', 'Wren', 'Author known for English grammar books.', 'British', NULL),
('H.', 'Martin', 'Co-author of English grammar books.', 'British', NULL);

INSERT INTO BOOK (isbn, title, book_type_id, category_id, publisher_id, language, edition, publication_year, page_count, description)
VALUES
(NULL, 'Mathematics for Class 10', (SELECT book_type_id FROM BOOK_TYPE WHERE type_name = 'Textbook' LIMIT 1), (SELECT category_id FROM CATEGORY WHERE category_name = 'Maths' LIMIT 1), (SELECT publisher_id FROM PUBLISHER WHERE publisher_name = 'Dhanpat Rai Publications' LIMIT 1), 'English', 'Revised', 2024, 800, 'School mathematics textbook by R. D. Sharma.'),
('9781260440232', 'Java: The Complete Reference', (SELECT book_type_id FROM BOOK_TYPE WHERE type_name = 'Programming Book' LIMIT 1), (SELECT category_id FROM CATEGORY WHERE category_name = 'Computer' LIMIT 1), (SELECT publisher_id FROM PUBLISHER WHERE publisher_name = 'McGraw Hill' LIMIT 1), 'English', '12th', 2021, 1248, 'A comprehensive guide to Java programming.'),
(NULL, 'Let Us C', (SELECT book_type_id FROM BOOK_TYPE WHERE type_name = 'Programming Book' LIMIT 1), (SELECT category_id FROM CATEGORY WHERE category_name = 'Computer' LIMIT 1), (SELECT publisher_id FROM PUBLISHER WHERE publisher_name = 'BPB Publications' LIMIT 1), 'English', '18th', 2022, 320, 'A beginner-friendly book on C programming.'),
(NULL, 'The Blue Umbrella', (SELECT book_type_id FROM BOOK_TYPE WHERE type_name = 'General Book' LIMIT 1), (SELECT category_id FROM CATEGORY WHERE category_name = 'Story Books' LIMIT 1), (SELECT publisher_id FROM PUBLISHER WHERE publisher_name = 'Penguin Random House India' LIMIT 1), 'English', 'Reprint', 1980, 96, 'A popular story by Ruskin Bond.'),
(NULL, 'Grandma''s Bag of Stories', (SELECT book_type_id FROM BOOK_TYPE WHERE type_name = 'General Book' LIMIT 1), (SELECT category_id FROM CATEGORY WHERE category_name = 'Children Books' LIMIT 1), (SELECT publisher_id FROM PUBLISHER WHERE publisher_name = 'Puffin Books' LIMIT 1), 'English', '1st', 2012, 256, 'A collection of stories for children by Sudha Murty.'),
(NULL, 'Malgudi Days', (SELECT book_type_id FROM BOOK_TYPE WHERE type_name = 'General Book' LIMIT 1), (SELECT category_id FROM CATEGORY WHERE category_name = 'Story Books' LIMIT 1), (SELECT publisher_id FROM PUBLISHER WHERE publisher_name = 'Penguin Random House India' LIMIT 1), 'English', 'Reprint', 1943, 256, 'A collection of short stories by R. K. Narayan.'),
(NULL, 'High School English Grammar and Composition', (SELECT book_type_id FROM BOOK_TYPE WHERE type_name = 'Textbook' LIMIT 1), (SELECT category_id FROM CATEGORY WHERE category_name = 'English' LIMIT 1), (SELECT publisher_id FROM PUBLISHER WHERE publisher_name = 'Oxford University Press' LIMIT 1), 'English', 'Revised', 2020, 640, 'English grammar and composition reference book.');

INSERT INTO BOOK_AUTHOR (book_id, author_id, author_order)
SELECT b.book_id, a.author_id, 1 FROM BOOK b JOIN AUTHOR a ON a.first_name = 'R. D.' AND a.last_name = 'Sharma' WHERE b.title = 'Mathematics for Class 10'
UNION ALL
SELECT b.book_id, a.author_id, 1 FROM BOOK b JOIN AUTHOR a ON a.first_name = 'Herbert' AND a.last_name = 'Schildt' WHERE b.title = 'Java: The Complete Reference'
UNION ALL
SELECT b.book_id, a.author_id, 1 FROM BOOK b JOIN AUTHOR a ON a.first_name = 'Yashavant' AND a.last_name = 'Kanetkar' WHERE b.title = 'Let Us C'
UNION ALL
SELECT b.book_id, a.author_id, 1 FROM BOOK b JOIN AUTHOR a ON a.first_name = 'Ruskin' AND a.last_name = 'Bond' WHERE b.title = 'The Blue Umbrella'
UNION ALL
SELECT b.book_id, a.author_id, 1 FROM BOOK b JOIN AUTHOR a ON a.first_name = 'Sudha' AND a.last_name = 'Murty' WHERE b.title = 'Grandma''s Bag of Stories'
UNION ALL
SELECT b.book_id, a.author_id, 1 FROM BOOK b JOIN AUTHOR a ON a.first_name = 'R. K.' AND a.last_name = 'Narayan' WHERE b.title = 'Malgudi Days'
UNION ALL
SELECT b.book_id, a.author_id, 1 FROM BOOK b JOIN AUTHOR a ON a.first_name = 'P. C.' AND a.last_name = 'Wren' WHERE b.title = 'High School English Grammar and Composition'
UNION ALL
SELECT b.book_id, a.author_id, 2 FROM BOOK b JOIN AUTHOR a ON a.first_name = 'H.' AND a.last_name = 'Martin' WHERE b.title = 'High School English Grammar and Composition';

INSERT INTO BOOK_COPY (book_id, accession_number, acquisition_date, condition_status, availability_status, shelf_location)
VALUES
((SELECT book_id FROM BOOK WHERE title = 'Mathematics for Class 10' LIMIT 1), 'GU-ACC-001', '2026-01-05', 'GOOD', 'AVAILABLE', 'MATH-A1'),
((SELECT book_id FROM BOOK WHERE title = 'Java: The Complete Reference' LIMIT 1), 'GU-ACC-002', '2026-01-06', 'NEW', 'AVAILABLE', 'CSE-A1'),
((SELECT book_id FROM BOOK WHERE title = 'Let Us C' LIMIT 1), 'GU-ACC-003', '2026-01-07', 'GOOD', 'AVAILABLE', 'CSE-A2'),
((SELECT book_id FROM BOOK WHERE title = 'The Blue Umbrella' LIMIT 1), 'GU-ACC-004', '2026-01-08', 'GOOD', 'AVAILABLE', 'STORY-B1'),
((SELECT book_id FROM BOOK WHERE title = 'Grandma''s Bag of Stories' LIMIT 1), 'GU-ACC-005', '2026-01-09', 'GOOD', 'AVAILABLE', 'CHILD-C1'),
((SELECT book_id FROM BOOK WHERE title = 'Malgudi Days' LIMIT 1), 'GU-ACC-006', '2026-01-10', 'NEW', 'AVAILABLE', 'LIT-D1'),
((SELECT book_id FROM BOOK WHERE title = 'Mathematics for Class 10' LIMIT 1), 'GU-ACC-007', '2026-02-01', 'GOOD', 'AVAILABLE', 'MATH-A1');

SELECT 'GENDER' AS table_name, COUNT(*) AS total_records FROM GENDER
UNION ALL SELECT 'ADDRESS', COUNT(*) FROM ADDRESS
UNION ALL SELECT 'USER_TYPE', COUNT(*) FROM USER_TYPE
UNION ALL SELECT 'USER', COUNT(*) FROM `USER`
UNION ALL SELECT 'MEMBERSHIP', COUNT(*) FROM MEMBERSHIP
UNION ALL SELECT 'LIBRARIAN_ROLE', COUNT(*) FROM LIBRARIAN_ROLE
UNION ALL SELECT 'LIBRARIAN', COUNT(*) FROM LIBRARIAN
UNION ALL SELECT 'PUBLISHER', COUNT(*) FROM PUBLISHER
UNION ALL SELECT 'CATEGORY', COUNT(*) FROM CATEGORY
UNION ALL SELECT 'BOOK_TYPE', COUNT(*) FROM BOOK_TYPE
UNION ALL SELECT 'AUTHOR', COUNT(*) FROM AUTHOR
UNION ALL SELECT 'BOOK', COUNT(*) FROM BOOK
UNION ALL SELECT 'BOOK_AUTHOR', COUNT(*) FROM BOOK_AUTHOR
UNION ALL SELECT 'BOOK_COPY', COUNT(*) FROM BOOK_COPY;
