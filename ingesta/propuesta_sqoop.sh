#!/bin/bash
# Propuesta técnica de importación relacional con Apache Sqoop

sqoop import \
--connect jdbc:mysql://servidor/base_datos \
--username tu_usuario \
--password tu_clave \
--table clientes \
--target-dir /user/cloudera/clientes_hdfs \
-m 1