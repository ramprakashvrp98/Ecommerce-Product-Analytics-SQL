-- TOTAL BOUNCE RATE
SELECT 
    COUNT(DISTINCT session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN event_type = 'bounce' THEN session_id END) AS bounce_sessions,
    ROUND(COUNT(DISTINCT CASE WHEN event_type = 'bounce' THEN session_id END) / COUNT(DISTINCT session_id) * 100, 2) AS bounce_rate_pct FROM events;
    
    -- In total, we got around 26% Bounce rate
