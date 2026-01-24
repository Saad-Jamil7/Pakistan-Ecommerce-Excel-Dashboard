SELECT 
    category_name_1,
    # Revenue
    SUM(CASE 
            WHEN status IN ('complete','received') 
            THEN grand_total 
        END) AS revenue,

    -- Lost order rate
    COUNT(DISTINCT CASE 
            WHEN status IN ('canceled','closed','fraud','order_refunded','refund') 
            THEN increment_id 
        END)
    / NULLIF(COUNT(DISTINCT increment_id), 0) * 100 AS lost_order_rate

FROM cleaned_ecommerce
GROUP BY category_name_1
ORDER BY revenue DESC;