-- ecommerce customer and revenue analysis
-- olist brazilian ecommerce dataset

use ecommerce_project;

-- =========================================================
-- data validation
-- =========================================================

select 'customers' as table_name, count(*) as row_count from customers
union all
select 'orders', count(*) from orders
union all
select 'order_items', count(*) from order_items
union all
select 'order_payments', count(*) from order_payments
union all
select 'order_reviews', count(*) from order_reviews
union all
select 'products', count(*) from products
union all
select 'sellers', count(*) from sellers
union all
select 'geolocation', count(*) from geolocation
union all
select 'product_category_translation', count(*) from product_category_translation;


-- =========================================================
-- 1. order date range
-- =========================================================

select
    min(order_purchase_timestamp) as first_order,
    max(order_purchase_timestamp) as last_order
from orders;


-- =========================================================
-- 2. order status breakdown
-- =========================================================

select
    order_status,
    count(*) as order_count
from orders
group by order_status
order by order_count desc;


-- =========================================================
-- 3. total product revenue, freight, and combined revenue
-- =========================================================

select
    round(sum(price), 2) as product_revenue,
    round(sum(freight_value), 2) as freight_revenue,
    round(sum(price + freight_value), 2) as total_revenue
from order_items;


-- =========================================================
-- 4. monthly revenue trend
-- =========================================================

select
    date_format(o.order_purchase_timestamp, '%Y-%m') as order_month,
    round(sum(oi.price + oi.freight_value), 2) as total_revenue
from orders o
join order_items oi
    on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by date_format(o.order_purchase_timestamp, '%Y-%m')
order by order_month;


-- =========================================================
-- 5. average order value
-- calculate order totals first so multi-item orders are not double counted
-- =========================================================

select
    round(avg(order_total), 2) as average_order_value
from (
    select
        order_id,
        sum(price + freight_value) as order_total
    from order_items
    group by order_id
) as order_totals;


-- =========================================================
-- 6. top 10 product categories by revenue
-- =========================================================

select
    coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as category,
    round(sum(oi.price), 2) as product_revenue
from order_items oi
join products p
    on oi.product_id = p.product_id
left join product_category_translation t
    on p.product_category_name = t.product_category_name
group by coalesce(t.product_category_name_english, p.product_category_name, 'unknown')
order by product_revenue desc
limit 10;


-- =========================================================
-- 7. sales by customer state
-- =========================================================

select
    c.customer_state,
    count(distinct o.order_id) as orders,
    round(sum(oi.price + oi.freight_value), 2) as total_revenue
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by c.customer_state
order by total_revenue desc;


-- =========================================================
-- 8. payment method breakdown
-- =========================================================

select
    payment_type,
    count(*) as payment_count,
    round(sum(payment_value), 2) as payment_value
from order_payments
group by payment_type
order by payment_value desc;


-- =========================================================
-- 9. average delivery time for delivered orders
-- =========================================================

select
    round(avg(datediff(order_delivered_customer_date, order_purchase_timestamp)), 2)
        as average_delivery_days
from orders
where order_status = 'delivered'
  and order_delivered_customer_date is not null;


-- =========================================================
-- 10. on-time vs late delivery
-- =========================================================

select
    case
        when order_delivered_customer_date <= order_estimated_delivery_date then 'on time'
        else 'late'
    end as delivery_status,
    count(*) as orders
from orders
where order_status = 'delivered'
  and order_delivered_customer_date is not null
  and order_estimated_delivery_date is not null
group by delivery_status;


-- =========================================================
-- 11. review score by delivery performance
-- =========================================================

select
    case
        when o.order_delivered_customer_date is null then 'not delivered'
        when o.order_delivered_customer_date <= o.order_estimated_delivery_date then 'on time'
        else 'late'
    end as delivery_status,
    round(avg(r.review_score), 2) as average_review_score,
    count(*) as review_count
from orders o
join order_reviews r
    on o.order_id = r.order_id
group by delivery_status
order by average_review_score desc;


