🧠 Employee Attrition Intelligence System
End-to-End HR Analytics Project | Python • SQL • Power BI • Machine Learning
📌 Project Overview

This project analyzes 1,470 IBM HR employee records to identify why employees leave and predict which employees are at risk of attrition.

The objective was to build a complete data analytics pipeline from raw HR data to actionable business recommendations using industry-standard analytics tools.

Project Workflow
Raw Data (CSV)
        ↓
Python (EDA & Data Cleaning)
        ↓
SQL (Business Analysis)
        ↓
Machine Learning (Prediction)
        ↓
Power BI Dashboard
        ↓
Business Recommendations
🎯 Key Findings
Metric	Value
Overall Attrition Rate	16.12%
Employees Who Left	237 / 1,470
Highest Risk Department	Sales (20.6%)
OverTime Attrition Rate	30.5% vs 10.4%
Avg Salary (Left)	$4,787
Avg Salary (Stayed)	$6,832
Annual Replacement Cost	$6.81M+
Potential Annual Savings	~$720K
🔍 Top 3 Attrition Drivers (Machine Learning)
1️⃣ Monthly Income

Employees with lower salaries are significantly more likely to leave.

2️⃣ OverTime

Employees working overtime leave approximately 3x more frequently.

3️⃣ Age

Employees under 30 represent the highest attrition-risk group.

🛠️ Tools & Technologies
Tool	Purpose
Python	EDA, Data Cleaning, Machine Learning
Pandas & NumPy	Data Manipulation
Matplotlib & Seaborn	Data Visualization
Scikit-learn	Machine Learning
SQL (MySQL)	Business Queries & Analysis
Power BI	Interactive Dashboard
Excel	Initial Data Exploration
📁 Project Structure
employee-attrition-intelligence-system/

├── Data
│   ├── HR_Attrition.csv
│   ├── powerbi_main_data.csv
│   ├── powerbi_dept_summary.csv
│   ├── powerbi_feature_importance.csv
│   ├── powerbi_high_risk.csv
│   └── powerbi_cost_analysis.csv
│
├── Analysis
│   ├── HR_Attrition_Python.ipynb
│   └── HR_Attrition_SQL_Queries.sql
│
├── Dashboard
│   ├── HR_Attrition_Dashboard.pbix
│   └── HR_Attrition_Dashboard.pdf
│
└── Plots
    ├── plot1_attrition_overview.png
    ├── plot2_salary_age.png
    ├── plot3_key_factors.png
    ├── plot4_correlation_heatmap.png
    ├── plot5_lr_results.png
    ├── plot6_feature_importance.png
    └── plot7_model_comparison.png
📊 Power BI Dashboard
Page 1 — Executive Overview
KPIs
Total Employees
Attrition Rate
Average Salary
Employees Left
Visualizations
Attrition Split (Donut Chart)
Department-wise Attrition
Job Role Headcount
Interactive Slicers
Page 2 — Risk Analysis
Analysis Performed
OverTime vs Attrition
Salary Comparison (Left vs Stayed)
Years at Company Analysis
Job Satisfaction Analysis
Work-Life Balance Analysis
Page 3 — Machine Learning Insights
Visualizations
Feature Importance Chart
High Risk Employees Table
Model Performance Metrics
Model Performance
Metric	Value
Accuracy	89.46%
ROC-AUC	0.84
Page 4 — Business Impact
Metrics
Total Replacement Cost
Cost by Department
Potential Savings
Business Recommendations
🤖 Machine Learning Models
Logistic Regression
Accuracy : 87.07%
ROC-AUC  : 0.82
Use Case

Baseline interpretable model for attrition prediction.

Random Forest (Best Model)
Accuracy : 89.46%
ROC-AUC  : 0.84
Trees    : 100
MaxDepth : 10
Why Random Forest Performed Better
Captures non-linear relationships
Provides feature importance scores
Robust against overfitting
No feature scaling required
🗄️ SQL Highlights
High-Risk Employee Detection Using CTE
WITH dept_avg_salary AS (
    SELECT Department,
           AVG(MonthlyIncome) AS avg_dept_salary
    FROM hr_attrition
    GROUP BY Department
),
high_risk AS (
    SELECT h.*, d.avg_dept_salary
    FROM hr_attrition h
    JOIN dept_avg_salary d
    ON h.Department = d.Department
    WHERE h.MonthlyIncome < d.avg_dept_salary
      AND h.OverTime = 'Yes'
      AND h.JobSatisfaction <= 2
)
SELECT *
FROM high_risk
ORDER BY MonthlyIncome ASC;
Salary Ranking by Department
SELECT EmployeeNumber,
       Department,
       MonthlyIncome,
       RANK() OVER (
           PARTITION BY Department
           ORDER BY MonthlyIncome DESC
       ) AS salary_rank
FROM hr_attrition;
📉 Business Impact
Key Outcomes

✅ Identified high-risk employees before attrition

✅ Estimated annual replacement cost of $6.81M

✅ Developed a complete HR decision-support dashboard

✅ Identified opportunities for approximately $720K annual savings

💼 Business Recommendations
1. Salary Review

Employees earning below department average while working overtime represent the highest flight-risk group.

2. OverTime Policy

Reducing excessive overtime in Sales could save approximately $1.2M annually.

3. Retention Program

Focus retention efforts on employees within their first 0–2 years, the highest churn period.

4. Satisfaction Monitoring

Employees with Job Satisfaction scores of 1–2 require immediate HR intervention.

🚀 How To Run
Install Dependencies
pip install pandas numpy matplotlib seaborn scikit-learn jupyter
Run Notebook
jupyter notebook HR_Attrition_Python.ipynb
Run SQL Queries
CREATE DATABASE hr_project;
USE hr_project;

Import the dataset and execute:

HR_Attrition_SQL_Queries.sql
Open Dashboard

Open:

HR_Attrition_Dashboard.pbix

using Power BI Desktop.

📚 Dataset
IBM HR Analytics Employee Attrition & Performance
Source: Kaggle
Records: 1,470 Employees
Features: 35 Columns
Target Variable: Attrition (Yes/No)
Missing Values: None
👨‍💻 About

Pratyaksha Kumar
BCA Student | Aspiring Data Analyst

⭐ If you found this project useful, please consider giving it a star!
Skills Demonstrated

✅ SQL (CTEs, Window Functions, Subqueries)

✅ Python (Pandas, NumPy, Matplotlib, Seaborn)

✅ Machine Learning (Logistic Regression, Random Forest)

✅ Power BI (DAX, KPIs, Slicers, Conditional Formatting)

✅ Excel (Data Cleaning, Pivot Tables)

✅ Business Analytics & Decision Making
