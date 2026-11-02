## **1\. Procedimientos y Funciones Almacenadas**

### **1.1. Definición y objetivo**

* **Procedimientos almacenados (Stored Procedures):** Son programas SQL guardados dentro del motor de base de datos que permiten ejecutar secuencias de operaciones de consulta, inserción, modificación y validación de forma centralizada.  
* **Funciones almacenadas (Functions):** Son rutinas que aceptan parámetros, procesan lógica interna y retornan obligatoriamente un valor escalar o una tabla.  
* **Objetivo:** Encapsular las reglas operativas del sistema (liquidación de repartidores, control de insumos en cocina, actualización de cartas de precios y despacho de pedidos) en componentes reutilizables.

### **1.2. Ventajas y aplicaciones**

* Reutilizan la lógica de negocio y reducen la duplicación de código SQL.  
* Mejoran la mantenibilidad cuando cambian las reglas operativas del local.  
* Centralizan cálculos financieros y validaciones dentro del servidor.  
* Facilitan la seguridad sobre los datos al restringir el acceso directo a las tablas.

### **1.3. Casos concretos aplicados al Sistema de Hamburguesería**

Se implementan **cuatro casos distintos** adaptados al dominio de nuestro sistema

1. **Función Escalar (dbo.fn\_CalcularComisionRepartidor):** Calcula la comisión económica (15% sobre el total de cada pedido) que le corresponde cobrar a un repartidor por todos los pedidos que efectivamente haya **Entregado** (id\_estado\_pedido \= 5) en un rango de fechas.  
2. **Función de Tabla (dbo.fn\_AlertaReposicionCocina):** Recibe un umbral mínimo de stock y devuelve qué productos necesitan reposición inmediata, indicando a qué categoría pertenecen y los datos del **Cocinero responsable** de elaborarlos.  
3. **Procedimiento Almacenado (dbo.sp\_ActualizarPreciosPorCategoria):** Aplica un ajuste porcentual masivo sobre los precios de todos los productos de una categoría específica (por ejemplo, *Pizzas* o *Hamburguesas y Sándwiches*) ante cambios en los costos de insumos.  
4. **Procedimiento Almacenado (dbo.sp\_DespacharPedidoConRepartidor):** Asigna un repartidor a un pedido que se encuentra en cocina/listo y actualiza automáticamente su estado a **En Camino** (id\_estado\_pedido \= 4), validando previamente que el pago asociado no esté rechazado.

**1.4. Implementación en SQL Server Express** 

\-- \=========================================================================

\-- CASO 1: FUNCIÓN ESCALAR \- LIQUIDACIÓN DE COMISIÓN DE REPARTIDORES (15%)

\-- \=========================================================================

CREATE OR ALTER FUNCTION dbo.fn\_CalcularComisionRepartidor (

    @id\_repartidor INT,

    @fecha\_desde DATE,

    @fecha\_hasta DATE

)

RETURNS DECIMAL(10,2)

AS

BEGIN

    DECLARE @comision DECIMAL(10,2);

    \-- Calcula el 15% de los pedidos en estado 5 ('Entregado') en ese rango

    SELECT @comision \= ISNULL(SUM(p.total \* 0.15), 0.00)

    FROM dbo.Pedido p

    WHERE p.id\_repartidor \= @id\_repartidor

      AND p.id\_estado\_pedido \= 5 \-- Entregado

      AND p.fecha BETWEEN @fecha\_desde AND @fecha\_hasta;

    RETURN @comision;

END;

GO

\-- \=========================================================================

\-- CASO 2: FUNCIÓN DE TABLA \- ALERTA DE STOCK CRÍTICO Y COCINERO RESPONSABLE

\-- \=========================================================================

CREATE OR ALTER FUNCTION dbo.fn\_AlertaReposicionCocina (@stock\_minimo INT)

RETURNS TABLE

AS

RETURN

