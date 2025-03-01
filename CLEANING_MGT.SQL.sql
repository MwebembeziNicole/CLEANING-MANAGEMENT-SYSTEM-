-- Active: 1739950240455@@127.0.0.1@3306@cleaningsystem
CREATE DATABASE CLEANING_SYSTEM;

USE CLEANING_SYSTEM;


CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email LIKE '%@%'),
    password VARCHAR(255) NOT NULL,
    user_role ENUM('Admin', 'Employee', 'Client') NOT NULL
);
CREATE TABLE employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employeename VARCHAR(50) NOT NULL UNIQUE,
    employee_contact VARCHAR(15) NOT NULL UNIQUE CHECK (LENGTH(employee_contact) >= 10),
    employee_address VARCHAR(255) NOT NULL,     
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) CHECK (salary > 0),
    employee_specialization ENUM('Industrial', 'Residential') NOT NULL

);

ALTER TABLE Employee ADD COLUMN user_id INT UNIQUE, 
ADD CONSTRAINT fk_employee_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE;
ALTER TABLE employee
MODIFY COLUMN salary INT NOT NULL;
ALTER TABLE employee DROP COLUMN job_title;
ALTER TABLE employee ADD COLUMN employee_availability ENUM('Available', 'Not Available') NOT NULL;



CREATE TABLE Client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,-- Ensures each client is also a user
    address VARCHAR(255) NOT NULL,
    client_contact VARCHAR(15) NOT NULL UNIQUE CHECK (LENGTH(client_contact) >= 10),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE Client ADD COLUMN user_id INT UNIQUE, 
ADD CONSTRAINT fk_client_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE;
ALTER TABLE Client ADD COLUMN Client_name VARCHAR(50) NOT NULL;


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
    amount DECIMAL(10,2) NOT NULL

);

ALTER TABLE Payments
MODIFY COLUMN amount INT;
ALTER TABLE Payments ADD COLUMN payment_method ENUM('Cash','Credit Card','Momopay','Bank Transfer') NOT NULL;
-- Foreign key invoice id
ALTER TABLE Payments
ADD COLUMN invoice_id INT NOT NULL, 
ADD CONSTRAINT fk_payment_invoice FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id) ON DELETE CASCADE;


