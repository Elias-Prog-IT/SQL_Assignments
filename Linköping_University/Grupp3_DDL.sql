/*
@Author:Elias Posluk
Student-ID:elipo145
@Date:2018-01-10
Group Assignment
Course: 725G28
Linköping University
*/


/*Drop Table */
DROP TABLE IF EXISTS journals;
DROP TABLE IF EXISTS scientific_papers;
DROP TABLE IF EXISTS dig_site_excavators;
DROP TABLE IF EXISTS slide_loans;
DROP TABLE IF EXISTS slides;
DROP TABLE IF EXISTS artifact_loans;
DROP TABLE IF EXISTS artifacts;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS dig_sites;
DROP TABLE IF EXISTS book_loans;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS former_journals;
DROP TABLE IF EXISTS library_shelves;

/*Drop VIEWS*/
DROP VIEW IF EXISTS staff_list;
DROP VIEW IF EXISTS artifact_list;
DROP VIEW IF EXISTS slide_list;

/*Drop Stored Procedure*/
DROP PROCEDURE IF EXISTS add_scientific_paper;

/*Drop Trigger*/
DROP TRIGGER IF EXISTS journal_update;

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

/* Object:  Table former_journals*/
CREATE TABLE former_journals(
	PRIMARY KEY(journal_doi),
	journal_doi NCHAR(20)  NOT NULL,
	shelf_id	INT    NOT NULL,
	title       NCHAR(100) NOT NULL,
	author	    NCHAR(100) NOT NULL,
);

/* Object:  Table staff */
CREATE TABLE staff(
	PRIMARY KEY(staff_id),
	staff_id     INT IDENTITY(100,1) NOT NULL,
	staff_tel_nr NCHAR(20)           NOT NULL,
	staff_name   NCHAR(100)          NOT NULL,
	job_title    NCHAR(100)          NOT NULL,
);

/* Object:  Table library_shelves   */
CREATE TABLE library_shelves(
	PRIMARY KEY(shelf_id),
	shelf_id			   INT IDENTITY(1,1) NOT NULL,
	library_shelf_location VARCHAR(50)       NOT NULL,
);

/* Object: Table books  */
CREATE TABLE books(
	PRIMARY KEY(book_id),
	book_id  INT IDENTITY(1000,1) NOT NULL,
	shelf_id INT		      NOT NULL,
	title    NCHAR(100)           NOT NULL,
	author   NCHAR(100)           NOT NULL,
	isbn     NCHAR(100)           NOT NULL,
	FOREIGN KEY(shelf_id)
	REFERENCES library_shelves(shelf_id)
);

/* Object: Table book_loans */
CREATE TABLE book_loans(
	PRIMARY KEY (book_loan_id),
	book_loan_id INT IDENTITY(100,1) NOT NULL,
    book_id		 INT                 NOT NULL,
	staff_id	 INT                 NOT NULL,
	date_loaned  DATE		     NOT NULL,
	return_date  DATE		     NOT NULL,
	overdue      NUMERIC(18, 0)	     NULL,
	FOREIGN KEY(book_id)
	REFERENCES books(book_id),
	FOREIGN KEY(staff_id)
	REFERENCES staff(staff_id)
);

/* Object:  Table dig_sites */
CREATE TABLE dig_sites(
	PRIMARY KEY(dig_site_id),
	dig_site_id       INT IDENTITY(1,1) NOT NULL,
	dig_site_name     NCHAR(100)        NOT NULL UNIQUE,
	depth             NCHAR(100)	    NOT NULL,
	dig_site_location NCHAR(100)        NOT NULL,
	grid	          NCHAR(100)        NOT NULL
);

/* Object:  Table students   */
CREATE TABLE students(
	PRIMARY KEY(student_id),
	student_id     INT IDENTITY(1000,1) NOT NULL,
	student_name   NCHAR(100)           NOT NULL,
	student_tel_nr NCHAR(50)            NOT NULL,
);

