**BlinkIT Grocery Sales and Inventory Performance Analysis**

🎯 Project Overview
This project provides a comprehensive data analysis of the BlinkIT Grocery dataset, focusing on sales performance, inventory characteristics (like item weight and fat content), and outlet effectiveness.

The goal of this analysis is to identify key drivers of sales, uncover high-performing/underperforming store types, and implement data cleaning techniques (specifically, imputation for missing weights) to create a robust foundation for strategic business decisions.

The project is structured in two main parts:

Data Processing & Analysis: Performed using T-SQL queries to clean, aggregate, and analyze data.

Visualization: A dynamic Power BI Dashboard is used to present KPIs, sales breakdowns, and actionable insights.

🛠️ Technology Stack
Database: Microsoft SQL Server 

Visualization: Power BI

Data Source: BlinkIT Grocery Sales Data (CSV/Excel)

📁 Repository Contents
blinkit_analysis.sql: The complete T-SQL script used for data cleaning, imputation, KPI calculation, and deep-dive analysis.

BlinkIT Grocery Sales and Inventory Performance Analysis.pbix: The Power BI file containing the final dashboard.

Cleaned_BlinkIT_Data.csv: The final dataset exported after cleaning and imputation (e.g., standardized fat content and imputed item weights).

README.md: This document.

🧹 Data Cleaning & Imputation Steps
The initial data required cleaning to ensure accuracy in aggregation. These steps were executed in the blinkit_analysis.sql script:

ItemFatContent
Standardization: Inconsistent entries (e.g., 'LF', 'low fat', 'reg') were standardized to 'Low Fat' and 'Regular'.

ItemWeight
Imputation: Missing values (NULL) in the [Item Weight] column were imputed (filled in) by calculating the average weight of the corresponding [Item Type] category. This approach preserves the data structure while maintaining a more accurate representation of product weights.

📊 Key Analysis and Insights (SQL Queries)
The T-SQL script executes the following key analytical steps:

Core KPIs
Calculates Total Sales (in millions), Average Sales per Item, Total Orders, and Average Customer Rating.

Sales Breakdown
Analyzes sales based on Item Fat Content and Outlet Location Type (Tier 1, 2, 3).

Determines the Sales Contribution Percentage for each Outlet Size (Small, Medium, High).

Performance and Inventory Deep Dive
Top 5 Item Types: Identifies the categories contributing the most to total revenue (Pareto Analysis).

Outlet Performance Ranking: Uses the RANK() window function to determine global and segmented sales rankings across all outlets.

Outlet Age Performance: Groups sales metrics by the outlet's establishment year to identify trends related to store maturity.

Item Weight Analysis: Groups sales and rating metrics by product weight bins (e.g., 0-5 kg, 5-10 kg) to analyze the impact of item weight on customer behavior.

🚀 Getting Started
SQL Setup
Load Data: Import the raw data into a SQL Server database, ensuring the table is named PortfolioProject1.dbo.BlinkITGrocery.

Execute Script: Run the entire blinkit_analysis.sql script. The data cleaning and imputation steps will run first, preparing the data for all subsequent analysis queries.

Power BI Dashboard Setup
Connect to Cleaned Data: Open the Power BI file (BlinkIT Grocery Sales and Inventory Performance Analysis.pbix).

Refresh Data: If you have exported the final cleaned data (after imputation) to a file named Cleaned_BlinkIT_Data.csv, ensure the Power BI report is connected to this file and refresh the data. (Alternatively, if you are connecting Power BI directly to the SQL Server, refresh the connection to the BlinkITGrocery table after running the cleaning updates).

Explore: Navigate through the dashboard pages to view the visualizations for KPIs, Outlet performance, and Item analysis.

Author: Shivasena Reddy Indurthi
Date: 10/05/2025
