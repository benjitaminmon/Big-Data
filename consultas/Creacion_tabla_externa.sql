-- 1. Crear y usar la base de datos
CREATE DATABASE IF NOT EXISTS steam_analytics;
USE steam_analytics;

-- 2. Crear la tabla externa apuntando a los datos en HDFS
CREATE EXTERNAL TABLE IF NOT EXISTS juegos_steam (
    appid INT, 
    name STRING, 
    release_date STRING, 
    is_free BOOLEAN,
    price DOUBLE, 
    average_playtime_forever INT, 
    average_playtime_2weeks INT,
    median_playtime_forever INT, 
    median_playtime_2weeks INT, 
    peak_ccu INT,
    num_reviews_total INT, 
    pct_pos_total INT, 
    metacritic_score INT,
    recommendations INT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\""
)
STORED AS TEXTFILE 
LOCATION '/user/cloudera/proyecto/' 
TBLPROPERTIES ("skip.header.line.count"="1");

-- 3. Sincronizar metadatos con Impala
INVALIDATE METADATA;