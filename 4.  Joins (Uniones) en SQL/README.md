# Joins (Uniones) en SQL — INNER, LEFT, RIGHT, FULL

Este documento explica los tipos principales de uniones entre tablas en SQL, con ejemplos prácticos orientados a MySQL y notas sobre compatibilidad.

## ¿Qué es un JOIN?
Un JOIN combina filas de dos (o más) tablas basándose en una condición de relación, normalmente que una columna de la primera tabla coincida con una columna de la segunda (por ejemplo, `productos.categoria_id = categorias.id`).

### Tipos principales
- INNER JOIN: devuelve solo las filas que tienen coincidencia en ambas tablas.
- LEFT JOIN (LEFT OUTER JOIN): devuelve todas las filas de la tabla izquierda y las coincidentes de la derecha (si no hay coincidencia, columnas de la derecha serán NULL).
- RIGHT JOIN (RIGHT OUTER JOIN): devuelve todas las filas de la tabla derecha y las coincidentes de la izquierda.
- FULL JOIN (FULL OUTER JOIN): devuelve filas cuando hay coincidencias en cualquiera de las tablas (MySQL no implementa `FULL JOIN` directamente; se consigue con `UNION` entre LEFT y RIGHT o usando operaciones externas).

> Notas: en MySQL se usan `INNER JOIN`, `LEFT JOIN` y `RIGHT JOIN`. Para un `FULL JOIN` suele usarse una combinación de `LEFT JOIN` y `RIGHT JOIN` con `UNION`.

---

## Sintaxis básica y ejemplos
> Supongamos las tablas del ejemplo `tienda_select`: `productos(id, nombre, precio, categoria_id, ...)` y `categorias(id, nombre)`.

### INNER JOIN
Devuelve solo las filas con coincidencias en ambas tablas.
```sql
SELECT p.id AS producto_id, p.nombre AS producto, c.nombre AS categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id;
```
- Resultado: solo productos que tienen una `categoria_id` no nula que existe en `categorias`.

### LEFT JOIN
Incluye todos los productos, aunque no tengan categoría asociada (las columnas de `categorias` serán NULL).
```sql
SELECT p.id AS producto_id, p.nombre AS producto, c.nombre AS categoria
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id;
```
- Útil para detectar productos huérfanos (sin categoría): `WHERE c.id IS NULL` en análisis, aunque aquí evitamos filtros en ejercicios.

### RIGHT JOIN
Equivalente a LEFT JOIN pero preservando todas las filas de la tabla derecha.
```sql
SELECT c.id AS categoria_id, c.nombre AS categoria, p.id AS producto_id, p.nombre AS producto
FROM productos p
RIGHT JOIN categorias c ON p.categoria_id = c.id;
```
- En la práctica, en MySQL y estructuras típicas, `LEFT JOIN` es más común; `RIGHT JOIN` puede reescribirse como `LEFT JOIN` intercambiando el orden de tablas.

### FULL JOIN (workaround en MySQL)
MySQL no soporta `FULL OUTER JOIN` directamente. Se puede simular combinando `LEFT JOIN` y `RIGHT JOIN` y uniendo los resultados con `UNION`:
```sql
-- Simular FULL JOIN: todas las combinaciones coincidentes y no coincidentes
SELECT p.id AS producto_id, p.nombre AS producto, c.id AS categoria_id, c.nombre AS categoria
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
UNION
SELECT p.id AS producto_id, p.nombre AS producto, c.id AS categoria_id, c.nombre AS categoria
FROM productos p
RIGHT JOIN categorias c ON p.categoria_id = c.id;
```
- Alternativa: usar `UNION ALL` y filtrar duplicados con una condición si es necesario. Ten cuidado con filas duplicadas si hay coincidencias en ambos lados.

---

## Buenas prácticas
- Usa alias (`p`, `c`) para hacer las consultas más legibles.
- Prefiere `INNER JOIN` cuando solo te interesan coincidencias válidas y `LEFT JOIN` si quieres mantener la tabla principal completa.
- Evita seleccionar `*` cuando haces joins; especifica columnas y alias para prevenir ambigüedad.
- Si la columna de relación puede ser `NULL`, `INNER JOIN` la excluirá; usa `LEFT JOIN` si necesitas ver esos registros.
- Para grandes volúmenes, asegúrate de que las columnas usadas en la condición `ON` están indexadas (por ejemplo, `categorias.id` es PK e indexada; `productos.categoria_id` debería tener índice para mejorar rendimiento).

---

## Ejemplos más avanzados (combinaciones)
- JOIN entre más de 2 tablas:
```sql
SELECT o.id AS pedido_id, c.nombre AS cliente, p.nombre AS producto, pd.cantidad
FROM pedido_detalle pd
JOIN pedidos o ON pd.pedido_id = o.id
JOIN clientes c ON o.cliente_id = c.id
JOIN productos p ON pd.producto_id = p.id;
```
- LEFT JOIN para incluir pedidos aunque alguna línea refiera a un producto eliminado (y ver NULLs en columnas del producto).

---

¿Quieres que añada un archivo de ejercicios y soluciones listo para tus alumnos? Puedo generar `README-ejercicios.md` en la misma carpeta con ejemplos y soluciones paso a paso.
