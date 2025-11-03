# Definición de Estructuras (DDL) en MySQL

Este documento explica los comandos de Definición de Datos (DDL) en MySQL para crear, modificar y eliminar estructuras: bases de datos, tablas y restricciones.

## Contenido
- Qué es DDL (y diferencias con DML/DCL/TCL)
- CREATE DATABASE, USE, DROP DATABASE
- CREATE TABLE, ALTER TABLE, DROP TABLE
- Claves y restricciones: PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, DEFAULT, NOT NULL
- Buenas prácticas y errores comunes

---

## Qué es DDL
- DDL (Data Definition Language) define estructuras: bases de datos, tablas, índices, vistas y restricciones.
- DML (Data Manipulation Language) gestiona los datos: INSERT, UPDATE, DELETE.
- DCL/TCL (Control/Transacciones): GRANT/REVOKE y COMMIT/ROLLBACK.

En MySQL, las operaciones DDL suelen ser transaccionales en InnoDB, pero algunas son implícitamente COMMIT; ejecuta DDL con cuidado.

---

## CREATE DATABASE, USE, DROP DATABASE

### Crear base de datos
```sql
-- Crea la base de datos si no existe, con juego de caracteres/collation recomendados
CREATE DATABASE IF NOT EXISTS universidad
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
```

### Seleccionar base de datos
```sql
USE universidad;
```

### Eliminar base de datos
```sql
-- ¡Peligroso! Borra todo su contenido
DROP DATABASE IF EXISTS universidad;
```

Notas:
- En MySQL, "database" y "schema" son sinónimos.
- Define explícitamente `CHARACTER SET` y `COLLATE` para evitar problemas con acentos/ordenación.

---

## CREATE TABLE

### Sintaxis básica
```sql
CREATE TABLE IF NOT EXISTS alumnos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE,
  fecha_nac DATE,
  creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;
```

Puntos clave:
- `PRIMARY KEY` puede ser una o varias columnas (clave compuesta).
- `AUTO_INCREMENT` suele aplicarse a una PK entera.
- `UNIQUE`, `NOT NULL`, `DEFAULT` pueden declararse en línea con la columna o como restricciones aparte.
- Usa `ENGINE=InnoDB` (por defecto) para soportar transacciones y FKs.

### Tipos de datos comunes
- Numéricos: `TINYINT`, `INT`, `BIGINT`, `DECIMAL(p,s)`
- Texto: `VARCHAR(n)`, `TEXT` (no admite `DEFAULT`), `CHAR(n)`
- Fecha/hora: `DATE`, `DATETIME`, `TIMESTAMP` (acepta `DEFAULT CURRENT_TIMESTAMP`)
- Varios: `BOOLEAN` (sinónimo de `TINYINT(1)`), `JSON` (MySQL 5.7+)

### Claves y restricciones
```sql
CREATE TABLE IF NOT EXISTS cursos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  codigo VARCHAR(20) NOT NULL UNIQUE,
  titulo VARCHAR(200) NOT NULL,
  creditos TINYINT NOT NULL CHECK (creditos BETWEEN 1 AND 30)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS matriculas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  alumno_id INT NOT NULL,
  curso_id INT NOT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- Restricción única compuesta: un alumno no puede matricularse 2 veces al mismo curso
  CONSTRAINT uq_matricula UNIQUE (alumno_id, curso_id),
  -- Claves foráneas con acciones de cascada
  CONSTRAINT fk_matr_alumno FOREIGN KEY (alumno_id) REFERENCES alumnos(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_matr_curso  FOREIGN KEY (curso_id)  REFERENCES cursos(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
```

Notas y compatibilidad:
- `CHECK`: MySQL lo aplica a partir de 8.0.16. En versiones más antiguas, se aceptaba pero se ignoraba.
- Las columnas referenciadas por una `FOREIGN KEY` deben tener el mismo tipo/longitud/collation que la columna objetivo y estar indexadas; InnoDB crea índices implícitos si es necesario.
- Acciones: `ON DELETE/UPDATE` con `RESTRICT|CASCADE|SET NULL|NO ACTION`.

