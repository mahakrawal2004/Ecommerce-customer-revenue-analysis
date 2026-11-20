-- database setup and csv import template
-- update the file paths before running the load data statements

create database if not exists ecommerce_project;
use ecommerce_project;

create table if not exists customers (
    customer_id varchar(50),
    customer_unique_id varchar(50),
    customer_zip_code_prefix int,
    customer_city varchar(100),
    customer_state varchar(10)
);

create table if not exists orders (
    order_id varchar(50),
    customer_id varchar(50),
    order_status varchar(30),
    order_purchase_timestamp datetime,
    order_approved_at datetime,
    order_delivered_carrier_date datetime,
    order_delivered_customer_date datetime,
    order_estimated_delivery_date datetime
);

create table if not exists order_items (
    order_id varchar(50),
    order_item_id int,
    product_id varchar(50),
    seller_id varchar(50),
    shipping_limit_date datetime,
    price decimal(10,2),
    freight_value decimal(10,2)
);

create table if not exists order_payments (
    order_id varchar(50),
    payment_sequential int,
    payment_type varchar(50),
    payment_installments int,
    payment_value decimal(10,2)
);

create table if not exists order_reviews (
    review_id varchar(50),
    order_id varchar(50),
    review_score int,
    review_comment_title text,
    review_comment_message text,
    review_creation_date datetime,
    review_answer_timestamp datetime
);

create table if not exists products (
    product_id varchar(50),
    product_category_name varchar(100),
    product_name_lenght int,
    product_description_lenght int,
    product_photos_qty int,
    product_weight_g int,
    product_length_cm int,
    product_height_cm int,
    product_width_cm int
);

create table if not exists sellers (
    seller_id varchar(50),
    seller_zip_code_prefix int,
    seller_city varchar(100),
    seller_state varchar(10)
);

create table if not exists geolocation (
    geolocation_zip_code_prefix int,
    geolocation_lat decimal(10,7),
    geolocation_lng decimal(10,7),
    geolocation_city varchar(100),
    geolocation_state varchar(10)
);

create table if not exists product_category_translation (
    product_category_name varchar(100),
    product_category_name_english varchar(100)
);

-- csv import examples
-- local_infile must be enabled before using these statements
-- replace c:/path/to/data/ with the folder containing the csv files

/*
load data local infile 'c:/path/to/data/olist_customers_dataset.csv'
into table customers
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);

load data local infile 'c:/path/to/data/olist_orders_dataset.csv'
into table orders
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at,
 order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date);

load data local infile 'c:/path/to/data/olist_order_items_dataset.csv'
into table order_items
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value);

load data local infile 'c:/path/to/data/olist_order_payments_dataset.csv'
into table order_payments
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(order_id, payment_sequential, payment_type, payment_installments, payment_value);

load data local infile 'c:/path/to/data/olist_order_reviews_dataset.csv'
into table order_reviews
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(review_id, order_id, review_score, review_comment_title, review_comment_message,
 review_creation_date, review_answer_timestamp);

load data local infile 'c:/path/to/data/olist_products_dataset.csv'
into table products
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(product_id, product_category_name, product_name_lenght, product_description_lenght,
 product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm);

load data local infile 'c:/path/to/data/olist_sellers_dataset.csv'
into table sellers
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(seller_id, seller_zip_code_prefix, seller_city, seller_state);

load data local infile 'c:/path/to/data/olist_geolocation_dataset.csv'
into table geolocation
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state);

load data local infile 'c:/path/to/data/product_category_name_translation.csv'
into table product_category_translation
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(product_category_name, product_category_name_english);
*/
