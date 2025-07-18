use capstone;

create table amazone_sales 
(
	invoice_id varchar(30) primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    vat float(6,4) not null,
    total decimal(10,2) not null,
    date date not null,
    time timestamp not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_percentage float(11,9) not null,
    gross_income decimal(10,2) not null,
    rating float(2,1) not null
);

-- BELOW TWO LINES ARE FOR MAKING A BACKUP OF THE MAIN TABLE
-- create table amazon_sales_safety like amazon_sales;
-- insert into amazon_sales_safety select * from amazon_sales;

-- PRODUCT ANALYSIS
	-- Different Product Lines
	select count(distinct product_line) as number_of_product_lines
	from amazon_sales;
    -- Best Performing Product Line
    select product_line, sum(total) as total_sales
    from amazon_sales
    group by product_line
    order by total_sales desc;

-- SALES ANALYSIS
	-- Sales Trends of Products
    SELECT product_line, month(date) AS month, SUM(total) AS total_sales
	FROM amazon_sales
	GROUP BY product_line, month(date)
	ORDER BY product_line, month;

-- CUSTOMER ANALYSIS
	-- Customer segments
    select distinct customer_type as customer_segments
    from amazon_sales;
    -- Purchase Trends in each month
    select customer_type, month(date) as month, sum(total) as sales
    from amazon_sales
    group by customer_type, month(date)
    order by month(date), sum(total) desc;
    -- Profitability in each month
    select customer_type, month(date) as month, sum(gross_income) as profit
    from amazon_sales
    group by customer_type, month(date)
    order by month(date), sum(gross_income) desc;
    
-- FEATURE ENGINEERING
	-- Adding new column timeofday
	alter table amazon_sales add timeofday varchar(15) not null;
	-- Adding values to timeofday column.
	update amazon_sales
	set timeofday = case
		when time(time) between '06:00:00' and '11:59:59' then 'Morning'
		when time(time) between '12:00:00' and '17:59:59' then 'Afternoon'
		when time(time) between '18:00:00' and '23:59:59' then 'Evening'
		else 'Night'
	end;

	-- Adding dayname column
    alter table amazon_sales add dayname varchar(3) not null;
    -- Adding values to dayname column
    update amazon_sales
    set dayname = dayname(date);
    
    -- Adding monthname column
    alter table amazon_sales add monthname varchar(10) not null;
    -- Adding values to monthname column
    update amazon_sales
    set monthname = monthname(date);

