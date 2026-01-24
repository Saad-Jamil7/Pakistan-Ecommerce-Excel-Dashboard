#Customer Insights

WITH customer_orders AS (
    SELECT `Customer ID`,
        COUNT(DISTINCT increment_id) AS order_count
    FROM cleaned_ecommerce
    GROUP BY `Customer ID`
)
SELECT
    CASE WHEN order_count > 1 THEN 'Repeat'
        ELSE 'One-time'
    END AS customer_type,
    COUNT(*) AS customers
FROM customer_orders
GROUP BY customer_type;

#revenue by customers
SELECT `Customer ID`, SUM(grand_total) AS revenue
FROM cleaned_ecommerce
WHERE status = 'complete' or status = 'received'
GROUP BY `Customer ID`
ORDER BY revenue DESC
LIMIT 10;
