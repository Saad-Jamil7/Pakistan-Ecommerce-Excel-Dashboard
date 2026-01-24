#monthly revenue
SELECT
    DATE_FORMAT(created_at, '%Y-%m-01') AS month_date,
    SUM(grand_total) AS revenue
FROM cleaned_ecommerce
WHERE status IN ('complete','received')
GROUP BY month_date
ORDER BY month_date;


#lost orders by month
SELECT
    DATE_FORMAT(created_at, '%Y-%m-01') AS month_date,
    COUNT(DISTINCT increment_id) AS lost_orders
FROM cleaned_ecommerce
WHERE status IN ('canceled','closed','fraud','order_refunded','refund')
GROUP BY month_date
ORDER BY month_date;

SELECT
    month_date,
    SUM(revenue) AS revenue,
    SUM(lost_orders) AS lost_orders
FROM (
    -- Revenue part
    SELECT
        DATE_FORMAT(created_at, '%Y-%m-01') AS month_date,
        SUM(grand_total) AS revenue,
        0 AS lost_orders
    FROM cleaned_ecommerce
    WHERE status IN ('complete','received')
    GROUP BY month_date

    UNION ALL

    -- Lost orders part
    SELECT
        DATE_FORMAT(created_at, '%Y-%m-01') AS month_date,
        0 AS revenue,
        COUNT(DISTINCT increment_id) AS lost_orders
    FROM cleaned_ecommerce
    WHERE status IN ('canceled','closed','fraud','order_refunded','refund')
    GROUP BY month_date
) t
GROUP BY month_date
ORDER BY month_date;

