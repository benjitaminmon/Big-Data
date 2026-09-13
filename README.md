# Análisis Exploratorio y Preparación del Dataset (Steam Games 2025)

## 1. Identificación del Archivo
- **Archivo analizado:** `games_march2025_full.csv`
- **Formato:** CSV delimitado por comas
- **Tamaño aproximado:** 471 MB
- **Número de registros:** 94.948 videojuegos *(Cumple con la restricción >50.000 de la pauta)*.
- **Número de variables:** 47
- **Temática:** Videojuegos publicados en la plataforma Steam.
- **Fuente declarada:** Kaggle (Se adjuntará URL exacta en el informe final).
- **Referencia temporal:** Actualización a marzo de 2025.

## 2. Estructura del Documento en HDFS
La primera fila contiene los nombres de las variables (cabeceras). Cada fila posterior representa un videojuego y utiliza `appid` como identificador principal (Primary Key). 
Debido a que el CSV contiene campos de texto largos y descripciones con saltos de línea y comas internas, la ingesta y lectura mediante **Apache Hive / Pig** requerirá el uso de un serializador/deserializador (OpenCSV SerDe) que respete los campos entrecomillados para evitar el desplazamiento de columnas.

## 3. Diccionario de Variables Disponibles
*(Esta sección se utilizará para definir el esquema DDL en Hive)*

### Identificación y Datos Básicos
- `appid`: Identificador único del juego.
- `name`: Nombre del videojuego.
- `release_date`: Fecha de lanzamiento.
- `required_age`: Edad mínima requerida.
- `price`: Precio base.
- `discount`: Descuento aplicado.
- `dlc_count`: Cantidad de contenidos descargables.

### Descripciones y Metadatos
- `detailed_description`, `about_the_game`, `short_description`: Textos descriptivos.
- `header_image`, `website`, `support_url`, `support_email`, `notes`: Multimedia y contacto.

### Plataformas y Soporte
- `windows`, `mac`, `linux`: Booleanos de disponibilidad por sistema operativo.
- `supported_languages`, `full_audio_languages`: Soporte de idiomas.

### Métricas de Valoración y Comunidad
- `metacritic_score` / `metacritic_url`: Puntuación y enlace de la crítica especializada.
- `user_score`, `positive`, `negative`: Volumen de reseñas de usuarios.
- `pct_pos_total`, `pct_pos_recent`: Porcentajes de aprobación histórica y reciente.
- `num_reviews_total`, `num_reviews_recent`: Volumen de interacciones.
- `recommendations`: Recomendaciones totales de la comunidad.
- `score_rank`: Clasificación del producto.

### Categorización y Jugabilidad
- `achievements`, `packages`: Logros y ediciones.
- `developers`, `publishers`: Estudios de desarrollo y publicación.
- `categories`, `genres`, `tags`: Clasificaciones de nicho y género.

### Actividad y Retención (KPIs)
- `estimated_owners`: Estimación de alcance.
- `average_playtime_forever` / `average_playtime_2weeks`: Tiempo medio de juego.
- `median_playtime_forever` / `median_playtime_2weeks`: Mediana de retención.
- `peak_ccu`: Máximo de usuarios conectados simultáneamente (concurrencia).

## 4. Auditoría de Calidad de Datos (Data Profiling)
Se detectaron **485.940 valores vacíos o nulos** distribuidos entre las variables. Las columnas con mayor índice de ausencia que afectarán el procesamiento son:

| Variable | Valores vacíos o nulos |
|---|---:|
| `score_rank` | 94.909 |
| `metacritic_url` | 91.372 |
| `reviews` | 84.520 |
| `notes` | 78.296 |
| `website` | 53.754 |
| `support_url` | 50.763 |
| `support_email` | 16.100 |
| `detailed_description` | 5.426 |
| `name` | 2 |

### Interpretación para el Pipeline de Big Data
- La variable `score_rank` está vacía en casi el 100% del dataset, por lo que será excluida de las consultas analíticas en Impala.
- No se detectaron identificadores `appid` duplicados.
- Existen **19.420 juegos con `price = 0`** (20,45% del catálogo, modelo Free-to-Play) y **75.528 juegos de pago**. Estas dos naturalezas deberán ser analizadas en sub-consultas separadas.
- Los valores ausentes son celdas vacías nativas que herramientas como Apache Pig y Hive interpretarán directamente como valores `NULL`.

## 5. Estrategia de Variables Clave para el Negocio
Para resolver la problemática planteada (identificar qué hace exitoso a un juego Indie), las consultas en Hive se centrarán en los siguientes KPIs:
1. **Métricas de Aprobación:** `pct_pos_total` y `num_reviews_total`.
2. **Métricas de Crítica:** `metacritic_score` y `recommendations`.
3. **Métricas de Mercado:** `genres`, `tags`, `price` y `discount`.
4. **Métricas de Engagement:** `peak_ccu` y `average_playtime_forever`.

## 6. Variables que requieren precaución analítica
- `metacritic_score`: Su alta tasa de valores nulos exige utilizar cláusulas `WHERE metacritic_score IS NOT NULL` en Hive para no sesgar los promedios.
- `average_playtime_forever`: Un tiempo elevado no siempre equivale a calidad; puede indicar mecánicas repetitivas (*grinding*) o juegos de tipo "servicio".
- `recommendations`: Favorece por defecto a los juegos más antiguos (efecto bola de nieve), requiriendo cruzar esta métrica con `release_date`.

## 7. Propuesta de Lógica Analítica para Hive/Impala
No conviene ordenar los juegos únicamente por porcentaje de aprobación (`pct_pos_total`), ya que un juego con 1 sola reseña positiva tendría un 100%, superando injustamente a uno con 10.000 reseñas y 95% de aprobación.

Las consultas SQL implementarán los siguientes filtros:
- Exigir un umbral mínimo de `num_reviews_total` (ej. > 500 reseñas).
- Segmentar mediante `GROUP BY` juegos gratuitos vs. juegos de pago.
- Generar un ranking ponderado (Score Calculado) directamente en la consulta SQL utilizando pesos porcentuales sobre las reseñas, Metacritic y la actividad (CCU).

## 8. Hoja de Ruta para Limpieza (Data Cleaning con Apache Pig)
Antes de construir las tablas definitivas en Hive, se diseñará un script en **Apache Pig** (`transformacion.pig`) para ejecutar las siguientes tareas:
1. Eliminar los registros críticos con problemas estructurales (ej. los 2 registros sin `name`).
2. Descartar la columna `score_rank` del esquema por falta de completitud.
3. Estandarizar los tipos de datos (castear fechas y números) y asegurar que los campos vacíos sean inyectados formalmente como `NULL` lógicos para evitar errores de tipo (*Type Mismatch*) en Hive.

## 9. Conclusión de Viabilidad
El archivo presenta un volumen idóneo para el ecosistema Hadoop (94.948 registros) y una riqueza de dimensiones (47 variables) que abarcan economía, popularidad y retención. Las anomalías detectadas (comas internas, saltos de línea y valores nulos) representan el escenario perfecto para justificar el uso de herramientas de Big Data como Apache Pig para limpieza y Apache Hive para la estructuración y consulta analítica robusta.