
/****** Object:  Database [BaseCoreSales]    Script Date: 24/04/2026 3:35:51 CH ******/
IF DB_ID(N'BaseCoreSales') IS NULL
BEGIN
    CREATE DATABASE [BaseCoreSales];
END
GO
ALTER DATABASE [BaseCoreSales] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BaseCoreSales].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BaseCoreSales] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BaseCoreSales] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BaseCoreSales] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BaseCoreSales] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BaseCoreSales] SET ARITHABORT OFF 
GO
ALTER DATABASE [BaseCoreSales] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [BaseCoreSales] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BaseCoreSales] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BaseCoreSales] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BaseCoreSales] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BaseCoreSales] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BaseCoreSales] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BaseCoreSales] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BaseCoreSales] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BaseCoreSales] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BaseCoreSales] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BaseCoreSales] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BaseCoreSales] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BaseCoreSales] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BaseCoreSales] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BaseCoreSales] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [BaseCoreSales] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BaseCoreSales] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BaseCoreSales] SET  MULTI_USER 
GO
ALTER DATABASE [BaseCoreSales] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BaseCoreSales] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BaseCoreSales] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BaseCoreSales] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BaseCoreSales] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BaseCoreSales] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [BaseCoreSales] SET QUERY_STORE = ON
GO
ALTER DATABASE [BaseCoreSales] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BaseCoreSales]
GO
/****** Object:  Table [dbo].[CartItems]    Script Date: 24/04/2026 3:35:51 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[CartItems]', N'U') IS NULL
CREATE TABLE [dbo].[CartItems](
	[CartItemId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[AddedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CartItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 24/04/2026 3:35:52 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Categories]', N'U') IS NULL
CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[ImageUrl] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contacts]    Script Date: 24/04/2026 3:35:52 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Contacts]', N'U') IS NULL
CREATE TABLE [dbo].[Contacts](
	[ContactId] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Subject] [nvarchar](200) NULL,
	[Message] [nvarchar](1000) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK__Contacts__5C66259B206DC337] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Coupons]    Script Date: 24/04/2026 3:35:52 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Coupons]', N'U') IS NULL
CREATE TABLE [dbo].[Coupons](
	[CouponId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[DiscountType] [nvarchar](20) NOT NULL,
	[DiscountValue] [decimal](18, 2) NOT NULL,
	[MinOrderAmount] [decimal](18, 2) NOT NULL,
	[MaxDiscountAmount] [decimal](18, 2) NULL,
	[StartAt] [datetime] NOT NULL,
	[EndAt] [datetime] NOT NULL,
	[UsageLimit] [int] NULL,
	[UsedCount] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsPublic] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CouponId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 24/04/2026 3:35:52 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[OrderItems]', N'U') IS NULL
CREATE TABLE [dbo].[OrderItems](
	[OrderItemId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[SubTotal]  AS ([Quantity]*[UnitPrice]) PERSISTED,
PRIMARY KEY CLUSTERED 
(
	[OrderItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 24/04/2026 3:35:52 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Orders]', N'U') IS NULL
CREATE TABLE [dbo].[Orders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ReceiverName] [nvarchar](100) NOT NULL,
	[Phone] [nvarchar](20) NOT NULL,
	[ShippingAddress] [nvarchar](255) NOT NULL,
	[Note] [nvarchar](500) NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[DiscountAmount] [decimal](18, 2) NOT NULL,
	[CouponCode] [nvarchar](50) NULL,
	[PaymentMethod] [nvarchar](50) NOT NULL,
	[PaymentStatus] [nvarchar](50) NOT NULL,
	[OrderStatus] [nvarchar](50) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK__Orders__C3905BCF422094EE] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductImages]    Script Date: 24/04/2026 3:35:52 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[ProductImages]', N'U') IS NULL
CREATE TABLE [dbo].[ProductImages](
	[ImageId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ImageUrl] [nvarchar](255) NOT NULL,
	[IsMain] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ImageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 24/04/2026 3:35:52 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NULL
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[ProductName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[StockQuantity] [int] NOT NULL,
	[ImageUrl] [nvarchar](255) NULL,
	[Unit] [nvarchar](50) NULL,
	[IsFeatured] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 24/04/2026 3:35:52 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID(N'[dbo].[Users]', N'U') IS NULL
CREATE TABLE [dbo].[Users](
	[Id] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[Salt] [varbinary](max) NULL,
	[Contact] [nvarchar](max) NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Phone] [nvarchar](20) NULL,
	[Position] [nvarchar](max) NULL,
	[Image] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[UserType] [int] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CartItems] ON 

IF NOT EXISTS (SELECT 1 FROM [dbo].[CartItems] WHERE [CartItemId] = 1)
BEGIN
    INSERT [dbo].[CartItems] ([CartItemId], [UserId], [ProductId], [Quantity], [AddedAt]) VALUES (1, N'USR000001', 1, 2, CAST(N'2026-04-24T08:56:15.523' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[CartItems] WHERE [CartItemId] = 2)
BEGIN
    INSERT [dbo].[CartItems] ([CartItemId], [UserId], [ProductId], [Quantity], [AddedAt]) VALUES (2, N'USR000001', 3, 3, CAST(N'2026-04-24T08:56:15.523' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[CartItems] WHERE [CartItemId] = 3)
BEGIN
    INSERT [dbo].[CartItems] ([CartItemId], [UserId], [ProductId], [Quantity], [AddedAt]) VALUES (3, N'USR000002', 2, 1, CAST(N'2026-04-24T08:56:15.523' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[CartItems] WHERE [CartItemId] = 4)
BEGIN
    INSERT [dbo].[CartItems] ([CartItemId], [UserId], [ProductId], [Quantity], [AddedAt]) VALUES (4, N'USR000002', 11, 2, CAST(N'2026-04-24T08:56:15.523' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[CartItems] WHERE [CartItemId] = 5)
BEGIN
    INSERT [dbo].[CartItems] ([CartItemId], [UserId], [ProductId], [Quantity], [AddedAt]) VALUES (5, N'USR000003', 17, 1, CAST(N'2026-04-24T08:56:15.523' AS DateTime))
END
SET IDENTITY_INSERT [dbo].[CartItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

IF NOT EXISTS (SELECT 1 FROM [dbo].[Categories] WHERE [CategoryId] = 1)
BEGIN
    INSERT [dbo].[Categories] ([CategoryId], [CategoryName], [Description], [IsActive]) VALUES (1, N'Bánh kẹo', N'Các loại bánh, kẹo và đồ ngọt ăn vặt', 1)
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Categories] WHERE [CategoryId] = 3)
BEGIN
    INSERT [dbo].[Categories] ([CategoryId], [CategoryName], [Description], [IsActive]) VALUES (3, N'Nước uống', N'Các loại nước uống đóng chai, lon, trà, cà phê', 1)
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Categories] WHERE [CategoryId] = 13)
BEGIN
    INSERT [dbo].[Categories] ([CategoryId], [CategoryName], [Description], [IsActive]) VALUES (13, N'Đồ ăn vặt', N'Snack, rong biển, mì ăn liền và các món ăn vặt khác', 1)
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Categories] WHERE [CategoryId] = 14)
BEGIN
    INSERT [dbo].[Categories] ([CategoryId], [CategoryName], [Description], [IsActive]) VALUES (14, N'Combo', N'Các combo sản phẩm tiết kiệm', 1)
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Categories] WHERE [CategoryId] = 15)
BEGIN
    INSERT [dbo].[Categories] ([CategoryId], [CategoryName], [Description], [IsActive]) VALUES (15, N'Đồ khô', N'Khô gà, khô bò, hạt và các loại đồ khô ăn liền', 1)
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Categories] WHERE [CategoryId] = 16)
BEGIN
    INSERT [dbo].[Categories] ([CategoryId], [CategoryName], [Description], [IsActive]) VALUES (16, N'Khác', N'Các sản phẩm khác', 1)
END
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Contacts] ON 

IF NOT EXISTS (SELECT 1 FROM [dbo].[Contacts] WHERE [ContactId] = 1)
BEGIN
    INSERT [dbo].[Contacts] ([ContactId], [FullName], [Email], [Subject], [Message], [CreatedAt], [Status]) VALUES (1, N'Nguyễn Thu Hà', N'thuha@gmail.com', N'Hỏi phí ship', N'Shop có hỗ trợ giao nhanh nội thành không ạ?', CAST(N'2026-04-24T08:56:15.503' AS DateTime), N'Chưa xử lý')
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Contacts] WHERE [ContactId] = 2)
BEGIN
    INSERT [dbo].[Contacts] ([ContactId], [FullName], [Email], [Subject], [Message], [CreatedAt], [Status]) VALUES (2, N'Lê Phương Anh', N'phuonganh@gmail.com', N'Hỏi combo', N'Combo học bài gồm những món nào vậy shop?', CAST(N'2026-04-23T08:56:15.507' AS DateTime), N'Đã phản hồi')
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Contacts] WHERE [ContactId] = 3)
BEGIN
    INSERT [dbo].[Contacts] ([ContactId], [FullName], [Email], [Subject], [Message], [CreatedAt], [Status]) VALUES (3, N'Trần Minh Khôi', N'khoi@gmail.com', N'Hỏi hàng Thái', N'Bên mình có hàng nội địa Thái chuẩn không ạ?', CAST(N'2026-04-22T08:56:15.507' AS DateTime), N'Chưa xử lý')
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Contacts] WHERE [ContactId] = 4)
BEGIN
    INSERT [dbo].[Contacts] ([ContactId], [FullName], [Email], [Subject], [Message], [CreatedAt], [Status]) VALUES (4, N'Phạm Hồng Nhung', N'nhung@gmail.com', N'Đổi sản phẩm', N'Em muốn đổi vị snack thì shop hỗ trợ thế nào?', CAST(N'2026-04-21T08:56:15.510' AS DateTime), N'Đã phản hồi')
END
SET IDENTITY_INSERT [dbo].[Contacts] OFF
GO
SET IDENTITY_INSERT [dbo].[Coupons] ON 

IF NOT EXISTS (SELECT 1 FROM [dbo].[Coupons] WHERE [CouponId] = 1)
BEGIN
    INSERT [dbo].[Coupons] ([CouponId], [Code], [Name], [Description], [DiscountType], [DiscountValue], [MinOrderAmount], [MaxDiscountAmount], [StartAt], [EndAt], [UsageLimit], [UsedCount], [IsActive], [IsPublic], [DisplayOrder], [CreatedAt]) VALUES (1, N'WELCOME10', N'Giảm 10% cho đơn đầu', N'Giảm 10% tối đa 30.000đ cho đơn từ 100.000đ', N'Percent', CAST(10.00 AS Decimal(18, 2)), CAST(100000.00 AS Decimal(18, 2)), CAST(30000.00 AS Decimal(18, 2)), CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2027-01-01T00:00:00.000' AS DateTime), 1000, 0, 1, 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Coupons] WHERE [CouponId] = 2)
BEGIN
    INSERT [dbo].[Coupons] ([CouponId], [Code], [Name], [Description], [DiscountType], [DiscountValue], [MinOrderAmount], [MaxDiscountAmount], [StartAt], [EndAt], [UsageLimit], [UsedCount], [IsActive], [IsPublic], [DisplayOrder], [CreatedAt]) VALUES (2, N'SNACK30K', N'Giảm thẳng 30.000đ', N'Giảm trực tiếp 30.000đ cho đơn từ 200.000đ', N'Fixed', CAST(30000.00 AS Decimal(18, 2)), CAST(200000.00 AS Decimal(18, 2)), NULL, CAST(N'2026-01-01T00:00:00.000' AS DateTime), CAST(N'2027-01-01T00:00:00.000' AS DateTime), 500, 0, 1, 1, 2, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
SET IDENTITY_INSERT [dbo].[Coupons] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderItems] ON 

IF NOT EXISTS (SELECT 1 FROM [dbo].[OrderItems] WHERE [OrderItemId] = 1)
BEGIN
    INSERT [dbo].[OrderItems] ([OrderItemId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (1, 1, 1, 1, CAST(45000.00 AS Decimal(18, 2)))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[OrderItems] WHERE [OrderItemId] = 2)
BEGIN
    INSERT [dbo].[OrderItems] ([OrderItemId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (2, 1, 3, 2, CAST(18000.00 AS Decimal(18, 2)))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[OrderItems] WHERE [OrderItemId] = 3)
BEGIN
    INSERT [dbo].[OrderItems] ([OrderItemId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (3, 2, 2, 1, CAST(25000.00 AS Decimal(18, 2)))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[OrderItems] WHERE [OrderItemId] = 4)
BEGIN
    INSERT [dbo].[OrderItems] ([OrderItemId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (4, 2, 11, 2, CAST(55000.00 AS Decimal(18, 2)))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[OrderItems] WHERE [OrderItemId] = 5)
BEGIN
    INSERT [dbo].[OrderItems] ([OrderItemId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (5, 3, 30, 1, CAST(119000.00 AS Decimal(18, 2)))
END
SET IDENTITY_INSERT [dbo].[OrderItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

IF NOT EXISTS (SELECT 1 FROM [dbo].[Orders] WHERE [OrderId] = 1)
BEGIN
    INSERT [dbo].[Orders] ([OrderId], [UserId], [ReceiverName], [Phone], [ShippingAddress], [Note], [TotalAmount], [DiscountAmount], [CouponCode], [PaymentMethod], [PaymentStatus], [OrderStatus], [CreatedAt]) VALUES (1, N'USR000001', N'Nguyễn Hồng Liên', N'0901000001', N'Hoàn Kiếm, Hà Nội', N'Giao giờ hành chính', CAST(88000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, N'COD', N'Unpaid', N'Pending', CAST(N'2026-04-22T08:56:15.543' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Orders] WHERE [OrderId] = 2)
BEGIN
    INSERT [dbo].[Orders] ([OrderId], [UserId], [ReceiverName], [Phone], [ShippingAddress], [Note], [TotalAmount], [DiscountAmount], [CouponCode], [PaymentMethod], [PaymentStatus], [OrderStatus], [CreatedAt]) VALUES (2, N'USR000002', N'Trần Minh Thư', N'0901000002', N'Quận 3, TP.HCM', N'Gọi trước khi giao', CAST(124000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, N'Bank Transfer', N'Paid', N'Shipping', CAST(N'2026-04-23T08:56:15.547' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Orders] WHERE [OrderId] = 3)
BEGIN
    INSERT [dbo].[Orders] ([OrderId], [UserId], [ReceiverName], [Phone], [ShippingAddress], [Note], [TotalAmount], [DiscountAmount], [CouponCode], [PaymentMethod], [PaymentStatus], [OrderStatus], [CreatedAt]) VALUES (3, N'USR000004', N'Lê Minh Quang', N'0901000004', N'Lê Chân, Hải Phòng', N'Giao buổi tối', CAST(119000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, N'COD', N'Unpaid', N'Confirmed', CAST(N'2026-04-23T22:56:15.550' AS DateTime))
END
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 1)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (1, 1, N'Bánh trứng Thái Lan', N'Bánh trứng thơm mềm, vị ngọt nhẹ', CAST(45000.00 AS Decimal(18, 2)), 100, N'img/banhtrungthai.jpg', N'Hộp', 1, 1, CAST(N'2026-04-23T00:14:52.317' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 2)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (2, 13, N'Snack mực cay', N'Snack mực vị cay đậm đà', CAST(25000.00 AS Decimal(18, 2)), 80, N'img/snackmuccay.jpg', N'Gói', 1, 1, CAST(N'2026-04-23T00:14:52.317' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 3)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (3, 3, N'Trà sữa đóng chai', N'Trà sữa tiện lợi, dễ uống', CAST(18000.00 AS Decimal(18, 2)), 120, N'img/trasuachai.jpg', N'Chai', 0, 1, CAST(N'2026-04-23T00:14:52.317' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 4)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (4, 14, N'Combo ăn vặt 5 món', N'Combo mix tiết kiệm', CAST(99000.00 AS Decimal(18, 2)), 50, N'img/combo5mon.jpg', N'Combo', 1, 1, CAST(N'2026-04-23T00:14:52.317' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 5)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (5, 1, N'Bánh quy bơ mini', N'Bánh quy bơ giòn thơm, tiện ăn nhẹ mỗi ngày', CAST(35000.00 AS Decimal(18, 2)), 120, N'img/banhquybo.jpg', N'Hộp', 1, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 6)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (6, 1, N'Bánh gấu nhân socola', N'Bánh gấu nhân socola giòn thơm', CAST(28000.00 AS Decimal(18, 2)), 150, N'img/banhgau_socola.jpg', N'Gói', 0, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 7)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (7, 1, N'Bánh waffle mật ong', N'Bánh waffle vị mật ong thơm ngọt', CAST(49000.00 AS Decimal(18, 2)), 70, N'img/waffle_matong.jpg', N'Hộp', 1, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 8)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (8, 1, N'Bánh cuộn kem sữa', N'Bánh cuộn giòn nhân kem sữa béo nhẹ', CAST(42000.00 AS Decimal(18, 2)), 95, N'img/banhcuon_kemsua.jpg', N'Hộp', 0, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 9)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (9, 13, N'Snack khoai tây cay BBQ', N'Snack khoai tây vị BBQ cay nhẹ', CAST(22000.00 AS Decimal(18, 2)), 180, N'img/snack_khoaitay_bbq.jpg', N'Gói', 1, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 10)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (10, 13, N'Snack tôm cay giòn', N'Snack vị tôm cay đậm đà', CAST(24000.00 AS Decimal(18, 2)), 160, N'img/snack_tomcay.jpg', N'Gói', 0, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 11)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (11, 13, N'Rong biển kẹp hạt', N'Rong biển giòn kẹp hạt dinh dưỡng', CAST(55000.00 AS Decimal(18, 2)), 75, N'img/rongbien_kephat.jpg', N'Gói', 1, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 12)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (12, 13, N'Rong biển sấy vị truyền thống', N'Rong biển sấy giòn, vị thanh nhẹ', CAST(32000.00 AS Decimal(18, 2)), 110, N'img/rongbien_truyenthong.jpg', N'Gói', 0, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 13)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (13, 1, N'Kẹo dẻo trái cây mix vị', N'Kẹo dẻo mix nhiều vị trái cây', CAST(30000.00 AS Decimal(18, 2)), 130, N'img/keodeo_mixvi.jpg', N'Gói', 1, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 14)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (14, 1, N'Socola hạnh nhân', N'Socola ngọt dịu kết hợp hạnh nhân giòn', CAST(65000.00 AS Decimal(18, 2)), 60, N'img/socola_hanhnhan.jpg', N'Hộp', 1, 1, CAST(N'2026-04-24T08:56:15.460' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 15)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (15, 13, N'Mì ly cay phô mai', N'Mì ly vị cay phô mai tiện lợi', CAST(27000.00 AS Decimal(18, 2)), 140, N'img/mily_cay_phomai.jpg', N'Ly', 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 16)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (16, 13, N'Mì gói vị bò cay', N'Mì gói vị bò cay đậm vị', CAST(18000.00 AS Decimal(18, 2)), 220, N'img/migoi_bocay.jpg', N'Gói', 0, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 17)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (17, 15, N'Khô gà lá chanh', N'Khô gà xé cay nhẹ, thơm lá chanh', CAST(79000.00 AS Decimal(18, 2)), 90, N'img/khoga_lachanh.jpg', N'Hộp', 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 18)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (18, 15, N'Khô bò miếng cay', N'Khô bò miếng mềm dai, cay vừa', CAST(99000.00 AS Decimal(18, 2)), 65, N'img/khobo_miengcay.jpg', N'Hộp', 0, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 19)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (19, 15, N'Chân gà ăn liền sốt cay', N'Chân gà ăn liền vị cay đậm', CAST(45000.00 AS Decimal(18, 2)), 100, N'img/changa_sotcay.jpg', N'Gói', 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 20)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (20, 15, N'Hạt điều rang muối', N'Hạt điều rang muối thơm bùi', CAST(85000.00 AS Decimal(18, 2)), 80, N'img/hatdieu_rangmuoi.jpg', N'Hộp', 0, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 21)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (21, 15, N'Hạnh nhân sấy bơ', N'Hạnh nhân giòn bùi, vị bơ nhẹ', CAST(92000.00 AS Decimal(18, 2)), 55, N'img/hanhnhan_saybo.jpg', N'Hộp', 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 22)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (22, 3, N'Cà phê lon sữa đá', N'Cà phê lon tiện lợi, vị sữa đá', CAST(22000.00 AS Decimal(18, 2)), 125, N'img/caphe_suada.jpg', N'Lon', 0, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 23)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (23, 3, N'Trà đào đóng chai', N'Trà đào thanh mát, dễ uống', CAST(19000.00 AS Decimal(18, 2)), 170, N'img/tradao_chai.jpg', N'Chai', 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 24)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (24, 3, N'Sữa dâu đóng chai', N'Sữa dâu vị ngọt nhẹ, dễ uống', CAST(20000.00 AS Decimal(18, 2)), 150, N'img/suadau_chai.jpg', N'Chai', 0, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 25)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (25, 3, N'Nước ép nho mini', N'Nước ép nho chai nhỏ tiện dùng', CAST(17000.00 AS Decimal(18, 2)), 180, N'img/nuocep_nho.jpg', N'Chai', 0, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 26)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (26, 13, N'Bánh que Thái vị sữa', N'Bánh que giòn vị sữa nội địa Thái', CAST(38000.00 AS Decimal(18, 2)), 90, N'img/banhque_thai_sua.jpg', N'Hộp', 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 27)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (27, 13, N'Kẹo sữa Thái', N'Kẹo sữa nội địa Thái mềm thơm', CAST(34000.00 AS Decimal(18, 2)), 130, N'img/keosua_thai.jpg', N'Gói', 0, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 28)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (28, 14, N'Combo ăn vặt 3 món', N'Combo tiết kiệm gồm 3 món bán chạy', CAST(69000.00 AS Decimal(18, 2)), 60, N'img/combo_3mon.jpg', N'Combo', 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 29)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (29, 14, N'Combo ăn vặt học bài', N'Combo bánh kẹo nhẹ cho dân văn phòng, học sinh', CAST(89000.00 AS Decimal(18, 2)), 45, N'img/combo_hocbai.jpg', N'Combo', 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Products] WHERE [ProductId] = 30)
BEGIN
    INSERT [dbo].[Products] ([ProductId], [CategoryId], [ProductName], [Description], [Price], [StockQuantity], [ImageUrl], [Unit], [IsFeatured], [IsActive], [CreatedAt]) VALUES (30, 14, N'Combo snack cay 5 món', N'Combo dành cho tín đồ ăn cay', CAST(119000.00 AS Decimal(18, 2)), 40, N'img/combo_snackcay_5mon.jpg', N'Combo', 1, 1, CAST(N'2026-04-24T08:56:15.463' AS DateTime))
END
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Id] = N'507f1f77bcf86cd799439011')
BEGIN
    INSERT [dbo].[Users] ([Id], [Name], [UserName], [Password], [Salt], [Contact], [Email], [Phone], [Position], [Image], [IsActive], [UserType], [Created]) VALUES (N'507f1f77bcf86cd799439011', N'Administrator', N'admin', N'admin', NULL, N'', N'admin@robotvibot.com', N'0123456789', N'System Administrator', N'', 1, 1, CAST(N'2026-04-22T16:06:35.7646719' AS DateTime2))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Id] = N'ADM000002')
BEGIN
    INSERT [dbo].[Users] ([Id], [Name], [UserName], [Password], [Salt], [Contact], [Email], [Phone], [Position], [Image], [IsActive], [UserType], [Created]) VALUES (N'ADM000002', N'Thanh Seller', N'thanh.admin', N'123456', NULL, N'Hà Nội', N'thanh.admin@snackshop.com', N'0901999999', N'Seller Admin', N'', 1, 1, CAST(N'2026-04-24T08:56:15.4000000' AS DateTime2))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Id] = N'USR000001')
BEGIN
    INSERT [dbo].[Users] ([Id], [Name], [UserName], [Password], [Salt], [Contact], [Email], [Phone], [Position], [Image], [IsActive], [UserType], [Created]) VALUES (N'USR000001', N'Nguyễn Hồng Liên', N'lien.nguyen', N'123456', NULL, N'Hà Nội', N'lien.nguyen@gmail.com', N'0901000001', N'Customer', N'', 1, 2, CAST(N'2026-04-24T08:56:15.4000000' AS DateTime2))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Id] = N'USR000002')
BEGIN
    INSERT [dbo].[Users] ([Id], [Name], [UserName], [Password], [Salt], [Contact], [Email], [Phone], [Position], [Image], [IsActive], [UserType], [Created]) VALUES (N'USR000002', N'Trần Minh Thư', N'thu.tran', N'123456', NULL, N'TP.HCM', N'thu.tran@gmail.com', N'0901000002', N'Customer', N'', 1, 2, CAST(N'2026-04-24T08:56:15.4000000' AS DateTime2))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Id] = N'USR000003')
BEGIN
    INSERT [dbo].[Users] ([Id], [Name], [UserName], [Password], [Salt], [Contact], [Email], [Phone], [Position], [Image], [IsActive], [UserType], [Created]) VALUES (N'USR000003', N'Phạm Ngọc Mai', N'mai.pham', N'123456', NULL, N'Đà Nẵng', N'mai.pham@gmail.com', N'0901000003', N'Customer', N'', 1, 2, CAST(N'2026-04-24T08:56:15.4000000' AS DateTime2))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Id] = N'USR000004')
BEGIN
    INSERT [dbo].[Users] ([Id], [Name], [UserName], [Password], [Salt], [Contact], [Email], [Phone], [Position], [Image], [IsActive], [UserType], [Created]) VALUES (N'USR000004', N'Lê Minh Quang', N'quang.le', N'123456', NULL, N'Hải Phòng', N'quang.le@gmail.com', N'0901000004', N'Customer', N'', 1, 2, CAST(N'2026-04-24T08:56:15.4000000' AS DateTime2))
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Id] = N'USR000005')
BEGIN
    INSERT [dbo].[Users] ([Id], [Name], [UserName], [Password], [Salt], [Contact], [Email], [Phone], [Position], [Image], [IsActive], [UserType], [Created]) VALUES (N'USR000005', N'Võ Thanh Hoa', N'hoa.vo', N'123456', NULL, N'Cần Thơ', N'hoa.vo@gmail.com', N'0901000005', N'Customer', N'', 1, 2, CAST(N'2026-04-24T08:56:15.4000000' AS DateTime2))
END
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Cart_User_Product]    Script Date: 24/04/2026 3:35:52 CH ******/
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE [name] = N'UQ_Cart_User_Product'
      AND [object_id] = OBJECT_ID(N'[dbo].[CartItems]')
)
ALTER TABLE [dbo].[CartItems] ADD  CONSTRAINT [UQ_Cart_User_Product] UNIQUE NONCLUSTERED 
(
	[UserId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_UserName]    Script Date: 24/04/2026 3:35:52 CH ******/
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE [name] = N'IX_Users_UserName'
      AND [object_id] = OBJECT_ID(N'[dbo].[Users]')
)
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_UserName] ON [dbo].[Users]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_Coupons_Code]    Script Date: 24/04/2026 3:35:52 CH ******/
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE [name] = N'UX_Coupons_Code'
      AND [object_id] = OBJECT_ID(N'[dbo].[Coupons]')
)
CREATE UNIQUE NONCLUSTERED INDEX [UX_Coupons_Code] ON [dbo].[Coupons]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
IF COL_LENGTH(N'[dbo].[CartItems]', N'AddedAt') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[CartItems]')
          AND c.[name] = N'AddedAt'
    )
