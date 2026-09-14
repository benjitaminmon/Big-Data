-- Script de Apache Pig para agrupar por precio y contar
datos = LOAD '/user/cloudera/proyecto/games_sample.csv' USING PigStorage(',');

-- Extraer la columna del precio (ajustar el $4 según la posición exacta en el CSV)
precios = FOREACH datos GENERATE $4 as price;

-- Agrupar los registros por su valor
agrupados = GROUP precios BY price;

-- Contar la cantidad de juegos por cada precio
conteo = FOREACH agrupados GENERATE group, COUNT(precios);

-- Almacenar los resultados en la ruta evidenciada en el informe
STORE conteo INTO '/user/cloudera/out/pig_resultado/' USING PigStorage(',');