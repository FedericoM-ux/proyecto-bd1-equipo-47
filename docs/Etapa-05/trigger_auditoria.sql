-- ============================================================
-- SCRIPT: TEMA 3 - TRIGGERS DE AUDITORÍA (SISTEMA HAMBURGUESERÍA)
-- ============================================================

-- 1. Crear la tabla de auditoría para los productos
CREATE TABLE auditoria_producto (
    auditoria_id INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT,
    nombre_prod VARCHAR(100),
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    usuario VARCHAR(50) DEFAULT SYSTEM_USER
);
GO

-- 2. Crear el Trigger de Auditoría para actualizaciones en la tabla Producto
CREATE TRIGGER trg_auditoria_precio_producto
ON Producto
AFTER UPDATE
AS
BEGIN
    -- Verificamos si la columna 'precio' fue modificada
    IF UPDATE(precio)
    BEGIN
        INSERT INTO auditoria_producto (id_producto, nombre_prod, precio_anterior, precio_nuevo)
        SELECT 
            I.id_producto, 
            I.nombre_prod, 
            D.precio, 
            I.precio
        FROM inserted I
        JOIN deleted D ON I.id_producto = D.id_producto;
    END
END;
GO

-- 3. Demostración: Modificamos el precio de la Hamburguesa Clásica (id_producto = 1)
UPDATE Producto 
SET precio = 750.00 
WHERE id_producto = 1;
GO

-- 4. Consultar la tabla de auditoría para verificar que el cambio se registró solo
SELECT * FROM auditoria_producto;
