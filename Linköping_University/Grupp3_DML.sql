/*
@Author:Elias Posluk
Student-ID:elipo145
@Date:2018-01-10
Group Assignment
Course: 725G28
Linköping University
*/


/*Shows our Views*/
SELECT *
  FROM staff_list;

SELECT *
  FROM artifact_list;

SELECT * 
  FROM slide_list;

/*Shows which staff has an overdue book and which books that are overdue and how long they have been overdue*/
/*Connects tables with INNER JOIN*/
SELECT BL.book_loan_id, S.staff_id, S.staff_name, S.staff_tel_nr, B.book_id, B.title, B.isbn, BL.overdue AS days_overdue
  FROM book_loans AS BL
	   INNER JOIN books AS B
	   ON BL.book_id = B.book_id
	   INNER JOIN staff AS S
	   ON BL.staff_id = S.staff_id
 WHERE BL.overdue > 0
 ORDER BY BL.overdue DESC;

/*Shows which slide is overdue, by which staff, what slide is overdue and how long it has been overdue*/
/*Connects tables with INNER JOIN*/
SELECT SL.slide_loan_id, ST.staff_id, ST.staff_name, ST.staff_tel_nr, S.slide_id, S.topic, S.slide_description, SL.overdue AS days_overdue
  FROM slide_loans AS SL
	   INNER JOIN slides AS S
	   ON SL.slide_id = S.slide_id
	   INNER JOIN staff AS ST
	   ON SL.staff_id = ST.staff_id
 ORDER BY ST.staff_id ASC;

/*Shows all artifacts id, name of the artifacts and where they have been found. Sortet in alphabetical order*/
SELECT A.artifact_id, A.artifact_name, A.date_found
  FROM artifacts AS A
 ORDER BY A.artifact_name ASC 

/*Shows how many artifacts that has been loaned out under the year 2015*/
SELECT YEAR(AL.date_loaned) AS Year, COUNT(AL.artifact_loan_id) AS artifact_loans
  FROM artifact_loans AS AL
 WHERE YEAR(AL.date_loaned) > 2015
 GROUP BY YEAR(AL.date_loaned)
	
/*Shows all staff and number of overdue loans in all categories */
SELECT S.staff_id, S.staff_name, S.staff_tel_nr, COUNT(AL.artifact_loan_id) AS artifact_loans_overdue, COUNT(BL.book_loan_id) AS book_loans_overdue, COUNT(SL.slide_loan_id) AS slide_loans_overdue
  FROM staff AS S
	   LEFT JOIN artifact_loans AS AL
	   ON AL.overdue > 0 AND AL.staff_id = S.staff_id
	   LEFT JOIN book_loans AS BL
	   ON BL.overdue > 0 AND BL.staff_id = S.staff_id
	   LEFT JOIN slide_loans AS SL
	   ON SL.overdue > 0 AND SL.staff_id = S.staff_id
 GROUP BY S.staff_id, S.staff_Name, S.staff_tel_nr;

/*Triggers our trigger function*/
DELETE  
  FROM journals 
 WHERE journal_doi = '10.100/100';

/*Location of the journal deleted in the trigger funkction above*/
SELECT *
  FROM former_journals;

/*We delete a specific scientific paper with the DOI '20.800/800' to add it later with our stored procedure in the statement below*/
DELETE  
  FROM scientific_papers 
 WHERE sp_doi = '20.800/800';

/*Executes our stored procedure which adds a scientific paper*/
EXECUTE add_scientific_paper '20.800/800', '2', 'How To Make A Stored Procedure In SQL', 'Stacko Verflow' 

/*This shows that we have managed to add a new unit to scientific_paper Table*/
SELECT * 
  FROM scientific_papers;