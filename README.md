# 📊 WFM Agent Performance Analysis

An end-to-end **Workforce Management (WFM) analytics project** built using **Python, SQL, and Power BI** to analyze call center agent productivity and operational efficiency.

The project evaluates key workforce metrics such as **Average Handle Time (AHT), Occupancy, Utilization, and Shrinkage**, and introduces a **Productivity Score Model** to rank agent performance.

---

## 🚀 Project Overview

Call centers generate large volumes of operational data. However, identifying high-performing agents and operational inefficiencies can be challenging without structured analysis.

This project analyzes agent performance data and builds a **data-driven workforce analytics solution** that helps identify:

- Top performing agents
- Team productivity patterns
- Shift performance differences
- Workforce efficiency trends

---

## 🧰 Tools & Technologies

| Tool | Purpose |
|---|---|
| Python (Pandas) | Data cleaning and EDA |
| SQL (MySQL) | Data transformation, KPI calculations, Window functions |
| Power BI | Interactive dashboard and visualization |

---

## 🔄 Project Workflow

```
Python → Exploratory Data Analysis & Data Cleaning
SQL    → Data Transformation & KPI Calculation
Power BI → Interactive Dashboard Visualization
```

---

## 📂 Files in This Repository

| File | Description |
|---|---|
| `bpo_agent_dataset_final.csv` | Agent performance dataset |
| `Agents Performance_Python.ipynb` | Python EDA notebook |
| `Agents Performance SQL Quaries.sql` | SQL queries for KPI analysis |
| `Agents Performance Dashboard.pbix` | Power BI dashboard |
| `WFM-Agent-Performance-Analysis.pdf` | Project report (PDF) |
| `WFM Agent Performance Analysis.docx` | Project report (Word) |

---

## 📊 Key Workforce Metrics Calculated

### Average Handle Time (AHT)
Average time spent handling each call including talk time, hold time, and wrap-up.

### Effective Work Hours
Total productive working time after removing breaks and unavailability.

### Occupancy
Proportion of work time spent actively handling calls.
```
Occupancy = (Handle Time / Login Hours) × 100
```

### Utilization
How efficiently login time is used across all work activities.
```
Utilization = (Total Work Time / Login Hours) × 100
```

### Shrinkage
Percentage of time agents are unavailable due to breaks, training, or absenteeism.
```
Shrinkage = (Unavailable Time / Total Scheduled Time) × 100
```

---

## ⭐ Productivity Score Model

To evaluate agent performance objectively, a weighted productivity model was created:

```
Productivity Score =
  (AHT Score   × 0.4)
+ (Occupancy   × 0.3)
+ (Utilization × 0.3)
```

Agents were ranked using **SQL Window Functions** to identify top performers within each team and shift.

---

## 📈 Power BI Dashboard

The interactive dashboard provides insights including:

- Total Calls Handled
- Average Handle Time (AHT)
- Occupancy & Utilization rates
- Shrinkage Percentage
- Top Agents by Productivity Score
- Team Performance Comparison
- Shift-wise Call Analysis

**Interactive filters:** Team | Gender | Age Category | Shift | Month

### Dashboard Preview

https://github.com/hemnath126-collab/WFM-Agent-Performance-Analysis/blob/main/Dashbord%20Screenshot.png



## 🔍 Key Insights

- Certain teams consistently handle higher call volumes, indicating uneven workload distribution
- The **11 AM – 8 PM shift** handles the highest number of calls across all teams
- Agents aged **21–27 show higher productivity scores** on average
- **Utilization rate** has the strongest correlation with overall productivity
- Shrinkage patterns vary significantly across teams, highlighting scheduling optimization opportunities

---

## 🎯 Future Improvements

- Predict agent productivity using **machine learning**
- Forecast call volumes using **time series analysis (ARIMA/Prophet)**
- Predict agent absenteeism patterns
- Optimize workforce scheduling using predictive staffing models

---

## 📌 Conclusion

This project demonstrates how workforce management data can be transformed into actionable insights using **Python, SQL, and Power BI**. The Productivity Score Model provides a data-driven, fair approach to evaluating agent performance and improving operational efficiency.

---

## ⭐ Skills Demonstrated

`Workforce Analytics` `KPI Design` `SQL Window Functions` `Python EDA` `Power BI` `Productivity Modeling` `Data-Driven Decision Making`

---

## 💼 Author

**Hemnath S**  
Data Analyst | Python | SQL | Power BI  
📧 hemnath126@gmail.com | 🔗 [GitHub](https://github.com/hemnath126-collab)
