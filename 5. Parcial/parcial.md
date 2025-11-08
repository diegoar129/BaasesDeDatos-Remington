# Parcial — Enunciado

Duración sugerida: 60 minutos.

Instrucciones: responde las preguntas de opción múltiple (1–10) indicando la letra correcta (A/B/C/D). Para las preguntas prácticas (11–20) escribe la consulta SQL solicitada. Usa la base `parcial_db` creada por `setup_parcial.sql`.

---

## Parte A — Opción múltiple (analiza la consulta)

1) ¿Qué devuelve la siguiente consulta?

```sql
SELECT COUNT(*) FROM productos WHERE sku IS NULL;
```
A) El número total de productos con SKU no nulo.
B) El número total de productos con SKU nulo.
C) Siempre 0.
D) Error porque `sku` no está indexado.

2) ¿Qué resultado produce este SELECT?

```sql
SELECT p.nombre, c.nombre
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.activo = FALSE;
```
A) Todos los productos (independientemente de `activo`).
B) Productos inactivos con su categoría (solo si tienen categoría).
C) Productos inactivos aunque no tengan categoría, con nombres de categoría NULL.
D) Error: INNER JOIN no permite WHERE en la misma consulta.

3) ¿Qué hace esta sentencia?

```sql
INSERT INTO productos (id, nombre, precio) VALUES (7, 'Altavoz', 39.90);
```
A) Inserta una fila nueva con id=7 aunque exista otra con id=7 (sobrescribe).
B) Inserta una fila nueva con id=7 y fallará si ya existe un producto con id=7.
C) Inserta pero establece `categoria_id` automáticamente.
D) Actualiza la fila con id=7 si existe.

4) ¿Cuál es la salida de:

```sql
SELECT MAX(precio) FROM productos;
```
A) El precio máximo de todos los productos (ignora NULLs).
B) El número de productos con precio máximo.
C) Un error si existen NULLs.
D) El precio mínimo.

5) Dado el siguiente GROUP BY, ¿qué devuelve?

```sql
SELECT categoria_id, COUNT(*) FROM productos GROUP BY categoria_id HAVING COUNT(*) >= 2;
```
A) Categorías con al menos 2 productos y el número de productos por categoría.
B) Todas las categorías, sin filtrar.
C) Un error: HAVING no puede usarse sin agregación en SELECT.
D) Categorías con menos de 2 productos.

6) ¿Qué hace esta consulta?

```sql
UPDATE productos SET precio = precio * 1.10 WHERE id = 2;
```
A) Aumenta en 10% el precio de todos los productos.
B) Aumenta en 10% el precio del producto con id=2.
C) Inserta un nuevo producto con id=2.
D) Elimina el producto con id=2.

7) ¿Qué devuelve la siguiente consulta JOIN?

```sql
SELECT pe.id, cl.nombre
FROM pedidos pe
LEFT JOIN clientes cl ON pe.cliente_id = cl.id;
```
A) Todos los pedidos con el nombre del cliente; si el cliente no existe, el nombre será NULL.
B) Solo pedidos cuyo cliente exista en `clientes`.
C) Solo clientes que tienen pedidos.
D) Un error por usar LEFT JOIN con alias.

8) ¿Qué hace `TRUNCATE TABLE productos;`?
A) Elimina todas las filas y reinicia AUTO_INCREMENT (si aplica).
B) Elimina solo las filas que cumplen una condición.
C) Borra la definición de la tabla (DROP).
D) Hace lo mismo que DELETE FROM productos WHERE precio < 0;

9) Considera:

```sql
SELECT nombre FROM productos ORDER BY precio DESC LIMIT 1;
```
¿Qué devuelve?
A) El producto más barato.
B) El producto más caro.
C) Todos los productos ordenados.
D) Error, falta GROUP BY.

10) ¿Cuál es el efecto de `SELECT DISTINCT categoria_id FROM productos;`?
A) Devuelve una fila por cada producto.
B) Devuelve cada categoría que aparece en productos, sin duplicados.
C) Devuelve solo las categorías con más de un producto.
D) Elimina las filas duplicadas de la tabla `categorias`.
11) ¿Qué hace la cláusula `LIMIT 5 OFFSET 10` en una consulta?
A) Devuelve las primeras 15 filas.
B) Devuelve 5 filas empezando desde la fila 11.
C) Devuelve 10 filas empezando desde la fila 6.
D) Error: sintaxis inválida en MySQL.

