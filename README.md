# SQL_Spotify_project
# 🎧 Spotify Advanced SQL Project & Query Optimization – P6

🔗 [LinkedIn](https://www.linkedin.com/in/mahesh-thakare-75817b2a7)  
📧 [Contact Me](mailto:maheshthakare225@gmail.com)  
🐱 [GitHub](https://github.com/mahesh735-ai)

![Spotify Logo](spotify_logo.jpg)

---

## 📌 Project Overview

In this project, we analyze a rich Spotify dataset using **PostgreSQL**. The dataset contains metadata of tracks, artists, albums, streaming data, and engagement metrics like views, likes, comments, etc.  

We’ve divided the queries into 3 levels: **Easy, Medium, and Advanced**, followed by **query optimization** using indexing and EXPLAIN ANALYZE.

---

## 📂 Dataset Info

| Field            | Description                         |
|------------------|-------------------------------------|
| artist           | Name of the artist                  |
| track            | Track name                          |
| album            | Album name                          |
| danceability     | Danceability score (0-1)            |
| energy, tempo    | Audio features                      |
| views, likes     | YouTube stats                       |
| stream           | Spotify stream count                |
| official_video   | Whether it's an official video      |
| most_played_on   | Platform with max engagement        |

🧠 Source: [Spotify Dataset – Kaggle](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

---

## 🧠 SQL Problem Solving

### ✅ Easy Level
1. Top tracks with over 1B streams  
2. Total tracks per artist  
3. Tracks from album type = "single"  
4. Comments for licensed tracks  
5. Artist + album summary

### 🔶 Medium Level
1. Average danceability per album  
2. Top 5 energetic tracks  
3. Views & likes for official videos  
4. Total views per album  
5. Compare Spotify vs. YouTube streams

### 🚀 Advanced Level
1. Top 3 viewed tracks/artist (window function)  
2. Tracks with above-average liveness  
3. WITH CTE: Energy range per album  
4. Tracks where `energy/liveness > 1.2`  
5. Cumulative likes using `SUM() OVER(...)`

---

## ⚙️ Query Optimization

We used:
- ✅ `EXPLAIN ANALYZE` for performance benchmarking  
- ✅ Indexing on key fields like `artist`  
- ✅ Observed execution time improvements after index creation  

📈 Performance Drop: 7ms → **0.15ms** ⚡  
```sql
CREATE INDEX idx_artist ON spotify(artist);
