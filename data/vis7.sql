USE AdventureWorks2025;

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME = 'Store'
ORDER BY ORDINAL_POSITION;

SELECT Top 5 * 
from sales.store

SELECT Top 5 * 
from sales.customer

---- använder frankrike som ett exempel
SELECT TOP 20
    soh.SubTotal,
    soh.SalesOrderID
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c
    ON soh.CustomerID = c.CustomerID
JOIN Sales.SalesTerritory st
    ON c.TerritoryID = st.TerritoryID
WHERE st.Name = 'France'
ORDER BY soh.SubTotal DESC;


SELECT DISTINCT
    AVG(SubTotal) OVER () AS avg_subtotal,
    PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY SubTotal) 
        OVER () AS median_subtotal
FROM (
    SELECT soh.SubTotal
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.Customer c 
        ON soh.CustomerID = c.CustomerID
    JOIN Sales.SalesTerritory st 
        ON c.TerritoryID = st.TerritoryID
    WHERE st.Name = 'France'
) f;

--- medelvärde per kundgrupp
SELECT 
    st.Name AS Region, 
    SUM(soh.SubTotal) AS Försäljning,
    COUNT(DISTINCT soh.SalesOrderID) AS Antal_Ordrar,
    SUM(soh.SubTotal) / COUNT(DISTINCT soh.SalesOrderID) AS Medel_ordervärde,
    CASE 
        WHEN c.StoreID IS NOT NULL THEN 'Store'
        ELSE 'Private'
    END AS Kundtyp

FROM sales.SalesTerritory st  
JOIN sales.customer c  
    ON st.TerritoryID = c.TerritoryID
JOIN sales.salesorderheader soh  
    ON c.customerid = soh.CustomerID
GROUP BY 
    st.Name,
    CASE                    --- alla icke-aggregerade värden i SELECT måste finnas i GROUP BY
                            --- och kom ihåg att SQL kör GROUP BY innan SELECT, så CASE måste här finnas 
                            --- med i både GROUP BY och SELECT. (Eller gör en subquery)
        WHEN c.StoreID IS NOT NULL THEN 'Store'
        ELSE 'Private'
    END;