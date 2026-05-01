----*#$/

--Select *
--From CoffeeShopSales

--Select transaction_date, transaction_time, transaction_qty, 
--store_id, store_location, product_id, unit_price, 
--product_category, product_type, product_detail
--From CoffeeShopSales

----Transaction_Time Data Cleaning

--Select transaction_time
--From CoffeeShopSales

--Select Convert(Time(0), transaction_time) As transaction_time
--From CoffeeShopSales

--Select transaction_date,  Convert(Time(0), transaction_time) 
--As transaction_time, transaction_qty, 
--store_id, store_location, product_id, unit_price, 
--product_category, product_type, product_detail
--From CoffeeShopSales

----Unit_Price Data Cleaning

--Select Round(unit_price,1) As unit_price
--From CoffeeShopSales

--Update CoffeeShopSales
--Set unit_price = Round(unit_price,1)

Select transaction_date,  Convert(Time(0), 
transaction_time) As transaction_time, transaction_qty, 
store_id, store_location, product_id, unit_price, 
product_category, product_type, product_detail
From CoffeeShopSales

--Select store_id, store_location 
--From CoffeeShopSales 

--Total_Sales_per_Location_EveryDay

Select transaction_date,store_id,store_location, 
Count(store_location) As total_transactions_per_location, 
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by transaction_date, store_id, store_location
Order by transaction_date


--Sales_by_product_category

Select store_id,product_category,store_location, 
Count(store_location) As total_transaction_per_location, 
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by store_id, store_location,product_category
Order by total_sales Desc


--Sales_by_product_type

Select store_id,store_location,product_category, product_type,
Count(store_location) As total_transaction_per_location, 
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by store_id, store_location,product_category,product_type
Order by total_sales Desc


--Sales by product by Sales Range

With CTE_Sale_Range
As(
Select store_id, store_location, product_category, product_type, 
Count(store_location) As total_transaction_per_location, 
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by store_id, store_location,product_category,product_type
)
Select store_id, store_location, product_category, product_type,
total_transaction_per_location, total_sales, 
Case
When total_sales > 10000 Then 'Highest sales'
When total_sales > 1000 Then 'Medium sales'
Else 'Lowest sales' End As Sales_Ranges

From CTE_Sale_Range
Order by total_sales Desc


--Days of the week which tend to be busiest

Select Datename(Weekday,transaction_date) As day_of_Week, Count(*) As total_transaction,   
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by  Datename(Weekday,transaction_date)
Order by total_sales Desc

--total sale each store made by day_of_week

Select Datename(Weekday,transaction_date) As day_of_week, Count(*) As total_transaction,store_id, store_location,
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by Datename(Weekday,transaction_date),store_id, store_location
Order by day_of_week Desc

--Busiest store by total_transactions_per_location 

Select store_id,store_location, Count(store_location) 
As total_transactions_per_location 
From CoffeeShopSales 
Group by store_id, store_location
Order by total_transactions_per_location Desc

--Hour of the day tend to be the most busiest 

Select Datepart(Hour,transaction_time) As Hour_of_day, store_location,   
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by Datepart(Hour,transaction_time), store_id, store_location
Order by total_sales DESC

--Hour of the day tend to be the most busiest by product sold

Select Datepart(Hour,transaction_time) As Hour_of_day,store_location,product_category, product_type,    
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by Datepart(Hour,transaction_time), store_location,product_category, product_type, unit_price
Having Round(Sum(unit_price),2) > 590 
Order by store_location

--Store Rank by Revenue 

With CTE_Store_sales
   As (
Select store_id, store_location, Round(Sum(unit_price),1) 
As Total_Revenue_per_Location
From CoffeeShopSales
Group by store_id, store_location 
)

Select store_id,store_location,Total_Revenue_per_Location,
 RANK() Over (Order by Total_Revenue_per_Location Desc
) AS Revenue_Rank
From CTE_Store_sales

	--VIEWS

----Total_Sales_per_Location_EveryDay

Create View Total_Sales_per_Location_EveryDay As

Select transaction_date,store_id,store_location, 
Count(store_location) As total_transactions_per_location, 
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by transaction_date, store_id, store_location
--Order by transaction_date
Go

----Sales_by_product

Create View  Sales_by_product As

Select store_id,store_location,product_category, product_type,
Count(store_location) As total_transaction_per_location, 
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by store_id, store_location,product_category,product_type
--Order by total_sales Desc
Go

----Sales by product by Sales Range

Create View Sales_by_product_by_Sales_Range As

With CTE_Sale_Range
As(
Select store_id, store_location, product_category, product_type, 
Count(store_location) As total_transaction_per_location, 
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by store_id, store_location,product_category,product_type
)
Select store_id, store_location, product_category, product_type,
total_transaction_per_location, total_sales, 
Case
When total_sales > 10000 Then 'Highest sales'
When total_sales > 1000 Then 'Medium sales'
Else 'Lowest sales' End As Sales_Ranges

From CTE_Sale_Range
--Order by total_sales Desc


----Days of the week which tend to be busiest

Create View Days_of_the_week_which_tend_to_be_busiest As

Select Datename(Weekday,transaction_date) As day_of_Week, Count(*) As total_transaction,   
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by  Datename(Weekday,transaction_date)
--Order by total_sales Desc
Go

----total sale each store made by day_of_week

Create View total_sale_each_store_made_by_day_of_week As

Select Datename(Weekday,transaction_date) As day_of_week, Count(*) As total_transaction,store_id, store_location,
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by Datename(Weekday,transaction_date),store_id, store_location
--Order by day_of_week Desc
Go


----Busiest store by total_transactions_per_location 

Create View Busiest_store_by_total_transactions_per_location As

Select store_id,store_location, Count(store_location) 
As total_transactions_per_location 
From CoffeeShopSales 
Group by store_id, store_location
--Order by total_transactions_per_location Desc
Go


----Hour of the day tend to be the most busiest 

Create View Hour_of_the_day_tend_to_be_the_most_busiest As

Select Datepart(Hour,transaction_time) As Hour_of_day, store_location,   
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by Datepart(Hour,transaction_time), store_id, store_location
--Order by total_sales DESC
Go

--Hour of the day tend to be the most busiest by product sold

Create View Hour_of_the_day_tend_to_be_the_most_busiest_by_product_sold As

Select Datepart(Hour,transaction_time) As Hour_of_day,store_location,product_category, product_type,    
Round(Sum(unit_price),2) As total_sales
From CoffeeShopSales 
Group by Datepart(Hour,transaction_time), store_location,product_category, product_type, unit_price
Having Round(Sum(unit_price),2) > 590 
--Order by store_location
Go

--Store Rank by Revenue 

Create View Store_Rank_by_Revenue As

With CTE_Store_sales
   As (
Select store_id, store_location, Round(Sum(unit_price),1) 
As Total_Revenue_per_Location
From CoffeeShopSales
Group by store_id, store_location 
)

Select store_id,store_location,Total_Revenue_per_Location,
 RANK() Over (Order by Total_Revenue_per_Location Desc
) AS Revenue_Rank
From CTE_Store_sales
Go
