# SQL-analisis-de-datos-adventureworks
Consultas SQL para análisis de datos y control de calidad (QA) usando AdventureWorks2019

## Base de datos utilizada
AdventureWorks2019 (Microsoft SQL Server sample database)

Este repositorio contiene consultas SQL realizadas sobre la base de datos AdventureWorks2019, enfocadas en análisis de datos, validación y detección de inconsistencias.

## Conceptos aplicados
- JOINs (INNER JOIN, LEFT JOIN)
- Agregaciones (SUM, COUNT)
- Filtrado de datos con WHERE y HAVING
- Manejo de valores nulos con ISNULL
- Subconsultas
- Transacciones (BEGIN TRANSACTION, COMMIT, ROLLBACK)


## Objetivos
- Analizar comportamiento de clientes
- Detectar inconsistencias en datos (Data Quality / QA)
- Generar reportes útiles para negocio
- Practicar consultas avanzadas en SQL Server

## Contenido

### Validación de datos (QA)
- Clientes sin compras
- Personas sin cliente
- Órdenes sin cliente

### Análisis de negocio
- Cliente que más ha gastado
- Total vendido por producto
- Clientes con número de órdenes

### Análisis de productos
- Productos sin ventas
- Productos con stock disponible

### Manejo de datos
- Uso de JOINs (INNER, LEFT)
- Subconsultas con agregaciones
- Uso de ISNULL para manejo de valores nulos
- Transacciones (UPDATE + COMMIT)

## Notas
Las consultas están diseñadas como escenarios prácticos basados en casos reales de análisis de datos y validación de información.
