-- Database: departmental_sotre_data_2

-- DROP DATABASE departmental_sotre_data_2;

CREATE DATABASE departmental_sotre_data_2
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
	

-- Create table Roles
CREATE TABLE roles (
	role VARCHAR(30) PRIMARY KEY,
	description VARCHAR(100)
);

-- Insert data into roles
INSERT INTO roles (role, description)
VALUES ('Cashier', 'Manages bills and cash'),
('Store Manager', 'Manager of the store'),
('Inventory Controller', 'Controls the inventory'),
('Sales Associate', 'Makes sure sales must go high'),
('Gaurd', 'For security of the store');

SELECT * FROM roles;




-- Create table addresses
CREATE TABLE addresses(
	id SERIAL PRIMARY KEY,
	address_line1 VARCHAR(60) NOT NULL,
	address_line2 VARCHAR(60),
	city VARCHAR(30) NOT NULL,
	state VARCHAR(30) NOT NULL,
	pincode VARCHAR(10) NOT NULL
);

-- Insert data into addresses
INSERT INTO addresses (address_line1, address_line2, city, state, pincode)
VALUES ('140 Werninger Street', null, 'Houston', 'Texas', '77032'),
('1440 Eagle Drive', null, 'Detroit', 'Michigan', '48226'),
('706 Flint Street', 'Near St. Cruiz Church', ' Atlanta', 'Georgia', '30303'),
('3459 Zappia Drive', null, 'Lakeside Park', 'Kentucky', '41017'),
('28 Ross Street', null, 'Belleville', 'Illinois', '62220');

SELECT * FROM addresses;




-- Create table genders
CREATE TABLE genders (
	gender VARCHAR(30) PRIMARY KEY
);

-- Insert data into genders
INSERT INTO genders(gender)
VALUES ('Male'), ('Female');

SELECT * FROM genders;




-- Create table staff
CREATE TABLE staff (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	phone_number CHAR(10) NOT NULL UNIQUE,
	email VARCHAR(30) NOT NULL UNIQUE,
	gender VARCHAR(30) NOT NULL REFERENCES genders(gender),
	address_id INT NOT NULL REFERENCES addresses(id),
	role VARCHAR(30) NOT NULL REFERENCES roles(role),
	salary INT NOT NULL CHECK (salary > 0)
);

SELECT * FROM staff;

-- Insert data into staff
INSERT INTO staff (first_name, last_name, phone_number, email, gender, address_id, role, salary)
VALUES ('Bryant', 'Miller', '9456517812', 'bryant.miller@gmail.com', 'Male',  1, 'Cashier', 25000),
('Chris', 'Badman', '7845912634', 'chris.badman@gmail.com', 'Male',  2, 'Store Manager', 50000),
('Georgie', 'Nguyen', '6578412937', 'georgie.nguyen@gmail.com', 'Female',  3, 'Inventory Controller', 18000),
('Stewart', 'Dittman', '8789456123', 'stewart.dittman@gmail.com', 'Male',  4, 'Sales Associate', 30000),
('Christine', 'Malone', '9247561438', 'christine.malone@gmail.com', 'Female',  5, 'Gaurd', 12000);

SELECT * FROM staff;




-- Create table categories
CREATE TABLE categories(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	short_code VARCHAR(4) NOT NULL UNIQUE
);

SELECT * FROM categories;

-- Insert data into categories
INSERT INTO categories (name, short_code)
VALUES ('Dairy', 'DRY'),
('Cosmetics','COMS'),
('Electronics', 'ECTR'),
('Furniture', 'FRNT'),
('Stationary', 'STNY');

SELECT * FROM categories;




-- Create table products
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	short_code VARCHAR(4) NOT NULL UNIQUE,
	manufacturer VARCHAR(30) NOT NULL,
	quantity INT NOT NULL CHECK (quantity > 0)
);

SELECT * FROM products;

--Insert data into products
INSERT INTO products (name, short_code, manufacturer, quantity)
VALUES ('Milk', 'MLK', 'Amul', 12),
('Eyeliner', 'EYLN', 'Nyka', 2),
('Pen', 'PEN', 'Cello', 50),
('Pencil', 'PNCL', 'Natraj', 15),
('Table', 'TBL', 'My Furniture.com', 4),
('Chair', 'CH', 'Furnitures@99', 10),
('Fan', 'FAN', 'Philips', 3),
('Motor', 'MTR', 'Crompton', 8),
('LED', 'LED', 'Bajaj', 25),
('Marker', 'MKR', 'Reynolds', 45);

