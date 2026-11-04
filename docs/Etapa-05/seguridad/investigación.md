# **ETAPA V: IMPLEMENTACIÓN DE TEMAS TÉCNICOS**

## **TEMA 4: SEGURIDAD (MANEJO DE PERMISOS A NIVEL DE USUARIOS Y ROLES EN SQL SERVER)**

### **1\. Definición y Objetivo**

**Definición:** Es el mecanismo de control de accesos de SQL Server que administra qué inicios de sesión (*Logins*), usuarios de base de datos (*Users*) y roles (*Roles*) pueden consultar, modificar o ejecutar objetos específicos dentro del motor de base de datos.

**Objetivo:** Implementar el **Principio de Mínimo Privilegio** en el Sistema de Hamburguesería, separando adecuadamente las responsabilidades y permisos entre gerencia, cajeros de cobro, personal de cocina y repartidores de delivery.

### **2\. Ventajas y Aplicaciones**

**Protección de Datos Financieros:** Protege la recaudación, los saldos de caja y los estados de pago contra modificaciones directas por fuera de los procedimientos almacenados autorizados.

**Segmentación Operativa:** Permite asignar responsabilidades estrictamente ligadas al puesto de trabajo (Cocina, Caja, Logística/Reparto).

**Mantenibilidad y Escalabilidad:** Simplifica la administración asignando permisos a roles reutilizables del negocio en lugar de configurar usuario por usuario.

**Encapsulamiento mediante Stored Procedures:** Permite otorgar permisos de ejecución (`EXECUTE`) sobre un procedimiento almacenado a un perfil (como el cajero) sin darle permisos directos de inserción, actualización o borrado (`UPDATE`/`DELETE`) sobre las tablas base.

### **3\. Casos Concretos Aplicados al Sistema de Hamburguesería**

En lugar de ejemplos genéricos de la guía, el esquema de seguridad se basa en los roles operativos reales del local gastronómico:

**Procedimiento Encapsulado de Caja (`dbo.sp_ConfirmarCobroPendiente`):** Permite que el perfil de caja apruebe un pago pendiente sin requerir permisos directos de `UPDATE` sobre las tablas `EstadoPago` o `Pago`.

**Parte 1 (Permisos a Nivel de Usuarios):**

**`usuario_encargado`:** Asignado al rol `db_owner` (control total sobre el local).

**`usuario_cajero`:** Posee únicamente permisos de consulta (`SELECT`) sobre `dbo.Pago` y `dbo.EstadoPago`, junto con permiso de ejecución (`EXECUTE`) sobre `dbo.sp_ConfirmarCobroPendiente`. No puede modificar tablas directamente.

**Parte 2 (Permisos a Nivel de Roles del Negocio):**

**`rol_cocina_preparacion`:** Permiso `SELECT` sobre `dbo.detalle_Pedido`, `dbo.Producto` y `dbo.Categoria` para visualizar las comandas a preparar, sin acceso a datos financieros o de pagos.

**`rol_logistica_reparto`:** Permiso `SELECT` sobre `dbo.Pedido`, `dbo.Cliente` y `dbo.Persona` para consultar nombres, teléfonos y direcciones de envío de los clientes.

**Prueba de Accesos:** Se evalúan los accesos comparando a `usuario_cocinero_ricardo` (rol cocina), `usuario_repartidor_andres` (rol logística) y `usuario_invitado_sin_rol` (sin permisos).

### **4\. Caso Concreto Aplicado al Sistema de Ventas de la Hamburguesería**

En nuestro sistema de ventas se diseñó un esquema basado en los puestos operativos reales del local gastronómico:

1. **Procedimiento Encapsulado de Caja (`dbo.sp_ConfirmarCobroPendiente`):** Permite que el perfil de caja apruebe un pago pendiente en la tabla `EstadoPago` sin requerir permisos directos de `UPDATE` sobre las tablas `EstadoPago` o `Pago`.  
2. **Permisos a Nivel de Usuarios:**

**`usuario_encargado`:** Asignado al rol administrativo `db_owner` (control total sobre el local).

**`usuario_cajero`:** Posee únicamente permisos de consulta (`SELECT`) sobre `dbo.Pago` y `dbo.EstadoPago`, junto con permiso de ejecución (`EXECUTE`) sobre `dbo.sp_ConfirmarCobroPendiente`. No puede modificar ni eliminar filas de las tablas directamente.

3. **Permisos a Nivel de Roles de Negocio:**

**`rol_cocina_preparacion`:** Posee permiso `SELECT` sobre `dbo.detalle_Pedido`, `dbo.Producto` y `dbo.Categoria` para visualizar las comandas a preparar, manteniendo bloqueado el acceso a la recaudación (`Pago`).

**`rol_logistica_reparto`:** Posee permiso `SELECT` sobre `dbo.Pedido`, `dbo.Cliente` y `dbo.Persona` para consultar nombres, teléfonos y direcciones de entrega de los clientes.

**Prueba de Accesos:** Se evalúan los accesos comparando a `usuario_cocinero_ricardo` (rol cocina), `usuario_repartidor_andres` (rol logística) y `usuario_invitado_sin_rol` (sin rol asignado).

### **5\. Script de Demostración y Resultados Obtenidos**

El código ejecutable completo se encuentra en Scripts.sql y sus respectivos resultados en la carpeta evidencias.

Matriz Resumen de Resultados Obtenidos:

| Prueba Realizada | Usuario Evaluado | Permiso / Mecanismo Aplicado | Resultado Esperado / Obtenido |
| :---- | :---- | :---- | :---- |
| **UPDATE directo sobre EstadoPago** | usuario\_cajero | Sin permiso DML directo | **Acceso denegado** (Mens. 229: Permiso UPDATE denegado). |
| **EXEC sp\_ConfirmarCobroPendiente** | usuario\_cajero | GRANT EXECUTE sobre SP | **Correcto** (Operación completada exitosamente). |
| **SELECT sobre Producto** | usuario\_cocinero\_ricardo | Vía rol\_cocina\_preparacion | **Correcto** (Devuelve filas de la tabla Producto). |
| **SELECT sobre Pago** | usuario\_cocinero\_ricardo | Sin acceso a finanzas | **Acceso denegado** (Mens. 229: Permiso SELECT denegado). |
| **SELECT sobre Persona** | usuario\_repartidor\_andres | Vía rol\_logistica\_reparto | **Correcto** (Consulta direcciones de clientes). |
| **SELECT sobre Producto** | usuario\_invitado\_sin\_rol | Sin rol asignado | **Acceso denegado** (Bloqueo general del motor). |