---

## ALTER TABLE

Cambiar estructuras sin recrear la tabla completa.

```sql
-- Añadir columnas
ALTER TABLE alumnos ADD COLUMN telefono VARCHAR(20);
ALTER TABLE alumnos ADD COLUMN activo BOOLEAN NOT NULL DEFAULT TRUE;

-- Modificar tipo o nulabilidad
ALTER TABLE alumnos MODIFY COLUMN telefono VARCHAR(30) NULL;

-- Renombrar columna (MySQL 8.0+)
ALTER TABLE alumnos RENAME COLUMN telefono TO tel_contacto;

-- Añadir y eliminar restricciones
ALTER TABLE cursos ADD CONSTRAINT uq_cursos_codigo UNIQUE (codigo);
ALTER TABLE cursos DROP INDEX uq_cursos_codigo;  -- UNIQUE crea un índice; se elimina como índice

-- Añadir/eliminar clave foránea (nómbrala explícitamente)
ALTER TABLE matriculas
  ADD CONSTRAINT fk_matr_curso FOREIGN KEY (curso_id) REFERENCES cursos(id);

ALTER TABLE matriculas
  DROP FOREIGN KEY fk_matr_curso;

-- Renombrar tabla
ALTER TABLE alumnos RENAME TO estudiantes;
```

Consejos:
- Pon nombres explícitos a las restricciones (`CONSTRAINT nombre ...`) para gestionarlas luego.
- Cambios de columna con datos existentes pueden fallar; valida longitudes y nulos antes.
- Cambiar una columna usada por FK puede requerir soltar la FK primero.

---

## DROP TABLE

```sql
DROP TABLE IF EXISTS matriculas;
DROP TABLE IF EXISTS cursos;
DROP TABLE IF EXISTS alumnos;
```

- Respeta el orden: elimina primero tablas hijas (con FKs) y luego las padres.
- Evita usar `SET FOREIGN_KEY_CHECKS=0` salvo que entiendas las consecuencias (puede dejar datos huérfanos).

---

## Claves y restricciones (detalle)

- PRIMARY KEY (PK): identifica de forma única una fila. Implica índice único, no nulo.
- FOREIGN KEY (FK): asegura integridad referencial entre tablas. Requiere tipos compatibles e índices.
- UNIQUE: garantiza unicidad; puede ser por varias columnas (índice único compuesto).
- NOT NULL: prohíbe valores nulos.
- DEFAULT: valor por defecto. En MySQL debe ser un literal; para `TIMESTAMP/DATETIME` se permite `CURRENT_TIMESTAMP` y `ON UPDATE CURRENT_TIMESTAMP`.
- CHECK: valida una condición booleana sobre la fila. Aplicado a partir de MySQL 8.0.16.

Ejemplos de patrones útiles:
```sql
-- Clave compuesta como PK
CREATE TABLE detalle (
  pedido_id INT,
  linea INT,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad > 0),
  precio_unit DECIMAL(10,2) NOT NULL CHECK (precio_unit >= 0),
  PRIMARY KEY (pedido_id, linea),
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Único compuesto (ej.: un email por empresa)
CREATE TABLE contactos (
  empresa_id INT NOT NULL,
  email VARCHAR(150) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT uq_contacto UNIQUE (empresa_id, email)
);
```

---

## Buenas prácticas y errores comunes

- Define `CHARACTER SET`/`COLLATE` al crear la base de datos; heredan a tablas/columnas.
- Nombra todas las restricciones: facilita `ALTER TABLE ... DROP ...`.
- Usa `IF NOT EXISTS` / `IF EXISTS` para idempotencia en scripts.
- Evita `TEXT`/`BLOB` para columnas que necesiten `DEFAULT` o índice de longitud completa.
- Para importes usa `DECIMAL(p,s)`, no `FLOAT`.
- Antes de `DROP` asegúrate de backups; DDL suele ser irreversible.
