use retail_sales_customer_data;

select * from customers;


##################### TOP BUSINESS QUESTIONS #######################

-- Q1. What is the TOTAL Annual Sale(in INR) of all Shopping Malls by Year?

/* The currency unit of the price column is in Turkish Liras (TL)
1 TL = 3.20 INR, hence we have to multiply price with 3.20 in order to get the values in INR
*/

# let's simplify it by adding a column price_inr

-- ALTER TABLE customers
-- add column price_inr decimal(8,2) after price;

UPDATE customers
set price_inr = price * 3.20;
select * from customers;

select 
	shopping_mall,
    round(sum(case
			when year=2021 then price_inr/1000000 ## this will convert the value in Million
            else 0								  ## 1 million = 1000000
		end),2) as '2022_sales_(M_inr)', # M_inr for Million INR
	round(sum(case
			when year=2022 then price_inr/1000000
            else 0
		end),2) as '2022_sales_(M_inr)',
	round(sum(case
			when year=2023 then price_inr/1000000
			else 0
		end),2) as '2023_sales_(M_inr)'
from customers
	group by shopping_mall
    order by '2022_sales_(M_inr)' desc, '2022_sales_(M_inr)' desc, '2023_sales_(M_inr)' desc;
    
    

-- Q2. What is the Average Sales(in INR) of all Shopping Malls Quarterly in each year?

select 
	shopping_mall,
	year, 
    quarter(invoice_date) AS quarter, 
    round(avg(price_inr),2) AS average_sale_inr
from customers
	group by shopping_mall, year, quarter
    order by year, quarter, average_sale_inr desc;
    
    
-- Q3. Gender Breakdown with age group!

select
	age_group,
    gender,
    count(*) as total_customers
from customers
	group by age_group, gender
    order by age_group desc, gender;
    
-- Q4. SELECT Total transactions and Total Payment(INR) of each Payment method!

select
	payment_method,
    count(*) as total_transaction,
    round(sum(price_inr/1000000),2) as 'total_payment_M(INR)'
from customers
	group by payment_method
    order by total_transaction desc;
    
    
-- Q5. SELECT Total Transactions with Gender, Category and Payment Method!

select 
	category,
    gender,
    count(*) as total_trasaction,
    payment_method
from customers
	group by category, gender, payment_method
    order by total_trasaction desc;

-- Q5. Total Transaction, Total Payment(INR) and Payment Method by age group and gender

select 
	age_group,
    gender, 
    count(*) as total_transaction,
    round(sum(price_inr/1000000),2) as 'total_payment_M(INR)',
    payment_method
from customers
	group by payment_method, age_group, gender
    order by age_group desc, total_transaction desc;
    
-- Q6. Top 3 Category by total sale(INR)

select 
	category,
    round(sum(price_inr/1000000),2) as 'total_sale_M(INR)'
from customers
	group by category
    order by round(sum(price_inr/1000000),2) desc limit 3;
    
-- Q7. Total Sale(INR) by age group only!

select 
	age_group,
	round(sum(price_inr/1000000),2) as 'total_sale_M(INR)'
from customers
	group by age_group
    order by round(sum(price_inr/1000000),2) desc;
    
-- Q8. Total customers of each shopping mall!

select 
	shopping_mall,
    count(*) as total_customers
from customers
	group by shopping_mall
    order by total_customers desc;
    
-- Q9. Total sales by category in each Shopping Malls!

select 
	shopping_mall, 
    category,
    round(sum(price/1000000),2) as total_sales_M_inr # total sales in Million (INR)
from customers
	group by shopping_mall, category
    order by total_sales_M_inr desc, shopping_mall asc;

-- Q10. Which Month had highest sales(INR) in each Shopping Mall in the year 2021 and 2022?

select 
	shopping_mall,
	year,
    month,
    round(sum(price/1000000),2) as total_sales_in_Million_INR
from customers
	where year in (2021, 2022)
	group by shopping_mall, year, month
    order by total_sales_in_Million_INR desc, shopping_mall;
    
    
select * from customers;