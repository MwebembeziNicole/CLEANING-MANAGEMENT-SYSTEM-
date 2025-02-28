-- Active: 1739950240455@@127.0.0.1@3306@cleaningsystem
CREATE DATABASE CLEANING_SYSTEM;

USE CLEANING_SYSTEM;

CREATE TABLE USER (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    useraddress VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email LIKE '%@%'),
    password VARCHAR(255) NOT NULL,
    user_type ENUM('Employee', 'Client') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employeename VARCHAR(50) NOT NULL UNIQUE,
    employee_contact INT 
    employeeaddress VARCHAR(255) NOT NULL,
    user_id INT UNIQUE NOT NULL,  
    job_title VARCHAR(100) NOT NULL,     
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) CHECK (salary > 0),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE Client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,  -- Ensures each client is also a user
    address VARCHAR(255) NOT NULL,
    client_contact VARCHAR(15) NOT NULL UNIQUE CHECK (phone_number REGEXP '^[0-9]+$'),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
    feedback_id INT  NOT NULL,
    FOREIGN KEY (feedback_id) REFERENCES Feedback(feedback_id)
);