12) ¿Cuál es la diferencia entre `COUNT(*)` y `COUNT(columna)`?
A) Ninguna; son equivalentes en todos los casos.
B) `COUNT(*)` cuenta filas, `COUNT(columna)` cuenta solo si la columna no es NULL.
C) `COUNT(columna)` cuenta filas, `COUNT(*)` ignora NULLs.
D) `COUNT(*)` es más lento y no debe usarse.

13) ¿Qué devuelve esta consulta?

```sql
SELECT categoria_id, AVG(precio) FROM productos GROUP BY categoria_id;
```
A) El promedio de precio por categoría.
B) El precio promedio total (sin agrupar).
C) Error: AVG no puede usarse con GROUP BY.
D) El recuento de productos por categoría.

14) ¿Cuál es el efecto de `ALTER TABLE productos ADD COLUMN descuento DECIMAL(5,2) NOT NULL DEFAULT 0.00;`?
A) Añade la columna `descuento` y asigna 0.00 a filas existentes.
B) Elimina la columna `descuento` si existe.
C) Cambia el tipo de `precio` a DECIMAL(5,2).
D) Crea una tabla nueva llamada `descuento`.

15) ¿Qué devuelve `SELECT p.nombre, c.nombre FROM productos p RIGHT JOIN categorias c ON p.categoria_id = c.id;`?
A) Solo productos que tengan categoría.
B) Todas las categorías y los productos coincidentes (NULL si no hay producto).
C) Todas las filas de `productos` y columnas de `categorias` NULL.
D) Error: RIGHT JOIN no es soportado en MySQL.

16) ¿Cuál es el propósito de `ON DELETE CASCADE` en una FK?
A) Evitar que se borren filas en la tabla padre.
B) Que al borrar una fila padre, se borren las filas hijas relacionadas automáticamente.
C) Rechazar la operación de borrado si existen hijos.
D) No tiene efecto en InnoDB.

17) ¿Qué devuelve esta consulta?

```sql
SELECT nombre FROM productos WHERE nombre LIKE 'T%';
```
A) Productos cuyo nombre termina con 'T'.
B) Productos cuyo nombre contiene la letra 'T' en cualquier posición.
C) Productos cuyo nombre empieza por 'T'.
D) Error: LIKE requiere comillas dobles.

18) ¿Qué hace `INSERT INTO categorias (id, nombre) VALUES (1, 'Electrónica')` si ya existe id=1?
A) Inserta otra fila con el mismo id.
B) Lanza error de duplicado por PK.
C) Actualiza la fila existente con id=1.
D) Ignora silenciosamente la inserción.

19) ¿Cuál es el resultado de usar `UNION` entre dos SELECT?
A) Devuelve la intersección de filas entre ambas consultas.
B) Devuelve todas las filas de ambas consultas eliminando duplicados.
C) Devuelve filas duplicadas solo si se usa UNION ALL.
D) B y C son correctas.

20) ¿Qué hace `START TRANSACTION; ... ROLLBACK;`?
A) Ejecuta las operaciones y las confirma permanentemente.
B) Inicia una transacción y revierte los cambios realizados dentro de ella.
C) Es sinónimo de COMMIT.
D) Solo funciona en tablas MyISAM.

---

21) Traduce a SQL la siguiente petición: "Muestra el nombre y el precio de los productos cuyo precio sea mayor a 100." ¿Cuál es la consulta correcta?

A) SELECT nombre, precio FROM productos WHERE precio > 100;
B) SELECT precio FROM productos WHERE nombre > 100;
C) SELECT nombre FROM productos WHERE precio < 100;
D) SELECT * FROM productos ORDER BY precio > 100;

22) Traduce a SQL: "Cuenta cuántos pedidos hay." ¿Cuál es la mejor consulta?

A) SELECT COUNT(*) FROM pedidos;
B) SELECT pedidos FROM COUNT(*) ;
C) SELECT COUNT(pedido_id) FROM pedido_detalle;
D) SELECT SUM(*) FROM pedidos;

23) Traduce: "Muestra los clientes y la fecha de su primer pedido." ¿Qué consulta corresponde mejor?

A) SELECT c.nombre, MIN(p.creado_en) FROM clientes c JOIN pedidos p ON p.cliente_id = c.id GROUP BY c.id;
B) SELECT clientes.nombre, pedidos.creado_en FROM clientes, pedidos;
C) SELECT nombre, creado_en FROM clientes ORDER BY creado_en ASC LIMIT 1;
D) SELECT c.nombre, p.creado_en FROM clientes c LEFT JOIN pedidos p ON p.cliente_id = c.id;

24) Traduce: "Lista los productos que no tienen SKU." ¿Cuál es la consulta correcta?

