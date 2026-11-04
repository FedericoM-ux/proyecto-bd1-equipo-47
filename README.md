# Sistema de Gestión de Base de Datos - Hamburguesería

Bienvenido al repositorio oficial del proyecto **Hamburguesería** desarrollado para la materia **Bases de Datos I**. Este repositorio contiene la documentación completa de las 5 etapas del proyecto, scripts DDL/DML, consultas de negocio, informes técnicos de la Etapa V y sus respectivas evidencias de ejecución.

---

## Información del Proyecto

* **Materia:** Bases de Datos I
* **Equipo:** 47
* **Motor de Base de Datos:** Microsoft SQL Server 2008 R2 / Express
* **Base de Datos:** `Hamburgueseria`

---

## Resumen de Etapas del Proyecto

* **Etapa I:** Requerimientos y Dominio del Negocio (Alcance, decisiones de diseño, descripción del caso y reglas de negocio).
* **Etapa II:** Modelado Conceptual y Lógico (DER en notación Chen, modelo relacional en formato gráfico y texto, y normalización a 3FN).
* **Etapa III:** Implementación Física (Scripts DDL de creación de tablas/restricciones y DML de carga inicial).
* **Etapa IV:** Consultas y Casos de Uso (Comprobantes de venta, casos de prueba, consultas avanzadas e informes de ventas).
* **Etapa V:** Implementación de Temas Técnicos Avanzados (Optimización de consultas e índices, procedimientos y funciones almacenadas, seguridad, transacciones, y triggers de auditoría).

---

## Estructura del Repositorio

```text
/
├── docs/
│   ├── etapa-01/                             # Requerimientos y reglas de negocio
│   │   ├── alcance.md
│   │   ├── decisiones-diseño.md
│   │   ├── descripcion-caso.md
│   │   └── reglas-negocio.md
│   │
│   ├── etapa-02/                             # Modelado conceptual, lógico y normalización
│   │   └── der/
│   │       ├── der.png
│   │       ├── modelo-relacional-imagen.png
│   │       ├── modelo-relacional.md
│   │       └── normalizacion.md
│   │
│   ├── etapa-03/                             # Scripts DDL y DML
│   │   ├── script_ddl.sql
│   │   └── script_dml.sql
│   │
│   ├── etapa-04/                             # Consultas y reportes de ventas
│   │   ├── Comprobante-ventas
│   │   ├── casos-prueba.md
│   │   ├── consulta-avanzada.md
│   │   └── informe-ventas.md
│   │
│   └── etapa-05/                             # Temas técnicos avanzados
│       ├── optimizacion_consultas/
│       │   ├── evidencias/
│       │   ├── investigacion.md
│       │   └── scripts.sql
│       ├── procedimientos_funciones/
│       │   ├── evidencias/
│       │   └── investigacion.md
│       ├── seguridad/                        # Tema 4: Seguridad y Permisos
│       │   ├── evidencias/                   # Capturas de comprobación (Mens. 229, SP)
│       │   ├── investigación.md              # Informe del Tema 4
│       │   ├── investigación.md
│       │   └── Scripts.sql                   # Script DCL y pruebas EXECUTE AS
│       ├── transacciones/
│       │   ├── evidencias/
│       │   ├── investigacion.md
│       │   └── scripts.sql
│       └── triggers_auditoria/
│           ├── evidencias/
│           └── scripts.sql
│
├── sql/                                      # Archivos SQL consolidados
│   ├── consultas
│   ├── ddl
│   ├── dml
│   └── tecnico
│
└── README.md                                 # Presentación principal del repositorio

**Carga Base:** Ejecutar en SQL Server Management Studio los scripts `script_ddl.sql` y `script_dml.sql` ubicados en `docs/etapa-03/` para crear la base de datos `Hamburgueseria` y sus tablas con datos de prueba.
