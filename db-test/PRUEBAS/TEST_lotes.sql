-- Crear base de datos
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

CREATE TABLE Movimientos (
    MovimientoID INT AUTO_INCREMENT PRIMARY KEY,
    ProductoID INT NOT NULL,
    LoteID INT,
    UltimoStock INT, -- Stock antes del movimiento
    TipoMovimiento CHAR(1), -- 'S' para salida, 'E' para entrada
    Cantidad INT,
    StockDespues INT, -- Stock después del movimiento
    FechaMovimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Movimientos_Productos FOREIGN KEY (ProductoID) 
        REFERENCES Productos(ProductoID),
    CONSTRAINT FK_Movimientos_Lotes FOREIGN KEY (LoteID) 
        REFERENCES Lotes(LoteID)
);

-- Crear el procedimiento almacenado para descontar stock y registrar antes y después del movimiento
-- Crear el procedimiento almacenado para descontar stock y registrar antes y después del movimiento sin usar transacciones
DROP PROCEDURE IF EXISTS sp_DescontarStock;
CREATE PROCEDURE sp_DescontarStock(
    IN p_ProductoID INT,
    IN p_Cantidad INT
)
BEGIN
    DECLARE v_CantidadPendiente INT;
    DECLARE v_LoteID INT;
    DECLARE v_StockLote INT;
    DECLARE v_CantidadDescontar INT;
    DECLARE v_StockDespues INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE lotes_cursor CURSOR FOR
        SELECT LoteID, Stock 
        FROM Lotes 
        WHERE ProductoID = p_ProductoID 
        AND Stock > 0
        ORDER BY FechaCreacion ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Inicializar la cantidad pendiente a descontar
    SET v_CantidadPendiente = p_Cantidad;
    
    OPEN lotes_cursor;
    
    read_loop: LOOP
        FETCH lotes_cursor INTO v_LoteID, v_StockLote;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Determinar la cantidad a descontar en el lote actual
        IF v_StockLote >= v_CantidadPendiente THEN
            SET v_CantidadDescontar = v_CantidadPendiente;
        ELSE
            SET v_CantidadDescontar = v_StockLote;
        END IF;
        
        -- Calcular el stock después del movimiento
        SET v_StockDespues = v_StockLote - v_CantidadDescontar;
        
        -- Actualizar el stock en la tabla Lotes
        UPDATE Lotes 
        SET Stock = v_StockDespues
        WHERE LoteID = v_LoteID;
        
        -- Insertar el movimiento con el stock antes y después del movimiento
        INSERT INTO Movimientos (ProductoID, LoteID, TipoMovimiento, Cantidad, UltimoStock, StockDespues)
        VALUES (p_ProductoID, v_LoteID, 'S', v_CantidadDescontar, v_StockLote, v_StockDespues);
        
        -- Restar la cantidad descontada del pendiente
        SET v_CantidadPendiente = v_CantidadPendiente - v_CantidadDescontar;
        
        -- Terminar si ya no hay cantidad pendiente
        IF v_CantidadPendiente <= 0 THEN
            LEAVE read_loop;
        END IF;
    END LOOP;
    
    CLOSE lotes_cursor;
    
    -- Si no hay suficiente stock en los lotes, arroja un error
    IF v_CantidadPendiente > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
END;

-- Insertar datos de prueba en Productos
INSERT INTO Productos (Codigo, Nombre) VALUES
('P001', 'Laptop HP'),
('P002', 'Monitor Dell'),
('P003', 'Teclado Logitech');

-- Insertar datos de prueba en Lotes
INSERT INTO Lotes (ProductoID, NumeroLote, FechaVencimiento, Stock, FechaCreacion) VALUES
(1, 'L001', '2024-12-31', 100, '2024-01-01 10:00:00'),
(1, 'L002', '2024-12-31', 50, '2024-02-01 10:00:00'),
(2, 'L003', '2024-12-31', 75, '2024-01-15 10:00:00'),
(2, 'L004', '2024-12-31', 25, '2024-02-15 10:00:00'),
(3, 'L005', '2024-12-31', 200, '2024-01-01 10:00:00');

-- Probar el procedimiento sp_DescontarStock
CALL sp_DescontarStock(1,8); -- Debería descontar del lote L001 y L002

-- Consultar el resultado en la tabla Lotes
SELECT * FROM Lotes;

-- Consultar los movimientos realizados
SELECT * FROM Movimientos;

-- Consultar datos de prueba con JOIN para visualizar la información completa
SELECT 
    m.MovimientoID,
    p.Nombre AS Producto,
    l.NumeroLote,
    m.UltimoStock AS StockInicial,
    m.TipoMovimiento,
    m.Cantidad AS CantidadMovimiento,
    m.StockDespues AS Stock_despues,
    l.Stock AS StockActual,
    m.FechaMovimiento
FROM Movimientos m
INNER JOIN Productos p ON m.ProductoID = p.ProductoID
INNER JOIN Lotes l ON m.LoteID = l.LoteID
ORDER BY m.MovimientoID DESC;
