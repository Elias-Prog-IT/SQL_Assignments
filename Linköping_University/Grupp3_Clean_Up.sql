/*
@Author:Elias Posluk
Student-ID:elipo145
@Date:2018-01-10
Group Assignment
Course: 725G28
Linköping University
*/

/*Deletes data from every table */
DELETE  
  FROM journals;
DELETE 
  FROM scientific_papers;
DELETE
  FROM dig_site_excavators;
DELETE
  FROM slide_loans;
DELETE
  FROM slides;
DELETE
  FROM artifact_loans;
DELETE
  FROM artifacts;
DELETE
  FROM students;
DELETE
  FROM dig_sites;
DELETE
  FROM book_loans;
DELETE
  FROM books;
DELETE
  FROM library_shelves;
DELETE
  FROM staff;
DELETE
  FROM former_journals;

/*Drop Table*/
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
