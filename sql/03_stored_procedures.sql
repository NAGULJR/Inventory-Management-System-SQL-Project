USE IMS_system;

DELIMITER //
CREATE PROCEDURE PROC_PlaceOrder(IN cust INT, IN p_id INT, IN qty INT)
BEGIN
    INSERT INTO Orders(customer_id, order_date, order_status)
    VALUES(cust, NOW(), 'Pending');

    SET @oid = LAST_INSERT_ID();

    INSERT INTO order_items(order_id, product_id, quantity, price_at_order)
    SELECT @oid, product_id, qty, selling_price
    FROM Products WHERE product_id = p_id;

    UPDATE Orders
    SET total_amount = (
        SELECT SUM(quantity * price_at_order)
        FROM order_items WHERE order_id = @oid
    )
    WHERE order_id = @oid;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE PROC_AddStock(IN p_id INT, IN w_id INT, IN s_id INT, IN qty INT)
BEGIN
    INSERT INTO StockMovements(product_id, warehouse_id, supplier_id, movement_type, quantity)
    VALUES(p_id, w_id, s_id, 'IN', qty);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE PROC_LowStockItems()
BEGIN
    SELECT p.product_id, p.product_name, p.reorder_level, i.current_stock
    FROM Products p
    JOIN Inventory i ON p.product_id = i.product_id
    WHERE i.current_stock < p.reorder_level;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE PROC_WarehouseSummary(IN wid INT)
BEGIN
    SELECT p.product_name, i.current_stock
    FROM Inventory i
    JOIN Products p ON p.product_id = i.product_id
    WHERE i.warehouse_id = wid;
END //
DELIMITER ;