USE AWDataWarehouse
GO

-- Populate DimDate dimension table with values from 1/1/2000 to 1/1/2003
-- declare variables to hold the start and end date
DECLARE @StartDate datetime
DECLARE @EndDate datetime

--- assign values to the start date and end date we 
-- want our reports to cover (this should also take
-- into account any future reporting needs)
SET @StartDate = '01/01/2000'
SET @EndDate = getdate() 

-- using a while loop increment from the start date 
-- to the end date
DECLARE @LoopDate datetime
SET @LoopDate = @StartDate

WHILE @LoopDate <= @EndDate
BEGIN
 -- add a record into the date dimension table for this date
  INSERT INTO dbo.DimDate VALUES
	(
		CAST(CONVERT(VARCHAR(8), @LoopDate, 112) AS int) , -- date key
		@LoopDate, -- date alt key
		datepart(dw, @LoopDate), -- day number of week
		datename(dw, @LoopDate), -- day name of week
	    Day(@LoopDate),  -- day number of month
		datepart(dy, @LoopDate), -- day of year
		datepart(wk, @LoopDate), --  week of year
		datename(mm, @LoopDate), -- month name
		Month(@LoopDate), -- month number of year
		datepart(qq, @LoopDate), -- calendar quarter
		Year(@LoopDate), -- calendar year
		CASE
			WHEN Month(@LoopDate) < 7 THEN 1
			ELSE 2
		 END, -- calendar semester
		 CASE
			WHEN Month(@LoopDate) IN (1, 2, 3) THEN 3
			WHEN Month(@LoopDate) IN (4, 5, 6) THEN 4
			WHEN Month(@LoopDate) IN (7, 8, 9) THEN 1
			WHEN Month(@LoopDate) IN (10, 11, 12) THEN 2
		 END, -- fiscal quarter (assuming fiscal year runs from Jul to June)
		CASE
			WHEN Month(@LoopDate) < 7 THEN Year(@LoopDate)
			ELSE Year(@Loopdate) + 1
		 END, -- Fiscal year
		CASE
			WHEN Month(@LoopDate) > 6 THEN 1
			ELSE 2
		 END -- fiscal semester
	)  		  
	 -- increment the date by 1 day and do next loop
	SET @LoopDate = DateAdd(dd, 1, @LoopDate)
END



