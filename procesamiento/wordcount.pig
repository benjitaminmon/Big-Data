-- Script de Apache Pig para procesamiento (Wordcount / Limpieza)
-- Cargamos los datos desde el directorio del proyecto
datos = LOAD '/user/cloudera/proyecto/games_sample.csv' USING PigStorage(',');

-- (Aquí va la lógica de transformación que Oozie ejecutará en su nodo_pig)