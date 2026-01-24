#revenue by sku
SELECT sku, SUM(grand_total) as revenue
FROM cleaned_ecommerce
WHERE status = 'complete' or status = 'received'
GROUP BY sku
ORDER BY revenue DESC
LIMIT 5;

#cancel count by sku
SELECT sku, COUNT(*) AS cancel_count
FROM cleaned_ecommerce
WHERE status IN (
    'canceled',
    'fraud',
    'order_refunded',
    'refund',
    'closed'
)
GROUP BY sku
ORDER BY cancel_count DESC
LIMIT 10;


