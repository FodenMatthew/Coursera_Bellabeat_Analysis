    //Bellabeat Case Study - Cleaning and Analysing Data

# Our datasets include Daily_Activity, Sleep_Log, and Weight_Log

# Looking at DISTINCT IDs to see unique participants for each dataset

SELECT DISTINCT Id
FROM `bellabeat_data.Daily_Activity`
# 33 unique IDs
;

SELECT DISTINCT Id
FROM `bellabeat_data.Sleep_Log`
# 24 unique IDs
;

SELECT DISTINCT Id
FROM `bellabeat_data.Sleep_Log`
# 8 unique IDs

# Looking at start and end date of each dataset

SELECT MIN(ActivityDate) AS startDate, MAX(ActivityDate) AS endDate
FROM `bellabeat_data.Daily_Activity`
# startDate 2016-04-12; endDate 2016-05-12
;

SELECT MIN(SleepDay) AS startDate, MAX(SleepDay) AS endDate
FROM `bellabeat_data.Sleep_Log`
# startDate 2016-04-12; endDate 2016-05-12
;

SELECT MIN(Date) AS startDate, MAX(Date) AS endDate
FROM `bellabeat_data.Weight_Log`
# startDate 2016-04-12; endDate 2016-05-12
;

# Looking for duplicate rows in our three datasets

SELECT ID, ActivityDate, COUNT(*) AS numRow
FROM `bellabeat_data.Daily_Activity`
GROUP BY ID, ActivityDate
HAVING numRow > 1
# No results, appears to be no duplicates in our Daily_Activity dataset
;

SELECT *, COUNT(*) AS numRow
FROM `bellabeat_data.Sleep_Log`
GROUP BY Id, SleepDay, TotalSleepRecords, TotalTimeInBed, TotalMinutesAsleep
HAVING numRow > 1
# 3 duplicate rows have been found
;

SELECT *, COUNT(*) AS numRow
FROM `bellabeat_data.Weight_Log`
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
HAVING numRow > 1
# No results, appears to be no duplicates in our Weight_Log dataset
;

# We must remove the duplicate rows we found in our Sleep_Log dataset

# Here we will create a new table with only distanct values
CREATE TABLE Sleep_Log2 
SELECT DISTINCT * 
FROM `bellabeat_data.Sleep_Log`
;

# checking for duplicates once again
SELECT *, COUNT(*) AS numRow
FROM `bellabeat_data.Sleep_Log2`
GROUP BY Id, SleepDay, TotalSleepRecords, TotalTimeInBed, TotalMinutesAsleep
HAVING numRow > 1
# No results, appears to be no duplicates in our Sleep_Log2 dataset
;

# Removing our old table and renaming our new one

ALTER TABLE `bellabeat_data.Sleep_Log` RENAME trash
DROP TABLE IF EXISTS trash;
ALTER TABLE `bellabeat_data.Sleep_Log2` RENAME Sleep_Log
;

# We see that a standard ID is 10 numbers in length, we will check to make sure all of our IDs are uniform
SELECT Id
FROM `bellabeat_data.Daily_Activity'
WHERE LENGTH(Id) > 10 
OR LENGTH(Id) < 10
# No values returned; all IDs in Daily_Activity have 10 characters
;

SELECT Id
FROM `bellabeat_data.Sleep_Log'
WHERE LENGTH(Id) > 10 
OR LENGTH(Id) < 10
# No values returned; all IDs in Sleep_Log have 10 characters
;

# Looking for IDs in WeightLog with more or less than 10 characters
SELECT Id
FROM `bellabeat_data.Weight_Log'
WHERE LENGTH(Id) > 10 
OR LENGTH(Id) < 10
# No values returned; all IDs in Weight_Log have 10 characters
;

# Looking at our Weight_Log dataset we see Boolean values in IsManualReport. We will varchar "True" and "False" to make our data more readable

ALTER TABLE `bellabeat_data.Weight_Log'
MODIFY IsManualReport varchar(255)
;

UPDATE `bellabeat_data.Weight_Log'
SET IsManualReport = 'True'
WHERE IsManualReport = '1'
;

UPDATE `bellabeat_data.Weight_Log'
SET IsManualReport = 'False'
WHERE IsManualReport = '0'
;

# Lastly, we notice some  0 values in our TotalSteps column. We will dive deeper in this

SELECT Id, COUNT(*) AS numZeroStepsDays
FROM `bellabeat_data.Daily_Activity'
WHERE TotalSteps = 0
GROUP BY Id
ORDER BY numZeroStepsDays DESC
# We have 15 participants who have recorded atleast 1 zero step day

# Looking to see the total number of days recorded with 0 steps
SELECT SUM(numZeroStepsDays) AS totalDaysZeroSteps
FROM (
	SELECT COUNT(*) AS numZeroStepsDays
	FROM `bellabeat_data.Daily_Activity'
	WHERE TotalSteps = 0
	) AS z
# 77 records with 0 steps

# Looking further into the other values associated with our 0 step days
SELECT *, ROUND((SedentaryMinutes / 60), 2) AS SedentaryHours
FROM DailyActivity
WHERE TotalSteps = 0
# With our other values reflecting what our TotalSteps column tells us. It is safe to assume these are days our users did not wear their Fitbits on these days

# We will go ahead and remove these 0 step days, as they can skew our analysis

DELETE FROM `bellabeat_data.Daily_Activity'
WHERE TotalSteps = 0
:

