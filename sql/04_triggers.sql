USE IMS_system;

DELIMITER //
CREATE TRIGGER trg_update_inventory_after_movement
AFTER INSERT ON StockMovements
FOR EACH ROW
BEGIN
    IF NEW.movement_type = 'IN' THEN
        UPDATE Inventory
        SET current_stock = current_stock + NEW.quantity
        WHERE product_id = NEW.product_id
        AND warehouse_id = NEW.warehouse_id;
    ELSEIF NEW.movement_type = 'OUT' THEN
        UPDATE Inventory
        SET current_stock = current_stock - NEW.quantity
        WHERE product_id = NEW.product_id
        AND warehouse_id = NEW.warehouse_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_prevent_negative_stock
BEFORE UPDATE ON Inventory
FOR EACH ROW
BEGIN
    IF NEW.current_stock < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock cannot be negative!';
    END IF;
END //
DELIMITER ;