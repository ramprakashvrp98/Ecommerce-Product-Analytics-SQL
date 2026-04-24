create database ecom;
use ecom;

-- EVENTS TABLE
CREATE TABLE events (
    event_id INT,
    timestamp DATETIME,
    customer_id INT,
    session_id INT,
    event_type VARCHAR(50),
    product_id INT,
    device_type VARCHAR(20),
    traffic_source VARCHAR(50),
    campaign_id INT,
    page_category VARCHAR(20),
    session_duration_sec DECIMAL(10,2),
    experiment_group VARCHAR(20)
);

SET GLOBAL local_infile = 1; 

LOAD DATA LOCAL INFILE 'C:/Users/rprekash/Downloads/RAM/SQL/MYSQL/PROJECT ECOM/events.csv'
INTO TABLE events
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

select * from events;


-- PRODUCTS TABLE
create table products(
product_id int primary key,
category varchar(50),
brand varchar(50),
base_price decimal(5,2),
launch_date date,
is_premium boolean);

LOAD DATA LOCAL INFILE 'C:/Users/rprekash/Downloads/RAM/SQL/MYSQL/PROJECT ECOM/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

select * from products;


-- TRANSACTIONS TABLE
create table transactions(
transaction_id int,
timestamp datetime,
customer_id int,
product_id int,
quantity int,
discount_applied decimal(5,2),
gross_revenue decimal (5,2),
campaign_id int,
refund_flag boolean);

LOAD DATA LOCAL INFILE 'C:/Users/rprekash/Downloads/RAM/SQL/MYSQL/PROJECT ECOM/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

select * from transactions;


-- CAMPAIGNS TABLE
create table campaigns(
campaign_id int,
channel varchar(50),
objective varchar(50),
start_date date,
end_date date,
target_segment varchar(50),
expected_uplift decimal(5,3));

LOAD DATA LOCAL INFILE 'C:/Users/rprekash/Downloads/RAM/SQL/MYSQL/PROJECT ECOM/campaigns.csv'
INTO TABLE campaigns
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

select * from campaigns;


-- CUSTOMERS TABLE
create table customers(
customer_id int,
signup_date date,
country varchar(10),
age int,
gender varchar(10),
loyalty_tier varchar(20),
acquisition_channel varchar(20));

LOAD DATA LOCAL INFILE 'C:/Users/rprekash/Downloads/RAM/SQL/MYSQL/PROJECT ECOM/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

select * from customers;



select * from events;
select * from campaigns;
select * from products;
select * from customers;
select * from transactions;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Comparing event types based on unique customers (FUNNEL ANALYSIS - USER LEVEL)
SELECT 
event_type,
COUNT(DISTINCT customer_id) AS users
FROM events
GROUP BY event_type
ORDER BY users DESC;

-- As we can see almost 85k users have bounced from the website, this affects sales and shows there is something wrong with the website or a wrong landing page or bad UI/UX

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TOTAL BOUNCE RATE
SELECT 
    COUNT(DISTINCT session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN event_type = 'bounce' THEN session_id END) AS bounce_sessions,
    ROUND(COUNT(DISTINCT CASE WHEN event_type = 'bounce' THEN session_id END) / COUNT(DISTINCT session_id) * 100, 2) AS bounce_rate_pct FROM events;
    
    -- In total, we got around 26% Bounce rate

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- OVERALL EVENT DISTRIBUITION
select distinct event_type, count(session_id) as each_event ,sum(count(session_id)) over() as total_event, count(session_id)*100/sum(count(session_id)) over() event_perc from events
group by event_type; 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CONVERSION RATE WRT EVENTS

select * from events;

-- METHOD 1
select event_type,count(distinct customer_id),lag(count(distinct customer_id)) over(order by count(distinct customer_id) desc) prev_stage, 
count(distinct customer_id)*100/lag(count(distinct customer_id)) over(order by count(distinct customer_id) desc) conv_percentage from events group by event_type;

-- METHOD 2
WITH conv_funnel AS(
select event_type,count(distinct customer_id) cust_count from events group by event_type)
select event_type,cust_count,lag(cust_count) over(order by cust_count desc) prev_stage, 
cust_count*100/lag(cust_count) over(order by cust_count desc) conv_percentage from conv_funnel;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNNEL BY PRODUCT CATEGORY - TO IDENTIFY WHICH CATEGORIES CONVERT BETTER

SELECT * FROM EVENTS;
SELECT * FROM PRODUCTS;

SELECT DISTINCT CATEGORY FROM PRODUCTS;

SELECT 
    p.category,
    e.event_type,
    COUNT(DISTINCT e.customer_id) AS users
FROM events e
JOIN products p 
    ON e.product_id = p.product_id
GROUP BY p.category, e.event_type;

-- Category Beauty has the lowest conversion rate
-- Category Electronics has the highest conversion rate 


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- A/B TESTING RESULTS

SELECT * FROM EVENTS;
select experiment_group,count(experiment_group) from events group by experiment_group;


select experiment_group,count(distinct customer_id) as total_users from events
where event_type = 'purchase'
group by experiment_group;

select experiment_group,count(distinct customer_id) as total_users, 
COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) AS purchasers, 
COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END)*100/count(distinct customer_id) conv_perc from events
group by experiment_group;

-- Control group has a better conversion rate compared to experiment groups


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Revenue Analysis

select a.product_id,a.category,a.base_price,sum(b.quantity) quantity,sum(b.gross_revenue) Total_revenue
from products a inner join transactions b 
on a.product_id=b.product_id
group by a.product_id,a.category,a.base_price
order by a.product_id asc;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Campaign and Revenue summary (Based on all transactions and campaigns)
   
SELECT COALESCE(a.campaign_id, 0) AS campaign_id,a.channel,a.target_segment,b.event_type,b.traffic_source,c.transaction_id,c.gross_revenue
FROM events b LEFT JOIN campaigns a 
ON b.campaign_id = a.campaign_id
LEFT JOIN transactions c 
ON b.customer_id = c.customer_id
AND b.campaign_id = c.campaign_id;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Revenue by channel and ranking

select a.channel,sum(b.gross_revenue) total_revenue, count(distinct b.customer_id) total_customers, dense_rank() over(order by sum(b.gross_revenue) desc) rank_
from campaigns a inner join transactions b on a.campaign_id=b.campaign_id
group by a.channel;

-- Affiliate marketing brings in the highest revenue and customers whereas Social media marketing brings the lowest

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Retention Analysis - classification based on customer interaction

select * from events;

with user_interaction as(
SELECT customer_id,
count(event_id) as interactions
FROM events
GROUP BY customer_id), 
prk as
(select customer_id,interactions,percent_rank() over(order by interactions) as pr
from user_interaction)

select customer_id,interactions,round(pr,2) p_rank,
case when round(pr,2) >=0.7 then 'A'
when round(pr,2) >= 0.4 then 'B'
else 'C'
end Class
from prk;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Most number of products refunded

select product_id,sum(refund_flag) rf from transactions
group by product_id
order by rf desc;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TOP CUSTOMERS BY LIFE TIME VALUE

SELECT 
    customer_id,
    SUM(gross_revenue) AS lifetime_value
FROM transactions
GROUP BY customer_id
order by lifetime_value desc;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CUSTOMERS BY LIFE TIME VALUE and Tenure Analysis

select a.customer_id,a.acquisition_channel,datediff(curdate(),a.signup_date) member_days, sum(b.gross_revenue) Purchase_amount
from customers a inner join transactions b
on a.customer_id=b.customer_id
group by a.customer_id,a.acquisition_channel,a.signup_date
order by Purchase_amount desc;

