-------------------(Basic Queries)--------------------
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

-------------------(Garment-Specific Inventory Tables)-------------------

-- Garments/Inventory Items
CREATE TABLE garments (
  item_id VARCHAR(10) PRIMARY KEY, -- e.g., 'INV001' from UI
  designer_id INT NOT NULL,
  type VARCHAR(50) NOT NULL, -- e.g., 'Evening Dress', 'Blazer'
  size VARCHAR(10) NOT NULL,
  color VARCHAR(50) NOT NULL,
  retail_price DECIMAL(10, 2) NOT NULL, -- The original purchase/sale price
  current_status ENUM('In Stock', 'Rental', 'In Cleaning', 'Sold') NOT NULL, -- From UI Dashboard
  item_condition ENUM('Excellent', 'Good', 'Fair', 'Poor') NOT NULL, -- From Inventory Management Table
  total_rental_cycles INT DEFAULT 0, -- From Inventory Management Table
  date_added DATE NOT NULL,
  is_dead_stock BOOLEAN DEFAULT FALSE, -- Based on 'Dead Stock Items' alert
  
  FOREIGN KEY (designer_id) REFERENCES designers(designer_id)
);

-- Designers (to replace or supplement generic 'suppliers')
CREATE TABLE designers (
  designer_id INT AUTO_INCREMENT PRIMARY KEY,
  designer_name VARCHAR(100) UNIQUE NOT NULL
);

-------------------(Rental and Returns Pipeline Tables)-------------------

