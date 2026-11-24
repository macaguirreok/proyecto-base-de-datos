# Universidad – Base de Datos Relacional | MySQL

## Descripción del proyecto

Proyecto de diseño, desarrollo y gestión de una base de datos relacional para una institución universitaria.

El sistema permite administrar información de profesores, alumnos, materias, inscripciones y calificaciones, incorporando mecanismos para garantizar la integridad de los datos y automatizar determinadas operaciones.

Esta versión representa una evolución de un proyecto anterior, incorporando mejoras en la organización del esquema, restricciones de integridad referencial, transacciones y triggers para la validación y auditoría de operaciones.

El objetivo es aplicar conocimientos de SQL y diseño de bases de datos mediante un escenario práctico que permita trabajar tanto con la manipulación de información como con la consistencia y el control de los datos.

## Tecnologías y conceptos utilizados

- MySQL 8.0.16 o superior.
- SQL (DDL y DML).
- Modelado de bases de datos relacionales.
- Claves primarias y foráneas.
- AUTO_INCREMENT.
- Restricciones NOT NULL, CHECK y UNIQUE.
- Integridad referencial.
- INNER JOIN y LEFT JOIN.
- GROUP BY y funciones de agregación.
- Vistas (VIEW).
- Transacciones (START TRANSACTION, COMMIT y ROLLBACK).
- Triggers (BEFORE y AFTER).
- Auditoría de operaciones.

## 1. Estructura de la base de datos

La base de datos `universidad_mejoras` está compuesta por siete tablas:

| Tabla | Descripción |
|---|---|
| `profesores` | Almacena los datos de los profesores. |
| `alumnos` | Almacena los datos de los alumnos. |
| `materias` | Registra las materias y sus profesores responsables. |
| `inscripciones` | Relaciona alumnos con materias y registra la fecha y el año académico. |
| `notas` | Almacena las calificaciones correspondientes a cada inscripción. |
| `historial_inscripciones` | Registra eventos relacionados con las inscripciones. |
| `historial_notas` | Conserva información sobre inserciones, modificaciones y eliminaciones de notas. |

### Relaciones entre tablas

- Un profesor puede tener asignadas varias materias.
- Una materia pertenece a un profesor.
- Un alumno puede realizar varias inscripciones.
- Una materia puede tener varios alumnos inscriptos.
- Una inscripción puede tener varias notas.
- El historial de inscripciones mantiene referencias a alumnos y materias.
- El historial de notas funciona de manera independiente de las tablas operativas, conservando copias de los datos relevantes de las operaciones registradas.

### Datos iniciales

El proyecto incluye un conjunto de datos de prueba para trabajar con las consultas y comprobar las restricciones.

| Tabla | Registros iniciales |
|---|---:|
| Profesores | 11 |
| Alumnos | 10 |
| Materias | 11 |
| Inscripciones | 15 |
| Notas | 15 |

Las tablas de historial comienzan sin registros y se completan a medida que se realizan las operaciones correspondientes.

## 2. Restricciones de integridad

Las tablas se crean junto con sus respectivas restricciones, concentrando la definición de la estructura y las reglas de integridad en un único archivo.

### Claves primarias

Todas las tablas cuentan con identificadores propios mediante PRIMARY KEY y AUTO_INCREMENT.

### Restricciones CHECK

Se implementan validaciones para controlar los valores ingresados:

- La edad de los alumnos debe ser mayor a 0 y menor o igual a 150.
- Las calificaciones deben encontrarse entre 1 y 10.

### Restricción UNIQUE

Se incorpora una restricción compuesta en la tabla `inscripciones`:

```sql
UNIQUE(id_alumno, id_materia, anio_cursada)
```

Esta restricción evita que un mismo alumno pueda registrar más de una inscripción a la misma materia durante el mismo año académico.

### Claves foráneas y acciones referenciales

Se implementan diferentes comportamientos para controlar las operaciones sobre registros relacionados.

**ON DELETE RESTRICT**

Impide eliminar profesores que tengan materias asociadas y materias que tengan inscripciones relacionadas.

**ON DELETE CASCADE**

Permite automatizar eliminaciones relacionadas:

