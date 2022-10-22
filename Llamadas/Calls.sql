-- AGREGAR ESTUDIANTE(1)
-- SISTEMAS
CALL registrarEstudiante(201709311,'Edin Emanuel','Montenegro Vasquez','30-10-1999','edinfusion@gmail.com',12345678,'direccion',337859510101,3);
CALL registrarEstudiante(201109821,'Joel','Santos','3-5-1990','joelsants@gmail.com',12345678,'direcciondejoel',32781580101,3);
-- CIVIL
CALL registrarEstudiante(201109822,'Jorge','Santos','3-5-1990','jsants@gmail.com',12345678,'direcciondejorge',3182781580101,1);
CALL registrarEstudiante(201509823,'Carlos Eduardo','Carrega Aguilar','03-08-1998','carls@gmail.com',12345678,'direcciondecarlos',3181781580101,1);
-- INDUSTRIAL
CALL registrarEstudiante(201710156, 'JAVIER ESTURADO','ALFARO','30-10-1999','javalfr@gmail.com',12345678,'direccionjavier',3878168901,2);
CALL registrarEstudiante(201710157, 'LUIS','GALINDO','20-10-1994','luisglnd@gmail.com',89765432,'direccionluis',29781580101,2);
-- ELECTRONICA
CALL registrarEstudiante(201710158, 'JUAN','GALINDO','20-10-1994','jgal@gmail.com',89765432,'direccionjuan',29761580101,4);
CALL registrarEstudiante(201710159, 'ESTUARDO ERNESTO', 'SALVADOR MENDEZ', '01-01-1999','esternst@gmail.com',12345678,'direccionestuardo',387916890101,4);
-- ESTUDIANTESMODELOS
CALL registrarEstudiante(201710160, 'ESTUDIANTE','SISTEMAS','20-08-1994','estudiasist@gmail.com',89765432,'direccionestudisist',29791580101,3);
CALL registrarEstudiante(201710161, 'ESTUDIANTE','CIVIL','20-08-1995','estudiacivl@gmail.com',89765432,'direccionestudicivl',30791580101,1);

-- AGREGAR CARRERA(2)
CALL crearCarrera('Ingenieria Civil'); -- 1
CALL crearCarrera('Ingenieria Industrial'); -- 2
CALL crearCarrera('Ingenieria Sistemas'); -- 3
CALL crearCarrera('Ingenieria Electronica'); -- 4
CALL crearCarrera('Ingenieria Mecanica'); -- 5
CALL crearCarrera('Ingenieria Mecatronica'); -- 6
CALL crearCarrera('Ingenieria Quimica'); -- 7
CALL crearCarrera('Ingenieria Ambiental'); -- 8
CALL crearCarrera('Ingenieria Materiales'); -- 9

-- AGREGAR DOCENTE(3)
CALL registrarDocente('Docente1','Apellido1','30-10-1999','aadf@ingenieria.usac.edu.gt',12345678,'direccion',12345678910,1);
CALL registrarDocente('Docente2','Apellido2','20-11-1999','docente2@ingenieria.usac.edu.gt',12345678,'direcciondocente2',12345678911,2);
CALL registrarDocente('Docente3','Apellido3','20-12-1980','docente3@ingenieria.usac.edu.gt',12345678,'direcciondocente3',12345678912,3);
CALL registrarDocente('Docente4','Apellido4','20-11-1981','docente4@ingenieria.usac.edu.gt',12345678,'direcciondocente4',12345678913,4);
CALL registrarDocente('Docente5','Apellido5','20-09-1982','docente5@ingenieria.usac.edu.gt',12345678,'direcciondocente5',12345678914,5);

-- AGREGAR CURSO(4)
-- codigo, nombre, crn, cro, idcarrera, obligatorio
-- AREA COMUN
CALL crearCurso(0006,'Idioma Tecnico 1',0,7,0,false); 
CALL crearCurso(0007,'Idioma Tecnico 2',0,7,0,false);
CALL crearCurso(101,'MB 1',0,7,0,true); 
CALL crearCurso(103,'MB 2',0,7,0,true); 
CALL crearCurso(017,'SOCIAL HUMANISTICA 1',0,4,0,true); 
CALL crearCurso(019,'SOCIAL HUMANISTICA 2',0,4,0,true); 
CALL crearCurso(348,'QUIMICA GENERAL',0,3,0,true); 
-- INGENIERIA EN SISTEMAS
CALL crearCurso(777,'Compiladores 1',80,4,3,true); 
CALL crearCurso(770,'INTR. A la Programacion y computacion 1',0,4,3,true); 
CALL crearCurso(960,'MATE COMPUTO 1',33,5,3,true); 
CALL crearCurso(795,'lOGICA DE SISTEMAS',33,2,3,true);
CALL crearCurso(796,'LENGUAJES FORMALES Y DE PROGRAMACIÓN',0,3,3,TRUE);
-- INGENIERIA INDUSTRIAL
CALL crearCurso(123,'Curso Industrial 1',0,4,2,true); 
CALL crearCurso(124,'Curso Industrial 2',0,4,2,true);
CALL crearCurso(125,'Curso Industrial enseñar a pensar',10,2,2,true);
CALL crearCurso(126,'Curso Industrial ENSEÑAR A DIBUJAR',2,4,2,true);
CALL crearCurso(127,'Curso Industrial 3',8,4,2,true);
-- INGENIERIA CIVIL
CALL crearCurso(321,'Curso Civil 1',0,4,1,true);
CALL crearCurso(322,'Curso Civil 2',4,4,1,true);
CALL crearCurso(323,'Curso Civil 3',8,4,1,true);
CALL crearCurso(324,'Curso Civil 4',12,4,1,true);
CALL crearCurso(325,'Curso Civil 5',16,4,1,true);
CALL crearCurso(0250,'Mecanica de Fluidos',0,5,1,true);
-- INGENIERIA ELECTRONICA
CALL crearCurso(421,'Curso Electronica 1',0,4,4,true);
CALL crearCurso(422,'Curso Electronica 2',4,4,4,true);
CALL crearCurso(423,'Curso Electronica 3',8,4,4,true);
CALL crearCurso(424,'Curso Electronica 4',12,4,4,true);
CALL crearCurso(425,'Curso Electronica 5',16,4,4,true);


-- AGREGAR CURSO HABILITADO(5)
-- codcurso, ciclo, siidocente, cupomax, seccion
CALL habilitarCurso(101,'2S',1,110,'A');
-- AGREGAR HORARIO DE CURSO HABILITADO(6)
-- codcursohabiltado, dia, horario
CALL agregarHorario(1,3,"9:00-10:40");
-- ASIGNAR CURSO ESTUDIANTE(7)
-- codcurso, ciclo, seccion, carnet
CALL asignarCursoEstudiante(101,'2S','a',201709311);
CALL asignarCursoEstudiante(101,'2S','a',201109821);
-- DESASIGNAR CURSO ESTUDIANTE(8)
-- codcurso, ciclo, seccion, carnet
CALL desasignarCursoEstudiante(101,'1S','a',201709311);
-- INGRESAR NOTA(9)
CALL ingresarNotas(101,'2S','a',201709311,61);
CALL ingresarNotas(101,'2S','a',201109821,60.4);
-- GENERAR ACTA(10)
CALL generarActa(101,'2S','a');



