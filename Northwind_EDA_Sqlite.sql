-- Exploratory data analysis

-- Top 10 customers with most quantity of orders made
SELECT Customers.CustomerID, CustomerName, Country, COUNT(Orders.OrderID) AS TotalOrders FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Orders.CustomerID
ORDER BY TotalOrders DESC
LIMIT 10

-- Top 10 customers who spend the most

-- First, creating a CTE with the total for each Order made by joining tables OrderDetails and
-- Products
WITH TotalPaidByOrder AS (
SELECT OrderDetails.OrderDetailID, OrderDetails.OrderID, sum((Quantity*Price)) as TotalPaid FROM OrderDetails
INNER JOIN Products on OrderDetails.ProductID = Products.ProductID
GROUP BY OrderDetails.OrderID)

-- Second, joining the CTE with tables Orders and Customers for getting the total
-- paid by customer
SELECT Orders.CustomerID, Customers.CustomerName, Country, sum(TotalPaidByOrder.TotalPaid) FROM TotalPaidByOrder
INNER JOIN Orders ON TotalPaidByOrder.OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Orders.CustomerID
ORDER BY TotalPaid DESC
LIMIT 10

-- Total orders by Employee
SELECT Employees.EmployeeID, FirstName || ' ' || LastName as FullName, COUNT(Orders.OrderID) AS TotalOrders FROM Orders
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Orders.EmployeeID
ORDER BY TotalOrders DESC

-- Total sold by Employee

-- First, creating a CTE with the total for each Order made by joining tables OrderDetails and
-- Products
WITH TotalPaidByOrder AS (
SELECT OrderDetails.OrderDetailID, OrderDetails.OrderID, sum((Quantity*Price)) as TotalPaid FROM OrderDetails
INNER JOIN Products on OrderDetails.ProductID = Products.ProductID
GROUP BY OrderDetails.OrderID)
-- Second, joining the CTE with tables Orders and Employees for getting the total
-- sold by employee
SELECT Employees.EmployeeID, Employees.FirstName || ' ' || Employees.LastName as FullName, 
sum(TotalPaidByOrder.TotalPaid) as TotalSold FROM TotalPaidByOrder
INNER JOIN Orders ON TotalPaidByOrder.OrderID = Orders.OrderID
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Orders.EmployeeID
ORDER BY TotalSold DESC

-- 10 Ten best selling Products by Quantity
SELECT OrderDetails.ProductID, Products.ProductName, OrderDetails.Quantity FROM OrderDetails
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY OrderDetails.ProductID
ORDER BY OrderDetails.Quantity DESC
LIMIT 10

-- 10 Ten best selling Products by total revenue
SELECT OrderDetails.ProductID, ProductName, sum(OrderDetails.Quantity), sum((Quantity*Price)) as TotalRevenue FROM OrderDetails
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY OrderDetails.ProductID
ORDER BY TotalRevenue DESC
LIMIT 10 

