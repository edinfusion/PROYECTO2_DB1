-- para iniciar id 0
-- SET SESSION sql_mode='NO_AUTO_VALUE_ON_ZERO'
-- para iniciar id 1
-- SET SESSION sql_mode=''
-- para limpiar tabla
-- ALTER TABLE proyecto2.carrera AUTO_INCREMENT=0;
-- SET FOREIGN_KEY_CHECKS = 0;
-- TRUNCATE TABLE proyecto2.carrera;
-- SET FOREIGN_KEY_CHECKS = 1;
DROP FUNCTION if EXISTS sololetras;
DROP FUNCTION if EXISTS validarEmail;
DROP FUNCTION IF EXISTS esNumero;
DROP FUNCTION if EXISTS validarSeccion;
DROP FUNCTION if EXISTS validarCiclo;
DROP FUNCTION IF EXISTS buscarCarnet;
DROP FUNCTION if EXISTS buscarCarrera;
DROP FUNCTION if EXISTS buscarSiif;
DROP FUNCTION if EXISTS buscarCurso;
DROP FUNCTION if EXISTS buscarCursoHabilitado;
DROP FUNCTION IF EXISTS buscarCursoHabilitadoPorCodigo;
DROP FUNCTION if EXISTS buscarEstudianteAsignado;
DROP FUNCTION if EXISTS validarAsignacion;
DROP FUNCTION if EXISTS validarCupo;
DROP FUNCTION if EXISTS cantidadNotasIgualCantidadEstudiantesAsignados;
DROP FUNCTION if EXISTS buscarNota;
DROP FUNCTION if EXISTS buscarEstudiantesAsignados;
DROP FUNCTION if EXISTS buscarActa;

DROP PROCEDURE if EXISTS Mensaje;
DROP PROCEDURE if EXISTS registrarEstudiante; -- 1
DROP PROCEDURE if EXISTS crearCarrera;-- 2
DROP PROCEDURE if EXISTS registrarDocente; -- 3
DROP PROCEDURE if EXISTS crearCurso; -- 4
DROP PROCEDURE if EXISTS habilitarCurso; -- 5
DROP PROCEDURE if EXISTS agregarHorario; -- 6
DROP PROCEDURE if EXISTS asignarCursoEstudiante; -- 7
DROP PROCEDURE if EXISTS desasignarCursoEstudiante; -- 8
DROP PROCEDURE if EXISTS ingresarNotas; -- 9
DROP PROCEDURE if EXISTS generarActa; -- 10 

-- FUNCTION SOLO LETRAS
CREATE FUNCTION soloLetras(str VARCHAR(100))
RETURNS BOOLEAN DETERMINISTIC
RETURN IF (str REGEXP '^[a-zA-Záéíóú ]*$',true,false);
select sololetras('asdfasdfasdfasdfasdf');
-- FUNCTION VALIDAR EMAIL
CREATE FUNCTION validarEmail(email VARCHAR(60))
RETURNS BOOLEAN DETERMINISTIC
RETURN IF (email REGEXP '^[a-zA-Z0-9]+@[a-zA-Z]+(\.[a-zA-Z]+)+$',true,false);
-- FUNCTIO ES NUMERO
CREATE FUNCTION esNumero(num VARCHAR(45))
RETURNS BOOLEAN DETERMINISTIC
RETURN if (num REGEXP '^[0-9]*$',TRUE, FALSE);
-- FUNCTION VALIDAR SECCION
CREATE FUNCTION validarSeccion(seccion VARCHAR(1))
RETURNS BOOLEAN DETERMINISTIC
RETURN IF (BINARY seccion <> UPPER(seccion),true,false);
-- FUNCTION VALIDAR CICLO
CREATE FUNCTION validarCiclo(ciclo VARCHAR(2))
RETURNS BOOLEAN DETERMINISTIC
RETURN IF (BINARY ciclo = '1S' OR BINARY ciclo = '2S' OR BINARY ciclo = 'VD' OR BINARY ciclo = 'VJ',TRUE,FALSE);

DELIMITER $$
-- FUNCTION BUSCAR CARNET
CREATE FUNCTION buscarCarnet(car INT)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(SELECT * FROM estudiante WHERE carnet=car) INTO existe;
RETURN (existe);
END $$
DELIMITER ;

DELIMITER $$
-- FUNCTION BUSCAR CARRERA
CREATE FUNCTION buscarCarrera(cod INT)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(SELECT * FROM carrera WHERE id=cod) INTO existe;
RETURN existe;
END $$
DELIMITER ;

