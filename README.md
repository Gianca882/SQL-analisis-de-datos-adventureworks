# SQL-analisis-de-datos-adventureworks

Conjunto de consultas SQL enfocadas en análisis de datos, validación (QA) y lógica de negocio utilizando la base de datos AdventureWorks2019.

## Base de datos utilizada
AdventureWorks2019 (Microsoft SQL Server sample database)

## Descripción
Este repositorio contiene consultas SQL diseñadas como escenarios prácticos basados en casos reales de análisis de datos, validación de información y lógica de negocio.  

El objetivo es demostrar habilidades en el uso de SQL para explorar datos, detectar inconsistencias y aplicar transformaciones controladas dentro de un entorno similar al empresarial.

## Conceptos aplicados
- JOINs (INNER JOIN, LEFT JOIN)
- Agregaciones (SUM, COUNT, AVG)
- Filtrado de datos con WHERE y HAVING
- Manejo de valores nulos con ISNULL
- Subconsultas
- Uso de CASE para lógica condicional
- Transacciones (BEGIN TRANSACTION, COMMIT, ROLLBACK)
- Actualización de datos con lógica de negocio

## Objetivos
- Analizar comportamiento de clientes
- Detectar inconsistencias en datos (Data Quality / QA)
- Generar información útil para toma de decisiones
- Practicar consultas intermedias en SQL Server

## Contenido

### Validación de datos (QA)
- Clientes sin compras
- Clientes duplicados
- Personas sin cliente

### Análisis de datos
- Clientes con más compras
- Cliente que más ha gastado
- Promedio gastado por cliente
- Clientes y número de órdenes
- Historial de cliente

### Análisis de productos
- Productos sin ventas
- Productos con stock disponible
- Total vendido por producto

### Transacciones y actualizaciones
- Corrección de datos (UPDATE controlado)
- Uso de transacciones (COMMIT / ROLLBACK)

### Lógica de negocio
- Ajuste de precios por rangos (uso de CASE)
- Aumento de precios controlado
