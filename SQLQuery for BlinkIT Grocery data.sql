-- ======================================================================================
-- BLINKIT GROCERY DATA ANALYSIS SCRIPT
-- Target Table: PortfolioProject1.dbo.BlinkITGrocery
-- This script performs data cleaning, KPI generation, sales breakdowns, and advanced analytics.
-- All column names with spaces are enclosed in brackets [].
-- ======================================================================================

-- View all data to inspect the table structure and content
SELECT *
FROM PortfolioProject1.dbo.BlinkITGrocery;


-- --------------------------------------------------------------------------------------
-- 1. DATA CLEANING AND VALIDATION
-- --------------------------------------------------------------------------------------

-- Standardize the [Item Fat Content] field (LF, low fat -> 'Low Fat'; reg -> 'Regular').
UPDATE PortfolioProject1.dbo.BlinkITGrocery
SET [Item Fat Content] =
    CASE
        WHEN [Item Fat Content] IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN [Item Fat Content] = 'reg' THEN 'Regular'
        ELSE [Item Fat Content]
    END;

-- Validate cleaning: Check the distinct values of [Item Fat Content] after the update.
SELECT
    DISTINCT [Item Fat Content]
FROM PortfolioProject1.dbo.BlinkITGrocery;


-- --------------------------------------------------------------------------------------
-- 2. KEY PERFORMANCE INDICATORS (KPIs)
-- --------------------------------------------------------------------------------------

-- Calculate the Total Sales in millions.
SELECT
    CAST(SUM(Sales) / 1000000.0 AS DECIMAL(10,2)) AS Total_Sales_Million
FROM PortfolioProject1.dbo.BlinkITGrocery;

-- Calculate the Average Sales per item/transaction.
SELECT
    CAST(AVG(Sales) AS INT) AS Avg_Sales
FROM PortfolioProject1.dbo.BlinkITGrocery;

-- Calculate the total number of orders (rows) in the dataset.
SELECT
    COUNT(*) AS No_of_Orders
FROM PortfolioProject1.dbo.BlinkITGrocery;

-- Calculate the average customer rating across all items.
SELECT
    CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM PortfolioProject1.dbo.BlinkITGrocery;


-- --------------------------------------------------------------------------------------
-- 3. SALES BREAKDOWN AND AGGREGATION
-- --------------------------------------------------------------------------------------

-- Total Sales segmented by the Fat Content of the item.
SELECT
    [Item Fat Content],
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM PortfolioProject1.dbo.BlinkITGrocery
GROUP BY [Item Fat Content]
ORDER BY Total_Sales DESC;

-- Total Sales based on the geographical location type of the outlet (Tier 1, 2, 3).
SELECT
    [Outlet Location Type],
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM PortfolioProject1.dbo.BlinkITGrocery
GROUP BY [Outlet Location Type]
ORDER BY Total_Sales DESC;

-- Total Sales by Outlet Size, including its percentage contribution to grand total sales.
SELECT
    [Outlet Size],
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM PortfolioProject1.dbo.BlinkITGrocery
GROUP BY [Outlet Size]
ORDER BY Total_Sales DESC;

-- Comprehensive metrics (Total Sales, Avg Sales, Order Count) for each Outlet Type.
SELECT
    [Outlet Type],
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,0)) AS Avg_Sales,
    COUNT(*) AS No_of_Orders
FROM PortfolioProject1.dbo.BlinkITGrocery
GROUP BY [Outlet Type]
ORDER BY Total_Sales DESC;


-- --------------------------------------------------------------------------------------
-- 4. ADVANCED PERFORMANCE & INVENTORY ANALYSIS
-- --------------------------------------------------------------------------------------

-- Top 5 Item Types (Categories) by Sales, including their contribution percentage and average rating.
SELECT
    TOP 5 [Item Type],
    CAST(SUM(Sales) AS DECIMAL(10, 2)) AS Total_Sales,
    CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating,
    CAST(
        (SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER ())
        AS DECIMAL(10, 2)
    ) AS Sales_Contribution_Percent
FROM PortfolioProject1.dbo.BlinkITGrocery
GROUP BY [Item Type]
ORDER BY Total_Sales DESC;

-- Outlet Performance Ranking: Ranks outlets globally and within their specific [Outlet Type].
SELECT
    [Outlet Identifier],
    [Outlet Type],
    [Outlet Location Type],
    CAST(SUM(Sales) AS DECIMAL(10, 2)) AS Total_Sales,
    CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS Global_Sales_Rank,
    RANK() OVER (PARTITION BY [Outlet Type] ORDER BY SUM(Sales) DESC) AS Rank_Within_Outlet_Type
