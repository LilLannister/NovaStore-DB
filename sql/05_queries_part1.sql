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