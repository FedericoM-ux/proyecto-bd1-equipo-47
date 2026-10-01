-- ============================================================
-- SCRIPT DDL: SISTEMA DE HAMBURGUESERÍA 
-- ============================================================

-- 1. TABLAS BASE

CREATE TABLE Persona (
    dni INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NULL,
    telefono VARCHAR(50) NULL,
    direccion VARCHAR(200) NULL,
    CONSTRAINT UQ_Persona_Email UNIQUE (email),
    CONSTRAINT PK_Persona PRIMARY KEY (dni)
);

CREATE TABLE Categoria (
    id_categoria INT NOT NULL IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100) NULL,
    CONSTRAINT PK_Categoria PRIMARY KEY (id_categoria)
);

CREATE TABLE EstadoPedido (
    id_estado_pedido INT NOT NULL IDENTITY(1,1),
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT PK_EstadoPedido PRIMARY KEY (id_estado_pedido)
);

CREATE TABLE tipo_Pago (
    id_tipoPago INT NOT NULL IDENTITY(1,1),
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT PK_tipo_Pago PRIMARY KEY (id_tipoPago)
);

-- 2. TABLAS SECUNDARIAS (ROLES Y PAGOS)

CREATE TABLE Cliente (
    id_cliente INT NOT NULL IDENTITY(1,1),
    dni INT NOT NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (id_cliente),
    CONSTRAINT FK_Cliente_Persona FOREIGN KEY (dni) REFERENCES Persona(dni)
);

CREATE TABLE Repartidor (
    id_repartidor INT NOT NULL IDENTITY(1,1),
    dni INT NOT NULL,
    CONSTRAINT PK_Repartidor PRIMARY KEY (id_repartidor),
    CONSTRAINT FK_Repartidor_Persona FOREIGN KEY (dni) REFERENCES Persona(dni)
);

CREATE TABLE Cocinero (
    id_cocinero INT NOT NULL IDENTITY(1,1),
    dni INT NOT NULL,
    CONSTRAINT PK_Cocinero PRIMARY KEY (id_cocinero),
    CONSTRAINT FK_Cocinero_Persona FOREIGN KEY (dni) REFERENCES Persona(dni)
);

CREATE TABLE Pago (
    id_pago INT NOT NULL IDENTITY(1,1),
    fecha DATE NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    id_tipoPago INT NOT NULL,
    CONSTRAINT PK_Pago PRIMARY KEY (id_pago),
    CONSTRAINT FK_Pago_tipoPago FOREIGN KEY (id_tipoPago) REFERENCES tipo_Pago(id_tipoPago)
);

-- 3. ESTADO PAGO Y DETALLE PEDIDO

CREATE TABLE EstadoPago (
    id_estado_pago INT NOT NULL IDENTITY(1,1),
    descripcion VARCHAR(100) NOT NULL,
    id_pago INT NOT NULL,
    CONSTRAINT PK_EstadoPago PRIMARY KEY (id_estado_pago),
    CONSTRAINT FK_EstadoPago_Pago FOREIGN KEY (id_pago) REFERENCES Pago(id_pago)
);

CREATE TABLE detalle_Pedido (
    id_detalle INT NOT NULL IDENTITY(1,1),
    cantidad INT NOT NULL,
    precio_unit DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    id_pago INT NOT NULL,
    CONSTRAINT PK_detalle_Pedido PRIMARY KEY (id_detalle),
    CONSTRAINT FK_detalle_Pedido_Pago FOREIGN KEY (id_pago) REFERENCES Pago(id_pago)
);

-- 4. PEDIDO Y PRODUCTO

CREATE TABLE Pedido (
    id_pedido INT NOT NULL IDENTITY(1,1),
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    id_detalle INT NOT NULL,
    id_cliente INT NOT NULL,
    id_repartidor INT NOT NULL,
    id_estado_pedido INT NOT NULL,
    CONSTRAINT PK_Pedido PRIMARY KEY (id_pedido),
    CONSTRAINT FK_Pedido_detalle FOREIGN KEY (id_detalle) REFERENCES detalle_Pedido(id_detalle),
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT FK_Pedido_Repartidor FOREIGN KEY (id_repartidor) REFERENCES Repartidor(id_repartidor),
    CONSTRAINT FK_Pedido_EstadoPedido FOREIGN KEY (id_estado_pedido) REFERENCES EstadoPedido(id_estado_pedido)
);

CREATE TABLE Producto (
    id_producto INT NOT NULL IDENTITY(1,1),
    descripcion VARCHAR(255) NULL,
    nombre_prod VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    id_categoria INT NOT NULL,
    id_cocinero INT NOT NULL,
    id_detalle INT NOT NULL,
    CONSTRAINT PK_Producto PRIMARY KEY (id_producto),
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
    CONSTRAINT FK_Producto_Cocinero FOREIGN KEY (id_cocinero) REFERENCES Cocinero(id_cocinero),
    CONSTRAINT FK_Producto_detalle FOREIGN KEY (id_detalle) REFERENCES detalle_Pedido(id_detalle)
);

ALTER TABLE Persona
ADD CONSTRAINT CK_Persona_DNI CHECK (dni > 0);

ALTER TABLE detalle_Pedido
ADD CONSTRAINT CK_Detalle_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_Detalle_PrecioUnit CHECK (precio_unit > 0),
    CONSTRAINT CK_Detalle_Subtotal CHECK (subtotal > 0);

ALTER TABLE Pago
ADD CONSTRAINT CK_Pago_Monto CHECK (monto > 0);

ALTER TABLE Pedido
ADD CONSTRAINT CK_Pedido_Total CHECK (total > 0);

ALTER TABLE Producto
ADD CONSTRAINT CK_Producto_Precio CHECK (precio > 0),
    CONSTRAINT CK_Producto_Stock CHECK (stock >= 0);