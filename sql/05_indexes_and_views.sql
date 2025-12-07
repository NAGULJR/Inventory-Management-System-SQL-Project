USE IMS_system;

CREATE INDEX idx_orders_customer_date ON Orders (customer_id, order_date DESC);
CREATE INDEX idx_inventory_product_warehouse ON Inventory (product_id, warehouse_id);
CREATE INDEX idx_orderitems_product_order ON order_items(product_id, order_id);
CREATE INDEX idx_stockmovements_prod_date ON StockMovements(product_id, movement_date);
CREATE INDEX idx_productsupplier_product ON ProductSuppliers(product_id);
CREATE INDEX idx_products_category ON Products(category_id);

CREATE VIEW vw_stock_summary AS
SELECT
    p.product_name,
    w.warehouse_name,
    i.current_stock
FROM Inventory i
JOIN Products p USING(product_id)
JOIN Warehouses w USING(warehouse_id);

CREATE VIEW vw_product_sales AS
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.quantity * oi.price_at_order) AS revenue
FROM Products p
LEFT JOIN order_items oi USING(product_id)
GROUP BY p.product_id, p.product_name;

CREATE VIEW vw_order_details AS
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    p.product_name,
    oi.quantity,
    oi.price_at_order
FROM Orders o
JOIN Customers c USING(customer_id)
JOIN order_items oi USING(order_id)
JOIN Products p USING(product_id);

CREATE VIEW vw_low_stock_alert AS
SELECT
    p.product_name,
    i.current_stock,
    p.reorder_level
FROM Inventory i
JOIN Products p USING(product_id)
WHERE i.current_stock < p.reorder_level;