ALTER TABLE [dbo].[CartItems] ADD  DEFAULT (getdate()) FOR [AddedAt]
GO
IF COL_LENGTH(N'[dbo].[Categories]', N'IsActive') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Categories]')
          AND c.[name] = N'IsActive'
    )
ALTER TABLE [dbo].[Categories] ADD  DEFAULT ((1)) FOR [IsActive]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'DF__Contacts__Create__6CD828CA' AND [type] = 'D')
ALTER TABLE [dbo].[Contacts] ADD  CONSTRAINT [DF__Contacts__Create__6CD828CA]  DEFAULT (getdate()) FOR [CreatedAt]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'DF__Contacts__Status__6DCC4D03' AND [type] = 'D')
ALTER TABLE [dbo].[Contacts] ADD  CONSTRAINT [DF__Contacts__Status__6DCC4D03]  DEFAULT (N'Chưa xử lý') FOR [Status]
GO
IF COL_LENGTH(N'[dbo].[Coupons]', N'MinOrderAmount') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Coupons]')
          AND c.[name] = N'MinOrderAmount'
    )
ALTER TABLE [dbo].[Coupons] ADD  DEFAULT ((0)) FOR [MinOrderAmount]
GO
IF COL_LENGTH(N'[dbo].[Coupons]', N'UsedCount') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Coupons]')
          AND c.[name] = N'UsedCount'
    )
