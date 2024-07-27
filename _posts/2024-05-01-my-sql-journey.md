---
title: My SQL journey
tags: [SQL, Learning]
style: 
color: 
description: My journey in learning SQL through my Database and Security course at my University
---
This blog is about my learnings through the Database Design and Security course at my University. I will try to stray away from the basics, and explain some concepts which I found interesting and unaware of. I have worked on ML projects and Data engineering projects, through which I became proficient in python. I could understand SQL, but I couldn’t write queries on my own. I think I was stuck in tutorial hell. I wanted to pick up SQL, and would start looking at few videos, and I wouldn’t practice. I would assume that, as I can understand the queries, I should be able to write queries for new problems. But, that was not the case. I would get stuck at wiring simple joins, and this shows my lack of practice. This course was a way for me to brush up my SQL knowledge. I learnt quite a lot beginning from the basics and finally got to build an ER model as a part of a project.

## The Database
For this course, we used a database which was setup by my professor specifically for healthcare usecases. The database had tables related to Physician, Patient, Patient visits etc.. He had set it up with sample data populated in the table. We used SQL Server Management Studio to query the database, which was hosted in a server at the University.

## The Journey
In the first week, we had learned about the history of databases. At first the records were stored in files which wasn't optimal for retrieval and storage used. The data was stored in Magnetic tapes, punch cards, disks etc. We learnt about different Data models used like Network models, Hierarchical model etc. Then, we were introduced to Relation models and how SQL is used for Data Definition and Manipulation.

Then we got used to using the keywords like `Select`, `Where`, `From` etc. We did few simple queries to get our hands dirty in querying and using the software. And then we learnt about `Join`. This is where it can get a bit messy. There are different kinds of joins, it is important to understand the difference between `CROSS JOIN` and `JOIN`. When writing queries with joins, we can get a lot of duplicates, hence use `DISTINCT` to get your intended results. One of the important learnings was using self-joins. Self-joins are joins done on the same table. This is useful when you have multiple conditions on combinations of different columns. `WHERE` has a limitation that it can look into a single row at a time. And this is where self-joins are helpful. Let me show you an example of using self-joins.

> Find every last name that has both Charlie and Ana as first names.

| StudentKey | FirstName | LastName |
|------------|-----------|----------|
| 1          | Ana       | Banana   |
| 2          | Betty     | Bobetty  |
| 3          | Charlie   | Banana   |
| 4          | Dolly     | Ewe      |


```SQL
SELECT * 
FROM Students s1
JOIN Students s2 ON s1.LastName=s2.LastName
WHERE s1.FirstName = 'Ana' AND s2.FirstName='Charlie'
```

## IMPLICIT AND EXPLICIT JOINS
The equivalent of `JOIN` can be achieved using `WHERE`. But it is important to note that when the where clause is not written correctly, it can result in cartesian product(`CROSS JOIN`) of the two tables and result in a slow query.

>Joins using JOIN Clause, this is called as explcit joins
```SQL
SELECT 
    table1.column1, 
    table2.column2 
FROM 
    table1 
JOIN 
    table2 ON table1.common_column = table2.common_column;
```

>Joins using WHERE Clause, this is called as implcit joins
```SQL
SELECT 
    table1.column1, 
    table2.column2 
FROM 
    table1, 
    table2 
WHERE 
    table1.common_column = table2.common_column;
```

Next, we learnt about Expressions and Aggregations. We got to use `CASE`, `GROUP BY` etc..`HAVING` is used like `WHERE`, but on groups.

### VIEWS AND TEMPORARY TABLES
Later, we got to know views. I like to think of views as temporary tables which can come in handy to avoid rewriting long queries. But there are temporary tables in DBMS, which are different view. The key differnce between views and temporary tables aret that, views aren't stored phtysically. They are dynamically genereated results each time they are accesseed. However, temporary tables are ephermal, they are deleted once the session ends. Views can also be used to restrict access to specific rows or columns. 