SELECT * FROM products;




-- Create table products_categories
CREATE TABLE products_categories(
	product_id INT REFERENCES products(id),
	category_id INT REFERENCES categories(id),
	PRIMARY KEY(product_id, category_id)
);

SELECT * FROM products_categories;

-- Insert data into products_categories
INSERT INTO products_categories (product_id, category_id)
VALUES (1,1), (2,2), (3,5), (4,5), (5,4), (6,4), (7,3), (8,3), (9,3), (10,5);

SELECT * FROM products_categories;




-- Creating table products_price
CREATE TABLE products_price(
	product_id INT NOT NULL REFERENCES products(id),
	cost_price NUMERIC(10,2) NOT NULL CHECK (cost_price > 0),
	selling_price NUMERIC(10,2) NOT NULL CHECK (selling_price > 0),
	date DATE NOT NULL
);

SELECT * FROM products_price;

-- Insert data into products_price
INSERT INTO products_price (product_id, cost_price, selling_price, date)
VALUES (1, 18, 22, '2015-04-01'),
(1, 20, 24, '2020-01-01'),
(2, 100, 120, '2021-01-01'),
(3, 15, 15, '2021-01-01'),
(4, 2, 5, '2010-01-01'),
(5, 5000, 5700, '2021-03-01'),
(6, 1600, 2000, '2021-02-01'),
(7, 700, 950, '2020-12-01'),
(8, 1800, 2000, '2020-09-01'),
(9, 25000, 27000, '2021-02-01'),
(10, 25, 25, '2015-08-01');

SELECT * FROM products_price ORDER BY product_id;




-- Creating table inventory
CREATE TABLE inventory(
	product_id INT PRIMARY KEY REFERENCES products(id),
	quantity INT NOT NULL CHECK (quantity >= 0),
	instock BOOLEAN DEFAULT FALSE
);

SELECT * FROM inventory;

-- Insert data into inventory
INSERT INTO inventory (product_id, quantity, instock)
VALUES (1, 24, TRUE),
(2, 20, FALSE),
(3, 100, TRUE),
(4, 41, TRUE),
(5, 39, TRUE),
(6, 72, TRUE),
(7, 30, FALSE),
(8, 65, TRUE),
(9, 80, TRUE),
(10, 25, TRUE);

SELECT * FROM inventory;




-- Create table suppliers
CREATE TABLE suppliers(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	phone_number CHAR(10) NOT NULL UNIQUE,
	email VARCHAR(30) NOT NULL UNIQUE,
	gender VARCHAR(30) NOT NULL REFERENCES genders(gender),
	address_id INT NOT NULL REFERENCES addresses(id)
);

SELECT * FROM suppliers;

-- Insert data into suppliers
INSERT INTO addresses (address_line1, address_line2, city, state, pincode)
VALUES ('3492 Elmwood Avenue', null, ' Scottsdale', 'Arizona', '85251'),
('4835 Crim Lane', null, 'Medway', 'Ohio', '45341'),
('3637 Clover Drive', null, 'Colorado Springs', 'Colorado', '80903');
SELECT * FROM addresses;


INSERT INTO suppliers (first_name, last_name, phone_number, email, gender, address_id)
VALUES ('Celeste', 'Gilbert', '7475913258', 'celeste.gilbert@amazon.com', 'Male', 6),
('Ross', 'Matthews', '9147539286', 'ross.matthews@flipkart.com', 'Male', 7),
('Nina', 'Wells', '6789451752', 'nina.wells@wallmart.com', 'Female', 8);

SELECT * FROM suppliers;




-- Creating table orders
CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
	supplier_id INT NOT NULL REFERENCES suppliers(id),
	order_date DATE NOT NULL
);

SELECT * FROM orders;

-- Insert data into orders
INSERT INTO orders (supplier_id, order_date)
VALUES (2, '2021-05-13'),
(3, '2020-12-25'),
(1, '2021-01-14'),
(2, '2021-02-04');

SELECT * FROM orders;




-- Creating table order_details
CREATE TABLE order_details(
	order_id INT NOT NULL REFERENCES orders(id),
	product_id INT NOT NULL REFERENCES products(id),
	quantity INT NOT NULL,
	PRIMARY KEY(order_id, product_id)
);