DELIMITER $$
-- FUNCTION BUSCAR SIIF
CREATE FUNCTION buscarSiif(sif INT)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(SELECT * FROM docente WHERE siif=sif) INTO existe;
RETURN existe;
END $$
DELIMITER ;

DELIMITER $$
-- FUNCTION BUSCAR CURSO
create function buscarCurso(codi INT)
returns boolean deterministic
begin
declare existe boolean;
select exists(select * from curso where cod=codi) into existe;
return existe;
end $$
DELIMITER ;

DELIMITER $$
-- FUNCTION BUSCAR CURSO HABILITADO
create function buscarCursoHabilitado(codc INT, cicl VARCHAR(45), secc VARCHAR(45))
returns boolean deterministic
begin
declare existe boolean;
select exists(select * from cursohabilitado where CURSO_cod=codc and ciclo=cicl and seccion=secc) into existe;
return existe;
end $$
DELIMITER ;

DELIMITER $$
-- FUNCTION BUSCAR CURSO HABILITADO POR CODIGO
create function buscarCursoHabilitadoPorCodigo(codc INT)
returns boolean deterministic
begin
declare existe boolean;
select exists(select * from cursohabilitado where id=codc) into existe;
return existe;
end $$
DELIMITER ; 

DELIMITER $$
-- FUNCTION PARA BUSCAR SI ESTUDIANTE YA ESTA ASIGNADO A UN CURSO
create function buscarEstudianteAsignado(carn BIGINT, codc INT, cicl VARCHAR(45), secc VARCHAR(45))
returns boolean deterministic
begin
declare existe boolean;
select exists(
	select * 
	from cursohabilitado
	inner join asignacion 
	on cursohabilitado.id=asignacion.CURSOHABILITADO_id
	where cursohabilitado.CURSO_cod=codc and cursohabilitado.ciclo=cicl and cursohabilitado.seccion=secc and asignacion.ESTUDIANTE_carnet=carn
) into existe;
return existe;
end $$
DELIMITER ;

DELIMITER $$
-- FUNCTION VALIDA SI EL CURSO QUE SE DESEA ASIGNAR ESTUDIANTE LE CORRESPONDE A LA CARRERA Y SI TIENE LOS CREDITOS NECESARIOS
create function validarAsignacion(carn BIGINT, codc INT)
returns boolean deterministic
begin
declare existe boolean;
select exists(
	select * 
	from estudiante
	inner join carrera
	on estudiante.CARRERA_id=carrera.id or 0=carrera.id
	inner join curso
	on carrera.id=curso.CARRERA_id
	where estudiante.carnet=carn and curso.cod=codc and estudiante.creditos>=curso.crnecesarios
) into existe;
return existe;
end $$
DELIMITER ;

DELIMITER $$
-- FUNCTION VALIDA SI HAY CUPO EN EL CURSO
create function validarCupo(codc INT, cicl VARCHAR(45), secc VARCHAR(45))
returns boolean deterministic
begin
declare existe boolean;
select exists(
	select * 
	from cursohabilitado
	inner join asignados
	on cursohabilitado.id=asignados.CURSOHABILITADO_id
	where cursohabilitado.CURSO_cod=codc and cursohabilitado.ciclo=cicl and cursohabilitado.seccion=secc and asignados.cantidad<cursohabilitado.cupo
) into existe;
return existe;
end $$
DELIMITER ;

DELIMITER $$
-- FUNCTION VALIDA NUMERO NOTAS INGRESADAS CON NUMERO DE ESTUDIANTES ASIGNADOS
create function cantidadNotasIgualCantidadEstudiantesAsignados(codc INT, cicl VARCHAR(2), secc VARCHAR(1))
returns boolean deterministic
begin
declare existe boolean;
select exists(
	select *
	from cursohabilitado
	inner join asignados
	on cursohabilitado.id=asignados.CURSOHABILITADO_id
	where cursohabilitado.CURSO_cod=codc and cursohabilitado.ciclo=cicl and cursohabilitado.seccion=secc and asignados.cantidad = (select count(*) from nota where CURSOHABILITADO_id=cursohabilitado.id)
) into existe;
return existe;
end $$
DELIMITER ;

DELIMITER $$
-- FUNCTION VALIDA SI EL ESTUDIANTE YA TIENE NOTA INGRESADA
CREATE FUNCTION buscarNota
(carn BIGINT, codc INT, cicl VARCHAR(45), secc VARCHAR(45))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(
	SELECT * 
	FROM nota
	inner join cursohabilitado
	on nota.CURSOHABILITADO_id=cursohabilitado.id
	where cursohabilitado.CURSO_cod=codc and cursohabilitado.ciclo=cicl and cursohabilitado.seccion=secc and nota.ESTUDIANTE_carnet=carn
) INTO existe;
RETURN existe;
END $$
DELIMITER ;

