
--- Pruebas CON BASE DE DATOS DE ADVENTUREWORKS2019




--- #VALIDACION DE DATOS (QA)



--- Clientes sin compras

SELECT SC.CustomerID, SOH.TotalDue
FROM Sales.Customer SC
LEFT JOIN SALES.SalesOrderHeader SOH ON(SC.CustomerID = SOH.CustomerID)
WHERE SOH.CustomerID IS NULL
ORDER BY SC.CustomerID ASC

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





--- #ANALISIS DE DATOS



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


--- Promedio gastado por cliente

SELECT SC.CustomerID, ISNULL(AVG(SOH.TotalDue), 0) AS PROMEDIO_GASTADO
FROM Sales.Customer SC
LEFT JOIN Sales.SalesOrderHeader SOH ON (SC.CustomerID = SOH.CustomerID)
GROUP BY SC.CustomerID
ORDER BY PROMEDIO_GASTADO DESC



--- Clientes y número de órdenes


SELECT SC.CustomerID ,COUNT(SOH.SalesOrderID) AS NUMERO_DE_ORDENES
FROM Sales.Customer SC
LEFT JOIN Sales.SalesOrderHeader SOH ON (SC.CustomerID = SOH.CustomerID)
GROUP BY SC.CustomerID
ORDER BY NUMERO_DE_ORDENES





--- #ANALISIS DE PRODUCTOS



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





--- #TRANSACCIONES / ACTUALIZACIONES



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
--- ROLLBACK;


--- Cambia el MIDDLE NAME de una persona específica


SELECT BusinessEntityID,FirstName, MiddleName, LastName
FROM Person.Person
WHERE BusinessEntityID = 18728
ORDER BY BusinessEntityID

BEGIN TRANSACTION;

UPDATE Person.Person
SET MiddleName = 'Scott'
WHERE BusinessEntityID =18728


SELECT BusinessEntityID,FirstName, MiddleName, LastName -- Revisar
FROM Person.Person
WHERE BusinessEntityID = 18728
ORDER BY BusinessEntityID

--- COMMIT;
--- ROLLBACK;




--- # ACTUALIZACIÓN DE PRECIOS (LÓGICA DE NEGOCIO)



--- Ajustar precios de productos vendidos (Por rangos)

SELECT DISTINCT SOD.ProductID, PPR.ListPrice
FROM Sales.SalesOrderDetail SOD
INNER JOIN Production.Product PPR ON(SOD.ProductID = PPR.ProductID)
WHERE PPR.ListPrice < 22 -- Se usa < 22 porque en los datos actuales este es el máximo valor dentro del rango evaluado

BEGIN TRANSACTION

UPDATE PPR
SET ListPrice =
	CASE
		WHEN ListPrice BETWEEN 0 AND 9.99 THEN ListPrice + 3
		WHEN ListPrice BETWEEN 10 AND 19.99 THEN ListPrice + 2
		ELSE ListPrice
	END
FROM Sales.SalesOrderDetail SOD
INNER JOIN Production.Product PPR ON(SOD.ProductID = PPR.ProductID)

--- COMMIT;
--- ROLLBACK;



--- Aumento de precio controlado (10% mas a los prodcutos que cuestan menos de 50)

SELECT*
FROM Production.Product P
WHERE ListPrice < 50


BEGIN TRANSACTION

UPDATE Production.Product
SET ListPrice = ListPrice * 1.10
WHERE ListPrice < 50


SELECT * --Revisar
FROM Production.Product
WHERE ListPrice < 55

--- COMMIT;
--- ROLLBACK;





