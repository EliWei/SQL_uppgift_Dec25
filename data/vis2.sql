USE AdventureWorks2025;
GO

SELECT TOP 5 *
FROM sales.SalesOrderDetail

SELECT pc.name AS Kategori, SUM(sod.LineTotal) AS Intäkt -- LineTotal är i formatet MONEY, inkluderar rabatter
FROM production.productcategory pc   
JOIN production.productsubcategory psc
    ON pc.productcategoryid = psc.productcategoryid
JOIN production.product p
    ON psc.productsubcategoryid = p.productsubcategoryid
JOIN sales.salesorderdetail sod  
    ON p.productid = sod.productid
GROUP BY pc.name  
ORDER BY Intäkt DESC;

SELECT TOP 10 *
FROM person.Address;

SELECT psc.name AS Underkategori, SUM(sod.LineTotal) AS Intäkt
FROM production.productcategory pc   
JOIN production.productsubcategory psc
    ON pc.productcategoryid = psc.productcategoryid
JOIN production.product p
    ON psc.productsubcategoryid = p.productsubcategoryid
JOIN sales.salesorderdetail sod  
    ON p.productid = sod.productid
WHERE pc.Name = 'Bikes'
GROUP BY psc.Name
ORDER BY Intäkt DESC;