- Al eliminar un alumno, se eliminan sus inscripciones.
- Al eliminar una inscripción, se eliminan las notas asociadas.
- La eliminación en cascada puede propagarse desde el alumno hasta sus notas.

**ON UPDATE CASCADE**

Al modificar el identificador de un profesor, se actualiza automáticamente la referencia correspondiente en la tabla `materias`.

**NO ACTION**

Se utiliza el comportamiento predeterminado de las claves foráneas para impedir modificaciones o eliminaciones que dejen referencias inconsistentes.

En MySQL con InnoDB, NO ACTION tiene el mismo comportamiento que RESTRICT.

## 3. Consultas SQL

Se desarrollan consultas para recuperar y analizar información de las distintas tablas.

### Consultas básicas

- SELECT para recuperar registros.
- WHERE para aplicar filtros.
- ORDER BY para ordenar resultados.

### Consultas con JOIN

Se utilizan INNER JOIN para combinar información relacionada de diferentes tablas.

Ejemplos:

- Materias y sus profesores.
- Alumnos y las materias que cursan.
- Calificaciones asociadas a cada alumno y materia.

### Consultas con LEFT JOIN

Permiten recuperar registros principales incluso cuando no existen registros relacionados.

Ejemplos:

- Mostrar todos los alumnos, tengan o no inscripciones.
- Mostrar todas las materias, tengan o no alumnos inscriptos.

### Funciones de agregación y GROUP BY

Se utilizan COUNT y AVG para:

- Calcular promedios de notas por inscripción.
- Contar alumnos inscriptos en cada materia.
- Calcular el promedio general de calificaciones.

## 4. Vistas (VIEW)

Se crean dos vistas para reutilizar consultas frecuentes y facilitar la recuperación de información.

**vista_alumnos_materias**

Permite consultar los alumnos, las materias que cursan y el año académico correspondiente.

**vista_profesores_materias**

Permite consultar los profesores y las materias que tienen asignadas.

Se utiliza CREATE OR REPLACE VIEW para crear las vistas o actualizar sus definiciones.

## 5. Transacciones

Se implementan transacciones utilizando:

- START TRANSACTION
- COMMIT
- ROLLBACK

Se desarrollan dos escenarios para demostrar su funcionamiento.

**Transacción exitosa**

Se registra una nueva inscripción y, dentro de la misma transacción, se inserta el evento correspondiente en `historial_inscripciones`.

Ambas operaciones se confirman mediante COMMIT.

**Transacción fallida**

Se intenta registrar una inscripción válida y posteriormente un registro de historial con un alumno inexistente.

La clave foránea impide la segunda operación. Se utiliza ROLLBACK para deshacer las operaciones pendientes y evitar que la inscripción anterior quede confirmada de manera aislada.

Este ejemplo permite comprobar cómo las transacciones contribuyen a mantener la consistencia de operaciones relacionadas.

## 6. Triggers y auditoría

Se incorporan cuatro triggers para automatizar validaciones y registrar las operaciones realizadas sobre la tabla `notas`.

### BEFORE INSERT

**trg_before_insert_fecha_notas**

Se ejecuta antes de insertar una nueva calificación.

Consulta la fecha de inscripción correspondiente y compara ese valor con la fecha de la nota que se intenta registrar.

Si la fecha de la nota es anterior a la fecha de inscripción, genera una excepción mediante SIGNAL SQLSTATE '45000' y cancela la operación.

### AFTER INSERT

**trg_historial_notas_insert**

Se ejecuta después de insertar una nueva nota.

Recupera los datos relacionados del alumno y la materia, y registra automáticamente la operación en `historial_notas`.

### AFTER UPDATE

**trg_after_update_notas**

Se ejecuta después de modificar una nota.

Registra automáticamente la modificación en la tabla de auditoría, conservando la nueva calificación y los datos correspondientes al alumno y la materia.

### AFTER DELETE

**trg_after_delete_notas**

Se ejecuta después de eliminar una nota.

Utiliza OLD para recuperar los datos del registro eliminado y conservar su información en la tabla de auditoría.

De esta manera, es posible mantener un registro de las operaciones aunque la fila original ya no exista.

### Tabla de auditoría: historial_notas

Se crea una tabla independiente para conservar información sobre las operaciones realizadas en las calificaciones.

Registra:

