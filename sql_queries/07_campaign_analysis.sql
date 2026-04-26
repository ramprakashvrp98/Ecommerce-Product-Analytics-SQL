-- Campaign and Revenue summary (Based on all transactions and campaigns)
   
SELECT COALESCE(a.campaign_id, 0) AS campaign_id,a.channel,a.target_segment,b.event_type,b.traffic_source,c.transaction_id,c.gross_revenue
FROM events b LEFT JOIN campaigns a 
ON b.campaign_id = a.campaign_id
LEFT JOIN transactions c 
ON b.customer_id = c.customer_id
AND b.campaign_id = c.campaign_id;