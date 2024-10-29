CREATE OR REPLACE TABLE dim_users as(
select user_id from orders
);

CREATE OR REPLACE TABLE dim_products as(
select product_id,product_name from products
);

CREATE OR REPLACE TABLE dim_aisles as (
select aisle_id,aisle from aisles
);

CREATE OR REPLACE TABLE dim_departments as(
select department_id, department from departments
);

CREATE OR REPLACE TABLE dim_orders as(
select order_id, order_number, order_dow, order_hour_of_day, days_since_prior_order 
from orders
);

CREATE OR REPLACE TABLE fact_orders_products as(
select op.order_id, o.user_id,op.product_id,p.aisle_id,p.department_id,op.add_to_cart_order,op.reordered
from order_products op 
join orders o 
on op.order_id=o.order_id
join products p
on op.product_id=p.product_id
);

