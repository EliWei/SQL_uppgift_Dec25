USE AdventureWorks2025;

SELECT TOP 5 * FROM Production.Product;
SELECT TOP 5 * FROM Production.ProductCostHistory;      ---- var jag kan hitta kostanden per produkt historiskt

--- skillnanden mellan Production.ProductCostHistory och Production.StandardCost:
--- Production.ProductCostHistory har ett start datum för när kostanden började implementeras och ett 
--- slutdatum där kostnaden ändrades. Om slutdatum är NULL gäller det fortfarande kostnaden. 
--- Därför borde de kostander som har ett slutdatum som är NULL vara de samma som finns i Production.StandardCost
--- jag gör därför valtet att bara använda mig av Production.ProductCostHistory då det är en mindre tabell att
--- använda mig av och borde ge samma resultat

SELECT 
    ProductID,
    Name,
    StandardCost
FROM Production.Product;        --- ser att vissa produkter har 0.00 som StandardCost

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