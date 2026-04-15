CREATE VIEW vw_SiparisOzet AS
SELECT
    Customers.FullName AS MusteriAdi,
    Orders.OrderDate AS SiparisTarihi,
    Products.ProductName AS UrunAdi,
    OrderDetails.Quantity AS Adet
FROM Customers
INNER JOIN Orders
    ON Customers.CustomerID=Orders.CustomerID
INNER JOIN OrderDetails
    ON Orders.OrderID=OrderDetails.OrderID
INNER JOIN Products
    ON OrderDetails.ProductID=Products.ProductID
GO

SELECT * FROM vw_SiparisOzet