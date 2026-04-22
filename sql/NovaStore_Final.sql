-- Nova Store Database Projesi / Uğur Ege ÇELİK


CREATE DATABASE NovaStoreDB; -- 1.Database'i oluştur.
GO

USE NovaStoreDB; -- 2. Query işlemlerinin üzerinde yapılması için oluşturduğun database'i seç.
GO

-- İstenilen Tabloları oluştur(Proje yönetmeliklerine dayalı).
CREATE TABLE Categories( -- Categories Tablosu: Product kategorilerini saklar.
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Customers( -- 3.Customers Tablosu: Customers bilgilerini saklar.
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(50),
    City VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);
GO

CREATE TABLE Products( -- 4.Products Tablosu: Products bilgilerini saklar.
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT DEFAULT 0,
    CategoryID INT,

    CONSTRAINT FK_Products_Categories -- Products Tablosu ile Categories Tablosunu bağlayan Foreign Key.
    FOREIGN KEY (CategoryID) 
    REFERENCES Categories(CategoryID) -- Products Tablosundaki CategoryID, Categories Tablosundaki CategoryID'ye referans verir.
    -- Bunun ile her Products instance'ının bir Category'si olur.
);
GO

CREATE TABLE Orders( -- 5.Orders Tablosu: Orders bilgilerini saklar.
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),

    CONSTRAINT FK_Orders_Customers -- Orders Tablosu ile Customers Tablosunu bağlayan Foreign Key.
    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID) -- Orders Tablosundaki CustomerID, Customers Tablosundaki CustomerID'ye referans verir.
    -- Bunun ile her Order instance'ının bir Customer'ı olur.
);
GO

CREATE TABLE OrderDetails( -- 6.OrderDetails Tablosu: OrderDetail bilgilerini saklar.
    DetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductID INT,
    Quantity INT,

    CONSTRAINT FK_OrderDetails_Orders -- OrderDetails Tablosu ile Orders Tablosunu bağlayan Foreign Key.
    FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID), -- OrderDetails Tablosundaki OrderID, Order Tablosundaki OrderID'ye referans verir.
    -- Bunun ile her OrderDetails instance'ının bir Order'ı olur.

    CONSTRAINT FK_OrderDetails_Products -- OrderDetails Tablosu ile Products Tablosunu bağlayan Foreign Key.
    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID) -- OrderDetails Tablosundaki ProductsID, Products Tablosundaki ProductID'ye referans verir.
    -- Bunun ile her OrderDetails instance'ının bir Product'ı olur.
);
GO

-- Görev 1: 5 adet Kategori ekleyin 
INSERT INTO Categories(CategoryName) VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yaşam');
GO

-- Görev 2: Her kategoriye ait olacak şekilde toplamda en az 10-12 Ürün ekleyin.
INSERT INTO Products (ProductName, Price, Stock, CategoryID) VALUES
('iPhone 14', 45000, 10, 1),
('Laptop', 30000, 5, 1),
('T-Shirt', 300, 50, 2),
('Jean Pantolon', 800, 20, 2),
('Roman Kitap', 150, 40, 3),
('Bilim Kitabı', 200, 25, 3),
('Parfüm', 1200, 15, 4),
('Krem', 250, 30, 4),
('Kahve Makinesi', 5000, 8, 5),
('Sandalye', 700, 12, 5);
GO

-- Görev 3: 5-6 adet Müşteri kaydı oluşturun.
INSERT INTO Customers(FullName, City, Email) VALUES
('Ahmet Yılmaz', 'İstanbul', 'ahmet@gmail.com'),
('Mehmet Demir', 'Ankara', 'mehmet@gmail.com'),
('Ayşe Kaya', 'İzmir', 'ayse@gmail.com'),
('Fatma Çelik', 'Bursa', 'fatma@gmail.com'),
('Ali Veli', 'Antalya', 'ali@gmail.com');
GO

-- Görev 4: Farklı tarihlerde yapılmış en az 8-10 Sipariş ve bu siparişlere ait Sipariş Detayları girin.
INSERT INTO Orders(CustomerID, OrderDate, TotalAmount) VALUES
(1, '2024-04-01', 50000),
(2, '2024-04-02', 800),
(1, '2024-04-03', 300),
(3, '2024-04-04', 1200),
(4, '2024-04-05', 250),
(5, '2024-04-06', 7000),
(2, '2024-04-07', 150),
(3, '2024-04-08', 200);
GO
-- ChatGPT tarafından oluşturulmuş test verileridir.

-- OrderDetails gir.
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 3, 2),
(3, 5, 1),
(4, 7, 1),
(5, 8, 2),
(6, 9, 1),
(7, 6, 1),
(8, 4, 1);
GO

-- Query 1: Stok miktarı 20'den az olan ürünlerin adını ve stok miktarını, stok miktarına göre "AZALAN" sırada listeleyin.
SELECT ProductName, Stock -- ProductName ve Stock columnlarını;
FROM Products -- Products Tablosundan al.
WHERE Stock<20 -- Stock'u 20'den az olanları filtrele.
ORDER BY Stock DESC; -- Azalan (descending) olarak sırala.
GO