/* Object:  Table artifacts    */
CREATE TABLE artifacts(
	PRIMARY KEY(artifact_id),
	artifact_id			 INT IDENTITY(1000,1)         NOT NULL,
	dig_site_id			 INT			      NOT NULL,
	student_id			 INT			      NOT NULL,
	artifact_name		 NCHAR(100)	                      NOT NULL,
	artifact_description NCHAR(100)                               NOT NULL,
	date_found			 DATE			      NOT NULL,
	artifact_shelf		 NCHAR(100)                           NOT NULL,
	FOREIGN KEY(dig_site_id)
	REFERENCES dig_sites(dig_site_id),
	FOREIGN KEY(student_id)
	REFERENCES students(student_id)
);

/* Object:  Table artifact_loans    */
CREATE TABLE artifact_loans(
	PRIMARY KEY(artifact_loan_id),
	artifact_loan_id INT IDENTITY(100,1)             NOT NULL,
	staff_id         INT				 NOT NULL,
	artifact_id      INT				 NOT NULL,
	date_loaned      DATE				 NOT NULL,
	return_date      DATE			         NOT NULL,
	overdue          NUMERIC(18, 0)		             NULL,
	FOREIGN KEY(staff_id)
	REFERENCES staff(staff_id),
	FOREIGN KEY(artifact_id)
	REFERENCES artifacts(artifact_id)
);

/* Object:  Table slides */
CREATE TABLE slides(
	PRIMARY KEY(slide_id),
	slide_id		  INT IDENTITY(1000,1)     NOT NULL,
	dig_site_id		  INT		           NOT NULL,
	artifact_id	          INT		           NOT NULL,
	slide_description         NCHAR(100)               NOT NULL,
	topic			  NCHAR(100)               NOT NULL,
	FOREIGN KEY(dig_site_id)
	REFERENCES dig_sites(dig_site_id),
	FOREIGN KEY(artifact_id)
	REFERENCES artifacts(artifact_id)
);

/* Object:  Table slide_loans    */
CREATE TABLE slide_loans(
	PRIMARY KEY(slide_loan_id),
	slide_loan_id INT IDENTITY(100,1)     NOT NULL,
	slide_id      INT 		      NOT NULL,
	staff_id      INT	 	      NOT NULL,
	date_loaned   DATE		      NOT NULL,
	return_date   DATE		      NOT NULL,
	overdue       DECIMAL(18, 0)	          NULL,
	FOREIGN KEY(slide_id)
	REFERENCES slides(slide_id),
	FOREIGN KEY(staff_id)
	REFERENCES staff(staff_id)
);

/* Object:  Table dig_site_excacavators  */
CREATE TABLE dig_site_excavators(
	PRIMARY KEY(student_id, dig_site_id), 
	student_id  INT NOT NULL,
	dig_site_id INT NOT NULL
	FOREIGN KEY(student_id)
	REFERENCES students(student_id),
	FOREIGN KEY(dig_site_id)
	REFERENCES dig_sites(dig_site_id)
);

/* Object:  Table scientific_papers */
CREATE TABLE scientific_papers(
	PRIMARY KEY(sp_doi),
	sp_doi	 NCHAR(20)  NOT NULL,
	shelf_id INT	    NOT NULL,
	title	 NCHAR(100) NOT NULL,
	author	 NCHAR(100) NOT NULL,
	FOREIGN KEY(shelf_id)
	REFERENCES library_shelves(shelf_id)
);

/* Object:  Table journals */
CREATE TABLE journals(
	PRIMARY KEY(journal_doi),
	journal_doi NCHAR(20)              NOT NULL,
	shelf_id	INT		   NOT NULL,
	title           NCHAR(100)         NOT NULL,
	author		NCHAR(100)         NOT NULL,
	FOREIGN KEY(shelf_id)
	REFERENCES library_shelves(shelf_id)
);

GO

