# 🏦 Online Banking System

A secure web-based Online Banking System built using Java Servlets, JSP, and MySQL.

## 🚀 Features
- ✅ User Registration with auto-generated Account Number
- ✅ Secure Login with SHA-256 Password Hashing
- ✅ 4-Digit Transaction PIN for Deposit, Withdraw and Transfer
- ✅ Real-time Transaction History with Date and Type Filters
- ✅ Change Password Module
- ✅ Admin Panel restricted to Admin only
- ✅ Session Filter protecting all sensitive pages
- ✅ Responsive UI with Bootstrap 5

## 🛠️ Tech Stack
| Layer | Technology |
|---|---|
| Backend | Java Servlets (Jakarta EE) |
| Frontend | JSP + Bootstrap 5 |
| Database | MySQL 8.x |
| Server | Apache Tomcat 11 |
| Security | SHA-256 Hashing + Session Filter |
| IDE | Eclipse |

## 📁 Project Structure
OnlineBankingSystem/
├── src/main/java/
│   ├── com.bank.dao/        → TransactionDAO, UserDAO
│   ├── com.bank.filter/     → SessionFilter
│   ├── com.bank.main/       → All Servlets
│   ├── com.bank.model/      → User, Transaction
│   ├── com.bank.service/    → UserService
│   └── com.bank.util/       → DBConnection, PasswordUtil
└── src/main/webapp/
├── login.jsp
├── register.jsp
├── dashboard.jsp
├── deposit.jsp
├── withdraw.jsp
├── transfer.jsp
├── history.jsp
├── changepassword.jsp
└── admin.jsp

## ⚙️ How to Run Locally
1. Clone this repository
2. Import into Eclipse as Dynamic Web Project
3. Run `bankdb_setup.sql` in MySQL Workbench
4. Update `db.properties` with your MySQL credentials
5. Deploy on Apache Tomcat 11
6. Open `http://localhost:8080/OnlineBankingSystem/`

## 🗄️ Database Setup
```sql
CREATE DATABASE bankdb;
USE bankdb;
-- Run the full bankdb_setup.sql file
```

## 👨‍💻 Developer
**Harsh Shah**
TCET Mumbai — B.Tech AI/ML (2028)
GitHub: [@Harshshah931](https://github.com/Harshshah931)
