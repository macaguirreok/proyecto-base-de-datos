-- ==========================================
-- PRUEBAS DE INTEGRIDAD REFERENCIAL
-- ==========================================

USE universidad_mejoras;

-- IMPORTANTE:
-- Ejecutar cada prueba por separado.
-- Las pruebas que eliminan o modifican registros
-- pueden alterar los datos originales.


-- ==========================================
-- 1. ON DELETE RESTRICT
-- ==========================================

-- No permite eliminar un profesor que tiene materias asociadas.

DELETE FROM profesores
WHERE id_profesor = 7;


-- No permite eliminar una materia que tiene inscripciones.

DELETE FROM materias
WHERE id_materia = 8;

-- Si permite eliminar una materia que NO tiene inscripciones:

--Antes:
SELECT * FROM materias
WHERE id_materia = 11;

DELETE FROM materias
WHERE id_materia = 11;

--Después:

SELECT * FROM materias
WHERE id_materia = 11;

-- ==========================================
-- 2. ON DELETE CASCADE
-- ==========================================

-- CASO 1: Al eliminar un alumno, se eliminan
-- sus inscripciones y las notas relacionadas.

-- ANTES
SELECT * FROM alumnos
WHERE id_alumno = 2;

SELECT * FROM inscripciones
WHERE id_alumno = 2;

SELECT n.*
FROM notas n
INNER JOIN inscripciones i
    ON n.id_inscripcion = i.id_inscripcion
WHERE i.id_alumno = 2;



-- DELETE
DELETE FROM alumnos
WHERE id_alumno = 2;

-- DESPUÉS
SELECT * FROM alumnos
WHERE id_alumno = 2;

SELECT * FROM inscripciones
WHERE id_alumno = 2;

SELECT n.*
FROM notas n
INNER JOIN inscripciones i
    ON n.id_inscripcion = i.id_inscripcion
WHERE i.id_alumno = 2;


-- CASO 2: Al eliminar una inscripción,
-- se eliminan automáticamente sus notas.

-- ANTES
SELECT * FROM inscripciones
WHERE id_inscripcion = 1;

SELECT * FROM notas
WHERE id_inscripcion = 1;

-- DELETE
DELETE FROM inscripciones
WHERE id_inscripcion = 1;

-- DESPUÉS
SELECT * FROM inscripciones
WHERE id_inscripcion = 1;

SELECT * FROM notas
WHERE id_inscripcion = 1;

-- ==========================================
-- 3. ON UPDATE CASCADE
-- ==========================================

-- Al modificar el ID de un profesor,
-- se actualiza automáticamente en materias.

SELECT *
FROM profesores
WHERE id_profesor = 1;

UPDATE profesores
SET id_profesor = 12
WHERE id_profesor = 1;

--Ahora Juan Pérez tiene un nuevo ID:
SELECT *
FROM profesores
WHERE id_profesor = 12;

--Si ejecutamos el primer select, no nos devuelve nada
--porque ahora el id de Juan Pérez es el 12:
SELECT *
FROM profesores
WHERE id_profesor = 1;

-- ==========================================
-- 4. NO ACTION (COMPORTAMIENTO PREDETERMINADO)
-- ==========================================

-- No permite actualizar el ID de un alumno
-- si existen registros relacionados en inscripciones
-- o historial_inscripciones.

-- ANTES
SELECT * FROM alumnos
WHERE id_alumno = 1;

-- Verificamos que el ID 99 no exista.
SELECT * FROM alumnos
WHERE id_alumno = 99;

-- ACTUALIZAR (debe fallar por las claves foráneas).
UPDATE alumnos
SET id_alumno = 99
WHERE id_alumno = 1;


-- No permite actualizar el ID de una inscripción
-- si existen notas asociadas.

SELECT * FROM notas
WHERE id_inscripcion = 10;

-- La nota con id 10 se corresponde con la inscripción de id 10.

UPDATE inscripciones
SET id_inscripcion = 25
WHERE id_inscripcion = 10;