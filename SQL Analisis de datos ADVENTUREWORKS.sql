
--- Pruebas con base de datos de ADVENTUREWORKS2019


--- cLIENTES SIN COMPRAS

SELECT SC.CustomerID, ISNULL(SUM(TotalDue), 0) as Total_gastado
FROM Sales.Customer SC
LEFT JOIN SALES.SalesOrderHeader SOH ON(SC.CustomerID = SOH.CustomerID)
WHERE SOH.CustomerID IS NULL
GROUP BY SC.CustomerID



--- Clientes duplicados (posible bug)

SELECT AccountNumber, COUNT(*) AS TOTAL
FROM SALES.Customer
group by AccountNumber
HAVING COUNT(*) > 1




--- Personas sin cliente

SELECT SC.CustomerID, PP.FirstName, PP.LastName
FROM Person.Person PP
LEFT JOIN Sales.Customer SC ON SC.PersonID = PP.BusinessEntityID
WHERE SC.CustomerID IS NULL;



--- CLIENTES CON MAS COMPRAS
SELECT TOP 1 CustomerID, COUNT(CustomerID) AS COMPRAS
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY COMPRAS DESC


--- CLIENTE QUE MAS HA GASTADO
SELECT TOP 1 CustomerID, SUM(TotalDue) AS GASTADO
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY GASTADO DESC



--- Historial de cliente (tipo estado de cuenta)

SELECT SOH.CustomerID, SOH.SalesOrderNumber, SOH.TotalDue, SOH.OrderDate, PP.FirstName + ' ' + PP.LastName AS NombreCliente
FROM Sales.SalesOrderHeader SOH
INNER JOIN Sales.Customer SC 
    ON SOH.CustomerID = SC.CustomerID
INNER JOIN Person.Person PP 
    ON SC.PersonID = PP.BusinessEntityID
ORDER BY SOH.CustomerID, SOH.OrderDate;




--- Productos baratos que NUNCA se han vendido

SELECT P.ProductID, P.Name, P.ListPrice
FROM Production.Product P
LEFT JOIN Sales.SalesOrderDetail SOD ON (P.ProductID = SOD.ProductID)
WHERE SOD.ProductID IS NULL AND P.ListPrice < 100
ORDER BY P.ProductID




--- Productos disponibles en el sistema (con stock)

SELECT P.ProductID, P.Name, POI.Quantity
FROM Production.Product P
INNER JOIN (SELECT ProductID, SUM(Quantity) AS Quantity FROM Production.ProductInventory GROUP BY ProductID) POI ON P.ProductID = POI.ProductID
WHERE P.SellEndDate IS NULL AND POI.Quantity > 0
ORDER BY P.ProductID;




--- Total Vendido por producto (Todos los productos)

SELECT PP.ProductID, PP.Name, ISNULL(SOD.TOTAL_VENDIDO,0) AS TOTAL_VENDIDO
FROM Production.Product PP
LEFT JOIN (SELECT ProductID ,SUM(LineTotal) AS TOTAL_VENDIDO FROM Sales.SalesOrderDetail GROUP BY ProductID) SOD ON (SOD.ProductID = PP.ProductID)
ORDER BY PP.ProductID



--- Clientes y número de órdenes


SELECT SC.CustomerID ,COUNT(SOH.SalesOrderID) AS NUMERO_DE_ORDENES
FROM Sales.Customer SC
LEFT JOIN Sales.SalesOrderHeader SOH ON (SC.CustomerID = SOH.CustomerID)
GROUP BY SC.CustomerID
ORDER BY NUMERO_DE_ORDENES



--- Corregir nombres en clientes específicos

SELECT* --- Validar registros a actualizar
FROM Sales.SalesOrderHeader SOH
LEFT JOIN Sales.Customer SC ON(SOH.CustomerID = SC.CustomerID)
LEFT JOIN Person.Person PP ON(SC.PersonID = BusinessEntityID)
WHERE PP.LastName IS NULL


BEGIN TRANSACTION ---Aplicar actualizacion controlada
UPDATE PP
SET PP.LastName = 'SIN_APELLIDO'
FROM Sales.SalesOrderHeader SOH
LEFT JOIN Sales.Customer SC ON(SOH.CustomerID = SC.CustomerID)
LEFT JOIN Person.Person PP ON(SC.PersonID = PP.BusinessEntityID)
WHERE PP.LastName IS NULL

--- COMMIT;
--- ROLLBHACK;


--- Ajustar precios de productos vendidos


SELECT*
FROM Sales.SalesOrderDetail SOD
LEFT JOIN Production.Product PPR ON(SOD.ProductID = PPR.ProductID)
WHERE PPR.ListPrice < 50


BEGIN TRANSACTION
UPDATE PPR
SET ListPrice = 50
FROM Sales.SalesOrderDetail SOD
LEFT JOIN Production.Product PPR ON(SOD.ProductID = PPR.ProductID)
WHERE PPR.ListPrice < 50

--- COMMIT;
--- ROLLBHACK;


--- Cambia el MIDDLE NAME de una persona específica


SELECT BusinessEntityID,FirstName, MiddleName, LastName
FROM Person.Person
WHERE BusinessEntityID = 18728
ORDER BY BusinessEntityID

BEGIN TRANSACTION;

UPDATE Person.Person
SET MiddleName = 'Scott'
WHERE BusinessEntityID =18728

--- COMMIT;
--- ROLLBHACK;







