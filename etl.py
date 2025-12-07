import pandas as pd
import requests
from sqlalchemy import create_engine, text
from tqdm import tqdm

from urllib.parse import quote_plus
from sqlalchemy import create_engine


db_user = "root"
db_password = "gvnar@007"   
db_host = "localhost"
db_name = "movie_data"


db_user_enc = quote_plus(db_user)
db_password_enc = quote_plus(db_password)


print("Connecting to:", f"{db_user_enc}:*****@{db_host}/{db_name}")

engine = create_engine(f"mysql+mysqlconnector://{db_user_enc}:{db_password_enc}@{db_host}/{db_name}")



movies_df = pd.read_csv("movies.csv")
ratings_df = pd.read_csv("ratings.csv")


movies_df = movies_df.head(10)
print(f"🎬 Loaded {len(movies_df)} movies and {len(ratings_df)} ratings.")


OMDB_API_KEY = "63d2cf34"
omdb_base_url = "http://www.omdbapi.com/"

movies_clean = []
missing_movies = []

for _, row in tqdm(movies_df.iterrows(), total=len(movies_df), desc="Fetching movie details from OMDb"):
    title = row['title']

  
    clean_title = title
    clean_title = clean_title.split('(')[0].strip()   
    clean_title = clean_title.split('/')[0].strip()   
    clean_title = clean_title.split('-')[0].strip()  

    try:
        response = requests.get(omdb_base_url, params={"t": clean_title, "apikey": OMDB_API_KEY})
        data = response.json()

        if data.get("Response") == "True":
            movies_clean.append({
                "movieId": int(row['movieId']),
                "title": data.get("Title", title),
                "year": int(data.get("Year", 0)) if data.get("Year") else None,
                "imdb_id": data.get("imdbID"),
                "director": data.get("Director"),
                "plot": data.get("Plot"),
                "box_office": data.get("BoxOffice"),
                "genres": data.get("Genre", ""),
                "decade": int(data.get("Year", 0)) // 10 * 10 if data.get("Year") else None
            })
        else:
            missing_movies.append({"movieId": row['movieId'], "title": title})

    except Exception:
        missing_movies.append({"movieId": row['movieId'], "title": title})


if missing_movies:
    print("🔄 Adding fallback entries for missing movies...")
    for missing in missing_movies:
        movies_clean.append({
            "movieId": int(missing['movieId']),
            "title": missing['title'],
            "year": None,
            "imdb_id": None,
            "director": "Unknown",
            "plot": "No data available",
            "box_office": "N/A",
            "genres": "",
            "decade": None
        })

    pd.DataFrame(missing_movies).to_csv("missing_movies.csv", index=False)
    print(f"⚠️ {len(missing_movies)} movies not found in OMDb. Saved to 'missing_movies.csv'.")

movies_clean_df = pd.DataFrame(movies_clean)


genres_list = []
for _, row in movies_clean_df.iterrows():
    genres = row['genres'].split(',') if pd.notna(row['genres']) else []
    for genre in genres:
        genres_list.append({
            "movieId": int(row['movieId']),
            "genre": genre.strip()
        })

genres_df = pd.DataFrame(genres_list)


ratings_to_insert = ratings_df[ratings_df['movieId'].isin(movies_clean_df['movieId'])].copy()


ratings_to_insert.loc[:, 'movieId'] = ratings_to_insert['movieId'].astype(int)
ratings_to_insert.loc[:, 'userId'] = ratings_to_insert['userId'].astype(int)


try:
    with engine.begin() as conn:

        conn.execute(text("SET FOREIGN_KEY_CHECKS=0;"))

     
        conn.execute(text("TRUNCATE TABLE movie_genres;"))
        conn.execute(text("TRUNCATE TABLE ratings;"))
        conn.execute(text("TRUNCATE TABLE movies;"))


        conn.execute(text("SET FOREIGN_KEY_CHECKS=1;"))

      
        movies_clean_df[['movieId', 'title', 'year', 'imdb_id', 'director', 'plot', 'box_office', 'decade']] \
            .to_sql('movies', con=conn, if_exists='append', index=False)

   
        if not genres_df.empty:
            genres_df.to_sql('movie_genres', con=conn, if_exists='append', index=False)

        if not ratings_to_insert.empty:
            ratings_to_insert.to_sql('ratings', con=conn, if_exists='append', index=False)

    print("✅ Data loaded successfully into MySQL.")

except Exception as e:
    print(f"❌ Error loading data into MySQL: {e}")