ALTER TABLE [dbo].[Coupons] ADD  DEFAULT ((0)) FOR [UsedCount]
GO
IF COL_LENGTH(N'[dbo].[Coupons]', N'IsActive') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Coupons]')
          AND c.[name] = N'IsActive'
    )
ALTER TABLE [dbo].[Coupons] ADD  DEFAULT ((1)) FOR [IsActive]
GO
IF COL_LENGTH(N'[dbo].[Coupons]', N'IsPublic') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Coupons]')
          AND c.[name] = N'IsPublic'
    )
ALTER TABLE [dbo].[Coupons] ADD  DEFAULT ((1)) FOR [IsPublic]
GO
IF COL_LENGTH(N'[dbo].[Coupons]', N'DisplayOrder') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Coupons]')
          AND c.[name] = N'DisplayOrder'
    )
ALTER TABLE [dbo].[Coupons] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
IF COL_LENGTH(N'[dbo].[Coupons]', N'CreatedAt') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Coupons]')
          AND c.[name] = N'CreatedAt'
    )
ALTER TABLE [dbo].[Coupons] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'DF__Orders__PaymentM__607251E5' AND [type] = 'D')
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF__Orders__PaymentM__607251E5]  DEFAULT (N'COD') FOR [PaymentMethod]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'DF__Orders__PaymentS__6166761E' AND [type] = 'D')
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF__Orders__PaymentS__6166761E]  DEFAULT (N'Unpaid') FOR [PaymentStatus]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'DF__Orders__OrderSta__625A9A57' AND [type] = 'D')
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF__Orders__OrderSta__625A9A57]  DEFAULT (N'Pending') FOR [OrderStatus]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'DF__Orders__DiscountAmount' AND [type] = 'D')
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF__Orders__DiscountAmount]  DEFAULT ((0)) FOR [DiscountAmount]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'DF__Orders__CreatedA__634EBE90' AND [type] = 'D')
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF__Orders__CreatedA__634EBE90]  DEFAULT (getdate()) FOR [CreatedAt]
GO
IF COL_LENGTH(N'[dbo].[ProductImages]', N'IsMain') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[ProductImages]')
          AND c.[name] = N'IsMain'
    )
ALTER TABLE [dbo].[ProductImages] ADD  DEFAULT ((0)) FOR [IsMain]
GO
IF COL_LENGTH(N'[dbo].[Products]', N'StockQuantity') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Products]')
          AND c.[name] = N'StockQuantity'
    )
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [StockQuantity]
GO
IF COL_LENGTH(N'[dbo].[Products]', N'IsFeatured') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Products]')
          AND c.[name] = N'IsFeatured'
    )
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [IsFeatured]
GO
IF COL_LENGTH(N'[dbo].[Products]', N'IsActive') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Products]')
          AND c.[name] = N'IsActive'
    )
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((1)) FOR [IsActive]
GO
IF COL_LENGTH(N'[dbo].[Products]', N'CreatedAt') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c
            ON c.[object_id] = dc.[parent_object_id]
           AND c.[column_id] = dc.[parent_column_id]
        WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Products]')
          AND c.[name] = N'CreatedAt'
    )
ALTER TABLE [dbo].[Products] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_key_columns fkc
    WHERE fkc.[parent_object_id] = OBJECT_ID(N'[dbo].[CartItems]')
      AND fkc.[parent_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[CartItems]'), N'ProductId', 'ColumnId')
      AND fkc.[referenced_object_id] = OBJECT_ID(N'[dbo].[Products]')
      AND fkc.[referenced_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[Products]'), N'ProductId', 'ColumnId')
)
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD CONSTRAINT [FK_CartItems_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_key_columns fkc
    WHERE fkc.[parent_object_id] = OBJECT_ID(N'[dbo].[CartItems]')
      AND fkc.[parent_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[CartItems]'), N'UserId', 'ColumnId')
      AND fkc.[referenced_object_id] = OBJECT_ID(N'[dbo].[Users]')
      AND fkc.[referenced_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[Users]'), N'Id', 'ColumnId')
)
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD CONSTRAINT [FK_CartItems_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'FK__OrderItem__Order__690797E6' AND [type] = 'F')
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD  CONSTRAINT [FK__OrderItem__Order__690797E6] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([OrderId])
GO
ALTER TABLE [dbo].[OrderItems] CHECK CONSTRAINT [FK__OrderItem__Order__690797E6]
GO
IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_key_columns fkc
    WHERE fkc.[parent_object_id] = OBJECT_ID(N'[dbo].[OrderItems]')
      AND fkc.[parent_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[OrderItems]'), N'ProductId', 'ColumnId')
      AND fkc.[referenced_object_id] = OBJECT_ID(N'[dbo].[Products]')
      AND fkc.[referenced_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[Products]'), N'ProductId', 'ColumnId')
)
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD CONSTRAINT [FK_OrderItems_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'FK__Orders__UserId__6442E2C9' AND [type] = 'F')
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK__Orders__UserId__6442E2C9] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK__Orders__UserId__6442E2C9]
GO
IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_key_columns fkc
    WHERE fkc.[parent_object_id] = OBJECT_ID(N'[dbo].[ProductImages]')
      AND fkc.[parent_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[ProductImages]'), N'ProductId', 'ColumnId')
      AND fkc.[referenced_object_id] = OBJECT_ID(N'[dbo].[Products]')
      AND fkc.[referenced_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[Products]'), N'ProductId', 'ColumnId')
)
ALTER TABLE [dbo].[ProductImages]  WITH CHECK ADD CONSTRAINT [FK_ProductImages_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_key_columns fkc
    WHERE fkc.[parent_object_id] = OBJECT_ID(N'[dbo].[Products]')
      AND fkc.[parent_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[Products]'), N'CategoryId', 'ColumnId')
      AND fkc.[referenced_object_id] = OBJECT_ID(N'[dbo].[Categories]')
      AND fkc.[referenced_column_id] = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[Categories]'), N'CategoryId', 'ColumnId')
)
ALTER TABLE [dbo].[Products]  WITH CHECK ADD CONSTRAINT [FK_Products_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([CategoryId])
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK_CartItems_Quantity_Positive' AND [type] = 'C')
ALTER TABLE [dbo].[CartItems]  WITH CHECK ADD CONSTRAINT [CK_CartItems_Quantity_Positive] CHECK  (([Quantity]>(0)))
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK_OrderItems_Quantity_Positive' AND [type] = 'C')
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD CONSTRAINT [CK_OrderItems_Quantity_Positive] CHECK  (([Quantity]>(0)))
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK_OrderItems_UnitPrice_NonNegative' AND [type] = 'C')
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD CONSTRAINT [CK_OrderItems_UnitPrice_NonNegative] CHECK  (([UnitPrice]>=(0)))
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Orders__TotalAmo__5F7E2DAC' AND [type] = 'C')
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CK__Orders__TotalAmo__5F7E2DAC] CHECK  (([TotalAmount]>=(0)))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CK__Orders__TotalAmo__5F7E2DAC]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Orders__DiscountAmount' AND [type] = 'C')
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CK__Orders__DiscountAmount] CHECK  (([DiscountAmount]>=(0)))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CK__Orders__DiscountAmount]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Coupons__DiscountType' AND [type] = 'C')
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD  CONSTRAINT [CK__Coupons__DiscountType] CHECK  (([DiscountType]=N'Percent' OR [DiscountType]=N'Fixed'))
GO
ALTER TABLE [dbo].[Coupons] CHECK CONSTRAINT [CK__Coupons__DiscountType]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Coupons__DiscountValue' AND [type] = 'C')
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD  CONSTRAINT [CK__Coupons__DiscountValue] CHECK  (([DiscountValue]>(0)))
GO
ALTER TABLE [dbo].[Coupons] CHECK CONSTRAINT [CK__Coupons__DiscountValue]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Coupons__MinOrder' AND [type] = 'C')
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD  CONSTRAINT [CK__Coupons__MinOrder] CHECK  (([MinOrderAmount]>=(0)))
GO
ALTER TABLE [dbo].[Coupons] CHECK CONSTRAINT [CK__Coupons__MinOrder]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Coupons__MaxDiscount' AND [type] = 'C')
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD  CONSTRAINT [CK__Coupons__MaxDiscount] CHECK  (([MaxDiscountAmount] IS NULL OR [MaxDiscountAmount]>=(0)))
GO
ALTER TABLE [dbo].[Coupons] CHECK CONSTRAINT [CK__Coupons__MaxDiscount]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Coupons__DateRange' AND [type] = 'C')
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD  CONSTRAINT [CK__Coupons__DateRange] CHECK  (([EndAt]>=[StartAt]))
GO
ALTER TABLE [dbo].[Coupons] CHECK CONSTRAINT [CK__Coupons__DateRange]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Coupons__UsageLimit' AND [type] = 'C')
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD  CONSTRAINT [CK__Coupons__UsageLimit] CHECK  (([UsageLimit] IS NULL OR [UsageLimit]>(0)))
GO
ALTER TABLE [dbo].[Coupons] CHECK CONSTRAINT [CK__Coupons__UsageLimit]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Coupons__UsedCount' AND [type] = 'C')
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD  CONSTRAINT [CK__Coupons__UsedCount] CHECK  (([UsedCount]>=(0)))
GO
ALTER TABLE [dbo].[Coupons] CHECK CONSTRAINT [CK__Coupons__UsedCount]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK__Coupons__DisplayOrder' AND [type] = 'C')
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD  CONSTRAINT [CK__Coupons__DisplayOrder] CHECK  (([DisplayOrder]>=(0)))
GO
ALTER TABLE [dbo].[Coupons] CHECK CONSTRAINT [CK__Coupons__DisplayOrder]
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK_Products_Price_NonNegative' AND [type] = 'C')
ALTER TABLE [dbo].[Products]  WITH CHECK ADD CONSTRAINT [CK_Products_Price_NonNegative] CHECK  (([Price]>=(0)))
GO
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE [name] = N'CK_Products_StockQuantity_NonNegative' AND [type] = 'C')
ALTER TABLE [dbo].[Products]  WITH CHECK ADD CONSTRAINT [CK_Products_StockQuantity_NonNegative] CHECK  (([StockQuantity]>=(0)))
GO

