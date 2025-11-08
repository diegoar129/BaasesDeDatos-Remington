-- setup_parcial.sql
-- Crea la base de datos y carga datos de prueba para el parcial

DROP DATABASE IF EXISTS parcial_db;
CREATE DATABASE parcial_db CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE parcial_db;

-- Tablas
CREATE TABLE categorias (
  id INT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE productos (
  id INT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  categoria_id INT,
  sku VARCHAR(30),
  stock INT DEFAULT 0,
  activo BOOLEAN DEFAULT TRUE,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_prod_cat FOREIGN KEY (categoria_id) REFERENCES categorias(id)
) ENGINE=InnoDB;

CREATE TABLE clientes (
  id INT PRIMARY KEY,
  email VARCHAR(150) NOT NULL,
  nombre VARCHAR(120) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE pedidos (
  id INT PRIMARY KEY,
  cliente_id INT NOT NULL,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ped_cli FOREIGN KEY (cliente_id) REFERENCES clientes(id)
) ENGINE=InnoDB;

CREATE TABLE pedido_detalle (
  pedido_id INT NOT NULL,
  linea INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (pedido_id, linea),
  CONSTRAINT fk_det_ped FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
  CONSTRAINT fk_det_prod FOREIGN KEY (producto_id) REFERENCES productos(id)
) ENGINE=InnoDB;

-- Datos: categorías
INSERT INTO categorias (id, nombre) VALUES
  (1, 'Electrónica'),
  (2, 'Hogar'),
  (3, 'Jardín');

-- Datos: productos (IDs concretos para previsibilidad)
INSERT INTO productos (id, nombre, precio, categoria_id, sku, stock, activo) VALUES
  (1, 'Auriculares', 29.90, 1, 'SKU-AUR-001', 50, TRUE),
  (2, 'Televisor', 499.00, 1, 'SKU-TEL-001', 10, TRUE),
  (3, 'Silla', 85.50, 2, 'SKU-SIL-001', 30, TRUE),
  (4, 'Mesa', 129.00, 2, 'SKU-MES-001', 15, FALSE),
  (5, 'Manguera', 24.99, 3, NULL, 80, TRUE),
  (6, 'Tijeras', 12.49, 3, 'SKU-TIJ-001', 40, TRUE);

-- Clientes
INSERT INTO clientes (id, email, nombre) VALUES
  (1, 'ana@example.com', 'Ana'),
  (2, 'luis@example.com', 'Luis'),
  (3, 'maria@example.com', 'María');

-- Pedidos
INSERT INTO pedidos (id, cliente_id, creado_en) VALUES
  (1, 1, '2025-05-20 10:00:00'),
  (2, 1, '2025-06-01 12:00:00'),
  (3, 2, '2025-06-03 09:30:00');

-- Pedido detalle
INSERT INTO pedido_detalle (pedido_id, linea, producto_id, cantidad, precio_unitario) VALUES
  (1, 1, 1, 1, 29.90),
  (1, 2, 3, 2, 85.50),
  (2, 1, 2, 1, 499.00),
  (2, 2, 5, 3, 24.99),
  (3, 1, 4, 1, 129.00);

-- Opcional: ver datos
SELECT 'OK - parcial_db ready' AS status;
