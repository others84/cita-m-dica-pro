# Seguridad: sesión y credenciales

## 1. Fijación de sesión (session fixation)
Al autenticar correctamente en `login()`, regenerar el identificador de sesión antes de guardar los datos del usuario, y conservar el token CSRF actual para no romper formularios abiertos.

Comportamiento: idéntico para el usuario final; solo cambia el ID interno de sesión.

## 2. Credenciales fuera del código
- `Config::get()` pasa a consultar primero variables de entorno y luego el archivo de propiedades. Mapeo: `DB_INSTANCE`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_PORT`.
- Se agrega un cargador simple de archivo `.env` (en la raíz de `php-app/`) para desarrollo, leído al iniciar la aplicación.
- Se crea `php-app/.env.example` (sin valores reales) y `php-app/config/config.properties.example`.
- Se agrega `php-app/.gitignore` que excluye `.env`, `config/config.properties` y `storage/logs/`.
- El archivo actual `config/config.properties` se deja funcionando como respaldo (si no hay variables de entorno), pero se vacía la contraseña y se documenta que debe definirse por entorno. La contraseña real deberá cargarse en el servidor; además conviene rotarla en SQL Server ya que estuvo expuesta.

## 3. Rotación diaria de app.log
`Database::log()` escribirá en `storage/logs/app-YYYY-MM-DD.log` y borrará automáticamente los archivos con más de N días (por defecto 30, configurable con `LOG_RETENTION_DAYS`). Se mantiene un `app.log` como enlace lógico del día actual solo si es necesario para herramientas existentes; en caso contrario, se usa únicamente el archivo con fecha.

## Archivos a modificar, por prioridad
1. `php-app/app/controllers/AuthController.php` — regenerar ID de sesión tras el login.
2. `php-app/app/core/Config.php` — leer variables de entorno con prioridad y cargar `.env`.
3. `php-app/app/core/Database.php` — rotación diaria y purga de logs antiguos.
4. `php-app/app/core/App.php` — invocar la carga de `.env` al arrancar.
5. `php-app/config/config.properties` — quitar la contraseña en claro.
6. `php-app/.env.example` (nuevo) — plantilla de variables.
7. `php-app/.gitignore` (nuevo) — excluir secretos y logs.

## Nota operativa
Tras aplicar el cambio hay que crear el archivo `.env` en el servidor con la contraseña; si no, la conexión a la base de datos fallará.
