\# Investigación Técnica: Transacciones y Propiedades ACID en SQL Server

\#\# 1\. Fundamentos Teóricos  
Una \*\*transacción\*\* en SQL Server es un conjunto de una o más operaciones de base de datos que se ejecutan como una unidad lógica de trabajo. Para garantizar la integridad de los datos, toda transacción debe cumplir rigurosamente con las propiedades \*\*ACID\*\*:

\* \*\*Atomicidad (Atomicity):\*\* Principio de "todo o nada". O se aplican con éxito todas las instrucciones de la transacción o se revierten por completo (\*Rollback\*), sin dejar estados intermedios.  
\* \*\*Consistencia (Consistency):\*\* Garantiza que la base de datos pase de un estado válido a otro estado válido, respetando todas las restricciones de integridad (\`PRIMARY KEY\`, \`FOREIGN KEY\`, \`CHECK\`, etc.).  
\* \*\*Aislamiento (Isolation):\*\* Asegura que los cambios realizados por una transacción no sean visibles para otras transacciones concurrentes hasta que se hayan confirmado (\*Commit\*).  
\* \*\*Durabilidad (Durability):\*\* Una vez que una transacción ha sido confirmada, sus efectos son permanentes en la base de datos y persistirán incluso ante fallos del sistema o cortes de energía.

\#\# 2\. Caso de Uso Aplicado al Proyecto  
En el sistema del restaurante (\`ProyectoBD1\`), el proceso de \*\*Alta de Pedido y Descuento de Stock\*\* representa una operación crítica que requiere control transaccional estricto.

\#\#\# Diagrama del Flujo de Control

\`\`\`text  
\[Inicio Transacción\] \---\> \[Insertar Cabecera de Pedido\]   
                              \|  
                              v  
                   \[Descontar Stock en Inventario\]  
                              \|  
                              v  
                   ¿Stock resultante \< 0?  
                       /          \\  
                (Sí)  /            \\ (No)  
                     v              v  
            \[ROLLBACK\]        \[COMMIT\]  
         (Revertir todo)    (Guardar cambios)  
