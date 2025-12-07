# Building-a-Simple-Movie-Data-Pipeline

Movie ETL Pipeline (Python + MySQL)

Overview

This project is a simple ETL (Extract, Transform, Load) pipeline built using Python and MySQL.

It extracts data from local CSV files (movies.csv and ratings.csv), enriches the movie details using the OMDb API, and loads the cleaned and structured data into a MySQL database.



Setup Instructions


1️. Clone or Open the Project Make sure you have this folder structure: movie-pipeline/ ├── etl.py ├── schema.sql ├── queries.sql  └── README.md


2️. Install Required Libraries Run this command in your terminal :
pip install pandas requests sqlalchemy tqdm


3️. Create the Database and Tables

Open cmd  and run:"C:\\Program Files\\MySQL\\MySQL Server 9.5\\bin\\mysql.exe" -u root -p < "C:\\Users\\G V N AVINASH REDDY\\OneDrive\\Desktop\\project\\schema.sql"

password:**gvnar@007**


4️. Run the ETL Script cmd
python etl.py

Expected output:

✅ Connected to database: movie\_data
🎬 Loaded 10 movies and 100836 ratings.
⚠️ Some movies not found in OMDb. Saved to 'missing\_movies.csv'.
✅ Data loaded successfully into MySQL.

5️. Run the SQL Queries

"C:\\Program Files\\MySQL\\MySQL Server 9.5\\bin\\mysql.exe" -u root -p movie\_data < "C:\\Users\\G V N AVINASH REDDY\\OneDrive\\Desktop\\project\\queries.sql"

password:**gvnar@007**

=======================================================================================================================

Database Design:

----------------

Database: movie\_data

-|-|-Tables-|-|-

movies → Stores movie details (id, title, year, director, etc.)

ratings → Stores user ratings for each movie

movie\_genres → Stores genres for each movie

"Each table is linked using movieId."

=============================================================================================================================

Design Choices \& Assumptions
----------------------------

->Used OMDb API to enrich movies with metadata like director and plot.

->Added fallback values (e.g., “Unknown”) for missing API results.

->Foreign key checks are temporarily disabled during data reload for smooth testing.

->Genres are split and stored in a separate table for flexibility.

=================================================================================================================================

Challenges Faced:
------------------

Problem                                    Solution
-----------                               ------------

->Some movies not found in OMDb           -> Logged them in missing\_movies.csv and added fallback data

->API or network errors                   -> Used try-except for safe handling

->Data type mismatches                    -> Explicitly converted IDs and years to integers

->Foreign key errors                      -> Disabled FK checks during table truncation

