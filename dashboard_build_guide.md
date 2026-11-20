# Power BI Dashboard Build Guide

This file is the build checklist for the Power BI part of the project.

## Page 1: Overview

### KPI cards
- Total Revenue
- Total Orders
- Average Order Value
- Average Review Score

### Visuals
- Line chart: Revenue by Month
- Bar chart: Top 10 Product Categories by Revenue
- Filled map or bar chart: Revenue by Customer State
- Donut chart: Payment Type Distribution

### Slicers
- Order Year
- Customer State
- Product Category
- Order Status

## Page 2: Delivery & Customer Experience

### KPI cards
- Average Delivery Days
- Late Orders
- On-Time Orders

### Visuals
- Column chart: On-Time vs Late Orders
- Bar chart: Average Review Score by Delivery Status
- Line chart: Average Review Score by Month
- Bar chart: States with the Longest Average Delivery Time

## Page 3: Customers & Sellers

### KPI cards
- Unique Customers
- Repeat Customers
- Active Sellers

### Visuals
- Bar chart: Top 10 Sellers by Revenue
- Bar chart: Top 10 Customer States by Revenue
- Table: Top Repeat Customers
- Bar chart: Category Revenue Ranking

## Suggested Power BI Measures

Use measures instead of calculated columns where possible.

```dax
total revenue =
sum(order_items[price]) + sum(order_items[freight_value])

product revenue =
sum(order_items[price])

freight revenue =
sum(order_items[freight_value])

total orders =
distinctcount(orders[order_id])

average review score =
average(order_reviews[review_score])
```

For average order value, create an order-level total first or calculate from an order summary table so multi-item orders are not double counted.

## Formatting

Keep the dashboard simple:
- one font
- consistent number formatting
- BRL currency formatting for revenue
- no unnecessary decorative graphics
- clear page titles
- avoid too many colors
- keep the most important KPIs at the top

## Screenshots for GitHub

After the dashboard is finished, export or screenshot:
- Overview page
- Delivery & Customer Experience page
- Customers & Sellers page

Save them in the `images` folder and add them to the main README.
