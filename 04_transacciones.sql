-- TRANSACCIONES

-- En este proyecto tenemos una transacción:
-- Se crea una inscripción y se registra el evento en un historial.
-- Las dos operaciones deben hacerse juntas.
-- Si una falla, no se debe confirmar ninguna.

USE universidad_mejoras;


-- Consultamos las tablas antes de realizar las pruebas.

SELECT * FROM alumnos;

SELECT * FROM materias;

SELECT * FROM inscripciones;

SELECT * FROM historial_inscripciones;


-- ==========================================
-- 1. TRANSACCIÓN EXITOSA (COMMIT)
-- ==========================================

START TRANSACTION;

-- Creamos una nueva inscripción.

INSERT INTO inscripciones(
    id_alumno,
    id_materia,
    fecha,
    anio_cursada
)
VALUES(
    1,
    2,
    CURDATE(),
    2027
);

-- Registramos la inscripción en el historial.

INSERT INTO historial_inscripciones(
    id_alumno,
    id_materia,
    fecha,
    accion
)
VALUES(
    1,
    2,
    NOW(),
    'Nueva inscripción'
);

-- Confirmamos ambas operaciones.

COMMIT;

--IMPORTANTE:
-- En los datos de ejemplo están cargados el alumno 1 y la materia 2 del año 2026
-- Si cargamos este ejemplo que es del 2027 la bd nos permite guardarlo por ser años distintos
-- Si cargamos NUEVAMENTE este ejemplo para intentar tener el alumno 1 y materia 2
--otra vez en el año 2027 ahí si nos da error, gracias a la restricción que pusimos
--en la tabla inscripciones al crearla.


-- Verificamos que se hayan guardado los dos registros.

SELECT * FROM inscripciones;

SELECT * FROM historial_inscripciones;


-- ==========================================
-- 2. TRANSACCIÓN FALLIDA (ROLLBACK)
-- ==========================================

START TRANSACTION;

-- Esta inscripción es válida.

INSERT INTO inscripciones(
    id_alumno,
    id_materia,
    fecha,
    anio_cursada
)
VALUES(
    1,
    2,
    CURDATE(),
    2029
);

-- Este registro fallará porque el alumno 999 no existe.
-- La clave foránea impide registrar un alumno inexistente.

INSERT INTO historial_inscripciones(
    id_alumno,
    id_materia,
    fecha,
    accion
)
VALUES(
    999,
    2,
    NOW(),
    'Nueva inscripción'
);

-- Si la operación anterior falla, ejecutamos ROLLBACK
-- para deshacer también la inscripción creada anteriormente.

--La elección de poner el número 999 es solo para mostrar como 
--no se puede realizar la transacción exitosa, y se recurre al rollback.

ROLLBACK;


-- Verificamos que la inscripción del año 2029
-- tampoco haya quedado guardada.

SELECT * FROM inscripciones;

SELECT * FROM historial_inscripciones;