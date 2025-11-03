# Ejercicios de DML en MySQL

Practica `INSERT`, `UPDATE`, `DELETE` y `SELECT` con un esquema sencillo. Incluye un bloque de configuración (setup) y soluciones propuestas al final.

> Requisitos: MySQL 8.0+, motor InnoDB, Workbench o cliente `mysql`.

## Setup (crear esquema y datos)

Ejecuta este bloque para crear la base `tienda_dml`, tablas y algunos datos iniciales.

```sql
CREATE DATABASE IF NOT EXISTS tienda_dml CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE tienda_dml;

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
  sku VARCHAR(30) UNIQUE,
  CONSTRAINT fk_prod_categoria FOREIGN KEY (categoria_id) REFERENCES categorias(id)
) ENGINE=InnoDB;

-- Tabla de práctica sin restricciones únicas ni foráneas para operaciones
CREATE TABLE IF NOT EXISTS productos_prueba (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  categoria_id INT,
  sku VARCHAR(30)
) ENGINE=InnoDB;

CREATE TABLE clientes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(150) NOT NULL UNIQUE,
  nombre VARCHAR(120) NOT NULL
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

INSERT INTO productos (nombre, precio, categoria_id, sku) VALUES
  ('Auriculares', 29.90, 1, 'SKU-AUR-001'),
  ('Televisor', 499.00, 1, 'SKU-TEL-001'),
  ('Silla', 85.50, 2, 'SKU-SIL-001'),
  ('Mesa', 129.00, 2, 'SKU-MES-001'),
  ('Manguera', 24.99, 3, 'SKU-MAN-001');

-- Datos iniciales en la tabla de práctica
INSERT INTO productos_prueba (nombre, precio, categoria_id, sku) VALUES
  ('Producto A', 10.00, 1, 'A-001'),
  ('Producto B', 20.00, 2, 'B-001');

INSERT INTO clientes (email, nombre) VALUES
  ('ana@example.com', 'Ana'),
  ('luis@example.com', 'Luis');

INSERT INTO pedidos (cliente_id) VALUES (1), (2);

INSERT INTO pedido_detalle (pedido_id, linea, producto_id, cantidad, precio_unitario) VALUES
  (1, 1, 1, 1, 29.90),
  (1, 2, 3, 2, 85.50),
  (2, 1, 2, 1, 499.00);
```

---

## Nivel 1 — INSERT y SELECT básicos 

1) Inserta un producto nuevo con `nombre='Teclado'`, `precio=19.99`, `categoria_id=1`. Obtén su ID con `LAST_INSERT_ID()`.
2) Inserta, en una sola sentencia `INSERT`, dos productos más a tu elección.
3) Lista todos los productos (`SELECT * FROM productos;`).
4) Lista solo `id, nombre, precio` de todos los productos.

---

## Nivel 2 — UPDATE sin WHERE (tabla de práctica)

5) En `productos_prueba`, incrementa `precio` en `5.00` para todas las filas.
6) En `productos_prueba`, establece `sku` con el prefijo `TEMP-` seguido del `id` para todas las filas (p. ej., `TEMP-1`).
7) En `productos_prueba`, cambia `nombre` a mayúsculas para todas las filas.

---

## Nivel 3 — DELETE sin WHERE y más INSERT/SELECT

8) Vacía la tabla `productos_prueba` usando `DELETE FROM productos_prueba;` y verifica su contenido con `SELECT *`.
9) Inserta nuevamente dos filas en `productos_prueba` en una sola sentencia `INSERT` y lista todas las filas.
10) Usa `TRUNCATE TABLE productos_prueba;` para dejarla vacía y confirma con `SELECT *`.
11) Inserta dos categorías nuevas en una sola sentencia `INSERT` y muestra todas las categorías con `SELECT *`.

---

## Nivel 4 — Extras opcionales (sin WHERE)

12) Inserta tres productos en `productos_prueba` en una sola sentencia y luego establece el mismo `sku` para todas las filas (observa el resultado al seleccionar todas las filas).
13) Redondea los `precio` de `productos_prueba` a 0 decimales para todas las filas.

---

## Recomendaciones finales
- Revisa con `SELECT *` o `SELECT columnas` antes y después de cada cambio.
- Evita técnicas avanzadas hasta dominar lo básico.
- En esta práctica no usamos `WHERE`; trabaja sobre tablas de práctica como `productos_prueba` para evitar modificar datos principales.