/* =============================================
   UPGRADE (DB đang chạy): Coupon feature
   Chạy đoạn này nếu DB cũ chưa có bảng Coupons
   ============================================= */
IF OBJECT_ID(N'[dbo].[Coupons]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Coupons](
        [CouponId] [int] IDENTITY(1,1) NOT NULL,
        [Code] [nvarchar](50) NOT NULL,
        [Name] [nvarchar](150) NOT NULL,
        [Description] [nvarchar](255) NULL,
        [DiscountType] [nvarchar](20) NOT NULL,
        [DiscountValue] [decimal](18, 2) NOT NULL,
        [MinOrderAmount] [decimal](18, 2) NOT NULL CONSTRAINT [DF_Coupons_MinOrderAmount_Upgrade] DEFAULT ((0)),
        [MaxDiscountAmount] [decimal](18, 2) NULL,
        [StartAt] [datetime] NOT NULL,
        [EndAt] [datetime] NOT NULL,
        [UsageLimit] [int] NULL,
        [UsedCount] [int] NOT NULL CONSTRAINT [DF_Coupons_UsedCount_Upgrade] DEFAULT ((0)),
        [IsActive] [bit] NOT NULL CONSTRAINT [DF_Coupons_IsActive_Upgrade] DEFAULT ((1)),
        [IsPublic] [bit] NOT NULL CONSTRAINT [DF_Coupons_IsPublic_Upgrade] DEFAULT ((1)),
        [DisplayOrder] [int] NOT NULL CONSTRAINT [DF_Coupons_DisplayOrder_Upgrade] DEFAULT ((0)),
        [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_Coupons_CreatedAt_Upgrade] DEFAULT (getdate()),
        CONSTRAINT [PK_Coupons_Upgrade] PRIMARY KEY CLUSTERED ([CouponId] ASC),
        CONSTRAINT [CK_Coupons_DiscountType_Upgrade] CHECK ([DiscountType] IN (N'Percent', N'Fixed')),
        CONSTRAINT [CK_Coupons_DiscountValue_Upgrade] CHECK ([DiscountValue] > 0),
        CONSTRAINT [CK_Coupons_MinOrder_Upgrade] CHECK ([MinOrderAmount] >= 0),
        CONSTRAINT [CK_Coupons_MaxDiscount_Upgrade] CHECK ([MaxDiscountAmount] IS NULL OR [MaxDiscountAmount] >= 0),
        CONSTRAINT [CK_Coupons_DateRange_Upgrade] CHECK ([EndAt] >= [StartAt]),
        CONSTRAINT [CK_Coupons_UsageLimit_Upgrade] CHECK ([UsageLimit] IS NULL OR [UsageLimit] > 0),
        CONSTRAINT [CK_Coupons_UsedCount_Upgrade] CHECK ([UsedCount] >= 0),
        CONSTRAINT [CK_Coupons_DisplayOrder_Upgrade] CHECK ([DisplayOrder] >= 0)
    );

    CREATE UNIQUE NONCLUSTERED INDEX [UX_Coupons_Code]
        ON [dbo].[Coupons]([Code] ASC);
END
GO

/* =============================================
   UPGRADE: Bill và BillDetails
   Sinh bill khi người dùng đặt hàng thành công
   ============================================= */
IF OBJECT_ID(N'[dbo].[Bill]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Bill](
        [BillId] [int] IDENTITY(1,1) NOT NULL,
        [OrderId] [int] NOT NULL,
        [UserId] [nvarchar](450) NOT NULL,
        [BillCode] [nvarchar](50) NOT NULL,
        [ReceiverName] [nvarchar](100) NOT NULL,
        [Phone] [nvarchar](20) NOT NULL,
        [ShippingAddress] [nvarchar](255) NOT NULL,
        [SubtotalAmount] [decimal](18, 2) NOT NULL,
        [DiscountAmount] [decimal](18, 2) NOT NULL CONSTRAINT [DF_Bill_DiscountAmount_Upgrade] DEFAULT ((0)),
        [TotalAmount] [decimal](18, 2) NOT NULL,
        [PaymentMethod] [nvarchar](50) NOT NULL,
        [PaymentStatus] [nvarchar](50) NOT NULL,
        [BillStatus] [nvarchar](50) NOT NULL CONSTRAINT [DF_Bill_BillStatus_Upgrade] DEFAULT (N'Issued'),
        [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_Bill_CreatedAt_Upgrade] DEFAULT (getdate()),
        [PaidAt] [datetime] NULL,
        CONSTRAINT [PK_Bill_Upgrade] PRIMARY KEY CLUSTERED ([BillId] ASC)
    );
END
GO

IF OBJECT_ID(N'[dbo].[BillDetails]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[BillDetails](
        [BillDetailId] [int] IDENTITY(1,1) NOT NULL,
        [BillId] [int] NOT NULL,
        [ProductId] [int] NOT NULL,
        [ProductName] [nvarchar](150) NOT NULL,
        [Quantity] [int] NOT NULL,
        [UnitPrice] [decimal](18, 2) NOT NULL,
        [SubTotal] [decimal](18, 2) NOT NULL,
        CONSTRAINT [PK_BillDetails_Upgrade] PRIMARY KEY CLUSTERED ([BillDetailId] ASC)
    );
END
GO

IF OBJECT_ID(N'[dbo].[Bill]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM sys.indexes
        WHERE [name] = N'UX_Bill_OrderId'
          AND [object_id] = OBJECT_ID(N'[dbo].[Bill]')
    )
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UX_Bill_OrderId]
        ON [dbo].[Bill]([OrderId] ASC);
END
GO

IF OBJECT_ID(N'[dbo].[Bill]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM sys.indexes
        WHERE [name] = N'UX_Bill_BillCode'
          AND [object_id] = OBJECT_ID(N'[dbo].[Bill]')
    )
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UX_Bill_BillCode]
        ON [dbo].[Bill]([BillCode] ASC);
END
GO

IF OBJECT_ID(N'[dbo].[BillDetails]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM sys.indexes
        WHERE [name] = N'IX_BillDetails_BillId'
          AND [object_id] = OBJECT_ID(N'[dbo].[BillDetails]')
    )
BEGIN
    CREATE NONCLUSTERED INDEX [IX_BillDetails_BillId]
        ON [dbo].[BillDetails]([BillId] ASC);
END
GO

IF OBJECT_ID(N'[dbo].[BillDetails]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM sys.indexes
        WHERE [name] = N'IX_BillDetails_ProductId'
          AND [object_id] = OBJECT_ID(N'[dbo].[BillDetails]')
    )
BEGIN
    CREATE NONCLUSTERED INDEX [IX_BillDetails_ProductId]
        ON [dbo].[BillDetails]([ProductId] ASC);
END
GO

IF OBJECT_ID(N'[dbo].[Bill]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys
        WHERE [name] = N'FK_Bill_Orders'
          AND [parent_object_id] = OBJECT_ID(N'[dbo].[Bill]')
    )
BEGIN
    ALTER TABLE [dbo].[Bill] WITH CHECK ADD CONSTRAINT [FK_Bill_Orders]
        FOREIGN KEY([OrderId]) REFERENCES [dbo].[Orders] ([OrderId]) ON DELETE CASCADE;
END
GO

IF OBJECT_ID(N'[dbo].[BillDetails]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[Bill]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys
        WHERE [name] = N'FK_BillDetails_Bill'
          AND [parent_object_id] = OBJECT_ID(N'[dbo].[BillDetails]')
    )
BEGIN
    ALTER TABLE [dbo].[BillDetails] WITH CHECK ADD CONSTRAINT [FK_BillDetails_Bill]
        FOREIGN KEY([BillId]) REFERENCES [dbo].[Bill] ([BillId]) ON DELETE CASCADE;
END
GO

IF OBJECT_ID(N'[dbo].[BillDetails]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[Products]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys
        WHERE [name] = N'FK_BillDetails_Products'
          AND [parent_object_id] = OBJECT_ID(N'[dbo].[BillDetails]')
    )
BEGIN
    ALTER TABLE [dbo].[BillDetails] WITH CHECK ADD CONSTRAINT [FK_BillDetails_Products]
        FOREIGN KEY([ProductId]) REFERENCES [dbo].[Products] ([ProductId]);
END
GO

/* ============================================================
   Address book, product reviews, payment cleanup upgrade
   ============================================================ */

IF OBJECT_ID(N'[dbo].[PaymentTransactions]', N'U') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[PaymentTransactions];
END
GO

/* ============================================================
   Update product image URLs to better match seeded products.
   Execute this after product seed data so old placeholder URLs
   in Products and ProductImages are replaced consistently.
   ============================================================ */

