USE `Library_managment_system`;

CREATE TABLE IF NOT EXISTS login_account (
    login_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    username VARCHAR(80) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    role VARCHAR(10) NOT NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_login_account_user
        FOREIGN KEY (user_id) REFERENCES `USER` (user_id),
    CONSTRAINT chk_login_account_role
        CHECK (role IN ('USER', 'STUDENT')),
    CONSTRAINT chk_login_account_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);