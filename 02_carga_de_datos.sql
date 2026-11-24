USE universidad_mejoras;

-- ==========================================
-- 1. PROFESORES (10)
-- ==========================================

INSERT INTO profesores (nombre)
VALUES
('Juan Perez'),
('Ana Gomez'),
('Carlos Lopez'),
('Maria Fernandez'),
('Pedro Ramirez'),
('Laura Torres'),
('Diego Martinez'),
('Sofia Rodriguez'),
('Martin Sanchez'),
('Lucia Romero'),
('Luciano Gonzalez');


-- ==========================================
-- 2. ALUMNOS (10)
-- ==========================================
INSERT INTO alumnos (nombre, edad)
VALUES
('Macarena Aguirre', 28),
('Pedro Diaz', 25),
('Camila Fernandez', 22),
('Lucas Martinez', 24),
('Sofia Gonzalez', 21),
('Mateo Romero', 26),
('Valentina Lopez', 23),
('Tomas Perez', 27),
('Julieta Torres', 20),
('Nicolas Ramirez', 29);


-- ==========================================
-- 3. MATERIAS (10)
-- ==========================================

INSERT INTO materias (id_profesor, nombre)
VALUES
(1, 'Base de Datos'),
(2, 'Programacion'),
(3, 'Matematica'),
(4, 'Ingles'),
(5, 'Estadistica'),
(6, 'Sistemas Operativos'),
(7, 'Redes'),
(8, 'Desarrollo Web'),
(9, 'Ingenieria de Software'),
(10, 'Algoritmos'),
(11, 'Python');

-- La materia 11 fue creada a proposito para demostrar que una materia sin inscripciones
--si se puede eliminar, en el archivo de prubas de integridad.
--(junto con el profesor 11, que fue asociado con la materia 11)


-- ==========================================
-- 4. INSCRIPCIONES (15)
-- ==========================================

INSERT INTO inscripciones
(id_alumno, id_materia, fecha, anio_cursada)
VALUES
(1, 1, '2026-03-10', 2026),
(2, 2, '2026-03-11', 2026),
(3, 3, '2026-03-12', 2026),
(4, 4, '2026-03-13', 2026),
(5, 5, '2026-03-14', 2026),
(6, 6, '2026-03-15', 2026),
(7, 7, '2026-03-16', 2026),
(8, 8, '2026-03-17', 2026),
(9, 9, '2026-03-18', 2026),
(10, 10, '2026-03-19', 2026),
(1, 3, '2026-03-20', 2026),
(3, 4, '2026-03-21', 2026),
(4, 5, '2026-03-22', 2026),
(5, 6, '2026-03-23', 2026),
(6, 7, '2026-03-24', 2026);


-- ==========================================
-- 5. NOTAS (15)
-- ==========================================

INSERT INTO notas (id_inscripcion, nota, fecha)
VALUES
(1, 9.00, '2026-04-10'),
(2, 8.50, '2026-04-11'),
(3, 7.00, '2026-04-12'),
(4, 6.50, '2026-04-13'),
(5, 10.00, '2026-04-14'),
(6, 8.00, '2026-04-15'),
(7, 9.50, '2026-04-16'),
(8, 7.50, '2026-04-17'),
(9, 6.00, '2026-04-18'),
(10, 9.00, '2026-04-19'),
(11, 8.00, '2026-04-20'),
(12, 7.50, '2026-04-21'),
(13, 9.50, '2026-04-22'),
(14, 8.50, '2026-04-23'),
(15, 10.00, '2026-04-24');