IF OBJECT_ID(N'[dbo].[UpdateProductImageUrls]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[UpdateProductImageUrls];
GO

CREATE PROCEDURE [dbo].[UpdateProductImageUrls]
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ProductImageMap TABLE
        (
            ProductId INT NOT NULL PRIMARY KEY,
            MainImageUrl NVARCHAR(255) NOT NULL,
            GalleryImageUrl1 NVARCHAR(255) NOT NULL,
            GalleryImageUrl2 NVARCHAR(255) NOT NULL
        );

        INSERT INTO @ProductImageMap
            (ProductId, MainImageUrl, GalleryImageUrl1, GalleryImageUrl2)
        VALUES
            (1,
                N'https://loremflickr.com/800/800/egg,tart,pastry?lock=101',
                N'https://loremflickr.com/800/800/thai,dessert,pastry?lock=102',
                N'https://loremflickr.com/800/800/cake,pastry,bakery?lock=103'),
            (2,
                N'https://loremflickr.com/800/800/spicy,squid,snack?lock=201',
                N'https://loremflickr.com/800/800/seafood,snack?lock=202',
                N'https://loremflickr.com/800/800/chips,spicy,snack?lock=203'),
            (3,
                N'https://loremflickr.com/800/800/milk,tea,bottle?lock=301',
                N'https://loremflickr.com/800/800/bubble,tea,drink?lock=302',
                N'https://loremflickr.com/800/800/bottled,drink,tea?lock=303'),
            (4,
                N'https://loremflickr.com/800/800/snack,assortment?lock=401',
                N'https://loremflickr.com/800/800/snacks,table?lock=402',
                N'https://loremflickr.com/800/800/chips,candy,snack?lock=403'),
            (5,
                N'https://loremflickr.com/800/800/butter,cookies?lock=501',
                N'https://loremflickr.com/800/800/cookies,bakery?lock=502',
                N'https://loremflickr.com/800/800/biscuits,cookies?lock=503'),
            (6,
                N'https://loremflickr.com/800/800/chocolate,cookies?lock=601',
                N'https://loremflickr.com/800/800/chocolate,biscuit?lock=602',
                N'https://loremflickr.com/800/800/bear,cookies,chocolate?lock=603'),
            (7,
                N'https://loremflickr.com/800/800/waffle,honey?lock=701',
                N'https://loremflickr.com/800/800/waffles,dessert?lock=702',
                N'https://loremflickr.com/800/800/honey,waffle,bakery?lock=703'),
            (8,
                N'https://loremflickr.com/800/800/cream,roll,cake?lock=801',
                N'https://loremflickr.com/800/800/wafer,roll,cream?lock=802',
                N'https://loremflickr.com/800/800/milk,cream,dessert?lock=803'),
            (9,
                N'https://loremflickr.com/800/800/potato,chips,bbq?lock=901',
                N'https://loremflickr.com/800/800/spicy,potato,chips?lock=902',
                N'https://loremflickr.com/800/800/bbq,chips,snack?lock=903'),
            (10,
                N'https://loremflickr.com/800/800/shrimp,chips,snack?lock=1001',
                N'https://loremflickr.com/800/800/spicy,shrimp,snack?lock=1002',
                N'https://loremflickr.com/800/800/prawn,cracker?lock=1003'),
            (11,
                N'https://loremflickr.com/800/800/seaweed,nuts,snack?lock=1101',
                N'https://loremflickr.com/800/800/seaweed,snack?lock=1102',
                N'https://loremflickr.com/800/800/nuts,healthy,snack?lock=1103'),
            (12,
                N'https://loremflickr.com/800/800/dried,seaweed?lock=1201',
                N'https://loremflickr.com/800/800/seaweed,crispy?lock=1202',
                N'https://loremflickr.com/800/800/seaweed,food?lock=1203'),
            (13,
                N'https://loremflickr.com/800/800/gummy,candy,fruit?lock=1301',
                N'https://loremflickr.com/800/800/colorful,candy?lock=1302',
                N'https://loremflickr.com/800/800/fruit,jelly,candy?lock=1303'),
            (14,
                N'https://loremflickr.com/800/800/chocolate,almond?lock=1401',
                N'https://loremflickr.com/800/800/almonds,chocolate?lock=1402',
                N'https://loremflickr.com/800/800/chocolate,nuts?lock=1403'),
            (15,
                N'https://loremflickr.com/800/800/cup,noodles,cheese?lock=1501',
                N'https://loremflickr.com/800/800/instant,noodles,cup?lock=1502',
                N'https://loremflickr.com/800/800/spicy,noodles?lock=1503'),
            (16,
                N'https://loremflickr.com/800/800/instant,noodles,beef?lock=1601',
                N'https://loremflickr.com/800/800/spicy,beef,noodles?lock=1602',
                N'https://loremflickr.com/800/800/ramen,packet?lock=1603'),
            (17,
                N'https://loremflickr.com/800/800/dried,chicken,snack?lock=1701',
                N'https://loremflickr.com/800/800/chicken,jerky?lock=1702',
                N'https://loremflickr.com/800/800/lime,chicken,snack?lock=1703'),
            (18,
                N'https://loremflickr.com/800/800/beef,jerky,spicy?lock=1801',
                N'https://loremflickr.com/800/800/dried,beef,snack?lock=1802',
                N'https://loremflickr.com/800/800/spicy,beef,snack?lock=1803'),
            (19,
                N'https://loremflickr.com/800/800/chicken,feet,spicy?lock=1901',
                N'https://loremflickr.com/800/800/spicy,chicken,snack?lock=1902',
                N'https://loremflickr.com/800/800/chicken,sauce,food?lock=1903'),
            (20,
                N'https://loremflickr.com/800/800/cashew,nuts?lock=2001',
                N'https://loremflickr.com/800/800/roasted,cashew?lock=2002',
                N'https://loremflickr.com/800/800/salted,nuts?lock=2003'),
            (21,
                N'https://loremflickr.com/800/800/almonds,nuts?lock=2101',
                N'https://loremflickr.com/800/800/roasted,almonds?lock=2102',
                N'https://loremflickr.com/800/800/butter,almonds?lock=2103'),
            (22,
                N'https://loremflickr.com/800/800/canned,coffee?lock=2201',
                N'https://loremflickr.com/800/800/iced,coffee,milk?lock=2202',
                N'https://loremflickr.com/800/800/coffee,can,drink?lock=2203'),
            (23,
                N'https://loremflickr.com/800/800/peach,tea,bottle?lock=2301',
                N'https://loremflickr.com/800/800/iced,peach,tea?lock=2302',
                N'https://loremflickr.com/800/800/bottled,tea,peach?lock=2303'),
            (24,
                N'https://loremflickr.com/800/800/strawberry,milk,bottle?lock=2401',
                N'https://loremflickr.com/800/800/strawberry,drink?lock=2402',
                N'https://loremflickr.com/800/800/milk,bottle,drink?lock=2403'),
            (25,
                N'https://loremflickr.com/800/800/grape,juice,bottle?lock=2501',
                N'https://loremflickr.com/800/800/grapes,drink?lock=2502',
                N'https://loremflickr.com/800/800/fruit,juice,bottle?lock=2503'),
            (26,
                N'https://loremflickr.com/800/800/biscuit,sticks,milk?lock=2601',
                N'https://loremflickr.com/800/800/wafer,sticks?lock=2602',
                N'https://loremflickr.com/800/800/thai,snack,biscuit?lock=2603'),
            (27,
                N'https://loremflickr.com/800/800/milk,candy?lock=2701',
                N'https://loremflickr.com/800/800/thai,candy?lock=2702',
                N'https://loremflickr.com/800/800/soft,candy,milk?lock=2703'),
            (28,
                N'https://loremflickr.com/800/800/snack,box?lock=2801',
                N'https://loremflickr.com/800/800/snack,combo?lock=2802',
                N'https://loremflickr.com/800/800/chips,candy,box?lock=2803'),
            (29,
                N'https://loremflickr.com/800/800/study,snacks?lock=2901',
                N'https://loremflickr.com/800/800/snacks,desk?lock=2902',
                N'https://loremflickr.com/800/800/cookies,drink,desk?lock=2903'),
            (30,
                N'https://loremflickr.com/800/800/spicy,snacks?lock=3001',
                N'https://loremflickr.com/800/800/hot,chips,snack?lock=3002',
                N'https://loremflickr.com/800/800/spicy,snack,assortment?lock=3003');

        UPDATE p
        SET p.[ImageUrl] = m.[MainImageUrl]
        FROM [dbo].[Products] AS p
        INNER JOIN @ProductImageMap AS m ON m.[ProductId] = p.[ProductId];

        IF OBJECT_ID(N'[dbo].[ProductImages]', N'U') IS NOT NULL
        BEGIN
            DELETE pi
            FROM [dbo].[ProductImages] AS pi
            INNER JOIN @ProductImageMap AS m ON m.[ProductId] = pi.[ProductId];

            INSERT INTO [dbo].[ProductImages] ([ProductId], [ImageUrl], [IsMain])
            SELECT m.[ProductId], m.[MainImageUrl], 1
            FROM @ProductImageMap AS m
            INNER JOIN [dbo].[Products] AS p ON p.[ProductId] = m.[ProductId];

            INSERT INTO [dbo].[ProductImages] ([ProductId], [ImageUrl], [IsMain])
            SELECT m.[ProductId], m.[GalleryImageUrl1], 0
            FROM @ProductImageMap AS m
            INNER JOIN [dbo].[Products] AS p ON p.[ProductId] = m.[ProductId];

            INSERT INTO [dbo].[ProductImages] ([ProductId], [ImageUrl], [IsMain])
            SELECT m.[ProductId], m.[GalleryImageUrl2], 0
            FROM @ProductImageMap AS m
            INNER JOIN [dbo].[Products] AS p ON p.[ProductId] = m.[ProductId];
        END;

        COMMIT TRANSACTION;

        SELECT
            p.[ProductId],
            p.[ProductName],
            p.[ImageUrl] AS [MainImageUrl]
        FROM [dbo].[Products] AS p
        INNER JOIN @ProductImageMap AS m ON m.[ProductId] = p.[ProductId]
        ORDER BY p.[ProductId];
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO


IF COL_LENGTH(N'[dbo].[Orders]', N'PaymentProvider') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[Orders]
        DROP COLUMN [PaymentProvider];
END
GO

IF OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[Orders]
    SET [PaymentMethod] = CASE
        WHEN [PaymentMethod] IS NULL OR LTRIM(RTRIM([PaymentMethod])) = N'' THEN N'COD'
        WHEN LOWER(LTRIM(RTRIM([PaymentMethod]))) IN (N'bank transfer', N'banking', N'transfer') THEN N'Bank Transfer'
        WHEN LOWER(LTRIM(RTRIM([PaymentMethod]))) = N'cod' THEN N'COD'
        ELSE N'COD'
    END;

    UPDATE [dbo].[Orders]
    SET [PaymentStatus] = CASE
        WHEN [PaymentStatus] IN (N'Unpaid', N'Chưa thanh toán') THEN N'Unpaid'
        WHEN [PaymentStatus] IN (N'Pending', N'Đang chờ', N'Chờ thanh toán') THEN N'Pending'
        WHEN [PaymentStatus] IN (N'Paid', N'Đã thanh toán') THEN N'Paid'
        WHEN [PaymentStatus] IN (N'Failed', N'Thất bại', N'Thanh toán lỗi') THEN N'Failed'
        WHEN [PaymentStatus] IN (N'Refunded', N'Đã hoàn tiền') THEN N'Refunded'
        ELSE [PaymentStatus]
    END;

    UPDATE [dbo].[Orders]
    SET [OrderStatus] = CASE
        WHEN [OrderStatus] IN (N'WaitingPayment', N'Chờ thanh toán', N'Chờ xác nhận thanh toán') THEN N'WaitingPayment'
        WHEN [OrderStatus] IN (N'Pending', N'Chờ xác nhận') THEN N'Pending'
        WHEN [OrderStatus] IN (N'Confirmed', N'Đã xác nhận', N'Đang xử lý', N'Chờ giao hàng') THEN N'Confirmed'
        WHEN [OrderStatus] IN (N'Shipping', N'Shipped', N'Đang giao', N'Đang giao hàng') THEN N'Shipping'
        WHEN [OrderStatus] IN (N'Completed', N'Delivered', N'Hoàn thành', N'Đã giao') THEN N'Completed'
        WHEN [OrderStatus] IN (N'Cancelled', N'Canceled', N'Đã hủy') THEN N'Cancelled'
        ELSE [OrderStatus]
    END;
END
GO

IF OBJECT_ID(N'[dbo].[Bill]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[Bill]
    SET [PaymentMethod] = CASE
        WHEN [PaymentMethod] IS NULL OR LTRIM(RTRIM([PaymentMethod])) = N'' THEN N'COD'
        WHEN LOWER(LTRIM(RTRIM([PaymentMethod]))) IN (N'bank transfer', N'banking', N'transfer') THEN N'Bank Transfer'
        WHEN LOWER(LTRIM(RTRIM([PaymentMethod]))) = N'cod' THEN N'COD'
        ELSE N'COD'
    END;

    UPDATE [dbo].[Bill]
    SET [PaymentStatus] = CASE
        WHEN [PaymentStatus] IN (N'Unpaid', N'Chưa thanh toán') THEN N'Unpaid'
        WHEN [PaymentStatus] IN (N'Pending', N'Đang chờ', N'Chờ thanh toán') THEN N'Pending'
        WHEN [PaymentStatus] IN (N'Paid', N'Đã thanh toán') THEN N'Paid'
        WHEN [PaymentStatus] IN (N'Failed', N'Thất bại', N'Thanh toán lỗi') THEN N'Failed'
        WHEN [PaymentStatus] IN (N'Refunded', N'Đã hoàn tiền') THEN N'Refunded'
        ELSE [PaymentStatus]
    END;
END
GO

IF OBJECT_ID(N'[dbo].[CustomerAddresses]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[CustomerAddresses](
        [CustomerAddressId] [int] IDENTITY(1,1) NOT NULL,
        [UserId] [nvarchar](450) NOT NULL,
        [ReceiverName] [nvarchar](100) NOT NULL,
        [Phone] [nvarchar](20) NOT NULL,
        [AddressLine] [nvarchar](255) NOT NULL,
        [Ward] [nvarchar](100) NULL,
        [District] [nvarchar](100) NULL,
        [Province] [nvarchar](100) NULL,
        [IsDefault] [bit] NOT NULL CONSTRAINT [DF_CustomerAddresses_IsDefault] DEFAULT ((0)),
        [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_CustomerAddresses_CreatedAt] DEFAULT (getdate()),
        [UpdatedAt] [datetime] NULL,
        CONSTRAINT [PK_CustomerAddresses] PRIMARY KEY CLUSTERED ([CustomerAddressId] ASC)
    );
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ProductReviews](
        [ProductReviewId] [int] IDENTITY(1,1) NOT NULL,
        [ProductId] [int] NOT NULL,
        [UserId] [nvarchar](450) NOT NULL,
        [Rating] [int] NOT NULL,
        [Comment] [nvarchar](1000) NULL,
        [IsApproved] [bit] NOT NULL CONSTRAINT [DF_ProductReviews_IsApproved] DEFAULT ((1)),
        [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_ProductReviews_CreatedAt] DEFAULT (getdate()),
        [UpdatedAt] [datetime] NULL,
        CONSTRAINT [PK_ProductReviews] PRIMARY KEY CLUSTERED ([ProductReviewId] ASC),
        CONSTRAINT [CK_ProductReviews_Rating] CHECK ([Rating] >= 1 AND [Rating] <= 5)
    );
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE [name] = N'UX_ProductReviews_Product_User' AND [object_id] = OBJECT_ID(N'[dbo].[ProductReviews]'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UX_ProductReviews_Product_User]
        ON [dbo].[ProductReviews]([ProductId] ASC, [UserId] ASC);
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE [name] = N'FK_ProductReviews_Products')
BEGIN
    ALTER TABLE [dbo].[ProductReviews] WITH CHECK ADD CONSTRAINT [FK_ProductReviews_Products]
        FOREIGN KEY([ProductId]) REFERENCES [dbo].[Products] ([ProductId]) ON DELETE CASCADE;
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE [name] = N'FK_ProductReviews_Users')
BEGIN
    ALTER TABLE [dbo].[ProductReviews] WITH CHECK ADD CONSTRAINT [FK_ProductReviews_Users]
        FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([Id]);
