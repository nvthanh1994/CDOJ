CREATE SCHEMA IF NOT EXISTS `uestcojtest` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `uestcojtest` ;

-- -----------------------------------------------------
-- Table `uestcojtest`.`department`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`department` (
  `departmentId` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(50) NOT NULL DEFAULT '',
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`departmentId`) ,
  UNIQUE INDEX `departmentId_UNIQUE` (`departmentId` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`user`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`user` (
  `userId` INT NOT NULL AUTO_INCREMENT ,
  `userName` VARCHAR(24) NOT NULL ,
  `studentId` VARCHAR(50) NOT NULL ,
  `departmentId` INT NOT NULL ,
  `password` VARCHAR(40) NOT NULL COMMENT 'need to validate\nuse SHA1 encoding' ,
  `school` VARCHAR(100) NOT NULL DEFAULT '' ,
  `nickName` VARCHAR(50) NOT NULL COMMENT 'length >= 3' ,
  `email` VARCHAR(100) NOT NULL COMMENT 'need to validate' ,
  `solved` INT NOT NULL DEFAULT 0 ,
  `tried` INT NOT NULL DEFAULT 0 ,
  `type` INT NOT NULL DEFAULT 0 ,
  `lastLogin` DATETIME NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`userId`) ,
  UNIQUE INDEX `userId_UNIQUE` (`userId` ASC) ,
  UNIQUE INDEX `userName_UNIQUE` (`userName` ASC) ,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) ,
  INDEX `FK_departmentId_on_department_idx` (`departmentId` ASC) ,
  CONSTRAINT `FK_user_departmentId_on_department`
    FOREIGN KEY (`departmentId` )
    REFERENCES `uestcojtest`.`department` (`departmentId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`problem`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`problem` (
  `problemId` INT NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(50) NOT NULL ,
  `description` TEXT NOT NULL ,
  `input` TEXT NOT NULL ,
  `output` TEXT NOT NULL ,
  `sampleInput` TEXT NOT NULL ,
  `sampleOutput` TEXT NOT NULL ,
  `hint` TEXT NOT NULL ,
  `source` VARCHAR(100) NOT NULL DEFAULT '' ,
  `timeLimit` INT NOT NULL DEFAULT 1000 ,
  `memoryLimit` INT NOT NULL DEFAULT 65535 ,
  `solved` INT NOT NULL DEFAULT 0 ,
  `tried` INT NOT NULL DEFAULT 0 ,
  `isSPJ` TINYINT(1) NOT NULL ,
  `isVisible` TINYINT(1) NOT NULL ,
  `outputLimit` INT NOT NULL DEFAULT 8000 ,
  `javaTimeLimit` INT NOT NULL DEFAULT 3000 ,
  `javaMemoryLimit` INT NOT NULL DEFAULT 65535 ,
  `dataCount` INT NOT NULL DEFAULT 1 ,
  `difficulty` INT NOT NULL DEFAULT 1 ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`problemId`) ,
  UNIQUE INDEX `problemId_UNIQUE` (`problemId` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`contest`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`contest` (
  `contestId` INT NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(50) NOT NULL COMMENT 'length >= 3' ,
  `description` VARCHAR(200) NOT NULL DEFAULT '' ,
  `type` TINYINT NOT NULL DEFAULT 0 ,
  `time` DATETIME NOT NULL ,
  `length` INT NOT NULL ,
  `isVisible` TINYINT(1) NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`contestId`) ,
  UNIQUE INDEX `contestId_UNIQUE` (`contestId` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`article`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`article` (
  `articleId` INT NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(50) NOT NULL ,
  `content` TEXT NOT NULL ,
  `author` VARCHAR(50) NOT NULL DEFAULT '' ,
  `time` DATETIME NOT NULL ,
  `clicked` INT NOT NULL DEFAULT 0 ,
  `order` INT NOT NULL DEFAULT 0 COMMENT 'set order to top and move' ,
  `isNotice` TINYINT(1) NOT NULL DEFAULT 0 ,
  `isVisible` TINYINT(1) NOT NULL DEFAULT 0 ,
  `parentId` INT NULL DEFAULT NULL ,
  `problemId` INT NULL DEFAULT NULL ,
  `contestId` INT NULL DEFAULT NULL ,
  `userId` INT NULL DEFAULT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`articleId`) ,
  UNIQUE INDEX `noticeId_UNIQUE` (`articleId` ASC) ,
  INDEX `FK_parentId_on_article_idx` (`parentId` ASC) ,
  INDEX `FK_problemId_on_problem_idx` (`problemId` ASC) ,
  INDEX `FK_contestId_on_contest_idx` (`contestId` ASC) ,
  INDEX `FK_userId_on_user_idx` (`userId` ASC) ,
  CONSTRAINT `FK_article_parentId_on_article`
    FOREIGN KEY (`parentId` )
    REFERENCES `uestcojtest`.`article` (`articleId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_article_problemId_on_problem`
    FOREIGN KEY (`problemId` )
    REFERENCES `uestcojtest`.`problem` (`problemId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_article_contestId_on_contest`
    FOREIGN KEY (`contestId` )
    REFERENCES `uestcojtest`.`contest` (`contestId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_article_userId_on_user`
    FOREIGN KEY (`userId` )
    REFERENCES `uestcojtest`.`user` (`userId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`message`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`message` (
  `messageId` INT NOT NULL AUTO_INCREMENT ,
  `senderId` INT NOT NULL ,
  `receiverId` INT NOT NULL ,
  `title` VARCHAR(50) NOT NULL DEFAULT '' ,
  `content` TEXT NOT NULL ,
  `time` DATETIME NOT NULL ,
  `isOpened` TINYINT(1) NOT NULL DEFAULT 0 ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`messageId`) ,
  UNIQUE INDEX `messageId_UNIQUE` (`messageId` ASC) ,
  INDEX `FK_senderId_on_user_idx` (`senderId` ASC) ,
  INDEX `FK_receiverId_on_user_idx` (`receiverId` ASC) ,
  CONSTRAINT `FK_message_senderId_on_user`
    FOREIGN KEY (`senderId` )
    REFERENCES `uestcojtest`.`user` (`userId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_message_receiverId_on_user`
    FOREIGN KEY (`receiverId` )
    REFERENCES `uestcojtest`.`user` (`userId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`contestUser`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`contestUser` (
  `contestUserId` INT NOT NULL AUTO_INCREMENT ,
  `contestId` INT NOT NULL ,
  `userId` INT NOT NULL ,
  `status` TINYINT(4) NOT NULL COMMENT '0 - wait for validating\n1 - accepted\n2 - refused' ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`contestUserId`) ,
  UNIQUE INDEX `contestUserId_UNIQUE` (`contestUserId` ASC) ,
  INDEX `FK_contestId_on_contest_idx` (`contestId` ASC) ,
  INDEX `FK_userId_on_user_idx` (`userId` ASC) ,
  CONSTRAINT `FK_contestUser_contestId_on_contest`
    FOREIGN KEY (`contestId` )
    REFERENCES `uestcojtest`.`contest` (`contestId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_contestUser_userId_on_user`
    FOREIGN KEY (`userId` )
    REFERENCES `uestcojtest`.`user` (`userId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`contestProblem`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`contestProblem` (
  `contestProblemId` INT NOT NULL AUTO_INCREMENT ,
  `contestId` INT NOT NULL ,
  `problemId` INT NOT NULL ,
  `order` INT NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`contestProblemId`) ,
  UNIQUE INDEX `contestProblemId_UNIQUE` (`contestProblemId` ASC) ,
  INDEX `FK_contestId_on_contest_idx` (`contestId` ASC) ,
  INDEX `FK_problemId_on_problem_idx` (`problemId` ASC) ,
  CONSTRAINT `FK_contestProblem_contestId_on_contest`
    FOREIGN KEY (`contestId` )
    REFERENCES `uestcojtest`.`contest` (`contestId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_contestProblem_problemId_on_problem`
    FOREIGN KEY (`problemId` )
    REFERENCES `uestcojtest`.`problem` (`problemId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`tag`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`tag` (
  `tagId` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(50) NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`tagId`) ,
  UNIQUE INDEX `tagId_UNIQUE` (`tagId` ASC) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`problemTag`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`problemTag` (
  `problemTagId` INT NOT NULL AUTO_INCREMENT ,
  `problemId` INT NOT NULL ,
  `tagId` INT NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`problemTagId`) ,
  UNIQUE INDEX `problemTagId_UNIQUE` (`problemTagId` ASC) ,
  INDEX `FK_problemId_on_problem_idx` (`problemId` ASC) ,
  INDEX `FK_tagId_on_tag_idx` (`tagId` ASC) ,
  CONSTRAINT `FK_problemTag_problemId_on_problem`
    FOREIGN KEY (`problemId` )
    REFERENCES `uestcojtest`.`problem` (`problemId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_problemTag_tagId_on_tag`
    FOREIGN KEY (`tagId` )
    REFERENCES `uestcojtest`.`tag` (`tagId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`language`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`language` (
  `languageId` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(50) NOT NULL ,
  `extension` VARCHAR(10) NOT NULL ,
  `param` TEXT NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`languageId`) ,
  UNIQUE INDEX `languageId_UNIQUE` (`languageId` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`code`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`code` (
  `codeId` INT NOT NULL AUTO_INCREMENT ,
  `content` TEXT NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`codeId`) ,
  UNIQUE INDEX `codeId_UNIQUE` (`codeId` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`compileInfo`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`compileInfo` (
  `compileInfoId` INT NOT NULL AUTO_INCREMENT ,
  `content` TEXT NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`compileInfoId`) ,
  UNIQUE INDEX `compileInfoId_UNIQUE` (`compileInfoId` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`status`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`status` (
  `statusId` INT NOT NULL AUTO_INCREMENT ,
  `userId` INT NOT NULL ,
  `problemId` INT NOT NULL ,
  `result` INT NOT NULL ,
  `memoryCost` INT NOT NULL ,
  `timeCost` INT NOT NULL ,
  `languageId` INT NOT NULL ,
  `length` INT NOT NULL ,
  `time` DATETIME NOT NULL ,
  `contestId` INT NULL DEFAULT NULL ,
  `caseNumber` INT NOT NULL DEFAULT 0 ,
  `codeId` INT NOT NULL ,
  `compileInfoId` INT NULL DEFAULT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`statusId`) ,
  UNIQUE INDEX `statusId_UNIQUE` (`statusId` ASC) ,
  INDEX `FK_userID_on_user_idx` (`userId` ASC) ,
  INDEX `FK_problemId_on_problem_idx` (`problemId` ASC) ,
  INDEX `FK_languageId_on_language_idx` (`languageId` ASC) ,
  INDEX `FK_contestId_on_contst_idx` (`contestId` ASC) ,
  INDEX `FK_codeId_on_code_idx` (`codeId` ASC) ,
  INDEX `FK_compileInfoId_on_compileInfo_idx` (`compileInfoId` ASC) ,
  CONSTRAINT `FK_status_userID_on_user`
    FOREIGN KEY (`userId` )
    REFERENCES `uestcojtest`.`user` (`userId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_status_problemId_on_problem`
    FOREIGN KEY (`problemId` )
    REFERENCES `uestcojtest`.`problem` (`problemId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_status_languageId_on_language`
    FOREIGN KEY (`languageId` )
    REFERENCES `uestcojtest`.`language` (`languageId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_status_contestId_on_contest`
    FOREIGN KEY (`contestId` )
    REFERENCES `uestcojtest`.`contest` (`contestId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_status_codeId_on_code`
    FOREIGN KEY (`codeId` )
    REFERENCES `uestcojtest`.`code` (`codeId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_status_compileInfoId_on_compileInfo`
    FOREIGN KEY (`compileInfoId` )
    REFERENCES `uestcojtest`.`compileInfo` (`compileInfoId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`contestTeamInfo`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`contestTeamInfo` (
  `teamId` INT NOT NULL AUTO_INCREMENT ,
  `userId` INT NOT NULL ,
  `name` VARCHAR(50) NOT NULL DEFAULT '' ,
  `coderName` VARCHAR(150) NOT NULL DEFAULT '' ,
  `sex` VARCHAR(3) NOT NULL DEFAULT '' ,
  `department` VARCHAR(50) NOT NULL DEFAULT '' ,
  `grade` VARCHAR(50) NOT NULL DEFAULT '' ,
  `phone` VARCHAR(100) NOT NULL DEFAULT '' ,
  `size` VARCHAR(50) NOT NULL DEFAULT '' ,
  `email` VARCHAR(300) NOT NULL DEFAULT '' ,
  `school` VARCHAR(100) NOT NULL DEFAULT '' ,
  `state` TINYINT(4) NOT NULL DEFAULT 0 ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`teamId`) ,
  UNIQUE INDEX `teamId_UNIQUE` (`teamId` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`userSerialKey`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`userSerialKey` (
  `userSerialKeyId` INT NOT NULL AUTO_INCREMENT ,
  `userId` INT NOT NULL ,
  `serialKey` VARCHAR(128) NOT NULL ,
  `time` DATETIME NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  PRIMARY KEY (`userSerialKeyId`) ,
  UNIQUE INDEX `userSerialKeyId_UNIQUE` (`userSerialKeyId` ASC) ,
  INDEX `FK_userId_on_user_idx` (`userId` ASC) ,
  CONSTRAINT `FK_userSerialKey_userId_on_user`
    FOREIGN KEY (`userId` )
    REFERENCES `uestcojtest`.`user` (`userId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`trainingContest`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`trainingContest` (
  `trainingContestId` INT NOT NULL AUTO_INCREMENT ,
  `isPersonal` TINYINT(1) NOT NULL ,
  `title` VARCHAR(150) NOT NULL DEFAULT '' ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  `type` VARCHAR(45) NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`trainingContestId`) ,
  UNIQUE INDEX `traningContestId_UNIQUE` (`trainingContestId` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`trainingUser`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`trainingUser` (
  `trainingUserId` INT NOT NULL AUTO_INCREMENT ,
  `rating` DOUBLE NOT NULL ,
  `volatility` DOUBLE NOT NULL ,
  `type` INT NOT NULL ,
  `userId` INT NOT NULL ,
  `OPTLOCK` INT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  `allow` TINYINT(1) NOT NULL ,
  `ratingVary` DOUBLE NULL ,
  `volatilityVary` DOUBLE NULL ,
  `competitions` INT NOT NULL ,
  `member` VARCHAR(128) NOT NULL ,
  PRIMARY KEY (`trainingUserId`) ,
  UNIQUE INDEX `trainingUserId_UNIQUE` (`trainingUserId` ASC) ,
  INDEX `FK_trainingUser_userId_on_user_idx` (`userId` ASC) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) ,
  CONSTRAINT `FK_trainingUser_userId_on_user`
    FOREIGN KEY (`userId` )
    REFERENCES `uestcojtest`.`user` (`userId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `uestcojtest`.`trainingStatus`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `uestcojtest`.`trainingStatus` (
  `trainingStatusId` INT NOT NULL AUTO_INCREMENT ,
  `trainingContestId` INT NOT NULL ,
  `trainingUserId` INT NOT NULL ,
  `rating` DOUBLE NOT NULL ,
  `volatility` DOUBLE NOT NULL ,
  `OPTLOCK` INT NULL DEFAULT 0 ,
  `rank` INT NOT NULL ,
  `solve` INT NOT NULL ,
  `penalty` INT NOT NULL ,
  `ratingVary` DOUBLE NOT NULL ,
  `volatilityVary` DOUBLE NOT NULL ,
  `summary` TEXT NOT NULL ,
  PRIMARY KEY (`trainingStatusId`) ,
  UNIQUE INDEX `trainingStatusId_UNIQUE` (`trainingStatusId` ASC) ,
  INDEX `FK_trainingStatus_trainingContestId_on_trainingContest_idx` (`trainingContestId` ASC) ,
  INDEX `FK_trainingStatus_trainingUserId_on_user_idx` (`trainingUserId` ASC) ,
  CONSTRAINT `FK_trainingStatus_trainingContestId_on_trainingContest`
    FOREIGN KEY (`trainingContestId` )
    REFERENCES `uestcojtest`.`trainingContest` (`trainingContestId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_trainingStatus_trainingUserId_on_trainingUser`
    FOREIGN KEY (`trainingUserId` )
    REFERENCES `uestcojtest`.`trainingUser` (`trainingUserId` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;