A) SELECT * FROM productos WHERE sku IS NULL;
B) SELECT * FROM productos WHERE sku = '';
C) SELECT * FROM productos WHERE sku IS NOT NULL;
D) SELECT * FROM productos WHERE sku = 'NULL';

25) Traduce: "¿Cuánto ha ingresado en total por ventas? (suma de cantidad * precio_unitario)" ¿Cuál es la consulta adecuada?

A) SELECT SUM(cantidad * precio_unitario) AS total_ventas FROM pedido_detalle;
B) SELECT COUNT(cantidad * precio_unitario) FROM pedido_detalle;
C) SELECT AVG(cantidad * precio_unitario) FROM pedido_detalle;
D) SELECT SUM(precio_unitario) FROM pedido_detalle;

---

## Parte B — Prácticas (escribe la consulta)

26) Muestra `id, nombre, precio` de todos los productos.

27) Inserta un nuevo producto con `id=7`, `nombre='Altavoz'`, `precio=39.90`, `categoria_id=1`, `sku='SKU-ALT-001'`, `stock=20`, `activo=TRUE`.

28) Actualiza el precio del producto con `id=1`, súbelo a `34.90`.

29) Elimina el producto que acabas de insertar (id=7).

30) Lista `producto` y `categoria` para todos los productos que tengan categoría (usa INNER JOIN). Debes mostrar columnas como `producto_id, producto, categoria`.

31) Lista `pedido_id, cliente_nombre, producto_nombre, cantidad` uniendo `pedido_detalle`, `pedidos`, `clientes` y `productos`.

32) Cuenta cuántos pedidos existen en la tabla `pedidos`.

33) Muestra el total (SUM) del importe por `pedido_id` en `pedido_detalle` (cantidad * precio_unitario) y ordena por total descendente. Muestra `pedido_id, importe_total`.

34) Muestra los 2 productos más baratos (id, nombre, precio).

35) Añade una columna `descuento` a la tabla `productos` que sea DECIMAL(5,2) con valor por defecto 0.00.

---

Fin del examen. Guarda tus respuestas en `respuestas_parcial.sql` y envíalas cuando termines.

---

## Parte C — Libro: Fundamentos de Sistemas de Bases de Datos
Capítulo 1: Bases de datos y usuarios de bases de datos

36) ¿Cuál de las siguientes opciones describe mejor una base de datos?
a) Un conjunto de archivos sin relación.
b) Una colección organizada de datos interrelacionados que representa información del mundo real.
c) Un conjunto de programas para procesar textos.
d) Un repositorio de información multimedia.

37) ¿Cuál es el propósito principal de un Sistema de Administración de Bases de Datos (DBMS)?
a) Permitir que varios usuarios accedan y manipulen los datos de manera controlada.
b) Sustituir los sistemas operativos.
c) Eliminar toda redundancia de datos, incluso la necesaria.
d) Solo generar reportes automáticos.

38) Según Elmasri y Navathe, los principales “actores” en un entorno de bases de datos incluyen:
a) Administradores de red, usuarios finales y diseñadores de sistemas.
b) Administradores de bases de datos (DBA), diseñadores de bases de datos y programadores de aplicaciones.
c) Solo los usuarios finales.
d) Los diseñadores de hardware y los contadores.

39) Menciona tres ventajas de utilizar una metodología DBMS frente al uso de archivos tradicionales.
(Respuesta abierta)

40) ¿En qué tipo de situaciones no es recomendable usar un DBMS según el texto?
a) Cuando el volumen de datos es bajo y las aplicaciones son simples.
b) Cuando se necesita acceso concurrente.
c) Cuando se requieren políticas de seguridad complejas.
d) Cuando se deben integrar varios sistemas.

Capítulo 2: Conceptos y arquitectura de los sistemas de bases de datos

41) ¿Qué diferencia existe entre esquema e instancia de una base de datos?
(Respuesta abierta breve)

42) La arquitectura de tres esquemas (ANSI/SPARC) busca principalmente:
a) Aumentar la velocidad de las consultas.
b) Lograr independencia física y lógica de los datos.
c) Reducir el costo del almacenamiento.
d) Integrar las bases de datos distribuidas.

43) ¿Qué nivel de la arquitectura de tres esquemas representa cómo los usuarios finales ven los datos?
a) Nivel interno
b) Nivel conceptual
c) Nivel externo
d) Nivel físico

44) Los principales lenguajes asociados a un DBMS incluyen:
a) DDL, DML y DCL
b) HTML, XML y CSS
c) API, SDK y GUI
d) Python, Java y SQL

45) Explica brevemente qué se entiende por independencia de datos y por qué es importante en un DBMS.
(Respuesta abierta)