SELECT*
FROM dbo.Cyclist

SELECT distinct(member_casual), count(member_casual) as Total
FROM dbo.Cyclist
GROUP BY member_casual

--SPLITTING STATRTING DATE AND TIME

ALTER TABLE dbo.Cyclist
ADD start_date date

UPDATE dbo.Cyclist
SET start_date = PARSENAME(REPLACE(started_at,' ','.'), 2)

ALTER TABLE dbo.Cyclist
ADD start_time time

UPDATE dbo.Cyclist
SET start_time = PARSENAME(REPLACE(started_at,' ','.'), 1)

--SPLITTING END TIME

ALTER TABLE dbo.Cyclist
ADD ended_time time

UPDATE  dbo.Cyclist
SET ended_time= PARSENAME(REPLACE(ended_at,' ','.'),1)

--FINDING DAY FROM DATE

SELECT start_date,DATENAME(weekday,start_date)
FROM dbo.Cyclist
GROUP BY start_date

ALTER TABLE dbo.Cyclist
ADD start_day Nvarchar(255)

UPDATE dbo.Cyclist
SET start_day = DATENAME(weekday,start_date)

--CALCULATING RIDE LENGTH

SELECT DATEDIFF(MINUTE,start_time,ended_time) as ride_length_in_min
FROM Cyclist

ALTER TABLE dbo.Cyclist
ADD ride_length_in_minutes int

UPDATE dbo.Cyclist
SET ride_length_in_minutes = DATEDIFF(MINUTE,start_time,ended_time)

--FINDING THE MONTH

SELECT started_at,
CASE
     WHEN started_at like '%-01-%' THEN 'January'
     WHEN started_at like '%-02-%' THEN 'February'
	 ELSE 'March'
END
FROM Cyclist

ALTER TABLE Cyclist
ADD Month Nvarchar(255)

UPDATE Cyclist
SET Month=
CASE
     WHEN started_at like '%-01-%' THEN 'January'
     WHEN started_at like '%-02-%' THEN 'February'
	 ELSE 'March'
END




--Finding the Average Ride Length of Customers

SELECT distinct(member_casual), AVG(ride_length_in_minutes) as average_ride_length
FROM Cyclist
GROUP BY member_casual

-- Calculating The Maximum Ride Length

SELECT DISTINCT(member_casual), MAX(ride_length_in_minutes)as max_ride_length
FROM Cyclist
GROUP BY member_casual

--Finding Busiest Day

SELECT DISTINCT (start_day), COUNT(start_day) as Total_Rides
FROM Cyclist
GROUP BY start_day
     --Busiest day is Tuesday, Weekdays have Higher Ride and weekends have least ride
