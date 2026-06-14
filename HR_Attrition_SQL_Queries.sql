CREATE DATABASE hr_project;
CREATE TABLE hr_attrition (
    Age INT,
    Attrition VARCHAR(5),
    BusinessTravel VARCHAR(20),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(15),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(5),
    OverTime VARCHAR(5),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

copy hr_attrition
FROM 'D:/Employee Attrition Intelligence System/HR_Attrition.csv'
DELIMITER ','
CSV HEADER;
SELECT * FROM hr_attrition;

-- ============================================================
-- PROJECT: Employee Attrition Intelligence System
-- TOOL: SQL (MySQL / PostgreSQL compatible)
-- LEVEL: Beginner to Advanced (Interview Ready)
-- ============================================================

-- TABLE NAME: hr_attrition
-- Import your CSV into MySQL Workbench or PostgreSQL with this name


-- ============================================================
-- LEVEL 1: BASIC BUSINESS QUESTIONS
-- ============================================================

-- Q1. Overall attrition rate (most common interview question)
SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS attrition_rate_percent
FROM hr_attrition;


-- Q2. Department-wise attrition rate
SELECT 
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS attrition_rate_percent
FROM hr_attrition
GROUP BY Department
ORDER BY attrition_rate_percent DESC;


-- Q3. OverTime impact on attrition
SELECT 
    OverTime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS attrition_rate_percent
FROM hr_attrition
GROUP BY OverTime;


-- Q4. Average salary of employees who left vs stayed
SELECT 
    Attrition,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income,
    ROUND(MIN(MonthlyIncome), 2) AS min_income,
    ROUND(MAX(MonthlyIncome), 2) AS max_income
FROM hr_attrition
GROUP BY Attrition;


-- Q5. Age group wise attrition
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END AS age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS attrition_rate_percent
FROM hr_attrition
GROUP BY age_group
ORDER BY attrition_rate_percent DESC;


-- ============================================================
-- LEVEL 2: INTERMEDIATE QUERIES
-- ============================================================

-- Q6. Job Role wise attrition with avg salary (GROUP BY + HAVING)
SELECT 
    JobRole,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(AVG(MonthlyIncome), 2) AS avg_salary,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS attrition_rate_percent
FROM hr_attrition
GROUP BY JobRole
HAVING attrition_rate_percent > 15
ORDER BY attrition_rate_percent DESC;


-- Q7. Job Satisfaction vs Attrition (Cross Analysis)
SELECT 
    JobSatisfaction,
    CASE 
        WHEN JobSatisfaction = 1 THEN 'Very Low'
        WHEN JobSatisfaction = 2 THEN 'Low'
        WHEN JobSatisfaction = 3 THEN 'Medium'
        WHEN JobSatisfaction = 4 THEN 'High'
    END AS satisfaction_label,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS attrition_rate_percent
FROM hr_attrition
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;


-- Q8. Years at company vs attrition — when do people leave most?
SELECT 
    YearsAtCompany,
    COUNT(*) AS total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS attrition_rate_percent
FROM hr_attrition
GROUP BY YearsAtCompany
ORDER BY attrition_rate_percent DESC
LIMIT 10;


-- ============================================================
-- LEVEL 3: ADVANCED QUERIES (Window Functions + CTEs)
-- ============================================================

-- Q9. CTE — High Risk Employees
-- Employees earning below dept average AND doing overtime AND low job satisfaction
WITH dept_avg_salary AS (
    SELECT 
        Department,
        ROUND(AVG(MonthlyIncome), 2) AS avg_dept_salary
    FROM hr_attrition
    GROUP BY Department
),
high_risk AS (
    SELECT 
        h.EmployeeNumber,
        h.Age,
        h.Department,
        h.JobRole,
        h.MonthlyIncome,
        d.avg_dept_salary,
        h.OverTime,
        h.JobSatisfaction,
        h.Attrition
    FROM hr_attrition h
    JOIN dept_avg_salary d ON h.Department = d.Department
    WHERE 
        h.MonthlyIncome < d.avg_dept_salary
        AND h.OverTime = 'Yes'
        AND h.JobSatisfaction <= 2
)
SELECT * FROM high_risk
ORDER BY MonthlyIncome ASC;


-- Q10. Window Function — Rank employees by salary within each department
SELECT 
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    Attrition,
    RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS salary_rank_in_dept,
    ROUND(AVG(MonthlyIncome) OVER (PARTITION BY Department), 2) AS dept_avg_salary,
    MonthlyIncome - ROUND(AVG(MonthlyIncome) OVER (PARTITION BY Department), 2) AS salary_vs_dept_avg
FROM hr_attrition
ORDER BY Department, salary_rank_in_dept;


-- ============================================================
-- END OF FILE
-- Total Queries: 11 (Basic to Advanced)
-- Skills Demonstrated: GROUP BY, HAVING, CASE WHEN, CTE, 
--                      Window Functions, RANK(), AVG() OVER,
--                      Subqueries, Business Impact Analysis
-- ============================================================
-- BONUS Q11. Attrition Cost Estimation (Business Impact Query)

-- Assumption: Replacing one employee costs 50% of their annual salary
SELECT 
    Department,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN MonthlyIncome * 12 * 0.5 ELSE 0 END), 2) AS estimated_replacement_cost_usd
FROM hr_attrition
GROUP BY Department
ORDER BY estimated_replacement_cost_usd DESC;

-- ============================================================
-- LEVEL 4: ADVANCED BUSINESS + INTERVIEW QUERIES (ADDED)
-- ============================================================

-- Q12. Department Risk Ranking (Most Attrition Risk)
SELECT 
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(
        SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2
    ) AS attrition_rate_percent,
    RANK() OVER (
        ORDER BY SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*1.0/COUNT(*) DESC
    ) AS risk_rank
FROM hr_attrition
GROUP BY Department;


-- Q13. Salary Gap Analysis by Job Role
SELECT 
    JobRole,
    ROUND(AVG(MonthlyIncome),2) AS avg_salary,
    MIN(MonthlyIncome) AS min_salary,
    MAX(MonthlyIncome) AS max_salary,
    MAX(MonthlyIncome) - MIN(MonthlyIncome) AS salary_gap
FROM hr_attrition
GROUP BY JobRole
ORDER BY salary_gap DESC;


-- Q14. Work-Life Balance Impact on Attrition
SELECT 
    WorkLifeBalance,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2
    ) AS attrition_rate_percent
FROM hr_attrition
GROUP BY WorkLifeBalance
ORDER BY attrition_rate_percent DESC;


-- Q15. Promotion Delay Impact on Attrition
SELECT 
    YearsSinceLastPromotion,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(
        SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2
    ) AS attrition_rate_percent
FROM hr_attrition
GROUP BY YearsSinceLastPromotion
ORDER BY attrition_rate_percent DESC;


-- Q16. Top 10 High-Risk Employees (Low Salary + Overtime + Low Satisfaction)
SELECT 
    EmployeeNumber,
    Age,
    Department,
    JobRole,
    MonthlyIncome,
    OverTime,
    JobSatisfaction,
    Attrition
FROM hr_attrition
WHERE OverTime='Yes'
AND JobSatisfaction <=2
AND MonthlyIncome < (
    SELECT AVG(MonthlyIncome) FROM hr_attrition
)
ORDER BY MonthlyIncome ASC
LIMIT 10;


-- ============================================================
-- END (UPDATED VERSION)
-- Total Queries: 16 (Advanced Level Project Ready)
-- ============================================================
