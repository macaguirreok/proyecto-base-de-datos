
-- Cambio: Se decidió crear todas las tablas en un solo archivo,
-- y también colocar todas las restricciones en este archivo, no después
-- (como se hizo en el proyecto anterior).

CREATE DATABASE universidad_mejoras
DEFAULT CHARACTER SET = 'utf8mb4';

USE universidad_mejoras;


-- TABLA PROFESORES

CREATE TABLE profesores(
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);


-- TABLA ALUMNOS

CREATE TABLE alumnos(
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT NOT NULL CHECK(edad > 0 AND edad <= 150)
);


-- TABLA MATERIAS
-- No se puede borrar un profesor, si tiene materias asociadas
-- Si se actualiza el número de id del profesor, se actualiza en la tabla materias

CREATE TABLE materias(
    id_materia INT AUTO_INCREMENT PRIMARY KEY,
    id_profesor INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,

    FOREIGN KEY(id_profesor)
    REFERENCES profesores(id_profesor) 
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);


-- TABLA INSCRIPCIONES
-- ON UPDATE: NO ACTION (Comportamiento predeterminado).
-- No permite modificar los IDs de alumnos o materias
--si existen inscripciones relacionadas.

--ON DELETE: no se pueden eliminar materias que tengan inscripciones asociadas,
--en cambio si se borra un alumno, se borran en cascada sus inscripciones.

CREATE TABLE inscripciones(
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_materia INT NOT NULL,
    fecha DATE NOT NULL,
    anio_cursada INT NOT NULL,

    FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id_alumno)
    ON DELETE CASCADE,

    FOREIGN KEY(id_materia)
    REFERENCES materias(id_materia)
    ON DELETE RESTRICT,

    CONSTRAINT unica_inscripcion
    UNIQUE(id_alumno, id_materia, anio_cursada)

    
);






--TABLA NOTAS
-- ON DELETE CASCADE:
-- Si se elimina una inscripción, se eliminan
-- automáticamente las notas asociadas.
-- Esto permite que el borrado en cascada se propague
-- desde alumnos o materias hasta notas.


CREATE TABLE notas(
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_inscripcion INT NOT NULL,
    nota DECIMAL(4,2) NOT NULL CHECK(nota >= 1 AND nota <= 10),
    fecha DATE NOT NULL,

    FOREIGN KEY(id_inscripcion)
    REFERENCES inscripciones(id_inscripcion)
    ON DELETE CASCADE
);

--TABLA HISTORIAL_INSCRIPCIONES
-- ON DELETE y ON UPDATE: NO ACTION (comportamiento predeterminado).
-- No permite eliminar ni modificar los IDs de alumnos o materias
-- que tengan registros relacionados en esta tabla.

CREATE TABLE historial_inscripciones(
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_materia INT NOT NULL, 
    fecha DATETIME NOT NULL,
    accion VARCHAR(100) NOT NULL,

    FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id_alumno),

    FOREIGN KEY(id_materia)
    REFERENCES materias(id_materia)
);


-- TABLA HISTORIAL_NOTAS
-- Se creó esta tabla, para poder utilizar triggers en el proyecto.
-- No tiene FK porque funciona como una tabla de auditoría.
-- Almacena una copia de los datos relevantes de la nota
-- para conservar el historial aunque el registro original
-- sea modificado o eliminado.
CREATE TABLE historial_notas(
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL,
    alumno VARCHAR(80),
    materia VARCHAR(80),
    nota DECIMAL(4,2),
    accion VARCHAR(20)
);