/*Insert Into staff */ 
INSERT INTO staff (staff_tel_nr, staff_name, job_title) 
VALUES ('070555473','Jonathan Crusoe','Director'),
	   ('070555555', 'Jesper Johansson', 'Researcher'),
	   ('070555889', 'Elias Posluk', 'Supervisor'),
	   ('070654222', 'Simon HÃ¤llstorp', 'Researcher'),
	   ('070555999', 'Jakob Norlund peasant Sivermark', 'slide Librarian'),
	   ('070555485', 'Alexander CarlstrÃ¶m', 'Librarian'),
	   ('070111111', 'James Bond', 'Researcher'),
	   ('070222222', 'TorbjÃ¶rn Ost', 'Researcher');

/*Insert Into students*/
INSERT INTO students(student_name, student_tel_nr)
VALUES ('Anton MobÃ¤ck','555222333'),
	   ('Erik KarlstrÃ¶m', '6656498'),
	   ('Marcus Storm','9826722'),
	   ('Jakob Norlund peasant Sivermark','070555999'),
	   ('Alexander CarlstrÃ¶m','070555485'),
	   ('Gandalf','070-MidgÃ¥rd');

/* Insert into library_shelves*/
INSERT INTO library_shelves(library_shelf_location)
VALUES ('Room 1 Section 3'),
	   ('Room 3 Section 2'),
	   ('Room 2 Section 4'),
	   ('Room 5 Section 1'),
	   ('Room 4 Section 5');

/*Insert into books*/
INSERT INTO books(shelf_id, title, author, isbn)
VALUES (1,'How to SQL for Dummies','Steven Spielberg','12345678910111213'),
	   (2, 'How Santa is Fake News','J.R.R Tolkien','14151617181920212223'),
	   (3,'How to build rockets for dictators','Kim Jong-Un','1516171819202122232425'),
	   (4, 'How I got a bigger nuclear button','Mr.President Donald Trump','14151617181920555555'),
	   (5, 'How to write a book','Mr.CarlstrÃ¶m','14151617181920666666'),
	   (1, 'How to start a CafÃ©','Dallucci','14151617181920888888'),
	   (2, 'Computer Science for Dummies','Mr.TorbjÃ¶rn','14151617181920999999');

/*Insert Into dig_sites*/
INSERT INTO dig_sites(dig_site_name, dig_site_location, depth, grid)
VALUES ('Amazon','North of the Cave', '200m', 'A7'),
	   ('Tatooine','Mos Eisley','10m','A3'),
	   ('Atlantic Ocean','Bermuda Triangle','800m','B2'),
	   ('North Pole','Next to Mrs.Santas house','70cm','A4'),
	   ('South Pole','Next to the penguin that shit on the peasent','50cm','C4'),
	   ('4 Privet Drive','The Cupboard under the Stairs','7cm','F7'),
	   ('Helms Deep','Wall','40 cm','B3');

/*Insert Into dig_site_Excavators*/
INSERT INTO dig_site_Excavators(student_id, dig_site_id)
VALUES (1005, 6),
	   (1002, 3);
 

