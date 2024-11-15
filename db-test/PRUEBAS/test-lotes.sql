DROP DATABASE IF EXISTS db_test;
CREATE DATABASE IF NOT EXISTS db_test;
USE db_test;

-- Crear tablas
DROP TABLE IF EXISTS Movimientos;
DROP TABLE IF EXISTS Lotes;
DROP TABLE IF EXISTS Productos;

CREATE TABLE Productos (
    ProductoID INT AUTO_INCREMENT PRIMARY KEY,
    Codigo VARCHAR(20) UNIQUE,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Lotes (
    LoteID INT AUTO_INCREMENT PRIMARY KEY,
    ProductoID INT NOT NULL,
    NumeroLote VARCHAR(20),
    FechaVencimiento DATE,
    Stock INT DEFAULT 0,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Lotes_Productos FOREIGN KEY (ProductoID) 
    REFERENCES Productos(ProductoID)
);

-- Modificar tabla Movimientos
DROP TABLE IF EXISTS Movimientos;
CREATE TABLE Movimientos (
    MovimientoID INT AUTO_INCREMENT PRIMARY KEY,
    ProductoID INT NOT NULL,  -- Agregado ProductoID
    LoteID INT,
    TipoMovimiento CHAR(1), -- 'S'=Salida, 'E'=Entrada
    Cantidad INT,
    FechaMovimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Movimientos_Productos FOREIGN KEY (ProductoID) 
        REFERENCES Productos(ProductoID),
    CONSTRAINT FK_Movimientos_Lotes FOREIGN KEY (LoteID) 
        REFERENCES Lotes(LoteID)
);

-- Modificar procedimiento almacenado
CREATE PROCEDURE sp_DescontarStock(
    IN p_ProductoID INT,
    IN p_Cantidad INT
)
BEGIN
    DECLARE v_CantidadPendiente INT;
    DECLARE v_LoteID INT;
    DECLARE v_StockLote INT;
    DECLARE v_CantidadDescontar INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE lotes_cursor CURSOR FOR
        SELECT LoteID, Stock 
        FROM Lotes 
        WHERE ProductoID = p_ProductoID 
        AND Stock > 0
        ORDER BY FechaCreacion ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    START TRANSACTION;
    
    SET v_CantidadPendiente = p_Cantidad;
    
    OPEN lotes_cursor;
    
    read_loop: LOOP
        FETCH lotes_cursor INTO v_LoteID, v_StockLote;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        IF v_StockLote >= v_CantidadPendiente THEN
            SET v_CantidadDescontar = v_CantidadPendiente;
        ELSE
            SET v_CantidadDescontar = v_StockLote;
        END IF;
        
        UPDATE Lotes 
        SET Stock = Stock - v_CantidadDescontar
        WHERE LoteID = v_LoteID;
        
        INSERT INTO Movimientos (ProductoID, LoteID, TipoMovimiento, Cantidad)
        VALUES (p_ProductoID, v_LoteID, 'S', v_CantidadDescontar);
        
        SET v_CantidadPendiente = v_CantidadPendiente - v_CantidadDescontar;
        
        IF v_CantidadPendiente <= 0 THEN
            LEAVE read_loop;
        END IF;
    END LOOP;
    
    CLOSE lotes_cursor;
    
    IF v_CantidadPendiente > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    ELSE
        COMMIT;
    END IF;
END;


---------------------------------------------------------------------------------------------------

-- Consulta actualizada para ver movimientos
SELECT 
    m.MovimientoID,
    p.ProductoID AS IDProducto,
    p.Codigo AS CodigoProducto,
    p.Nombre AS Producto, 
    l.NumeroLote,
    m.TipoMovimiento,
    m.Cantidad,
    m.FechaMovimiento
FROM Movimientos m
INNER JOIN Productos p ON m.ProductoID = p.ProductoID
INNER JOIN Lotes l ON m.LoteID = l.LoteID
ORDER BY m.MovimientoID;


-- Insertar productos
INSERT INTO Productos (Codigo, Nombre) VALUES
('P001', 'Laptop HP'),
('P002', 'Monitor Dell'),
('P003', 'Teclado Logitech');

-- Insertar lotes
INSERT INTO Lotes (ProductoID, NumeroLote, FechaVencimiento, Stock, FechaCreacion) VALUES
(1, 'L001', '2024-12-31', 100, '2024-01-01 10:00:00'),
(1, 'L002', '2024-12-31', 50, '2024-02-01 10:00:00'),
(2, 'L003', '2024-12-31', 75, '2024-01-15 10:00:00'),
(2, 'L004', '2024-12-31', 25, '2024-02-15 10:00:00'),
(3, 'L005', '2024-12-31', 200, '2024-01-01 10:00:00');

-- Probar el descuento de stock
CALL sp_DescontarStock(1, 101); -- Debería descontar del lote L001 y L002
SELECT * FROM Lotes;
SELECT * FROM Movimientos;
SELECT * FROM Productos;
-- Consultar resultados
SELECT p.Nombre, l.NumeroLote, l.Stock, l.FechaCreacion 
FROM Productos p
INNER JOIN Lotes l ON p.ProductoID = l.ProductoID
ORDER BY p.ProductoID, l.FechaCreacion;

-- Consultar movimientos
SELECT m.MovimientoID, l.NumeroLote, m.TipoMovimiento, m.Cantidad, m.FechaMovimiento
FROM Movimientos m
INNER JOIN Lotes l ON m.LoteID = l.LoteID
ORDER BY m.MovimientoID;