DELIMITER $$
-- 3. que el curso tenga estudiantes asignados
CREATE FUNCTION buscarEstudiantesAsignados(codc INT, cicl VARCHAR(45), secc VARCHAR(45))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(
	SELECT * 
	FROM cursohabilitado
	inner join asignados
	on cursohabilitado.id=asignados.CURSOHABILITADO_id
	where cursohabilitado.CURSO_cod=codc and cursohabilitado.ciclo=cicl and cursohabilitado.seccion=secc and asignados.cantidad>0
) INTO existe;
RETURN existe;
END $$
DELIMITER ;

DELIMITER $$
-- valida que el acta no exista
CREATE FUNCTION buscarActa(codc INT, cicl VARCHAR(45), secc VARCHAR(45))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
DECLARE existe BOOLEAN;
SELECT EXISTS(
	SELECT * 
	FROM acta
	inner join cursohabilitado
	on acta.CURSOHABILITADO_id=cursohabilitado.id
	where cursohabilitado.CURSO_cod=codc and cursohabilitado.ciclo=cicl and cursohabilitado.seccion=secc
) INTO existe;
RETURN existe;
END $$
DELIMITER ;

-- PROC MENSAJE 
delimiter $$
CREATE PROCEDURE Mensaje (IN msg VARCHAR(200))
	BEGIN
		SELECT msg as Error;
        END$$
delimiter ;





-- PROC REGISTRAR ESTUDIANTE
delimiter $$
CREATE PROCEDURE registrarEstudiante(
-- parametros
IN carnet int, 
IN nombres varchar(45),
IN apellidos varchar(45),
IN fechanacimiento varchar(15),
IN correo varchar(60),
IN telefono int,
IN direccion varchar(200),
IN dpi bigint,
IN carrera int
)
proc_estudiante:BEGIN
	-- instrucciones
		DECLARE fech DATE;
        DECLARE fechan DATE;
		SET fechan = STR_TO_DATE(fechanacimiento,'%d-%m-%Y');
		IF carnet IS NULL THEN
			CALL Mensaje('Error, Debe ingresar carnet obligatoriamente');
			LEAVE proc_estudiante;
		ELSEIF nombres IS NULL THEN
			CALL Mensaje('Error, Debe ingresar nombres obligatoriamente');
			LEAVE proc_estudiante;
		ELSEIF apellidos IS NULL THEN
			CALL Mensaje('Error, Debe ingresar apeliidos obligatoriamente');
			LEAVE proc_estudiante;
		ELSEIF fechanacimiento IS NULL THEN
			CALL Mensaje('Error, Debe ingresar fecha de nacimiento');
			LEAVE proc_estudiante;
		ELSEIF correo IS NULL THEN
			CALL Mensaje('Error, Debe ingresar correo obligatoriamente');
			LEAVE proc_estudiante;
		ELSEIF telefono IS NULL THEN
			CALL Mensaje('Error, Debe ingresar telefono obligatoriamente');
			LEAVE proc_estudiante;
		ELSEIF direccion IS NULL THEN
			CALL Mensaje('Error, Debe ingresar direccion obligatoriamente');
			LEAVE proc_estudiante;
		ELSEIF dpi IS NULL THEN
			CALL Mensaje('Error, Debe ingresar dpi obligatoriamente');
			LEAVE proc_estudiante;
		ELSEIF carrera IS NULL THEN
			CALL Mensaje('Error, Debe ingresar carrera obligatoriamente');
			LEAVE proc_estudiante;
		ELSEIF validarEmail(correo)=false THEN
			CALL Mensaje('Error, Debe ingresar un correo valido');
			LEAVE proc_estudiante;
		ELSEIF buscarCarnet(carnet) THEN
			CALL Mensaje('Error, El carnet ya existe');
			LEAVE proc_estudiante;
		ELSEIF NOT buscarCarrera(carrera)  THEN
			CALL Mensaje('Error, La carrera no existe');
			LEAVE proc_estudiante;
		END IF;
		SET fech = curdate();
		INSERT INTO estudiante(carnet,dpi,nombres,apellidos,fechanacimiento,correo,telefono,direccion,creditos,fecha,CARRERA_id) 
		VALUES(carnet,dpi,nombres,apellidos,fechan,correo,telefono,direccion,0,fech,carrera);
	END $$
delimiter ;


