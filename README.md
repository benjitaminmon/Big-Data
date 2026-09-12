# Proyecto Big Data: Análisis del Ecosistema Steam 2025

## Equipo de Trabajo
* Vianca Viveros (Jefe de Equipo)
* Benjamin Lagos
* Danko Gangas
* Andres Chaves

## Objetivo del Proyecto
"Analizar el comportamiento de los videojuegos en Steam para determinar qué factores influyen en el éxito de ventas y calificaciones, optimizando decisiones para desarrolladores indies."

## Arquitectura y Tecnologías
Este proyecto fue desarrollado utilizando el ecosistema Hadoop en la máquina virtual Cloudera QuickStart VM.
* **Almacenamiento:** HDFS
* **Ingesta:** Sqoop (desde base de datos relacional) y Apache Flume
* **Procesamiento:** Apache Pig / MapReduce
* **Orquestación:** Apache Oozie
* **Análisis y Consultas:** Apache Hive y Apache Impala

## 🚀 Instrucciones de Ejecución
Proximamente

1. Clonar el repositorio.
2. Ejecutar el script `sqoop_import.sh`.
3. Ejecutar el flujo de Oozie...