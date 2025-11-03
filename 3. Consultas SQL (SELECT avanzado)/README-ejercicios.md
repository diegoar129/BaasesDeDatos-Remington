# Ejercicios — Consultas SQL (SELECT avanzado) en MySQL

Practica alias, filtros, ordenación, límite, agregaciones y agrupaciones. Incluye un setup reproducible y soluciones propuestas al final.

> Requisitos: MySQL 8.0+, motor InnoDB, Workbench o cliente `mysql`.

## Setup (crear esquema y datos)

```sql
CREATE DATABASE IF NOT EXISTS tienda_select CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE tienda_select;

DROP TABLE IF EXISTS pedido_detalle;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;

CREATE TABLE categorias (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE productos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  categoria_id INT,
  stock INT NOT NULL DEFAULT 0,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  sku VARCHAR(30),
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_prod_categoria FOREIGN KEY (categoria_id) REFERENCES categorias(id)
) ENGINE=InnoDB;

CREATE TABLE clientes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(150) NOT NULL UNIQUE,
  nombre VARCHAR(120) NOT NULL,
  ciudad VARCHAR(100),
  fecha_registro DATE NOT NULL DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

CREATE TABLE pedidos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  cliente_id INT NOT NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ped_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pedido_detalle (
  pedido_id INT NOT NULL,
  linea INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (pedido_id, linea),
  CONSTRAINT fk_det_pedido   FOREIGN KEY (pedido_id)  REFERENCES pedidos(id)   ON DELETE CASCADE,
  CONSTRAINT fk_det_producto FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO categorias (nombre) VALUES ('Electrónica'), ('Hogar'), ('Jardín');

INSERT INTO productos (nombre, precio, categoria_id, stock, activo, sku) VALUES
  ('Auriculares', 29.90, 1, 50, TRUE,  'SKU-AUR-001'),
  ('Televisor',  499.00, 1, 10, TRUE,  'SKU-TEL-001'),
  ('Silla',       85.50, 2, 30, TRUE,  'SKU-SIL-001'),
  ('Mesa',       129.00, 2, 15, FALSE, 'SKU-MES-001'),
  ('Manguera',    24.99, 3, 80, TRUE,  NULL),
  ('Tijeras',     12.49, 3, 40, TRUE,  'SKU-TIJ-001');

INSERT INTO clientes (email, nombre, ciudad, fecha_registro) VALUES
  ('ana@example.com',  'Ana',  'Madrid',     '2025-01-10'),
  ('luis@example.com', 'Luis', 'Barcelona',  '2025-03-22'),
  ('maria@example.com','María','Valencia',   '2025-05-05');

INSERT INTO pedidos (cliente_id, creado_en) VALUES
  (1, '2025-05-20 10:00:00'),
  (1, '2025-06-01 12:00:00'),
  (2, '2025-06-03 09:30:00');

INSERT INTO pedido_detalle (pedido_id, linea, producto_id, cantidad, precio_unitario) VALUES
  (1, 1, 1, 1, 29.90),
  (1, 2, 3, 2, 85.50),
  (2, 1, 2, 1, 499.00),
  (2, 2, 5, 3, 24.99),
  (3, 1, 4, 1, 129.00);
```

---

## Nivel 1 — Alias, filtros y ordenación

1) Lista `nombre` y `precio` de `productos` con alias `producto` y `precio_eur`.
2) Muestra productos activos (`activo = TRUE`) cuyo precio sea mayor o igual a 50.
3) Muestra productos con `precio` entre 20 y 100 (incluidos).
4) Muestra productos cuya `categoria_id` esté en (1,3).
5) Busca productos cuyo `nombre` contenga la cadena `te` (usa `LIKE`).
6) Muestra productos con `sku` nulo.
7) Lista `nombre, precio` ordenados por `precio` descendente y luego `nombre` ascendente.
8) Muestra los 3 productos más caros (usa `ORDER BY` + `LIMIT`).

---

## Nivel 2 — Agregaciones básicas

9) Cuenta cuántos productos hay en total (`COUNT(*)`).
10) Calcula el `precio_promedio`, `precio_max` y `precio_min` de todos los productos.
11) Calcula el `stock_total` sumando `stock` de todos los productos activos.

---

## Nivel 3 — GROUP BY y HAVING

12) Por `categoria_id`, muestra: `total_productos` y `precio_promedio`, ordenando por `total_productos` descendente.
13) Muestra solo las categorías con 2 o más productos.
14) Por `activo` (TRUE/FALSE), muestra el `stock_total` agrupado.
15) En `pedido_detalle`, muestra por `pedido_id`: `lineas` (COUNT), `unidades` (SUM `cantidad`) y `importe_total` (SUM `cantidad * precio_unitario`), ordena por `importe_total` descendente.
16) Filtra los pedidos del punto anterior para dejar solo aquellos con `importe_total` >= 200 (usa `HAVING`).

---

## Nivel 4 — LIMIT/OFFSET y combinaciones

17) Lista los `id, nombre` de `clientes` ordenados por `fecha_registro` descendente y devuelve solo las primeras 2 filas.
18) Devuelve la página 2 (filas 3 y 4) de `productos` ordenados por `id` ascendente, usando `LIMIT ... OFFSET`.

---


---

## Recomendaciones
- Antes de agrupar, verifica los datos con `SELECT` simples.
- Acompaña `LIMIT` con `ORDER BY` determinista.
- Recuerda: `WHERE` filtra filas antes de agrupar; `HAVING` filtra grupos.
