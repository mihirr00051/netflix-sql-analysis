<img width="5270" height="3453" alt="shre" src="https://github.com/user-attachments/assets/a3e3b0d9-5d7d-43da-a46b-5e7418147e0c" />
-Netflix Headquarters, Los Angeles — Sunset Boulevard


# Netflix-Movies-and-TV-Shows-Data-Analysis-using-SQL
This project analyzes Netflix movies and TV shows data using SQL to solve real business problems and extract actionable insights that support content strategy and decision-making.

---

## 📌 Project Overview

An end-to-end SQL project exploring Netflix's global content library. This project translates real business questions into analytical queries and surfaces actionable insights for content strategy and decision-making.

---

## 📊 Project Stats

| Metric | Value |
|--------|-------|
| Total SQL Queries | 15+ |
| Records Analyzed | 8,000+ |
| Countries Covered | 190+ |
| Database | PostgreSQL |

---

## 🛠️ Tech Stack

- **Database:** PostgreSQL
- **Domain:** Entertainment / Streaming Analytics
- **Dataset:** Netflix Movies and TV Shows (Kaggle)

---

## 🔍 Featured Queries

### Query 14 — Top 10 Actors in Indian Productions

Unnests the comma-separated cast column and ranks actors by appearance count across India-produced titles.

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*) AS appearances
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY appearances DESC
LIMIT 10;
```

---

### Query 15 — Content Safety Classification

Uses a `CASE` expression inside a subquery to label titles as **Bad** or **Good** based on keywords in the description, then aggregates counts by category.

```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' 
              OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
```

---

## 💡 Project Impact

This project demonstrates the ability to:

- ✅ Translate business questions into analytical SQL queries
- ✅ Work with real-world, production-scale datasets
- ✅ Apply advanced SQL concepts — window functions, CTEs, array unnesting
- ✅ Communicate insights clearly for non-technical stakeholders
- ✅ Think from a business decision-making perspective

This analysis provides a comprehensive view of Netflix's content library and can help inform content strategy, regional investment, and platform decision-making.

---

## 📁 Repository Structure

```
netflix-sql-analysis/
│
├── datasets/
│   └── netflix_titles.csv
│
├── queries/
│   ├── 01_content_type_distribution.sql
│   ├── 02_movies_vs_shows.sql
│   └── ...
│   └── 15_content_classification.sql
│
├── shre.jpg
└── README.md
```

---

## 👨🏻‍💻 Author

**Your Name**  
📧 Email: mihirofficial33.edu@gmail.com 
💼 LinkedIn: [linkedin.com/in/mihirr51](https://linkedin.com/in/mihirr51)  
🐙 GitHub: [github.com/mihirr00051](https://github.com/mihirr00051)

---

> *"Data is the new oil — and SQL is the refinery."*
