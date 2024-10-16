-- 197. Rising Temperature
/*
Given a Weather table, write a SQL query to find all dates' Ids with higher
temperature compared to its previous (yesterday's) dates.
+---------+------------------+------------------+
| Id(INT) | RecordDate(DATE) | Temperature(INT) |
+---------+------------------+------------------+
| 1 | 2015-01-01 | 10 |
| 2 | 2015-01-02 | 25 |
| 3 | 2015-01-03 | 20 |
| 4 | 2015-01-04 | 30 |
+---------+------------------+------------------+
For example, return the following Ids for the above Weather table:
+----+
| Id |
+----+
| 2 |
| 4 |
+----+
*/

-- using self join
select 
      w1.id
from
      weather w1,weather2
where 
      datediff(w1.recorddate,w2.recordate)=1
and 
   w1.temperature > w2.temperature;

-- or 

--  using cte
with tempcte as(
select  
      ID,
      Temperature,
      lag(temperature,1) over (order by RecordDate) as prevtemp
from 
     weather)
select 
     Id 
from tempcte   
where temperature > prevtemp;
     
     
 -- using sub query
SELECT Id
FROM (
    SELECT 
        Id, 
        Temperature, 
        LAG(Temperature, 1) OVER (ORDER BY RecordDate) AS PrevTemp
    FROM Weather
) AS WeatherWithPrev
WHERE Temperature > PrevTemp;

/* Result
# id
'2'
'4'
*/
