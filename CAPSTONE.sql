CREATE DATABASE e_learning_purchase;
USE e_learning_purchase;
SHOW TABLES;

CREATE TABLE learners (
              	learner_id INT Primary Key,
                full_name VARCHAR(50),
                Country   VARCHAR(50)
);
CREATE TABLE courses(
			 	course_id INT Primary Key,
                course_name VARCHAR(25),
				category VARCHAR(25),
				unit_price DECIMAL(10,2)
                );

CREATE TABLE purchases (
               purchase_id INT Primary Key,
	           learner_id INT,
			course_id INT,
	           Quantity INT,
	           purchase_date DATE,
               FOREIGN Key (learner_id)REFERENCES  learners(learner_id),
              FOREIGN Key (course_id) REFERENCES  courses(course_id)
               );

INSERT INTO learners (	learner_id, full_name,Country) VALUES
(1, 'Arun Kumar', 'India'),
(2, 'Meena Raj', 'USA'),
(3, 'John Peter', 'UK'),
(4, 'Divya Sri', 'India'),
(5, 'Rahul Das', 'Canada'),
(6, 'Sara Khan', 'Australia'),
(7, 'Vijay Kumar', 'Singapore'),
(8, 'Anitha Roy', 'India');
     
INSERT INTO courses(course_id,course_name,category,unit_price )
                 VALUES 
                (101, 'Python Basics', 'Programming', 50.00),
(102, 'SQL Fundamentals', 'Database', 40.00),
(103, 'Power BI Essentials', 'Data Analytics', 60.00),
(104, 'Digital Marketing', 'Marketing', 45.00),
(105, 'Excel Advanced', 'Data Analytics', 35.00),
(106, 'Java Programming', 'Programming', 70.00);
   INSERT INTO  purchases(purchase_id ,learner_id,course_id,Quantity, purchase_date)VALUES
				
(2001, 1, 101, 2, '2026-01-05'),
(2002, 1, 102, 1, '2026-01-12'),
(2003, 2, 103, 1, '2026-02-10'),
(2004, 2, 104, 2, '2026-02-20'),
(2005, 3, 102, 3, '2026-03-05'),
(2006, 3, 105, 1, '2026-03-15'),
(2007, 4, 103, 2, '2026-04-10'),
(2008, 4, 101, 1, '2026-04-20'),
(2009, 5, 104, 1, '2026-05-05'),
(2010, 5, 105, 2, '2026-05-15'),
(2011, 6, 101, 3, '2026-06-01'),
(2012, 6, 103, 1, '2026-06-10'),
(2013, 1, 105, 2, '2026-07-05'),
(2014, 2, 102, 1, '2026-07-15'),
(2015, 4, 104, 1, '2026-08-01');
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS learners;
   SELECT * FROM learners;
      SELECT * FROM courses;
         SELECT * FROM purchases;
	SELECT l.learner_id,
    l.full_name AS learner_name,
    
	c.course_name, c.category, p.quantity, p.purchase_date,ROUND(p.Quantity*c.unit_price,2)AS total_amount
    FROM learners l  /*start with the learners table*/
    INNER JOIN purchases p 
    ON p.learner_id=l.learner_id /*connect the learners and purchases*/
     INNER JOIN courses  c       
    ON c.course_id=p.course_id
    ORDER BY total_amount DESC;
    SHOW TABLES;
    SELECT l.learner_id,
    l.full_name AS learner_name,
	c.course_name, c.category, p.quantity, p.purchase_date,ROUND(p.Quantity*c.unit_price,2)AS total_amount
    FROM learners l  
    LEFT JOIN purchases p 
    ON p.learner_id=l.learner_id
     LEFT JOIN courses c
    ON c.course_id=p.course_id
    ORDER BY total_amount DESC;
    
    
    SELECT l.learner_id,
    l.full_name AS learner_name,
    
	c.course_name, c.category, p.quantity, p.purchase_date,ROUND(p.Quantity*c.unit_price,2)AS total_amount
    FROM learners l  
    RIGHT JOIN purchases p 
    ON p.learner_id=l.learner_id
     RIGHT JOIN courses c
    ON c.course_id=p.course_id
    ORDER BY total_amount DESC;
    
    --  3. Analytical Queries
  --    Q1. Display each learner’s total spending (quantity × unit_price) along with their country.
    SELECT l.learner_id,l.full_name,ROUND(SUM(p.Quantity*c.unit_price),2) AS Total_spending 
    FROM learners l 
    JOIN purchases  p           /*connected purchases and learners*/
    ON p.learner_id=l.learner_id /*because learners name in learners table and purchases in purchase table*/
    JOIN courses c              /*connected courses and purchases*/
    ON c.course_id=p.course_id  /* because course id in courses table and price i purchase table*/
    GROUP BY 
    l.learner_id,               /*GROUP BY puts the same learner's purchases together*/
    l.full_name,
    l.country
    ORDER BY Total_spending DESC;/*ordered by decending order*/
    
    --  Q2. Find the top 3 most purchased courses based on total quantity sold
    SELECT c.course_id,c.course_name,SUM(p.Quantity)AS total_quantity
    FROM courses c
      JOIN purchases p          /*connected purchases and courses*/
	
    ON c.course_id=p.course_id   /*course id in courses table and quantity in purchase table*/
    GROUP BY 
    c.course_id,
    c.course_name   /*purchases individual groups record*/
    ORDER BY
    total_quantity
    LIMIT 3;
    
    --  3.Show each course category’s total revenue and the number of unique learners who purchased from that category.
    SELECT c.category,sum(p.quantity*c.unit_price)  AS total_revenue, COUNT(DISTINCT p.learner_id) AS unique_learner
    FROM courses c 
    JOIN purchases p 
    ON c.course_id=p.course_id
    GROUP BY c.category
    ORDER BY total_revenue DESC;
    --  Q4.List all learners who have purchased courses from more than one category.
    SELECT l.learner_id,l.full_name AS learner_name,COUNT(DISTINCT c.category) AS catagory_count
    FROM learners l
    JOIN purchases p
    ON l.learner_id=p.learner_id
    JOIN courses c
    ON p.course_id=c.course_id
    
    GROUP BY
    l.learner_id,l.full_name
    HAVING COUNT(DISTINCT c.category)>1;
    --  Q5. Identify courses that have not been purchased at all.
    SELECT c.course_id,c.course_name,c.category
    FROM courses c 
    JOIN purchases p  
    ON p.course_id=c.course_id
    WHERE p.course_id=null;
    
    