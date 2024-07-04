--Question 1 Inner join: Retrieve the list of students and their enrolled courses.
SELECT s.student_name, c.course_name
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN courses c ON c.course_id = e.course_id

--Question 2 Left Join:  List all students and their enrolled courses, including those who haven't enrolled in any course.
SELECT s.student_name, c.course_name
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
LEFT JOIN courses c ON c.course_id = e.course_id

--Question 3 Right Join:  Display all courses and the students enrolled in each course, including courses with no enrolled students.
SELECT c.course_name, s.student_name
FROM students s
RIGHT JOIN enrollments e ON e.student_id = s.student_id
RIGHT JOIN courses c ON c.course_id = e.course_id

--Question 4 Self Join: Find pairs of students who are enrolled in at least one common course.
SELECT s1.student_name, s2.student_name, c.course_name
FROM enrollments e1
JOIN enrollments e2 ON e1.course_id = e2.course_id
JOIN Students s1 ON e1.student_id = s1.student_id
JOIN Students s2 ON e2.student_id = s2.student_id
JOIN Courses c ON e1.course_id = c.course_id
WHERE e1.student_id < e2.student_id

--Question 5 Complex Join: Retrieve students who are enrolled in 'Introduction to CS' but not in 'Data Structures'.
SELECT s.student_name
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE c.course_name ='Introduction to CS' 
AND s.student_name NOT IN(
	SELECT s.student_name
	FROM students s
	JOIN enrollments e ON e.student_id = s.student_id
	JOIN courses c ON c.course_id = e.course_id
	WHERE c.course_name ='Data Structures'
)
-- List all students along with a row number based on their enrollment date in ascending order.
SELECT s.student_name,e.enrollment_date,
ROW_NUMBER() OVER (ORDER BY e.enrollment_date) AS row_num
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
ORDER BY e.enrollment_date;

-- Rank students based on the number of courses they are enrolled in, handling ties by assigning the same rank.
SELECT s.student_name, RANK() OVER (ORDER BY COUNT(e.course_id) DESC) AS rank
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.student_name
ORDER BY rank;

-- Determine the dense rank of courses based on their enrollment count across all students
SELECT c.course_name, COUNT(e.student_id) AS enrollment_count, 
	    DENSE_RANK() OVER (ORDER BY COUNT(e.student_id) DESC) AS dense_rank
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY dense_rank;