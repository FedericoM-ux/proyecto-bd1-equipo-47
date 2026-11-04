USE Hamburgueseria;
GO

-- PARTE 1: CREACION DE OBJETOS, LOGINS, USUARIOS Y PERMISOS)

IF OBJECT_ID('dbo.sp_ConfirmarCobroPendiente', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConfirmarCobroPendiente;
GO

CREATE PROCEDURE dbo.sp_ConfirmarCobroPendiente
    @id_pago INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.EstadoPago
    SET descripcion = 'Aprobado'
    WHERE id_pago = @id_pago
      AND descripcion = 'Pendiente';
END;
GO

-- 2. Crear Logins y Usuarios de prueba
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'usuario_encargado')
    CREATE LOGIN usuario_encargado WITH PASSWORD = 'Encargado123*';
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usuario_encargado')
    CREATE USER usuario_encargado FOR LOGIN usuario_encargado;

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'usuario_cajero')
    CREATE LOGIN usuario_cajero WITH PASSWORD = 'Cajero123*';
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usuario_cajero')
    CREATE USER usuario_cajero FOR LOGIN usuario_cajero;

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'usuario_cocinero_ricardo')
    CREATE LOGIN usuario_cocinero_ricardo WITH PASSWORD = 'Cocina123*';
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usuario_cocinero_ricardo')
    CREATE USER usuario_cocinero_ricardo FOR LOGIN usuario_cocinero_ricardo;

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'usuario_repartidor_andres')
    CREATE LOGIN usuario_repartidor_andres WITH PASSWORD = 'Reparto123*';
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usuario_repartidor_andres')
    CREATE USER usuario_repartidor_andres FOR LOGIN usuario_repartidor_andres;

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'usuario_invitado_sin_rol')
    CREATE LOGIN usuario_invitado_sin_rol WITH PASSWORD = 'Invitado123*';
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'usuario_invitado_sin_rol')
    CREATE USER usuario_invitado_sin_rol FOR LOGIN usuario_invitado_sin_rol;
GO

-- 3. Otorgar permisos de suplantaci�n para la prueba
GRANT IMPERSONATE ON USER::usuario_encargado TO [dbo];
GRANT IMPERSONATE ON USER::usuario_cajero TO [dbo];
GRANT IMPERSONATE ON USER::usuario_cocinero_ricardo TO [dbo];
GRANT IMPERSONATE ON USER::usuario_repartidor_andres TO [dbo];
GRANT IMPERSONATE ON USER::usuario_invitado_sin_rol TO [dbo];
GO

-- 4. Asignar rol db_owner al encargado
EXEC sp_addrolemember 'db_owner', 'usuario_encargado';
GO

-- 5. Permisos directos al cajero
GRANT SELECT ON dbo.Pago TO usuario_cajero;
GRANT SELECT ON dbo.EstadoPago TO usuario_cajero;
GRANT EXECUTE ON dbo.sp_ConfirmarCobroPendiente TO usuario_cajero;
GO

-- 6. Crear roles de negocio y asignar permisos
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_cocina_preparacion')
    CREATE ROLE rol_cocina_preparacion;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_logistica_reparto')
    CREATE ROLE rol_logistica_reparto;
GO

GRANT SELECT ON dbo.Producto TO rol_cocina_preparacion;
GRANT SELECT ON dbo.Categoria TO rol_cocina_preparacion;
GRANT SELECT ON dbo.detalle_Pedido TO rol_cocina_preparacion;

GRANT SELECT ON dbo.Pedido TO rol_logistica_reparto;
GRANT SELECT ON dbo.Cliente TO rol_logistica_reparto;
GRANT SELECT ON dbo.Persona TO rol_logistica_reparto;
GO

EXEC sp_addrolemember 'rol_cocina_preparacion', 'usuario_cocinero_ricardo';
EXEC sp_addrolemember 'rol_logistica_reparto', 'usuario_repartidor_andres';
GO


-- PARTE 2: PRUEBAS Y COMPROBACIONES DE SEGURIDAD


-- COMPROBACION 1: Intento de UPDATE directo con el Cajero (ERROR esperado en rojo)
EXECUTE AS USER = 'usuario_cajero';
UPDATE dbo.EstadoPago SET descripcion = 'Aprobado' WHERE id_pago = 1;
REVERT;
GO

-- COMPROBACION 2: Ejecucion autorizada del SP con el Cajero (EXITO)
EXECUTE AS USER = 'usuario_cajero';
EXEC dbo.sp_ConfirmarCobroPendiente @id_pago = 1;
REVERT;
GO

-- COMPROBACION 3: Permisos del Rol de Cocina (Producto EXITO, Pago ERROR)
EXECUTE AS USER = 'usuario_cocinero_ricardo';
SELECT * FROM dbo.Producto; -- Muestra grilla
SELECT * FROM dbo.Pago;     -- Muestra error en rojo
REVERT;
GO