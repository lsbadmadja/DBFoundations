--*************************************************************************--
-- Title: Assignment06
-- Author: LisaBatten
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2021-11-22,LisaBatten,Created file
-- 2021-11-22,LisaBatten,Created tables
-- 2021-11-22,LisaBatten,Added constraints
-- 2021-11-22,LisaBatten,Entered data into tables
-- 2021-11-22,LisaBatten,Created a View for each Ttble
-- 2021-11-22,LisaBatten,Set permissions for public, so that they cannot select data 
-- from each table, but can select them from each view
-- 2021-11-22,LisaBatten,Created a view to show a list of Category and Product names, 
-- and the price of each product ordered by the Category and Product
-- 2021-11-22,LisaBatten,Created a view to show a list of Product names and Inventory Counts on each Inventory Date
-- ordered by the Product, Date, and Count
-- 2021-11-22,LisaBatten,Created a view to show a list of Inventory Dates and the Employee that took the count
-- ordered by the Date and returned only one row per date
-- 2021-11-22,LisaBatten,Created a view show a list of Categories, Products, and the Inventory Date 
-- and Count of each product ordered by the Category, Product, Date, and Count
-- 2021-11-22,LisaBatten,Created a view to show a list of Categories, Products, the Inventory Date and Count of each product, 
-- and the EMPLOYEE who took the count ordered by the Inventory Date, Category, Product and Employee
-- 2021-11-22,LisaBatten,Created a view to show a list of Categories, Products, the Inventory Date and Count of each product, 
-- and the Employee who took the count for the Products 'Chai' and 'Chang'
-- 2021-11-22,LisaBatten,Created a view to show a list of Employees and the Manager who manages them ordered by the Manager's name
-- 2021-11-22,LisaBatten,Created a view to show all the data from all four BASIC Views and the Employee's Manager Name 
-- ordered by Category, Product, InventoryID, and Employee
-- 2021-11-22,LisaBatten,Tested the Views
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_LisaBatten')
	 Begin 
	  Alter Database [Assignment06DB_LisaBatten] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_LisaBatten;
	 End
	Create Database Assignment06DB_LisaBatten;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_LisaBatten;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!
CREATE VIEW dbo.vCategories
WITH SCHEMABINDING
AS
    SELECT CategoryID, CategoryName
    FROM dbo.Categories
;	
GO

CREATE VIEW dbo.vProducts
WITH SCHEMABINDING
AS
    SELECT ProductID, ProductName, CategoryID, UnitPrice
    FROM dbo.Products
;	
GO

CREATE VIEW dbo.vEmployees
WITH SCHEMABINDING
AS
    SELECT EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
    FROM dbo.Employees
;	
GO

CREATE VIEW dbo.vInventories
WITH SCHEMABINDING
AS
    SELECT InventoryID, InventoryDate, EmployeeID, ProductID, Count
    FROM dbo.Inventories
;	
GO
-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?
Deny SELECT ON dbo.Categories to Public
;
Grant SELECT ON dbo.vCategories to Public
;
GO

Deny SELECT ON dbo.Products to Public
;
Grant SELECT ON dbo.vProducts to Public
;
GO

Deny SELECT ON dbo.Employees to Public
;
Grant SELECT ON dbo.vEmployees to Public
;
GO

Deny SELECT ON dbo.Inventories to Public
;
Grant SELECT ON dbo.vInventories to Public
;
GO

-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

-- Here is an example of some rows selected from the view:
-- CategoryName ProductName       UnitPrice
-- Beverages    Chai              18.00
-- Beverages    Chang             19.00
-- Beverages    Chartreuse verte  18.00
CREATE VIEW dbo.vCategoryProduct
WITH SCHEMABINDING
AS
    SELECT TOP 100000 a.CategoryName, b.ProductName, b.UnitPrice
    FROM dbo.vCategories AS a
    INNER JOIN dbo.VProducts AS b
    ON a.CategoryID = b.CategoryID
    ORDER BY a.CategoryName, b.ProductName
;
GO

-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- ProductName	  InventoryDate	Count
-- Alice Mutton	  2017-01-01	  0
-- Alice Mutton	  2017-02-01	  10
-- Alice Mutton	  2017-03-01	  20
-- Aniseed Syrup	2017-01-01	  13
-- Aniseed Syrup	2017-02-01	  23
-- Aniseed Syrup	2017-03-01	  33
CREATE VIEW dbo.vProductInventory
WITH SCHEMABINDING
AS
    SELECT TOP 100000 a.ProductName, b.InventoryDate, b.Count
    FROM dbo.vProducts AS a
    INNER JOIN dbo.VInventories AS b
    ON a.ProductID = b.ProductID
    ORDER BY a.ProductName, b.InventoryDate, b.Count
;
GO

