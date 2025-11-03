# Bases de Datos y SQL con MySQL — Introducción

Este documento introduce los conceptos esenciales de Bases de Datos, el modelo relacional y cómo instalar/configurar MySQL y MySQL Workbench en Windows para empezar a practicar SQL.

## Tabla de contenido

- Introducción a las Bases de Datos
  - ¿Qué es una base de datos?
  - ¿Por qué utilizarlas?
- Tipos de bases de datos
  - Relacionales (SQL)
  - No relacionales (NoSQL)
- Conceptos básicos
  - Tabla, fila (registro), columna (atributo)
  - Clave primaria (PK) y clave foránea (FK)
  - Otros conceptos útiles: esquema, índice, restricción
- El modelo relacional (visión general)
  - Entidades y relaciones
  - Normalización (1FN, 2FN, 3FN)
  - Integridad (entidad, referencial, dominio)
- Instalación y configuración de MySQL / MySQL Workbench (Windows)
  - Requisitos
  - Instalación con MySQL Installer
  - Configuración del servidor
  - Conexión y primera consulta en Workbench
  - (Opcional) Línea de comandos rápida
- Próximos pasos

---

## Introducción a las Bases de Datos

### ¿Qué es una base de datos?
Una base de datos es un sistema organizado para almacenar, gestionar y recuperar información de forma eficiente y segura. Permite que múltiples aplicaciones y usuarios accedan a los datos con control de concurrencia, integridad y seguridad.

### ¿Por qué utilizarlas?
- Persistencia: los datos sobreviven a los procesos que los usan.
- Integridad: reglas que evitan datos inválidos o inconsistentes.
- Concurrencia: múltiples usuarios/servicios pueden operar a la vez.
- Seguridad: control de acceso, auditoría, cifrado.
- Eficiencia: consultas optimizadas e índices para alto rendimiento.

## Tipos de bases de datos

### Relacionales (SQL)
- Organizan la información en tablas relacionadas entre sí.
- Se accede con SQL (Structured Query Language) para definir datos (DDL), manipularlos (DML) y consultarlos (DQL).
- Ejemplos: MySQL, PostgreSQL, SQL Server, Oracle.
- Ventajas: consistencia (ACID), flexibilidad de consulta, madurez tecnológica.

### No relacionales (NoSQL)
- Optimizadas para casos de uso específicos, a menudo con escalabilidad horizontal.
- Principales familias y ejemplos:
  - Documentos: MongoDB, CouchDB.
  - Clave-valor: Redis, DynamoDB.
  - Columnar: Cassandra, HBase.
  - Grafos: Neo4j, JanusGraph.
- Ventajas: esquemas flexibles, alto rendimiento/escala para patrones concretos.
- No sustituyen siempre a las relacionales; suelen ser complementos según el caso de uso.

## Conceptos básicos

- Tabla: estructura tabular que agrupa datos de un mismo tipo de entidad (p. ej., `clientes`).
- Fila (registro/tupla): una instancia concreta de la entidad (p. ej., un cliente).
- Columna (atributo): una propiedad de la entidad (p. ej., `email`).
- Esquema: conjunto de objetos (tablas, vistas, procedimientos) dentro de una base de datos.
- Clave primaria (PK): columna o conjunto de columnas que identifican de forma única cada fila. Debe ser única y no nula.
- Clave foránea (FK): columna(s) que referencian la PK de otra tabla para mantener la integridad referencial (relaciones 1:N o N:M mediante tabla intermedia).
- Índice: estructura auxiliar para acelerar búsquedas y ordenaciones a costa de espacio extra y coste en escrituras.
- Restricciones: reglas como `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT` que protegen la validez de los datos.

## El modelo relacional (visión general)

- Entidades y relaciones: el mundo real se modela como entidades (tablas) y relaciones entre ellas (mediante FKs).
- Normalización: proceso para reducir redundancias y anomalías de actualización. En una primera aproximación:
  - 1FN: atributos atómicos (sin listas ni campos repetidos).
  - 2FN: 1FN + cada atributo no clave depende de toda la clave (para claves compuestas).
  - 3FN: 2FN + no hay dependencias transitivas de la clave (atributos no clave no dependen entre sí).
- Integridad:
  - De entidad: PK válida y única para cada fila.
  - Referencial: FKs que apuntan a PKs existentes; reglas de borrado/actualización (`RESTRICT`, `CASCADE`, `SET NULL`).
  - De dominio: tipos y restricciones que definen valores permitidos.

## Instalación y configuración de MySQL / MySQL Workbench (Windows)

### Requisitos
- Windows 10/11 de 64 bits.
- Permisos de administrador para instalar servicios.
- Conexión a Internet para descargar instaladores.

### Instalación con MySQL Installer
1. Descarga el instalador oficial para Windows:
   - MySQL Installer: https://dev.mysql.com/downloads/installer/
   - (Workbench también puede descargarse aquí: https://dev.mysql.com/downloads/workbench/)
2. Ejecuta el instalador y elige uno de estos tipos de configuración:
   - "Developer Default": instala MySQL Server, Workbench, MySQL Shell y utilidades comunes.
   - "Custom": selecciona explícitamente `MySQL Server` y `MySQL Workbench` (recomendado si quieres control fino).
3. Sigue el asistente de instalación. Si pide dependencias (Visual C++ Redistributable), acepta la instalación.

### Configuración del servidor MySQL
Durante el asistente de configuración:
- Modo de configuración: "Standalone MySQL Server".
- Tipo: "Development Computer" (ajusta límites razonables para un equipo personal).
- Puerto: 3306 (por defecto). Si está ocupado, elige otro y recuerda el número.
- Autenticación: recomendado `Use Strong Password Encryption (caching_sha2_password)` (por defecto en versiones recientes).
- Usuario root: define una contraseña segura y guárdala en un gestor.
- Usuarios adicionales: opcionalmente crea un usuario de desarrollo con permisos limitados.
- Servicio de Windows: deja activado "Start the MySQL Server at System Startup" y un nombre de servicio como `MySQL80`.
- Aplica la configuración y espera a que los pasos marquen "Successful".

### Conexión y primera consulta en MySQL Workbench
1. Abre MySQL Workbench.
2. En "MySQL Connections", haz clic en `+` para crear una conexión:
   - Name: "Local MySQL" (o el que prefieras)
   - Hostname: `localhost`
   - Port: `3306` (o el que configuraste)
   - Username: `root` (o tu usuario)
3. Prueba la conexión (Test Connection) e introduce la contraseña.
4. Abre la conexión y ejecuta una consulta sencilla en un nuevo editor SQL:

```sql
SELECT VERSION() AS mysql_version;
```

Deberías ver la versión del servidor en el panel de resultados.

### (Opcional) Línea de comandos rápida
Si prefieres probar desde la terminal (PowerShell), puedes usar el cliente `mysql`:

```powershell
# Conectarse como root (te pedirá contraseña)
mysql -u root -p
```

Comandos básicos para crear una base de datos y tabla de ejemplo:

```sql
-- Crear base de datos y usarla
CREATE DATABASE demo_db;
USE demo_db;

-- Crear tabla
CREATE TABLE clientes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE,
  creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar y consultar
INSERT INTO clientes (nombre, email) VALUES
('Ana', 'ana@example.com'),
('Luis', 'luis@example.com');

SELECT * FROM clientes;
```
