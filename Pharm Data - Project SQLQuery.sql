SELECT SUM(Sales) Total_Sales, SUM(Quantity) Total_Quantity, AVG(Price) Average_Price
FROM data_pharm;

--1. Sales Performance Analysis
--•	What is the total sales amount for each month and year?
WITH Month_Year AS (SELECT DISTINCT Month, Year, SUM(Sales) OVER(PARTITION BY Month, Year ORDER BY Month, Year) AS Month_Year_SUM
					FROM data_pharm
					),
MAX_YEAR AS (SELECT *, MAX(Month_Year_SUM) OVER(PARTITION BY Year) AS Month_Year_MAX
FROM Month_Year)
SELECT *
FROM MAX_YEAR
WHERE Month_Year_SUM = Month_Year_MAX;


--•	Which product class contributes the most to sales?
SELECT DISTINCT Product_Class, ROUND(SUM(Sales) OVER(PARTITION BY Product_Class), 0) AS Product_Class_SUM
FROM data_pharm
ORDER BY Product_Class_SUM DESC;


--•	Which Sales rep contributes the most to sales?
WITH Sales_rep AS (SELECT DISTINCT Name_of_Sales_Rep, ROUND(SUM(Sales) OVER(PARTITION BY Name_of_Sales_Rep), 0) AS Sales_Rep_SUM
					FROM data_pharm)
SELECT *
FROM Sales_rep
ORDER BY Sales_Rep_SUM DESC;


--•	How do sales vary across different channels and sub-channels?
SELECT DISTINCT Channel, ROUND(SUM(Sales) OVER(PARTITION BY Channel), 0) AS Channel_SUM
FROM data_pharm
ORDER BY Channel_SUM DESC;

SELECT DISTINCT Sub_channel, ROUND(SUM(Sales) OVER(PARTITION BY Sub_channel), 0) AS Sub_Channel_SUM
FROM data_pharm
ORDER BY Sub_Channel_SUM DESC;

--2. Location Sales Analysis
--•	Top 3 city/cities with the highest sales?
SELECT TOP 3 City, ROUND(SUM(Sales), 0) AS CITY_SUM
FROM data_pharm
GROUP BY City
ORDER BY CITY_SUM DESC;

--•	Which city/cities has the lowest sale?
SELECT City, ROUND(SUM(Sales), 0) AS CITY_SUM
FROM data_pharm
GROUP BY City
ORDER BY CITY_SUM ASC;

--•	How many products sold across different countries?
SELECT DISTINCT Country, ROUND(SUM(Sales) OVER(PARTITION BY Country), 0) AS Country_SUM
FROM data_pharm
ORDER BY Country_SUM DESC;

--3. Product Analysis
--•	Which product has the highest and lowest sales quantity?
SELECT DISTINCT TOP 3 Product_Name, SUM(Quantity) OVER(PARTITION BY Product_Name) AS Product_SUM
FROM data_pharm
ORDER BY Product_SUM DESC;

SELECT DISTINCT TOP 3 Product_Name, SUM(Quantity) OVER(PARTITION BY Product_Name) AS Product_SUM
FROM data_pharm
ORDER BY Product_SUM ASC;

--•	What is the average price of each product?
SELECT DISTINCT Product_Name, AVG(Price) OVER(PARTITION BY Product_Name) AS Product_AVG
FROM data_pharm
ORDER BY Product_AVG DESC;

--•	Which product class is the most popular among customers?
SELECT Product_Class, COUNT(*) AS Total_Customers
FROM data_pharm
GROUP BY Product_Class
ORDER BY Total_Customers DESC;

--4. Distributor Analysis
--•	Which distributor has the highest sales and which has the lowest?
SELECT DISTINCT Distributor, ROUND(SUM(Sales) OVER(PARTITION BY Distributor), 0) AS Distributor_SUM
FROM data_pharm
ORDER BY Distributor_SUM DESC;


WITH Distributor_SUM AS (SELECT Distributor, SUM(Sales) Distr_SUM
							FROM data_pharm
							GROUP BY Distributor),