-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth
CREATE VIEW dbo.vInventoryEmployee
WITH SCHEMABINDING
AS
    SELECT TOP 100000 a.InventoryDate, (b.EmployeeFirstName + ' ' + b.EmployeeLastName) AS EmployeeName
    FROM dbo.vInventories AS a
    INNER JOIN dbo.VEmployees AS b
    ON a.EmployeeID = b.EmployeeID
    GROUP BY a.InventoryDate, (b.EmployeeFirstName + ' ' + b.EmployeeLastName)
    ORDER BY a.InventoryDate
;
GO

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- CategoryName	ProductName	InventoryDate	Count
-- Beverages	  Chai	      2017-01-01	  39
-- Beverages	  Chai	      2017-02-01	  49
-- Beverages	  Chai	      2017-03-01	  59
-- Beverages	  Chang	      2017-01-01	  17
-- Beverages	  Chang	      2017-02-01	  27
-- Beverages	  Chang	      2017-03-01	  37
CREATE VIEW dbo.vCategoryProductInventory
WITH SCHEMABINDING
AS
    SELECT TOP 100000 a.CategoryName, b.ProductName, c.InventoryDate, c.Count
    FROM dbo.vCategories AS a
	INNER JOIN dbo.vProducts AS b
	ON a.CategoryID = b.CategoryID
	INNER JOIN dbo.vInventories AS c
    ON b.ProductID = c.ProductID
    ORDER BY a.CategoryName, b.ProductName, c.InventoryDate, c.Count
;
GO

-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

-- Here is an example of some rows selected from the view:
-- CategoryName	ProductName	        InventoryDate	Count	EmployeeName
-- Beverages	  Chai	              2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	              2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chartreuse verte	  2017-01-01	  69	  Steven Buchanan
-- Beverages	  C�te de Blaye	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Guaran� Fant�stica	2017-01-01	  20	  Steven Buchanan
-- Beverages	  Ipoh Coffee	        2017-01-01	  17	  Steven Buchanan
-- Beverages	  Lakkalik��ri	      2017-01-01	  57	  Steven Buchanan
CREATE VIEW dbo.vCategoryProductInventoryEmployee
WITH SCHEMABINDING
AS
    SELECT TOP 100000 a.CategoryName, b.ProductName, c.InventoryDate, c.Count,
	(d.EmployeeFirstName + ' ' + d.EmployeeLastName) AS EmployeeName
    FROM dbo.vCategories AS a
	INNER JOIN dbo.vProducts AS b
	ON a.CategoryID = b.CategoryID
	INNER JOIN dbo.vInventories AS c
    ON b.ProductID = c.ProductID
	INNER JOIN dbo.vEmployees AS d
	ON c.EmployeeID = d.EmployeeID
    ORDER BY c.InventoryDate, a.CategoryName, b.ProductName, (d.EmployeeFirstName + ' ' + d.EmployeeLastName)
;
GO

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

-- Here are the rows selected from the view:

-- CategoryName	ProductName	InventoryDate	Count	EmployeeName
-- Beverages	  Chai	      2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chai	      2017-02-01	  49	  Robert King
-- Beverages	  Chang	      2017-02-01	  27	  Robert King
-- Beverages	  Chai	      2017-03-01	  59	  Anne Dodsworth
-- Beverages	  Chang	      2017-03-01	  37	  Anne Dodsworth
CREATE VIEW dbo.vCatProdInventEmpChaiChang
WITH SCHEMABINDING
AS
    SELECT TOP 100000 a.CategoryName, b.ProductName, c.InventoryDate, c.Count,
	(d.EmployeeFirstName + ' ' + d.EmployeeLastName) AS EmployeeName
    FROM dbo.vCategories AS a
	INNER JOIN dbo.vProducts AS b
	ON a.CategoryID = b.CategoryID
	INNER JOIN dbo.vInventories AS c
    ON b.ProductID = c.ProductID
	INNER JOIN dbo.vEmployees AS d
	ON c.EmployeeID = d.EmployeeID
	WHERE b.ProductName = 'Chai' OR b.ProductName = 'Chang'
    ORDER BY c.InventoryDate, a.CategoryName, b.ProductName, (d.EmployeeFirstName + ' ' + d.EmployeeLastName)
;
GO

-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

-- Here are teh rows selected from the view:
-- Manager	        Employee
-- Andrew Fuller	  Andrew Fuller
-- Andrew Fuller	  Janet Leverling
-- Andrew Fuller	  Laura Callahan
-- Andrew Fuller	  Margaret Peacock
-- Andrew Fuller	  Nancy Davolio
-- Andrew Fuller	  Steven Buchanan
-- Steven Buchanan	Anne Dodsworth
-- Steven Buchanan	Michael Suyama
-- Steven Buchanan	Robert King
CREATE VIEW dbo.vManagerEmployee
WITH SCHEMABINDING
AS
    SELECT TOP 100000 (m.EmployeeFirstName + ' ' + m.EmployeeLastName) AS ManagerName,
					  (e.EmployeeFirstName + ' ' + e.EmployeeLastName) AS EmployeeName 
    FROM dbo.vEmployees AS e
	INNER JOIN dbo.vEmployees AS m
	ON e.ManagerID = m.EmployeeID
    ORDER BY (m.EmployeeFirstName + ' ' + m.EmployeeLastName), (e.EmployeeFirstName + ' ' + e.EmployeeLastName)
