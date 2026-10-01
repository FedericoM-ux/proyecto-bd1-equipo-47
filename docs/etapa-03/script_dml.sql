-- ============================================================
-- SCRIPT DML: SISTEMA DE HAMBURGUESERÍA 
-- ============================================================
-- 1. Poblado de la tabla Pago
INSERT INTO Pago (fecha, monto, id_tipoPago) VALUES
('2026-09-01', 1200.00, 1),
('2026-09-02', 2500.50, 2),
('2026-09-03', 850.00, 1),
('2026-09-04', 3100.00, 3),
('2026-09-05', 1750.25, 2),
('2026-09-06', 990.00, 1),
('2026-09-07', 4200.00, 3),
('2026-09-08', 1500.00, 2),
('2026-09-09', 2100.00, 1),
('2026-09-10', 1800.75, 2);

-- 2. Poblado de la tabla EstadoPago
INSERT INTO EstadoPago (descripcion, id_pago) VALUES
('Aprobado', 1),
('Aprobado', 2),
('Pendiente', 3),
('Aprobado', 4),
('Rechazado', 5),
('Aprobado', 6),
('Aprobado', 7),
('Pendiente', 8),
('Aprobado', 9),
('Aprobado', 10);

-- 3. Poblado de la tabla detalle_Pedido
INSERT INTO detalle_Pedido (cantidad, precio_unit, subtotal, id_pago) VALUES
(2, 600.00, 1200.00, 1),
(1, 2500.50, 2500.50, 2),
(1, 850.00, 850.00, 3),
(2, 1550.00, 3100.00, 4),
(1, 1750.25, 1750.25, 5),
(3, 330.00, 990.00, 6),
(4, 1050.00, 4200.00, 7),
(2, 750.00, 1500.00, 8),
(3, 700.00, 2100.00, 9),
(1, 1800.75, 1800.75, 10);

-- 4. Poblado de la tabla Producto
INSERT INTO Producto (descripcion, nombre_prod, precio, stock, id_categoria, id_cocinero, id_detalle) VALUES
('Hamburguesa simple con papas', 'Hamburguesa Clásica', 600.00, 50, 1, 1, 1),
('Pizza grande de mozzarella', 'Pizza Mozzarella', 2500.50, 20, 2, 2, 2),
('Empanada de carne cortada a cuchillo', 'Empanada de Carne', 850.00, 100, 3, 1, 3),
('Milanesa napolitana con papas fritas', 'Sándwich Milanesa', 1550.00, 30, 1, 3, 4),
('Ensalada César con pollo a la parrilla', 'Ensalada César', 1750.25, 15, 4, 2, 5),
('Gaseosa de cola 500ml', 'Gaseosa Cola', 330.00, 200, 5, 1, 6),
('Lomo completo con huevo y jamón', 'Lomo Completo', 1050.00, 25, 1, 3, 7),
('Tarta de jamón y queso porción', 'Tarta J&Q', 750.00, 40, 3, 2, 8),
('Papas fritas con queso cheddar y verdeo', 'Papas Cheddar', 700.00, 80, 4, 1, 9),
('Postre flan casero con dulce de leche', 'Flan Casero', 1800.75, 18, 6, 2, 10);

-- 5. Poblado Persona 
INSERT INTO Persona (dni, nombre, apellido, correo electronico, telefono, direccion) VALUES 
('35123456', 'Juan', 'Pérez', 'juanperez@gmail.com', '3795562781', 'Las Piedras 1750');
('46713562', 'Marina', 'Alvarez', 'marinalavarez@gmail.com', '3794672687', 'Cordoba 1506');
('23456781', 'Andres', 'Gonzalez', 'andresgonzalez@gmail.com', '3794652671', 'San luis y Mendoza');
('12457832', 'Andrea', 'Galarza', 'andreagalarza@gmail.com', '3795674233', 'Necochea 2222');
('50003032', 'Ricardo', 'Gimenez', 'ricardogimenez@gmail.com', '3798552516', 'Junin 1766');
('45553432', 'Marisa', 'Pérez', 'marisaperez@gmail.com', '3794332331', 'Cordoba 2000');
('22333445', 'Sebastian', 'Hernandez', 'sebastianhernandez@gmail.com', '3794567121', 'Catamarca 56');
('34153677', 'Rita', 'Paez', 'ritapaez@gmail.com', '3794882781', 'Gutenbertg y tte ibañez');

-- 1. Poblado de la tabla Cliente
INSERT INTO Cliente (dni) VALUES 
('35123456');
('46713562');
('45553432');
('22333445');
('34153677');

-- 2. Poblado de la tabla Repartidor
INSERT INTO Repartidor (dni) VALUES 
('35123456');
('23456781');
('22333445');

-- 3. Poblado de la tabla Cocinero
INSERT INTO Cocinero (dni) VALUES 
('12457832');
('50003032');
('34153677');
