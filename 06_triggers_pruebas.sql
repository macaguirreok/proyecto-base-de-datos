-- ==========================================
-- PRUEBAS DE TRIGGERS
-- ==========================================

-- MEJORA:
-- No dependemos de que la nota tenga un ID específico,
-- como el 4 o el 7.
-- Identificamos el registro mediante la inscripción
-- y la fecha utilizada en nuestra prueba.

USE universidad_mejoras;


-- ==========================================
-- 1. BEFORE INSERT
-- ==========================================

-- Verificamos que las notas no puedan tener
-- una fecha anterior a la fecha de inscripción.

SELECT * FROM inscripciones;

-- Esta operación debe fallar porque la fecha
-- de la nota es anterior a la inscripción.

INSERT INTO notas(
    id_inscripcion,
    nota,
    fecha
)
VALUES(
    6,
    9.00,
    '2026-02-10'
);


-- ==========================================
-- 2. AFTER INSERT
-- ==========================================

-- Insertamos una nota válida.
-- El trigger debe registrar automáticamente
-- la operación en historial_notas.

INSERT INTO notas(
    id_inscripcion,
    nota,
    fecha
)
VALUES(
    13,
    7.50,
    CURDATE()
);

-- Verificamos el resultado.

SELECT * FROM notas;

SELECT * FROM historial_notas;


-- ==========================================
-- 3. AFTER UPDATE
-- ==========================================

-- Modificamos la nota recién insertada.
-- El trigger debe registrar la modificación.

UPDATE notas
SET nota = 10.00
WHERE id_inscripcion = 13
AND fecha = '2026-04-22';

-- Verificamos el resultado.

SELECT * FROM notas;

SELECT * FROM historial_notas;


-- ==========================================
-- 4. AFTER DELETE
-- ==========================================

-- Eliminamos la nota recién insertada.
-- El trigger debe registrar la eliminación.

DELETE FROM notas
WHERE id_inscripcion = 13
AND fecha = '2026-04-22';

-- Verificamos el resultado.

SELECT * FROM notas;

SELECT * FROM historial_notas;