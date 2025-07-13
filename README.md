# Car_Sales_Analysis

An end-to-end **data analytics** and **visualization** project using **SQL**, **Power BI**, and **Python (Pandas, Matplotlib, Machine Learning)** to analyze car sales in India.  
The project identifies market trends, top-selling car variants, accident risks, and predicts car prices using regression.

## Project Summary

|      Tools        |                       Purpose                                               |
|-------------------|-----------------------------------------------------------------------------|
|  SQL (MSSQL)      | Advanced queries using CTEs, window functions, CASE logic                   |
|  Power BI         | Interactive dashboard                                                       |
|  Python           | Data Cleaning, Data visualization and Car price prediction using regression |                                           

## SQL Highlights

Used SQL features like:
- `CTEs` to structure reusable logic  
- `ROW_NUMBER()` and `DENSE_RANK()` for top-N brand and model rankings  
- `CASE` for classifying price categories (Low, Medium, High)  
- `Z-Score` logic to detect price outliers  
- Year-on-year market share & accident rate by state

## Power BI dashboard

The Power BI dashboard is designed to present car sales data in a colorful, interactive, and user-friendly format across three pages: Overview, Brand Insights, and Car Characteristics.

### Dashboard Pages

####  **1. Dashboard Overview**
-  **KPI Cards**: Total Cars Sold, Total Revenue, Average Price
-  **Top Brands** by Units Sold
-  **Year-wise Sales & Revenue Trend**
-  **Ownership Distribution**

####  **2. Brand Insights**
-  **Top-Selling Variants** across brands
-  Revenue & Average Price per Variant
-  Matrix: Brand + Variant + Model

####  **3. Car Characteristics**
-  **Transmission Type** distribution (Manual vs Automatic)
-  **Car Age** visualizations
-  **Accidental Status** breakdown (Yes/No)
-  Bar/Pie charts showing category-wise counts

## Pandas

1. Exploration & Preprocessing
2. Visual Insights (using Pandas)
3. Machine Learning: Price Prediction
     - **Model**: Linear Regression (Baseline)
     - **Target Variable**: `price_inr`
       
##  Key Insights

-  Maruti, Hyundai, and Tata dominate in number of cars sold.
-  Accident rate highest in Maharashtra.
-  Diesel and manual transmission are still preferred combinations.
-  Car price depreciates consistently with age.
-  Top-selling variants vary drastically by state and brand.