-- PROC AGREGAR CARRERA (2)
delimiter $$
CREATE PROCEDURE crearCarrera(
	IN nom VARCHAR(100)
)
proccarrera:BEGIN
	IF nom IS NOT NULL THEN
		IF (soloLetras(nom)) THEN
			IF nom NOT IN (SELECT nombre FROM carrera) THEN
				INSERT INTO carrera (nombre) VALUES (nom);
				CALL Mensaje('Carrera agregada correctamente');
			ELSE
				CALL Mensaje('La carrera ya existe');
			END IF;
		ELSE
			CALL Mensaje('El nombre de la carrera no puede contener numeros');
		END IF;
	ELSE
		CALL Mensaje('El nombre de la carrera no puede estar vacio');
	END IF;
END$$
delimiter ;


-- PROC REGISTRAR DOCENTE (3)
delimiter $$
CREATE PROCEDURE registrarDocente(
-- parametros
IN noms varchar(45),
IN apells varchar(45),
IN fechanac varchar(15),
IN correos varchar(60),
IN telefono int,
IN direccion varchar(200),
IN dpi bigint,
IN siif int
)
proc_docente:BEGIN
	-- instrucciones
		DECLARE fech DATE;
		DECLARE fechan DATE;
		SET fechan = STR_TO_DATE(fechanac,'%d-%m-%Y');
		IF noms IS NULL THEN
			CALL Mensaje('Error, Debe ingresar nombres obligatoriamente');
			LEAVE proc_docente;
		ELSEIF apells IS NULL THEN
			CALL Mensaje('Error, Debe ingresar apeliidos obligatoriamente');
			LEAVE proc_docente;
		ELSEIF fechanac IS NULL THEN
			CALL Mensaje('Error, Debe ingresar fecha de nacimiento');
			LEAVE proc_docente;
		ELSEIF correos IS NULL THEN
			CALL Mensaje('Error, Debe ingresar correo obligatoriamente');
			LEAVE proc_docente;
		ELSEIF telefono IS NULL THEN
			CALL Mensaje('Error, Debe ingresar telefono obligatoriamente');
			LEAVE proc_docente;
		ELSEIF direccion IS NULL THEN
			CALL Mensaje('Error, Debe ingresar direccion obligatoriamente');
			LEAVE proc_docente;
		ELSEIF dpi IS NULL THEN
			CALL Mensaje('Error, Debe ingresar dpi obligatoriamente');
			LEAVE proc_docente;
		ELSEIF siif IS NULL THEN
			CALL Mensaje('Error, Debe ingresar siif obligatoriamente');
			LEAVE proc_docente;
		ELSEIF validarEmail(correos)=false THEN
			CALL Mensaje('Error, Debe ingresar un correo valido');
			LEAVE proc_docente;
		ELSEIF buscarSiif(siif) THEN
			CALL Mensaje('Error, El siif ya existe');
			LEAVE proc_docente;
		END IF;
		SET fech = curdate();
		INSERT INTO docente(siif,dpi,nombres,apellidos,fechanacimiento,correo,telefono,direccion,fechacreacion) 
		VALUES(siif,dpi,noms,apells,fechan,correos,telefono,direccion,fech);
	END $$
delimiter ;

-- PROC CREAR CURSO (4)
delimiter $$
CREATE PROCEDURE crearCurso(
-- parametros
IN Cod INT,
IN Nomb VARCHAR(45),
IN CrNecesarios INT,
IN CrOtorga INT,
IN idCarrera INT,
IN obligatorio BOOLEAN
)
proc_curso:BEGIN
	-- instrucciones
		IF Nomb IS NULL THEN
			CALL Mensaje('Error, Debe ingresar nombre obligatoriamente');
			LEAVE proc_curso;
		ELSEIF Cod IS NULL THEN
			CALL Mensaje('Error, Debe ingresar codigo de curso');
			LEAVE proc_curso;
		ELSEIF CrNecesarios IS NULL THEN
			CALL Mensaje('Error, Debe ingresar creditos necesarios obligatoriamente');
			LEAVE proc_curso;
		ELSEIF CrOtorga IS NULL THEN
			CALL Mensaje('Error, Debe ingresar creditos otorgados obligatoriamente');
			LEAVE proc_curso;
		ELSEIF idCarrera IS NULL THEN
			CALL Mensaje('Error, Debe ingresar carrera obligatoriamente');
			LEAVE proc_curso;
		ELSEIF obligatorio IS NULL THEN
			CALL Mensaje('Error, Debe ingresar si es obligatorio o no');
			LEAVE proc_curso;
		ELSEIF NOT (esNumero(Cod)) THEN
			CALL Mensaje('Error, El codigo debe ser un numero');
		ELSEIF buscarCurso(Cod) THEN
			CALL Mensaje('Error, El codigo del curso ya existe');
			LEAVE proc_curso;
		ELSEIF NOT buscarCarrera(idCarrera) THEN
			CALL Mensaje('Error, La carrera no existe');
			LEAVE proc_curso;
		ELSEIF NOT (esNumero(CrNecesarios) OR esNumero(CrOtorga))  THEN
			CALL Mensaje('Error, Los creditos deben ser de tipo numericos');
			LEAVE proc_curso;
		ELSEIF (CrNecesarios < 0 OR CrOtorga < 0) THEN
			CALL Mensaje('Error, Los creditos deben ser positivos');
			LEAVE proc_curso;
		END IF;
		INSERT INTO curso(cod,nombre,crnecesarios,crotorga,obligatorio,CARRERA_id) 
		VALUES(Cod,Nomb,CrNecesarios,CrOtorga,obligatorio,idCarrera);
	END $$
	delimiter ;

	-- PROC PARA HABILITAR CURSO (5)
