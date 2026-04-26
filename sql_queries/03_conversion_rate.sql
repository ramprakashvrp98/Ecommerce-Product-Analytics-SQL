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