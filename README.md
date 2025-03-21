# promotional-analysis-report
Domain: FMCG Function: Sales / Promotions

Project Description:

AtliQ Mart is a retail giant with over 50 supermarkets in the southern region of India. All their 50 stores ran a massive promotion during the Diwali 2023 and Sankranti 2024 (festive time in India) on their AtliQ branded products. Now the sales director wants to understand which promotions did well and which did not so that they can make informed decisions for their next promotional period.


1st Business Question

SELECT DISTINCT f.product_code, p.product_name, base_price, f.promo_type
FROM fact_events AS f 
JOIN dim_products AS p ON f.product_code = p.product_code
WHERE base_price > 500 AND promo_type = "BOGOF" ;


2nd Business Question

SELECT City, COUNT(store_id) AS Total_Stores
FROM dim_stores
GROUP BY city
ORDER BY Total_Stores DESC;


3rd Business Question

SELECT c.campaign_name, ROUND(SUM(f.base_price * f.`quantity_sold(before_promo)`) / 1000000,2) AS total_revenue_before_promotion,
ROUND(SUM(CASE
WHEN f.promo_type = 'BOGOF' THEN f.base_price * 0.5 * (f.`quantity_sold(after_promo)` * 2)
WHEN f.promo_type = '500 Cashback' THEN (f.base_price - 500) * f.`quantity_sold(after_promo)`
WHEN f.promo_type = '50% OFF' THEN f.base_price * 0.5 * f.`quantity_sold(after_promo)`
WHEN f.promo_type = '33% OFF' THEN f.base_price * 0.67 * f.`quantity_sold(after_promo)`
WHEN f.promo_type = '25% OFF' THEN f.base_price * 0.75 * f.`quantity_sold(after_promo)` END) / 1000000,2) AS total_revenue_after_promotion
FROM fact_events AS f
JOIN dim_campaigns AS c ON f.campaign_id = c.campaign_id
GROUP BY c.campaign_name;


4th Business Question 

SELECT Category, `ISU%`, 
RANK() OVER(ORDER BY `ISU%` DESC) AS rank_order 
FROM
(SELECT p.category,
ROUND(SUM((
CASE 
WHEN f.promo_type = "BOGOF" THEN f.`quantity_sold(after_promo)`*2
ELSE f.`quantity_sold(after_promo)`
END
- f.`quantity_sold(before_promo)`) * 100)
/ SUM(f.`quantity_sold(before_promo)`),2) AS `ISU%` 
FROM fact_events AS f
JOIN dim_products AS p ON f.product_code = p.product_code
JOIN dim_campaigns AS c ON f.campaign_id = c.campaign_id
WHERE c.campaign_name = "Diwali"
GROUP BY p.category) AS Diwali_campaign_sale;


5th Business Question

SELECT p.product_name, p.category,
ROUND((SUM(CASE
WHEN f.promo_type = 'BOGOF' THEN f.base_price * 0.5 * (f.`quantity_sold(after_promo)` * 2)
WHEN f.promo_type = '500 Cashback' THEN (f.base_price - 500) * f.`quantity_sold(after_promo)`
WHEN f.promo_type = '50% OFF' THEN f.base_price * 0.5 * f.`quantity_sold(after_promo)`
WHEN f.promo_type = '33% OFF' THEN f.base_price * 0.67 * f.`quantity_sold(after_promo)`
WHEN f.promo_type = '25% OFF' THEN f.base_price * 0.75 * f.`quantity_sold(after_promo)`
ELSE 0
END) 
- SUM(f.base_price * f.`quantity_sold(before_promo)`)) / SUM(f.base_price * f.`quantity_sold(before_promo)`) * 100,2) AS `IR%`
FROM fact_events AS f
JOIN dim_products AS p ON f.product_code = p.product_code
GROUP BY p.product_name, p.category
ORDER BY `IR%` DESC
LIMIT 5;
