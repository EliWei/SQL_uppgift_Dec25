USE AdventureWorks2025;

SELECT TOP 5 *
FROM sales.SalesOrderHeader

SELECT
  YEAR(soh.OrderDate) AS År,                --- OrderDate format datetime ---
  SUM(soh.SubTotal) AS Försäljning          --- änvänd SubTotal då den inte innehåller skatt eller frakt ---
FROM Sales.SalesOrderHeader AS soh
GROUP BY YEAR(soh.OrderDate)
ORDER BY År ASC;

SELECT
  YEAR(soh.OrderDate) AS År,                --- OrderDate format datetime ---
  COUNT(DISTINCT soh.SalesOrderNumber) AS Antal_Ordrar   
FROM Sales.SalesOrderHeader AS soh
GROUP BY YEAR(soh.OrderDate)
ORDER BY År ASC;