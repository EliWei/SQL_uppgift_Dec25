USE AdventureWorks2025;

SELECT 
    TABLE_SCHEMA,
    COUNT(*) AS number_of_tables
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
GROUP BY TABLE_SCHEMA
ORDER BY number_of_tables DESC;

SELECT 
    fk.name AS foreign_key,
    tp.name AS parent_table,
    cp.name AS parent_column,
    tr.name AS referenced_table,
    cr.name AS referenced_column
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN sys.tables tp ON fkc.parent_object_id = tp.object_id
JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
JOIN sys.tables tr ON fkc.referenced_object_id = tr.object_id
JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
ORDER BY parent_table;

SELECT 
    tp.name AS parent_table,
    cp.name AS parent_column,
    tr.name AS referenced_table,
    cr.name AS referenced_column
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN sys.tables tp ON fkc.parent_object_id = tp.object_id
JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
JOIN sys.tables tr ON fkc.referenced_object_id = tr.object_id
JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
WHERE tp.schema_id = SCHEMA_ID('Sales')
ORDER BY parent_table;

SELECT TOP 5
    p.FirstName,
    p.LastName,
    soh.OrderDate,
    soh.TotalDue
FROM Person.Person p
JOIN Sales.Customer c
    ON p.BusinessEntityID = c.PersonID
JOIN Sales.SalesOrderHeader soh
    ON c.CustomerID = soh.CustomerID
ORDER BY soh.OrderDate ASC;

SELECT TOP 5 *
FROM production.ProductSubcategory
ORDER BY Name;

SELECT pc.name AS Kategori, COUNT(DISTINCT p.ProductID) AS Antal_Produkter
FROM production.productcategory pc   
JOIN production.productsubcategory psc
    ON pc.productcategoryid = psc.productcategoryid
JOIN production.product p
    ON psc.productsubcategoryid = p.productsubcategoryid
GROUP BY pc.name  
ORDER BY Antal_Produkter DESC;

SELECT psc.name, COUNT(p.ProductID) AS Antal_Produkter  
FROM production.productcategory pc   
JOIN production.productsubcategory psc
    ON pc.productcategoryid = psc.productcategoryid
JOIN production.product p
    ON psc.productsubcategoryid = p.productsubcategoryid
WHERE pc.Name = 'Components'
GROUP BY psc.Name
ORDER BY Antal_Produkter DESC;
