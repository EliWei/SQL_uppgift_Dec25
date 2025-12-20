USE AdventureWorks2025;

SELECT TOP 5 *
FROM sales.SalesOrderDetail

SELECT TOP 10 
    p.ProductID, 
    p.Name AS Produkt, 
    SUM(sod.LineTotal) AS Försäljning   ---- Använd LineTotal som är inkl eventuella rabatter
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod
    ON p.ProductID = sod.ProductID
GROUP BY
    p.ProductID,
    p.Name
ORDER BY Försäljning DESC;

---- sense chekcing 

SELECT SUM(LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail;

SELECT COUNT(*) AS AntalProdukter
FROM Production.Product;

SELECT COUNT(DISTINCT ProductID) AS AntalProdukter
FROM Production.Product;

SELECT COUNT(*) AS Antal_Ordrar
FROM Production.Product;

--- joinar vidare för att konfirmera produktkategorier

SELECT TOP 10 
    p.ProductID, 
    p.Name AS Produkt, 
    SUM(sod.LineTotal) AS Försäljning,   ---- Använd LineTotal som är inkl eventuella rabatter
    psc.Name AS Produktkategori
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod
    ON p.ProductID = sod.ProductID
JOIN Production.ProductSubcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY
    p.ProductID,
    p.Name,
    psc.Name
ORDER BY Försäljning DESC;
