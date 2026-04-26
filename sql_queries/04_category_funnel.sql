-- FUNNEL BY PRODUCT CATEGORY - TO IDENTIFY WHICH CATEGORIES CONVERT BETTER

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