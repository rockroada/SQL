DECLARE @cols AS NVARCHAR(MAX)
DECLARE @query AS NVARCHAR(MAX)
SELECT @cols = STUFF((SELECT DISTINCT  ','+
						DATENAME(m,DATEADD(m, 1, Paydate)) +'_' + CONVERT(NVARCHAR, YEAR(DATEADD(m, 1, Paydate)))
						FROM EHIP_Checks_New
						WHERE PayDate BETWEEN  '01-01-2014' AND '04-30-2014'
						AND VendID = 'EXCH02'
						FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

SELECT @query	='SELECT * FROM (SELECT User5, ClearDate,  DATENAME(m,DATEADD(m, 1, Paydate)) +''_'' + CONVERT(NVARCHAR, YEAR(DATEADD(m, 1, Paydate))) AS Month
FROM EHIP_Checks_New WHERE PayDate BETWEEN  ''01-01-2014'' AND ''04-30-2014''
AND VendID = ''EXCH02''
) AS SourceTable PIVOT
(
MAX(ClearDate) FOR Month IN ('+ @cols+')
) 
AS PivotTable;';
execute(@query);

