--********************************************************************--
-- Create an ETL Procedure Template
--********************************************************************--
CREATE -- Procedure Template
PROCEDURE pETLProcedureTemplate
AS
	/**************************************************************
	Desc: <Desc Goes Here>
	ChangeLog: When, Who, What
	20160101,RRoot,Created Procedure  
	**************************************************************/
Begin -- Procedure Code
 Declare 
   @RC int = 0;
 Begin Try 
  Begin Transaction; 
  -- ETL Code  -------------------------------------------------------------------

   Select 3/1 -- Test;
  
  -- ETL Code  -------------------------------------------------------------------
  Commit Transaction;
  Set @RC = 100; -- Success
 End Try
 Begin Catch
  Rollback Tran;
  Set @RC = -100; -- Failure
 End Catch
 Return @RC;
End -- Procedure Code
;
go
