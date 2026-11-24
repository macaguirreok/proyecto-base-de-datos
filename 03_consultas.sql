
/*

PROYECTO UNIVERSIDAD - MYSQL
ARCHIVO 03: CONSULTAS SQL


Este archivo contiene consultas para recuperar y analizar
información de la base de datos.

Incluye:
- SELECT
- WHERE
- ORDER BY
- INNER JOIN
- LEFT JOIN
- GROUP BY
- Funciones de agregación
- Vistas (VIEW)
*/

USE universidad_mejoras;


-- =======================================================
-- 1. CONSULTAS BÁSICAS
-- =======================================================

-- Mostrar todos los profesores.
SELECT * FROM profesores;


-- Mostrar todos los alumnos.
SELECT * FROM alumnos;


-- Mostrar todos los alumnos mayores de 25 años.
SELECT *
FROM alumnos
WHERE edad > 25;


-- Mostrar las materias ordenadas alfabéticamente.
SELECT *
FROM materias
ORDER BY nombre ASC;


-- =======================================================
-- 2. CONSULTAS CON JOIN
-- =======================================================

-- Mostrar cada materia junto con el nombre de su profesor.

SELECT
    m.id_materia,
    m.nombre AS materia,
    p.nombre AS profesor
FROM materias m
INNER JOIN profesores p
ON m.id_profesor = p.id_profesor;


-- Mostrar los alumnos inscriptos y las materias que cursan.

SELECT
    a.nombre AS alumno,
    m.nombre AS materia,
    i.anio_cursada
FROM alumnos a
INNER JOIN inscripciones i
ON a.id_alumno = i.id_alumno
INNER JOIN materias m
ON i.id_materia = m.id_materia;


-- Mostrar las notas de cada alumno y la materia correspondiente.

SELECT
    a.nombre AS alumno,
    m.nombre AS materia,
    n.nota,
    n.fecha
FROM notas n
INNER JOIN inscripciones i
ON n.id_inscripcion = i.id_inscripcion
INNER JOIN alumnos a
ON i.id_alumno = a.id_alumno
INNER JOIN materias m
ON i.id_materia = m.id_materia;


-- =======================================================
-- 3. CONSULTAS CON LEFT JOIN
-- =======================================================

-- Mostrar todos los alumnos, incluso si no tienen inscripciones.

SELECT
    a.nombre AS alumno,
    m.nombre AS materia
FROM alumnos a
LEFT JOIN inscripciones i
ON a.id_alumno = i.id_alumno
LEFT JOIN materias m
ON i.id_materia = m.id_materia;


-- Mostrar todas las materias, incluso si no tienen inscriptos.

SELECT
    m.nombre AS materia,
    a.nombre AS alumno
FROM materias m
LEFT JOIN inscripciones i
ON m.id_materia = i.id_materia
LEFT JOIN alumnos a
ON i.id_alumno = a.id_alumno;


-- =======================================================
-- 4. FUNCIONES DE AGREGACIÓN Y GROUP BY
-- =======================================================

-- Calcular el promedio de notas de cada inscripción.

SELECT
    id_inscripcion,
    AVG(nota) AS promedio
FROM notas
GROUP BY id_inscripcion;


-- Contar cuántos alumnos están inscriptos en cada materia.

SELECT
    m.nombre AS materia,
    COUNT(i.id_alumno) AS cantidad_alumnos
FROM materias m
LEFT JOIN inscripciones i
ON m.id_materia = i.id_materia
GROUP BY m.id_materia, m.nombre;


-- Mostrar el promedio general de todas las notas.

SELECT AVG(nota) AS promedio_general
FROM notas;


-- =======================================================
-- 5. VISTAS (VIEW)
-- =======================================================

/*
Las vistas permiten guardar consultas SQL para reutilizarlas
como si fueran tablas virtuales.

CREATE OR REPLACE VIEW:
Crea la vista o reemplaza su definición si ya existe.
*/


-- VISTA: ALUMNOS Y MATERIAS

CREATE OR REPLACE VIEW vista_alumnos_materias AS
SELECT
    a.id_alumno,
    a.nombre AS alumno,
    m.nombre AS materia,
    i.anio_cursada
FROM alumnos a
INNER JOIN inscripciones i
ON a.id_alumno = i.id_alumno
INNER JOIN materias m
ON i.id_materia = m.id_materia;


-- Consultar la vista.
SELECT * FROM vista_alumnos_materias;


-- VISTA: PROFESORES Y MATERIAS

CREATE OR REPLACE VIEW vista_profesores_materias AS
SELECT
    p.nombre AS profesor,
    m.nombre AS materia
FROM profesores p
INNER JOIN materias m
ON p.id_profesor = m.id_profesor;


-- Consultar la vista.
SELECT * FROM vista_profesores_materias;


/*
=========================================================
FIN DEL ARCHIVO DE CONSULTAS
=========================================================
*/
