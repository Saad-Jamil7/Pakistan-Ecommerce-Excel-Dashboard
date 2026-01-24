use pak_ecommerce;
select * from cleaned_ecommerce;

#kpi cards
select 
SUM(CASE WHEN status IN ('complete','received') THEN grand_total END) as total_revenue,
count(distinct increment_id) as total_orders,
SUM(CASE WHEN status IN ('complete','received') THEN grand_total END)
/
COUNT(DISTINCT CASE WHEN status IN ('complete','received') THEN increment_id END)
AS avg_order_value
,
count(DISTINCT CASE WHEN status IN (
    'canceled',
    'fraud',
    'order_refunded',
    'refund',
    'closed'
) then increment_id end)
/
count(DISTINCT increment_id) * 100 as cancellation_rate_percent
from cleaned_ecommerce;

-- Best performing categories
SELECT category_name_1, SUM(grand_total) as revenue
FROM cleaned_ecommerce
WHERE status = 'complete' or status = 'received'
GROUP BY category_name_1
ORDER BY revenue DESC
LIMIT 5;

#revenue (generated,lost,risk)
SELECT
    SUM(CASE WHEN status IN ('complete','received') 
    THEN grand_total END) AS realized_revenue,
    SUM(CASE WHEN status IN ('canceled','fraud','order_refunded','refund','closed') 
    THEN grand_total END) AS lost_revenue,
    SUM(CASE WHEN status IN ('holded','exchange') 
    THEN grand_total END) AS at_risk_revenue
FROM cleaned_ecommerce;

#net revenue
SELECT
    SUM(CASE WHEN status IN ('complete','received') THEN grand_total END)
  - SUM(CASE WHEN status IN ('canceled','fraud','order_refunded','refund','closed') THEN grand_total END)
    AS net_revenue
FROM cleaned_ecommerce;

SELECT increment_id, COUNT(*) 
FROM cleaned_ecommerce
GROUP BY increment_id
HAVING COUNT(*) > 1;


