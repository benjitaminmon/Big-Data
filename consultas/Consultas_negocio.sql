-- Consulta 1: Ranking de valoración (Fiabilidad)
SELECT name, pct_pos_total, num_reviews_total 
FROM juegos_steam 
WHERE num_reviews_total > 1000 
ORDER BY pct_pos_total DESC, num_reviews_total DESC 
LIMIT 5;

-- Consulta 2: Peak de jugadores simultáneos
SELECT name, peak_ccu, price 
FROM juegos_steam 
ORDER BY peak_ccu DESC 
LIMIT 5;

-- Consulta 3: Criterio de gratuidad 
SELECT name, recommendations, num_reviews_total 
FROM juegos_steam 
WHERE price = 0 
ORDER BY recommendations DESC 
LIMIT 5;

-- Consulta 4: Crítica especializada (Metacritic)
SELECT name, metacritic_score, pct_pos_total 
FROM juegos_steam 
WHERE metacritic_score > 0 
ORDER BY metacritic_score DESC 
LIMIT 5;

-- Consulta 5: Rentabilidad
SELECT name, average_playtime_forever, price 
FROM juegos_steam 
WHERE average_playtime_forever > 0 
ORDER BY average_playtime_forever DESC 
LIMIT 5;