# Project Interview Notes

## 30-second explanation

I used the Olist Brazilian e-commerce dataset, which has about 100,000 orders across nine related tables. I loaded the data into MySQL and used SQL to analyze revenue, product categories, customer behavior, payments, delivery performance, reviews, and sellers. I used joins, CTEs, subqueries, and window functions, and I also added a stored procedure and a simple audit trigger because those were concepts I was learning in class. I then designed the results for a Power BI dashboard.

## Why this dataset?

I wanted something larger than a class assignment where I had to work with multiple related tables instead of one clean spreadsheet. It gave me a chance to practice joins and answer actual business questions.

## A query worth explaining

The average order value query first groups order items by `order_id` and calculates one total per order. Then it averages those totals. I did it that way because averaging individual line items would not give the real average order value.

## Why use customer_unique_id?

The `customer_id` changes across different orders in this dataset. `customer_unique_id` is the field that can be used to identify the same customer across orders, so I used it for repeat-customer analysis.

## Why use left join for category translations?

Some products do not have a matching English category translation. A left join keeps those products instead of dropping them from the analysis.

## Why use a test table for the trigger?

The dataset is historical data, so I did not want to change the original orders table just to demonstrate a trigger. I made `orders_test` and used the trigger there to log status changes safely.

## What would you improve next?

I would build a retention view that compares first-time and repeat customers over time, and I would add seller-level delivery performance to see whether certain sellers are associated with more late orders or lower reviews.
