CREATE DATABASE IF NOT EXISTS BankingSystem;
USE BankingSystem;

CREATE TABLE Branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);

INSERT INTO Branches VALUES
(1,'Tirupati Main Branch','Tirupati','Andhra Pradesh'),
(2,'Bangalore City Branch','Bangalore','Karnataka'),
(3,'Chennai Central Branch','Chennai','Tamil Nadu'),
(4,'Mumbai Branch','Mumbai','Maharashtra');


CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    designation VARCHAR(50),
    salary DECIMAL(12,2),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

INSERT INTO Employees VALUES
(1011,'Rajesh Kumar','Branch Manager',85000.00,1),
(1012,'Sunitha Reddy','Cashier',35000.00,1),
(1013,'Karthik Sharma','Loan Officer',60000.00,1),
(1014,'Priya Sharma','Branch Manager',82000.00,2),
(1015,'Arjun Verma','Accountant',50000.00,2),
(1016,'Nandhini Rao','Customer Service Executive',40000.00,2),
(1017,'Arun Kumar','Branch Manager',80000.00,3),
(1018,'Meena Iyer','Cashier',34000.00,3),
(1019,'Suresh Babu','Loan Officer',58000.00,3),
(1110,'Sneha Verma','Branch Manager',87000.00,4),
(1111,'Rahul Das','Accountant',52000.00,4),
(1112,'Kavya Nair','Customer Service Executive',42000.00,4);


CREATE TABLE Account_Types (
    account_type_id INT PRIMARY KEY,
    account_type_name VARCHAR(50)
);

INSERT INTO Account_Types VALUES
(1,'Savings'),
(2,'Current'),
(3,'Salary'),
(4,'Fixed Deposit');


CREATE TABLE Transaction_Types (
    transaction_type_id INT PRIMARY KEY,
    transaction_name VARCHAR(50)
);

INSERT INTO Transaction_Types VALUES
(1,'Deposit'),
(2,'Withdrawal'),
(3,'UPI'),
(4,'NEFT'),
(5,'RTGS'),
(6,'IMPS');


CREATE TABLE Loan_Types (
    loan_type_id INT PRIMARY KEY,
    loan_name VARCHAR(50)
);

INSERT INTO Loan_Types VALUES
(1,'Home Loan'),
(2,'Vehicle Loan'),
(3,'Education Loan'),
(4,'Personal Loan'),
(5,'Gold Loan');


CREATE TABLE Currencies (
    currency_id INT PRIMARY KEY,
    currency_name VARCHAR(50),
    currency_code VARCHAR(10)
);

INSERT INTO Currencies VALUES
(1,'Indian Rupee','INR'),
(2,'US Dollar','USD'),
(3,'Euro','EUR'),
(4,'British Pound','GBP');

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    dob DATE,
    gender VARCHAR(10),
    email VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(200),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

INSERT INTO Customers VALUES
(1,'Hemadri','1995-04-12','Male','rahul@gmail.com','9876543210','Tirupati',1),
(2,'Preetu Reddy','1997-08-20','Female','priya@gmail.com','6076543211','Bangalore',1),
(3,'Arjun Kumar','1994-01-15','Male','arjun@gmail.com','6976543212','Chennai',2),
(4,'Patel','1998-06-10','Female','sneha@gmail.com','6276543213','Hyderabad',2),
(5,'Vikram','1993-09-05','Male','vikram@gmail.com','8676543214','Mumbai',3),
(6,'Anjali Verma','1996-11-22','Female','anjali@gmail.com','7976543215',NULL,NULL),
(7,'Kiran Rao','1995-12-18','Male','kiran@gmail.com','8876543216',NULL,NULL),
(8,'Pooja','1997-07-25','Female','pooja@gmail.com','9976543217',NULL,NULL),
(9,'Ajay Gupta','1992-03-30','Male','ajay@gmail.com','9476543218',NULL,NULL),
(10,'Neha','1998-05-11','Female','neha@gmail.com','9876543219',NULL,NULL),
(11,'Rohit','1994-10-09','Male','rohit@gmail.com','9076543220',NULL,NULL),
(12,'Meera','1996-02-14','Female','meera@gmail.com','8276543221',NULL,NULL),
(13,'Suresh Kumar','1993-07-19','Male','suresh@gmail.com','7876543222',NULL,NULL),
(14,'Kavya Rani','1999-01-27','Female','kavya@gmail.com','9976543223',NULL,NULL),
(15,'Nikhil Reddy','1995-08-16','Male','nikhil@gmail.com','6776543224',NULL,NULL);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type_id INT,
    branch_id INT,
    balance DECIMAL(15,2),
    opening_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (account_type_id) REFERENCES Account_Types(account_type_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

INSERT INTO Accounts VALUES
(101,1,1,1,50000,'2024-01-01'),
(102,2,1,1,75000,'2024-01-02'),
(103,3,2,2,120000,'2024-01-03'),
(104,4,1,2,45000,'2024-01-04'),
(105,5,3,3,98000,'2024-01-05');

CREATE VIEW Customer_Account_Details AS
SELECT
    c.customer_id,
    c.customer_name,
    a.account_id,
    a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id;

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type_id INT,
    amount DECIMAL(15,2),
    transaction_date DATETIME,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (transaction_type_id) REFERENCES Transaction_Types(transaction_type_id)
);

-- 11. Trigger Setup
DELIMITER $$
CREATE TRIGGER trg_deposit
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    UPDATE Accounts
    SET balance = balance + NEW.amount
    WHERE account_id = NEW.account_id;
END $$
DELIMITER ;

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_type_id INT,
    loan_amount DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    loan_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (loan_type_id) REFERENCES Loan_Types(loan_type_id)
);

INSERT INTO Loans VALUES
(1,1,1,2500000,8.5,'2024-01-01'),
(2,2,2,500000,9.0,'2024-02-01'),
(3,3,3,300000,7.5,'2024-03-01'),
(4,4,4,150000,12.0,'2024-04-01'),
(5,5,5,100000,10.5,'2024-05-01');
CREATE TABLE Loan_Payments (
    payment_id INT PRIMARY KEY,
    loan_id INT,
    amount_paid DECIMAL(15,2),
    payment_date DATE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);
INSERT INTO Loan_Payments VALUES
(1,1,25000,'2025-01-01'),
(2,2,10000,'2025-01-15'),
(3,3,5000,'2025-02-01');
USE BankingSystem;

show tables;
SELECT * FROM Customers;

SELECT * FROM Accounts;
SELECT * FROM Customer_Account_Details;
SELECT * FROM Loans;
SELECT * FROM Accounts;
SELECT * FROM Accounts
