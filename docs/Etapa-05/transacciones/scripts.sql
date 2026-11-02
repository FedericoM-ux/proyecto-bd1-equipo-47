USE ProyectoBD1;
GO

-- DEMOSTRACIÓN DE TRANSACCIÓN CON CONTROL DE ERRORES Y ROLLBACK
IF OBJECT_ID('tempdb..#StockPrueba', 'U') IS NOT NULL
    DROP TABLE #StockPrueba;

CREATE TABLE #StockPrueba (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(50),
    stock INT
);

INSERT INTO #StockPrueba (id_producto, nombre, stock)
VALUES (1, 'Pizza Mozzarella', 1);
GO

BEGIN TRANSACTION;

BEGIN TRY
    UPDATE #StockPrueba
    SET stock = stock - 2
    WHERE id_producto = 1;

    IF EXISTS (SELECT 1 FROM #StockPrueba WHERE id_producto = 1 AND stock < 0)
    BEGIN
        RAISERROR('Error de Negocio: Stock insuficiente para completar el pedido.', 16, 1);
    END

    COMMIT TRANSACTION;
    PRINT 'Transacción CONFIRMADA (COMMIT).';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Transacción CANCELADA (ROLLBACK): ' + ERROR_MESSAGE();
END CATCH;
GO
