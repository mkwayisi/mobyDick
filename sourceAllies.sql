/* Fun database name as an abbreviation for Source Allies*/

CREATE DATABASE soAlli;
USE soAlli;
SELECT * FROM mobyDick;
ALTER TABLE mobyDick ADD Sentence varchar(255);

-- This was my initial test of the formula for how I was going to get the SQL to parse through the file in a single column format.  
INSERT INTO mobyDick (Sentence) VALUES ('This is a string'), ('This is another string'), ('One more string for the road'), ('Is this a string too?'); 

SELECT * FROM mobyDick;

/*
This is where I was attempting to load the file directly into mySQL database but I was having issues with the my.cnf file on my Mac
for some reason it wasn't in the library and mySQL Workbench wasn't allowing me to create one in the specified config Directory. But here
 is what I would code:
 
LOAD DATA LOCAL INFILE '/tmp/mobyDick.csv' INTO TABLE mobyDick COLUMNS TERMINATED BY '\t';

NOTE: Important to note that the file is a .csv and not the text file you originally provided. I figured it would be easier to determine
the count of recurrung Strings (varchar in this case) in SQL and it's easier to parse the data in .csv format
*/

/* This code was borrowed from user 'peterm' of Stack Overflow, as Devs we are all aware that it's we don't reinvent the wheel
we just improve upon the one we already have. I didn't get a chance to modify for the stop words but it does ignore punctuation 
*/

SELECT SUM(total_count) as total, value
FROM (

SELECT count(*) AS total_count, REPLACE(REPLACE(REPLACE(x.value,'?',''),'.',''),'!','') as value
FROM (
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(t.sentence, ' ', n.n), ' ', -1) value
  FROM mobyDick t CROSS JOIN 
(
   SELECT a.N + b.N * 10 + 1 n
     FROM 
    (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
   ,(SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    ORDER BY n
) n
 WHERE n.n <= 1 + (LENGTH(t.sentence) - LENGTH(REPLACE(t.sentence, ' ', '')))
 ORDER BY value

) AS x
GROUP BY x.value

) AS y
GROUP BY value;

/*

