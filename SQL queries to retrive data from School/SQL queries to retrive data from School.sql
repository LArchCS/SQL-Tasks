-- 1.	 
INSERT INTO periods (day, per)
SELECT DISTINCT day, per
FROM assigned
ORDER BY day;

-- 2.	 
INSERT INTO teachers (tname, tload)
SELECT t.tname, SUM (c.nper)
FROM courses AS c, taught_by as t
WHERE c.cno = t.cno
GROUP BY t.tname
ORDER BY t.tname;

-- 3.	 
SELECT a.day, a.per, a.cno
FROM assigned AS a, taught_by AS t
WHERE t.cno = a.cno AND t.tname = 'Marsalis'
ORDER BY a.day, a.per;

-- 4.	 
UPDATE assigned
SET per = 4
WHERE cno = 10 AND day = 'B';

-- 5.	
SELECT a.day, a.per, a.cno
FROM assigned AS a, taught_to AS t
WHERE a.cno = t.cno AND t.grade = 11 AND (t.hr = 'B' OR t.hr = 'Z')
ORDER BY a.day, a.per;

-- 6.	
UPDATE assigned
SET per = 2 
WHERE per = 4 AND day = 'B' AND assigned.cno = (SELECT taught_to.cno FROM taught_to, courses WHERE grade = 11 AND (hr = 'B' OR hr = 'Z') AND courses.cno = taught_to.cno AND subj = 'Mat');

-- 7.	  
SELECT t1.tname, a.day, a.per, c.subj, t2.grade, t2.hr
FROM assigned AS a, taught_by AS t1, taught_to AS t2, courses AS c
WHERE c.cno = a.cno AND c.cno = t1.cno AND c.cno = t2.cno
ORDER BY t1.tname, a.day, a.per;

-- 8.	  
SELECT g.grade, g.hr, a.day, a.per, c.subj
From taught_to AS t, grades AS g, courses AS c, assigned AS a
WHERE c.cno = t.cno AND t.cno = a.cno AND t.grade = g.grade AND (t.hr = g.hr OR t.hr = 'Z')
ORDER BY g.grade, g.hr, a.day, a.per;

-- 9.	 
SELECT DISTINCT t1.tname, a1.day, a1.per
FROM taught_by as t1, taught_by as t2, assigned as a1, assigned as a2
WHERE t1.cno = a1.cno and t2.cno = a2.cno and t1.tname = t2.tname and a1.cno <> a2.cno and a1.day = a2.day and a1.per = a2.per
ORDER BY t1.tname, a1.day, a1.per;	

SELECT t.tname, a.day, a.per
FROM taught_by AS t, assigned AS a
WHERE t.cno = a.cno
GROUP BY t.tname, a.day, a.per
HAVING COUNT(*) > 1
ORDER BY t.tname, day, per;

-- 10.	 
SELECT DISTINCT ta1.day, ta1.per, ta1.grade, g.hr
FROM grades AS g, (taught_to NATURAL JOIN assigned) AS ta1, 
(taught_to NATURAL JOIN assigned) AS ta2
WHERE g.grade = ta1.grade AND ((ta1.hr = ta2.hr AND g.hr = ta1.hr) OR (ta1.hr = 'Z' AND ta2.hr = 'Z') OR (ta1.hr = 'Z' AND g.hr = ta2.hr)) AND g.grade = ta2.grade AND ta1.cno <> ta2.cno AND ta1.day = ta2.day AND ta1.per = ta2.per;

-- 11.	 
SELECT a1.cno, a1.day, a1.per
FROM assigned AS a1, assigned AS a2
WHERE a1.cno = a2.cno AND a1.day = a2.day AND a1.per <> a2.per;


-- 12.	  
UPDATE assigned
SET per = 2
WHERE cno = 14 AND day = 'A' AND per = 4;

-- 13.	  
UPDATE assigned
SET day = 'D'
WHERE cno = 3 AND day = 'B' AND per = 2;

-- 14.	
UPDATE assigned
SET per = 4
WHERE cno = 19 AND day = 'B' AND per = 2;

-- 15.	  
UPDATE assigned
SET per = 4
WHERE cno = 22 AND day = 'A' AND per = 2;

