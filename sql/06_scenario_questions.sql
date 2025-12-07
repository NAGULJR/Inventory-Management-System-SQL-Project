-- 1. Total stock of a single product
SELECT SUM(current_stock) AS total_stock FROM Inventory WHERE product_id = 5;

-- 2. Products under Electronics category
SELECT p.product_name FROM Products p JOIN Categories c ON p.category_id = c.category_id WHERE c.category_name = 'Electronics';

-- 3. Orders by specific customer
SELECT order_id, order_date, total_amount FROM Orders WHERE customer_id = 10;

-- 4. Total stock per product with category
SELECT p.product_name, c.category_name, SUM(i.current_stock) AS total_stock FROM Products p
JOIN Categories c ON p.category_id = c.category_id JOIN Inventory i USING(product_id)
GROUP BY p.product_name, c.category_name;

-- 5. Products supplied by fast suppliers
SELECT product_name FROM Products WHERE product_id IN (SELECT product_id FROM ProductSuppliers WHERE lead_time_days < 5);

-- 6. Customers who placed at least one order
SELECT customer_name FROM Customers c WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.customer_id = c.customer_id);

-- 7. Products never sold
SELECT product_name FROM Products p WHERE NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id);

-- 8. Cumulative sales by date
SELECT order_date, SUM(total_amount) OVER(ORDER BY order_date) AS running_total FROM Orders;

-- 9. Rank products by revenue
SELECT product_id, SUM(quantity * price_at_order) AS revenue,
RANK() OVER(ORDER BY SUM(quantity * price_at_order) DESC) AS revenue_rank FROM order_items GROUP BY product_id;

-- 10. Previous movement quantity
SELECT movement_id, product_id, quantity,
LAG(quantity) OVER(PARTITION BY product_id ORDER BY movement_date) AS previous_qty FROM StockMovements;

-- 11. Products sold > 500
SELECT product_id, SUM(quantity) AS total_sold FROM order_items GROUP BY product_id HAVING total_sold > 500;

-- 12. Revenue classification
SELECT product_id, CASE WHEN SUM(quantity * price_at_order) > 10000 THEN 'HIGH'
wHEN SUM(quantity * price_at_order) > 5000 THEN 'MEDIUM'
ELSE 'LOW' END AS revenue_category FROM order_items GROUP BY product_id;

-- 13. Top 5 ordered products
SELECT product_id, COUNT(*) AS order_count FROM order_items GROUP BY product_id ORDER BY order_count DESC LIMIT 5;

-- 14. Trigger demo (do not run if real triggers exist)
DELIMITER //
CREATE TRIGGER trg_update_inventory_demo AFTER INSERT ON StockMovements
    FOR EACH ROW
    BEGIN
        IF NEW.movement_type = 'OUT' THEN
        UPDATE Inventory SET current_stock = current_stock - NEW.quantity
        WHERE product_id = NEW.product_id;
        END IF;
    END //
DELIMITER ;

-- 15. Procedure demo
DELIMITER //
CREATE PROCEDURE PROC_PlaceOrder_demo(IN cust INT, IN p_id INT, IN qty INT) BEGIN SELECT 'Demo procedure';
END //
DELIMITER ;

-- 16. Warehouses storing a product
SELECT DISTINCT warehouse_id FROM Inventory WHERE product_id = 12;

-- 17. Total revenue per customer
SELECT customer_id, SUM(total_amount) AS total_spent FROM Orders GROUP BY customer_id;

-- 18. Product with highest revenue
SELECT product_id, SUM(quantity * price_at_order) AS revenue FROM order_items
GROUP BY product_id ORDER BY revenue DESC LIMIT 1;

-- 19. Consecutive stock decreases
SELECT a.movement_id AS prev, b.movement_id AS next FROM StockMovements a
JOIN StockMovements b ON a.product_id = b.product_id AND b.movement_date > a.movement_date WHERE b.movement_type = 'OUT';

-- 20. Customers spent above average
SELECT customer_id, SUM(total_amount) AS spent FROM Orders GROUP BY customer_id
HAVING SUM(total_amount) > (SELECT AVG(total_amount) FROM Orders);

-- 21. Full order details
SELECT o.order_id, c.customer_name, p.product_name, oi.quantity FROM Orders o
JOIN Customers c USING(customer_id) JOIN order_items oi USING(order_id) JOIN Products p USING(product_id);

-- 22. Suppliers even without products
SELECT s.supplier_name, ps.product_id FROM Suppliers s LEFT JOIN ProductSuppliers ps USING(supplier_id);

-- 23. Stock valuation per warehouse
SELECT i.warehouse_id, SUM(i.current_stock * p.cost_price) AS stock_value FROM Inventory i
JOIN Products p USING(product_id) GROUP BY i.warehouse_id;

-- 24. Delete warehouse if empty
DELETE FROM Warehouses WHERE warehouse_id = 10 AND warehouse_id NOT IN (SELECT warehouse_id FROM Inventory);

-- 25. Increase reorder level for fast movers
UPDATE Products p JOIN (SELECT product_id, SUM(quantity) AS sold FROM order_items
GROUP BY product_id) AS x USING(product_id) SET p.reorder_level = p.reorder_level + 10 WHERE x.sold > 1000;

-- 26. Rank suppliers by avg lead time
SELECT supplier_id, AVG(lead_time_days) AS avg_lead,
DENSE_RANK() OVER(ORDER BY AVG(lead_time_days)) AS fast_rank FROM ProductSuppliers GROUP BY supplier_id;

-- 27. Top customer per warehouse
SELECT warehouse_id, customer_id, total_qty FROM ( SELECT i.warehouse_id, o.customer_id, SUM(oi.quantity) AS total_qty,
ROW_NUMBER() OVER(PARTITION BY i.warehouse_id ORDER BY SUM(oi.quantity) DESC) AS rn FROM Inventory i
JOIN order_items oi USING(product_id) JOIN Orders o USING(order_id) GROUP BY warehouse_id, customer_id ) x WHERE rn = 1;

-- 28. Trigger demo prevent negative stock
DELIMITER //
CREATE TRIGGER trg_negative_stock_demo
    BEFORE UPDATE ON Inventory
    FOR EACH ROW
    BEGIN
        IF NEW.current_stock < 0
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock cannot be negative!';
        END IF;
    END //
DELIMITER ;

-- 29. Index example
CREATE INDEX idx_orders_customer_date_demo ON Orders(customer_id, order_date DESC);

-- 30. View demo
CREATE VIEW vw_stock_summary_demo AS SELECT p.product_name, w.warehouse_name, i.current_stock FROM Inventory i
JOIN Products p USING(product_id) JOIN Warehouses w USING(warehouse_id);