/*Insert Into artifacts*/
INSERT INTO artifacts(dig_site_id, student_id, artifact_name, artifact_description, date_found, artifact_shelf)
VALUES (1, 1000, 'T-Rex bone', 'The Big Bone', '2017-08-05', '2A'),
	   (1, 1000, 'Velociraptor', 'Claw', '2017-06-05', '3A'),
	   (1, 1000, 'Spinosaurus', 'His Spine', '2017-07-05', '1A'),
	   (1, 1000, 'Ankylosaurus', 'The big ball thing on his tail', '2017-06-10', '4A'),
	   (1, 1000, 'Brachiosaurus', 'The whole skeleton', '2017-09-05', '5A'),
	   (2, 1001, 'Rancor skull', 'Big teeth', '2017-02-05', '2B'),
       (2, 1001, 'Pod racer engine', 'Non functional and very rusty', '2017-03-05', '1B'),
	   (2, 1001, 'Hyper drive', 'Singed in left corner', '2017-04-05', '3B'),
	   (2, 1001, 'Stormtrooper helmet', 'Skull still inside', '2016-08-05', '4B'),
	   (2, 1001, 'Trading card', 'First edition Charizard', '1996-06-06', '5B'),
	   (3, 1002, 'Titanic', 'The Boat', '2015-08-05', '2C'),
	   (3, 1002, 'Merchant vessel', 'The Big Bone', '2015-10-05', '1C'),
	   (3, 1002, 'SS President Coolidge,', 'WW2 attack plane', '2015-03-05', '3C'),
       (3, 1002, 'Submerged Submarine', 'Big Submarine', '2015-11-05', '4C'),
	   (3, 1002, 'The true value of Bitcoin', 'Cant go any lower', '2015-12-05', '5C'),
	   (4, 1003, 'Reindeer', 'The Big Red Nose', '2014-08-05', '1D'),
	   (4, 1003, 'Wrapping paper', 'Christmassy', '2016-08-05', '2D'),	  
	   (4, 1003, 'Elves', 'The Lost souls', '2016-04-05', '3D'),		
	   (4, 1003, 'Reindeers', 'The ones that couldnt fly', '2016-03-05', '4D'),				 
	   (4, 1003, 'Santas secret stash', 'Empty inside', '2016-01-05', '5D'),
	   (7, 1004, 'Orc', 'Underwear', '2018-01-05', '1E'),			
	   (7, 1004, 'Sword', 'Still shiny', '2018-02-05', '2E'),			 
       (7, 1004, 'Elf bow', 'Made of some magical wood', '2017-02-23', '3E'),					
	   (7, 1004, 'Human bones', 'Bite marks', '2017-01-01', '4E'),	
	   (7, 1004, 'war horn', 'Pristine', '2017-08-05', '5E'),
	   (6, 1005, 'Harry Potters Underwear', 'Spiderman theme', '2013-08-05', '1F'),				 
       (6, 1005, 'Nimbus 2000', 'Non functioning', '2013-04-21', '2F'),						
	   (6, 1005, 'Invinsibility Cloak', 'Hard to keep track of. I promise it is still there', '2013-01-23', '3F'),						
	   (6, 1005, 'Wand', 'Belongs to H.Potter', '2012-04-05', '4F'),						
       (6, 1005, 'Doobies socks', 'Smelly', '2013-11-05', '5F');

/*Insert into slides*/
INSERT INTO slides(dig_site_id, artifact_id, slide_description, topic)
VALUES (1, 1000, 'Ancient, so it says', 'Dinosaur'),
	   (1, 1001, 'Ancient, so it says', 'another Dinosaur'),
	   (1, 1003, 'Ancient, so it says', 'another, another, Dinosaur'),
	   (2, 1005, 'Ugly', 'Star wars'),
	   (2, 1007, 'goes VROOM', 'Star wars'),
	   (2, 1008, 'FN2187', 'Traitor!'),
	   (3, 1010, 'Sad face', 'Iceberg wins'),
	   (3, 1011, 'Lots of gold', 'Pirate wins'),
	   (4, 1015 ,'Red nose', 'Santas bitch'),
	   (4, 1016, '100% pure', 'Snorting santa'),
	   (7, 1017, 'Underwear', 'Stinky'),
	   (7, 1019, 'Made of some magical wood', 'Stinky elves'),
	   (7, 1021, 'Plays the tune of Justin Bieber', 'Peasants!'),
	   (6, 1023, 'Warning! Very fast!', 'Dumbledore!'),
	   (6, 1024, 'I promise, it is there!', 'Deathly Hallows');

/*Insert into journal*/
INSERT INTO journals (journal_doi, shelf_id, title, author)
VALUES ('10.100/100', 1, 'About Dinosaurs', 'Mr.Bean'),
	   ('10.200/200', 2, 'About SQL for Dummies', 'Mr.Bean'),
	   ('10.300/300', 3, 'How to cook Turkey', 'Mr.Bean'),
	   ('10.400/400', 4, 'How to be a "gamer" like NS', 'Mr. Posluk'),
	   ('10.500/500', 5, 'About Dinosaurs', 'Mr.Holmberg'),
	   ('10.600/600', 1, 'About horses', 'Mr.HÃ¤llstorp'),
	   ('10.700/700', 2, 'About bitcoin', 'Mr.Johansson');
		
