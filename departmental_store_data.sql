-- Database: departmental_store_data

-- DROP DATABASE departmental_store_data;

CREATE DATABASE departmental_store_data
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;




-- Creating table staff
CREATE TABLE staff(
	staff_id SERIAL PRIMARY KEY,
	staff_name VARCHAR(30) NOT NULL,
	staff_phone_number BIGINT NOT NULL UNIQUE CHECK(staff_phone_number > 999999999 ),
	staff_role VARCHAR(20) NOT NULL
);

SELECT * FROM staff;

-- Insert data into staff
INSERT INTO staff (staff_name, staff_phone_number, staff_role)
VALUES ('David', 9456517812, 'Cashier'),
('Charles', 7845912634, 'Store Manager'),
('Thomas', 6578412937, 'Inventory Controller'),
('Arthur', 8789456123, 'Sales Associate'),
('Jamie', 9247561438, 'Gaurd');

SELECT * FROM staff;




-- Creating table categories

CREATE TABLE categories(
	category_id SERIAL PRIMARY KEY,
	category_name VARCHAR(30) NOT NULL,
	category_short_code VARCHAR(4) NOT NULL UNIQUE
);

SELECT * FROM categories;

-- Insert data into categories
INSERT INTO categories (category_name, category_short_code)
VALUES ('Dairy', 'DRY'),
('Cosmetics','COMS'),
('Electronics', 'ECTR'),
('Furniture', 'FRNT'),
('Stationary', 'STNY');

SELECT * FROM categories;




-- Creating table products

CREATE TABLE products(
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(30) NOT NULL,
	product_short_code VARCHAR(4) NOT NULL UNIQUE,
	product_manufacturer VARCHAR(30) NOT NULL,
	category_id INT NOT NULL REFERENCES categories(category_id)
);

SELECT * FROM products;

--Insert data into products
INSERT INTO products (product_name, product_short_code, product_manufacturer, category_id)
VALUES ('Milk', 'MLK', 'Amul', 1),
('Eyeliner', 'EYLN', 'Nyka', 2),
('Pen', 'PEN', 'Cello', 5),
('Pencil', 'PNCL', 'Natraj', 5),
('Table', 'TBL', 'My Furniture.com', 4),
('Chair', 'CH', 'Furnitures@99', 4),
('Fan', 'FAN', 'Philips', 3),
('Motor', 'MTR', 'Crompton', 3),
('LED', 'LED', 'Bajaj', 3),
('Marker', 'MKR', 'Reynolds', 5);

SELECT * FROM products;




-- Creating table products_price
CREATE TABLE products_price(
	product_id INT NOT NULL REFERENCES products(product_id),
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
	product_id INT PRIMARY KEY REFERENCES products(product_id),
	quantity INT NOT NULL CHECK (quantity >= 0),
	instock BOOLEAN DEFAULT FALSE
);

SELECT * FROM inventory;

-- Insert data into inventory
INSERT INTO inventory (product_id, quantity, instock)
VALUES (1, 12, TRUE),
(2, 0, FALSE),
(3, 30, TRUE),
(4, 10, TRUE),
(5, 1, TRUE),
(6, 2, TRUE),
(7, 0, FALSE),
(8, 5, TRUE),
(9, 8, TRUE),
(10, 25, TRUE);

SELECT * FROM inventory;




-- Creating table suppliers

CREATE TABLE suppliers(
	supplier_id SERIAL PRIMARY KEY,
	supplier_name VARCHAR(30) NOT NULL,
	supplier_phone_number BIGINT NOT NULL UNIQUE CHECK(supplier_phone_number > 999999999 ),
	supplier_email VARCHAR(30) NOT NULL UNIQUE,
	supplier_city VARCHAR(20)
);

SELECT * FROM suppliers;

-- Insert data into suppliers
INSERT INTO suppliers (supplier_name, supplier_phone_number, supplier_email, supplier_city)
VALUES ('Amazon', 7475913258, 'supply@amazon.com', 'Arizona'),
('Flipkart', 9147539286, 'supply@flipkart.com', 'California'),
('Wallmart', 6789451752, 'supply@wallmart.com', 'New York');

SELECT * FROM suppliers;




-- Creating table orders
CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	supplier_id INT NOT NULL REFERENCES suppliers(supplier_id),
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
	order_id INT NOT NULL REFERENCES orders(order_id),
	product_id INT NOT NULL REFERENCES products(product_id),
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
(3, 1, 1),
(4, 1, 2),
(4, 3, 2),
(4, 8, 1),
(4, 10, 2);