- Fecha y hora de la operación.
- Nombre del alumno.
- Materia correspondiente.
- Calificación registrada.
- Tipo de acción: INSERT, UPDATE o DELETE.

La tabla no utiliza claves foráneas hacia las tablas operativas, permitiendo conservar la información registrada aunque el registro original sea modificado o eliminado.

Los registros se generan automáticamente mediante triggers, sin necesidad de realizar manualmente las inserciones en la tabla de auditoría.

### Historial de inscripciones

La tabla `historial_inscripciones` permite conservar eventos relacionados con las inscripciones.

Se utiliza en conjunto con transacciones para demostrar cómo registrar una operación y su correspondiente evento de historial dentro de una misma transacción.

A diferencia del historial de notas, mantiene claves foráneas hacia alumnos y materias.

## 7. Pruebas realizadas

El proyecto incluye archivos específicos para verificar el funcionamiento de las restricciones, las transacciones y los triggers.

### Pruebas de integridad referencial

Se comprueba:

- La restricción de eliminación de profesores con materias asociadas.
- La restricción de eliminación de materias con inscripciones.
- La eliminación de materias sin inscripciones.
- La eliminación en cascada de alumnos, inscripciones y notas.
- La eliminación en cascada de inscripciones y sus notas.
- La actualización en cascada de identificadores de profesores.
- La restricción de modificaciones cuando existen registros relacionados.

### Pruebas de triggers

Se comprueba:

- El rechazo de notas con fechas anteriores a la inscripción.
- El registro automático de nuevas calificaciones.
- El registro de modificaciones.
- El registro de eliminaciones.
- La conservación de información en la tabla de auditoría.

Las pruebas incluyen operaciones válidas y no válidas para verificar los distintos comportamientos de la base de datos.

## 8. Limitaciones conocidas

El proyecto está desarrollado con fines de aprendizaje y demostración de conceptos de bases de datos relacionales. Existen algunas limitaciones que pueden abordarse en futuras versiones.

### Validación de fechas

La validación de fechas se implementa mediante BEFORE INSERT.

Actualmente no existe una validación equivalente para las modificaciones realizadas mediante UPDATE.

Por lo tanto, una nota puede recibir una fecha anterior a su inscripción si se modifica después de haber sido insertada.

### Auditoría de eliminaciones en cascada

El trigger AFTER DELETE registra las eliminaciones directas realizadas sobre la tabla `notas`.

Sin embargo, MySQL no ejecuta triggers cuando las filas son eliminadas automáticamente como consecuencia de una acción ON DELETE CASCADE.

Por este motivo, las notas eliminadas indirectamente al borrar una inscripción o un alumno no quedan registradas mediante este trigger.

### Información histórica limitada

La tabla `historial_notas` conserva la calificación registrada en cada evento, pero no almacena el valor anterior y el nuevo de manera diferenciada.

Tampoco conserva el identificador original de la nota, el usuario responsable de la operación ni otros datos de contexto.

### Auditoría de inscripciones

El registro del historial de inscripciones se realiza mediante operaciones SQL incluidas en una transacción.

No se implementaron triggers específicos para automatizar todos los eventos sobre esa tabla.

Además, las claves foráneas de `historial_inscripciones` impiden eliminar alumnos o materias que tengan registros históricos relacionados.

### Pruebas de triggers

En el archivo de pruebas se utiliza CURDATE() para insertar una nota, mientras que las operaciones posteriores de UPDATE y DELETE utilizan una fecha fija correspondiente a uno de los registros iniciales.

Por lo tanto, esas operaciones no garantizan actuar sobre el mismo registro recién insertado. Los triggers se prueban individualmente, pero la secuencia no reproduce el ciclo completo sobre una única nota.

### Pruebas de integridad

Las pruebas incluyen operaciones diseñadas para generar errores intencionales.

Algunas operaciones modifican identificadores o eliminan registros, por lo que los resultados dependen del estado previo de la base de datos.

Se recomienda ejecutarlas individualmente sobre una instancia de prueba recién inicializada.

### Motor de almacenamiento

Los scripts no especifican explícitamente ENGINE=InnoDB en cada tabla.

Se recomienda comprobar que las tablas utilicen InnoDB, ya que las claves foráneas y las transacciones implementadas requieren un motor compatible.

