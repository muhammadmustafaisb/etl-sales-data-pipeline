-- Create Database (if not exists)
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'sale_db')
BEGIN
    CREATE DATABASE sale_db;
END

-- Use the database
USE sale_db;

-- Drop tables if they exist (in correct order due to foreign key constraints)
IF OBJECT_ID('dbo.Transactions', 'U') IS NOT NULL
    DROP TABLE dbo.Transactions;

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
    DROP TABLE dbo.Customers;

IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
    DROP TABLE dbo.Products;

-- Create Products Table
CREATE TABLE Products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_category VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Create Customers Table
CREATE TABLE Customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(1000) NOT NULL,
    email VARCHAR(500) NOT NULL,
    region VARCHAR(50),
    join_date DATETIME2,
    loyalty_points INT DEFAULT 0
);

-- Create Transactions Table
CREATE TABLE Transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    product_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    discount DECIMAL(5, 2) DEFAULT 0,
    date DATETIME,
    region VARCHAR(50),
    total_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Transactions_Products FOREIGN KEY (product_id) 
        REFERENCES Products(product_id),
    CONSTRAINT FK_Transactions_Customers FOREIGN KEY (customer_id) 
        REFERENCES Customers(customer_id)
);

-- Create Indexes for better query performance
CREATE INDEX IX_Transactions_CustomerID ON Transactions(customer_id);
CREATE INDEX IX_Transactions_ProductID ON Transactions(product_id);
CREATE INDEX IX_Transactions_Date ON Transactions(date);
CREATE INDEX IX_Transactions_Region ON Transactions(region);
CREATE INDEX IX_Customers_Region ON Customers(region);
CREATE INDEX IX_Products_Category ON Products(product_category);

-- Display table structures
EXEC sp_help 'Products';
EXEC sp_help 'Customers';
EXEC sp_help 'Transactions';
