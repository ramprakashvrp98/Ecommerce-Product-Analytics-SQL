-- Revenue Analysis

select a.product_id,a.category,a.base_price,sum(b.quantity) quantity,sum(b.gross_revenue) Total_revenue
from products a inner join transactions b 
on a.product_id=b.product_id
group by a.product_id,a.category,a.base_price
order by a.product_id asc;

-------------------------------------------------------------------------------------------------------------------------------

-- Revenue by channel and ranking

select a.channel,sum(b.gross_revenue) total_revenue, count(distinct b.customer_id) total_customers, dense_rank() over(order by sum(b.gross_revenue) desc) rank_
from campaigns a inner join transactions b on a.campaign_id=b.campaign_id
group by a.channel;

-- Affiliate marketing brings in the highest revenue and customers whereas Social media marketing brings the lowest