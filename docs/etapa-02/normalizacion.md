La evolución entre el primer y el segundo Diagrama Entidad-Relación (DER) refleja un proceso de normalización enfocado en eliminar redundancias, garantizar la atomicidad de los datos y desacoplar las dependencias funcionales del sistema.

**1FN (Primera Forma Normal: Atomicidad y eliminación de grupos repetitivos)**

* **Estructuración del detalle:** Se mantiene la descomposición de la compra mediante la entidad **detalle\_Pedido**, impidiendo el uso de listas o campos multivaluados (como almacenar múltiples productos dentro de un mismo registro de **Pedido**).  
* **Atributos atómicos e identificadores:** En la Parte 2 se agrega el atributo **dni** a la estructura de datos personales, garantizando que cada valor en el dominio de la entidad sea indivisible y unívoco por cada registro.

**2FN (Segunda Forma Normal: Eliminación de dependencias parciales)**

* **Dependencia completa en claves compuestas:** En **detalle\_Pedido,** atributos como **cantidad, precio\_unit y subtotal** dependen totalmente de la clave que combina la orden y el ítem (o **id\_detalle**). Ningún atributo no clave depende únicamente de **id\_pedido** o únicamente de **id\_producto**.  
* **Aislamiento de identificadores de rol:** En la Parte 2 se definen claves primarias específicas para los roles operativos (**id\_r`epartidor`** y **`id_cocinero`**), asegurando que las interacciones con **Pedido y Producto** dependan exclusivamente del ID propio de cada entidad y no de un atributo parcial.

**3FN (Tercera Forma Normal: Eliminación de dependencias transitivas)**

* **Desacoplamiento de estados (EstadoPedido y EstadoPago):** En la Parte 1, **Pedido** y **Pago** incluyeron un atributo simple **`estado`** (texto). En la Parte 2 se normalizan creando las entidades independientes **EstadoPedid`o`** (**id\_estado\_pedido**, **descripcion**) y **EstadoPago** (**id\_estado\_pago, descripcion**). De este modo, las descripciones del estado dependen únicamente de su propia clave primaria de catálogo y no transitivamente del ID de un pedido o pago.  
* **Generalización de Persona (Especialización/Herencia):** En la Parte 1, los atributos de identidad (**nombre**, **apellido**, **email**, **telefono**, **direccion**) residían directamente dentro de **`Cliente`**. En la Parte 2, para evitar dependencias transitivas y duplicación al integrar cocineros y repartidores, estos atributos se centralizan en la entidad **`Persona`**. Las entidades **`Cliente`**, **`Repartidor`** y **`Cocinero`** heredan de **`Persona`**, logrando que ningún atributo descriptivo de una persona dependa indirectamente del rol que cumple.