SELECT * FROM order_details;




-- Query Staff
SELECT * FROM staff WHERE staff_name = 'Charles';

SELECT * FROM staff WHERE staff_phone_number = 9456517812;

SELECT * FROM staff WHERE staff_name = 'Charles' OR staff_phone_number = 9456517812;

SELECT * FROM staff WHERE staff_role = 'Gaurd';




-- Query Product
SELECT * FROM products WHERE product_name = 'Pen';

SELECT pr.product_id, pr.product_name, ct.category_name FROM products pr
JOIN categories ct ON ct.category_id = pr.category_id
WHERE ct.category_name = 'Stationary';

SELECT pr.product_id, pr.product_name, ct.category_name, inv.quantity, inv.instock FROM products pr
JOIN categories ct ON ct.category_id = pr.category_id
JOIN inventory inv ON inv.product_id = pr.product_id
WHERE inv.instock = TRUE;

SELECT pr.product_id, pr.product_name, ppr.selling_price FROM products pr
JOIN products_price ppr ON ppr.product_id = pr.product_id
WHERE ppr.date = (SELECT MAX(date) FROM products_price WHERE product_id = ppr.product_id) AND
ppr.selling_price > 100;




-- Number of Products out of stock
SELECT COUNT(product_id) AS total_out_of_stock_products FROM inventory WHERE instock = FALSE;




-- Number of Products within a category
SELECT ct.category_id, ct.category_name, ct.category_short_code, COUNT(pr.product_id) AS number_of_products FROM categories ct
JOIN products pr ON pr.category_id = ct.category_id
WHERE pr.product_id IN (SELECT product_id FROM products WHERE category_id = ct.category_id)
GROUP BY ct.category_id, ct.category_name
ORDER BY ct.category_id;




-- Categories listed in descending with highest number of products
SELECT ct.category_id, ct.category_name, ct.category_short_code, COUNT(pr.product_id) AS number_of_products FROM categories ct
JOIN products pr ON pr.category_id = ct.category_id
WHERE pr.product_id IN (SELECT product_id FROM products WHERE category_id = ct.category_id)
GROUP BY ct.category_id, ct.category_name
ORDER BY number_of_products DESC;




-- Query Suppliers
SELECT * FROM suppliers WHERE supplier_name = 'Amazon';

SELECT * FROM suppliers WHERE supplier_phone_number = 6789451752;

SELECT * FROM suppliers WHERE supplier_email = 'supply@flipkart.com';

SELECT * FROM suppliers WHERE supplier_city = 'Arizona' OR supplier_city = 'New York';




-- Query Product Supply
SELECT orders.order_id , suppliers.supplier_name, products.product_name,
products.product_short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.supplier_id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.order_id
JOIN products ON products.product_id = order_details.product_id;

SELECT orders.order_id , suppliers.supplier_name, products.product_name,
products.product_short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.supplier_id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.order_id
JOIN products ON products.product_id = order_details.product_id
WHERE products.product_name = 'Pen';

SELECT orders.order_id , suppliers.supplier_name, products.product_name,
products.product_short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.supplier_id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.order_id
JOIN products ON products.product_id = order_details.product_id
WHERE suppliers.supplier_name = 'Flipkart';

SELECT orders.order_id , suppliers.supplier_name, products.product_name,
products.product_short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.supplier_id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.order_id
JOIN products ON products.product_id = order_details.product_id
WHERE products.product_short_code = 'MKR';

SELECT orders.order_id , suppliers.supplier_name, products.product_name,
products.product_short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.supplier_id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.order_id
JOIN products ON products.product_id = order_details.product_id
WHERE orders.order_date > '2021-01-10';

SELECT orders.order_id , suppliers.supplier_name, products.product_name,
products.product_short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.supplier_id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.order_id
JOIN products ON products.product_id = order_details.product_id
WHERE orders.order_date < '2021-02-15';

SELECT orders.order_id , suppliers.supplier_name, products.product_name,
products.product_short_code, order_details.quantity, orders.order_date FROM orders
JOIN suppliers ON  suppliers.supplier_id = orders.supplier_id
JOIN order_details ON order_details.order_id = orders.order_id
JOIN products ON products.product_id = order_details.product_id
JOIN inventory ON inventory.product_id = products.product_id
WHERE order_details.quantity > inventory.quantity;
