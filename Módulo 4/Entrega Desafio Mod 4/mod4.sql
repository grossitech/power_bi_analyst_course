-- =================================================================================
-- Script para criação do Data Warehouse da Universidade (Star Schema)
-- =================================================================================

-- -----------------------------------------------------
-- Schema dw_universidade
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dw_universidade` DEFAULT CHARACTER SET utf8mb4 ;
USE `dw_universidade` ;

-- -----------------------------------------------------
-- Tabela de Dimensão: Dim_Professor
-- Armazena os dados descritivos dos professores.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dw_universidade`.`Dim_Professor` (
  `PK_Professor` INT NOT NULL AUTO_INCREMENT,
  `IdProfessor_Original` INT NULL,
  `Nome_Professor` VARCHAR(255) NULL,
  PRIMARY KEY (`PK_Professor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela de Dimensão: Dim_Departamento
-- Armazena os dados descritivos dos departamentos.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dw_universidade`.`Dim_Departamento` (
  `PK_Departamento` INT NOT NULL AUTO_INCREMENT,
  `IdDepartamento_Original` INT NULL,
  `Nome_Departamento` VARCHAR(255) NULL,
  `Campus` VARCHAR(255) NULL,
  `Nome_Professor_Coordenador` VARCHAR(255) NULL,
  PRIMARY KEY (`PK_Departamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela de Dimensão: Dim_Curso
-- Armazena os dados descritivos dos cursos.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dw_universidade`.`Dim_Curso` (
  `PK_Curso` INT NOT NULL AUTO_INCREMENT,
  `IdCurso_Original` INT NULL,
  `Nome_Curso` VARCHAR(255) NULL,
  PRIMARY KEY (`PK_Curso`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela de Dimensão: Dim_Disciplina
-- Armazena os dados descritivos das disciplinas.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dw_universidade`.`Dim_Disciplina` (
  `PK_Disciplina` INT NOT NULL AUTO_INCREMENT,
  `IdDisciplina_Original` INT NULL,
  `Nome_Disciplina` VARCHAR(255) NULL,
  `Nome_Pre_Requisitos` TEXT NULL,
  PRIMARY KEY (`PK_Disciplina`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela de Dimensão: Dim_Tempo
-- Armazena os atributos de data para análise temporal.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dw_universidade`.`Dim_Tempo` (
  `PK_Tempo` INT NOT NULL AUTO_INCREMENT,
  `Data_Completa` DATE NULL,
  `Ano` INT NULL,
  `Semestre` INT NULL,
  `Trimestre` INT NULL,
  `Mes_Numero` INT NULL,
  `Mes_Nome` VARCHAR(50) NULL,
  `Dia_da_Semana` VARCHAR(50) NULL,
  PRIMARY KEY (`PK_Tempo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela Fato: Fato_Analise_Professor
-- Tabela central que conecta as dimensões e contém as métricas.
-- O grão é: um professor ministrando uma disciplina em um curso em um determinado período.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dw_universidade`.`Fato_Analise_Professor` (
  `FK_Professor` INT NOT NULL,
  `FK_Departamento` INT NOT NULL,
  `FK_Curso` INT NOT NULL,
  `FK_Disciplina` INT NOT NULL,
  `FK_Tempo` INT NOT NULL,
  `Qtd_Disciplinas_Ministradas` INT NULL DEFAULT 1,
  INDEX `fk_Fato_Analise_Professor_Dim_Professor_idx` (`FK_Professor` ASC) VISIBLE,
  INDEX `fk_Fato_Analise_Professor_Dim_Departamento_idx` (`FK_Departamento` ASC) VISIBLE,
  INDEX `fk_Fato_Analise_Professor_Dim_Curso_idx` (`FK_Curso` ASC) VISIBLE,
  INDEX `fk_Fato_Analise_Professor_Dim_Disciplina_idx` (`FK_Disciplina` ASC) VISIBLE,
  INDEX `fk_Fato_Analise_Professor_Dim_Tempo_idx` (`FK_Tempo` ASC) VISIBLE,
  CONSTRAINT `fk_Fato_Analise_Professor_Dim_Professor`
    FOREIGN KEY (`FK_Professor`)
    REFERENCES `dw_universidade`.`Dim_Professor` (`PK_Professor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fato_Analise_Professor_Dim_Departamento`
    FOREIGN KEY (`FK_Departamento`)
    REFERENCES `dw_universidade`.`Dim_Departamento` (`PK_Departamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fato_Analise_Professor_Dim_Curso`
    FOREIGN KEY (`FK_Curso`)
    REFERENCES `dw_universidade`.`Dim_Curso` (`PK_Curso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fato_Analise_Professor_Dim_Disciplina`
    FOREIGN KEY (`FK_Disciplina`)
    REFERENCES `dw_universidade`.`Dim_Disciplina` (`PK_Disciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fato_Analise_Professor_Dim_Tempo`
    FOREIGN KEY (`FK_Tempo`)
    REFERENCES `dw_universidade`.`Dim_Tempo` (`PK_Tempo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;