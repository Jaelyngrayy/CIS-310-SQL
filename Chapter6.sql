--equi-Join
--What are the customer I Ds and names of all customers, along with the order I Ds for all the orders they have placed?

Select Customer_T.customerID, Order_T.customerID, CustomerName, OrderID
	from Customer_T,Order_T
	Where Customer_T.customerID = Order_T.CustomerID
	Order by OrderID;

Select Customer_T.customerID, Order_T.customerID, CustomerName, OrderID
	from Customer_T INNER JOIN Order_T
	ON Customer_T.customerID = Order_T.CustomerID
	Order by OrderID;

--List the customer name, I D number, and order number for all customers. 
--Include customer information even for customers that do not have an order.


Select Customer_T.customerID, CustomerName, Order_T.customerID, OrderID
	from Customer_T LEFT OUTER JOIN Order_T
	ON Customer_T.customerID = Order_T.CustomerID;
	
--Assemble all information necessary to create an invoice for order number 1006.

Select Customer_T.customerID, CustomerName, CustomerAddress, CustomerCity,
	CustomerState, customerPostalCode, Order_T.OrderID, OrderDate,
	OrderedQuantity, ProductDescription, ProductStandardPrice,
	(OrderedQuantity*ProductStandardPrice)
	from Customer_T, Order_T, OrderLine_T, Product_T
	Where Customer_T.customerID = Order_T.CustomerID
	AND Order_T.OrderID=Orderline_T.OrderID
	AND Orderline_T.ProductID=Product_T.ProductID
	AND Order_T.OrderID = 1006



--What are the employee ID and name of each employee and the name of his or her 
--supervisor (label the supervisor’s name Manager

Select E.EMployeeID, E.EMployeeName, M.EMployeeName AS Manager
	from Employee_T E, Employee_T M
	Where E.EmployeeSupervisor=M.EmployeeID;



--What are the name and address of the customer who placed order number 1008?
Select Customer_T.customerID, CustomerName, CustomerAddress, CustomerCity,
	CustomerState, customerPostalCode
	From Customer_T
	Where Customer_T.CustomerID=         --Only one value
		(Select Order_T.CustomerID
			From Order_T
			Where OrderID = 1008);



--Use a join
Select Customer_T.customerID, CustomerName, CustomerAddress, CustomerCity,
	CustomerState, customerPostalCode
	From Customer_T, Order_T
	Where Customer_T.CustomerID = Order_T.CustomerID
		AND OrderID = 1008;

--List the details about the product with the highest standard price.
--Correlated Subquery
Select ProductDescription, ProductFinish, ProductStandardPrice
	From Product_T PA
	Where PA.ProductStandardPrice > All
		(Select ProductStandardPrice From Product_T PB
		Where PB.ProductID !=PA.ProductID);


--What are the order I Ds for all orders that have included furniture 
--finished in natural ash?

Select Distinct OrderID from OrderLine_T
where Exists
	(Select * from Product_T
		Where ProductID=OrderLine_T.ProductID
		AND Productfinish='Natural Ash');


--What are the order I Ds for all orders that have included furniture 
--finished in natural ash?
Select ProductDescription, ProductStandardPrice, AvgPrice
	From 
		(Select Avg(ProductStandardPrice) AvgPrice From Product_T),
		Product_T
	Where ProductStandardPrice>AvgPrice;


--UNION — Combining Queries
Select C1.CustomerID, CustomerName, OrderedQuantity, 'Largest Quantity' As Quantity
  From customer_T C1, order_T O1, OrderLine_T Q1
  Where C1.customerID = O1.customerID and O1.orderID=Q1.orderID
  and orderedquantity= (Select Max(orderedquantity) from orderline_T)
Union
Select C1.CustomerID, CustomerName, OrderedQuantity, 'Smallest Quantity' As Quantity
  From customer_T C1, order_T O1, OrderLine_T Q1
  Where C1.customerID = O1.customerID and O1.orderID=Q1.orderID
  and orderedquantity= (Select Min(orderedquantity) from orderline_T)


--Conditional Expressions Using Case Keyword
Select 
	Case When ProductLineID = 1 Then ProductDescription
	Else '####'
End AS ProductDescription
From Product_T;

--Using a view in query
Create View TSales AS
 Select SalespersonName, ProductDescription,SUM(OrderedQuantity) AS TotOrders
 From Salesperson_T, OrderLine_T, Product_T, Order_T
	where Salesperson_T.SalespersonID = Order_T.SalespersonID
	AND Order_T.OrderID = Orderline_T.OrderID
	AND OrderLine_T.ProductID = Product_T.ProductID
	Group By SalespersonName, ProductDescription;

--The query using view
Select SalespersonName, ProductDescription
 From TSales As A
	Where Totorders=(Select Max(TotOrders) From TSales B
		Where B.SalespersonName = A.SalespersonName);



Create View ExpensiveStuff_V
	AS
	Select ProductID, ProductDescription, ProductStandardPrice
	 From Product_T
	   Where ProductStandardPrice>300
	   With Check Option;

















	

