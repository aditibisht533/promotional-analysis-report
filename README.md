# **Promotional Analysis Report**  
**Domain:** FMCG  
**Function:** Sales / Promotions  

## **Project Description**  
AtliQ Mart, a retail giant with over 50 supermarkets in southern India, conducted massive promotions on AtliQ-branded products during Diwali 2023 and Sankranti 2024. The sales director seeks insights into which promotions performed well and which did not, aiding future promotional strategies.  

---

## **SQL Queries & Insights**  

### **1. Identify High-Value BOGOF Promotions**  
**Objective:** Identify products with a base price above ₹500 that were promoted under the "BOGOF" (Buy One Get One Free) scheme.  

```sql
SELECT DISTINCT f.product_code, p.product_name, base_price, f.promo_type
FROM fact_events AS f 
JOIN dim_products AS p ON f.product_code = p.product_code
WHERE base_price > 500 AND promo_type = "BOGOF";
```

---

### **2. Store Distribution by City**  
**Objective:** Determine the number of stores per city and identify cities with the highest store count.  

```sql
SELECT City, COUNT(store_id) AS Total_Stores
FROM dim_stores
GROUP BY city
ORDER BY Total_Stores DESC;
```

---

### **3. Revenue Before and After Promotions**  
**Objective:** Compare total revenue before and after promotions across different campaigns.  

```sql
SELECT c.campaign_name, 
ROUND(SUM(f.base_price * f.`quantity_sold(before_promo)`) / 1000000,2) AS total_revenue_before_promotion,
ROUND(SUM(CASE
    WHEN f.promo_type = 'BOGOF' THEN f.base_price * 0.5 * (f.`quantity_sold(after_promo)` * 2)
    WHEN f.promo_type = '500 Cashback' THEN (f.base_price - 500) * f.`quantity_sold(after_promo)`
    WHEN f.promo_type = '50% OFF' THEN f.base_price * 0.5 * f.`quantity_sold(after_promo)`
    WHEN f.promo_type = '33% OFF' THEN f.base_price * 0.67 * f.`quantity_sold(after_promo)`
    WHEN f.promo_type = '25% OFF' THEN f.base_price * 0.75 * f.`quantity_sold(after_promo)` 
END) / 1000000,2) AS total_revenue_after_promotion
FROM fact_events AS f
JOIN dim_campaigns AS c ON f.campaign_id = c.campaign_id
GROUP BY c.campaign_name;
```

---

### **4. Category-Wise Sales Uplift (ISU%) for Diwali**  
**Objective:** Rank product categories based on Incremental Sales Uplift (`ISU%`).  

```sql
WITH Diwali_campaign_sale AS (
    SELECT p.category,
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
    GROUP BY p.category
)
SELECT Category, `ISU%`, RANK() OVER(ORDER BY `ISU%` DESC) AS rank_order 
FROM Diwali_campaign_sale;
```

---

### **5. Top 5 Products with Highest Incremental Revenue (IR%)**  
**Objective:** Identify the top 5 products with the highest Incremental Revenue (`IR%`).  

```sql
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
```

---

## **Key Insights**  

- **BOGOF promotions** were applied to products priced above ₹500, making them a high-impact strategy.  
- **City-wise store distribution** helps in localizing promotions effectively.  
- **Total revenue impact** before and after promotions provides insight into campaign effectiveness.  
- **Category-wise sales uplift (`ISU%`)** ranks categories based on their performance during Diwali promotions.  
- **Top 5 products** with the highest incremental revenue (`IR%`) indicate which items benefited the most from promotions.  

This analysis aids **AtliQ Mart** in making data-driven decisions for future promotional strategies. 🚀  
