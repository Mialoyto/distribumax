
-- Crear base de datos
DROP DATABASE IF EXISTS db_inventario;
CREATE DATABASE IF NOT EXISTS db_inventario;
USE db_inventario;

-- Limpiar tablas si existen
DROP TABLE IF EXISTS Movimientos;
DROP TABLE IF EXISTS Lotes;
DROP TABLE IF EXISTS Productos;

-- Tabla de Productos
CREATE TABLE Productos (
    ProductoID INT AUTO_INCREMENT PRIMARY KEY,
    Codigo VARCHAR(20) UNIQUE,           -- Código único del producto
    Nombre VARCHAR(100) NOT NULL,        -- Nombre descriptivo
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Lotes 
CREATE TABLE Lotes (
    LoteID INT AUTO_INCREMENT PRIMARY KEY,
    ProductoID INT NOT NULL,
    NumeroLote VARCHAR(20),              -- Identificador del lote
    FechaVencimiento DATE,               -- Fecha de caducidad
    Stock INT DEFAULT 0,                 -- Stock actual del lote
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);

-- Tabla de Kardex (Movimientos)
CREATE TABLE Movimientos (
    MovimientoID INT AUTO_INCREMENT PRIMARY KEY,
    ProductoID INT NOT NULL,
    LoteID INT,
    TipoMovimiento CHAR(1),             -- 'E'=Entrada, 'S'=Salida
    Cantidad INT,                        -- Cantidad del movimiento
    StockAnterior INT,                  -- Stock antes del movimiento
    StockResultante INT,                -- Stock después del movimiento
    Observacion VARCHAR(200),           -- Notas adicionales
    FechaMovimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    FOREIGN KEY (LoteID) REFERENCES Lotes(LoteID)
);

-- Procedimiento para registrar entradas de stock
DELIMITER //
CREATE PROCEDURE sp_RegistrarEntrada(
    IN p_ProductoID INT,
    IN p_NumeroLote VARCHAR(20),
    IN p_FechaVencimiento DATE,
    IN p_Cantidad INT,
    IN p_Observacion VARCHAR(200)
)
BEGIN
    DECLARE v_LoteID INT;
    DECLARE v_StockAnterior INT;
    
    START TRANSACTION;
    
    -- Crear nuevo lote
    INSERT INTO Lotes (ProductoID, NumeroLote, FechaVencimiento, Stock)
    VALUES (p_ProductoID, p_NumeroLote, p_FechaVencimiento, p_Cantidad);
    
    SET v_LoteID = LAST_INSERT_ID();
    
    -- Obtener stock anterior total del producto
    SELECT COALESCE(SUM(Stock), 0) INTO v_StockAnterior
    FROM Lotes WHERE ProductoID = p_ProductoID;
    
    -- Registrar movimiento
    INSERT INTO Movimientos (
        ProductoID, LoteID, TipoMovimiento, Cantidad, 
        StockAnterior, StockResultante, Observacion
    )
    VALUES (
        p_ProductoID, v_LoteID, 'E', p_Cantidad,
        v_StockAnterior, v_StockAnterior + p_Cantidad, p_Observacion
    );
    
    COMMIT;
END;
DELIMITER ;

-- Procedimiento para descontar stock (salidas)
DELIMITER //
CREATE PROCEDURE sp_DescontarStock(
    IN p_ProductoID INT,
    IN p_Cantidad INT,
    IN p_Observacion VARCHAR(200)
)
BEGIN
    DECLARE v_CantidadPendiente INT;
    DECLARE v_LoteID INT;
    DECLARE v_StockLote INT;
    DECLARE v_CantidadDescontar INT;
    DECLARE v_StockAnterior INT;
    DECLARE v_StockResultante INT;
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE lotes_cursor CURSOR FOR
        SELECT LoteID, Stock 
        FROM Lotes 
        WHERE ProductoID = p_ProductoID 
        AND Stock > 0
        ORDER BY FechaVencimiento ASC, FechaCreacion ASC; -- FEFO (First Expired, First Out)
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    START TRANSACTION;
    
    SET v_CantidadPendiente = p_Cantidad;
    
    -- Obtener stock total actual
    SELECT COALESCE(SUM(Stock), 0) INTO v_StockAnterior
    FROM Lotes WHERE ProductoID = p_ProductoID;
    
    -- Verificar stock suficiente
    IF v_StockAnterior < p_Cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
    
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
        
        -- Actualizar stock del lote
        UPDATE Lotes 
        SET Stock = Stock - v_CantidadDescontar
        WHERE LoteID = v_LoteID;
        
        SET v_StockResultante = v_StockAnterior - v_CantidadDescontar;
        
        -- Registrar movimiento
        INSERT INTO Movimientos (
            ProductoID, LoteID, TipoMovimiento, Cantidad,
            StockAnterior, StockResultante, Observacion
        )
        VALUES (
            p_ProductoID, v_LoteID, 'S', v_CantidadDescontar,
            v_StockAnterior, v_StockResultante, p_Observacion
        );
        
        SET v_StockAnterior = v_StockResultante;
        SET v_CantidadPendiente = v_CantidadPendiente - v_CantidadDescontar;
        
        IF v_CantidadPendiente <= 0 THEN
            LEAVE read_loop;
        END IF;
    END LOOP;
    
    CLOSE lotes_cursor;
    COMMIT;
END;
DELIMITER ;

-- Vista para consulta de Kardex
CREATE OR REPLACE VIEW v_Kardex AS
SELECT 
    m.MovimientoID,
    m.FechaMovimiento,
    p.Codigo,
    p.Nombre,
    l.NumeroLote,
    l.FechaVencimiento,
    CASE m.TipoMovimiento 
        WHEN 'E' THEN 'Entrada'
        WHEN 'S' THEN 'Salida'
    END as TipoMovimiento,
    m.Cantidad,
    m.StockAnterior,
    m.StockResultante,
    m.Observacion
FROM Movimientos m
INNER JOIN Productos p ON m.ProductoID = p.ProductoID
INNER JOIN Lotes l ON m.LoteID = l.LoteID
ORDER BY m.MovimientoID;

-- Datos de prueba
INSERT INTO Productos (Codigo, Nombre) VALUES
('P001', 'Laptop HP Pavilion'),
('P002', 'Monitor Dell 24"'),
('P003', 'Teclado Logitech K380');

-- Registrar entradas de stock
CALL sp_RegistrarEntrada(1, 'LOT001', '2024-12-31', 100, 'Ingreso inicial');
CALL sp_RegistrarEntrada(1, 'LOT002', '2025-01-31', 50, 'Compra adicional');
CALL sp_RegistrarEntrada(2, 'LOT003', '2024-12-31', 75, 'Ingreso inicial');
CALL sp_RegistrarEntrada(3, 'LOT004', '2024-12-31', 200, 'Ingreso inicial');

-- Registrar algunas salidas
CALL sp_DescontarStock(1, 30, 'Venta cliente A');
CALL sp_DescontarStock(2, 25, 'Venta cliente B');
CALL sp_DescontarStock(3, 50, 'Venta cliente C');

-- Consultas útiles

-- Ver kardex completo
SELECT * FROM v_Kardex;
SELECT * FROM v_Kardex;

-- Ver stock actual por producto
SELECT 
    p.Codigo,
    p.Nombre,
    COALESCE(SUM(l.Stock), 0) as StockTotal
FROM Productos p
LEFT JOIN Lotes l ON p.ProductoID = l.ProductoID
GROUP BY p.ProductoID;

-- Ver detalle de lotes con stock
SELECT 
    p.Codigo,
    p.Nombre,
    l.NumeroLote,
    l.FechaVencimiento,
    l.Stock
FROM Productos p
INNER JOIN Lotes l ON p.ProductoID = l.ProductoID
WHERE l.Stock > 0
ORDER BY p.Codigo, l.FechaVencimiento;