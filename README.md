🛒 E-Commerce Analytics SQL Project

📌 Overview

This project performs end-to-end analysis of an e-commerce platform using SQL.
It focuses on understanding user behavior, conversion funnels, marketing performance, and customer value.
The goal is to simulate real-world business analysis and generate actionable insights from raw data.


🧰 Tools & Technologies

SQL (MySQL)
Window Functions (LAG, DENSE_RANK, PERCENT_RANK)
Common Table Expressions (CTEs)
Data Modeling (multi-table schema)

📂 Dataset Structure

The project uses a multi-table dataset:
events → User interactions (clicks, views, purchases, bounce)
products → Product details (category, price, brand)
transactions → Purchase data (revenue, quantity, refunds)
campaigns → Marketing campaign data
customers → Customer demographics and acquisition data


📊 Key Analyses Performed

- Funnel Analysis
Analyzed user flow across event stages
Identified major drop-offs in the funnel

- Bounce Rate Calculation
Calculated total sessions vs bounce sessions
Measured overall engagement quality

- Conversion Rate Analysis
Used window functions (LAG) to track stage-to-stage conversion
Built funnel conversion metrics

- Category-Level Funnel
Compared conversion across product categories
Identified high vs low performing categories

- A/B Testing Analysis
Compared experiment groups vs control group
Measured purchase conversion performance

- Revenue Analysis
Aggregated revenue by product and category
Identified top-performing products

- Campaign Performance
Analyzed revenue by marketing channel
Ranked channels using DENSE_RANK

- Retention & Segmentation
Classified customers using PERCENT_RANK
Segmented users into A/B/C tiers based on engagement

- Customer Lifetime Value (LTV)
Calculated total revenue per customer
Identified high-value customers

🔥 Key Business Insights

~26% overall bounce rate → Indicates UX or landing page issues
Significant drop-offs observed in funnel stages
Electronics category shows highest conversion
Beauty category underperforms in conversion
Control group outperformed experiment groups in A/B testing
Affiliate marketing drives highest revenue and customer acquisition
Social media channels show lower ROI
High-value customers identified for targeted retention strategies


💡 Skills Demonstrated

Writing complex SQL queries
Using window functions for business metrics
Building multi-table joins
Translating data into business insights
Performing product and marketing analytics


🚀 How to Run This Project

Create database:
CREATE DATABASE ecom;
USE ecom;
Run schema setup:
Execute 00_schema_setup.sql
Run analysis queries:
Execute files inside /sql_queries folder


📁 Project Structure

ecommerce-analytics-sql-project/
│
├── dataset/
├── sql_queries/
├── insights/
└── README.md