-- Query 2: Hangi müşteri, hangi tarihte sipariş vermiş? Sonuçta Müşteri Adı, Şehir, Sipariş Tarihi ve Toplam Tutar gözüksün.
SELECT -- İstenilen fieldları seç.
    Customers.FullName,
    Customers.City,
    Orders.OrderDate,
    Orders.TotalAmount
FROM Customers -- Customers tablosu ile;
INNER JOIN Orders -- Orders tablosunu birleştir(Seçilen fieldlar üzerinden).
    ON Customers.CustomerID=Orders.CustomerID -- Birleşimde CustomerID ile eşleştir.
ORDER BY Orders.OrderDate; -- Sipariş tarihine göre sırala.
GO

-- Query 3: "Ahmet Yılmaz" (veya verinizdeki bir müşteri) isimli müşterinin aldığı ürünlerin isimlerini, fiyatlarını ve kategorilerini listeleyin.
SELECT -- İstenilen fieldları seç.
    Customers.FullName,
    Products.ProductName,
    Products.Price,
    Categories.CategoryName
FROM Customers -- Customers tablosu ile başla;
INNER JOIN Orders
    ON Customers.CustomerID=Orders.CustomerID -- Customer ile Order'ı bağla.
INNER JOIN OrderDetails
    ON Orders.OrderID=OrderDetails.OrderID -- Order ile OrderDetails'ı bağla.
INNER JOIN Products
    ON OrderDetails.ProductID=Products.ProductID -- OrderDetails ile Products'ı bağla.
INNER JOIN Categories
    ON Products.CategoryID=Categories.CategoryID -- Products ile Categories'i bağla.
WHERE Customers.FullName = 'Ahmet Yılmaz'; -- 'Ahmet Yılmaz' ismini filtrele.
GO

-- Query 4: Hangi kategoride toplam kaç adet ürünümüz var? (Örn: Elektronik - 5 ürün).
SELECT 
    Categories.CategoryName, -- Category Name'i seç.
    COUNT (Products.ProductID) AS ProductCount -- O Category'deki ürün sayısını hesapla ve ProductCount'a ata.
FROM Categories -- Categories Tablosu ile;
LEFT JOIN Products -- Products Tablosunu CategoryID üzerinden bağla.
    ON Categories.CategoryID=Products.CategoryID
GROUP BY Categories.CategoryName; -- CategoryName'e göre grupla.
GO

-- Query 5: Her müşterinin şirkete kazandırdığı toplam ciro nedir? En çok harcama yapan müşteriden en aza doğru sıralayın.
SELECT
    Customers.FullName, -- Customer'ın FUllName'ini seç.
    SUM (Orders.TotalAmount) AS TotalRevenue -- Toplam harcamayı hesapla ve TotalRevenue'ya ata.
FROM Customers -- Customers Tablosu ile;
INNER JOIN Orders -- Orders Tablosunu CustomerID üzerinden bağla.
    ON Customers.CustomerID=Orders.CustomerID
GROUP BY Customers.FullName -- Customer'ın FullName'ine göre grupla.
ORDER BY TotalRevenue DESC; -- Azalan olarak sırala.
GO

-- Query 6: Bugünün tarihine göre, siparişlerin üzerinden kaç gün geçtiğini hesaplayan bir sorgu yazın.
SELECT  -- İstenen fieldları seç.
    OrderID,
    OrderDate,
    DATEDIFF(DAY,OrderDate,GETDATE()) AS DaysPassed -- Bugüne göre geçen gün sayısını hesapla ve DaysPassed'e ata.
FROM Orders
ORDER BY OrderDate; -- OrderDate'e göre sırala.
GO

-- View (Görünüm) Oluşturma (Müşteri, Tarih, Ürün Adı, Adet ve Kategori bilgileri ile):
CREATE VIEW vw_SiparisOzet AS -- View oluştur.
SELECT -- İstenen fieldları seç ve bunları istenen column name'lere ata.
    Customers.FullName AS MusteriAdi, 
    Orders.OrderDate AS SiparisTarihi,
    Products.ProductName AS UrunAdi,
    OrderDetails.Quantity AS Adet,
    Categories.CategoryName AS Kategori
FROM Customers -- Customers tablosu ile başla;
INNER JOIN Orders 
    ON Customers.CustomerID = Orders.CustomerID -- Customer ile Order'ı bağla.
INNER JOIN OrderDetails
    ON Orders.OrderID = OrderDetails.OrderID -- Order ile OrderDetails'ı bağla.
INNER JOIN Products
    ON OrderDetails.ProductID = Products.ProductID -- OrderDetails ile Products'ı bağla.
INNER JOIN Categories
    ON Products.CategoryID = Categories.CategoryID; -- Products ile Categories'i bağla.
GO

-- Yedekleme (Backup): (MacOS sistemine göre refine edilmiş yedekleme path'ı.)
BACKUP DATABASE NovaStoreDB -- Backup oluştur.
TO DISK = 'internship/NovaStore-DB/Backup/NovaStore-DB.bak' -- Kaydedilecek path.
WITH FORMAT; -- Var olan yedekleme varsa sil ve yeniden oluştur.