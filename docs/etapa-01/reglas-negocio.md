**Base de datos I**  
**Grupo 47**

**Tomasella Tiago 46.922.473**  
**Matteo Federico 44.683.505**  
**Gomez Axel Joel 46.515.933**  
**Galeano Roman Agustin 46.074.425**  
**Sardi Gustavo Ariel 46.316.982**

**Reglas de negocio**

**RN01**: Para cada cliente, el sistema debe registrar un código único como identificador, junto con su nombre, apellido, DNI, dirección, localidad y número de contacto

**RN02**: Se requiere almacenar información de cada opción en el menú, incluyendo un código único de identificación, su descripción, el precio al que se vende

**RN03**: Cada transacción de compra debe ser almacenada en la base de datos detallando el día y fecha en que se efectuó, especificando también cuántas unidades de cada producto se vendieron en esa operación

**RN04**: Al registrarse cada transacción, el sistema debe almacenar de forma permanente el precio unitario vigente del producto en el detalle de la venta, garantizando que futuras modificaciones en los precios del menú no alteren los montos históricos ya facturados

**RN05**: Cada producto del menú debe contar con un registro de existencias (stock disponible) y un umbral de stock mínimo; el sistema descontará automáticamente las unidades vendidas tras confirmarse la operación y bloqueará la venta de aquellos ítems cuyo stock sea insuficiente

**RN06**: Cada venta debe registrar el o los métodos de pago utilizados (efectivo, transferencia bancaria, QR/billetera virtual o tarjeta de débito/crédito), junto con el monto abonado y, en caso de operaciones electrónicas, el número de comprobante o referencia de la transacción

**RN07**: En caso de que una transacción confirmada sea anulada o cancelada antes de su entrega, el sistema debe registrar el motivo de la cancelación y reintegrar de manera automática al stock las cantidades correspondientes a los productos de dicha orden  