### EXISTS & SUB-QUERIES
Subqueires, can be considered as quereies inside a query. You can create temporary tables using a subquery. Subquery can be used in `FROM`, `WHERE` and `JOIN` clauses. Subqueries can be used in conditions where you find the filtering to be complex. This ensure good readability of queries. The `EXISTS` clause is one of the most interesting and confusing clause for me. You can create work around queries using `JOIN` and `WHERE` which achieve the same results, but exists is expected to have speed and efficiency benifits. It took some while to wrap my head around to figure out the flow of execution.The `EXISTS` opereator can be more efficient because it stops processing records as soon it finds a match. While `JOIN` and `IN`, will process all the records. For example both these below queries achieve the same.

>Query using JOIN and WHERE
```SQL
SELECT DISTINCT
p.patientKey,
p.FirstName,
p.LastName,
lt.Description,
lt.OrderDate,
lt.Value
FROM phys.Patient p
JOIN Phys.LaboratoryTests lt ON lt.PatientKey = p.PatientKey
JOIN (
    SELECT p1.PatientKey
    FROM Phys.Patient p1
    JOIN Phys.LaboratoryTests lt1 ON lt1.PatientKey = p1.PatientKey
    WHERE p1.LastName = 'Carlson' AND lt1.Description = 'Hemoglobin A1c'
    AND (lt1.Value > 5 AND lt1.Value < 9)
) subq ON subq.PatientKey = p.PatientKey
```

>Query using WHERE and EXISTS
```SQL
SELECT DISTINCT
    p.patientKey,
    p.FirstName,
    p.LastName,
    lt.Description,
    lt.OrderDate,
    lt.Value
FROM 
    phys.Patient p
JOIN 
    Phys.LaboratoryTests lt ON lt.PatientKey = p.PatientKey
WHERE 
    EXISTS (
        SELECT null
        FROM 
            Phys.Patient p1
        JOIN 
            Phys.LaboratoryTests lt ON lt.PatientKey = p1.PatientKey
        WHERE 
            p.LastName = 'Carlson' 
            AND lt.Description = 'Hemoglobin A1c'
            AND (lt.Value > 5 AND lt.Value < 9)
            AND p1.PatientKey = p.PatientKey
    )
```
To Understand `EXISTS`, think that there is an implicit join being created in the `WHERE EXISTS` inner query. 

We moved onto set operation, where we used `EXCEPT`, `UNION`, `INTERSECT`. This was fairly easy to understand, if we assume each row as an element in a set.


## Data Definition Language
In this part, we learned about how to `INSERT`, `UPDATE` and `DELETE` tables, along with `CREATE` tables as well. This part is entirey new to me, as I hadn't worked with queries regarding these tasks. When creating costraints there are differnt ways of creating it. It is better to show the difference with examples.

>Both queries show different ways of creating a table
```SQL
CREATE TABLE temp.Parent(
    parent_id int PRIMARY KEY,
    first_name varchar(20),
    last_name varchar(20) NOT NULL
)
```
```SQL
CREATE TABLE temp.Child(
    child_id int,
    first_name varchar(20),
    last_name varchar(20),
    CONSTRAINT some_random_unique_name PRIMARY KEY (child_id),
    CONSTRAINT foriegn_key_random_name FORIEGN KEY (parent_id) 
    CHECK (last_name IS NOT NULL)
)
```

When we delete or drop tables, it is important to note that we should drop the referencee before droping the referenced table, to avoid raising errors. 

## Database Design
Database design is all about representing information in a easy to understand manner. It is important to keep some rules in mind that, every table, relation, attribute we add, that is a burden. There are lot of possibilities that we might over-engineer or under-engieer the solution. It is also important to note that there aren't any right or wrong solution, but there are bad ways and good ways to create one. So, we have to make some tradeoffs. To, represent the model, we need notions and one wasy to do it is the entity-relationship notion. We used MYSQL Workbench to create ER Models. 

The key concepts in ER model:
- **`Entity`**: Not something tangible, just an abstraction
- **`Relationships`**: Relations have Cardinality (1:1, 1:many: many:many), between 2 or more entities, can be optional.
- **`Attributes`**: Can be optional, have a type, can have a domain of values(eg: ICD codes)







