-- Comparing event types based on unique customers (FUNNEL ANALYSIS - USER LEVEL)
SELECT 
event_type,
COUNT(DISTINCT customer_id) AS users
FROM events
GROUP BY event_type
ORDER BY users DESC;

-- As we can see almost 85k users have bounced from the website, this affects sales and shows there is something wrong with the website or a wrong landing page or bad UI/UX