-- =========================================================
-- 12. repeat customers
-- customer_unique_id identifies the same customer across different orders
-- =========================================================

select
    count(*) as repeat_customers
from (
    select
        c.customer_unique_id
    from customers c
    join orders o
        on c.customer_id = o.customer_id
    group by c.customer_unique_id
    having count(distinct o.order_id) > 1
) as repeat_customer_list;


-- =========================================================
-- 13. top 10 repeat customers by number of orders
-- =========================================================

select
    c.customer_unique_id,
    count(distinct o.order_id) as order_count
from customers c
join orders o
    on c.customer_id = o.customer_id
group by c.customer_unique_id
having count(distinct o.order_id) > 1
order by order_count desc
limit 10;


-- =========================================================
-- 14. top 10 sellers by product revenue
-- =========================================================

select
    s.seller_id,
    s.seller_state,
    count(distinct oi.order_id) as orders,
    round(sum(oi.price), 2) as product_revenue
from sellers s
join order_items oi
    on s.seller_id = oi.seller_id
group by s.seller_id, s.seller_state
order by product_revenue desc
limit 10;


-- =========================================================
-- 15. category ranking using a window function
-- =========================================================

with category_revenue as (
    select
        coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as category,
        sum(oi.price) as revenue
    from order_items oi
    join products p
        on oi.product_id = p.product_id
    left join product_category_translation t
        on p.product_category_name = t.product_category_name
    group by coalesce(t.product_category_name_english, p.product_category_name, 'unknown')
)
select
    category,
    round(revenue, 2) as revenue,
    rank() over (order by revenue desc) as revenue_rank
from category_revenue
order by revenue_rank;


-- =========================================================
-- 16. month-over-month revenue change using lag
-- =========================================================

with monthly_revenue as (
    select
        date_format(o.order_purchase_timestamp, '%Y-%m') as order_month,
        sum(oi.price + oi.freight_value) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    where o.order_status = 'delivered'
    group by date_format(o.order_purchase_timestamp, '%Y-%m')
),
revenue_change as (
    select
        order_month,
        revenue,
        lag(revenue) over (order by order_month) as previous_month_revenue
    from monthly_revenue
)
select
    order_month,
    round(revenue, 2) as revenue,
    round(previous_month_revenue, 2) as previous_month_revenue,
    round(
        ((revenue - previous_month_revenue) / previous_month_revenue) * 100,
        2
    ) as month_over_month_change
from revenue_change
order by order_month;


-- =========================================================
-- 17. stored procedure: revenue for a selected customer state
-- =========================================================

delimiter //

drop procedure if exists get_state_revenue //

create procedure get_state_revenue(in state_code varchar(2))
begin
    select
        c.customer_state,
        count(distinct o.order_id) as orders,
        round(sum(oi.price + oi.freight_value), 2) as total_revenue
    from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
    where c.customer_state = state_code
      and o.order_status = 'delivered'
    group by c.customer_state;
end //

delimiter ;

-- example:
-- call get_state_revenue('SP');


-- =========================================================
-- 18. trigger example: order status audit
-- this uses a copy table so the original dataset is not changed
-- =========================================================

drop table if exists orders_test;

create table orders_test as
select *
from orders
limit 1000;

drop table if exists order_status_audit;

create table order_status_audit (
    audit_id int auto_increment primary key,
    order_id varchar(50),
    old_status varchar(30),
    new_status varchar(30),
    changed_at datetime
);

delimiter //

drop trigger if exists after_order_status_update //

create trigger after_order_status_update
after update on orders_test
for each row
begin
    if old.order_status <> new.order_status then
        insert into order_status_audit (
            order_id,
            old_status,
            new_status,
            changed_at
        )
        values (
            new.order_id,
            old.order_status,
            new.order_status,
            now()
        );
    end if;
end //

delimiter ;

-- example test:
-- update orders_test
-- set order_status = 'canceled'
-- where order_id = (
--     select order_id
--     from (
--         select order_id
--         from orders_test
--         limit 1
--     ) as x
-- );

-- select * from order_status_audit;
