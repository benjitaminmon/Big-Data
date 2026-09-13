-- Consulta 1: Ranking de valoración (Fiabilidad)
SELECT name, pct_pos_total, num_reviews_total 
FROM juegos_steam 
WHERE num_reviews_total > 1000 
ORDER BY pct_pos_total DESC, num_reviews_total DESC 
LIMIT 5;

-- Consulta 2: Peak de jugadores simultáneos
SELECT name, peak_ccu 
FROM juegos_steam 
ORDER BY peak_ccu DESC 
LIMIT 5;

-- Consulta 3: Criterio de gratuidad 
SELECT name, pct_pos_total, num_reviews_total 
FROM juegos_steam 
WHERE price = 0 AND num_reviews_total > 500 
ORDER BY pct_pos_total DESC 
LIMIT 5;

-- Consulta 4: Crítica especializada (Metacritic)
SELECT name, metacritic_score 
FROM juegos_steam 
WHERE metacritic_score > 0 
ORDER BY metacritic_score DESC 
LIMIT 5;

-- Consulta 5: Rentabilidad (Tiempo de juego por dólar/peso gastado)
SELECT name, average_playtime_forever, price 
FROM juegos_steam 
WHERE average_playtime_forever > 0 AND price > 0 
ORDER BY (average_playtime_forever / price) DESC 
LIMIT 5;