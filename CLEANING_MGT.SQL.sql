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
    employee_contact VARCHAR(15) NOT NULL UNIQUE CHECK (LENGTH(employee_contact) >= 10),
    employee_address VARCHAR(255) NOT NULL, 
    job_title VARCHAR(100) NOT NULL,     
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) CHECK (salary > 0),
    employee_specialization ENUM('Industrial', 'Residential') NOT NULL,
    user_id INT UNIQUE NOT NULL, 
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

DROP TABLE employee;

CREATE TABLE Client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,-- Ensures each client is also a user
    address VARCHAR(255) NOT NULL,
    client_contact VARCHAR(15) NOT NULL UNIQUE CHECK (LENGTH(client_contact) >= 10),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT UNIQUE NOT NULL,  
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON UPDATE CASCADE ON DELETE CASCADE 
    -- feedback_id INT  NOT NULL,
    -- FOREIGN KEY (feedback_id) REFERENCES Feedback(feedback_id)
);
ALTER TABLE Client ADD COLUMN feedback_id INT;
ALTER TABLE Client ADD FOREIGN KEY (feedback_id) REFERENCES Feedback(feedback_id);


CREATE TABLE Cleaning_task (
    task_id INT PRIMARY KEY AUTO_INCREMENT,
    task_name VARCHAR(100) NOT NULL,
    task_date DATE NOT NULL,
    task_status ENUM('Pending', 'In Progress', 'Completed') NOT NULL,
    client_id INT NOT NULL,
    employee_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE Cleaning_task;

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    feedback VARCHAR(255) NOT NULL,
    feedback_date DATE NOT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON UPDATE CASCADE ON DELETE CASCADE
); 

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE SCHEDULES(
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_date DATE NOT NULL,
    schedule_time TIME NOT NULL,
    task_id INT NOT NULL,
    FOREIGN KEY (task_id) REFERENCES Cleaning_task(task_id) ON UPDATE CASCADE ON DELETE CASCADE,
    client_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON UPDATE CASCADE ON DELETE CASCADE,
    employee_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE CASCADE

);

DROP TABLE SCHEDULES;   

CREATE TABLE Invoice (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_date DATE NOT NULL,
    amount INT NOT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON UPDATE CASCADE ON DELETE CASCADE
);