SELECT * FROM order_details;

-- Insert data into order_details
INSERT INTO order_details (order_id, product_id, quantity)
VALUES (1, 10, 3),
(1, 3, 10),
(1, 4, 1),
(2, 5, 1),
(2, 6, 2),
(3, 9, 2),
(3, 1, 30),
(4, 1, 2),
(4, 3, 2),
(4, 8, 1),
(4, 10, 2);

SELECT * FROM order_details;




-- Query Staff
SELECT * FROM staff WHERE first_name = 'Chris';

SELECT * FROM staff WHERE phone_number = '9456517812';

SELECT * FROM staff WHERE first_name = 'Chris' OR phone_number = '9456517812';

SELECT * FROM staff WHERE role = 'Gaurd';




-- Query Product
SELECT * FROM products WHERE name = 'Pen';

SELECT pr.id, pr.name, ct.name FROM products pr
JOIN products_categories pc ON pc.product_id = pr.id
JOIN categories ct ON ct.id = pc.category_id
WHERE ct.name = 'Stationary';

SELECT pr.id, pr.name, ct.name, inv.quantity, inv.instock FROM products pr
JOIN products_categories pc ON pc.product_id = pr.id
JOIN categories ct ON ct.id = pc.category_id
JOIN inventory inv ON inv.product_id = pr.id
WHERE inv.instock = TRUE;

SELECT pr.id, pr.name, ppr.selling_price FROM products pr
JOIN products_price ppr ON ppr.product_id = pr.id
WHERE ppr.date = (SELECT MAX(date) FROM products_price WHERE product_id = ppr.product_id) AND
ppr.selling_price > 100;




-- Number of Products out of stock
SELECT COUNT(product_id) AS total_out_of_stock_products FROM inventory WHERE instock = FALSE;




-- Number of Products within a category
SELECT ct.id, ct.name, ct.short_code, COUNT(pc.product_id) AS number_of_products FROM categories ct
JOIN products_categories pc ON pc.category_id = ct.id
GROUP BY ct.id, ct.name
ORDER BY ct.id;




-- Categories listed in descending with highest number of products
SELECT ct.id, ct.name, ct.short_code, COUNT(pc.product_id) AS number_of_products FROM categories ct
JOIN products_categories pc ON pc.category_id = ct.id
GROUP BY ct.id, ct.name
ORDER BY number_of_products DESC;




-- Query Suppliers
SELECT * FROM suppliers WHERE first_name = 'Ross';

SELECT * FROM suppliers WHERE phone_number = '6789451752';

SELECT * FROM suppliers WHERE email = 'ross.matthews@flipkart.com';

SELECT sp.id, sp.first_name, sp.last_name, sp.phone_number, sp.email,
sp.gender, ad.address_line1, ad.city, ad.state, ad.pincode
FROM suppliers sp 
JOIN addresses ad ON ad.id = sp.address_id
WHERE ad.state = 'Arizona' OR ad.city = 'New York';




-- Query Product Supply
SELECT orders.id , suppliers.first_name, suppliers.last_name, products.name,
products.short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.id
JOIN products ON products.id = order_details.product_id;

SELECT orders.id , suppliers.first_name, suppliers.last_name, products.name,
products.short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.id
JOIN products ON products.id = order_details.product_id
WHERE products.name = 'Pen';

SELECT orders.id , suppliers.first_name, suppliers.last_name, products.name,
products.short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.id
JOIN products ON products.id = order_details.product_id
WHERE suppliers.first_name = 'Ross';

SELECT orders.id , suppliers.first_name, suppliers.last_name, products.name,
products.short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.id
JOIN products ON products.id = order_details.product_id
WHERE products.short_code = 'MKR';

SELECT orders.id , suppliers.first_name, suppliers.last_name, products.name,
products.short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.id
JOIN products ON products.id = order_details.product_id
WHERE orders.order_date > '2021-01-10';

SELECT orders.id , suppliers.first_name, suppliers.last_name, products.name,
products.short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.id
JOIN products ON products.id = order_details.product_id
WHERE orders.order_date < '2021-02-15';

SELECT orders.id , suppliers.first_name, suppliers.last_name, products.name,
products.short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.id
JOIN products ON products.id = order_details.product_id
JOIN inventory ON inventory.product_id = products.id
WHERE order_details.quantity > inventory.quantity;