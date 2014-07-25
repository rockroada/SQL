USE [WA_LLAA]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Housing_Progress_Log_Minutes_View]
AS
WITH Housing_Progress_Log_Minutes
AS
(SELECT  DISTINCT PL.SQLID, PL.ClientProfileID, CPRActivityDate, CPRLength, PL.CPRProvider, 
 CPRHousingProgram, PL.ProgressLogID--CPRServiceProvided, CPRServiceFrom 
FROM vwProgress_Log PL
LEFT OUTER JOIN vwService_Provided SP
ON PL.ProgressLogID = SP.ProgressLogID
AND SP.APgm = 'Housing Assistance'
WHERE PL.APgm = 'Housing Assistance'
AND (PL.DeleteFlag <> 'Y' OR PL.DeleteFlag IS NULL) AND (SP.DeleteFlag <> 'Y 'OR SP.DeleteFlag IS NULL)
--AND CPRActivityDate BETWEEN '03-01-2013' and '03-31-2014'
)
SELECT SQLID, ClientProfileID, CPRActivityDate, CPRLength, CPRProvider, ProgressLogID,
--concatenate Housing programs in a singe row
STUFF(
(SELECT ', ' + CPRHousingProgram --add a comma (,) before each value
	FROM Housing_Progress_Log_Minutes PL2 WHERE PL2.ProgresslogID = Housing_Progress_Log_minutes.ProgressLogID
	--WHERE ProgressLogID in the subquery is equal to the ProgressLogID in the outer query
     FOR XML PATH('') --Select it as XML 
	 ), 1, 1, '' -- Remove the first character (the first comma) from the result
	 ) AS HousingProgram 
FROM Housing_Progress_Log_Minutes
GROUP BY  SQLID, ClientProfileID, CPRActivityDate, CPRLength, CPRProvider, ProgressLogID--CPRServiceProvided, CPRServiceFrom 

GO


