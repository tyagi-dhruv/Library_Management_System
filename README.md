# Library Management System API

A small Spring Boot REST API using Java 22, Maven, MySQL, Spring Security, BCrypt, and JWT.

## Database

The application connects to the existing `Library_managment_system` database. Hibernate is configured with `ddl-auto=none`, so the application does not create or change tables.

The CATEGORY entity maps to the inspected table columns:

- `category_id`
- `category_name`
- `parent_category_id` (a self-reference to `CATEGORY.category_id`)
- `description`
- `created_at`

User login accounts use the existing `login_account` table. The existing role constraint on that table allows `USER` and `STUDENT`; librarian credentials are supplied through environment variables and are BCrypt-checked by the application. No database table changes are needed.

## Configuration

Provide these environment variables in the shell or IntelliJ run configuration. Do not put real values in source control.

| Variable | Required | Default |
| --- | --- | --- |
| `DB_URL` | No | `jdbc:mysql://localhost:3306/Library_managment_system` |
| `DB_USERNAME` | No | `root` |
| `DB_PASSWORD` | Yes | None |
| `JWT_SECRET_BASE64` | Yes | None |
| `JWT_EXPIRATION_MS` | No | `3600000` |
| `LIBRARIAN_USERNAME` | Yes for librarian login | None |
| `LIBRARIAN_PASSWORD` | Yes for librarian login | None |

Generate a private JWT key of at least 256 bits and encode it as Base64. For example, use `openssl rand -base64 32`. Keep the result private.

PowerShell example (replace each placeholder with your own value):

```powershell
$env:DB_USERNAME = "root"
$env:DB_PASSWORD = "<your-mysql-password>"
$env:JWT_SECRET_BASE64 = "<your-private-base64-key>"
$env:LIBRARIAN_USERNAME = "librarian"
$env:LIBRARIAN_PASSWORD = "<your-librarian-password>"
mvn spring-boot:run
```

The librarian password is hashed with BCrypt in memory. Set these variables each time you start the application, or save them in the IDE run configuration. The application does not load `.env` automatically.

## Run

Install Java 22 and Maven 3.8 or later, then start MySQL and run:

```powershell
mvn spring-boot:run
```

Base URL: `http://localhost:8081`.

## Endpoints

| Method | Path | Access |
| --- | --- | --- |
| POST | `/api/auth/register/user` | Public |
| POST | `/api/auth/login` | Public |
| GET | `/librarian/hello` | LIBRARIAN |
| GET | `/user/hello` | USER |
| POST | `/categories` | LIBRARIAN |
| GET | `/categories` | LIBRARIAN or USER |
| PUT | `/categories/{id}` | LIBRARIAN |

Registration adds a USER and login account using the existing tables. The `userTypeId` must match an existing row in `USER_TYPE`; optional `genderId` and `addressId` values must also exist.

Example category request for both POST and PUT:

```json
{
  "categoryName": "Fiction",
  "parentCategoryId": null,
  "description": "Fiction books"
}
```

To make a child category, set `parentCategoryId` to an existing category ID. A successful POST returns 201; GET and successful PUT return 200. A missing category on PUT returns 404.

## Postman

### Register a USER

Send `POST http://localhost:8081/api/auth/register/user` with Body → raw → JSON. Use IDs that exist in your database.

```json
{
  "membershipNumber": "TEST-USER-001",
  "firstName": "Alex",
  "middleName": null,
  "lastName": "Reader",
  "email": "alex.reader@example.com",
  "username": "alex.reader",
  "password": "ChooseYourOwnPassword123!",
  "phoneNumber": "9000000001",
  "dateOfBirth": "2000-01-15",
  "genderId": null,
  "addressId": null,
  "userTypeId": 1
}
```

Use a unique email, username, and membership number for each registration.

### Log in

Send `POST http://localhost:8081/api/auth/login`:

```json
{
  "usernameOrEmail": "alex.reader",
  "password": "ChooseYourOwnPassword123!"
}
```

For a librarian, use the configured `LIBRARIAN_USERNAME` and `LIBRARIAN_PASSWORD`. The login response contains an `accessToken` and its role.

### Call a protected API

In Postman, open Authorization → Bearer Token and paste `accessToken` from login. Try the hello and category requests. Create and update categories with the librarian token; list categories with either token.

| Request | Expected status |
| --- | --- |
| Protected API without a token | 401 Unauthorized |
| Protected API with an invalid/expired token | 401 Unauthorized |
| USER token → `GET /user/hello` | 200 OK |
| LIBRARIAN token → `GET /librarian/hello` | 200 OK |
| USER token → `GET /librarian/hello` | 403 Forbidden |
| LIBRARIAN token → `GET /user/hello` | 403 Forbidden |
| USER or LIBRARIAN token → `GET /categories` | 200 OK |
| USER token → category POST or PUT | 403 Forbidden |
| LIBRARIAN token → category POST | 201 Created |
| LIBRARIAN token → category PUT | 200 OK |