### Reejecución de scripts

Los scripts están preparados para una primera ejecución sobre una base de datos nueva.

No incluyen una rutina completa de eliminación y reconstrucción automática del esquema y de todos los datos de prueba.

## 9. Mejoras incorporadas respecto de la versión anterior

Esta versión incorpora cambios y ampliaciones en el diseño y funcionamiento de la base de datos:

- Consolidación de la creación de todas las tablas en un único archivo.
- Definición de las restricciones directamente durante la creación de las tablas.
- Incorporación de restricciones CHECK para controlar edades y calificaciones.
- Incorporación de una restricción UNIQUE compuesta para evitar inscripciones duplicadas por año.
- Implementación de diferentes comportamientos de integridad referencial mediante ON DELETE y ON UPDATE.
- Incorporación de transacciones para agrupar operaciones relacionadas.
- Implementación de triggers para validar fechas y automatizar registros.
- Creación de una tabla independiente de auditoría para conservar las operaciones realizadas sobre las notas.
- Incorporación de pruebas específicas de integridad referencial y automatización.

## 10. Posibles mejoras futuras

A partir de las funcionalidades implementadas y las limitaciones identificadas, se consideran las siguientes oportunidades de evolución:

- Incorporar un trigger BEFORE UPDATE para validar las fechas de las notas también durante las modificaciones.
- Mejorar la auditoría almacenando el identificador original de cada nota.
- Registrar de manera diferenciada la calificación anterior y la nueva en las modificaciones.
- Incorporar información del usuario que realiza cada operación.
- Ampliar el registro de auditoría para contemplar eliminaciones en cascada mediante un mecanismo explícito de gestión de operaciones.
- Revisar el diseño de `historial_inscripciones` para permitir conservar información histórica independientemente de la existencia de los registros originales.
- Incorporar una estrategia de inicialización y restablecimiento de datos de prueba.

Estas mejoras quedan identificadas como posibles desarrollos posteriores y no forman parte de la implementación actual.

## 11. Organización de archivos

La estructura del repositorio se organiza en archivos SQL independientes, separados según su finalidad.

```text
universidad-mejoras/
│
├── 01_creacion_base_datos.sql
├── 02_datos_iniciales.sql
├── 03_consultas_y_vistas.sql
├── 04_transacciones.sql
├── 05_triggers.sql
├── 06_pruebas_triggers.sql
├── 07_pruebas_integridad.sql
│
└── README.md
```

## 12. Instalación y ejecución

### Requisitos

- MySQL 8.0.16 o superior.
- Un cliente para ejecutar consultas SQL.

### Orden recomendado de ejecución

1. Ejecutar `01_creacion_base_datos.sql` para crear la base de datos y sus tablas.
2. Ejecutar `02_datos_iniciales.sql` para cargar los registros de prueba.
3. Ejecutar `03_consultas_y_vistas.sql` para consultar información y crear las vistas.
4. Ejecutar `04_transacciones.sql` para probar COMMIT y ROLLBACK.
5. Ejecutar `05_triggers.sql` para crear los triggers.
6. Ejecutar `06_pruebas_triggers.sql` para verificar las automatizaciones.
7. Ejecutar `07_pruebas_integridad.sql` para comprobar las restricciones referenciales.

**Importante:** los nombres de archivos indicados corresponden a la organización propuesta. Si los archivos del repositorio utilizan otros nombres, se debe ajustar esta lista.

Algunas pruebas generan errores de manera intencional para demostrar las restricciones de la base de datos. Las operaciones de eliminación y modificación pueden alterar los registros originales.

Se recomienda trabajar sobre una instancia de prueba y ejecutar individualmente las operaciones que esperan generar errores.

## Objetivo de aprendizaje

Este proyecto busca demostrar la aplicación práctica de conocimientos de bases de datos relacionales mediante el diseño de una estructura académica, la implementación de relaciones y restricciones, la utilización de consultas SQL, el manejo de transacciones y la automatización de operaciones mediante triggers.

Además, incorpora un mecanismo de auditoría que permite conservar información sobre los cambios realizados en las calificaciones.

El desarrollo representa una evolución del proyecto inicial, incorporando nuevas herramientas y criterios de diseño para mejorar la integridad, organización y trazabilidad de los datos.