delimiter $$
CREATE PROCEDURE habilitarCurso(
-- parametros
IN codcurso INT,
IN ciclo VARCHAR(2),
IN codDocente INT,
IN cupoMaximo INT,
IN seccion VARCHAR(1)
)
proc_habilitar:BEGIN
	-- instrucciones
	DECLARE añoo YEAR;
	SET añoo = YEAR(curdate());
		IF codcurso IS NULL THEN
			CALL Mensaje('Error, Debe ingresar codigo de curso');
			LEAVE proc_habilitar;
		ELSEIF ciclo IS NULL OR  NOT validarCiclo(ciclo) THEN
			CALL Mensaje('Error, Debe ingresar ciclo, 1S,2S,VJ,VD');
			LEAVE proc_habilitar;
		ELSEIF codDocente IS NULL THEN
			CALL Mensaje('Error, Debe ingresar codigo de docente obligatoriamente');
			LEAVE proc_habilitar;
		ELSEIF cupoMaximo IS NULL THEN
			CALL Mensaje('Error, Debe ingresar cupo maximo obligatoriamente');
			LEAVE proc_habilitar;
		ELSEIF seccion IS NULL THEN
			CALL Mensaje('Error, Debe ingresar seccion obligatoriamente');
			LEAVE proc_habilitar;
		ELSEIF NOT buscarCurso(codcurso) THEN
			CALL Mensaje('Error, El curso no existe');
			LEAVE proc_habilitar;
		ELSEIF NOT buscarSiif(codDocente) THEN
			CALL Mensaje('Error, El docente no existe');
			LEAVE proc_habilitar;
		ELSEIF NOT (esNumero(codcurso) OR esNumero(codDocente) OR esNumero(cupoMaximo)) THEN
			CALL Mensaje('Error, Los datos deben ser de tipo numericos');
			LEAVE proc_habilitar;
		ELSEIF (cupoMaximo < 0) THEN
			CALL Mensaje('Error, El cupo maximo debe ser positivo');
			LEAVE proc_habilitar;
		ELSEIF validarSeccion(seccion) THEN 
			CALL Mensaje('Error, La seccion debe ser A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z');
			LEAVE proc_habilitar;
		ELSEIF buscarCursoHabilitado(codcurso,ciclo,seccion) THEN
			CALL Mensaje('Error, El curso ya esta habilitado');
			LEAVE proc_habilitar;
		END IF;
		INSERT INTO cursohabilitado(CURSO_cod,DOCENTE_siif,ciclo,seccion,cupo,año) 
		VALUES(codcurso,codDocente,ciclo,seccion,cupoMaximo,añoo);
		INSERT INTO asignados(CURSOHABILITADO_id,cantidad)
		VALUES(LAST_INSERT_ID(),0);
	END $$
	delimiter ;

-- PROC PARA AGREGAR HORARIO (6)
delimiter $$
CREATE PROCEDURE agregarHorario(
-- parametros
IN codcursoh INT,
IN dia INT,
IN horario varchar(45)
)
proc_horario:BEGIN
	-- instrucciones
		IF codcursoh IS NULL THEN
			CALL Mensaje('Error, Debe ingresar codigo de curso habilitado');
			LEAVE proc_horario;
		ELSEIF dia IS NULL THEN
			CALL Mensaje('Error, Debe ingresar dia obligatoriamente');
			LEAVE proc_horario;
		ELSEIF horario IS NULL THEN
			CALL Mensaje('Error, Debe ingresar horario obligatoriamente');
			LEAVE proc_horario;
		ELSEIF NOT buscarCursoHabilitadoPorCodigo(codcursoh) THEN
			CALL Mensaje('Error, El código del curso habilitado no existe');
			LEAVE proc_horario;
		ELSEIF NOT (esNumero(codcursoh) OR esNumero(dia)) THEN
			CALL Mensaje('Error, Los datos deben ser de tipo numericos');
			LEAVE proc_horario;
		ELSEIF (dia < 1 OR dia > 7) THEN
			CALL Mensaje('Error, El dia debe ser entre 1 y 7');
			LEAVE proc_horario;
		END IF;
		INSERT INTO horario(CURSOHABILITADO_id,dia,horario) 
		VALUES(codcursoh,dia,horario);
	END $$
	delimiter ;

