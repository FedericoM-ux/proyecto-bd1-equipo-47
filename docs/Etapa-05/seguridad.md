### **4.1. Definición y Objetivo**

**Definición:** Es el mecanismo de control de accesos de SQL Server que administra qué inicios de sesión (*Logins*), usuarios de base de datos (*Users*) y roles (*Roles*) pueden consultar, modificar o ejecutar objetos específicos dentro del motor de base de datos.

**Objetivo:** Implementar el **Principio de Mínimo Privilegio** en el Sistema de Hamburguesería, separando adecuadamente las responsabilidades y permisos entre gerencia, cajeros de cobro, personal de cocina y repartidores de delivery.

### **4.2. Ventajas y Aplicaciones**

**Protección de Datos Financieros:** Protege la recaudación, los saldos de caja y los estados de pago contra modificaciones directas por fuera de los procedimientos almacenados autorizados.

**Segmentación Operativa:** Permite asignar responsabilidades estrictamente ligadas al puesto de trabajo (Cocina, Caja, Logística/Reparto).

**Mantenibilidad y Escalabilidad:** Simplifica la administración asignando permisos a roles reutilizables del negocio en lugar de configurar usuario por usuario.

**Encapsulamiento mediante Stored Procedures:** Permite otorgar permisos de ejecución (EXECUTE) sobre un procedimiento almacenado a un perfil (como el cajero) sin darle permisos directos de inserción, actualización o borrado (UPDATE/DELETE) sobre las tablas base.

### **4.3. Casos Concretos Aplicados al Sistema de Hamburguesería**

En lugar de ejemplos genéricos de la guía, el esquema de seguridad se basa en los roles operativos reales del local gastronómico:

**Procedimiento Encapsulado de Caja (dbo.sp\_ConfirmarCobroPendiente):** Permite que el perfil de caja apruebe un pago pendiente sin requerir permisos directos de UPDATE sobre las tablas EstadoPago o Pago.

**Parte 1 (Permisos a Nivel de Usuarios):**

**usuario\_encargado:** Asignado al rol db\_owner (control total sobre el local).

**usuario\_cajero:** Posee únicamente permisos de consulta (SELECT) sobre dbo.Pago y dbo.EstadoPago, junto con permiso de ejecución (EXECUTE) sobre dbo.sp\_ConfirmarCobroPendiente. No puede modificar tablas directamente.

**Parte 2 (Permisos a Nivel de Roles del Negocio):**

**rol\_cocina\_preparacion:** Permiso SELECT sobre dbo.detalle\_Pedido, dbo.Producto y dbo.Categoria para visualizar las comandas a preparar, sin acceso a datos financieros o de pagos.

**rol\_logistica\_reparto:** Permiso SELECT sobre dbo.Pedido, dbo.Cliente y dbo.Persona para consultar nombres, teléfonos y direcciones de envío de los clientes.

**Prueba de Accesos:** Se evalúan los accesos comparando a usuario\_cocinero\_ricardo (rol cocina), usuario\_repartidor\_andres (rol logística) y usuario\_invitado\_sin\_rol (sin permisos).

### **4.4. Implementación en SQL Server Express**

USE Hamburgueseria;  
GO

\-- \=========================================================================  
\-- PROCEDIMIENTO DE CAJA PARA DEMOSTRAR ENCAPSULAMIENTO DE SEGURIDAD  
\-- \=========================================================================  
CREATE OR ALTER PROCEDURE dbo.sp\_ConfirmarCobroPendiente  
    @id\_pago INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
    UPDATE dbo.EstadoPago  
    SET descripcion \= 'Aprobado'  
    WHERE id\_pago \= @id\_pago  
      AND descripcion \= 'Pendiente';  
END;  
GO

\-- \=========================================================================  
\-- PARTE 1: PERMISOS DIRECTOS A USUARIOS (ENCARGADO VS CAJERO)  
\-- \=========================================================================  
CREATE LOGIN usuario\_encargado WITH PASSWORD \= 'Encargado123\*';  
CREATE LOGIN usuario\_cajero WITH PASSWORD \= 'Cajero123\*';  
GO