-- Rental Transactions
CREATE TABLE rentals (
  rental_id VARCHAR(10) PRIMARY KEY, -- e.g., 'RNT001'
  item_id VARCHAR(10) NOT NULL,
  customer_id INT NOT NULL, -- Existing table `customers` is fine
  rental_date DATE NOT NULL,
  expected_return DATE NOT NULL,
  actual_return_date DATE NULL,
  base_rental_fee DECIMAL(10, 2) NOT NULL,
  deposit_held DECIMAL(10, 2) NOT NULL,
  late_fees DECIMAL(10, 2) DEFAULT 0.00,
  damage_fees DECIMAL(10, 2) DEFAULT 0.00,
  is_overdue BOOLEAN DEFAULT FALSE, -- Calculated field, but useful for quick lookups
  rental_status ENUM('Active', 'Returned', 'Overdue') NOT NULL,
  
  FOREIGN KEY (item_id) REFERENCES garments(item_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Returns Pipeline / Restock Predictions (Tracking cleaning/maintenance)
CREATE TABLE returns_pipeline (
  pipeline_id INT AUTO_INCREMENT PRIMARY KEY,
  rental_id VARCHAR(10) UNIQUE NOT NULL,
  item_id VARCHAR(10) NOT NULL,
  cleaning_days INT DEFAULT 2, -- Estimated availability including cleaning (UI shows 2 days)
  estimated_restock_date DATE AS (DATE_ADD(expected_return, INTERVAL cleaning_days DAY)) STORED, -- Computed column
  
  FOREIGN KEY (rental_id) REFERENCES rentals(rental_id),
  FOREIGN KEY (item_id) REFERENCES garments(item_id)
);

-------------------(Initial DML Queries (Data Manipulation Language))-------------------

-- Insert Designers (Based on Inventory Management table)
INSERT INTO designers (designer_name) VALUES
('Chanel'),
('Gucci'),
('Prada'),
('Versace'),
('Dior'),
('Armani')
ON DUPLICATE KEY UPDATE designer_name = designer_name; -- Prevents re-insertion if run multiple times

-- Insert Garments (A selection based on Inventory Management table)
INSERT INTO garments (item_id, designer_id, type, size, color, retail_price, current_status, item_condition, total_rental_cycles, date_added) VALUES
('INV001', (SELECT designer_id FROM designers WHERE designer_name = 'Chanel'), 'Evening Dress', '8', 'Black', 2500.00, 'Rental', 'Good', 3, '2024-09-15'),
('INV002', (SELECT designer_id FROM designers WHERE designer_name = 'Gucci'), 'Cocktail Dress', '6', 'Red', 1800.00, 'Sold', 'Excellent', 0, '2024-10-01'),
('INV003', (SELECT designer_id FROM designers WHERE designer_name = 'Prada'), 'Gown', '10', 'Navy Blue', 3500.00, 'In Cleaning', 'Good', 5, '2024-09-20'),
('INV008', (SELECT designer_id FROM designers WHERE designer_name = 'Gucci'), 'Trousers', '8', 'Black', 1000.00, 'Rental', 'Excellent', 2, '2024-09-25');

-- Insert Customers (Based on Rental Management table)
INSERT INTO customers (customer_name, phone) VALUES
('Sarah Johnson', '+1-555-0101'),
('Emily Davis', '+1-555-0102'),
('Jessica Brown', '+1-555-0103'),
('Amanda Wilson', '+1-555-0104')
ON DUPLICATE KEY UPDATE customer_name = customer_name;

-- Insert Rentals (Based on Rental Management and Returns Pipeline tables)
INSERT INTO rentals (rental_id, item_id, customer_id, rental_date, expected_return, actual_return_date, base_rental_fee, deposit_held, late_fees, rental_status, is_overdue) VALUES
('RNT001', 'INV001', (SELECT customer_id FROM customers WHERE customer_name = 'Sarah Johnson'), '2024-10-20', '2024-10-28', NULL, 250.00, 500.00, 0.00, 'Overdue', TRUE),
('RNT003', 'INV008', (SELECT customer_id FROM customers WHERE customer_name = 'Jessica Brown'), '2024-10-24', '2024-10-30', NULL, 100.00, 200.00, 0.00, 'Overdue', TRUE);

-- Insert into Returns Pipeline for currently rented/overdue items
INSERT INTO returns_pipeline (rental_id, item_id) VALUES
('RNT001', 'INV001'),
('RNT003', 'INV008');

-------------------(Time-Stamping and Locking Queries)-------------------

-- Add audit columns for last update
ALTER TABLE garments
ADD COLUMN last_updated_by INT NULL,
ADD COLUMN last_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD FOREIGN KEY (last_updated_by) REFERENCES users(user_id);

-- Example Trigger: Log status changes
DELIMITER //
CREATE TRIGGER garment_status_log_trigger
AFTER UPDATE ON garments
FOR EACH ROW
BEGIN
    IF OLD.current_status <> NEW.current_status THEN
        INSERT INTO stock_entries (product_id, quantity, entry_type, entered_by)
        VALUES (NEW.item_id, 1, CONCAT('STATUS_CHANGE_TO_', NEW.current_status), NEW.last_updated_by);
    END IF;
END;
//
DELIMITER ;

-------------------(Locking (Transaction Control))-------------------

-- Scenario: Processing a returned item (INV001) that has accumulated late fees
START TRANSACTION;

-- 1. Lock the rental and garment records to prevent other staff from changing them concurrently
SELECT * FROM rentals WHERE rental_id = 'RNT001' FOR UPDATE;
SELECT * FROM garments WHERE item_id = 'INV001' FOR UPDATE;

-- 2. Update the rental record with late fees, damage fees, and return date (Values from Financial Report UI)
UPDATE rentals
SET 
  actual_return_date = '2025-11-03', -- Assuming today is the day we process the return
  late_fees = 110.00,
  damage_fees = 100.00,
  rental_status = 'Returned',
  is_overdue = FALSE
WHERE rental_id = 'RNT001';

-- 3. Update the garment status and rental cycle count
UPDATE garments
SET 
  current_status = 'In Cleaning',
  total_rental_cycles = total_rental_cycles + 1
WHERE item_id = 'INV001';

-- 4. Insert into Returns Pipeline (The item is now tracked for cleaning)
INSERT INTO returns_pipeline (rental_id, item_id)
VALUES ('RNT999', 'INV001'); -- A new entry in the pipeline if it wasn't there or update existing

COMMIT;

-------------------(Warehouse and Location Queries)-------------------

-- Locations/Warehouse
CREATE TABLE item_locations (
  location_id INT AUTO_INCREMENT PRIMARY KEY,
  location_name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Storage Room A', 'Shop Floor Display'
  description TEXT
);

-- Modify Garments Table to include location
ALTER TABLE garments
ADD COLUMN location_id INT NULL,
ADD FOREIGN KEY (location_id) REFERENCES item_locations(location_id);

--------------------(DDL for Location Tracking)---------------
-- Locations/Warehouse
CREATE TABLE item_locations (
  location_id INT AUTO_INCREMENT PRIMARY KEY,
  location_name VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'Storage Room A', 'Shop Floor Display'
  description TEXT
);

-- Modify Garments Table to include location
ALTER TABLE garments
ADD COLUMN location_id INT NULL,
ADD FOREIGN KEY (location_id) REFERENCES item_locations(location_id);

--------------------(DML for Location Tracking)---------------

-- Initial Locations
INSERT INTO item_locations (location_name) VALUES
('In Transit (Rental)'),
('Cleaning/Maintenance Bay'),
('Showroom Display'),
('Back Stock Room');

-- Update garment location based on status
UPDATE garments
SET location_id = (SELECT location_id FROM item_locations WHERE location_name = 'Cleaning/Maintenance Bay')
WHERE current_status = 'In Cleaning';

UPDATE garments
SET location_id = (SELECT location_id FROM item_locations WHERE location_name = 'In Transit (Rental)')
WHERE current_status = 'Rental';

--------------------(DCL Queries (Data Control Language))---------------

-- Create a new user (for demonstration)
CREATE USER 'inventory_staff'@'localhost' IDENTIFIED BY 'securepass';

-- Staff permissions: Full read access, and the ability to update rentals and returns pipeline
GRANT SELECT ON Inventory_Management.* TO 'inventory_staff'@'localhost';
GRANT INSERT, UPDATE ON Inventory_Management.rentals TO 'inventory_staff'@'localhost';
GRANT INSERT, UPDATE ON Inventory_Management.returns_pipeline TO 'inventory_staff'@'localhost';
GRANT UPDATE (current_status) ON Inventory_Management.garments TO 'inventory_staff'@'localhost';

-- Viewer permissions: Read-only access for dashboards and reports
CREATE USER 'report_viewer'@'localhost' IDENTIFIED BY 'viewerpass';
GRANT SELECT ON Inventory_Management.* TO 'report_viewer'@'localhost';

-- Admin permissions: Full control (assuming they have the SUPER privilege or all other privileges)
GRANT ALL PRIVILEGES ON Inventory_Management.* TO 'admin_user'@'localhost' WITH GRANT OPTION;

-- Apply the changes
FLUSH PRIVILEGES;

-- Revoke: Example of removing permission to delete garments (even if they were granted ALL)
REVOKE DELETE ON Inventory_Management.garments FROM 'inventory_staff'@'localhost';
