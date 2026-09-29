-- ============================================================
-- SCRIPT DDL: SISTEMA DE HAMBURGUESERÍA
-- ============================================================

-- 1. TABLAS PRINCIPALES (SIN CLAVES FORÁNEAS)

CREATE TABLE Persona (
    dni VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    telefono VARCHAR(50),
    direccion VARCHAR(200),
    PRIMARY KEY (dni)
);

CREATE TABLE Categoria (
    id_categoria INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    PRIMARY KEY (id_categoria)
);

CREATE TABLE EstadoPedido (
    id_estado_pedido INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_estado_pedido)
);

CREATE TABLE tipo_Pago (
    id_tipoPago INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_tipoPago)
);

CREATE TABLE EstadoPago (
    id_estado_pago INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_estado_pago)
);

-- 2. TABLAS ROLES Y PRODUCTO (DEPENDEN DE PERSONA Y CATEGORIA)

CREATE TABLE Cliente (
    id_cliente INT NOT NULL AUTO_INCREMENT,
    dni VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (dni) REFERENCES Persona(dni)
);

CREATE TABLE Repartidor (
    id_repartidor INT NOT NULL AUTO_INCREMENT,
    dni VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_repartidor),
    FOREIGN KEY (dni) REFERENCES Persona(dni)
);

CREATE TABLE Cocinero (
    id_cocinero INT NOT NULL AUTO_INCREMENT,
    dni VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_cocinero),
    FOREIGN KEY (dni) REFERENCES Persona(dni)
);

CREATE TABLE Producto (
    id_producto INT NOT NULL AUTO_INCREMENT,
    nombre_prod VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    id_categoria INT NOT NULL,
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- 3. TABLA PEDIDO (DEPENDE DE CLIENTE, REPARTIDOR Y ESTADOPEDIDO)

CREATE TABLE Pedido (
    id_pedido INT NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    id_cliente INT NOT NULL,
    id_repartidor INT NOT NULL,
    id_estado_pedido INT NOT NULL,
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_repartidor) REFERENCES Repartidor(id_repartidor),
    FOREIGN KEY (id_estado_pedido) REFERENCES EstadoPedido(id_estado_pedido)
);

-- 4. TABLA DETALLE_PEDIDO (DEPENDE DE PEDIDO)

CREATE TABLE detalle_Pedido (
    id_detalle INT NOT NULL AUTO_INCREMENT,
    cantidad INT NOT NULL,
    precio_unit DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    id_pedido INT NOT NULL,
    PRIMARY KEY (id_detalle),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- 5. TABLA PAGO (DEPENDE DE DETALLE_PEDIDO, TIPO_PAGO Y ESTADOPAGO)

CREATE TABLE Pago (
    id_pago INT NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    id_detalle INT NOT NULL,
    id_tipoPago INT NOT NULL,
    id_estado_pago INT NOT NULL,
    PRIMARY KEY (id_pago),
    FOREIGN KEY (id_detalle) REFERENCES detalle_Pedido(id_detalle),
    FOREIGN KEY (id_tipoPago) REFERENCES tipo_Pago(id_tipoPago),
    FOREIGN KEY (id_estado_pago) REFERENCES EstadoPago(id_estado_pago)
);

-- 6. TABLAS INTERMEDIAS / MUCHOS A MUCHOS

CREATE TABLE detalle_Pedido_Producto (
    id_detalle INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_detalle, id_producto),
    FOREIGN KEY (id_detalle) REFERENCES detalle_Pedido(id_detalle),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Cocinero_Producto (
    id_cocinero INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_cocinero, id_producto),
    FOREIGN KEY (id_cocinero) REFERENCES Cocinero(id_cocinero),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);