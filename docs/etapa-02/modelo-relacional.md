CREATE TABLE TIPO\_PAGO  
(  
  id\_tipoPago INT NOT NULL,  
  descripcion VARCHAR(100) NOT NULL,  
  PRIMARY KEY (id\_tipoPago)  
);

CREATE TABLE PAGO  
(  
  id\_pago INT NOT NULL,  
  fecha DATE NOT NULL,  
  monto DECIMAL(10,2) NOT NULL,  
  id\_tipoPago INT NOT NULL,  
  PRIMARY KEY (id\_pago),  
  FOREIGN KEY (id\_tipoPago) REFERENCES TIPO\_PAGO(id\_tipoPago)  
);

CREATE TABLE PERSONA  
(  
  dni INT NOT NULL,  
  nombre VARCHAR(100) NOT NULL,  
  apellido VARCHAR(100) NOT NULL,  
  direccion VARCHAR(150) NOT NULL,  
  email VARCHAR(100) NOT NULL,  
  telefono VARCHAR(20) NOT NULL,  
  PRIMARY KEY (dni)  
);

CREATE TABLE CLIENTE  
(  
  id\_cliente INT NOT NULL,  
  dni INT NOT NULL,  
  PRIMARY KEY (id\_cliente),  
  FOREIGN KEY (dni) REFERENCES PERSONA(dni)  
);

CREATE TABLE REPARTIDOR  
(  
  id\_repartidor INT NOT NULL,  
  dni INT NOT NULL,  
  PRIMARY KEY (id\_repartidor),  
  FOREIGN KEY (dni) REFERENCES PERSONA(dni)  
);

CREATE TABLE COCINERO  
(  
  id\_cocinero INT NOT NULL,  
  dni INT NOT NULL,  
  PRIMARY KEY (id\_cocinero),  
  FOREIGN KEY (dni) REFERENCES PERSONA(dni)  
);

CREATE TABLE ESTADOPEDIDO  
(  
  id\_estado\_pedido INT NOT NULL,  
  descripcion VARCHAR(100) NOT NULL,  
  PRIMARY KEY (id\_estado\_pedido)  
);

CREATE TABLE PEDIDO  
(  
  id\_pedido INT NOT NULL,  
  fecha DATE NOT NULL,  
  hora TIME NOT NULL,  
  total DECIMAL(10,2) NOT NULL,  
  id\_cliente INT NOT NULL,  
  id\_estado\_pedido INT NOT NULL,  
  id\_repartidor INT NOT NULL,  
  PRIMARY KEY (id\_pedido),  
  FOREIGN KEY (id\_cliente) REFERENCES CLIENTE(id\_cliente),  
  FOREIGN KEY (id\_estado\_pedido) REFERENCES ESTADOPEDIDO(id\_estado\_pedido),  
  FOREIGN KEY (id\_repartidor) REFERENCES REPARTIDOR(id\_repartidor)  
);

CREATE TABLE CATEGORIA  
(  
  id\_categoria INT NOT NULL,  
  nombre VARCHAR(100) NOT NULL,  
  descripcion VARCHAR(200) NOT NULL,  
  PRIMARY KEY (id\_categoria)  
);

CREATE TABLE PRODUCTO  
(  
  id\_producto INT NOT NULL,  
  nombre\_prod VARCHAR(100) NOT NULL,  
  descripcion VARCHAR(200) NOT NULL,  
  precio DECIMAL(10,2) NOT NULL,  
  stock INT NOT NULL,  
  id\_categoria INT NOT NULL,  
  id\_cocinero INT NOT NULL,  
  PRIMARY KEY (id\_producto),  
  FOREIGN KEY (id\_categoria) REFERENCES CATEGORIA(id\_categoria),  
  FOREIGN KEY (id\_cocinero) REFERENCES COCINERO(id\_cocinero)  
);

CREATE TABLE DETALLE\_PEDIDO  
(  
  id\_detalle INT NOT NULL,  
  cantidad INT NOT NULL,  
  precio\_unit DECIMAL(10,2) NOT NULL,  
  subtotal DECIMAL(10,2) NOT NULL,  
  id\_pedido INT NOT NULL,  
  id\_producto INT NOT NULL,  
  PRIMARY KEY (id\_detalle),  
  FOREIGN KEY (id\_pedido) REFERENCES PEDIDO(id\_pedido),  
  FOREIGN KEY (id\_producto) REFERENCES PRODUCTO(id\_producto)  
);

CREATE TABLE ESTADOPAGO  
(  
  id\_estado\_pago INT NOT NULL,  
  descripcion VARCHAR(100) NOT NULL,  
  id\_pago INT NOT NULL,  
  PRIMARY KEY (id\_estado\_pago),  
  FOREIGN KEY (id\_pago) REFERENCES PAGO(id\_pago)  
);

