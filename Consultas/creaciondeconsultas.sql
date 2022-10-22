DROP PROCEDURE if EXISTS consultarPensum; -- 1
DROP PROCEDURE if EXISTS consultarEstudiante; -- 2
DROP PROCEDURE if EXISTS consultarDocente; -- 3
DROP PROCEDURE if EXISTS consultarEstudiantesAsignados; -- 4
DROP PROCEDURE if EXISTS consultarAprobacion; -- 5
DROP PROCEDURE if EXISTS consultarActas; -- 6


-- CONSULTAR PENSUM DE CARREERA (1)
delimiter $$
CREATE PROCEDURE consultarPensum(IN codcarrera INT)
BEGIN
    SELECT cod as CodigoCurso, nombre as NombreCurso, crnecesarios as CreditosNecesarios, obligatorio as Obligatorio
    FROM curso 
    WHERE codcarrera = CARRERA_id  or 0 = CARRERA_id ;  
END$$
delimiter ;

-- CONSULTAR ESTUDIANTE(2)
delimiter $$
CREATE PROCEDURE consultarEstudiante(IN carnet BIGINT)
BEGIN
    SELECT e.carnet as Carnet, CONCAT(e.nombres, ' ', e.apellidos) as NombreCompleto, e.fechanacimiento as FechaNacimiento, e.correo as Correo, e.telefono as Telefono, 
    e.direccion as Direccion, e.dpi as DPI, c.nombre as Carrera, e.creditos as CreditosquePosee
    FROM estudiante e
    INNER JOIN carrera c ON e.CARRERA_id = c.id
    WHERE e.carnet = carnet;
END$$
delimiter ;

-- CONSULTAR DOCENTE (3)
delimiter $$
CREATE PROCEDURE consultarDocente(IN siif BIGINT)
BEGIN
    SELECT d.siif as RegistroSIIF, CONCAT(d.nombres, ' ', d.apellidos) as NombreCompleto, d.fechanacimiento as FechaNacimiento, d.correo as Correo, d.telefono as Telefono,
    d.direccion as Direccion, d.dpi as NUMERODPI
    FROM docente d
    WHERE d.siif = siif;
END$$
delimiter ;

-- CONSULTAR ESTUDIANTES ASIGNADOS A UN CURSO (4)
delimiter $$
CREATE PROCEDURE consultarEstudiantesAsignados(IN codcurso INT, IN ciclo VARCHAR(2), IN anio INT, IN seccion VARCHAR(1))
BEGIN
    SELECT e.carnet as Carnet, CONCAT(e.nombres, ' ', e.apellidos) as NombreCompleto, e.creditos as CreditosquePosee
    FROM estudiante e
    INNER JOIN asignacion a
    ON e.carnet = a.ESTUDIANTE_carnet
    INNER JOIN cursohabilitado ch
    ON a.CURSOHABILITADO_id = ch.id
    WHERE ch.CURSO_cod = codcurso AND ch.ciclo = ciclo AND ch.año = anio AND ch.seccion = seccion;
END$$
delimiter ;

-- CONSULTAR APROBACIONES DE UN CURSO (5)
delimiter $$
CREATE PROCEDURE consultarAprobacion(IN codcurso INT, IN ciclo VARCHAR(2), IN anio INT, IN seccion VARCHAR(1))
BEGIN
    SELECT ch.CURSO_cod as CodigoCurso, e.carnet as Carnet, CONCAT(e.nombres, ' ', e.apellidos) as NombreCompleto, IF (n.nota >= 61, 'APROBADO', 'REPROBADO') as Estado
    FROM cursohabilitado ch
    INNER JOIN nota n
    ON ch.id = n.CURSOHABILITADO_id
    INNER JOIN estudiante e
    ON n.ESTUDIANTE_carnet = e.carnet
    WHERE ch.CURSO_cod = codcurso AND ch.ciclo = ciclo AND ch.año = anio AND ch.seccion = seccion;
END$$

-- CONSULTAR ACTAS DE UN CURSO (6)
-- TRADUCIR '1S' A 'PRIMER SEMESTRE'
-- TRADUCIR '2S' A 'SEGUNDO SEMESTRE'
-- TRADUCIR 'VJ' A 'VACACIONES DE JUNIO'
-- TRADUCIR 'VD' A 'VACACIONES DE DICIEMBRE'
delimiter $$
CREATE PROCEDURE consultarActas(IN codcurso INT)
BEGIN
    SELECT ch.CURSO_cod as CodigoCurso, ch.seccion as Seccion,
    IF (ch.ciclo = '1S', 'PRIMER SEMESTRE', IF (ch.ciclo = '2S', 'SEGUNDO SEMESTRE', IF (ch.ciclo = 'VJ', 'VACACIONES DE JUNIO', 'VACACIONES DE DICIEMBRE'))) as Ciclo,
    ch.año as Año, a.cantidad as CantidadEstudiantes, ac.fecha as FechaActa, ac.hora as HoraActa
    FROM cursohabilitado ch
    INNER JOIN acta ac
    ON ch.id = ac.CURSOHABILITADO_id
    INNER JOIN asignados a
    ON ch.id = a.CURSOHABILITADO_id
    WHERE ch.CURSO_cod = codcurso;
END$$
delimiter ;