-- EXPLORATORY DATA ANALYSIS (ANSWERING 28 BUSINESS QUESTIONS)
	-- What is the count of distinct cities in the dataset?
	select count(distinct city) as Distinct_city_count from amazon_sales;

	-- For each branch, what is the corresponding city?
	select branch, city from amazon_sales
	group by branch,city
    order by branch;

	-- What is the count of distinct product lines in the dataset?
	select distinct product_line as Distinct_Product_Line from amazon_sales; 

	-- Which payment method occurs most frequently?
	select payment_method, count(payment_method) as Count_of_distinct_payment_method from amazon_sales
	group by payment_method
	order by Count_of_distinct_payment_method desc
	limit 1;

	-- Which product line has the highest sales?
	select product_line, sum(total) as Total_Sales from amazon_sales
	group by product_line
	order by Total_Sales desc;

	-- How much revenue is generated each month?
	select month(date) as Month, sum(total) as Monthly_Sales from amazon_sales
	group by month(date)
	order by Month;

	-- In which month did the cost of goods sold reach its peak?
	select month(date) as Month, max(cogs) as Max_Cogs from amazon_sales
	group by Month
	order by Max_Cogs desc
	limit 1;

	-- Which product line generated the highest revenue?
	select product_line, sum(gross_income) as Revenue from amazon_sales
	group by product_line
	order by Revenue desc;

	-- In which city was the highest revenue recorded?
	select city, sum(gross_income) as Revenue from amazon_sales
	group by city
	order by Revenue desc;

	-- Which product line incurred the highest Value Added Tax?
	select product_line, max(vat) as Max_Vat from amazon_sales
	group by product_line
	order by Max_Vat desc;

	-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
	select product_line,
	case
		when sum(total) > (
			select avg(total_sales) from
				(select product_line, sum(total) as total_sales from amazon_sales
				group by product_line) as average_sales_of_product_line
		)
		then "Good"
		else "Bad"
	end as Sale_performance
	from amazon_sales
	group by product_line;

	-- Identify the branch that exceeded the average number of products sold.
	with branch_sales as (
		select branch, sum(quantity) as products_sold
		from amazon_sales
		group by branch
	),
	average_sales as (
		select avg(products_sold) as avg_sales
		from branch_sales
	)
	select branch, products_sold
	from branch_sales, average_sales
	where products_sold > avg_sales;


	-- Which product line is most frequently associated with each gender?
	with product_counts as (
	select gender, product_line, count(*) as frequency from amazon_sales
	group by gender, product_line), -- IT WILL GET US THE FREQUENCY OF PRODUCT SALES BASED ON GENDER AND PRODUCT LINE

	ranked_products as (
	select *, row_number() over(partition by gender order by frequency desc) as rnk
	from product_counts)	--  IT WILL RANK ALL THE FREQUENCIES IN DECENDING ORDER BASED ON THE GENDERS

	select gender, product_line,frequency from ranked_products where rnk=1;	-- IT WILL ONLY SELECT RANK 1 ROWS

	-- Calculate the average rating for each product line.
	select product_line, avg(rating) as average_rating from amazon_sales
	group by product_line
	order by average_rating desc;

	-- Count the sales occurrences for each time of day on every weekday.
	select time, count(*) from amazon_sales
	where weekday(date) in (0,1,2,3,4)
	group by time;

	-- Identify the customer type contributing the highest revenue.
	select customer_type, sum(total) as sale from amazon_sales
	group by customer_type
	order by sale desc
	limit 1;

	-- Determine the city with the highest VAT percentage.
	select city, max(vat) as highest_vat from amazon_sales
	group by city
	order by highest_vat desc
	limit 1;

	-- Identify the customer type with the highest VAT payments.
	select customer_type, sum(vat) as total_vat_payment 
	from amazon_sales 
	group by customer_type 
	order by total_vat_payment desc
	limit 1;

	-- What is the count of distinct customer types in the dataset?
	select count(distinct customer_type) as count_of_distinct_customer_type
	from amazon_sales;

	-- What is the count of distinct payment methods in the dataset?
	select count(distinct payment_method) as count_of_distinct_payment_method 
	from amazon_sales;

	-- Which customer type occurs most frequently?
	select customer_type, count(*) as most_frequent_occured from amazon_sales
	group by customer_type
	order by most_frequent_occured desc
	limit 1;

	-- Identify the customer type with the highest purchase frequency.
	select customer_type, count(*) as highest_purchase from amazon_sales
	group by customer_type
	order by highest_purchase desc
	limit 1;

	-- Determine the predominant gender among customers.
	select gender, count(*) as predominant_gender
	from amazon_sales
	group by gender
	order by predominant_gender desc
	limit 1;

	-- Examine the distribution of genders within each branch.
	select gender, branch, count(*) as distribution
	from amazon_sales
	group by gender, branch
	order by branch, gender;

	-- Identify the time of day when customers provide the most ratings.
	select timeofday, count(*) as most_number_of_ratings
	from amazon_sales
	group by timeofday
	order by most_number_of_ratings desc
	limit 1;

	-- Determine the time of day with the highest customer ratings for each branch.
	with avg_ratings as (
		select branch, timeofday, avg(rating) as avg_rating
		from amazon_sales
		group by branch, timeofday
	),
	ranked_ratings as (
		select *,
		rank() over(partition by branch order by avg_rating desc) as rnk
		from avg_ratings
	)
	select branch, timeofday, avg_rating
	from ranked_ratings
	where rnk=1;

	-- Identify the day of the week with the highest average ratings.
	select dayname, avg(rating) as highest_average_rating
	from amazon_sales
	group by dayname
	order by highest_average_rating desc
	limit 1;

	-- Determine the day of the week with the highest average ratings for each branch.
	with avg_ratings as (
		select branch, dayname, avg(rating) as avg_rating
		from amazon_sales
		group by branch, dayname
	),
	ranked_ratings as (
		select *,
		rank() over(partition by branch order by avg_rating desc) as rnk
		from avg_ratings
	)
	select branch, dayname, avg_rating
	from ranked_ratings
	where rnk=1;