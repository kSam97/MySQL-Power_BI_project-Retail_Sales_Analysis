create database retail_sales_customer_data;

use retail_sales_customer_data;

drop table customers;

create table customers(
invoice_number varchar(20),
customer_id varchar(20),
gender varchar(20),
age int,
category varchar(30),
quantity int,
price decimal(6,2),
payment_method varchar(20),
invoice_date date,
shopping_mall varchar(30)
);


select * from customers;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\customer_shopping_data.csv"
INTO TABLE customers
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;


-- Retriving total no. of records vs total no. of distinct records in the table
SELECT 
	distinct count(*) as total_distinct_records, 
    count(*) as total_records
FROM customers;


-- Retriving total no. of columns in the dataset
select 
	COUNT(*) AS total_no_of_columns 
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'retail_sales_customer_data' AND table_name = 'customers';

-- Describing the table customers
describe customers;

-- Retriving all the records from the table customers
SELECT * FROM customers; 

######################  ELPLORATORY DATA ANALYSIS  #######################

-- ''' Total No. of customers vs total no. of distinct customers ''' --
select 
	count(*),
	count(distinct customer_id) as total_no_of_unique_customers
from customers;

-- ;;; gender ;;; --

-- ''' Gender breakdown of total customers ''' --

select 
	gender,
    count(gender) as total_customers
from customers
group by gender;

-- ;;; age ;;; --

-- ''' Retirving customer age range ''' --
select
	min(age) as minimum_age,
    max(age) as maximum_age
from customers;

-- ### Grouping all the customers into age group ie.. Teens, Young adults, Middle-aged adults and Older adults

/* conditions:{ if age between 18-19 then Teens (Because the minimum age in the dataset is 18)
				if age between 20-30 then Young adults
                if age between 30-55 then Middle-aged adults
                if age > 56 then Older adults }
*/

-- ''' Adding a new column named age_group for this perticular operation ''' --

alter table customers 
add column age_group varchar(20) after age;

select * from customers;

update customers 
set age_group = case 
	when age between 18 and 19 then "Teens"
    when age between 20 and 30 then "Young adults"
    when age between 30 and 55 then "Middle-aged adults"
    else "Older adults"
end;

-- ''' retriving the total records with new column ''' --
SELECT * FROM customers;

-- ;;; age_group ;;; --

-- ''' Age group distribution in the dataset ''' --

select 
	age_group,
    count(*) as total_customers
from customers
group by age_group
order by total_customers desc;

-- ;;; category ;;; --
    
-- ''' total unique Category in the dataset ''' --

select 
	distinct category 
from customers;

-- ;;; quantity ;;; --

-- ''' Minimum and Maximum item bought by a customer ''' --
select 
	min(quantity) as minimum_item,
    max(quantity) as maximum_item
from customers ;

-- ''' price ''' --

-- ''' Minimum and Maximum and Average expenses by customers ''' --
select 
	min(price) as min_expenses,
    max(price) as max_expenses,
    avg(price) as avg_expenses
from customers;

-- ;;; category ;;; --

-- ''' total sale by the category ''' --
select 
	category,
    round(sum(price)/1000000,2) as total_sale_in_Million
from customers 
group by category
order by total_sale_in_Million desc;

-- ''' Expenses breakdown by gender and category ''' --

select 
	category,
    gender,
    round(sum(price)/1000000,2) as total_sale_in_Million,
    round(sum(price),2) as total_sale_actual
from customers
group by category, gender
order by category;

-- ;;; payment_method ;;; --

-- ''' Total payment breakdown by payment_method ''' --

select 
	payment_method,
    round(sum(price)/1000000,2) as total_payment_in_Million
from customers
group by payment_method
order by total_payment_in_Million desc;

-- ''' Total transaction of different payment method ''' --

select 
	payment_method,
    count(*) as total_transaction
from customers
group by payment_method
order by total_transaction desc;

-- ''' payment methond breakdown with total transaction and gender ''' --

select 
	payment_method,
    gender,
    count(*) as total_transaction
from customers
group by payment_method, gender
order by payment_method, gender, total_transaction desc;

-- ''' Gender Ratio in total transaction ''' --
select 
	gender,
    count(*) as total_transaction
from customers
group by gender
order by total_transaction desc;


-- ;;; invoice_date ;;; --

-- ''' Time period in the dataset ''' --

SELECT 
	min(invoice_date) as start_date,
    max(invoice_date) as end_date
FROM customers;

-- ''' Adding month and year column from invoice_date''' --

Alter table customers
add column month varchar (10) after invoice_date,
add column year int(5) after month;

update customers 
set month = monthname(invoice_date);

update customers
set year = year(invoice_date);

-- ''' total sales by year ''' --

select 
	year,
	round(sum(price)/1000000,2) as total_sale_in_Million
from customers
group by year
order by year;

-- ''' Average  and Total Sales by month in all 3 years ''' --
select 
	year,
    month,
    round(avg(price),2) as average_sale,
    round(sum(price)/1000000,2) as total_sale_in_Million
from customers
group by year, month
order by year, month;

-- '''  which month have the maximum sale throughout the all years ''' --

select 
	year,
	month(invoice_date) as month_no,
	month,
    round(sum(price)/1000000,2) as total_sale_in_Million
from customers
group by year, month, month_no
order by total_sale_in_Million desc;
    

select * from customers;


-- ;;; shopping_mall ;;; --

-- ''' Retrive all shopping mall's name in the dataset  in alphabetical order ''' --

select 
	distinct shopping_mall 
from customers
order by shopping_mall;

-- ''' shopping mall and total sales breakdown ''' --

select 
	shopping_mall,
    round(sum(price)/1000000,2) as total_sale_in_Million
from customers
group by shopping_mall;

-- ''' shopping mall total sales background by year ''' --

select 
	shopping_mall,
    round(sum(price)/1000000,2) as total_sale_in_Million,
    round(sum(case
		when year = 2021 then (price)/1000000
        else 0
        end),2)as '2021_sales(M)',
	round(sum(case
		when year = 2022 then (price)/1000000
        else 0
        end),2) as '2022_sales(M)',
	round(sum(case
		when year = 2023 then (price)/1000000
        else 0
        end),2) as '2023_sales(M)'

from customers
group by shopping_mall;


-- ''' total customers of each shopping mall with respect to gender ''' --

select 
	shopping_mall,
    gender,
    count(*) as total_customers
from customers
group by shopping_mall, gender
order by shopping_mall;


select * from customers;