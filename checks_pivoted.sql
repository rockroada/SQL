DECLARE @cols AS NVARCHAR(MAX)
DECLARE @query AS NVARCHAR(MAX)
DECLARE @StartDate AS DATE
DECLARE @EndDate AS DATE
DECLARE @VendID AS NVARCHAR(10)
SELECT @cols = STUFF((SELECT ','+
						QUOTENAME(FORMAT(DATEADD(m, 1, Paydate), 'MM/yyyy'))
						FROM EHIP_Checks_New
						WHERE PayDate BETWEEN  '01-01-2014' AND DATEADD(m,1,GETDATE())
						AND VendID = 'EXCH02'
						GROUP BY FORMAT(DATEADD(m, 1, Paydate), 'MM/yyyy')
						ORDER BY MAX(PayDate)
						FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');
						
SELECT @query	='SELECT * FROM (SELECT User5, ClearDate,  FORMAT(DATEADD(m, 1, Paydate), ''MM/yyyy'') AS Paydate
FROM EHIP_Checks_New WHERE PayDate BETWEEN  ''01-01-2014'' AND ''04-30-2014''
AND VendID = ''EXCH02''
) AS SourceTable PIVOT
(
MAX(ClearDate) FOR Paydate IN ('+ @cols+')
) 
AS PivotTable;';
execute(@query);



