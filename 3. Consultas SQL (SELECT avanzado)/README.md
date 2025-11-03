# Consultas SQL (SELECT avanzado) en MySQL

En esta guía aprenderás a hacer consultas más potentes con `SELECT` en MySQL: alias, filtros con `WHERE`, ordenar, limitar resultados, funciones de agregación y agrupaciones con `GROUP BY`/`HAVING`.

## Contenido
- Alias (AS) para columnas y tablas
- Filtros (WHERE, BETWEEN, IN, LIKE, IS NULL)
- Ordenar resultados (ORDER BY)
- Limitar resultados (LIMIT y OFFSET)
- Funciones de agregación (COUNT, SUM, AVG, MAX, MIN)
- Agrupar resultados (GROUP BY, HAVING)

> Nota: Los ejemplos asumen tablas como `productos(id, nombre, precio, categoria_id, stock, activo, creado_en)` y `categorias(id, nombre)`.

---

## Alias (AS)

- Alias de columna: mejora legibilidad del resultado.
```sql
SELECT nombre AS producto, precio AS precio_eur
FROM productos;
```

- Alias de tabla: útil para abreviar nombres (especialmente en subconsultas o uniones).
```sql
SELECT p.id, p.nombre
FROM productos AS p;
```

- Alias en expresiones y uso en ORDER BY.
```sql
SELECT nombre, precio * 1.21 AS precio_con_iva
FROM productos
ORDER BY precio_con_iva DESC;
```

---

## Filtros (WHERE)

- Comparaciones: `=`, `<>`/`!=`, `>`, `>=`, `<`, `<=`, combinadas con `AND`, `OR`, `NOT`.
```sql
SELECT * FROM productos
WHERE activo = TRUE AND precio >= 50;
```

- BETWEEN (incluye extremos):
```sql
SELECT * FROM productos
WHERE precio BETWEEN 20 AND 100;  -- incluye 20 y 100
```

- IN (pertenencia a una lista):
```sql
SELECT * FROM productos
WHERE categoria_id IN (1, 2, 3);
```

- LIKE (búsqueda por patrón con comodines):
```sql
SELECT * FROM productos WHERE nombre LIKE 'T%';     -- empieza por T
SELECT * FROM productos WHERE nombre LIKE '%pro%';  -- contiene "pro"
SELECT * FROM productos WHERE nombre LIKE '____';   -- exactamente 4 caracteres
```
> Por defecto, muchas collations en MySQL (p. ej., `utf8mb4_0900_ai_ci`) son insensibles a mayúsculas/acentos.

- IS NULL / IS NOT NULL (nulos):
```sql
SELECT * FROM productos
WHERE sku IS NULL;   -- nulos
```

---

## Ordenar resultados (ORDER BY)

- Orden ascendente y descendente:
```sql
SELECT nombre, precio
FROM productos
ORDER BY precio DESC, nombre ASC;
```

- Orden usando alias:
```sql
SELECT nombre, (precio * 0.9) AS precio_desc
FROM productos
ORDER BY precio_desc;
```

- Control de nulos (técnica común):
```sql
-- Empuja los NULL al final en orden ascendente
SELECT nombre, sku
FROM productos
ORDER BY (sku IS NULL), sku ASC;
```

---

## Limitar resultados (LIMIT)

- Los primeros N:
```sql
SELECT id, nombre, precio
FROM productos
ORDER BY precio DESC
LIMIT 5;  -- top 5
```

- Paginación con OFFSET:
```sql
SELECT id, nombre
FROM productos
ORDER BY id
LIMIT 10 OFFSET 20;  -- 10 filas a partir de la 21
```

- Sintaxis alternativa equivalente:
```sql
SELECT id, nombre
FROM productos
ORDER BY id
LIMIT 20, 10;  -- OFFSET 20, COUNT 10
```

---

## Funciones de agregación

- Concepto: agregan múltiples filas en un valor. Ignoran `NULL` salvo `COUNT(*)`.

```sql
-- Cantidad de filas
SELECT COUNT(*) AS total_productos FROM productos;

-- Promedio, suma, máximos y mínimos
SELECT AVG(precio) AS precio_promedio,
       SUM(stock) AS stock_total,
       MAX(precio) AS precio_max,
       MIN(precio) AS precio_min
FROM productos;

-- COUNT de una columna no cuenta NULLs
SELECT COUNT(sku) AS productos_con_sku FROM productos;
```

- Útil combinar con `COALESCE` para reemplazar nulos:
```sql
SELECT AVG(COALESCE(precio, 0)) AS promedio_con_ceros
FROM productos;
```

---

## Agrupar resultados (GROUP BY, HAVING)

- Agrupa por una o varias columnas y calcula agregados por grupo.
```sql
-- Total y promedio de precio por categoría
SELECT categoria_id,
       COUNT(*) AS total,
       AVG(precio) AS precio_promedio
FROM productos
GROUP BY categoria_id
ORDER BY total DESC;
```

- Filtrar grupos con HAVING (después del GROUP BY):
```sql
-- Solo categorías con 2 o más productos
SELECT categoria_id, COUNT(*) AS total
FROM productos
GROUP BY categoria_id
HAVING COUNT(*) >= 2;
```

- Combinar WHERE y GROUP BY:
```sql
-- WHERE filtra filas antes de agrupar; HAVING filtra grupos resultantes
SELECT categoria_id, SUM(stock) AS stock_total
FROM productos
WHERE activo = TRUE
GROUP BY categoria_id
HAVING SUM(stock) > 50;
```

> Orden de evaluación típico en MySQL: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT.

---

## Consejos y errores comunes

- `BETWEEN` incluye ambos extremos; para excluir límites usa `>`/`<`.
- `LIKE` usa `%` (cualquier secuencia) y `_` (un carácter). Escapa `%`/`_` con `ESCAPE` si es necesario.
- `COUNT(columna)` ignora `NULL`; `COUNT(*)` cuenta filas.
- Usa alias en agregados para ordenar/leer mejor los resultados.
- `WHERE` vs `HAVING`: no intercambiables; `HAVING` es para condiciones sobre agregados o tras el agrupamiento.
- Al paginar, acompaña `LIMIT` con `ORDER BY` determinista.

¿Quieres que añada diagramas o una “chuleta” rápida con todas las cláusulas de SELECT? Puedo incluirla como archivo adicional.
