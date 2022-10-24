DROP TRIGGER if EXISTS insert_estudiante;
DROP TRIGGER if EXISTS insert_carrera;
DROP TRIGGER if EXISTS insert_docente;
DROP TRIGGER if EXISTS insert_curso;
DROP TRIGGER if EXISTS insert_habilitarcurso;
DROP TRIGGER if EXISTS insert_horario;
DROP TRIGGER if EXISTS insert_estudiante_curso;
DROP TRIGGER if EXISTS update_cantidad_estudiantes;
DROP TRIGGER if EXISTS delete_estudiante_curso;
DROP TRIGGER if EXISTS insert_desasignacion;
DROP TRIGGER if EXISTS insert_notas;
DROP TRIGGER if EXISTS update_creditos;
DROP TRIGGER if EXISTS insert_acta;


-- triger para registro de estudiante
delimiter $$
CREATE TRIGGER insert_estudiante AFTER INSERT ON estudiante
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla ESTUDIANTE','INSERT');
END$$
delimiter ;

-- triger para agregar carrera
delimiter $$
CREATE TRIGGER insert_carrera AFTER INSERT ON carrera
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla CARRERA','INSERT');
END$$
delimiter ;

-- triger para agregar docente
delimiter $$
CREATE TRIGGER insert_docente AFTER INSERT ON docente
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla DOCENTE','INSERT');
END$$
delimiter ;

-- triger para agregar curso
delimiter $$
CREATE TRIGGER insert_curso AFTER INSERT ON curso
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla CURSO','INSERT');
END$$       
delimiter ;

-- trigger para habilitar curso
delimiter $$
CREATE TRIGGER insert_habilitarcurso AFTER INSERT ON cursohabilitado
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla CURSOHABILITADO','INSERT');
END$$
delimiter ;

-- trigger para agregar horario
delimiter $$
CREATE TRIGGER insert_horario AFTER INSERT ON horario
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla HORARIO','INSERT');
END$$
delimiter ;

-- triger para asignar estudiantes a un curso
delimiter $$
CREATE TRIGGER insert_estudiante_curso AFTER INSERT ON asignacion
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla ASIGNACION','INSERT');
END$$
delimiter ;

-- triger para actualizar cantidad de estudiantes en un curso
delimiter $$
CREATE TRIGGER update_cantidad_estudiantes AFTER UPDATE ON asignados
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla ASIGNADOS','UPDATE');
END$$
delimiter ;

--trigger para desasignar estudiante de un curso
delimiter $$
CREATE TRIGGER delete_estudiante_curso AFTER DELETE ON asignacion
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla ASIGNACION','DELETE');
END$$
delimiter ;

-- triger para registar desasignacion en tabla desasignacion
delimiter $$
CREATE TRIGGER insert_desasignacion AFTER INSERT ON desasignacion
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla DESASIGNACION','INSERT');
END$$
delimiter ;

-- trigger para registrar ingreso de notas
delimiter $$
CREATE TRIGGER insert_notas AFTER INSERT ON nota
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla NOTAS','INSERT');
END$$
delimiter ;

-- trigger para actualizar creditos de estudiantes
delimiter $$
CREATE TRIGGER update_creditos AFTER UPDATE ON estudiante
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla ESTUDIANTE','UPDATE');
END$$
delimiter ;

-- trigger para registros en acta
delimiter $$
CREATE TRIGGER insert_acta AFTER INSERT ON acta
FOR EACH ROW
BEGIN
    SELECT NOW() INTO @fecha;
    INSERT INTO historial(fecha,descripcion,tipo)
    VALUES(@fecha,'Se ha realizado una accion en la tabla ACTA','INSERT');
END$$
delimiter ;