/*Insert Into scientific_papers*/
INSERT INTO scientific_papers(sp_doi,shelf_id,title, author)
VALUES ('20.100/100', 1, 'Science for Dummies', 'Jockie boi'),
	   ('20.200/200', 2, 'I am the one behind bitcoin', 'Jockie boi'),
	   ('20.300/300', 3, 'Tuck Frump', 'Little Rocket Man'),
	   ('20.400/400', 4, 'How to fake a nuclear button', 'Kim jong-un'),
	   ('20.500/500', 5, 'When I found a storm trooper helmet', 'Jakob Norlund peasant Sivermark'),
	   ('20.600/600', 1, 'How to dig a dig site', 'Mr.CarlstrÃ¶m'),
	   ('20.700/700', 2, 'How to fake a dig site', 'Mr.CarlstrÃ¶m');

/*Insert into book_loans*/
INSERT INTO book_loans(staff_id, book_id, date_loaned, return_date, overdue)
VALUES (100, 1000, '2017-10-10', '2017-11-10', 0),
	   (101, 1001, '2017-11-11', '2017-11-11', 0),
	   (102, 1002, '2017-12-05', '2018-01-05', 2),
	   (103, 1003, '2017-06-10', '2017-07-20', 30),
	   (104, 1004, '2017-05-10', '2017-07-10', 60);

/*Insert data into slide_loans*/
INSERT INTO slide_loans(staff_id, slide_id, date_loaned, return_date, overdue)
VALUES (105, 1000, '2017-05-10', '2017-06-01', 5),
	   (106, 1001, '2017-01-10', '2017-06-01', 100),
	   (104, 1002, '2017-02-10', '2017-04-01', 5),
	   (100, 1003, '2017-04-10', '2017-06-01', 20),
	   (101, 1004, '2017-07-10', '2018-01-01', 50);

/*Insert data into artifacts	*/
INSERT INTO artifact_loans(staff_id, artifact_id, date_loaned, return_date, overdue)
VALUES (100, 1000, '2015-05-10', '2017-06-01', 0),
	   (101, 1001, '2016-01-10', '2017-06-01', 100),
	   (102, 1002, '2017-02-10', '2017-04-01', 5),
	   (103, 1003, '2016-04-10', '2017-06-01', 20),
	   (104, 1004, '2017-07-10', '2018-01-01', 50);
GO

/*Creates View for staff_list*/
CREATE VIEW staff_list
  AS SELECT staff_id, staff_name, staff_tel_nr
       FROM staff;
GO

/*Creates View for artifact_list*/
CREATE VIEW artifact_list
  AS SELECT A.artifact_id, A.dig_site_id, S.student_id, S.student_name, A.artifact_name, A.artifact_description, A.date_found, A.artifact_shelf
       FROM artifacts AS A
			LEFT JOIN students AS S
			ON A.student_id = S.student_id;
GO

/*Creates View for slide_list*/
CREATE VIEW slide_list
  AS SELECT slide_id, dig_site_id, artifact_id, slide_description, topic
       FROM slides; 
GO

/* Trigger: former_journals  */
CREATE TRIGGER journal_update
			ON journals
  AFTER DELETE
            AS 
	     BEGIN
			   INSERT INTO former_journals (journal_doi, shelf_id, title, author)
		       SELECT N.journal_doi, N.shelf_id, N.title, N.author
		         FROM deleted AS N
	       END;
GO

/*Stored Procedure: add_scientific_paper*/
CREATE PROCEDURE add_scientific_paper
	   @sp_doi   NCHAR(20),
	   @shelf_id INT, 
	   @title    NCHAR(100), 
	   @author   NCHAR(100)
              AS 
		   BEGIN
			     INSERT INTO scientific_papers
			          VALUES (@sp_doi, @shelf_id, @title, @author)
             END;
