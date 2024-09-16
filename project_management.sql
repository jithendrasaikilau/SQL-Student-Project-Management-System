-- Create the database
CREATE DATABASE ProjectManagement;

-- Use the database
USE ProjectManagement;

-- Table to store students
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    year INT CHECK (year IN (2, 3))  -- Only 2nd and 3rd year students
);

-- Table to store projects
CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(150) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE
);

-- Table to store supervisors
CREATE TABLE supervisors (
    supervisor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Table to store tasks for each project
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    task_name VARCHAR(150) NOT NULL,
    description TEXT,
    project_id INT,
    due_date DATE,
    status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);

-- Table to link students with projects (many-to-many relationship)
CREATE TABLE student_project (
    student_id INT,
    project_id INT,
    PRIMARY KEY (student_id, project_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);

-- Table to link supervisors with projects (one-to-many relationship)
CREATE TABLE project_supervisor (
    project_id INT,
    supervisor_id INT,
    PRIMARY KEY (project_id, supervisor_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (supervisor_id) REFERENCES supervisors(supervisor_id) ON DELETE CASCADE
);

-- Insert sample data into students
INSERT INTO students (name, email, year) VALUES
('Alice', 'alice@example.com', 2),
('Bob', 'bob@example.com', 3),
('Charlie', 'charlie@example.com', 2);

-- Insert more students into the students table
INSERT INTO students (name, email, year) VALUES
('David', 'david@example.com', 2),  -- This is student_id 4
('Eva', 'eva@example.com', 3),      -- This is student_id 5
('Frank', 'frank@example.com', 3),  -- This is student_id 6
('Grace', 'grace@example.com', 2),  -- This is student_id 7
('Henry', 'henry@example.com', 3);  -- This is student_id 8

-- Insert sample data into supervisors
INSERT INTO supervisors (name, email) VALUES
('Dr. Smith', 'smith@example.com'),
('Prof. Johnson', 'johnson@example.com');

-- Insert more sample data into supervisors
INSERT INTO supervisors (name, email) VALUES
('Dr. Lee', 'lee@example.com'),
('Prof. Adams', 'adams@example.com'),
('Dr. Garcia', 'garcia@example.com');

-- Insert sample data into projects
INSERT INTO projects (project_name, description, start_date, end_date) VALUES
('AI Research', 'Project on AI development', '2023-09-01', '2024-05-01'),
('Data Analysis', 'Big data project', '2023-08-15', '2024-02-01');

-- Insert more sample data into projects
INSERT INTO projects (project_name, description, start_date, end_date) VALUES
('Blockchain Development', 'Research and develop blockchain applications', '2023-10-01', '2024-06-01'),
('Cybersecurity', 'Project on modern cybersecurity techniques', '2023-09-15', '2024-03-01'),
('Natural Language Processing', 'NLP research and model building', '2023-11-01', '2024-07-01');

-- Link students to projects
INSERT INTO student_project (student_id, project_id) VALUES
(1, 1),  -- Alice is assigned to AI Research
(2, 1),  -- Bob is assigned to AI Research
(3, 2);  -- Charlie is assigned to Data Analysis

-- Link more students to projects
INSERT INTO student_project (student_id, project_id) VALUES
(4, 3),  -- David is assigned to Blockchain Development
(5, 4),  -- Eva is assigned to Cybersecurity
(6, 3),  -- Frank is assigned to Blockchain Development
(7, 5),  -- Grace is assigned to Natural Language Processing
(8, 4);  -- Henry is assigned to Cybersecurity

-- Link supervisors to projects
INSERT INTO project_supervisor (project_id, supervisor_id) VALUES
(1, 1),  -- Dr. Smith supervises AI Research
(2, 2);  -- Prof. Johnson supervises Data Analysis

-- Link more supervisors to projects
INSERT INTO project_supervisor (project_id, supervisor_id) VALUES
(3, 3),  -- Dr. Garcia supervises Blockchain Development
(4, 2),  -- Prof. Adams supervises Cybersecurity
(5, 1);  -- Dr. Smith supervises Natural Language Processing

-- Insert tasks for AI Research
INSERT INTO tasks (task_name, description, project_id, due_date, status) VALUES
('Literature Review', 'Research papers on AI', 1, '2023-10-01', 'completed'),
('Model Development', 'Build AI model', 1, '2023-12-01', 'pending');

-- Insert tasks for Data Analysis
INSERT INTO tasks (task_name, description, project_id, due_date, status) VALUES
('Data Cleaning', 'Clean big data', 2, '2023-09-15', 'in progress');

-- Insert tasks for Blockchain Development, Cybersecurity, NLP
INSERT INTO tasks (task_name, description, project_id, due_date, status) VALUES
('Smart Contracts', 'Develop smart contracts for blockchain', 3, '2023-12-01', 'pending'),
('Security Auditing', 'Audit security measures', 4, '2024-01-15', 'in progress'),
('Text Preprocessing', 'Preprocess text data for NLP', 5, '2024-02-01', 'pending'),
('Algorithm Design', 'Design new algorithms for blockchain', 3, '2024-03-01', 'pending'),
('Intrusion Detection', 'Research on intrusion detection systems', 4, '2023-11-01', 'completed'),
('Model Training', 'Train NLP model with large datasets', 5, '2024-05-15', 'pending');

-- Queries

-- Query to fetch students and the projects they are working on for AI Research and Blockchain Development
SELECT s.name AS student_name, p.project_name 
FROM students s
JOIN student_project sp ON s.student_id = sp.student_id
JOIN projects p ON sp.project_id = p.project_id
WHERE p.project_name IN ('AI Research', 'Blockchain Development');

-- Query to fetch tasks for AI Research and Blockchain Development
SELECT t.task_name, t.description, t.due_date, t.status
FROM tasks t
JOIN projects p ON t.project_id = p.project_id
WHERE p.project_name IN ('AI Research', 'Blockchain Development');

-- Query to fetch supervisors for all projects
SELECT sup.name AS supervisor_name, p.project_name
FROM supervisors sup
JOIN project_supervisor ps ON sup.supervisor_id = ps.supervisor_id
JOIN projects p ON ps.project_id = p.project_id;

-- Query to count the number of students in each project
SELECT p.project_name, COUNT(sp.student_id) AS num_students
FROM projects p
JOIN student_project sp ON p.project_id = sp.project_id
GROUP BY p.project_name;