-- PROC PARA ASIGNAR CURSO ESTUDIANTE(7)
delimiter $$
CREATE PROCEDURE asignarCursoEstudiante(
-- parametros
IN codcurso INT,
IN ciclo VARCHAR(2),
IN seccion VARCHAR(1),
IN carnet BIGINT
)
proc_asignar:BEGIN
	-- instrucciones
	-- validaciones:
	-- 1. que el curso este habilitado
	-- 2. que el estudiante no se encuentre asignado a ese curso ya 
	-- 3. que el estudiante cuente con los creditos necesarios y que corresponda a su carrera o area comun
	-- 4. que haya cupo disponible
	IF codcurso IS NULL THEN
		CALL Mensaje('Error, Debe ingresar codigo de curso que desea asignarse');
		LEAVE proc_asignar;
	ELSEIF ciclo IS NULL OR  NOT validarCiclo(ciclo) THEN
		CALL Mensaje('Error, Debe ingresar ciclo, 1S,2S,VJ,VD');
		LEAVE proc_asignar;
	ELSEIF seccion IS NULL THEN
		CALL Mensaje('Error, Debe ingresar seccion obligatoriamente');
		LEAVE proc_asignar;
	ELSEIF carnet IS NULL THEN
		CALL Mensaje('Error, Debe ingresar carnet obligatoriamente');
		LEAVE proc_asignar;
	ELSEIF NOT (esNumero(codcurso) OR esNumero(carnet)) THEN
		CALL Mensaje('Error, Los datos de codigo de curso y carnet deben ser de tipo numericos');
		LEAVE proc_asignar;
	ELSEIF NOT buscarCurso(codcurso) THEN
		CALL Mensaje('Error, El curso no existe');
		LEAVE proc_asignar;
	ELSEIF NOT buscarCarnet(carnet) THEN
		CALL Mensaje('Error, El estudiante no existe');
		LEAVE proc_asignar;
	-- 1. que el curso este habilitado
	ELSEIF NOT buscarCursoHabilitado(codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, El curso no esta habilitado');
		LEAVE proc_asignar;
	-- 2. que el estudiante no se encuentre asignado a ese curso ya 
	ELSEIF buscarEstudianteAsignado(carnet,codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, El estudiante ya se encuentra asignado a ese curso');
		LEAVE proc_asignar;
	-- 3. que el estudiante cuente con los creditos necesarios y que corresponda a su carrera o area comun
	ELSEIF NOT validarAsignacion(carnet,codcurso) THEN
		CALL Mensaje('Error, El estudiante no cuenta con los creditos necesarios o no corresponde a su carrera o area comun');
		LEAVE proc_asignar;
	-- 4. que haya cupo disponible
	ELSEIF NOT validarCupo(codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, No hay cupo disponible');
		LEAVE proc_asignar;
	END IF;
	SELECT id INTO @id FROM cursohabilitado WHERE CURSO_cod = codcurso AND ciclo = ciclo AND seccion = seccion;
	SELECT asignados.cantidad INTO @cantidad FROM asignados WHERE CURSOHABILITADO_id = @id;
	UPDATE asignados SET cantidad = @cantidad + 1 WHERE CURSOHABILITADO_id = @id;
	INSERT INTO asignacion(CURSOHABILITADO_id,ESTUDIANTE_carnet) VALUES(@id,carnet);
	END $$
	delimiter ;

-- PROC PARA DESASIGNAR CURSO ESTUDIANTE(8)
delimiter $$
CREATE PROCEDURE desasignarCursoEstudiante(
-- parametros
IN codcurso INT,
IN ciclo VARCHAR(2),
IN seccion VARCHAR(1),
IN carnet BIGINT
)
proc_desasignar:BEGIN
	-- instrucciones
	-- validaciones:
	-- 1. que el curso este habilitado
	-- 2. que el estudiante se encuentre asignado a ese curso
	IF codcurso IS NULL THEN
		CALL Mensaje('Error, Debe ingresar codigo de curso que desea desasignarse');
		LEAVE proc_desasignar;
	ELSEIF ciclo IS NULL OR  NOT validarCiclo(ciclo) THEN
		CALL Mensaje('Error, Debe ingresar ciclo, 1S,2S,VJ,VD');
		LEAVE proc_desasignar;
	ELSEIF seccion IS NULL THEN
		CALL Mensaje('Error, Debe ingresar seccion obligatoriamente');
		LEAVE proc_desasignar;
	ELSEIF carnet IS NULL THEN
		CALL Mensaje('Error, Debe ingresar carnet obligatoriamente');
		LEAVE proc_desasignar;
	ELSEIF NOT (esNumero(codcurso) OR esNumero(carnet)) THEN
		CALL Mensaje('Error, Los datos de codigo de curso y carnet deben ser de tipo numericos');
		LEAVE proc_desasignar;
	ELSEIF NOT buscarCurso(codcurso) THEN
		CALL Mensaje('Error, El curso no existe');
		LEAVE proc_desasignar;
	ELSEIF NOT buscarCarnet(carnet) THEN
		CALL Mensaje('Error, El estudiante no existe');
		LEAVE proc_desasignar;
	-- 1. que el curso este habilitado
	ELSEIF NOT buscarCursoHabilitado(codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, El curso no esta habilitado');
		LEAVE proc_desasignar;
	-- 2. que el estudiante se encuentre asignado a ese curso
	ELSEIF NOT buscarEstudianteAsignado(carnet,codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, El estudiante no se encuentra asignado a ese curso');
		LEAVE proc_desasignar;
	END IF;
	SELECT id INTO @id FROM cursohabilitado WHERE CURSO_cod = codcurso AND ciclo = ciclo
	AND seccion = seccion;
	SELECT asignados.cantidad INTO @cantidad FROM asignados WHERE CURSOHABILITADO_id = @id;
	UPDATE asignados SET cantidad = @cantidad - 1 WHERE CURSOHABILITADO_id = @id;
	DELETE FROM asignacion WHERE CURSOHABILITADO_id = @id AND ESTUDIANTE_carnet = carnet;
	INSERT INTO desasignacion(CURSOHABILITADO_id,ESTUDIANTE_carnet) VALUES(@id,carnet);
	END $$
	delimiter ;

-- PROC PARA INGRESAR NOTAS(9)
delimiter $$
CREATE PROCEDURE ingresarNotas(
-- parametros
IN codcurso INT,
IN ciclo VARCHAR(2),
IN seccion VARCHAR(1),
IN carnet BIGINT,
IN nota INT
)
-- instrucciones
proc_ingresarNotas:BEGIN
	declare existe boolean;
	-- validaciones:
	-- 1. que el curso este habilitado
	-- 2. que el estudiante se encuentre asignado a ese curso
	-- 3. que la nota este entre 0 y 100
	-- 4. que la nota no haya sido ingresada anteriormente
	-- 5. aproximar nota a entero mas cercano
	-- 6. si la nota es >= 61, sumar creditos del curso a los creditos aprobados del estudiante

	IF codcurso IS NULL THEN
		CALL Mensaje('Error, Debe ingresar codigo de curso que desea ingresar nota');
		LEAVE proc_ingresarNotas;
	ELSEIF ciclo IS NULL OR  NOT validarCiclo(ciclo) THEN
		CALL Mensaje('Error, Debe ingresar ciclo, 1S,2S,VJ,VD');
		LEAVE proc_ingresarNotas;
	ELSEIF seccion IS NULL THEN
		CALL Mensaje('Error, Debe ingresar seccion obligatoriamente');
		LEAVE proc_ingresarNotas;
	ELSEIF carnet IS NULL THEN
		CALL Mensaje('Error, Debe ingresar carnet obligatoriamente');
		LEAVE proc_ingresarNotas;
	ELSEIF nota IS NULL THEN
		CALL Mensaje('Error, Debe ingresar nota obligatoriamente');
		LEAVE proc_ingresarNotas;
	ELSEIF NOT (esNumero(codcurso) OR esNumero(carnet) OR esNumero(nota)) THEN
		CALL Mensaje('Error, Los datos de codigo de curso, carnet y nota deben ser de tipo numericos');
		LEAVE proc_ingresarNotas;
	ELSEIF NOT buscarCurso(codcurso) THEN
		CALL Mensaje('Error, El curso no existe');
		LEAVE proc_ingresarNotas;
	ELSEIF NOT buscarCarnet(carnet) THEN
		CALL Mensaje('Error, El estudiante no existe');
		LEAVE proc_ingresarNotas;
	-- 1. que el curso este habilitado
	ELSEIF NOT buscarCursoHabilitado(codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, El curso no esta habilitado');
		LEAVE proc_ingresarNotas;
	-- 2. que el estudiante se encuentre asignado a ese curso
	ELSEIF NOT buscarEstudianteAsignado(carnet,codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, El estudiante no se encuentra asignado a ese curso');
		LEAVE proc_ingresarNotas;
	-- 3. que la nota este entre 0 y 100
	ELSEIF nota < 0 OR nota > 100 THEN
		CALL Mensaje('Error, La nota debe estar entre 0 y 100');
		LEAVE proc_ingresarNotas;
	-- 4. que la nota no haya sido ingresada anteriormente
	ELSEIF buscarNota(carnet,codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, La nota ya fue ingresada anteriormente');
		LEAVE proc_ingresarNotas;
	-- 5. aproximar nota a entero mas cercano
	ELSEIF nota >= 0 AND nota <= 100 THEN
		SET nota = ROUND(nota);
	-- 6. si la nota es >= 61, sumar creditos del curso a los creditos aprobados del estudiante
	ELSEIF nota >= 61 THEN
		SELECT crotorga INTO @crotorga FROM curso WHERE cod = codcurso;
		SELECT creditos INTO @creditos FROM estudiante WHERE carnet = carnet;
		UPDATE estudiante SET creditos = @creditos + @crotorga WHERE carnet = carnet;
	END IF;
	SELECT id INTO @id FROM cursohabilitado WHERE CURSO_cod = codcurso AND ciclo = ciclo
	AND seccion = seccion;
	INSERT INTO nota(CURSOHABILITADO_id,ESTUDIANTE_carnet,nota) VALUES(@id,carnet,nota);
	END $$
	delimiter ;

-- PROC GENERAR ACTA DE NOTAS(10)
delimiter $$
CREATE PROCEDURE generarActa(
-- parametros
IN codcurso INT,
IN ciclo VARCHAR(2),
IN seccion VARCHAR(1)
)
-- instrucciones
proc_generarActa:BEGIN
	-- validaciones:
	-- 1. que el curso este habilitado
	-- 2. que la cantidad de notas ingresadas sea igual a la cantidad de estudiantes asignados
	-- 3. que el curso tenga estudiantes asignados
	-- 4. que el acta no haya sido generada anteriormente
	IF codcurso IS NULL THEN
		CALL Mensaje('Error, Debe ingresar codigo de curso que desea generar acta');
		LEAVE proc_generarActa;
	ELSEIF ciclo IS NULL OR  NOT validarCiclo(ciclo) THEN
		CALL Mensaje('Error, Debe ingresar ciclo, 1S,2S,VJ,VD');
		LEAVE proc_generarActa;
	ELSEIF seccion IS NULL THEN
		CALL Mensaje('Error, Debe ingresar seccion obligatoriamente');
		LEAVE proc_generarActa;
	ELSEIF NOT (esNumero(codcurso)) THEN
		CALL Mensaje('Error, Los datos de codigo de curso deben ser de tipo numericos');
		LEAVE proc_generarActa;
	ELSEIF NOT buscarCurso(codcurso) THEN
		CALL Mensaje('Error, El curso no existe');
		LEAVE proc_generarActa;
	-- 1. que el curso este habilitado
	ELSEIF NOT buscarCursoHabilitado(codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, El curso no esta habilitado');
		LEAVE proc_generarActa;
	-- 2. que la cantidad de notas ingresadas sea igual a la cantidad de estudiantes asignados
	ELSEIF NOT cantidadNotasIgualCantidadEstudiantesAsignados(codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, La cantidad de notas ingresadas no es igual a la cantidad de estudiantes asignados');
		LEAVE proc_generarActa;
	-- 3. que el curso tenga estudiantes asignados
	ELSEIF NOT buscarEstudiantesAsignados(codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, El curso no tiene estudiantes asignados');
		LEAVE proc_generarActa;
	-- 4. que el acta no haya sido generada anteriormente
	ELSEIF buscarActa(codcurso,ciclo,seccion) THEN
		CALL Mensaje('Error, El acta ya fue generada anteriormente');
		LEAVE proc_generarActa;
	END IF;
	SELECT id INTO @id FROM cursohabilitado WHERE CURSO_cod = codcurso AND ciclo = ciclo
	AND seccion = seccion;
	-- OBTENER FECHA
	SELECT CURDATE() INTO @fecha;
	-- OBTENER HORA
	SELECT CURTIME() INTO @hora;
	INSERT INTO acta(fecha, hora, CURSOHABILITADO_id) VALUES(@fecha,@hora,@id);
	END $$
	delimiter ;

