# Ejercicios de DDL en MySQL

Practica la Definición de Datos (DDL) creando, alterando y eliminando bases de datos, tablas y restricciones. Los ejercicios están organizados por nivel y al final encontrarás una sección de soluciones propuestas.

> Requisitos: MySQL 8.0+ (para `CHECK`), Workbench o cliente `mysql`.

## Reglas de trabajo
- Crea una base de datos dedicada por ejercicios para evitar conflictos.
- Usa `IF NOT EXISTS` / `IF EXISTS` para idempotencia.
- Nombra tus restricciones con `CONSTRAINT nombre` para poder gestionarlas.
- Ejecuta en este orden cuando borres: primero tablas hijas, luego tablas padre.

---

## Nivel 1 — Fundamentos

1) Crea la base de datos `tienda_ddl` con `utf8mb4` y selecciónala.
2) Crea la tabla `categorias`:
   - `id` INT PK AUTO_INCREMENT
   - `nombre` VARCHAR(100) NOT NULL UNIQUE
3) Crea la tabla `productos`:
   - `id` INT PK AUTO_INCREMENT
   - `nombre` VARCHAR(150) NOT NULL
   - `precio` DECIMAL(10,2) NOT NULL con `CHECK (precio > 0)`
   - `categoria_id` INT NOT NULL FK a `categorias(id)` con `ON DELETE RESTRICT`
4) Inserta 2 categorías y 3 productos (al menos 2 del mismo tipo de categoría).
5) Intenta insertar un producto con `precio = -1` y verifica que falle por CHECK.

---

## Nivel 2 — Alteraciones y unicidad

6) Añade a `productos` la columna `sku` `VARCHAR(30)` `NOT NULL` `UNIQUE`.
7) Intenta insertar dos productos con el mismo `sku` y observa el error de unicidad.
8) Cambia `nombre` de `productos` a permitir `NULL` y luego vuelve a `NOT NULL`.
9) Añade índice único compuesto a `productos` para (`nombre`, `categoria_id`).
10) Renombra la columna `precio` a `precio_unitario`.

---

## Nivel 3 — Relaciones y cascadas

11) Crea la tabla `clientes`:
   - `id` INT PK AUTO_INCREMENT
   - `email` VARCHAR(150) NOT NULL UNIQUE
   - `nombre` VARCHAR(120) NOT NULL
12) Crea la tabla `pedidos`:
   - `id` INT PK AUTO_INCREMENT
   - `cliente_id` INT NOT NULL FK `ON DELETE CASCADE`
   - `creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
13) Crea la tabla `pedido_detalle` con PK compuesta (`pedido_id`, `linea`) y FKs a `pedidos(id)` y `productos(id)`; valida `cantidad > 0` y `precio_unitario >= 0` con `CHECK`.
14) Inserta un cliente, un pedido y dos líneas de detalle. Luego elimina el cliente y verifica que el pedido y su detalle se borren en cascada.

---

## Nivel 4 — Limpieza y drops

15) Elimina las tablas en orden correcto y al final elimina la base de datos `tienda_ddl`.

> Evita usar `SET FOREIGN_KEY_CHECKS=0` a menos que entiendas las implicaciones.

---


## Siguientes pasos
- Extiende las FKs con `ON DELETE SET NULL` y valida su efecto.
- Prueba PKs compuestas en más tablas y cómo afectan a las FKs.
- Mide rendimiento con y sin índices en columnas de búsqueda.
