-- This file defines all tables for the database

CREATE TABLE IF NOT EXISTS places (
    place_id TEXT,
    place_name TEXT,
    place_country TEXT,
    place_country_code TEXT,
    place_full_name TEXT,
    place_type TEXT,
    place_street_address TEXT,
    place_locality TEXT,
    place_region TEXT,
    place_iso3_country_code TEXT,
    place_postal_code TEXT,
    PRIMARY KEY(place_id)
);

CREATE TABLE IF NOT EXISTS place_bounding_box_coordinate (
    id SERIAL,
    place_id TEXT,
    longitude DECIMAL,
    latitude DECIMAL,
    bound_type TEXT,
    PRIMARY KEY(id),
    FOREIGN KEY(place_id) REFERENCES places(place_id)
);

CREATE TABLE IF NOT EXISTS users (
    user_id BIGINT,
    user_screen_name TEXT,
    user_name TEXT,
    user_location TEXT,
    user_description TEXT,
    user_followers_count INT, 
    user_friends_count INT,
    user_time_zone TEXT,
    user_lang TEXT,
    user_url TEXT,
    user_geo_enabled BOOLEAN,
    PRIMARY KEY(user_id)
);

CREATE TABLE IF NOT EXISTS user_relations (
    follower_user_id BIGINT,
    following_user_id BIGINT,
    PRIMARY KEY(follower_user_id, following_user_id),
    FOREIGN KEY(follower_user_id) REFERENCES users(user_id),
    FOREIGN KEY(following_user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS tweets (
    id BIGINT,
    created_at TIMESTAMP,
    text TEXT,
    geo BOOLEAN,
    user_id BIGINT,
    longitude DECIMAL,
    latitude DECIMAL,
    geo_longitude DECIMAL,
    geo_latitude DECIMAL,
    place_id TEXT,
    retweeted_id BIGINT,
    original_tweet_retweet_count BIGINT,
    in_reply_to_status_id BIGINT,
    in_reply_to_user_id BIGINT,
    lang TEXT,
    detected_language TEXT,
    PRIMARY KEY(id),
    FOREIGN KEY(place_id) REFERENCES places(place_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS tweet_hashtags (
    tweet_id BIGINT,
    hashtag TEXT,
    PRIMARY KEY(tweet_id, hashtag),
    FOREIGN KEY(tweet_id) REFERENCES tweets(id)
);

CREATE TABLE IF NOT EXISTS geonames (
    geonameid INT,
    name VARCHAR (200),
    asciiname VARCHAR (200),
    alternatenames VARCHAR (10000),
    latitude DECIMAL,
    longitude DECIMAL,
    feature_class CHAR(1),
    feature_code VARCHAR (10),
    country_code VARCHAR (2),
    cc2 VARCHAR (200),
    admin1_code VARCHAR (20),
    admin2_code VARCHAR (80),
    admin3_code VARCHAR (20),
    admin4_code VARCHAR (20),
    population BIGINT,
    elevation INTEGER,
    dem INTEGER,
    timezone VARCHAR (40),
    modification_date date,
    PRIMARY KEY(geonameid)
);

CREATE VIEW trumps_tweets AS
SELECT * FROM tweets WHERE user_id = 25073877;

CREATE TABLE IF NOT EXISTS filtered_user_locations(
  user_id BIGINT,
  geonameid INT,
  ratio DECIMAL,
  FOREIGN KEY(user_id) REFERENCES users(user_id),
  FOREIGN KEY(geonameid) REFERENCES geonames(geonameid)
);

CREATE TABLE IF NOT EXISTS identified_via_geonames (
    geonameid INT,
    user_id BIGINT,
    country_name VARCHAR (200),
    FOREIGN KEY (geonameid) REFERENCES geonames(geonameid),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS predicted_user_locations(
  user_id BIGINT UNIQUE,
  predicted_lat DECIMAL,
  predicted_long DECIMAL,
  max_value DECIMAL,
  incorrect BOOLEAN,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
)