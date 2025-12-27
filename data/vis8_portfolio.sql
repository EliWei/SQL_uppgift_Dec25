USE AdventureWorks2025;

SELECT TOP 5 * FROM Production.Product;
SELECT TOP 5 * FROM Production.ProductCostHistory;      ---- var jag kan hitta kostanden per produkt historiskt

--- skillnanden mellan Production.ProductCostHistory.StandardCost och Production.Product.StandardCost:
--- Production.ProductCostHistory har ett start datum för när kostanden började implementeras och ett 
--- slutdatum där kostnaden ändrades. Om slutdatum är NULL gäller det fortfarande kostnaden. 
--- Därför borde de kostander som har ett slutdatum som är NULL vara de samma som finns i Production.StandardCost
--- jag gör därför valvet att bara använda mig av Production.ProductCostHistory
SELECT 
    ProductID,
    Name,
    StandardCost
FROM Production.Product;        --- vissa produkter har 0.00 som StandardCost

SELECT 
    ProductID,
    Name,
    StandardCost
FROM Production.Product p
WHERE p.StandardCost != 0.00;

SELECT
    SUM(CASE WHEN StandardCost > 0 THEN 1 ELSE 0 END) AS PositiveCostCount,
    COUNT(*) AS TotalRows
FROM Production.ProductCostHistory;



--- väljer att analysera data för de 12 månaderna fram till maj 2025
--- ordrar under perioden
SELECT
    sod.ProductID,
    SUM(sod.LineTotal) AS Försäljning
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
WHERE soh.OrderDate >= '2024-05-01'
  AND soh.OrderDate <  '2025-05-01'
GROUP BY sod.ProductID;

---12 månader fram till 30 april 2025
--- Vinst per produkt

SELECT TOP 10
    sod.ProductID,
    p.Name AS Produktnamn,
    pc.Name AS Produktkategori,
    SUM(sod.LineTotal) AS Intäkt,
    SUM(sod.OrderQty * pch.StandardCost) AS Kostnad,
    SUM(sod.LineTotal) - SUM(sod.OrderQty * pch.StandardCost) AS Vinst
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p  
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Production.ProductCostHistory pch
    ON pch.ProductID = sod.ProductID
   AND pch.StartDate <= soh.OrderDate
   AND (pch.EndDate IS NULL OR pch.EndDate > soh.OrderDate)
WHERE soh.OrderDate >= '2024-05-01'
  AND soh.OrderDate <  '2025-05-01'
  AND pch.StandardCost > 0
GROUP BY sod.ProductID,
        p.Name,
        pc.Name
ORDER BY Vinst DESC;

--- vinst per produkt, sorterat på vinstmarginal
SELECT
    sod.ProductID,
    p.Name AS Produktnamn,
    pc.Name AS Produktkategori,
    SUM(sod.LineTotal) AS Försäljning,
    SUM(sod.OrderQty * pch.StandardCost) AS Kostnad,
    SUM(sod.LineTotal) - SUM(sod.OrderQty * pch.StandardCost) AS Vinst,
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * pch.StandardCost))
/ NULLIF(SUM(sod.LineTotal), 0) AS Vinstmarginal
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p  
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Production.ProductCostHistory pch
    ON pch.ProductID = sod.ProductID
   AND pch.StartDate <= soh.OrderDate
   AND (pch.EndDate IS NULL OR pch.EndDate > soh.OrderDate)
WHERE soh.OrderDate >= '2024-05-01'
  AND soh.OrderDate <  '2025-05-01'
  AND pch.StandardCost > 0
GROUP BY sod.ProductID,
        p.Name,
        pc.Name
ORDER BY Vinstmarginal DESC;


---- skilland mellan tillverkade produkter och återförsäljningsprodukter?

