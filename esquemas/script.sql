-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Proyecto2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Proyecto2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Proyecto2` DEFAULT CHARACTER SET utf8 ;
USE `Proyecto2` ;

DROP TABLE IF EXISTS `Proyecto2`.`DOCENTE`;
DROP TABLE IF EXISTS `Proyecto2`.`CARRERA`;
DROP TABLE IF EXISTS `Proyecto2`.`CURSO`;
DROP TABLE IF EXISTS `Proyecto2`.`CURSOHABILITADO`;
DROP TABLE IF EXISTS `Proyecto2`.`HORARIO`;
DROP TABLE IF EXISTS `Proyecto2`.`ESTUDIANTE`;
DROP TABLE IF EXISTS `Proyecto2`.`ASIGNACION`;
DROP TABLE IF EXISTS `Proyecto2`.`DESASIGNACION`;
DROP TABLE IF EXISTS `Proyecto2`.`ASIGNADOS`;
DROP TABLE IF EXISTS `Proyecto2`.`ACTA`;
DROP TABLE IF EXISTS `Proyecto2`.`NOTA`;


-- -----------------------------------------------------
-- Table `Proyecto2`.`DOCENTE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`DOCENTE` (
  `dpi` BIGINT NOT NULL,
  `siif` INT NOT NULL,
  `nombres` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `fechanacimiento` DATE NOT NULL,
  `correo` VARCHAR(60) NOT NULL,
  `telefono` INT NOT NULL,
  `direccion` VARCHAR(200) NOT NULL,
  `fechacreacion` DATE NOT NULL,
  PRIMARY KEY (`siif`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`CARRERA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`CARRERA` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`CURSO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`CURSO` (
  `cod` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `crnecesarios` INT NOT NULL,
  `crotorga` INT NOT NULL,
  `obligatorio` TINYINT NOT NULL,
  `CARRERA_id` INT NOT NULL,
  PRIMARY KEY (`cod`),
  INDEX `fk_CURSO_CARRERA_idx` (`CARRERA_id` ASC) VISIBLE,
  CONSTRAINT `fk_CURSO_CARRERA`
    FOREIGN KEY (`CARRERA_id`)
    REFERENCES `Proyecto2`.`CARRERA` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`CURSOHABILITADO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`CURSOHABILITADO` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ciclo` VARCHAR(2) NOT NULL,
  `cupo` INT NOT NULL,
  `seccion` CHAR NOT NULL,
  `año` YEAR(4) NOT NULL,
  `CURSO_cod` INT NOT NULL,
  `DOCENTE_siif` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_CURSOHABILITADO_CURSO1_idx` (`CURSO_cod` ASC) VISIBLE,
  INDEX `fk_CURSOHABILITADO_DOCENTE1_idx` (`DOCENTE_siif` ASC) VISIBLE,
  CONSTRAINT `fk_CURSOHABILITADO_CURSO1`
    FOREIGN KEY (`CURSO_cod`)
    REFERENCES `Proyecto2`.`CURSO` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CURSOHABILITADO_DOCENTE1`
    FOREIGN KEY (`DOCENTE_siif`)
    REFERENCES `Proyecto2`.`DOCENTE` (`siif`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`HORARIO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`HORARIO` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `dia` INT NOT NULL,
  `horario` VARCHAR(45) NOT NULL,
  `CURSOHABILITADO_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_HORARIO_CURSOHABILITADO1_idx` (`CURSOHABILITADO_id` ASC) VISIBLE,
  CONSTRAINT `fk_HORARIO_CURSOHABILITADO1`
    FOREIGN KEY (`CURSOHABILITADO_id`)
    REFERENCES `Proyecto2`.`CURSOHABILITADO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`ESTUDIANTE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`ESTUDIANTE` (
  `carnet` BIGINT NOT NULL,
  `dpi` BIGINT NOT NULL,
  `nombres` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `fechanacimiento` DATE NOT NULL,
  `correo` VARCHAR(60) NOT NULL,
  `telefono` INT NOT NULL,
  `direccion` VARCHAR(200) NOT NULL,
  `creditos` INT NOT NULL DEFAULT 0,
  `fecha` DATE NOT NULL,
  `CARRERA_id` INT NOT NULL,
  PRIMARY KEY (`carnet`),
  INDEX `fk_ESTUDIANTE_CARRERA1_idx` (`CARRERA_id` ASC) VISIBLE,
  CONSTRAINT `fk_ESTUDIANTE_CARRERA1`
    FOREIGN KEY (`CARRERA_id`)
    REFERENCES `Proyecto2`.`CARRERA` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`ASIGNACION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`ASIGNACION` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `CURSOHABILITADO_id` INT NOT NULL,
  `ESTUDIANTE_carnet` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_ASIGNACION_CURSOHABILITADO1_idx` (`CURSOHABILITADO_id` ASC) VISIBLE,
  INDEX `fk_ASIGNACION_ESTUDIANTE1_idx` (`ESTUDIANTE_carnet` ASC) VISIBLE,
  CONSTRAINT `fk_ASIGNACION_CURSOHABILITADO1`
    FOREIGN KEY (`CURSOHABILITADO_id`)
    REFERENCES `Proyecto2`.`CURSOHABILITADO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ASIGNACION_ESTUDIANTE1`
    FOREIGN KEY (`ESTUDIANTE_carnet`)
    REFERENCES `Proyecto2`.`ESTUDIANTE` (`carnet`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`DESASIGNACION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`DESASIGNACION` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ESTUDIANTE_carnet` BIGINT NOT NULL,
  `CURSOHABILITADO_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_DESASIGNACION_ESTUDIANTE1_idx` (`ESTUDIANTE_carnet` ASC) VISIBLE,
  INDEX `fk_DESASIGNACION_CURSOHABILITADO1_idx` (`CURSOHABILITADO_id` ASC) VISIBLE,
  CONSTRAINT `fk_DESASIGNACION_ESTUDIANTE1`
    FOREIGN KEY (`ESTUDIANTE_carnet`)
    REFERENCES `Proyecto2`.`ESTUDIANTE` (`carnet`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DESASIGNACION_CURSOHABILITADO1`
    FOREIGN KEY (`CURSOHABILITADO_id`)
    REFERENCES `Proyecto2`.`CURSOHABILITADO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`ASIGNADOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`ASIGNADOS` (
  `cantidad` INT NOT NULL DEFAULT 0,
  `CURSOHABILITADO_id` INT NOT NULL,
  INDEX `fk_ASIGNADOS_CURSOHABILITADO1_idx` (`CURSOHABILITADO_id` ASC) VISIBLE,
  CONSTRAINT `fk_ASIGNADOS_CURSOHABILITADO1`
    FOREIGN KEY (`CURSOHABILITADO_id`)
    REFERENCES `Proyecto2`.`CURSOHABILITADO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`ACTA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`ACTA` (
  `id_acta` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `hora` TIME NOT NULL,
  `CURSOHABILITADO_id` INT NOT NULL,
  PRIMARY KEY (`id_acta`),
  INDEX `fk_ACTA_CURSOHABILITADO1_idx` (`CURSOHABILITADO_id` ASC) VISIBLE,
  CONSTRAINT `fk_ACTA_CURSOHABILITADO1`
    FOREIGN KEY (`CURSOHABILITADO_id`)
    REFERENCES `Proyecto2`.`CURSOHABILITADO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Proyecto2`.`NOTA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Proyecto2`.`NOTA` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nota` INT NOT NULL,
  `CURSOHABILITADO_id` INT NOT NULL,
  `ESTUDIANTE_carnet` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_NOTA_CURSOHABILITADO1_idx` (`CURSOHABILITADO_id` ASC) VISIBLE,
  INDEX `fk_NOTA_ESTUDIANTE1_idx` (`ESTUDIANTE_carnet` ASC) VISIBLE,
  CONSTRAINT `fk_NOTA_CURSOHABILITADO1`
    FOREIGN KEY (`CURSOHABILITADO_id`)
    REFERENCES `Proyecto2`.`CURSOHABILITADO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_NOTA_ESTUDIANTE1`
    FOREIGN KEY (`ESTUDIANTE_carnet`)
    REFERENCES `Proyecto2`.`ESTUDIANTE` (`carnet`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