CREATE USER usuario\_encargado FOR LOGIN usuario\_encargado;  
CREATE USER usuario\_cajero FOR LOGIN usuario\_cajero;  
GO

\-- El encargado tiene control total de la base de datos  
ALTER ROLE db\_owner ADD MEMBER usuario\_encargado;  
GO

\-- El cajero solo puede consultar Pago y EstadoPago, y ejecutar el SP de confirmación  
GRANT SELECT ON dbo.Pago TO usuario\_cajero;  
GRANT SELECT ON dbo.EstadoPago TO usuario\_cajero;  
GRANT EXECUTE ON dbo.sp\_ConfirmarCobroPendiente TO usuario\_cajero;  
GO

\-- \=========================================================================  
\-- PARTE 2: PERMISOS MEDIANTE ROLES PERSONALIZADOS (COCINA Y LOGÍSTICA)  
\-- \=========================================================================  
CREATE LOGIN usuario\_cocinero\_ricardo WITH PASSWORD \= 'Cocina123\*';  
CREATE LOGIN usuario\_repartidor\_andres WITH PASSWORD \= 'Reparto123\*';  
CREATE LOGIN usuario\_invitado\_sin\_rol WITH PASSWORD \= 'Invitado123\*';  
GO

CREATE USER usuario\_cocinero\_ricardo FOR LOGIN usuario\_cocinero\_ricardo;  
CREATE USER usuario\_repartidor\_andres FOR LOGIN usuario\_repartidor\_andres;  
CREATE USER usuario\_invitado\_sin\_rol FOR LOGIN usuario\_invitado\_sin\_rol;  
GO

\-- Creación de roles de la hamburguesería  
CREATE ROLE rol\_cocina\_preparacion;  
CREATE ROLE rol\_logistica\_reparto;  
GO

\-- Permisos del rol de cocina (ve productos y detalles, pero NO ve pagos ni datos personales)  
GRANT SELECT ON dbo.Producto TO rol\_cocina\_preparacion;  
GRANT SELECT ON dbo.Categoria TO rol\_cocina\_preparacion;  
GRANT SELECT ON dbo.detalle\_Pedido TO rol\_cocina\_preparacion;  
GO

\-- Permisos del rol de logística (ve pedidos y direcciones en Persona/Cliente, pero NO ve pagos)  
GRANT SELECT ON dbo.Pedido TO rol\_logistica\_reparto;  
GRANT SELECT ON dbo.Cliente TO rol\_logistica\_reparto;  
GRANT SELECT ON dbo.Persona TO rol\_logistica\_reparto;  
GO

