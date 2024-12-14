CREATE SCHEMA StudentDB;

USE StudentDB;

/* 
   1.Students Table:
   - `student_id` (Primary Key, Auto Increment)
   - `first_name`
   - `last_name`
   - `date_of_birth`
   - `gender`
   - `address`
   - `phone_number`
   - `email`
*/

CREATE TABLE students(
student_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(100),
last_name VARCHAR(100),
date_of_birth DATE,
gender ENUM('male', 'female', 'other'),
address TEXT,
phone_number VARCHAR(100),
email_id VARCHAR(100)
);

/* 
   2.Courses Table:
   - `course_id` (Primary Key, Auto Increment)
   - `course_code`
   - `course_name`
   - `credits`
*/

CREATE TABLE courses(
course_id INT AUTO_INCREMENT PRIMARY KEY,
course_code VARCHAR(100),
course_name VARCHAR(100),
credits INT
);

/*
   3.Enrollments Table**:
   - `enrollment_id` (Primary Key, Auto Increment)
   - `student_id` (Foreign Key from Students)
   - `course_id` (Foreign Key from Courses)
   - `enrollment_date`
*/

CREATE TABLE enrollments(
enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT,
course_id INT,
enrollment_date DATE,
FOREIGN KEY(student_id) REFERENCES students(student_id),
FOREIGN KEY(course_id) REFERENCES courses(course_id)
); 

/* 
   5.Attendance Table**:
   - `attendance_id` (Primary Key, Auto Increment)
   - `enrollment_id` (Foreign Key from Enrollments)
   - `attendance_date`
   - `status` (Present/Absent)
*/

 CREATE TABLE attendance(
 attendance_id INT AUTO_INCREMENT PRIMARY KEY,
 enrollment_id INT,
 attendance_date DATE,
 status ENUM('present', 'absent'),
 FOREIGN KEY(enrollment_id) REFERENCES enrollments(enrollment_id)
 );
 
 /* 
   4.Grades Table**:
   - `grade_id` (Primary Key, Auto Increment)
   - `enrollment_id` (Foreign Key from Enrollments)
   - `grade`
   - 'date_awarded'
*/
 
 CREATE TABLE grades(
 grade_id INT AUTO_INCREMENT PRIMARY KEY,
 enrollment_id INT,
 grade CHAR(2),
 date_awarded DATE,
 FOREIGN KEY(enrollment_id) REFERENCES enrollments(enrollment_id)
 );
 
 INSERT INTO students(first_name,last_name,date_of_birth,gender,address,phone_number,email_id)
 VALUES('John','Doe','2002-05-14','Male','123 Main St, city','555-1234','john.doe@email.com'),
	   ('Jane','Smith','2001-08-22','Female','456 Oak Ave, Town','555-5678','jane.smith@email.com'),
       ('Alice','Johnson','2003-02-17','Female','789 Pine Rd, Village','555-9012','alice.j@email.com'),
       ('Bob','Brown','2000-11-30','Male','321 Maple St, city','555-3456','bob.brown@email.com'),
       ('Emma','Davis','2002-07-19','Female','654 Elm St, Town','555-7890','emma.davis@email.com');
 
 INSERT INTO courses(course_code,course_name,credits)
 VALUES('CS101','Introduction to Programming',4),
       ('CS201','Data Structures & Algorithms',4),
       ('CS301','Database Systems',3),
       ('CS302','Web Development',4),
       ('CS303','Operating Systems',3);
       
INSERT INTO enrollments(student_id,course_id,enrollment_date)
VALUES(1,1,'2020-09-01'),
      (1,2,'2021-02-15'),
      (2,2,'2020-09-01'),
      (3,3,'2021-01-20'),
      (4,4,'2020-09-01');
      
INSERT INTO attendance(enrollment_id,attendance_date,status)
VALUES(1,'2020-09-02','Present'),
      (2,'2021-02-16','Present'),
      (3,'2020-09-02','Absent'),
      (4,'2021-01-21','Present'),
      (5,'2020-09-02','Present');
      
INSERT INTO grades(enrollment_id,grade,date_awarded)
VALUES(1,'A','2020-12-15'),
      (2,'B','2021-05-20'),
      (3,'C','2020-12-15'),
      (4,'A+','2021-05-20'),
      (5,'D','2021-04-22');
      
-- RETRIEVE ALL THE DETAILS FROM EACH TABLE
SELECT* FROM students;
SELECT* FROM courses;
SELECT* FROM enrollments;
SELECT* FROM attendance;
SELECT* FROM grades;

-- RETRIEVE STUDENTS ENROLLED IN 'INTRODUCTION TO PROGRAMMING'

SELECT s.first_name, s.last_name, s.date_of_birth, s.gender, c.course_name
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id                                             -- USING JOIN
JOIN courses c
ON c.course_id = e.course_id
WHERE course_name = 'Introduction to Programming';


SELECT first_name, last_name, date_of_birth, gender, course_name
FROM students s, courses c, enrollments e
WHERE s.student_id = e.student_id                                          -- WITHOUT USING JOIN
AND c.course_id = e.course_id
AND course_name = 'Introduction to Programming';
      
