# Ejercicios — Joins (Uniones) en SQL

Ejercicios pensados para practicar `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN` y la simulación de `FULL JOIN` en MySQL. Usa la base de datos `tienda_select` o la que prefieras con las tablas: `productos`, `categorias`, `clientes`, `pedidos`, `pedido_detalle`.

> Recomendación: estos ejercicios usan `JOIN` y SELECT con columnas explícitas; evita `SELECT *` para mayor claridad.

---

## Setup rápido (si no tienes `tienda_select`)

Ejecuta el setup de `3. Consultas SQL (SELECT avanzado)/README-ejercicios.md` para crear las tablas y datos base. También puedes usar `tienda_select` si ya la creaste.

---

## Ejercicios

### Nivel 1 — INNER JOIN
1) Lista todos los productos junto con su categoría (solo productos con categoría válida). Muestra `producto_id, producto, categoria_id, categoria`.
2) Cuenta cuántos productos tienen categoría (usa `COUNT` sobre los resultados del INNER JOIN).

### Nivel 2 — LEFT JOIN
3) Lista todos los productos y la categoría cuando exista (`LEFT JOIN`), mostrando `NULL` para los campos de categoría si no hay coincidencia.
4) Identifica cuántos productos quedan sin categoría: usando LEFT JOIN, cuente filas donde la columna de `categoria` sea NULL.

### Nivel 3 — RIGHT JOIN y comparación
5) Reescribe el ejercicio 3 usando `RIGHT JOIN` invirtiendo el orden de las tablas para obtener equivalente lógico.
6) Haz un `FULL JOIN` simulado (LEFT UNION RIGHT) entre `productos` y `categorias` y explica en un comentario cuántas filas adicionales aparecen con respecto a `INNER JOIN`.

### Nivel 4 — JOINs con más tablas
7) Listar `pedido_id, cliente_nombre, producto_nombre, cantidad, precio_unitario` uniendo `pedido_detalle`, `pedidos`, `clientes` y `productos`.
8) Mostrar todos los pedidos (aunque no tengan detalle) usando una combinación de `pedidos` y `pedido_detalle` con `LEFT JOIN`.

---

## Soluciones propuestas

```sql
-- 1) INNER JOIN productos + categorias
SELECT p.id AS producto_id, p.nombre AS producto, c.id AS categoria_id, c.nombre AS categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id;

-- 2) Contar productos con categoría (forma compacta)
SELECT COUNT(*) AS productos_con_categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id;

-- 3) LEFT JOIN: todos los productos
SELECT p.id AS producto_id, p.nombre AS producto, c.id AS categoria_id, c.nombre AS categoria
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id;

-- 4) Contar productos sin categoría (usa LEFT JOIN y WHERE c.id IS NULL)
SELECT COUNT(*) AS productos_sin_categoria
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
WHERE c.id IS NULL;

-- 5) RIGHT JOIN reescribiendo 3
SELECT p.id AS producto_id, p.nombre AS producto, c.id AS categoria_id, c.nombre AS categoria
FROM categorias c
RIGHT JOIN productos p ON p.categoria_id = c.id; -- equivalente lógico a LEFT JOIN en 3

-- 6) Simular FULL JOIN
SELECT p.id AS producto_id, p.nombre AS producto, c.id AS categoria_id, c.nombre AS categoria
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id
UNION
SELECT p.id AS producto_id, p.nombre AS producto, c.id AS categoria_id, c.nombre AS categoria
FROM productos p
RIGHT JOIN categorias c ON p.categoria_id = c.id;

-- 7) JOIN entre 4 tablas para listar detalles
SELECT pd.pedido_id, cl.nombre AS cliente_nombre, pr.nombre AS producto_nombre, pd.cantidad, pd.precio_unitario
FROM pedido_detalle pd
JOIN pedidos pe ON pd.pedido_id = pe.id
JOIN clientes cl ON pe.cliente_id = cl.id
JOIN productos pr ON pd.producto_id = pr.id;

-- 8) Mostrar pedidos aunque no tengan detalle: LEFT JOIN pedido_detalle
SELECT pe.id AS pedido_id, cl.nombre AS cliente, pd.linea, pd.producto_id, pd.cantidad
FROM pedidos pe
JOIN clientes cl ON pe.cliente_id = cl.id
LEFT JOIN pedido_detalle pd ON pd.pedido_id = pe.id;
```

> Nota: en los ejercicios 4 y 6 se usan `WHERE c.id IS NULL` o comparaciones con `NULL` para contar/seleccionar datos no coincidentes; son análisis válidos para aprender sobre la semántica de cada JOIN.

---