🎵 Music Store Database Analysis

This project analyzes a digital music store database to answer business questions using SQL. The database contains information about customers, invoices, tracks, albums, artists, and more.

📂 Project Structure

-schema.sql → SQL script to create tables.

-data/ → CSV files with sample data.

-queries.sql → SQL queries that answer the business questions.

🗄️ Database Schema

Database Schema

The Music Store database includes the following tables:

-Customer – customer details (name, email, country, etc.)

-Invoice – invoices with purchase totals

-InvoiceLine – line items (tracks purchased in each invoice)

-Track – individual songs with genre, album, and media info

-Album – album details linked to artists

-Artist – musicians/bands

-Genre – music categories

-Employee – staff details (support reps, managers)

-Playlist – playlists created in the store

-PlaylistTrack – mapping of tracks to playlists

-MediaType – file types (MP3, AAC, etc.)

🛠️ Technologies Used

-SQL Server (can also run on PostgreSQL/MySQL with small changes)

-CSV files as data source

-Import/Export Wizard for loading data

📊 Key Skills Demonstrated

-Data modeling (customers, invoices, employees, tracks, artists, etc.)

-SQL Joins (INNER JOIN, GROUP BY, ORDER BY)

-Aggregations (SUM, COUNT, AVG)

-Window Functions (ROW_NUMBER)

-Common Table Expressions (CTEs)

-Business analysis with SQL

🚀 Business Questions Answered

The queries in this project answer real-world business problems, such as: -Who is the senior-most employee based on job title?

-Which country has the highest number of invoices?

-What are the top 3 highest invoice totals?

-Which city generates the most revenue (best customers)?

-Who is the best customer by total spend?

-Which artists have written the most rock music?

-Which country prefers which genre?

-How much has each customer spent on each artist?

🚀 Getting Started

1.Clone this repository 
2.Import music_database_project.sql into your SQL Server / PostgreSQL / MySQL 
3.Load sample data from data folder 