;
GO

-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.

-- Here is an example of some rows selected from the view:
-- CategoryID	  CategoryName	ProductID	ProductName	        UnitPrice	InventoryID	InventoryDate	Count	EmployeeID	Employee
-- 1	          Beverages	    1	        Chai	              18.00	    1	          2017-01-01	  39	  5	          Steven Buchanan
-- 1	          Beverages	    1	        Chai	              18.00	    78	        2017-02-01	  49	  7	          Robert King
-- 1	          Beverages	    1	        Chai	              18.00	    155	        2017-03-01	  59	  9	          Anne Dodsworth
-- 1	          Beverages	    2	        Chang	              19.00	    2	          2017-01-01	  17	  5	          Steven Buchanan
-- 1	          Beverages	    2	        Chang	              19.00	    79	        2017-02-01	  27	  7	          Robert King
-- 1	          Beverages	    2	        Chang	              19.00	    156	        2017-03-01	  37	  9	          Anne Dodsworth
-- 1	          Beverages	    24	      Guaran� Fant�stica	4.50	    24	        2017-01-01	  20	  5	          Steven Buchanan
-- 1	          Beverages	    24	      Guaran� Fant�stica	4.50	    101	        2017-02-01	  30	  7	          Robert King
-- 1	          Beverages	    24	      Guaran� Fant�stica	4.50	    178	        2017-03-01	  40	  9	          Anne Dodsworth
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    34	        2017-01-01	  111	  5	          Steven Buchanan
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    111	        2017-02-01	  121	  7	          Robert King
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    188	        2017-03-01	  131	  9	          Anne Dodsworth
CREATE VIEW dbo.vAllViews
WITH SCHEMABINDING
AS
    SELECT TOP 100000 a.CategoryID, 
					  a.CategoryName, 
					  b.ProductID,
					  b.ProductName, 
					  b.UnitPrice,
					  c.InventoryID,
					  c.InventoryDate, 
					  c.Count,
					  d.EmployeeID,
					  (d.EmployeeFirstName + ' ' + d.EmployeeLastName) as EmployeeName,
					  (m.EmployeeFirstName + ' ' + m.EmployeeLastName) AS ManagerName
    FROM dbo.vCategories AS a
	INNER JOIN dbo.vProducts AS b
	ON a.CategoryID = b.CategoryID
	INNER JOIN dbo.vInventories AS c
    ON b.ProductID = c.ProductID
	INNER JOIN dbo.vEmployees AS d
	ON c.EmployeeID = d.EmployeeID
	INNER JOIN dbo.vEmployees AS m
	ON d.ManagerID = m.EmployeeID
    ORDER BY a.CategoryID, a.CategoryName, b.ProductID, b.ProductName, c.InventoryID, (d.EmployeeFirstName + ' ' + d.EmployeeLastName)
;
GO

-- Test your Views (NOTE: You must change the names to match yours as needed!)
/*Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories];
Select * From [dbo].[vProducts];
Select * From [dbo].[vInventories];
Select * From [dbo].[vEmployees];

Select * From [dbo].[vCategoryProduct];
Select * From [dbo].[vProductInventory];
Select * From [dbo].[vInventoryEmployee];
Select * From [dbo].[vCategoryProductInventory];
Select * From [dbo].[vCategoryProductInventoryEmployee];
Select * From [dbo].[vCatProdInventEmpChaiChang];
Select * From [dbo].[vManagerEmployee];
Select * From [dbo].[vAllViews];*/

BEGIN TRY
	BEGIN TRAN;
        Select * From [dbo].[vCategories];
		Select * From [dbo].[vProducts];
		Select * From [dbo].[vInventories];
		Select * From [dbo].[vEmployees];
		Select * From [dbo].[vCategoryProduct];
		Select * From [dbo].[vProductInventory];
		Select * From [dbo].[vInventoryEmployee];
		Select * From [dbo].[vCategoryProductInventory];
		Select * From [dbo].[vCategoryProductInventoryEmployee];
		Select * From [dbo].[vCatProdInventEmpChaiChang];
		Select * From [dbo].[vManagerEmployee];
		Select * From [dbo].[vAllViews];
	COMMIT TRAN;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Note: You will get an error until the views are created!'
	PRINT Error_Message();
END CATCH;
GO
/***************************************************************************************/