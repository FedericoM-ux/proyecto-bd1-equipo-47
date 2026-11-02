USE PedidosRestaurant;
GO

-- =========================================================================
-- PARTE 1: CREACIÓN DE TABLA HISTÓRICA Y CARGA MASIVA DE PRUEBA (100.000 REGS)
-- =========================================================================
IF OBJECT_ID('dbo.VentaHistorica', 'U') IS NOT NULL 
    DROP TABLE dbo.VentaHistorica;
GO

CREATE TABLE dbo.VentaHistorica (
    id_venta BIGINT IDENTITY(1,1) PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    importe DECIMAL(12,2) NOT NULL,
    id_cliente INT NOT NULL
);
GO

-- Poblado masivo de prueba para generar impacto real en el plan de ejecución
SET NOCOUNT ON;
WITH Numeros AS (
    SELECT TOP (100000) ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b CROSS JOIN sys.objects c
)
INSERT INTO dbo.VentaHistorica (fecha_venta, importe, id_cliente)
SELECT 
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, '2026-01-01'),
    ROUND(RAND(CHECKSUM(NEWID())) * 15000 + 1000, 2),
    ABS(CHECKSUM(NEWID())) % 50 + 1
FROM Numeros;
GO

-- =========================================================================
-- PARTE 2: CONSULTA Y EVALUACIÓN DE ESCENARIOS DE RENDIMIENTO
-- =========================================================================

-- Activar métricas de lectura y tiempo de CPU en SSMS
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

-- ESCENARIO 1: Consulta sin índices creados sobre la fecha (Table Scan)
SELECT id_venta, fecha_venta, importe, id_cliente
FROM dbo.VentaHistorica
WHERE fecha_venta BETWEEN '2026-02-01' AND '2026-03-31';
GO

-- =========================================================================
-- ESCENARIO 2: Creación de índice no agrupado simple sobre el filtro de fecha
-- =========================================================================
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_VentaHistorica_Fecha')
    DROP INDEX IX_VentaHistorica_Fecha ON dbo.VentaHistorica;
GO

CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha 
ON dbo.VentaHistorica (fecha_venta);
GO

-- Consulta con Índice Simple (Index Seek + Key Lookup)
SELECT id_venta, fecha_venta, importe, id_cliente
FROM dbo.VentaHistorica
WHERE fecha_venta BETWEEN '2026-02-01' AND '2026-03-31';
GO

-- =========================================================================
-- ESCENARIO 3: Creación de índice con cobertura (INCLUDE)
-- =========================================================================
DROP INDEX IX_VentaHistorica_Fecha ON dbo.VentaHistorica;
GO

CREATE NONCLUSTERED INDEX IX_VentaHistorica_Fecha_Cobertura 
ON dbo.VentaHistorica (fecha_venta) 
INCLUDE (importe, id_cliente);
GO

-- Consulta con Índice de Cobertura (Index Seek Puro - Cobertura 100%)
SELECT id_venta, fecha_venta, importe, id_cliente
FROM dbo.VentaHistorica
WHERE fecha_venta BETWEEN '2026-02-01' AND '2026-03-31';
GO

-- Desactivar estadísticas
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
