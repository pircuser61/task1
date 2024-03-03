
--1. Используя SQL, создайте базу данных с именем "Company" 
CREATE DATABASE Company;

SELECT datname FROM pg_database
WHERE datistemplate = false;
-- и тремя таблицами :
CREATE TABLE public.Departments(
    dep_id SERIAL PRIMARY KEY ,
    name VARCHAR
);

CREATE TABLE public.Employees(
    empl_id SERIAL PRIMARY KEY,
    FirstName VARCHAR,
    LastName VARCHAR,
    dep_id INTEGER REFERENCES departments (dep_id) -- FOREIGN KEY
);

CREATE TABLE public.Projects(
    proj_id SERIAL PRIMARY KEY,
    title VARCHAR
);

CREATE TABLE public.EmplProj(
    empl_id INTEGER REFERENCES Employees(empl_id),
    proj_id INTEGER REFERENCES Projects(proj_id)
)
--2. Вставьте несколько записей в каждую из созданных таблиц.
INSERT INTO Departments (name) 
    VALUES ('IT'), ('Sales');

INSERT INTO Employees (FirstName, LastName)
    VALUES ('Ivan', 'Ivanov'),
            ('Pert', 'Petrov'),
            ('Sidor', 'Sidorov');

INSERT INTO Projects (title)
    VALUES ('proj01'), ('proj02');

INSERT INTO EmplProj (empl_id, proj_id)
    VALUES ((select empl_id from Employees where FirstName = 'Ivan'), 
            (select proj_id from Projects where title = 'proj01'));

UPDATE Employees
    SET dep_id = (SELECT dep_id FROM Departments WHERE name = 'IT')
    WHERE LastName = 'Ivanov' or LastName = 'Petrov'; 

SELECT * FROM Departments;
SELECT * FROM employees;
SELECT * FROM Projects;
SELECT * FROM EmplProj;

--3. Напишите SQL-запрос для выбора всех сотрудников в отделе "IT
SELECT e FROM Departments d
LEFT JOIN Employees e
ON e.dep_id = d.dep_id 
WHERE d.name = 'IT';

-- 4. Измените имя сотрудника с идентификатором 1 на "Robert"
UPDATE Employees 
SET FirstName = 'Robert'
WHERE empl_id = 1;
SELECT * FROM Employees;

-- 5. Удалите проект с идентификатором 2.
DELETE FROM Projects WHERE proj_id = 2;
SELECT * FROM Projects;
-- 6. Создайте индексы для ускорения поиска по полю "LastName" в таблице "Employees".
CREATE INDEX IX1 ON Employees (LastName);
SELECT * FROM pg_indexes
WHERE tablename = 'employees';

-- 7. Напишите SQL-запрос для подсчета общего количества сотрудников в каждом отделе.
SELECT e.dep_id, count(e.empl_id)
FROM Employees e
GROUP BY e.dep_id;

-- 8. Напишите SQL-запрос для получения списка сотрудников с именами, фамилиями и названиями их отделов.
SELECT e.FirstName, e.LastName, d.name
FROM Employees e 
LEFT JOIN Departments d
ON e.dep_id = d.dep_id;

-- 9. спользуйте транзакции для вставки нового отдела и проекта. 
-- Удостоверьтесь, что обе операции успешно выполнены, или обе отменены в случае ошибки.
BEGIN;
INSERT INTO Projects (title)
VALUES ('projForDel');
INSERT INTO Departments (name)
VALUES ('depForDel');

SELECT * FROM Projects;
SELECT * FROm Departments;
ROLLBACK; --COMMIT;
SELECT * FROM Projects;
SELECT * FROm Departments;;


--10. Создайте резервную копию базы данных "Company"

--В докере  pg_dump -F c -U user -d company -f /home/db.dumpp  
select * from Projects
delete from Projects where proj_id = 6
--В докере  pg_restore /home/db.dump -d company -U user -c 