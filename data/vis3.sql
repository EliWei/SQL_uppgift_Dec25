USE AdventureWorks2025;
GO

SELECT TOP 5 *
FROM sales.SalesOrderHeader

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME = 'SalesOrderHeader'
  AND COLUMN_NAME IN ('OrderDate', 'SubTotal', 'TotalDue');

SELECT
  MIN(OrderDate) AS FörstaDatum,
  MAX(OrderDate) AS SistaDatum,
  COUNT(DISTINCT YEAR(OrderDate)) AS AntalÅr --- lägg in Emils kod här ---

--- Visar att maj 2022 inte är en hel månad
SELECT
  YEAR(OrderDate)  AS År,
  MONTH(OrderDate) AS Månad,
  MIN(OrderDate)   AS FörstaOrder,
  MAX(OrderDate)   AS SistaOrder,
  COUNT(*)         AS AntalOrder
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2022
  AND MONTH(OrderDate) = 5
GROUP BY YEAR(OrderDate), MONTH(OrderDate);

--- Visar att juni 2025 inte är en hel månad
SELECT
  YEAR(OrderDate)  AS År,
  MONTH(OrderDate) AS Månad,
  MIN(OrderDate)   AS FörstaOrder,
  MAX(OrderDate)   AS SistaOrder,
  COUNT(*)         AS AntalOrder
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2025
  AND MONTH(OrderDate) = 6
GROUP BY YEAR(OrderDate), MONTH(OrderDate);

--- inspiration från Emils kod -> video

SELECT
  YEAR(soh.OrderDate) AS År,                --- OrderDate format datetime ---
  MONTH(soh.OrderDate) AS Månad,
  SUM(soh.SubTotal) AS Försäljning          --- änvänd SubTotal då den inte innehåller skatt eller frakt ---
FROM Sales.SalesOrderHeader AS soh
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
ORDER BY År, Månad ASC;

--- Vad är det för knas med maj 2025?
SELECT
  YEAR(OrderDate)  AS År,
  MONTH(OrderDate) AS Månad,
  MIN(OrderDate)   AS FörstaOrder,
  MAX(OrderDate)   AS SistaOrder,
  COUNT(*)         AS AntalOrder
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2025
  AND MONTH(OrderDate) = 5
GROUP BY YEAR(OrderDate), MONTH(OrderDate);

SELECT
  COUNT(*)            AS AntalOrder,
  SUM(SubTotal)       AS TotalFörsäljning,
  AVG(SubTotal)       AS SnittPerOrder
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2025-05-01'
  AND OrderDate <  '2025-06-01';

SELECT
  MONTH(OrderDate)    AS Månad,
  COUNT(*)            AS AntalOrder,
  SUM(SubTotal)       AS TotalFörsäljning,
  AVG(SubTotal)       AS SnittPerOrder
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2025-04-01'
  AND OrderDate <  '2025-07-01'
GROUP BY MONTH(OrderDate)
ORDER BY Månad;

SELECT
  YEAR(soh.OrderDate) AS År,
  MONTH(soh.OrderDate) AS Månad,
  pc.Name AS Kategori,
  SUM(sod.LineTotal) AS Intäkt
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE soh.OrderDate >= '2025-04-01'
  AND soh.OrderDate <  '2025-07-01'
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate), pc.Name
ORDER BY År, Månad, Intäkt DESC;

SELECT COUNT(*) AS AntalOrderrader
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
  ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate >= '2025-05-01'
  AND soh.OrderDate <  '2025-06-01';

SELECT COUNT(*) AS AntalRaderComponents
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
  ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p
  ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc
  ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
  ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Components'
  AND soh.OrderDate >= '2025-05-01'
  AND soh.OrderDate <  '2025-06-01';

--- Titta närmare på Bikes och components

SELECT
  YEAR(soh.OrderDate) AS År,
  MONTH(soh.OrderDate) AS Månad,
  SUM(sod.LineTotal) AS Cykelförsäljning
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
  ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p
  ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc
  ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
  ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Bikes'
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
ORDER BY År, Månad;

SELECT
  YEAR(soh.OrderDate) AS År,
  MONTH(soh.OrderDate) AS Månad,
  SUM(sod.LineTotal) AS Komponentförsäljning
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
  ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p
  ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc
  ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
  ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Components'
GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
ORDER BY År, Månad;