END
GO

GO

/* =============================================
   UPGRADE (DB đang chạy): Order status history
   ============================================= */
IF OBJECT_ID(N'[dbo].[OrderStatusHistories]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[OrderStatusHistories](
        [OrderStatusHistoryId] [int] IDENTITY(1,1) NOT NULL,
        [OrderId] [int] NOT NULL,
        [PreviousStatus] [nvarchar](50) NULL,
        [NewStatus] [nvarchar](50) NOT NULL,
        [Note] [nvarchar](500) NULL,
        [ChangedByUserId] [nvarchar](450) NULL,
        [ChangedByRole] [nvarchar](50) NULL,
        [ChangedAt] [datetime] NOT NULL
            CONSTRAINT [DF_OrderStatusHistories_ChangedAt_Upgrade] DEFAULT (getdate()),
        CONSTRAINT [PK_OrderStatusHistories_Upgrade] PRIMARY KEY CLUSTERED ([OrderStatusHistoryId] ASC)
    );
END
GO

IF OBJECT_ID(N'[dbo].[OrderStatusHistories]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys
        WHERE [name] = N'FK_OrderStatusHistories_Orders_Upgrade'
          AND [parent_object_id] = OBJECT_ID(N'[dbo].[OrderStatusHistories]')
    )
BEGIN
    ALTER TABLE [dbo].[OrderStatusHistories]  WITH CHECK ADD  CONSTRAINT [FK_OrderStatusHistories_Orders_Upgrade]
        FOREIGN KEY([OrderId])
        REFERENCES [dbo].[Orders] ([OrderId])
        ON DELETE CASCADE;

    ALTER TABLE [dbo].[OrderStatusHistories] CHECK CONSTRAINT [FK_OrderStatusHistories_Orders_Upgrade];
END
GO

IF OBJECT_ID(N'[dbo].[OrderStatusHistories]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE [name] = N'IX_OrderStatusHistories_OrderId_ChangedAt_Upgrade'
          AND [object_id] = OBJECT_ID(N'[dbo].[OrderStatusHistories]')
    )
BEGIN
    CREATE NONCLUSTERED INDEX [IX_OrderStatusHistories_OrderId_ChangedAt_Upgrade]
        ON [dbo].[OrderStatusHistories]([OrderId] ASC, [ChangedAt] DESC);
END
GO

IF OBJECT_ID(N'[dbo].[OrderStatusHistories]', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[OrderStatusHistories]
        ([OrderId], [PreviousStatus], [NewStatus], [Note], [ChangedByUserId], [ChangedByRole], [ChangedAt])
    SELECT
        o.[OrderId],
        NULL,
        o.[OrderStatus],
        N'Tạo dữ liệu lịch sử ban đầu',
        o.[UserId],
        N'System',
        o.[CreatedAt]
    FROM [dbo].[Orders] o
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[OrderStatusHistories] h
        WHERE h.[OrderId] = o.[OrderId]
    );
END
GO

IF COL_LENGTH(N'[dbo].[Orders]', N'DiscountAmount') IS NULL
BEGIN
    ALTER TABLE [dbo].[Orders]
        ADD [DiscountAmount] [decimal](18, 2) NOT NULL
            CONSTRAINT [DF_Orders_DiscountAmount_Upgrade] DEFAULT ((0));
END
GO

IF COL_LENGTH(N'[dbo].[Coupons]', N'IsPublic') IS NULL
BEGIN
    ALTER TABLE [dbo].[Coupons]
        ADD [IsPublic] [bit] NOT NULL
            CONSTRAINT [DF_Coupons_IsPublic_Upgrade_Add] DEFAULT ((1));
END
GO

IF COL_LENGTH(N'[dbo].[Coupons]', N'DisplayOrder') IS NULL
BEGIN
    ALTER TABLE [dbo].[Coupons]
        ADD [DisplayOrder] [int] NOT NULL
            CONSTRAINT [DF_Coupons_DisplayOrder_Upgrade_Add] DEFAULT ((0));
END
GO

IF OBJECT_ID(N'[dbo].[Coupons]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE [name] = N'UX_Coupons_Code'
          AND [object_id] = OBJECT_ID(N'[dbo].[Coupons]')
    )
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UX_Coupons_Code]
        ON [dbo].[Coupons]([Code] ASC);
END
GO

IF OBJECT_ID(N'[dbo].[Coupons]', N'U') IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM sys.check_constraints
        WHERE [name] = N'CK_Coupons_DisplayOrder_Upgrade_Add'
          AND [parent_object_id] = OBJECT_ID(N'[dbo].[Coupons]')
    )
BEGIN
    ALTER TABLE [dbo].[Coupons]
        WITH CHECK ADD CONSTRAINT [CK_Coupons_DisplayOrder_Upgrade_Add]
        CHECK ([DisplayOrder] >= 0);
END
GO

IF COL_LENGTH(N'[dbo].[Orders]', N'CouponCode') IS NULL
BEGIN
    ALTER TABLE [dbo].[Orders]
        ADD [CouponCode] [nvarchar](50) NULL;
END
GO

/* =============================================
   UPGRADE: canonical order/payment statuses
   ============================================= */
DECLARE @constraintName sysname;
DECLARE @sql NVARCHAR(MAX); -- Khai báo thêm biến chứa chuỗi lệnh
IF OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL
BEGIN
    SELECT @constraintName = dc.[name]
    FROM sys.default_constraints dc
    INNER JOIN sys.columns c
        ON c.[object_id] = dc.[parent_object_id]
        AND c.[column_id] = dc.[parent_column_id]
    WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Orders]')
      AND c.[name] = N'PaymentStatus';

    IF @constraintName IS NOT NULL
    BEGIN
        SET @sql = N'ALTER TABLE [dbo].[Orders] DROP CONSTRAINT ' + QUOTENAME(@constraintName);
        EXEC(@sql);
    END

    IF NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints
        WHERE [name] = N'DF_Orders_PaymentStatus_Canonical'
          AND [parent_object_id] = OBJECT_ID(N'[dbo].[Orders]')
    )
    BEGIN
        ALTER TABLE [dbo].[Orders]
            ADD CONSTRAINT [DF_Orders_PaymentStatus_Canonical] DEFAULT (N'Unpaid') FOR [PaymentStatus];
    END
END
GO

DECLARE @constraintName sysname;
DECLARE @sql NVARCHAR(MAX); -- Khai báo thêm biến chứa chuỗi lệnh
IF OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL
BEGIN
    SELECT @constraintName = dc.[name]
    FROM sys.default_constraints dc
    INNER JOIN sys.columns c
        ON c.[object_id] = dc.[parent_object_id]
        AND c.[column_id] = dc.[parent_column_id]
    WHERE dc.[parent_object_id] = OBJECT_ID(N'[dbo].[Orders]')
      AND c.[name] = N'OrderStatus';

    IF @constraintName IS NOT NULL
    BEGIN
        SET @sql = N'ALTER TABLE [dbo].[Orders] DROP CONSTRAINT ' + QUOTENAME(@constraintName);
        EXEC(@sql);
    END

    IF NOT EXISTS (
        SELECT 1
        FROM sys.default_constraints
        WHERE [name] = N'DF_Orders_OrderStatus_Canonical'
          AND [parent_object_id] = OBJECT_ID(N'[dbo].[Orders]')
    )
    BEGIN
        ALTER TABLE [dbo].[Orders]
            ADD CONSTRAINT [DF_Orders_OrderStatus_Canonical] DEFAULT (N'Pending') FOR [OrderStatus];
    END
END
GO

IF OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[Orders]
    SET [PaymentStatus] = CASE
        WHEN [PaymentStatus] IN (N'Chưa thanh toán', N'Unpaid') THEN N'Unpaid'
        WHEN [PaymentStatus] IN (N'Đang chờ', N'Chờ thanh toán', N'Pending') THEN N'Pending'
        WHEN [PaymentStatus] IN (N'Đã thanh toán', N'Paid') THEN N'Paid'
        WHEN [PaymentStatus] IN (N'Thất bại', N'Failed') THEN N'Failed'
        WHEN [PaymentStatus] IN (N'Đã hoàn tiền', N'Refunded') THEN N'Refunded'
        ELSE [PaymentStatus]
    END;

    UPDATE [dbo].[Orders]
    SET [OrderStatus] = CASE
        WHEN [OrderStatus] IN (N'Chờ thanh toán', N'Chờ xác nhận thanh toán', N'WaitingPayment') THEN N'WaitingPayment'
        WHEN [OrderStatus] IN (N'Chờ xác nhận', N'Pending') THEN N'Pending'
        WHEN [OrderStatus] IN (N'Đã xác nhận', N'Đang xử lý', N'Chờ giao hàng', N'Confirmed') THEN N'Confirmed'
        WHEN [OrderStatus] IN (N'Đang giao', N'Đang giao hàng', N'Shipping') THEN N'Shipping'
        WHEN [OrderStatus] IN (N'Đã giao', N'Hoàn tất', N'Hoàn thành', N'Completed') THEN N'Completed'
        WHEN [OrderStatus] IN (N'Đã huỷ', N'Đã hủy', N'Cancelled', N'Canceled') THEN N'Cancelled'
        ELSE [OrderStatus]
    END;
END
GO

