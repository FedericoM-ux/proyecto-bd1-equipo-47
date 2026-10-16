# Etapa 04: Casos de Prueba y Validación de Consultas

## 1. Juego de Datos de Prueba (Setup)
Se ingresaron registros de prueba representativos para el mes de septiembre de 2026 en el servidor de base de datos para validar el correcto funcionamiento y agrupamiento de los reportes.
-- 1. Insertar Personas y Clientes
INSERT INTO Persona (dni, nombre, apellido) VALUES
(40111222, 'Juan', 'Pérez'),
(40333444, 'María', 'Gómez'),
(40555666, 'Carlos', 'López');

INSERT INTO Cliente (id_cliente, dni) VALUES
(1, 40111222),
(2, 40333444),
(3, 40555666);

-- 2. Insertar Categorías de Productos
INSERT INTO Categoria (id_categoria, nombre) VALUES
(1, 'Bebidas'),
(2, 'Comidas'),
(3, 'Postres');

-- 3. Insertar Detalles de Pedido (Líneas de venta)
INSERT INTO detalle_Pedido (id_detalle, cantidad, precio_unit, subtotal) VALUES
(10, 2, 1500.00, 3000.00),
(11, 1, 800.00, 800.00),
(12, 3, 4500.00, 13500.00),
(13, 1, 1200.00, 1200.00);

-- 4. Insertar Productos vinculados
INSERT INTO Producto (id_producto, nombre_prod, id_categoria, id_detalle) VALUES
(101, 'Cerveza Artesanal', 1, 10),
(102, 'Gaseosa 500ml', 1, 11),
(103, 'Hamburguesa Completa', 2, 12),
(105, 'Helado 2 bochas', 3, 13);

-- 5. Insertar Pedidos (Septiembre 2026)
INSERT INTO Pedido (id_pedido, fecha, total, id_detalle, id_cliente) VALUES
(1001, '2026-09-05', 3000.00, 10, 1),
(1002, '2026-09-12', 800.00, 11, 2),
(1003, '2026-09-20', 13500.00, 12, 1),
(1004, '2026-09-25', 1200.00, 13, 3);

## 2. Caso de Prueba: Consulta Avanzada (Filtro por Promedio)

* **Objetivo:** Validar que la consulta agrupe los pedidos de septiembre de 2026 por categoría y devuelva únicamente aquellas categorías cuyo monto total vendido sea superior al promedio general entre todas las categorías.
* **Cálculo Previo de Validación:**
  * Total Categoría Bebidas = $3,800.00
  * Total Categoría Comidas = $13,500.00
  * Total Categoría Postres = $1,200.00
  * **Promedio General:** (3800 + 13500 + 1200) / 3 = 6,166.67
* **Resultado Esperado vs Real:**
  * La consulta retorna exclusivamente la categoría **Comidas** con 1 Pedido, 3 Unidades Vendidas y un Monto Total Vendido de $13,500.00, superando el umbral de $6,166.67.
* **Estado:** EXITO / APROBADO.
