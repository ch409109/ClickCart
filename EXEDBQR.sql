CREATE DATABASE ClickCart
GO
USE ClickCart;

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(15),
    Role NVARCHAR(20) CHECK (Role IN ('Admin', 'Customer')) NOT NULL DEFAULT 'Customer',
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID),
    Price INT NOT NULL,
    Stock INT NOT NULL,
    Description NVARCHAR(MAX),
    ImageUrl NVARCHAR(255),
    IsAlcoholic BIT NOT NULL DEFAULT 0
);

CREATE TABLE Combos (
    ComboID INT PRIMARY KEY IDENTITY(1,1),
    ComboName NVARCHAR(100) NOT NULL,
    Price INT NOT NULL,
    Description NVARCHAR(MAX),
    ImageUrl NVARCHAR(255)
);

CREATE TABLE ComboProducts (
    ComboID INT NOT NULL FOREIGN KEY REFERENCES Combos(ComboID),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    PRIMARY KEY (ComboID, ProductID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    TotalAmount INT NOT NULL,
    PaymentStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    PaymentGateway NVARCHAR(50) NOT NULL DEFAULT 'VNPay',
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    Price INT NOT NULL
);

CREATE TABLE Carts (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE CartItems (
    CartItemID INT PRIMARY KEY IDENTITY(1,1),
    CartID INT NOT NULL FOREIGN KEY REFERENCES Carts(CartID),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL
);

CREATE TABLE Vouchers (
    VoucherID INT PRIMARY KEY IDENTITY(1,1),
    VoucherCode NVARCHAR(50) NOT NULL UNIQUE,
    DiscountPercentage INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

INSERT INTO Categories (CategoryName, Description)
VALUES 
(N'Đồ uống', N'Các loại đồ uống bao gồm nước ngọt, nước lọc, bia, rượu...'),
(N'Đồ ăn vặt', N'Các loại snack, bánh kẹo, hạt ăn vặt...'),
(N'Gia vị', N'Gia vị bao gồm hành, tỏi, tiêu, ớt, muối...'),
(N'Thực phẩm ăn liền', N'Các loại thực phẩm chế biến sẵn như mì tôm, cháo ăn liền...'),
(N'Thực phẩm tươi sống', N'Rau củ, thịt cá tươi sống...'),
(N'Dụng cụ nội trợ', N'Các dụng cụ nhà bếp như dao, nồi, chảo...');

-- Insert data into Products table for "Đồ ăn vặt"
INSERT INTO Products (ProductName, CategoryID, Price, Stock, Description, ImageUrl, IsAlcoholic)
VALUES 
(N'Bánh gạo Jinju cốt sữa', 2, 30.000, 5, N'Bánh gạo vị cốt sữa thơm ngon', N'Bánh gạo Jinju cốt sữa.png', 0),
(N'Bánh quy bơ Danisa hộp 908g', 2, 300.000, 4, N'Bánh quy bơ cao cấp, hương vị truyền thống', N'Bánh quy bơ Danisa hộp 908g.png', 0),
(N'Bánh que Pocky Glico 118g', 2, 90.000, 5, N'Bánh que vị socola thơm ngon', N'Hộp Bánh Pocky Glico 118g.png', 0),
(N'Kẹo sing gum bạc hà Cool Air Wrigley', 2, 40.000, 5, N'Kẹo sing gum mát lạnh vị bạc hà', N'Kẹo sing gum hương bạc hà và khuynh diệp CooL Air Wrigley.png', 0),
(N'Snack khoai tây Lay''s tôm hùm cay', 2, 70.000, 3, N'Snack khoai tây vị tôm hùm cay đậm đà', N'Snach khoai tây Lay''s tôm hùm cay lon 105 g.png', 0);

-- Insert data into Products table for "Gia vị"
INSERT INTO Products (ProductName, CategoryID, Price, Stock, Description, ImageUrl, IsAlcoholic)
VALUES 
(N'Bột ngọt Ajinomoto 400g', 3, 40.000, 5, N'Bột ngọt chất lượng cao', N'Bột ngọt (mì chính) Ajinomoto 400g.png', 0),
(N'Dầu hào Lee Kum Kee chai 255g', 3, 45.000, 4, N'Dầu hào thơm ngon, dễ sử dụng', N'Dầu hào Lee Kum Kee Chun chai 255g.png', 0),
(N'Nước mắm Phú Quốc 35 độ đạm', 3, 95.000, 3, N'Nước mắm truyền thống đậm vị', N'Nước mắm Phú Quốc Thanh Quốc 35 độ đậm.png', 0),
(N'Tương ớt ngọt Cholimex PET 2.1kg', 3, 75.000, 2, N'Tương ớt ngọt hương vị đậm đà', N'Tương ớt chua ngọt Cholimex PET 2.1kg.png', 0),
(N'Gia vị lẩu Thái Aji-Quick', 3, 10.000, 4, N'Hỗn hợp gia vị nêm sẵn cho lẩu Thái', N'Gia vị nêm sẵn lẩu Thái Aji-Quick gói 50g.png', 0);

-- Insert data into Products table for "Nước giải khát"
INSERT INTO Products (ProductName, CategoryID, Price, Stock, Description, ImageUrl, IsAlcoholic)
VALUES 
(N'Nước khoáng Lavie 1.5L', 1, 15.000, 5, N'Nước khoáng thiên nhiên tinh khiết', N'Nước khoáng thiên nhiên LaVie 1.5 lít.png', 0),
(N'Nước uống tăng lực Redbull 250ml', 1, 15.000, 4, N'Nước tăng lực cung cấp năng lượng nhanh chóng', N'Nước uống tăng lực Việt Redbull lon 250ml.png', 0),
(N'Thùng 24 lon bia Heineken 330ml', 1, 500.000, 3, N'Bia Heineken cao cấp, vị thơm ngon', N'Thùng 24 lon bia Heineken 330ml.png', 1),
(N'Thùng 24 lon bia Saigon Lager 330ml', 1, 300.000, 2, N'Bia Sài Gòn Lager truyền thống', N'Thùng 24 lon Bia Saigon lager 330ml.png', 1),
(N'Trà bí đao Wonderfarm lon 310ml', 1, 10.000, 5, N'Trá bí đao giải khát mát lành', N'Trá bí đao Wonderfarm lon 310ml.png', 0);

-- Insert data into Products table for "Thực phẩm ăn liền"
INSERT INTO Products (ProductName, CategoryID, Price, Stock, Description, ImageUrl, IsAlcoholic)
VALUES 
(N'Cháo thịt bằm Vifon gói 70g', 4, 10.000, 5, N'Cháo ăn liền tiện lợi, thơm ngon', N'Cháo thịt bằm Vifon gói 70g.png', 0),
(N'Mì gói ăn liền cay Shin Ramyun Nongshim 114g', 4, 40.000, 4, N'Mì ăn liền vị cay đặc trưng Hàn Quốc', N'Mì gói ăn liền cay Shin Ramyun Nongshim 114g.png', 0),
(N'Phở gà Đệ Nhất gói 65g', 4, 10.000, 5, N'Phở ăn liền thơm ngon, tiện lợi', N'Phở gà Đệ Nhất gói 65g.png', 0),
(N'Thùng 24 ly mì Hảo Hảo tôm chua cay', 4, 220.000, 3, N'Thùng mì ly Hảo Hảo tiện lợi', N'Thùng 24 ly mì Hảo Hảo vị tôm chua cay Acecook 67g.png', 0),
(N'Thùng 30 gói mì tôm chua cay Hảo Hảo', 4, 130.000, 2, N'Mì gói Hảo Hảo thơm ngon', N'Thùng 30 gói mì tôm chua cay Hảo Hảo Vina Acecook 75g.png', 0);
