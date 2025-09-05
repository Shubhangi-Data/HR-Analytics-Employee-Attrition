SELECT * FROM dbo.hr_data; 
--1 Total Employee
SELECT COUNT(*) AS total_employees FROM dbo.hr_data;
--2 Attrition Count
SELECT COUNT(*) AS attrition_count FROM dbo.hr_data WHERE Attrition='Yes';
--3 Attrition Rate
SELECT CAST(100.0 * SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/
COUNT(*) AS decimal(5,2)) AS attrition_rate_pct FROM dbo.hr_data;
--4 Average Monthly Income
SELECT AVG(CAST([MonthlyIncome] AS FLOAT))
AS avg_monthly_income FROM dbo.hr_data;
--5 Average Years At Company
SELECT AVG(CAST([YearsAtCompany] AS FLOAT))
AS avg_years_at_company FROM dbo.hr_data;
--6 Overall Attrition
SELECT Attrition, COUNT(*) AS cnt
FROM dbo.hr_data
GROUP BY Attrition;
--7 Attrition by Department
SELECT Department,
CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*)
AS decimal(5,2)) AS attrition_rate_pct,
COUNT(*) AS headcount
FROM dbo.hr_data
GROUP BY Department
ORDER BY attrition_rate_pct DESC;
--8 Attrition by Job Role
SELECT[JobRole],
CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*)
AS decimal(5,2)) AS attrition_rate_pct,
COUNT(*) AS headcount
FROM dbo.hr_data
GROUP BY [JobRole]
ORDER BY attrition_rate_pct DESC;
--9 Overtime vs Attrition
SELECT OverTime, Attrition, COUNT(*) AS cnt
FROM dbo.hr_data
GROUP BY OverTime, Attrition;
--10 Attrition by Job Satisfaction
SELECT
CASE WHEN JobSatisfaction = 1 THEN 'Low'
WHEN JobSatisfaction = 2 THEN 'Medium'
WHEN JobSatisfaction = 3 THEN 'High'
WHEN JobSatisfaction = 4 THEN 'Very High'
END AS [Job_Satisfaction_Level],
CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*)
AS decimal(5,2)) AS attrition_rate_pct, COUNT(*) AS n
FROM dbo.hr_data
GROUP BY [JobSatisfaction]
ORDER BY JobSatisfaction;
--11 Years at Company vs Attrition
WITH tenure AS (SELECT CASE WHEN [YearsAtCompany] BETWEEN 0 AND 2 THEN '0-2' 
WHEN [YearsAtCompany] BETWEEN 3 AND 5 THEN '3-5'
WHEN [YearsAtCompany] BETWEEN 6 AND 10 THEN '6-10'
WHEN [YearsAtCompany] BETWEEN 11 AND 20 THEN '11-20'
ELSE '21+'
END AS tenure_band, Attrition FROM dbo.hr_data)
SELECT tenure_band,
CAST(100.0*SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)/COUNT(*)
AS decimal(5,2)) AS attrition_rate_pct,
COUNT(*) AS headcount
FROM tenure
GROUP BY tenure_band
ORDER BY CASE tenure_band WHEN '0-2' THEN 1
WHEN '3-5' THEN 2 WHEN '6-10' THEN 3 WHEN
'11-20' THEN 4 ELSE 5 END;
--12 Monthly Income vs Attrition
SELECT
  CASE 
    WHEN MonthlyIncome BETWEEN 0 AND 20000 THEN '0-20k'
    WHEN MonthlyIncome BETWEEN 20001 AND 40000 THEN '20-40k'
    WHEN MonthlyIncome BETWEEN 40001 AND 60000 THEN '40-60k'
    WHEN MonthlyIncome BETWEEN 60001 AND 80000 THEN '60-80k'
    WHEN MonthlyIncome BETWEEN 80001 AND 100000 THEN '80-100k'
    ELSE '100k+' 
  END AS IncomeBracket,
  Attrition,
  COUNT(*) AS EmployeeCount
  FROM dbo.hr_data
GROUP BY 
  CASE 
    WHEN MonthlyIncome BETWEEN 0 AND 20000 THEN '0-20k'
    WHEN MonthlyIncome BETWEEN 20001 AND 40000 THEN '20-40k'
    WHEN MonthlyIncome BETWEEN 40001 AND 60000 THEN '40-60k'
    WHEN MonthlyIncome BETWEEN 60001 AND 80000 THEN '60-80k'
    WHEN MonthlyIncome BETWEEN 80001 AND 100000 THEN '80-100k'
    ELSE '100k+' 
  END,
  Attrition
ORDER BY IncomeBracket;