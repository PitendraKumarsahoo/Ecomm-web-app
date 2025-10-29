# 🛒 Advanced Java E-Commerce Web Application

## 📖 Overview
This project is a dynamic **E-commerce Web Application** developed using **JSP (Java Server Pages)**, **Servlets**, and **MySQL** database.  
It demonstrates the core concepts of **Advanced Java** such as MVC architecture, JDBC connectivity, session handling, and form validation.

The web app allows users to register, log in, browse products, add them to the cart, and place orders — simulating a real-world online shopping platform.

---

## 🚀 Features
- 👤 User Registration & Login System  
- 🛍️ Product Listing and Details Page  
- 🛒 Add to Cart and Checkout Functionality  
- 🧾 Order Summary and History  
- 🗂️ Admin Panel for Product Management (optional)  
- 🔒 Session Management & Input Validation  
- 💾 MySQL Database Connectivity via JDBC  
- 🌐 Deployed on Apache Tomcat Server  

---

## 🏗️ Architecture
This project follows the **Model-View-Controller (MVC)** architecture:
- **Model** → Handles database logic (JDBC and DAO classes)
- **View** → JSP pages (frontend UI)
- **Controller** → Servlets (handles requests and responses)

---

## 🛠️ Tech Stack
| Layer | Technology Used |
|-------|------------------|
| Frontend | HTML, CSS, JSP |
| Backend | Java Servlets |
| Database | MySQL |
| Server | Apache Tomcat |
| IDE | Eclipse / IntelliJ IDEA / NetBeans |
| JDBC Driver | MySQL Connector/J |

---

## ⚙️ Installation & Setup Guide

### 1️⃣ Prerequisites
Before running the project, make sure you have:
- **JDK 8 or above**
- **Apache Tomcat 9 or above**
- **MySQL Server**
- **Eclipse IDE** (or any other Java IDE)

---

### 2️⃣ Database Setup
Open MySQL and create a new database:
```sql
CREATE DATABASE ecomm_db;
USE ecomm_db;

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(100)
);

CREATE TABLE products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  price DECIMAL(10,2),
  description VARCHAR(255)
);

CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  product_id INT,
  quantity INT,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