(

    SELECT 

        prod.id\_producto,

        prod.nombre\_prod AS Producto,

        cat.nombre AS Categoria,

        prod.stock AS Stock\_Actual,

        per.nombre \+ ' ' \+ per.apellido AS Cocinero\_Responsable,

        per.telefono AS Telefono\_Cocinero

    FROM dbo.Producto prod

    INNER JOIN dbo.Categoria cat ON prod.id\_categoria \= cat.id\_categoria

    INNER JOIN dbo.Cocinero coc ON prod.id\_cocinero \= coc.id\_cocinero

    INNER JOIN dbo.Persona per ON coc.dni \= per.dni

    WHERE prod.stock \<= @stock\_minimo

);

GO

\-- \=========================================================================

\-- CASO 3: PROCEDIMIENTO \- AJUSTE MASIVO DE PRECIOS POR CATEGORÍA

\-- \=========================================================================

CREATE OR ALTER PROCEDURE dbo.sp\_ActualizarPreciosPorCategoria

    @id\_categoria INT,

    @porcentaje\_aumento DECIMAL(5,2) \-- Ejemplo: 10.00 para 10%

AS

BEGIN

    SET NOCOUNT ON;

    IF @porcentaje\_aumento \<= 0

    BEGIN

        RAISERROR('El porcentaje de aumento debe ser mayor a cero.', 16, 1);

        RETURN;

    END

    UPDATE dbo.Producto

    SET precio \= ROUND(precio \* (1 \+ (@porcentaje\_aumento / 100.0)), 2\)

    WHERE id\_categoria \= @id\_categoria;

END;

GO

\-- \=========================================================================

\-- CASO 4: PROCEDIMIENTO \- DESPACHAR PEDIDO Y ASIGNAR REPARTIDOR

\-- \=========================================================================

CREATE OR ALTER PROCEDURE dbo.sp\_DespacharPedidoConRepartidor

    @id\_pedido INT,

    @id\_repartidor INT

AS

BEGIN

    SET NOCOUNT ON;

    DECLARE @estado\_pago VARCHAR(100);

    \-- Verificar estado del pago antes de despachar la comida

    SELECT @estado\_pago \= ep.descripcion

    FROM dbo.Pedido p

    INNER JOIN dbo.detalle\_Pedido dp ON p.id\_detalle \= dp.id\_detalle

    INNER JOIN dbo.EstadoPago ep ON dp.id\_pago \= ep.id\_pago

    WHERE p.id\_pedido \= @id\_pedido;

    IF @estado\_pago \= 'Rechazado'

    BEGIN

        RAISERROR('No se puede despachar el pedido: el pago figura como Rechazado.', 16, 1);

        RETURN;

    END

    \-- Actualizar repartidor asignado y pasar a estado 4 ('En Camino')

    UPDATE dbo.Pedido

    SET id\_repartidor \= @id\_repartidor,

        id\_estado\_pedido \= 4

    WHERE id\_pedido \= @id\_pedido;

END;

GO

### **1.5. Script de demostración y resultados obtenidos**

\-- 1\. Consultar comisiones ganadas por cada repartidor en Septiembre 2026

SELECT 

    r.id\_repartidor,

    per.nombre \+ ' ' \+ per.apellido AS Repartidor,

    dbo.fn\_CalcularComisionRepartidor(r.id\_repartidor, '2026-09-01', '2026-09-30') AS Comision\_A\_Cobrar

FROM dbo.Repartidor r

INNER JOIN dbo.Persona per ON r.dni \= per.dni;

\-- 2\. Consultar productos con stock menor o igual a 25 unidades para que cocina reponga

SELECT \* FROM dbo.fn\_AlertaReposicionCocina(25);

\-- 3\. Aumentar un 10% la categoría 1 ('Hamburguesas y Sándwiches')

EXEC dbo.sp\_ActualizarPreciosPorCategoria @id\_categoria \= 1, @porcentaje\_aumento \= 10.00;

SELECT id\_producto, nombre\_prod, precio FROM dbo.Producto WHERE id\_categoria \= 1;

\-- 4\. Despachar el Pedido 7 (que estaba 'En Cocina') asignándolo al Repartidor 3

EXEC dbo.sp\_DespacharPedidoConRepartidor @id\_pedido \= 7, @id\_repartidor \= 3;

SELECT id\_pedido, id\_repartidor, id\_estado\_pedido FROM dbo.Pedido WHERE id\_pedido \= 7;