IF OBJECT_ID(N'[dbo].[Bill]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[Bill]
    SET [PaymentStatus] = CASE
        WHEN [PaymentStatus] IN (N'Chưa thanh toán', N'Unpaid') THEN N'Unpaid'
        WHEN [PaymentStatus] IN (N'Đang chờ', N'Chờ thanh toán', N'Pending') THEN N'Pending'
        WHEN [PaymentStatus] IN (N'Đã thanh toán', N'Paid') THEN N'Paid'
        WHEN [PaymentStatus] IN (N'Thất bại', N'Failed') THEN N'Failed'
        WHEN [PaymentStatus] IN (N'Đã hoàn tiền', N'Refunded') THEN N'Refunded'
        ELSE [PaymentStatus]
    END,
    [BillStatus] = CASE
        WHEN [BillStatus] IN (N'Chờ thanh toán', N'Chờ xác nhận thanh toán', N'WaitingPayment') THEN N'WaitingPayment'
        WHEN [BillStatus] IN (N'Chờ xác nhận', N'Pending') THEN N'Pending'
        WHEN [BillStatus] IN (N'Đã xác nhận', N'Đang xử lý', N'Chờ giao hàng', N'Confirmed') THEN N'Confirmed'
        WHEN [BillStatus] IN (N'Đang giao', N'Đang giao hàng', N'Shipping') THEN N'Shipping'
        WHEN [BillStatus] IN (N'Đã giao', N'Hoàn tất', N'Hoàn thành', N'Completed') THEN N'Completed'
        WHEN [BillStatus] IN (N'Đã huỷ', N'Đã hủy', N'Cancelled', N'Canceled') THEN N'Cancelled'
        ELSE [BillStatus]
    END;
END
GO

IF OBJECT_ID(N'[dbo].[OrderStatusHistories]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[OrderStatusHistories]
    SET [PreviousStatus] = CASE
        WHEN [PreviousStatus] IN (N'Chờ thanh toán', N'Chờ xác nhận thanh toán', N'WaitingPayment') THEN N'WaitingPayment'
        WHEN [PreviousStatus] IN (N'Chờ xác nhận', N'Pending') THEN N'Pending'
        WHEN [PreviousStatus] IN (N'Đã xác nhận', N'Đang xử lý', N'Chờ giao hàng', N'Confirmed') THEN N'Confirmed'
        WHEN [PreviousStatus] IN (N'Đang giao', N'Đang giao hàng', N'Shipping') THEN N'Shipping'
        WHEN [PreviousStatus] IN (N'Đã giao', N'Hoàn tất', N'Hoàn thành', N'Completed') THEN N'Completed'
        WHEN [PreviousStatus] IN (N'Đã huỷ', N'Đã hủy', N'Cancelled', N'Canceled') THEN N'Cancelled'
        ELSE [PreviousStatus]
    END,
    [NewStatus] = CASE
        WHEN [NewStatus] IN (N'Chờ thanh toán', N'Chờ xác nhận thanh toán', N'WaitingPayment') THEN N'WaitingPayment'
        WHEN [NewStatus] IN (N'Chờ xác nhận', N'Pending') THEN N'Pending'
        WHEN [NewStatus] IN (N'Đã xác nhận', N'Đang xử lý', N'Chờ giao hàng', N'Confirmed') THEN N'Confirmed'
        WHEN [NewStatus] IN (N'Đang giao', N'Đang giao hàng', N'Shipping') THEN N'Shipping'
        WHEN [NewStatus] IN (N'Đã giao', N'Hoàn tất', N'Hoàn thành', N'Completed') THEN N'Completed'
        WHEN [NewStatus] IN (N'Đã huỷ', N'Đã hủy', N'Cancelled', N'Canceled') THEN N'Cancelled'
        ELSE [NewStatus]
    END;
END
GO

IF OBJECT_ID(N'[dbo].[Coupons]', N'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Coupons] WHERE [Code] = N'WELCOME10')
    BEGIN
        INSERT INTO [dbo].[Coupons]
            ([Code], [Name], [Description], [DiscountType], [DiscountValue], [MinOrderAmount], [MaxDiscountAmount], [StartAt], [EndAt], [UsageLimit], [UsedCount], [IsActive], [IsPublic], [DisplayOrder], [CreatedAt])
        VALUES
            (N'WELCOME10', N'Giảm 10% cho đơn đầu', N'Giảm 10% tối đa 30.000đ cho đơn từ 100.000đ', N'Percent', 10.00, 100000.00, 30000.00, '2026-01-01T00:00:00', '2027-01-01T00:00:00', 1000, 0, 1, 1, 1, GETDATE());
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Coupons] WHERE [Code] = N'SNACK30K')
    BEGIN
        INSERT INTO [dbo].[Coupons]
            ([Code], [Name], [Description], [DiscountType], [DiscountValue], [MinOrderAmount], [MaxDiscountAmount], [StartAt], [EndAt], [UsageLimit], [UsedCount], [IsActive], [IsPublic], [DisplayOrder], [CreatedAt])
        VALUES
            (N'SNACK30K', N'Giảm thẳng 30.000đ', N'Giảm trực tiếp 30.000đ cho đơn từ 200.000đ', N'Fixed', 30000.00, 200000.00, NULL, '2026-01-01T00:00:00', '2027-01-01T00:00:00', 500, 0, 1, 1, 2, GETDATE());
    END
END
GO

IF COL_LENGTH(N'[dbo].[Categories]', N'ImageUrl') IS NULL
BEGIN
    ALTER TABLE [dbo].[Categories]
        ADD [ImageUrl] [nvarchar](500) NULL;
END
GO

IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[Products]
    SET [ImageUrl] = CASE [ProductId]
        WHEN 1 THEN N'https://cdn.dummyjson.com/recipe-images/1.webp'
        WHEN 2 THEN N'https://cdn.dummyjson.com/recipe-images/2.webp'
        WHEN 3 THEN N'https://cdn.dummyjson.com/recipe-images/22.webp'
        WHEN 4 THEN N'https://cdn.dummyjson.com/recipe-images/4.webp'
        WHEN 5 THEN N'https://cdn.dummyjson.com/recipe-images/3.webp'
        WHEN 6 THEN N'https://cdn.dummyjson.com/recipe-images/6.webp'
        WHEN 7 THEN N'https://cdn.dummyjson.com/recipe-images/7.webp'
        WHEN 8 THEN N'https://cdn.dummyjson.com/recipe-images/8.webp'
        WHEN 9 THEN N'https://cdn.dummyjson.com/recipe-images/9.webp'
        WHEN 10 THEN N'https://cdn.dummyjson.com/recipe-images/10.webp'
        WHEN 11 THEN N'https://cdn.dummyjson.com/recipe-images/11.webp'
        WHEN 12 THEN N'https://cdn.dummyjson.com/recipe-images/12.webp'
        WHEN 13 THEN N'https://cdn.dummyjson.com/recipe-images/13.webp'
        WHEN 14 THEN N'https://cdn.dummyjson.com/recipe-images/14.webp'
        WHEN 15 THEN N'https://cdn.dummyjson.com/recipe-images/15.webp'
        WHEN 16 THEN N'https://cdn.dummyjson.com/recipe-images/16.webp'
        WHEN 17 THEN N'https://cdn.dummyjson.com/recipe-images/17.webp'
        WHEN 18 THEN N'https://cdn.dummyjson.com/recipe-images/18.webp'
        WHEN 19 THEN N'https://cdn.dummyjson.com/recipe-images/19.webp'
        WHEN 20 THEN N'https://cdn.dummyjson.com/recipe-images/20.webp'
        WHEN 21 THEN N'https://cdn.dummyjson.com/recipe-images/21.webp'
        WHEN 22 THEN N'https://cdn.dummyjson.com/recipe-images/25.webp'
        WHEN 23 THEN N'https://cdn.dummyjson.com/recipe-images/23.webp'
        WHEN 24 THEN N'https://cdn.dummyjson.com/recipe-images/24.webp'
        WHEN 25 THEN N'https://cdn.dummyjson.com/recipe-images/30.webp'
        WHEN 26 THEN N'https://cdn.dummyjson.com/recipe-images/26.webp'
        WHEN 27 THEN N'https://cdn.dummyjson.com/recipe-images/27.webp'
        WHEN 28 THEN N'https://cdn.dummyjson.com/recipe-images/28.webp'
        WHEN 29 THEN N'https://cdn.dummyjson.com/recipe-images/29.webp'
        WHEN 30 THEN N'https://cdn.dummyjson.com/recipe-images/5.webp'
        ELSE [ImageUrl]
    END
    WHERE [ProductId] BETWEEN 1 AND 30
      AND (
          [ImageUrl] IS NULL
          OR LTRIM(RTRIM([ImageUrl])) = N''
          OR [ImageUrl] LIKE N'img/%'
          OR [ImageUrl] LIKE N'/img/%'
          OR [ImageUrl] LIKE N'https://picsum.photos/%'
          OR [ImageUrl] LIKE N'https://dummyjson.com/image/%'
      );
END
GO

IF OBJECT_ID(N'[dbo].[Categories]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[Categories]
    SET [ImageUrl] = CASE [CategoryId]
        WHEN 1 THEN N'https://cdn.dummyjson.com/recipe-images/3.webp'
        WHEN 3 THEN N'https://cdn.dummyjson.com/recipe-images/25.webp'
        WHEN 13 THEN N'https://cdn.dummyjson.com/recipe-images/26.webp'
        WHEN 14 THEN N'https://cdn.dummyjson.com/recipe-images/1.webp'
        WHEN 15 THEN N'https://cdn.dummyjson.com/recipe-images/17.webp'
        WHEN 16 THEN N'https://cdn.dummyjson.com/recipe-images/2.webp'
        ELSE [ImageUrl]
    END
    WHERE [CategoryId] IN (1, 3, 13, 14, 15, 16)
      AND (
          [ImageUrl] IS NULL
          OR LTRIM(RTRIM([ImageUrl])) = N''
          OR [ImageUrl] LIKE N'https://picsum.photos/%'
          OR [ImageUrl] LIKE N'https://dummyjson.com/image/%'
      );
END
GO

/* ============================================================
   IMAGE URL UPDATE ONLY (Copy this block to run quickly)
   From: START_IMAGE_URL_UPDATE
   To  : END_IMAGE_URL_UPDATE
   ============================================================ */
-- START_IMAGE_URL_UPDATE
IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[Products]
    SET [ImageUrl] = CASE [ProductId]
        WHEN 1 THEN N'https://cdn.dummyjson.com/recipe-images/1.webp'
        WHEN 2 THEN N'https://cdn.dummyjson.com/recipe-images/2.webp'
        WHEN 3 THEN N'https://cdn.dummyjson.com/recipe-images/22.webp'
        WHEN 4 THEN N'https://cdn.dummyjson.com/recipe-images/4.webp'
        WHEN 5 THEN N'https://cdn.dummyjson.com/recipe-images/3.webp'
        WHEN 6 THEN N'https://cdn.dummyjson.com/recipe-images/6.webp'
        WHEN 7 THEN N'https://cdn.dummyjson.com/recipe-images/7.webp'
        WHEN 8 THEN N'https://cdn.dummyjson.com/recipe-images/8.webp'
        WHEN 9 THEN N'https://cdn.dummyjson.com/recipe-images/9.webp'
        WHEN 10 THEN N'https://cdn.dummyjson.com/recipe-images/10.webp'
        WHEN 11 THEN N'https://cdn.dummyjson.com/recipe-images/11.webp'
        WHEN 12 THEN N'https://cdn.dummyjson.com/recipe-images/12.webp'
        WHEN 13 THEN N'https://cdn.dummyjson.com/recipe-images/13.webp'
        WHEN 14 THEN N'https://cdn.dummyjson.com/recipe-images/14.webp'
        WHEN 15 THEN N'https://cdn.dummyjson.com/recipe-images/15.webp'
        WHEN 16 THEN N'https://cdn.dummyjson.com/recipe-images/16.webp'
        WHEN 17 THEN N'https://cdn.dummyjson.com/recipe-images/17.webp'
        WHEN 18 THEN N'https://cdn.dummyjson.com/recipe-images/18.webp'
        WHEN 19 THEN N'https://cdn.dummyjson.com/recipe-images/19.webp'
        WHEN 20 THEN N'https://cdn.dummyjson.com/recipe-images/20.webp'
        WHEN 21 THEN N'https://cdn.dummyjson.com/recipe-images/21.webp'
        WHEN 22 THEN N'https://cdn.dummyjson.com/recipe-images/25.webp'
        WHEN 23 THEN N'https://cdn.dummyjson.com/recipe-images/23.webp'
        WHEN 24 THEN N'https://cdn.dummyjson.com/recipe-images/24.webp'
        WHEN 25 THEN N'https://cdn.dummyjson.com/recipe-images/30.webp'
        WHEN 26 THEN N'https://cdn.dummyjson.com/recipe-images/26.webp'
        WHEN 27 THEN N'https://cdn.dummyjson.com/recipe-images/27.webp'
        WHEN 28 THEN N'https://cdn.dummyjson.com/recipe-images/28.webp'
        WHEN 29 THEN N'https://cdn.dummyjson.com/recipe-images/29.webp'
        WHEN 30 THEN N'https://cdn.dummyjson.com/recipe-images/5.webp'
        ELSE [ImageUrl]
    END
    WHERE [ProductId] BETWEEN 1 AND 30;
END
GO

IF OBJECT_ID(N'[dbo].[Categories]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[Categories]
    SET [ImageUrl] = CASE [CategoryId]
        WHEN 1 THEN N'https://cdn.dummyjson.com/recipe-images/3.webp'
        WHEN 3 THEN N'https://cdn.dummyjson.com/recipe-images/25.webp'
        WHEN 13 THEN N'https://cdn.dummyjson.com/recipe-images/26.webp'
        WHEN 14 THEN N'https://cdn.dummyjson.com/recipe-images/1.webp'
        WHEN 15 THEN N'https://cdn.dummyjson.com/recipe-images/17.webp'
        WHEN 16 THEN N'https://cdn.dummyjson.com/recipe-images/2.webp'
        ELSE [ImageUrl]
    END
    WHERE [CategoryId] IN (1, 3, 13, 14, 15, 16);
END
GO
-- END_IMAGE_URL_UPDATE

/* ============================================================
   UPGRADE: Order activity logs + Returned status
   Safe to run on an existing database; existing data is kept.
   ============================================================ */
IF OBJECT_ID(N'[dbo].[OrderActivityLogs]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[OrderActivityLogs](
        [OrderActivityLogId] [int] IDENTITY(1,1) NOT NULL,
        [OrderId] [int] NOT NULL,
        [ActivityType] [nvarchar](50) NOT NULL,
        [Title] [nvarchar](150) NOT NULL,
        [Description] [nvarchar](1000) NULL,
        [FromValue] [nvarchar](100) NULL,
        [ToValue] [nvarchar](100) NULL,
        [ActorUserId] [nvarchar](450) NULL,
        [ActorRole] [nvarchar](50) NULL,
        [CreatedAt] [datetime] NOT NULL CONSTRAINT [DF_OrderActivityLogs_CreatedAt] DEFAULT (getdate()),
        CONSTRAINT [PK_OrderActivityLogs] PRIMARY KEY CLUSTERED ([OrderActivityLogId] ASC)
    );
END
GO

IF OBJECT_ID(N'[dbo].[OrderActivityLogs]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE [name] = N'IX_OrderActivityLogs_Order_CreatedAt' AND [object_id] = OBJECT_ID(N'[dbo].[OrderActivityLogs]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_OrderActivityLogs_Order_CreatedAt]
        ON [dbo].[OrderActivityLogs]([OrderId] ASC, [CreatedAt] DESC);
END
GO

IF OBJECT_ID(N'[dbo].[OrderActivityLogs]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE [name] = N'IX_OrderActivityLogs_ActivityType' AND [object_id] = OBJECT_ID(N'[dbo].[OrderActivityLogs]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_OrderActivityLogs_ActivityType]
        ON [dbo].[OrderActivityLogs]([ActivityType] ASC);
END
GO

IF OBJECT_ID(N'[dbo].[OrderActivityLogs]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE [name] = N'FK_OrderActivityLogs_Orders')
BEGIN
    ALTER TABLE [dbo].[OrderActivityLogs] WITH CHECK ADD CONSTRAINT [FK_OrderActivityLogs_Orders]
        FOREIGN KEY([OrderId]) REFERENCES [dbo].[Orders] ([OrderId]) ON DELETE CASCADE;
END
GO

IF OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL
BEGIN
    UPDATE [dbo].[Orders]
    SET [OrderStatus] = CASE
        WHEN [OrderStatus] IN (N'ReturnRequested', N'Yêu cầu hoàn/trả') THEN N'ReturnRequested'
        WHEN [OrderStatus] IN (N'Returned', N'Đã hoàn/trả', N'Đã trả hàng') THEN N'Returned'
        ELSE [OrderStatus]
    END;
END
GO

IF OBJECT_ID(N'[dbo].[OrderActivityLogs]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[OrderStatusHistories]', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[OrderActivityLogs] (
        [OrderId], [ActivityType], [Title], [Description], [FromValue], [ToValue],
        [ActorUserId], [ActorRole], [CreatedAt]
    )
    SELECT
        h.[OrderId],
        CASE
            WHEN h.[Note] LIKE N'\[ReturnRequest]\[Open]%' ESCAPE N'\' THEN N'ReturnRequestOpened'
            WHEN h.[Note] LIKE N'\[ReturnRequest]\[Resolved]\[Approved]%' ESCAPE N'\' THEN N'ReturnRequestApproved'
            WHEN h.[Note] LIKE N'\[ReturnRequest]\[Resolved]\[Rejected]%' ESCAPE N'\' THEN N'ReturnRequestRejected'
            ELSE N'OrderStatusChanged'
        END,
        CASE
            WHEN h.[Note] LIKE N'\[ReturnRequest]\[Open]%' ESCAPE N'\' THEN N'Return/refund requested'
            WHEN h.[Note] LIKE N'\[ReturnRequest]\[Resolved]\[Approved]%' ESCAPE N'\' THEN N'Return/refund request approved'
            WHEN h.[Note] LIKE N'\[ReturnRequest]\[Resolved]\[Rejected]%' ESCAPE N'\' THEN N'Return/refund request rejected'
            ELSE N'Legacy order activity'
        END,
        LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(h.[Note],
            N'[ReturnRequest][Resolved][Approved]', N''),
            N'[ReturnRequest][Resolved][Rejected]', N''),
            N'[ReturnRequest][Open]', N''))),
        h.[PreviousStatus],
        h.[NewStatus],
        h.[ChangedByUserId],
        h.[ChangedByRole],
        h.[ChangedAt]
    FROM [dbo].[OrderStatusHistories] h
    WHERE h.[Note] LIKE N'\[ReturnRequest]%' ESCAPE N'\'
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[OrderActivityLogs] existing
          WHERE existing.[OrderId] = h.[OrderId]
            AND existing.[CreatedAt] = h.[ChangedAt]
            AND existing.[ActivityType] IN (N'ReturnRequestOpened', N'ReturnRequestApproved', N'ReturnRequestRejected')
      );