FROM PortfolioProject1.dbo.BlinkITGrocery
GROUP BY [Outlet Identifier], [Outlet Type], [Outlet Location Type]
ORDER BY Global_Sales_Rank;

-- Sales performance grouped by how old the outlet is (age since establishment).
SELECT
    (YEAR(GETDATE()) - [Outlet Establishment Year]) AS Outlet_Age_Years,
    CAST(SUM(Sales) AS DECIMAL(10, 2)) AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10, 2)) AS Average_Sales_Per_Item,
    COUNT(DISTINCT [Outlet Identifier]) AS Num_Outlets
FROM PortfolioProject1.dbo.BlinkITGrocery
GROUP BY [Outlet Establishment Year]
ORDER BY Outlet_Age_Years DESC;


-- --------------------------------------------------------------------------------------
-- 5. ITEM WEIGHT ANALYSIS
-- --------------------------------------------------------------------------------------

-- Groups products into weight bins and calculates average sales and rating for each bin.
SELECT
    CASE
        WHEN [Item Weight] IS NULL THEN 'Unknown'
        WHEN [Item Weight] < 5 THEN '0 - 5 kg (Light)'
        WHEN [Item Weight] >= 5 AND [Item Weight] < 10 THEN '5 - 10 kg'
        WHEN [Item Weight] >= 10 AND [Item Weight] < 15 THEN '10 - 15 kg'
        ELSE '15+ kg (Heavy)'
    END AS Weight_Bin,
    COUNT(*) AS Total_Items,
    CAST(AVG([Item Weight]) AS DECIMAL(10, 2)) AS Avg_Weight_in_Bin,
    CAST(AVG(Sales) AS DECIMAL(10, 2)) AS Avg_Sales_in_Bin,
    CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating_in_Bin,
    -- Added explicit sort order to SELECT and GROUP BY to satisfy ORDER BY constraints
    CASE
        WHEN [Item Weight] IS NULL THEN 999
        WHEN [Item Weight] < 5 THEN 1
        WHEN [Item Weight] >= 5 AND [Item Weight] < 10 THEN 2
        WHEN [Item Weight] >= 10 AND [Item Weight] < 15 THEN 3
        ELSE 4
    END AS Weight_Sort_Order
FROM PortfolioProject1.dbo.BlinkITGrocery
GROUP BY
    CASE
        WHEN [Item Weight] IS NULL THEN 'Unknown'
        WHEN [Item Weight] < 5 THEN '0 - 5 kg (Light)'
        WHEN [Item Weight] >= 5 AND [Item Weight] < 10 THEN '5 - 10 kg'
        WHEN [Item Weight] >= 10 AND [Item Weight] < 15 THEN '10 - 15 kg'
        ELSE '15+ kg (Heavy)'
    END,
    -- Include the sort order in GROUP BY
    CASE
        WHEN [Item Weight] IS NULL THEN 999
        WHEN [Item Weight] < 5 THEN 1
        WHEN [Item Weight] >= 5 AND [Item Weight] < 10 THEN 2
        WHEN [Item Weight] >= 10 AND [Item Weight] < 15 THEN 3
        ELSE 4
    END
ORDER BY
    Weight_Sort_Order; -- Now we can order by the alias

-- Analyzes the average item weight and total sales for each [Item Type] category.
SELECT
    [Item Type],
    CAST(AVG([Item Weight]) AS DECIMAL(10, 2)) AS Avg_Item_Weight,
    CAST(SUM(Sales) AS DECIMAL(10, 2)) AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10, 2)) AS Avg_Sales_Per_Item
FROM PortfolioProject1.dbo.BlinkITGrocery
WHERE
    [Item Weight] IS NOT NULL -- Focus on items with known weight
GROUP BY
    [Item Type]
ORDER BY
    Avg_Item_Weight DESC;

-- Data quality check: Identifies records where the [Item Weight] data is missing (NULL).
SELECT
    [Item Identifier],
    [Item Type],
    [Item Weight],
    Sales,
    [Outlet Identifier]
FROM PortfolioProject1.dbo.BlinkITGrocery
WHERE
    [Item Weight] IS NULL
ORDER BY
    [Item Type],
    Sales DESC;
