Create database IMS_system;
use IMS_system;

create table Categories (
category_id int AUTO_INCREMENT Primary key,
category_name varchar(100) not null,
description varchar(255)
);

create table Suppliers (
 supplier_id int auto_increment Primary key,
 supplier_name varchar(100) not null,
 contact_number varchar(30),
 email varchar(100),
 address varchar(200)
 );

 create table Warehouses (
 warehouse_id int AUTO_INCREMENT Primary key,
 warehouse_name varchar(100) not null,
 location varchar(100)
 );

 create table Customers (
 customer_id int Auto_INCREMENT Primary key,
 customer_name varchar(100) not null,
 phone varchar(20),
 email varchar(100),
 address varchar(200)
 );

 create table Products (
 product_id int AUTO_INCREMENT Primary key,
 product_name varchar(100) not null,
 category_id int,
 cost_price Decimal(10, 2),
 selling_price Decimal(10, 2),
 reorder_level int Default 10,
 Foreign key (category_id) REFERENCES Categories (category_id)
 );

 create table ProductSuppliers (
 ps_id int AUTO_INCREMENT Primary key,
 product_id int,
 supplier_id int,
 lead_time_days int,
 last_price Decimal(10, 2),
 Foreign key (product_id) REFERENCES Products (product_id),
 Foreign key (supplier_id) REFERENCES Suppliers (supplier_id)
 );

 create table Inventory (
 inventory_id INT AUTO_INCREMENT Primary key,
 product_id int,
 warehouse_id int,
 current_stock int DEFAULT 0,
 Foreign key (product_id) REFERENCES Products (product_id),
 Foreign key (warehouse_id) REFERENCES Warehouses (warehouse_id)
 );

 create table Orders (
 order_id int AUTO_INCREMENT Primary key,
 customer_id int,
 order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
 order_status varchar(20) Default 'Pending',
 Foreign key (customer_id) REFERENCES Customers (customer_id)
 );

 create table Order_items (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  price_at_order DECIMAL(10,2),
  Foreign key (order_id) REFERENCES Orders (order_id),
  Foreign key (product_id) REFERENCES Products (product_id)
  );


CREATE TABLE StockMovements (
   movement_id INT AUTO_INCREMENT PRIMARY KEY,
   product_id INT,
   warehouse_id INT,
   supplier_id INT,
   movement_type ENUM('IN','OUT'),
   quantity INT,
   movement_date DATETIME DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (product_id) REFERENCES Products (product_id),
   FOREIGN KEY (warehouse_id) REFERENCES Warehouses (warehouse_id),
   FOREIGN KEY (supplier_id) REFERENCES Suppliers (supplier_id)
);