CREATE TABLE SCHEDULES(
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    schedule_date DATE NOT NULL,
    schedule_time TIME NOT NULL,
    task_id INT NOT NULL,
    FOREIGN KEY (task_id) REFERENCES Cleaning_task(task_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Invoice (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_date DATE NOT NULL,
    amount INT NOT NULL
);

ALTER TABLE Invoice 
ADD COLUMN task_id INT NOT NULL, 
ADD CONSTRAINT fk_invoice_task FOREIGN KEY (task_id) REFERENCES Cleaning_task(task_id) ON DELETE CASCADE;


INSERT INTO User (username, email, password, user_role) VALUES 
('johndoe', 'johndoe@example.com', 'hashedpassword1', 'Employee'),
('janesmith', 'janesmith@example.com', 'hashedpassword2', 'Employee'),
('alicejohnson', 'alicejohnson@example.com', 'hashedpassword3', 'Employee'),
('robertbrown', 'robertbrown@example.com', 'hashedpassword4', 'Employee'),
('emilydavis', 'emilydavis@example.com', 'hashedpassword5', 'Employee');

--Then, link the user_id to the corresponding employee:
--Links employees to their user accounts.--
UPDATE Employee SET user_id = (SELECT user_id FROM User WHERE username = 'johndoe') WHERE employeename = 'John Doe';
UPDATE Employee SET user_id = (SELECT user_id FROM User WHERE username = 'janesmith') WHERE employeename = 'Jane Smith';
UPDATE Employee SET user_id = (SELECT user_id FROM User WHERE username = 'alicejohnson') WHERE employeename = 'Alice Johnson';
UPDATE Employee SET user_id = (SELECT user_id FROM User WHERE username = 'robertbrown') WHERE employeename = 'Robert Brown';
UPDATE Employee SET user_id = (SELECT user_id FROM User WHERE username = 'emilydavis') WHERE employeename = 'Emily Davis';

INSERT INTO employee (employeename, employee_contact, employee_address, hire_date, salary, employee_specialization, employee_availability)
VALUES 
('John Doe', '1234567890', '123 Main St', '2023-01-15', 4500.00, 'Industrial', 'Available'),
('Jane Smith', '0987654321', '456 Elm St', '2022-05-22', 5000.00, 'Residential', 'Not Available'),
('Alice Johnson', '1122334455', '789 Oak St', '2023-03-10', 4700.00, 'Industrial', 'Available'),
('Robert Brown', '6677889900', '159 Pine St', '2022-11-05', 5200.00, 'Residential', 'Available'),
('Emily Davis', '5544332211', '753 Maple St', '2021-09-25', 4800.00, 'Industrial', 'Not Available');




INSERT INTO Client (client_name, address, client_contact)
VALUES 
('Michael Green', '12 Sunset Blvd', '1029384756'),
('Sarah White', '34 River Rd', '5647382910'),
('David Black', '56 Hilltop Ave', '8473629150'),
('Emma Wilson', '78 Mountain St', '1203948576'),
('James Brown', '90 Beach Dr', '6758493021');

--Insert Users Matching Clients
INSERT INTO User (username, email, password, user_role) VALUES 
('michaelgreen', 'michaelgreen@example.com', 'hashedpassword6', 'Client'),
('sarahwhite', 'sarahwhite@example.com', 'hashedpassword7', 'Client'),
('davidblack', 'davidblack@example.com', 'hashedpassword8', 'Client'),
('emmawilson', 'emmawilson@example.com', 'hashedpassword9', 'Client'),
('jamesbrown', 'jamesbrown@example.com', 'hashedpassword10', 'Client');

--Now, we create user accounts for clients--
--Then, link the user_id to the corresponding client--
--Links clients to their user accounts--
UPDATE Client SET user_id = (SELECT user_id FROM User WHERE username = 'michaelgreen') WHERE client_name = 'Michael Green';
UPDATE Client SET user_id = (SELECT user_id FROM User WHERE username = 'sarahwhite') WHERE client_name = 'Sarah White';
UPDATE Client SET user_id = (SELECT user_id FROM User WHERE username = 'davidblack') WHERE client_name = 'David Black';
UPDATE Client SET user_id = (SELECT user_id FROM User WHERE username = 'emmawilson') WHERE client_name = 'Emma Wilson';
UPDATE Client SET user_id = (SELECT user_id FROM User WHERE username = 'jamesbrown') WHERE client_name = 'James Brown';



INSERT INTO Feedback (feedbacK, feedback_date, client_id)
VALUES 
('Excellent service!', '2024-02-15', 1),
('Very professional staff.', '2024-02-16', 2),
('Cleaning was okay, but can be improved.', '2024-02-17', 3),
('Loved the work, highly recommended!', '2024-02-18', 4),
('Not satisfied, arrived late.', '2024-02-19', 5);

INSERT INTO Cleaning_task (task_name, task_date, task_status, client_id, employee_id)
VALUES 
('Office Cleaning', '2024-03-01', 'Pending', 1, 1),
('House Cleaning', '2024-03-02', 'In Progress', 2, 2),
('Apartment Deep Cleaning', '2024-03-03', 'Completed', 3, 3),
('Carpet Cleaning', '2024-03-04', 'Pending', 4, 4),
('Window Washing', '2024-03-05', 'In Progress', 5, 5);

INSERT INTO Invoice (invoice_date, amount, task_id)
VALUES 
('2024-03-06', 150.00, 1),
('2024-03-07', 200.00, 2),
('2024-03-08', 180.00, 3),
('2024-03-09', 220.00, 4),
('2024-03-10', 250.00, 5);

INSERT INTO Payments (payment_method, payment_date, amount, invoice_id)
VALUES 
('Credit Card', '2024-03-11', 150.00, 1),
('Cash', '2024-03-12', 200.00, 2),
('Momopay', '2024-03-13', 180.00, 3),
('Bank Transfer', '2024-03-14', 220.00, 4),
('Credit Card', '2024-03-15', 250.00, 5);



----------------------SCHEDULES---------------------
--Recurring Cleaning Services--
--The database is missing a way to schedule recurring tasks for regular clients.--
--Solution:Modify Schedules to include recurrence this allows automatic scheduling of regular cleaning services.--
ALTER TABLE Schedules 
ADD COLUMN recurrence ENUM('None', 'Weekly', 'Bi-Weekly', 'Monthly') DEFAULT 'None';

INSERT INTO Schedules (schedule_date, schedule_time, task_id)
VALUES 
('2024-03-16', '09:00:00', 1),
('2024-03-17', '10:30:00', 2),
('2024-03-18', '14:00:00', 3),
('2024-03-19', '16:00:00', 4),
('2024-03-20', '08:30:00', 5);

----------------------VIEWS---------------------


-- View: View_1Client_Tasks
-- Description: Displays all tasks assigned to clients, including task name, date, and status.
CREATE VIEW View_1Client_Tasks AS
SELECT c.client_id, c.client_name, ct.task_id, ct.task_name, ct.task_date, ct.task_status
FROM Client c
JOIN Cleaning_task ct ON c.client_id = ct.client_id;


-- View: View_Employee_Assigned_Tasks
-- Description: Provides a summary of employees and the tasks they are assigned to.
CREATE VIEW View2_Employee_Assigned_Tasks AS
SELECT e.employee_id, e.employeename, ct.task_id, ct.task_name, ct.task_date, ct.task_status
FROM Employee e
JOIN Cleaning_task ct ON e.employee_id = ct.employee_id;

-- View: View_Pending_Tasks
-- Description: Retrieves all tasks that have a status of 'Pending'.
CREATE VIEW View_Pending_Tasks AS
SELECT task_id, task_name, task_date, client_id, employee_id
FROM Cleaning_task
WHERE task_status = 'Pending';

-- View: View_Completed_Tasks
-- Description: Retrieves all tasks that have been marked as 'Completed'.
CREATE VIEW View4_Completed_Tasks AS
SELECT task_id, task_name, task_date, client_id, employee_id
FROM Cleaning_task
WHERE task_status = 'Completed';

-- View: View_Client_Feedback
-- Description: Shows client feedback along with the client’s name.
CREATE VIEW View_Client_Feedback AS
SELECT f.feedback_id, c.client_name, f.feedback, f.feedback_date
FROM Feedback f
JOIN Client c ON f.client_id = c.client_id;


-- View: View_Payment_History
-- Description: Lists all payments made for invoices, including payment method and amount.
CREATE VIEW View_Payment_History AS
SELECT p.payment_id, p.payment_method, p.payment_date, p.amount, i.invoice_id, i.invoice_date, i.task_id
FROM Payments p
JOIN Invoice i ON p.invoice_id = i.invoice_id;

Select * FROM View_Payment_History;

-- View: View_Schedule_Summary
-- Description: Displays scheduled cleaning tasks, including client and employee details.
CREATE VIEW View_Schedule_Summary AS
SELECT s.schedule_id, s.schedule_date, s.schedule_time, c.client_name, ct.task_name, e.employeename
FROM Schedules s
JOIN Cleaning_task ct ON s.task_id = ct.task_id
JOIN Client c ON ct.client_id = c.client_id
JOIN Employee e ON ct.employee_id = e.employee_id;

Select * FROM View_Schedule_Summary;

-- View: View_Employee_Specialization
-- Description: Categorizes employees based on their specialization in 'Industrial' or 'Residential'.
CREATE VIEW View_Employee_Specialization AS
SELECT 
    employee_id, 
    employeename, 
    employee_contact, 
    employee_specialization
FROM Employee;

Select * FROM View_Employee_Specialization;

-- View: View_Client_Tasks
-- Description: Shows all tasks assigned to clients.
CREATE VIEW View_Client_Tasks AS
SELECT c.client_id, c.client_name, ct.task_id, ct.task_name, ct.task_date, ct.task_status
FROM Client c
JOIN Cleaning_task ct ON c.client_id = ct.client_id;



--------------JOINS---------------


-- View: View_NaturalJoin_Employee_Tasks
-- Join:Explicit INNER join to join Cleaning_task and employee using employee_id
-- Description: Retrieves employees and their assigned tasks.

CREATE VIEW View_NaturalJoin_Employee_Tasks AS
SELECT e.employee_id, e.employeename, ct.task_id, ct.task_name, ct.task_status
FROM Employee e
INNER JOIN Cleaning_task ct ON e.employee_id = ct.employee_id;
SELECT * FROM View_NaturalJoin_Employee_Tasks;



-- View: View_LeftJoin_Employee_Tasks
-- Description: Lists all employees, including those without assigned tasks.

CREATE VIEW View_LeftJoin_Employee_Tasks AS
SELECT e.employee_id, e.employeename, ct.task_id, ct.task_name, ct.task_status
FROM Employee e
LEFT JOIN Cleaning_task ct ON e.employee_id = ct.employee_id;

-- View: View_RightJoin_Employee_Tasks
-- Description: Lists all tasks, including those not assigned to an employee.
CREATE VIEW View_RightJoin_Employee_Tasks AS
SELECT e.employee_id, e.employeename, ct.task_id, ct.task_name, ct.task_status
FROM Employee e
RIGHT JOIN Cleaning_task ct ON e.employee_id = ct.employee_id;

-- View: View_FullJoin_Employee_Tasks
-- Description: Lists all employees and all tasks, ensuring no missing data.
CREATE VIEW View_FullJoin_Employee_Tasks AS
SELECT e.employee_id, e.employeename, ct.task_id, ct.task_name, ct.task_status
FROM Employee e
LEFT JOIN Cleaning_task ct ON e.employee_id = ct.employee_id
UNION
SELECT e.employee_id, e.employeename, ct.task_id, ct.task_name, ct.task_status
FROM Employee e
RIGHT JOIN Cleaning_task ct ON e.employee_id = ct.employee_id;

Select * FROM View_FullJoin_Employee_Tasks;


------QN.5-------
--1.Using case in select statements.--
--Example 1:Categorizing employees based on salary--
SELECT 
    employee_id, 
    employeename, 
    salary,
    CASE 
        WHEN salary > 5000 THEN 'High'
        WHEN salary BETWEEN 4000 AND 5000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM employee;
--Example2:Showing task completion status.--
SELECT 
    task_id, 
    task_name, 
    task_status,
    CASE 
        WHEN task_status = 'Completed' THEN '✔ Done'
        WHEN task_status = 'Pending' THEN '❌ Pending'
        ELSE '🕒 In Progress'
    END AS status_display
FROM Cleaning_task;

--2.Using case in UPDATE statements.--
--Example 1: Updating Employee Availability Based on Salary--
UPDATE Employee
SET employee_availability = 
    CASE 
        WHEN salary >= 5000 THEN 'Available'
        ELSE 'Not Available'
    END;

--Example 2: Marking Overdue Tasks as "Pending"--
UPDATE Cleaning_task
SET task_status = 
    CASE 
        WHEN task_date < CURDATE() THEN 'Pending'
        ELSE task_status
    END;

-- Using CASE in DELETE Statements--
--Example 1: Delete Employees with a Salary Below 4000--
DELETE FROM Employee
WHERE 
    CASE 
        WHEN salary < 4000 THEN TRUE
        ELSE FALSE
    END;

-- Example 2: Remove Clients Who Haven’t Registered for Over 2 Years--
DELETE FROM Client
WHERE 
    CASE 
        WHEN registered_at < DATE_SUB(CURDATE(), INTERVAL 2 YEAR) THEN TRUE
        ELSE FALSE
    END;


