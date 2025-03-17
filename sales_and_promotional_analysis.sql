{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "033e9dc1-a323-4783-8e4a-cfe9f92566c4",
   "metadata": {},
   "outputs": [],
   "source": [
    " SELECT store_id,\n",
    " ROUND((SUM(CASE\n",
    " WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * (`quantity_sold(after_promo)` * 2)\n",
    " WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`\n",
    " WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`\n",
    " WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`\n",
    " WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)`\n",
    " ELSE 0\n",
    " END) - SUM(base_price * `quantity_sold(before_promo)`)) / SUM(base_price * `quantity_sold(before_promo)`) * 100,2) AS `IR%`\n",
    " FROM fact_events\n",
    " GROUP BY store_id\n",
    " ORDER BY `IR%` DESC\n",
    " LIMIT 10;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "df5ac8cd-b5d9-4c7c-83e5-ef53255a1e76",
   "metadata": {},
   "outputs": [],
   "source": [
    "     campaign_name,\n",
    "     ROUND(SUM(base_price * `quantity_sold(before_promo)`) / 1000000,2) AS total_revenue_before_promotion,\n",
    "     ROUND(SUM(CASE\n",
    "            WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * (`quantity_sold(after_promo)` * 2)\n",
    "            WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`\n",
    "            WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`\n",
    "            WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`\n",
    "            WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)` END) / 1000000,2) AS total_revenue_after_promotion\n",
    "     FROM\n",
    "     fact_events\n",
    "     JOIN\n",
    "     dim_campaigns USING (campaign_id)\n",
    "     GROUP BY campaign_name;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "8ec24d11-b015-49fa-97bc-536ab01184a4",
   "metadata": {},
   "outputs": [],
   "source": [
    " select store_id,\n",
    " sum(case\n",
    " when promo_type = 'BOGOF' then base_price * 0.5 * (`quantity_sold(after_promo)` * 2)\n",
    " when promo_type = '500 Cashback' then (base_price - 500) * `quantity_sold(after_promo)`\n",
    " when promo_type = '50% OFF' then base_price * 0.5 * `quantity_sold(after_promo)`\n",
    " when promo_type = '33% OFF' then base_price * 0.67 * `quantity_sold(after_promo)`\n",
    " when promo_type = '25% OFF' then base_price * 0.75 * `quantity_sold(after_promo)`\n",
    " else 0\n",
    " end) - sum(base_price * `quantity_sold(before_promo)`) as incremental_revenue\n",
    " from fact_events\n",
    " group by store_id\n",
    " order by incremental_revenue desc\n",
    " limit 10;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "1d33a4a2-1d5b-45be-99aa-28e93a85f890",
   "metadata": {},
   "outputs": [],
   "source": [
    " select promo_type,\n",
    " sum(case\n",
    " when promo_type = 'BOGOF' then base_price * 0.5 * (`quantity_sold(after_promo)` * 2)\n",
    " when promo_type = '500 Cashback' then (base_price - 500) * `quantity_sold(after_promo)`\n",
    " when promo_type = '50% OFF' then base_price * 0.5 * `quantity_sold(after_promo)`\n",
    " when promo_type = '33% OFF' then base_price * 0.67 * `quantity_sold(after_promo)`\n",
    " when promo_type = '25% OFF' then base_price * 0.75 * `quantity_sold(after_promo)`\n",
    " else 0\n",
    " end) - sum(base_price * `quantity_sold(before_promo)`) as incremental_revenue\n",
    " from fact_events\n",
    " group by promo_type\n",
    " order by incremental_revenue desc\n",
    " limit 2;\n"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.12.6"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
