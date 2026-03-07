# 📊 WFM Agent Performance Analysis

An end-to-end **Workforce Management (WFM) analytics project** built using **Python, SQL, and Power BI** to analyze call center agent productivity and operational efficiency.

The project evaluates key workforce metrics such as **Average Handle Time (AHT), Occupancy, Utilization, and Shrinkage**, and introduces a **Productivity Score Model** to rank agent performance.

---

# 🚀 Project Overview

Call centers generate large volumes of operational data. However, identifying high-performing agents and operational inefficiencies can be challenging without structured analysis.

This project analyzes agent performance data and builds a **data-driven workforce analytics solution** that helps identify:

* Top performing agents
* Team productivity patterns
* Shift performance differences
* Workforce efficiency trends

---

# 🧰 Tools & Technologies

**Python**
* Pandas
  
**SQL (MySQL)**

* Data transformation
* KPI calculations
* Views and window functions

**Power BI**

* Interactive dashboard
* Data visualization
* Operational insights

---

# 🔄 Project Workflow

Python → Exploratory Data Analysis
SQL → Data Transformation & KPI Calculation
Power BI → Interactive Dashboard Visualization

---

# 📂 Project Structure

```
WFM-Agent-Performance-Analysis
│
├── data
│   └── agent_performance.csv
│
├── python
│   └── wfm_analysis.ipynb
│
├── sql
│   └── wfm_analysis.sql
│
├── dashboard
│   └── wfm_dashboard.pbix
│
└── README.md
```

---

# 📊 Key Workforce Metrics

The project calculates several industry-standard WFM metrics.

### Average Handle Time (AHT)

Average time spent handling each call.

### Effective Work Hours

Total productive working time.

### Occupancy

Measures the proportion of work time spent handling calls.

### Utilization

Measures how efficiently login time is used.

### Shrinkage

Percentage of time agents are unavailable due to breaks or training.

---

# ⭐ Productivity Score Model

To evaluate agent performance, a weighted productivity model was created:

```
Productivity Score =
(AHT Score × 0.4)
+ (Occupancy × 0.3)
+ (Utilization × 0.3)
```

Agents were ranked using **SQL window functions** to identify top performers within each team.

---

# 📈 Power BI Dashboard

The Power BI dashboard provides interactive insights including:

• Total Calls Handled
• Average Handle Time (AHT)
• Occupancy & Utilization
• Shrinkage Percentage
• Top Agents by Productivity Score
• Team Performance Comparison
• Shift-wise Call Analysis

Interactive filters allow users to analyze performance by:

* Team
* Gender
* Age Category
* Shift
* Month

---

# 🔍 Key Insights

* Certain teams consistently handle higher call volumes.
* The **11 AM – 8 PM shift** handles the highest number of calls.
* Agents aged **21–27 show higher productivity levels**.
* Utilization has a strong influence on overall productivity.
* Shrinkage patterns vary across teams.

---

# 🎯 Future Improvements

Possible extensions for this project include:

* Predicting agent productivity using **machine learning**
* Forecasting call volumes using **time series analysis**
* Predicting agent absenteeism patterns
* Optimizing workforce scheduling

---

# 📌 Conclusion

This project demonstrates how workforce management data can be transformed into actionable insights using **Python, SQL, and Power BI**.

The solution provides a **data-driven approach to evaluating agent performance and improving operational efficiency**.

---

⭐ If you find this project useful, feel free to **star the repository**!
