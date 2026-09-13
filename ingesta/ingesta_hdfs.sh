#!/bin/bash
# Ingesta del dataset crudo al entorno HDFS de Hadoop

# 1. Subir los archivos del workspace local a HDFS
hadoop fs -put ~/workspace/steam/* /user/cloudera/proyecto/

# 2. Verificar que el archivo se haya cargado correctamente
hadoop fs -ls /user/cloudera/proyecto/