-- RETRIEVE THE GRADES OF STUDENTS
 SELECT s.first_name, s.last_name, c.course_name, g.grade
 FROM students s
 JOIN enrollments e
 ON s.student_id = e.student_id                                            -- USING JOIN
 JOIN courses c
 ON c.course_id = e.course_id
 JOIN grades g
 ON g.enrollment_id = e.enrollment_id;
 
SELECT first_name, last_name, course_name, grade
FROM students s, courses c, grades g, enrollments e
WHERE s.student_id = e.student_id                                          -- WITHOUT USING JOIN
AND c.course_id = e.course_id
AND g.enrollment_id = e.enrollment_id;

-- UPDATE :-

-- UPDATE AN INFORMATION OF A STUDENT
UPDATE Students
SET email_id = 'new.email@example.com'                                     
WHERE student_id = 1;

-- DELETE :-

-- REMOVE THE DETAILS OF A STUDENT
DELETE FROM Students
WHERE STUDENT_ID = 5;

-- COUNT THE NUMBER OF STUDENTS IN EACH COURSE

SELECT e.course_id, c.course_name, count(e.student_id) AS student_count
FROM enrollments e                                                         -- USING JOIN
JOIN courses c                                                              
ON e.course_id = c.course_id
GROUP BY e.course_id;

SELECT e.course_id, course_name, count(student_id) AS student_count
from enrollments e, courses c                                              -- WITHOUT USING JOIN
where e.course_id = c.course_id
group by e.course_id;

-- FIND STUDENTS WITH NO ENROLLMENTS
SELECT s.student_id, first_name, last_name
FROM students s
LEFT JOIN enrollments e                                                    -- USING JOIN
ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

SELECT s.student_id, first_name, last_name
FROM students s
LEFT JOIN enrollments e                                                    -- USING JOIN USING SUB QUERIES
ON s.student_id = e.student_id
WHERE s.student_id NOT IN(SELECT DISTINCT student_id FROM enrollments);

SELECT student_id, first_name, last_name
FROM students                                                              -- WITHOUT USING JOIN
WHERE student_id NOT IN(SELECT DISTINCT student_id FROM enrollments);


-- GET THE TOTAL NUMBER OF ENROLLMENTS PER STUDENT
SELECT s.student_id, s.first_name, s.last_name, COUNT(e.enrollment_id) AS no_of_enrollments
FROM students s
LEFT JOIN enrollments e                                                                                
ON s.student_id = e.student_id
GROUP BY s.student_id;    

-- FIND THE HIGHEST GRADE FOR EACH COURSE
SELECT c.course_id, c.course_name, MAX(g.grade) AS highest_grade
FROM courses c                                                             
JOIN enrollments e
ON c.course_id = e.course_id
JOIN grades g
ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;  

-- FIND THE COURSES WITH 2 OR MORE STUDENTS ENROLLED

SELECT c.course_id,c.course_name,count(e.student_id) AS no_of_students_enrolled
FROM courses c
JOIN enrollments e                                                                    
ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING count(e.student_id) >= 2;

-- GET THE ENROLLMENT DETAILS OF STUDENTS BORN AFTER A SPECIFIC DATE
   
SELECT s.first_name, s.last_name, e.enrollment_date, c.course_name
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
JOIN courses c
ON e.course_id = c.course_id
WHERE s.date_of_birth > '2003-01-04'; 

-- ADDING ANOTHER TABLE FOR FACULTIES

CREATE TABLE faculties(
	faculty_id INT PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	hire_date DATE
);

-- LINKING COURSES WITH FACULTIES

ALTER TABLE COURSES
ADD COLUMN faculty_id INT,
ADD FOREIGN KEY(faculty_id) REFERENCES faculties(faculty_id);

-- INSERT SAMPLE DATA INTO FACULTIES TABLE
   
INSERT INTO faculties(faculty_id, first_name, last_name, hire_date) 
VALUES(1, 'Louis', 'Brown', '2000-08-01'),
      (2, 'Cameron', 'White', '2005-01-15'),
      (3, 'Paul', 'Heyman', '2008-08-01');

UPDATE courses
SET faculty_id = 1 
WHERE course_id IN (1,3);

UPDATE courses
SET faculty_id = 2 
WHERE course_id IN (2,4);

UPDATE courses
SET faculty_id = 3
WHERE course_id = 5;
 
 -- FIND THE COURSES TAUGHT BY EACH FACULTY
 
 SELECT c.course_name, f.faculty_id, f.first_name, f.last_name
 FROM courses c
 JOIN faculties f                                                                   
 ON f.faculty_id = c.faculty_id;
 
 -- LIST TEACHERS AND NO. OF COURSES THEY TEACH
 
 SELECT f.faculty_id, f.first_name, f.last_name, COUNT(c.course_id) AS course_count
 FROM faculties f
 JOIN courses c                                                                        
 ON f.faculty_id = c.faculty_id
 GROUP BY c.faculty_id;
 
 
 -- GET THE DETAILS OF FALCULTIES WHO HAVE SERVED MORE THAN 17 YEARS
 
 SELECT faculty_id, first_name, last_name
 FROM faculties
 WHERE DATEDIFF(current_date(),hire_date) > 6205;
 
 
 

 
 
