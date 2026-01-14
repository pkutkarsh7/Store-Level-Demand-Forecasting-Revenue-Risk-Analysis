
select * from [walmart_sales].[dbo].[sales_fact]

select count(*) as total_rows
From [walmart_sales].[dbo].[sales_fact]

SELECT COUNT(DISTINCT store_id) AS total_stores
FROM [walmart_sales].[dbo].[sales_fact];

EXEC sp_rename 'sales_fact.store', 'store_id', 'COLUMN';

SELECT
	MIN([date]) as start_date,
	MAX([date]) as end_date
FROM sales_fact

select
	store_id,
	count(*) as weeks_of_data
from sales_fact
group by store_id 
order by store_id

SELECT
    SUM(CASE WHEN weekly_sales IS NULL THEN 1 ELSE 0 END) AS missing_weekly_sales,
    SUM(CASE WHEN temperature IS NULL THEN 1 ELSE 0 END) AS missing_temperature,
    SUM(CASE WHEN fuel_price IS NULL THEN 1 ELSE 0 END) AS missing_fuel_price,
    SUM(CASE WHEN cpi IS NULL THEN 1 ELSE 0 END) AS missing_cpi,
    SUM(CASE WHEN unemployment IS NULL THEN 1 ELSE 0 END) AS missing_unemployment
FROM sales_fact;




SELECT 
    holiday_flag,
    COUNT(*) AS record_count
FROM sales_fact
GROUP BY holiday_flag;



SELECT
    MIN(weekly_sales) AS min_sales,
    MAX(weekly_sales) AS max_sales,
    AVG(weekly_sales) AS avg_sales
FROM sales_fact;




SELECT 
    store_id,
    [date],
    COUNT(*) AS duplicate_count
FROM sales_fact
GROUP BY store_id, [date]
HAVING COUNT(*) > 1;



SELECT
    store_id,
    YEAR([date])  AS sales_year,
    MONTH([date]) AS sales_month,
    SUM(weekly_sales) AS monthly_sales
FROM sales_fact
GROUP BY
    store_id,
    YEAR([date]),
    MONTH([date])
ORDER BY
    store_id,
    sales_year,
    sales_month;






    WITH yearly_sales AS (
    SELECT
        store_id,
        YEAR([date]) AS sales_year,
        SUM(weekly_sales) AS yearly_sales
    FROM sales_fact
    GROUP BY
        store_id,
        YEAR([date])
)
SELECT
    store_id,
    sales_year,
    yearly_sales,
    LAG(yearly_sales) OVER (PARTITION BY store_id ORDER BY sales_year) AS prev_year_sales,
    ROUND(
        100.0 * (yearly_sales - LAG(yearly_sales) OVER (PARTITION BY store_id ORDER BY sales_year))
        / NULLIF(LAG(yearly_sales) OVER (PARTITION BY store_id ORDER BY sales_year), 0),
        2
    ) AS yoy_growth_pct
FROM yearly_sales
ORDER BY store_id, sales_year;
