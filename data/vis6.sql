USE AdventureWorks2025;

select top 5 * from sales.SalesTerritory

select top 5 * from sales.SalesOrderHeader

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME = 'SalesOrderHeader'
ORDER BY ORDINAL_POSITION;

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME = 'Customer'
ORDER BY ORDINAL_POSITION;

SELECT DISTINCT
    CountryRegionCode,
    Name AS Region
FROM Sales.SalesTerritory
ORDER BY Name;

SELECT DISTINCT
    Name AS Region
FROM Sales.SalesTerritory
ORDER BY Name;

SELECT 
    st.Name AS Region, 
    SUM(soh.SubTotal) AS Försäljning, 
    COUNT(DISTINCT soh.CustomerID) AS Antal_kunder
FROM sales.SalesTerritory st  
JOIN sales.customer c  
    ON st.TerritoryID = c.TerritoryID
JOIN sales.salesorderheader soh  
    ON c.customerid = soh.CustomerID
GROUP BY st.Name
Order by Försäljning DESC;

---- Group regions
SELECT
  CASE
    WHEN st.Name IN ('Southwest', 'Northwest', 'Central', 'Southeast', 'Northeast') THEN 'US'
    WHEN st.Name IN ('United Kingdom', 'France', 'Germany') THEN 'Europe'
    ELSE st.Name
  END AS RegionGrupp,
  SUM(soh.SubTotal) AS Försäljning,
  COUNT(DISTINCT soh.CustomerID) AS Antal_kunder
FROM Sales.SalesTerritory st
JOIN Sales.Customer c
  ON st.TerritoryID = c.TerritoryID
JOIN Sales.SalesOrderHeader soh
  ON c.CustomerID = soh.CustomerID
GROUP BY
  CASE
    WHEN st.Name IN ('Southwest', 'Northwest', 'Central', 'Southeast', 'Northeast') THEN 'US'
    WHEN st.Name IN ('United Kingdom', 'France', 'Germany') THEN 'Europe'
    ELSE st.Name
  END
ORDER BY Försäljning DESC;


