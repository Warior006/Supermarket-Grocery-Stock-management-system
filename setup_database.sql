-- SQL script to setup the database for the SuperMarket Application
-- You can run this script using SQL Server Management Studio (SSMS) or SQLCMD

-- Drop database if it exists to perform a clean initialization
USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'SuperMarket')
BEGIN
    ALTER DATABASE SuperMarket SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SuperMarket;
END
GO

CREATE DATABASE SuperMarket;
GO

USE SuperMarket;
GO

-- 1. Create ADMIN table
CREATE TABLE ADMIN (
    admin_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- 2. Create CUSTOMER table
CREATE TABLE CUSTOMER (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(255)
);

-- 3. Create BRANDS table
CREATE TABLE BRANDS (
    brand_id INT IDENTITY(1,1) PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
);

-- 4. Create CATEGORIES table
CREATE TABLE CATEGORIES (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

-- 5. Create STOCK table
CREATE TABLE STOCK (
    stock_id INT IDENTITY(1,1) PRIMARY KEY,
    stock_location VARCHAR(255),
    product_id INT NULL,
    quantity INT NULL
);

-- 6. Create PRODUCT table (with foreign keys to ADMIN, CATEGORIES, STOCK, BRANDS)
CREATE TABLE PRODUCT (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price FLOAT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    production_date DATETIME,
    expiry_date DATETIME,
    admin_id INT NULL,
    category_id INT NULL,
    stock_id INT NULL,
    brand_id INT NULL,
    CONSTRAINT FK_PRODUCT_ADMIN FOREIGN KEY (admin_id) REFERENCES ADMIN(admin_id) ON DELETE SET NULL,
    CONSTRAINT FK_PRODUCT_CATEGORIES FOREIGN KEY (category_id) REFERENCES CATEGORIES(category_id) ON DELETE SET NULL,
    CONSTRAINT FK_PRODUCT_STOCK FOREIGN KEY (stock_id) REFERENCES STOCK(stock_id) ON DELETE SET NULL,
    CONSTRAINT FK_PRODUCT_BRANDS FOREIGN KEY (brand_id) REFERENCES BRANDS(brand_id) ON DELETE SET NULL
);

-- 7. Create DISCOUNT_VOUCHER table
CREATE TABLE DISCOUNT_VOUCHER (
    voucher_id INT IDENTITY(1,1) PRIMARY KEY,
    amount_discount FLOAT NOT NULL,
    expiry_date_of_discount DATETIME,
    customer_id INT NULL,
    CONSTRAINT FK_DISCOUNT_VOUCHER_CUSTOMER FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE
);

-- 8. Create ORDERS table
CREATE TABLE ORDERS (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    order_date DATETIME NOT NULL DEFAULT GETDATE(),
    required_date DATETIME,
    shipped_date DATETIME,
    order_status VARCHAR(255),
    customer_id INT NULL,
    CONSTRAINT FK_ORDERS_CUSTOMER FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE
);

-- 9. Create ORDER_ITEMS table
CREATE TABLE ORDER_ITEMS (
    item_id INT NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price FLOAT NOT NULL,
    PRIMARY KEY (item_id, order_id),
    CONSTRAINT FK_ORDER_ITEMS_ORDERS FOREIGN KEY (order_id) REFERENCES ORDERS(order_id) ON DELETE CASCADE,
    CONSTRAINT FK_ORDER_ITEMS_PRODUCT FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE CASCADE
);

-- Seed with a default Admin account
INSERT INTO ADMIN (username, email, password) 
VALUES ('admin', 'admin@supermarket.com', 'admin123');
GO
