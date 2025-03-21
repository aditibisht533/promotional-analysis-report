# promotional-analysis-report
Domain: FMCG Function: Sales / Promotions

Project Description:

AtliQ Mart is a retail giant with over 50 supermarkets in the southern region of India. All their 50 stores ran a massive promotion during the Diwali 2023 and Sankranti 2024 (festive time in India) on their AtliQ branded products. Now the sales director wants to understand which promotions did well and which did not so that they can make informed decisions for their next promotional period.


1st Business Question
List of products

SELECT DISTINCT f.product_code, p.product_name, base_price, f.promo_type
FROM fact_events AS f 
JOIN dim_products AS p ON f.product_code = p.product_code
WHERE base_price > 500 AND promo_type = "BOGOF" ;
