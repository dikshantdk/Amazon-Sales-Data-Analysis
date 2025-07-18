# 📊 Amazon Sales Data Analysis – SQL Project

Welcome to the **Amazon Sales Data Analysis** project! This project uses **MySQL** to analyze an e-commerce dataset and extract business insights related to customer behavior, product performance, revenue trends, and more.

---

## 📁 Project Overview

The goal of this project is to:
- Perform **data cleaning and transformation**
- Write and optimize **SQL queries**
- Generate **descriptive analytics**
- Identify **trends and patterns**
- Support **decision-making** with data-driven insights

---

## 🧾 Dataset Description

The dataset contains simulated Amazon sales records with the following columns:

| Column Name        | Description                               |
|--------------------|-------------------------------------------|
| Invoice_ID         | Unique identifier for each transaction    |
| Branch             | Store location (A, B, or C)               |
| City               | Name of the city where branch is located  |
| Customer_Type      | Type of customer (Member or Normal)       |
| Gender             | Customer gender                           |
| Product_Line       | Type of product purchased                 |
| Unit_Price         | Price per product unit                    |
| Quantity           | Number of units purchased                 |
| Tax_5%             | VAT calculated at 5%                      |
| Total              | Final bill amount                         |
| Date               | Date of transaction                       |
| Time               | Time of transaction                       |
| Payment            | Payment method used                       |
| Cogs               | Cost of goods sold                        |
| Gross_Margin_%     | Gross margin percentage                   |
| Rating             | Customer rating of the experience         |

---

## 🔧 Tools Used

- **SQL (MySQL)**
- **MySQL Workbench**
- *(Optional for extension)* Power BI or Excel for data visualization

---

## 📌 Key SQL Tasks Performed

### 🔹 General Sales Analysis
- Total sales and revenue by city and branch
- Top-performing product lines by quantity and revenue
- Monthly and daily sales trends

### 🔹 Customer Behavior Analysis
- Gender distribution across branches
- Most common customer types
- Product preferences by gender and customer type

### 🔹 Time-Based Analysis
- Added `timeofday` column to analyze sales during **Morning**, **Afternoon**, and **Evening**
- Identified peak times of purchase activity

### 🔹 Rating Analysis
- Average customer rating by day of the week
- Rating distribution by city and branch

### 🔹 Financial Metrics
- Calculated VAT and total revenue per branch
- Identified customer types contributing the highest revenue

---

## 📈 Sample Insights

- 🛍️ **Most Purchased Product Line**: Food and Beverages
- 💳 **Preferred Payment Method**: Cash
- 🧑‍🤝‍🧑 **Predominant Customer Type**: Member
- 🌆 **City with Highest Sales**: Naypyitaw
- ⭐ **Day with Highest Average Rating**: Monday


---

## 📊 Optional: Power BI Dashboard

You can extend this project by connecting MySQL to Power BI to create interactive visual dashboards showing:
- Revenue by branch/product line
- Heatmap of product preference by gender
- Ratings over time

---

