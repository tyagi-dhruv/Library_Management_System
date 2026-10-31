# Library Management System Authentication

Spring Boot 3 / Java 17 backend for JWT authentication and USER/STUDENT authorization against the existing MySQL database. The project does not implement book, membership, payment, or fine operations.

## Requirements

- Java 17 or later
- Maven 3.8+
- MySQL with the existing `Library_managment_system` database and its 14 tables
- IntelliJ IDEA or another Java IDE

## Database Setup

The provided `schema.sql` describes the existing database tables. Do not rerun it against a populated database: it is not a migration script. Review and run only [`sql/login_account.sql`](sql/login_account.sql) in MySQL Workbench. It creates the new login table and foreign key without changing the existing tables or records.

Registration inserts a row into the existing `USER` table, so its `userTypeId` must refer to an existing `USER_TYPE.user_type_id`. If provided, `genderId` and `addressId` must also refer to existing rows. The auth role (`USER` or `STUDENT`) is stored only in `login_account.role`; it is separate from `USER_TYPE`.

## Environment Configuration

Set these variables in the IntelliJ run configuration's Environment variables field, or in your shell before starting the application:

| Variable | Required | Default |
| --- | --- | --- |
| `DB_URL` | No | `jdbc:mysql://localhost:3306/Library_managment_system` |
| `DB_USERNAME` | No | `root` |
| `DB_PASSWORD` | Yes | None |
| `JWT_SECRET_BASE64` | Yes | None |
| `JWT_EXPIRATION_MS` | No | `3600000` |

Generate a signing key of at least 256 bits and encode it as Base64, for example with `openssl rand -base64 32`. Keep the resulting value private and do not commit it. The application uses `ddl-auto=none`; Hibernate will not create or update tables.

Example PowerShell setup for the current terminal (replace the database username/password with your own):

```powershell
$env:DB_USERNAME = "root"
$env:DB_PASSWORD = "your-local-mysql-password"
$env:JWT_SECRET_BASE64 = "VGhpc0lzQU5vdEFjdHVhbFByb2R1Y3Rpb25TZWNyZXRLZXkxMjM0NQ=="
mvn spring-boot:run
```

In IntelliJ, open the project folder containing `pom.xml`, set the same environment variables in the run configuration, and run `LibraryManagementApplication`.

## API Endpoints

Base URL: `http://localhost:8081` (change using `SERVER_PORT` if needed)

| Method | Path | Access |
| --- | --- | --- |
| POST | `/api/auth/register/user` | Public |
| POST | `/api/auth/register/student` | Public |
| POST | `/api/auth/login` | Public |
| GET | `/api/user/profile` | USER |
| GET | `/api/user/dashboard` | USER |
| POST | `/api/user/manage-account` | USER |
| GET | `/api/student/profile` | STUDENT |
| GET | `/api/student/dashboard` | STUDENT |
| GET | `/api/student/library` | STUDENT |

The protected endpoints are placeholders and perform no library operations. Registration responds with the new `userId`, username, and a message; it never includes the submitted password or its hash.

## Postman Testing

For all requests, select `Body` > `raw` > `JSON` where a body is shown. Register one account through each registration endpoint, using distinct emails, usernames, and membership numbers. Change `userTypeId` to an ID that exists in your database.

USER registration (`POST /api/auth/register/user`):

```json
{
  "membershipNumber": "TEST-USER-001",
  "firstName": "Alex",
  "middleName": null,
  "lastName": "Reader",
  "email": "alex.reader@example.com",
  "username": "alex.reader",
  "password": "ChangeThis123!",
  "phoneNumber": "9000000001",
  "dateOfBirth": "2000-01-15",
  "genderId": null,
  "addressId": null,
  "userTypeId": 1
}
```

Use the same JSON shape for `POST /api/auth/register/student` with unique values.

Log in with `POST /api/auth/login`; set `usernameOrEmail` to either the registered username or email:

```json
{
  "usernameOrEmail": "alex.reader",
  "password": "ChangeThis123!"
}
```

Copy `accessToken` from the response. For protected requests, select the Postman `Authorization` tab, choose `Bearer Token`, and paste the token. Repeat login for the student account to get its token.

Expected checks:

| Request | Expected status |
| --- | --- |
| USER token to each `/api/user/**` endpoint | 200 |
| STUDENT token to each `/api/student/**` endpoint | 200 |
| STUDENT token to any `/api/user/**` endpoint | 403 |
| USER token to any `/api/student/**` endpoint | 403 |
| No token to any protected endpoint | 401 |
| Invalid, modified, or expired token to a protected endpoint | 401 |

The default token lifetime is one hour. For an expiration test, set `JWT_EXPIRATION_MS` to a short positive value, restart the application, log in, wait for that duration, and call a protected route with that token. An expired token must return 401.

## Run Tests

```powershell
mvn test
```

The MockMvc tests verify allowed USER and STUDENT access, cross-role 403 responses, and missing, malformed, and expired token 401 responses. They do not require a running MySQL instance. To use the API manually, MySQL must be running and the SQL setup and environment variables must be configured first.