\-- Asignación de usuarios a sus respectivos roles  
ALTER ROLE rol\_cocina\_preparacion ADD MEMBER usuario\_cocinero\_ricardo;  
ALTER ROLE rol\_logistica\_reparto ADD MEMBER usuario\_repartidor\_andres;  
GO  
\`\`\`\[cite: 47\]

\---

\#\#\# 4.5. Script de Demostración y Resultados Obtenidos

\#\#\#\# Script de Pruebas de Demostración:

\`\`\`sql  
\-- \=========================================================================  
\-- PRUEBA 1: MODIFICACIÓN DIRECTA DE ESTADOPAGO VS PROCEDIMIENTO ALMACENADO  
\-- \=========================================================================  
\-- A) Con usuario\_encargado (Resultado esperado: Correcto)  
EXECUTE AS USER \= 'usuario\_encargado';  
UPDATE dbo.EstadoPago SET descripcion \= 'Pendiente' WHERE id\_pago \= 8;  
REVERT;  
GO

\-- B) Con usuario\_cajero intentando hacer UPDATE directo (Resultado esperado: Acceso denegado)  
EXECUTE AS USER \= 'usuario\_cajero';  
UPDATE dbo.EstadoPago SET descripcion \= 'Aprobado' WHERE id\_pago \= 8;  
REVERT;  
GO

\-- C) Con usuario\_cajero usando el procedimiento autorizado (Resultado esperado: Correcto)  
EXECUTE AS USER \= 'usuario\_cajero';  
EXEC dbo.sp\_ConfirmarCobroPendiente @id\_pago \= 8;  
SELECT \* FROM dbo.EstadoPago WHERE id\_pago \= 8;  
REVERT;  
GO

\-- \=========================================================================  
\-- PRUEBA 2: ACCESO SEGÚN ROLES (COCINA, LOGÍSTICA Y SIN ROL)  
\-- \=========================================================================  
\-- A) usuario\_cocinero\_ricardo consulta detalle\_Pedido (Correcto) pero intenta leer Pago (Denegado)  
EXECUTE AS USER \= 'usuario\_cocinero\_ricardo';  
SELECT \* FROM dbo.detalle\_Pedido; \-- Correcto  
SELECT \* FROM dbo.Pago;           \-- Acceso denegado  
REVERT;  
GO

\-- B) usuario\_repartidor\_andres consulta direcciones en Persona (Correcto)  
EXECUTE AS USER \= 'usuario\_repartidor\_andres';  
SELECT nombre, apellido, telefono, direccion FROM dbo.Persona; \-- Correcto  
REVERT;  
GO

\-- C) usuario\_invitado\_sin\_rol intenta consultar Persona o Producto (Acceso denegado)  
EXECUTE AS USER \= 'usuario\_invitado\_sin\_rol';  
SELECT \* FROM dbo.Producto; \-- Acceso denegado  
REVERT;  
GO  
\`\`\`\[cite: 47\]

\#\#\#\# Cuadro Resumen de Resultados Obtenidos:

\| Prueba Realizada \| Usuario Evaluado \| Resultado Esperado / Obtenido \|  
\| :--- \| :--- \| :--- \|  
\| \*\*\`UPDATE\` directo sobre \`EstadoPago\`\*\*\[cite: 47\] \| \`usuario\_encargado\` \| \*\*Correcto\*\* (Pertenece a \`db\_owner\`)\[cite: 47\]. \|  
\| \*\*\`UPDATE\` directo sobre \`EstadoPago\`\*\*\[cite: 47\] \| \`usuario\_cajero\` \| \*\*Acceso denegado\*\* (No posee permiso \`UPDATE\` sobre la tabla)\[cite: 47\]. \|  
\| \*\*\`EXEC dbo.sp\_ConfirmarCobroPendiente\`\*\*\[cite: 47\] \| \`usuario\_cajero\` \| \*\*Correcto\*\* (Posee permiso \`EXECUTE\` sobre el procedimiento)\[cite: 47\]. \|  
\| \*\*\`SELECT\` sobre \`detalle\_Pedido\` y \`Producto\`\*\*\[cite: 47\] \| \`usuario\_cocinero\_ricardo\` \| \*\*Correcto\*\* (Miembro de \`rol\_cocina\_preparacion\`)\[cite: 47\]. \|  
\| \*\*\`SELECT\` sobre \`Pago\`\*\*\[cite: 47\] \| \`usuario\_cocinero\_ricardo\` \| \*\*Acceso denegado\*\* (El rol de cocina no tiene acceso a finanzas)\[cite: 47\]. \|  
\| \*\*\`SELECT\` sobre \`Persona\` (Direcciones)\*\*\[cite: 47\] \| \`usuario\_repartidor\_andres\` \| \*\*Correcto\*\* (Miembro de \`rol\_logistica\_reparto\`)\[cite: 47\]. \|  
\| \*\*\`SELECT\` sobre \`Producto\`\*\*\[cite: 47\] \| \`usuario\_invitado\_sin\_rol\` \| \*\*Acceso denegado\*\* (Usuario sin rol asignado)\[cite: 47\]. \|  