--- kombinera intäkt, vinst och vinstmarginal
SELECT
    TOP 10
    sod.ProductID,
    p.Name AS Produktnamn,
    pc.Name AS Produktkategori,
    SUM(sod.LineTotal) AS Intäkt,               --- Försäljning, använder LineTotal som tidigare
    SUM(sod.OrderQty * pch.StandardCost) AS Kostnad,
    SUM(sod.LineTotal) - SUM(sod.OrderQty * pch.StandardCost) AS Vinst, --- försäljning minus kostnad
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * pch.StandardCost))  
      / NULLIF(SUM(sod.LineTotal), 0) AS Vinstmarginal                  --- vinstmarginal
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Production.ProductCostHistory pch
    ON pch.ProductID = sod.ProductID
   AND pch.StartDate <= soh.OrderDate
   AND (pch.EndDate IS NULL OR pch.EndDate > soh.OrderDate)
WHERE soh.OrderDate >= '2024-05-01'
  AND soh.OrderDate <  '2025-05-01'
  AND pch.StandardCost > 0
GROUP BY
    sod.ProductID, 
    p.Name, 
    pc.Name;

SELECT
    COUNT(DISTINCT sod.ProductID) AS Antal_unika_produkter
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
WHERE soh.OrderDate >= '2024-05-01'
  AND soh.OrderDate <  '2025-05-01';

SELECT
    sod.ProductID,
    p.Name AS Produktnamn,
    pc.Name AS Produktkategori,
    SUM(sod.LineTotal) AS Intäkt,               --- Försäljning, använder LineTotal som tidigare
    SUM(sod.OrderQty * pch.StandardCost) AS Kostnad,
    SUM(sod.LineTotal) - SUM(sod.OrderQty * pch.StandardCost) AS Vinst, --- försäljning minus kostnad
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * pch.StandardCost))  
      / NULLIF(SUM(sod.LineTotal), 0) AS Vinstmarginal                  --- vinstmarginal
FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod
        ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Production.ProductCostHistory pch
    ON pch.ProductID = sod.ProductID
   AND pch.StartDate <= soh.OrderDate
   AND (pch.EndDate IS NULL OR pch.EndDate > soh.OrderDate)
WHERE soh.OrderDate >= '2024-05-01'
  AND soh.OrderDate <  '2025-05-01'
  AND pch.StandardCost > 0
GROUP BY
    sod.ProductID, 
    p.Name, 
    pc.Name;

--- se närmare på vinst per produktkategori maj 2024 - april 2025
SELECT
    pc.Name AS Produktkategori,
    SUM(sod.LineTotal) AS Intäkt,
    SUM(sod.OrderQty * pch.StandardCost) AS Kostnad,
    SUM(sod.LineTotal) - SUM(sod.OrderQty * pch.StandardCost) AS Vinst,
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * pch.StandardCost))  
      / NULLIF(SUM(sod.LineTotal), 0) AS Vinstmarginal 
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Production.ProductCostHistory pch
    ON pch.ProductID = sod.ProductID
    AND pch.StartDate <= soh.OrderDate
    AND (pch.EndDate IS NULL OR pch.EndDate > soh.OrderDate)
WHERE soh.OrderDate >= '2024-05-01'
    AND soh.OrderDate <  '2025-05-01'
    AND pch.StandardCost > 0
GROUP BY pc.Name
ORDER BY Vinst DESC;


--- titta på hög försäljning vs låg intäkt
SELECT TOP 10
    p.ProductID,
    p.Name AS Produkt,
    pc.Name AS Produktkategori,
    SUM(sod.OrderQty) AS Total_Kvantitet,
    SUM(sod.LineTotal) AS Total_Intäkt
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE soh.OrderDate >= '2024-05-01'
  AND soh.OrderDate <  '2025-05-01'
GROUP BY
    p.ProductID,
    p.Name,
    pc.Name;

SELECT TOP 10
    p.ProductID,
    p.Name AS Produkt,
    SUM(sod.OrderQty) AS Kvantitet,
    SUM(sod.LineTotal) AS Intäkt
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.Name
ORDER BY
    Kvantitet DESC;

SELECT
    p.ProductID,
    p.Name AS Produkt,
    SUM(sod.OrderQty) AS Kvantitet,
    SUM(sod.LineTotal) AS Intäkt
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.Name
ORDER BY
    Kvantitet DESC;
