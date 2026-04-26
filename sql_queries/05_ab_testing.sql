-- A/B TESTING RESULTS

select experiment_group,count(distinct customer_id) as total_users, 
COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) AS purchasers, 
COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END)*100/count(distinct customer_id) conv_perc from events
group by experiment_group;

-- Control group has a better conversion rate compared to experiment groups