END
GO

/* ============================================================
   Product review per OrderItem upgrade
   - Keep existing review data
   - New rule: each OrderItem can be reviewed only once
   ============================================================ */

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND COL_LENGTH(N'[dbo].[ProductReviews]', N'OrderId') IS NULL
BEGIN
    ALTER TABLE [dbo].[ProductReviews] ADD [OrderId] [int] NULL;
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND COL_LENGTH(N'[dbo].[ProductReviews]', N'OrderItemId') IS NULL
BEGIN
    ALTER TABLE [dbo].[ProductReviews] ADD [OrderItemId] [int] NULL;
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[OrderItems]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL
BEGIN
    UPDATE pr
    SET
        pr.[OrderId] = matched.[OrderId],
        pr.[OrderItemId] = matched.[OrderItemId]
    FROM [dbo].[ProductReviews] pr
    CROSS APPLY (
        SELECT TOP (1)
            o.[OrderId],
            oi.[OrderItemId]
        FROM [dbo].[OrderItems] oi
        INNER JOIN [dbo].[Orders] o ON o.[OrderId] = oi.[OrderId]
        WHERE oi.[ProductId] = pr.[ProductId]
          AND o.[UserId] = pr.[UserId]
          AND o.[OrderStatus] IN (N'Completed', N'Delivered', N'Hoàn thành', N'Hoan thanh')
        ORDER BY o.[CreatedAt] DESC, oi.[OrderItemId] DESC
    ) matched
    WHERE pr.[OrderItemId] IS NULL;
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND EXISTS (SELECT 1 FROM sys.indexes WHERE [name] = N'UX_ProductReviews_Product_User' AND [object_id] = OBJECT_ID(N'[dbo].[ProductReviews]'))
BEGIN
    DROP INDEX [UX_ProductReviews_Product_User] ON [dbo].[ProductReviews];
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE [name] = N'IX_ProductReviews_ProductId' AND [object_id] = OBJECT_ID(N'[dbo].[ProductReviews]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ProductReviews_ProductId]
        ON [dbo].[ProductReviews]([ProductId] ASC);
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE [name] = N'IX_ProductReviews_UserId' AND [object_id] = OBJECT_ID(N'[dbo].[ProductReviews]'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ProductReviews_UserId]
        ON [dbo].[ProductReviews]([UserId] ASC);
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.indexes WHERE [name] = N'UX_ProductReviews_OrderItemId' AND [object_id] = OBJECT_ID(N'[dbo].[ProductReviews]'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [UX_ProductReviews_OrderItemId]
        ON [dbo].[ProductReviews]([OrderItemId] ASC)
        WHERE [OrderItemId] IS NOT NULL;
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[Orders]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE [name] = N'FK_ProductReviews_Orders')
BEGIN
    ALTER TABLE [dbo].[ProductReviews] WITH CHECK ADD CONSTRAINT [FK_ProductReviews_Orders]
        FOREIGN KEY([OrderId]) REFERENCES [dbo].[Orders] ([OrderId]);
END
GO

IF OBJECT_ID(N'[dbo].[ProductReviews]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[OrderItems]', N'U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE [name] = N'FK_ProductReviews_OrderItems')
BEGIN
    ALTER TABLE [dbo].[ProductReviews] WITH CHECK ADD CONSTRAINT [FK_ProductReviews_OrderItems]
        FOREIGN KEY([OrderItemId]) REFERENCES [dbo].[OrderItems] ([OrderItemId]);
END
GO

/* ============================================================
   Product gallery upgrade (multiple images per product)
   - Keep existing data
   - Ensure every product has main image + 2 gallery images
   ============================================================ */

IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[ProductImages]', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[ProductImages] ([ProductId], [ImageUrl], [IsMain])
    SELECT p.[ProductId], LTRIM(RTRIM(p.[ImageUrl])), 1
    FROM [dbo].[Products] p
    WHERE p.[ImageUrl] IS NOT NULL
      AND LTRIM(RTRIM(p.[ImageUrl])) <> N''
      AND NOT EXISTS (
          SELECT 1
          FROM [dbo].[ProductImages] pi
          WHERE pi.[ProductId] = p.[ProductId]
      );
END
GO

IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[ProductImages]', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[ProductImages] ([ProductId], [ImageUrl], [IsMain])
    SELECT p.[ProductId], CONCAT(N'/multishop/img/product-', ((p.[ProductId] - 1) % 8) + 1, N'.jpg'), 0
    FROM [dbo].[Products] p
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[ProductImages] pi
        WHERE pi.[ProductId] = p.[ProductId]
          AND pi.[ImageUrl] = CONCAT(N'/multishop/img/product-', ((p.[ProductId] - 1) % 8) + 1, N'.jpg')
    );
END
GO


IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[ProductImages]', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[ProductImages] ([ProductId], [ImageUrl], [IsMain])
    SELECT p.[ProductId], CONCAT(N'/multishop/img/product-', ((p.[ProductId] + 2) % 8) + 1, N'.jpg'), 0
    FROM [dbo].[Products] p
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[ProductImages] pi
        WHERE pi.[ProductId] = p.[ProductId]
          AND pi.[ImageUrl] = CONCAT(N'/multishop/img/product-', ((p.[ProductId] + 2) % 8) + 1, N'.jpg')
    );
END
GO

IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[ProductImages]', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[ProductImages] ([ProductId], [ImageUrl], [IsMain])
    SELECT p.[ProductId], CONCAT(N'https://picsum.photos/seed/prod', p.[ProductId], N'_1/500/500'), 0
    FROM [dbo].[Products] p
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[ProductImages] pi
        WHERE pi.[ProductId] = p.[ProductId]
          AND pi.[ImageUrl] = CONCAT(N'https://picsum.photos/seed/prod', p.[ProductId], N'_1/500/500')
    );
END
GO

IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NOT NULL
    AND OBJECT_ID(N'[dbo].[ProductImages]', N'U') IS NOT NULL
BEGIN
    INSERT INTO [dbo].[ProductImages] ([ProductId], [ImageUrl], [IsMain])
    SELECT p.[ProductId], CONCAT(N'https://picsum.photos/seed/prod', p.[ProductId], N'_2/500/500'), 0
    FROM [dbo].[Products] p
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[ProductImages] pi
        WHERE pi.[ProductId] = p.[ProductId]
          AND pi.[ImageUrl] = CONCAT(N'https://picsum.photos/seed/prod', p.[ProductId], N'_2/500/500')
    );
END
GO

EXEC [dbo].[UpdateProductImageUrls];
GO
