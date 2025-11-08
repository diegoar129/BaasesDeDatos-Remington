# Parcial — Bases de Datos y SQL

Instrucciones generales

- Duración sugerida: 60 minutos.
- Entregables: un archivo `respuestas.txt` (o `.sql`) con las respuestas a las preguntas de opción múltiple y las soluciones SQL para las prácticas.
- Entorno: MySQL 8.0+ (puedes usar MySQL Workbench o el cliente `mysql`).
- Antes de empezar: ejecuta el script `setup_parcial.sql` en tu entorno para crear la base de datos y los datos de prueba. El examen asume que la base se llama `parcial_db`.

Cómo ejecutar el setup en PowerShell (Windows) con cliente `mysql`:

```powershell
# Desde PowerShell, asumiendo mysql en PATH
mysql -u root -p < "c:\Users\juand\GitHub\Material\Baases de datos\5. Parcial\setup_parcial.sql"
```

En Workbench: abre el archivo `setup_parcial.sql`, ejecútalo en una nueva pestaña de SQL asegurándote de que la conexión sea a tu servidor local.

Reglas del examen

- Las primeras 10 preguntas son de opción múltiple (marca una sola respuesta correcta cada una).
- Las últimas 10 son prácticas: escribe las consultas SQL solicitadas. Se evalúa sintaxis y semántica (que la consulta devuelva lo pedido).
 - Las primeras 25 preguntas son de opción múltiple (marca una sola respuesta correcta cada una).
 - Las últimas 10 son prácticas: escribe las consultas SQL solicitadas (numeradas 26–35). Se evalúa sintaxis y semántica (que la consulta devuelva lo pedido).
 - Las primeras 25 preguntas son de opción múltiple (marca una sola respuesta correcta cada una). Además existe una Parte C (preguntas 36–45) basada en el libro "Fundamentos de Sistemas de Bases de Datos".
 - Las últimas 10 son prácticas: escribe las consultas SQL solicitadas (numeradas 26–35). Se evalúa sintaxis y semántica (que la consulta devuelva lo pedido).
- Puedes usar cualquier recurso (internet, apuntes), pero haz el examen en el tiempo sugerido.
- Guarda tus respuestas en un archivo `respuestas_parcial.txt` o `respuestas_parcial.sql` y entrégalo al profesor.

Archivos en esta carpeta

- `setup_parcial.sql` — script para crear la base `parcial_db` y cargar datos.
- `parcial.md` — enunciado del parcial (preguntas).
- `soluciones.md` — claves y respuestas (no abrir hasta entregar el parcial).

Buena suerte.