MIN_DISTRIBUTOR_SALES AS (SELECT MIN(Distr_SUM) MIN_DISTR
							FROM Distributor_SUM)
SELECT Distributor, MIN_DISTR
FROM MIN_DISTRIBUTOR_SALES, Distributor_SUM
WHERE Distr_SUM = MIN_DISTR;

--•	Which distributor serves the most cities?
SELECT Distributor, COUNT(City) CITY_COUNT
FROM data_pharm
GROUP BY Distributor
ORDER BY CITY_COUNT DESC;

--•	How does the quantity of products sold vary across different distributors?
SELECT DISTINCT Distributor, ROUND(SUM(Quantity) OVER(PARTITION BY Distributor), 0) AS QTY_COUNT
FROM data_pharm
ORDER BY QTY_COUNT DESC;

--5. Channel and Sub-channel Analysis
--•	Which channel and sub-channel combination has the highest sales?
SELECT DISTINCT Channel, Sub_channel, ROUND(SUM(Sales) 
				OVER(PARTITION BY Channel, Sub_channel),0) AS Channel_Sales_SUM
FROM data_pharm
Order by Channel_Sales_SUM DESC;

--•	Are certain products more popular in specific channels or sub-channels?
SELECT DISTINCT Sub_channel, COUNT(Product_Name) 
				OVER(PARTITION BY Sub_channel) AS Sub_Channel_Count
FROM data_pharm
Order by Sub_Channel, Sub_Channel_Count DESC;


--•	How does the quantity of products sold vary across different channels?
SELECT DISTINCT Channel, Sub_channel, ROUND(SUM(Quantity) OVER(PARTITION BY Channel, Sub_channel),0) AS Channel_QTY_SUM
FROM data_pharm
Order by Channel_QTY_SUM DESC;

--•	Are there any trends or patterns in sales across different sub-channels?
SELECT DISTINCT Year, Sub_channel, ROUND(SUM(Sales) OVER(PARTITION BY Year, Sub_channel),0) AS Sub_Channel_Pattern
FROM data_pharm
Order by Sub_Channel, Sub_Channel_Pattern DESC;

--6. Monthly and Yearly Trend Analysis
--•	What are the monthly and yearly sales trends?
SELECT DISTINCT Month, Year, SUM(Sales) OVER(PARTITION BY Month, Year) AS Sales_trends
FROM data_pharm
ORDER BY Month, Year;

--•	How has the sales performance changed over the years?
SELECT DISTINCT Year, ROUND(SUM(Sales) OVER(PARTITION BY Year),0) Sales_Performance
FROM data_pharm
ORDER BY Year DESC;

--•	Which month has the highest and lowest sales?
SELECT DISTINCT Month, Year, SUM(Sales) OVER(PARTITION BY Month, Year) Month_Sales_Sum
FROM data_pharm
ORDER BY Month_Sales_Sum DESC;

--7. SALES REP PERFORMANCE ANALYSIS
--Which sales representative has the highest and lowest sales?
SELECT TOP 1
	Name_of_Sales_Rep AS Sales_Rep, SUM(Sales) AS Sales
FROM data_pharm
GROUP BY Name_of_Sales_Rep
ORDER BY Sales DESC;

SELECT TOP 1
	Name_of_Sales_Rep AS Sales_Rep, SUM(Sales) AS Sales
FROM data_pharm
GROUP BY Name_of_Sales_Rep
ORDER BY Sales ASC;

--How does the performance of sales reps vary across different distributors? 
SELECT Distributor, Name_of_Sales_Rep, ROUND(SUM(Sales),0) as Total_Sales
FROM data_pharm
GROUP BY Distributor, Name_of_Sales_Rep
ORDER BY Total_Sales DESC;

--Which sales team has the highest total sales? 
SELECT Sales_Team, SUM(Sales) AS Total_sales
FROM data_pharm
GROUP BY Sales_Team;







SELECT TOP 5 *
FROM data_pharm;