-- 16.	  
UPDATE assigned
SET day = 'D', per = 4
WHERE cno = 4 AND day = 'C' AND per = 2;

-- 17.	  
SELECT c.cno, (c.nper - COUNT(per)) AS remain
FROM courses AS c, assigned AS a
WHERE c.cno = a.cno AND c.nper > (SELECT COUNT (a.day) FROM assigned AS a WHERE a.cno = c.cno GROUP BY a.cno)
GROUP BY c.cno, c.nper
ORDER BY c.cno;

-- 18.	   
SELECT DISTINCT tname, subj
FROM courses AS c, taught_by as t
WHERE c.cno = t.cno
EXCEPT
SELECT t1.tname, c1.subj
FROM courses AS c1, taught_by as t1, courses AS c2, taught_by as t2
WHERE c1.cno = t1.cno AND c2.cno = t2.cno AND t1.tname = t2.tname AND c1.subj <> c2.subj
ORDER BY tname;

-- 19.	   
SELECT t.tname, a.day, a.per
INTO temp1
FROM taught_by AS t, assigned AS a
WHERE t.cno = a.cno
ORDER BY t.tname, a.day, a.per;

SELECT tname, day, count (per) as total
INTO temp2
FROM temp1
GROUP BY tname, day
ORDER BY tname, day;

SELECT tname, day, MAX (per) as max
INTO temp3
FROM temp1
GROUP BY tname, day
ORDER BY tname, day;

SELECT tname, day, MIN (per) as min
INTO temp4
FROM temp1
GROUP BY tname, day
ORDER BY tname, day;

SELECT t3.tname, t3.day, (t3.max - t4.min + 1) AS duration
INTO temp5
FROM temp4 AS t4, temp3 AS t3
WHERE t3.tname = t4.tname AND t3.day = t4.day
ORDER BY t3.tname, t3.day;

SELECT t2.tname, t2.day, (t5.duration - t2.total) AS window
FROM temp2 AS t2, temp5 AS t5
WHERE t2.tname = t5.tname AND t2.day = t5.day AND t5.duration > t2.total
ORDER BY t2.tname, t2.day;

-- 20.	  
SELECT t2.tname, t2.day, (t5.duration - t2.total) as window
INTO temp6
FROM temp2 AS t2, temp5 AS t5
WHERE t2.tname = t5.tname AND t2.day = t5.day AND t5.duration >= t2.total
ORDER BY t2.tname, t2.day;

SELECT t6.tname, SUM (t6.window) AS window
FROM temp6 AS t6
GROUP BY t6.tname
ORDER BY t6.tname;

-- 21.	  
SELECT SUM (t6.window) AS windows
FROM temp6 AS t6;

-- 22.	
SELECT t.tname, t.cno, a.day, a.per
INTO teacherSchedule
FROM taught_by AS t, assigned AS a
WHERE a.cno = t.cno
ORDER BY t.tname, t.cno;

SELECT DISTINCT ts1.cno, ts2.day, ts2.per
FROM teacherSchedule AS ts1, teacherSchedule AS ts2
WHERE ts1.tname = ts2.tname AND ts1.cno <> ts2.cno
ORDER BY ts1.cno, ts2.day, ts2.per;

-- 23.	  
SELECT t.grade, t.hr, t.cno, a.day, a.per
INTO homeroomSchedule
FROM taught_to AS t, assigned AS a
WHERE a.cno = t.cno
ORDER BY t.grade, t.hr, t.cno, a.day, a.per;
	
SELECT DISTINCT hr1.cno, hr2.day, hr2.per
FROM homeroomSchedule AS hr1, homeroomSchedule AS hr2
WHERE hr1.grade = hr2.grade AND hr1.hr = hr2.hr AND hr1.cno <> hr2.cno
ORDER BY hr1.cno, hr2.day, hr2.per;

-- 24.		  
SELECT tname, MAX (total) AS max
INTO temp7
FROM temp2
GROUP BY tname
ORDER BY tname;

SELECT t2.tname, t2.day, t2.total
FROM temp2 AS t2, temp7 AS t7	
WHERE t2.tname = t7.tname AND t2.total = t7.max
ORDER BY t2.tname, t2.day;
