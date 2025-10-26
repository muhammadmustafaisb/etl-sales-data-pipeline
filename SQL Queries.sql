-- 1: Total sales by region and category.
SELECT 
    t.region,
    p.product_category,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.quantity) AS total_quantity_sold,
    SUM(t.total_price) AS total_sales,
    AVG(t.total_price) AS avg_transaction_value,
    ROUND(AVG(t.discount), 2) AS avg_discount_percentage
FROM 
    Transactions t
INNER JOIN 
    Products p ON t.product_id = p.product_id
GROUP BY 
    t.region, p.product_category
ORDER BY 
    total_sales DESC, t.region, p.product_category;


-- 2: Top 5 products by total revenue
SELECT TOP 5
    p.product_id,
    p.product_name,
    p.product_category,
    p.price AS unit_price,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.quantity) AS total_units_sold,
    SUM(t.total_price) AS total_revenue,
    ROUND(AVG(t.discount), 2) AS avg_discount_applied
FROM 
    Products p
INNER JOIN 
    Transactions t ON p.product_id = t.product_id
GROUP BY 
    p.product_id, p.product_name, p.product_category, p.price
ORDER BY 
    total_revenue DESC;


-- 3: Monthly sales trend
SELECT 
    YEAR(date) AS sales_year,
    MONTH(date) AS sales_month,
    DATENAME(MONTH, date) AS month_name,
    COUNT(transaction_id) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    SUM(total_price) AS total_revenue,
    ROUND(AVG(total_price), 2) AS avg_transaction_value,
    ROUND(AVG(discount), 2) AS avg_discount_percentage
FROM 
    Transactions
WHERE 
    date IS NOT NULL
GROUP BY 
    YEAR(date), MONTH(date), DATENAME(MONTH, date)
ORDER BY 
    sales_year DESC, sales_month DESC;


-- 4: Average discount percentage per region
SELECT 
    region,
    COUNT(transaction_id) AS total_transactions,
    ROUND(AVG(discount), 2) AS avg_discount_percentage,
    ROUND(MIN(discount), 2) AS min_discount,
    ROUND(MAX(discount), 2) AS max_discount,
    SUM(total_price) AS total_sales,
    ROUND(SUM(total_price * discount / 100), 2) AS total_discount_amount,
    ROUND(AVG(total_price), 2) AS avg_transaction_value
FROM 
    Transactions
WHERE 
    region IS NOT NULL
GROUP BY 
    region
ORDER BY 
    avg_discount_percentage DESC;


-- 5: Number of transactions with total_value > $1000
SELECT 
    COUNT(*) AS high_value_transactions,
    SUM(total_price) AS total_high_value_revenue,
    ROUND(AVG(total_price), 2) AS avg_high_value_transaction,
    ROUND(MIN(total_price), 2) AS min_high_value_transaction,
    ROUND(MAX(total_price), 2) AS max_high_value_transaction,
    ROUND(AVG(discount), 2) AS avg_discount_percentage
FROM 
    Transactions
WHERE 
    total_price > 1000;
