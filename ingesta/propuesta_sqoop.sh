#!/bin/bash
# Propuesta técnica de importación relacional con Apache Sqoop

# Para usar sqoop se tomo el dataset y 
# se ingreso en una base de datos de 'mySql'
# mediante el siguente comando:

# LOAD DATA INFILE '/home/cloudera/mis_datos_windows/games_march2025_cleaned.csv' 
# INTO TABLE steam_games 
# FIELDS TERMINATED BY ',' 
# FIELDS TERMINATED BY ',' 
# ENCLOSED BY '"' 
# LINES TERMINATED BY '\n' 
# IGNORE 1 LINES;

sqoop import \
--connect jdbc:mysql://127.0.0.1/proyecto_I \ --LOCALHOST--
--username root \
--password cloudera \
--table steam_games \
--m 1 \
--target-dir /user/cloudera/steam_games_hdfs
