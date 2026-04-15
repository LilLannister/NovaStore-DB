SELECT ProductName, Stock
FROM Products
WHERE Stock<20
ORDER BY Stock DESC;
GO

SELECT
    Customers.FullName,
    Customers.City,
    Orders.OrderDate,
    Orders.TotalAmount
FROM Customers
INNER JOIN Orders
    ON Customers.CustomerID=Orders.CustomerID
ORDER BY Orders.OrderDate;
GO

SELECT 
    Customers.FullName,
    Products.ProductName,
    Products.Price,
    Categories.CategoryName
FROM Customers
INNER JOIN Orders
    ON Customers.CustomerID=Orders.CustomerID
INNER JOIN OrderDetails
    ON Orders.OrderID=OrderDetails.OrderID
INNER JOIN Products
    ON OrderDetails.ProductID=Products.ProductID
INNER JOIN Categories
    ON Products.CategoryID=Categories.CategoryID
WHERE Customers.FullName = 'Ahmet Yılmaz';
GO

SELECT 
    Categories.CategoryName,
    COUNT (Products.ProductID) AS ProductCount
FROM Categories
LEFT JOIN Products
    ON Categories.CategoryID=Products.CategoryID
GROUP BY Categories.CategoryName;
GO

SELECT
    Customers.FullName,
    SUM (Orders.TotalAmount) AS TotalRevenue
FROM Customers 
INNER JOIN Orders
    ON Customers.CustomerID=Orders.CustomerID
GROUP BY Customers.FullName
ORDER BY TotalRevenue DESC;