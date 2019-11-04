 CREATE -- Lookup Null Statuses
    TABLE ETLNullStatuses
    ( NullStatusID int Not Null
    , NullStatusDateKey date -- date = YYYY-MM-DD between 0001-01-01 through 9999-12-31
    , NullStatusName nvarchar (50)
    , NullStatusDescription nvarchar (1000)
    CONSTRAINT [pkETLNullStatuses] PRIMARY KEY Clustered (NullStatusID desc)
    );go

-- 2) Fill Null Lookup TableINSERT -- Lookup data
INTO [TempDB].[dbo].[ETLNullStatuses]
( NullStatusID
, NullStatusDateKey
, NullStatusName
, NullStatusDescription
)
VALUES
(-1,'9999-12-31','Unavaliable', 'Value is currently unknown, but should be available later')
, (-2,'0001-01-01','Not Applicable', 'A value is not applicable to this item')
, (-3,'0001-01-02','Unknown', 'Value is currently unknown, but may be available later')
, (-4,'0001-01-03','Corrupt', 'Original value appeared corrupt or suspicious. As such it was removed from the reporting data')
, (-5,'0001-01-04','Not Defined', 'A value could be entered, but the source data has not yet defined it')
;go 
