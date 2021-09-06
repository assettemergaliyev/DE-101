-- Используя данные Sample - Superstore.xls посчитать:

-- total sales
select sum(sales) as total_sales
from orders
-- 2 297 200,8603

-- total profit
select sum(profit) as total_profit
from orders
-- 286 397,0217

-- profit ratio
select sum(profit) / sum(sales) * 100 as profit_ratio
from orders
-- 12,46%

-- profit per order
select 
order_id,
profit / quantity as profit_per_order
from orders

-- sales per customer
select 
customer_name,
sum(sales) as sales_per_customer
from orders
group by 1
order by sales_per_customer desc

-- avg. discount
select avg(discount)
from orders
-- 0,15

-- sales by segment
select distinct 
segment,
sum(sales) as sales_by_segment
from orders
group by segment 
-- Consumer - 1161401.3450; Corporate - 706146.3668, Home Office - 429653.1485

-- sales by product category
select distinct 
category,
sum(sales) as sales_by_category
from orders
group by category 
order by sales_by_category desc
-- Technology - 836154.0330, Furniture - 741999.7953, Office Supplies - 719047.0320

-- sales by ship mode 
select distinct 
ship_mode,
sum(sales) as sales_by_shipmode
from orders
group by ship_mode 
order by sales_by_shipmode desc
-- Standard Class - 1358215.7430, Second Class - 459193.5694, First Class - 351428.4229, Same Day - 128363.1250

-- random task 1
select distinct 
subcategory,
sum(sales) as sales_by_subcategory
from orders
where ship_mode = 'Standard Class'
group by subcategory 
order by sales_by_subcategory desc

-- random task 2
select distinct 
subcategory,
state,
sum(profit) as profit_by_subcategory
from orders
where ship_mode in ('Standard Class', 'Second Class')
group by subcategory, state 
having sum(profit) > 1000
order by profit_by_subcategory desc

select *
from orders