# Netflix Mini Insights Dashboard

This project simulates a **mini streaming analytics system** like Netflix using a small dataset and Tableau for visualization.  
It provides insights into **user behavior, content ratings, watch time trends**, and more.

------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

## Dataset Summary

The project uses 5 interrelated CSV files:

| Table Name       | Description                                      |
|------------------|--------------------------------------------------|
| `users.csv`       | User details including location and user_id     |
| `shows.csv`       | Show metadata including genre, release year     |
| `watch history.csv` | Logs user watch time for shows                 |
| `subscriptions.csv` | Subscription status of users                   |
| `feedback.csv`     | User feedback and ratings for shows             |

---

## SQL Analysis

All SQL queries used for preprocessing and insights are saved in:
- `Netflix Mini Analysis.sql`

This includes logic for:
- Top rated shows/genres
- Watch time by region/genre
- Heavy/light watchers
- Aggregations used later in Tableau

---

## Tableau Dashboard

✅ View Full Dashboard here:  
🔗 [Netflix Mini Insights - Tableau Public](https://public.tableau.com/app/profile/rajat.kumar3079/viz/NetflixMiniInsights/NetflixMiniInsightsDashboard?publish=yes)

**Key Insights Covered:**
- Watch Time by Region
- Watch Time by Genre
- Top Rated Shows
- Top Rated Genres
- User Watch Type (Light, Moderate, Heavy)
- KPI Summary Tiles (Total Users, Total Watch Time, Total Shows)
- Interactive Filters for Region, Genre, User Name

---

## 📦 Files Included

| File                             | Purpose                                 |
|----------------------------------|-----------------------------------------|
| `users.csv`                      | User-level data                         |
| `shows.csv`                      | Shows and genres                        |
| `watch history.csv`             | Watch logs per user/show                |
| `subscriptions.csv`              | User subscription status                |
| `feedback.csv`                   | Show feedback and user ratings          |
| `Netflix Mini Analysis.sql`     | SQL used to derive intermediate tables  |
| `Netflix Mini Insights.twbx`    | Tableau Packaged Workbook               |

---

## Future Enhancements

- Connect Tableau to live MySQL instead of static CSVs
- Add monthly retention, churn analysis
- Auto-updating dashboards with parameterized filters

---

## Built With

- **SQL (MySQL)** – for logic and data wrangling
- **Tableau Public** – for dynamic dashboards and storytelling
- **GitHub** – for project versioning and portfolio

---

## Acknowledgements

This project was made to simulate a real-world OTT streaming platform’s mini data stack.  
Practice-ready for aspiring **Data Analysts / BI Developers / SQL & Tableau learners**.

---------------------------------------------------------------------------------------------------------------------------------------------------
