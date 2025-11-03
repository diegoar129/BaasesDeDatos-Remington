# Manipulación de Datos (DML) en MySQL

Esta guía cubre los comandos esenciales de DML para insertar, actualizar, eliminar y consultar datos en MySQL. Incluye ejemplos prácticos y consejos para evitar errores comunes.

## Contenido
- Qué es DML (y diferencias con DDL)
- Preparación rápida (base de datos de ejemplo)
- INSERT INTO — agregar registros
- UPDATE — actualizar registros (por ID)
- DELETE — eliminar registros (por ID)
- SELECT — consultas básicas 
- Buenas prácticas

---

## Qué es DML
- DML (Data Manipulation Language): INSERT, UPDATE, DELETE, SELECT.
- DDL (Data Definition Language): CREATE, ALTER, DROP (estructura).
- En MySQL, por defecto `autocommit=1` (cada sentencia confirma automáticamente). Puedes agrupar cambios en transacciones manuales.

---

## Preparación rápida (base de datos de ejemplo)

```sql
CREATE DATABASE IF NOT EXISTS tienda_dml CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE tienda_dml;

-- Tablas simples para ejemplos
CREATE TABLE IF NOT EXISTS categorias (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS productos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  categoria_id INT,
  sku VARCHAR(30),
  CONSTRAINT fk_prod_categoria FOREIGN KEY (categoria_id) REFERENCES categorias(id)
) ENGINE=InnoDB;

INSERT INTO categorias (nombre) VALUES ('Electrónica'), ('Hogar')
;

INSERT INTO productos (nombre, precio, categoria_id, sku) VALUES
  ('Auriculares', 29.90, 1, 'SKU-AUR-001'),
  ('Televisor', 499.00, 1, 'SKU-TEL-001'),
  ('Silla', 85.50, 2, 'SKU-SIL-001')
;
```

---

## INSERT INTO — agregar registros

### Sintaxis básica
```sql
INSERT INTO productos (nombre, precio, categoria_id)
VALUES ('Teclado', 19.99, 1);
```

- Especifica columnas en el mismo orden que los valores.
- Si una columna tiene `DEFAULT` o permite `NULL`, puedes omitirla.

### Múltiples filas
```sql
INSERT INTO productos (nombre, precio, categoria_id) VALUES
  ('Ratón', 12.50, 1),
  ('Lámpara', 22.00, 2);
```

> Nota: aquí evitamos técnicas avanzadas (INSERT ... SELECT, IGNORE, UPSERT) para centrarnos en lo básico.

### Obtener el ID insertado
```sql
SELECT LAST_INSERT_ID() AS nuevo_id;
```

---

## UPDATE — actualizar registros (por ID)

### Sintaxis básica
```sql
-- Actualizar un producto conocido por su ID
UPDATE productos
SET precio = 24.90
WHERE id = 1;
```

Recomendaciones:
- Usa `WHERE id = ...` para cambiar una fila concreta.
- Puedes usar expresiones simples (por ejemplo `precio = precio + 5.00`).


---

## DELETE — eliminar registros (por ID)

### Sintaxis básica
```sql
-- Eliminar un producto por su ID (que no esté referenciado por FKs)
DELETE FROM productos
WHERE id = 3;
```

### TRUNCATE vs DELETE
- `DELETE` elimina filas y puede llevar `WHERE`/`LIMIT`.
- `TRUNCATE TABLE productos;` borra todas las filas, es más rápido, reinicia `AUTO_INCREMENT` y es similar a DDL (no usa `WHERE`). Úsalo con cuidado.

---

## SELECT — consultas básicas 

### Elegir columnas
```sql
SELECT id, nombre, precio FROM productos;
SELECT * FROM productos;
```

---

## Buenas prácticas

- Antes de un `UPDATE`/`DELETE`, ejecuta el `SELECT` equivalente para verificar el conjunto afectado.
- Mantén copias de seguridad si vas a hacer cambios masivos.
- Evita técnicas avanzadas (IGNORE, UPSERT) hasta dominar lo básico.
- Usa tipos y longitudes adecuadas; maneja `NULL` explícitamente.
- Evita `SELECT *`; especifica columnas para mejorar rendimiento y estabilidad.
- Añade índices en columnas muy usadas cuando avances a consultas con filtros/joins.

