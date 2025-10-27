CREATE DATABASE Inventory_Management;
USE Inventory_Management;
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE,
  password_hash VARCHAR(255),
  full_name VARCHAR(100),
  role ENUM('admin','staff','viewer'),
  created_at DATETIME DEFAULT NOW()
);

CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(100) UNIQUE,
  description TEXT,
  created_at DATETIME DEFAULT NOW()
);

CREATE TABLE suppliers (
  supplier_id INT AUTO_INCREMENT PRIMARY KEY,
  supplier_name VARCHAR(200),
  contact_name VARCHAR(100),
  phone VARCHAR(50),
  email VARCHAR(100),
  address TEXT,
  created_at DATETIME DEFAULT NOW()
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(200),
  category_id INT,
  supplier_id INT,
  unit_price DECIMAL(10,2),
  quantity_in_stock INT DEFAULT 0,
  created_at DATETIME DEFAULT NOW(),
  FOREIGN KEY (category_id) REFERENCES categories(category_id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(200),
  contact_name VARCHAR(100),
  phone VARCHAR(50),
  email VARCHAR(100),
  address TEXT,
  created_at DATETIME DEFAULT NOW()
);

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  order_date DATETIME DEFAULT NOW(),
  total_amount DECIMAL(12,2),
  status ENUM('pending','shipped','delivered','cancelled'),
  created_by INT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE stock_entries (
  entry_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  quantity INT,
  entry_type ENUM('purchase','return','adjustment'),
  entry_date DATETIME DEFAULT NOW(),
  entered_by INT,
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (entered_by) REFERENCES users(user_id)
);
