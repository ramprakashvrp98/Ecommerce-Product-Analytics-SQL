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