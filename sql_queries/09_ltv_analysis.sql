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