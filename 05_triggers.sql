-- ==========================================
-- TRIGGERS
-- ==========================================

USE universidad_mejoras;


-- ==========================================
-- 1. BEFORE INSERT
-- ==========================================

-- Evita insertar una nota con una fecha anterior
-- a la fecha de inscripción del alumno.

DROP TRIGGER IF EXISTS trg_before_insert_fecha_notas;

DELIMITER $$

CREATE TRIGGER trg_before_insert_fecha_notas
BEFORE INSERT
ON notas
FOR EACH ROW

BEGIN

    DECLARE fecha_inscripcion DATE;

    SELECT fecha
    INTO fecha_inscripcion
    FROM inscripciones
    WHERE id_inscripcion = NEW.id_inscripcion;

    IF NEW.fecha < fecha_inscripcion THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'La fecha de la nota no puede ser anterior a la fecha de inscripción.';

    END IF;

END$$

DELIMITER ;


-- ==========================================
-- 2. AFTER INSERT
-- ==========================================

-- Registra automáticamente en el historial
-- cada nueva nota insertada.

DROP TRIGGER IF EXISTS trg_historial_notas_insert;

DELIMITER $$

CREATE TRIGGER trg_historial_notas_insert
AFTER INSERT
ON notas
FOR EACH ROW

BEGIN

    INSERT INTO historial_notas(
        fecha,
        alumno,
        materia,
        nota,
        accion
    )

    SELECT
        NOW(),
        a.nombre,
        m.nombre,
        NEW.nota,
        'INSERT'

    FROM inscripciones i

    INNER JOIN alumnos a
    ON i.id_alumno = a.id_alumno

    INNER JOIN materias m
    ON i.id_materia = m.id_materia

    WHERE i.id_inscripcion = NEW.id_inscripcion;

END$$

DELIMITER ;


-- ==========================================
-- 3. AFTER UPDATE
-- ==========================================

-- Registra en el historial cada modificación de una nota.

DROP TRIGGER IF EXISTS trg_after_update_notas;

DELIMITER $$

CREATE TRIGGER trg_after_update_notas
AFTER UPDATE
ON notas
FOR EACH ROW

BEGIN

    INSERT INTO historial_notas(
        fecha,
        alumno,
        materia,
        nota,
        accion
    )

    SELECT
        NOW(),
        a.nombre,
        m.nombre,
        NEW.nota,
        'UPDATE'

    FROM inscripciones i

    INNER JOIN alumnos a
    ON i.id_alumno = a.id_alumno

    INNER JOIN materias m
    ON i.id_materia = m.id_materia

    WHERE i.id_inscripcion = NEW.id_inscripcion;

END$$

DELIMITER ;


-- ==========================================
-- 4. AFTER DELETE
-- ==========================================

-- Registra en el historial cada nota eliminada.
-- En DELETE no existe NEW, solamente OLD.

DROP TRIGGER IF EXISTS trg_after_delete_notas;

DELIMITER $$

CREATE TRIGGER trg_after_delete_notas
AFTER DELETE
ON notas
FOR EACH ROW

BEGIN

    INSERT INTO historial_notas(
        fecha,
        alumno,
        materia,
        nota,
        accion
    )

    SELECT
        NOW(),
        a.nombre,
        m.nombre,
        OLD.nota,
        'DELETE'

    FROM inscripciones i

    INNER JOIN alumnos a
    ON i.id_alumno = a.id_alumno

    INNER JOIN materias m
    ON i.id_materia = m.id_materia

    WHERE i.id_inscripcion = OLD.id_inscripcion;

END$$

DELIMITER ;