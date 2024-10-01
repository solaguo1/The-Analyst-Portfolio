-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema school
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema school
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `school` DEFAULT CHARACTER SET utf8 ;
USE `school` ;

-- -----------------------------------------------------
-- Table `school`.`Students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `school`.`Students` (
  `Student_ID` INT NOT NULL AUTO_INCREMENT,
  `First_name` VARCHAR(50) NOT NULL,
  `Last_name` VARCHAR(50) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  `Date_Register` DATETIME NOT NULL,
  PRIMARY KEY (`Student_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`Instructors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `school`.`Instructors` (
  `Instructor_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NULL,
  PRIMARY KEY (`Instructor_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`Courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `school`.`Courses` (
  `Course_ID` INT NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(255) NOT NULL,
  `Price` DECIMAL(5,2) NOT NULL,
  `Instructor_id` SMALLINT NOT NULL,
  PRIMARY KEY (`Course_ID`),
  INDEX `fk_Courses_Instructors1_idx` (`Instructor_id` ASC) VISIBLE,
  CONSTRAINT `fk_Courses_Instructors1`
    FOREIGN KEY (`Instructor_id`)
    REFERENCES `school`.`Instructors` (`Instructor_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`Enrollment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `school`.`Enrollment` (
  `Student_ID` INT NOT NULL,
  `Course_ID` INT NOT NULL,
  `Date` DATETIME NOT NULL,
  `Price` DECIMAL(5,2) NOT NULL,
  INDEX `fk_Enrollment_Students_idx` (`Student_ID` ASC) VISIBLE,
  INDEX `fk_Enrollment_Courses1_idx` (`Course_ID` ASC) VISIBLE,
  PRIMARY KEY (`Student_ID`, `Course_ID`),
  CONSTRAINT `fk_Enrollment_Students`
    FOREIGN KEY (`Student_ID`)
    REFERENCES `school`.`Students` (`Student_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Enrollment_Courses`
    FOREIGN KEY (`Course_ID`)
    REFERENCES `school`.`Courses` (`Course_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`Tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `school`.`Tag` (
  `Tag_ID` TINYINT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Tag_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `school`.`Course_tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `school`.`Course_tags` (
  `Course_ID` INT NOT NULL,
  `Tag_ID` TINYINT NOT NULL,
  INDEX `fk_Course_tags_Courses1_idx` (`Course_ID` ASC) VISIBLE,
  INDEX `fk_Course_tags_Tag1_idx` (`Tag_ID` ASC) VISIBLE,
  PRIMARY KEY (`Tag_ID`, `Course_ID`),
  CONSTRAINT `fk_Course_tags_Courses1`
    FOREIGN KEY (`Course_ID`)
    REFERENCES `school`.`Courses` (`Course_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Course_tags_Tag1`
    FOREIGN KEY (`Tag_ID`)
    REFERENCES `school`.`Tag` (`Tag_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
