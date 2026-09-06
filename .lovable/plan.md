# Adaptar la configuración de Apache existente para levantar la app

## Objetivo
Servir la aplicación PHP MVC desde `/var/www/citas/public` sobre Apache 2 + PHP-FPM 8.5,
con HTTPS (`https://www.sgcopuebla.com.mx`), URLs limpias (que requiere la app) y bloqueo de
archivos sensibles. Se adapta la configuración de Apache que ya tienes; no se empieza de 0.

## Lo que la app necesita del servidor web (verificado en el código)
- **DocumentRoot** = `/var/www/citas/public` (allí está `index.php`).
- **mod_rewrite + `AllowOverride All`**: la app usa URLs limpias mediante
  `php-app/public/.htaccess` (`RewriteRule ^(.*)$ index.php?url=$1`). Si no se habilita el
  rewrite/override, todas las rutas distintas de `/` devuelven 404.
- **PHP ejecutado por PHP-FPM** vía `proxy_fcgi` al socket `/run/php/php8.5-fpm.sock`
  (pool `www` corriendo como `citasuser`, socket con dueño `www-data` para que Apache lo lea).
- **Extensiones PHP ya presentes**: `pdo_sqlsrv`, `sqlsrv`, `mbstring`, openssl, opcache.
- **Directorio escribible**: `storage/logs/` (la app escribe `app-YYYY-MM-DD.log` ahí).
- **Sesiones**: `session.save_path = /var/lib/citas/tmp` (ya configurado en el pool FPM).
- **Archivos que NO deben servirse**: `.env`, `config/config.properties`, `*.sql`, `*.log`.

## Archivos de servidor a crear/modificar (Apache)

### 1. `php-app/public/.htaccess` — ya existe y NO se modifica
Confirmado: ya tiene el rewrite correcto. Solo debe funcionar (requiere `AllowOverride All`
y `mod_rewrite` en Apache).

### 2. Habilitar módulos de Apache
```
a2enmod proxy proxy_fcgi rewrite headers ssl setenvif
systemctl restart apache2
```

### 3. `/etc/apache2/sites-available/sgcopuebla.conf` (nuevo / reemplazo del VirtualHost)
Definir el sitio con:
- `ServerName www.sgcopuebla.com.mx`
- `ServerAlias sgcopuebla.com.mx`
- `DocumentRoot /var/www/citas/public`
- `<Directory /var/www/citas/public>` con `AllowOverride All`, `Require all granted`,
  `Options -Indexes +FollowSymLinks`
- Proxy a PHP-FPM:
  `<FilesMatch \.php$>` → `SetHandler "proxy:unix:/run/php/php8.5-fpm.sock|fcgi://localhost"`
  y `ProxyTimeout 60`.
- Bloqueo de archivos sensibles dentro de `<Directory>`:
  `<FilesMatch "(^\.|\.(env|sql|log|properties|md|sh)$)">` → `Require all denied`
- Cabeceras de seguridad: `X-Content-Type-Options`, `X-Frame-Options SAMEORIGIN`,
  `Referrer-Policy`.
- Logs: `ErrorLog`/`CustomLog` con prefijo `sgcopuebla_`.

Se te entregará el archivo completo para pegarlo; si prefieres adaptar el que ya tienes, basta
con cambiar `DocumentRoot`, `ServerName/ServerAlias`, habilitar el `<FilesMatch>` de PHP-FPM,
asegurar `AllowOverride All` y añadir el bloqueo de archivos sensibles.

### 4. Redirección HTTPS (puerto 80 → 443)
En el mismo `sgcopuebla.conf`, el bloque `*:80` solo redirige a `https://www.sgcopuebla.com.mx`
(301). El contenido se sirve en el bloque `*:443`.

### 5. Certificado Let's Encrypt
```
apt install -y certbot python3-certbot-apache
certbot --apache -d www.sgcopuebla.com.mx -d sgcopuebla.com.mx
```
Certbot editará el VirtualHost para añadir HTTPS y la redirección automáticamente; si lo
dejamos, el paso 4 lo gestiona certbot y no hace falta redirección manual.

## Archivos de la aplicación (configuración, no código)

### 6. `/var/www/citas/.env` (crear copiando `.env.example`)
Valores reales del servidor:
```
DB_INSTANCE=<host de SQL Server o localhost\SQLEXPRESS>
DB_NAME=CitasMedicas
DB_USER=citasadmin
DB_PASSWORD=<la que definas>
DB_PORT=1433
LOG_RETENTION_DAYS=30
APP_KEY=<generar con: openssl rand -hex 32>
```
`APP_KEY` se usa para cifrar la contraseña SMTP guardada en la base de datos.

### 7. `/var/www/citas/config/config.properties` (opcional, respaldo local)
Si dejas `.env`, este archivo no es necesario. Si lo creas, tiene prioridad inferior al `.env`.
Mantener fuera del acceso web (ya queda bloqueado por la regla `*.properties`).

## Permisos y propiedad
```
chown -R citasuser:citasuser /var/www/citas
find /var/www/citas -type d -exec chmod 755 {} \;
find /var/www/citas -type f -exec chmod 644 {} \;
mkdir -p /var/www/citas/storage/logs
chown -R citasuser:citasuser /var/www/citas/storage
chmod 770 /var/www/citas/storage/logs
# sesiones (ya creado en el paso de PHP-FPM)
chown -R citasuser:citasuser /var/lib/citas/tmp
```

## Verificación final
1. `apachectl configtest` → `Syntax OK`.
2. `systemctl reload apache2`.
3. Crear `info.php` temporal en `public/`, abrir `https://www.sgcopuebla.com.mx/info.php`,
   confirmar que `pdo_sqlsrv` aparece y el Server API dice `FPM-FastCGI`. Borrar el archivo.
4. Abrir `https://www.sgcopuebla.com.mx/` → debe cargar la pantalla de login.
5. Abrir `https://www.sgcopuebla.com.mx/.env` → debe dar 403 (bloqueo correcto).
6. Probar una ruta limpia, p.ej. `/auth/login`, y un POST de login (valida CSRF + sesión).

## Resumen de archivos
**Crear/modificar en el servidor:**
- `/etc/apache2/sites-available/sgcopuebla.conf` (VirtualHost con HTTPS + PHP-FPM + rewrite + bloqueo)
- `/var/www/citas/.env` (credenciales y APP_KEY)
- `/var/www/citas/config/config.properties` (opcional, respaldo)

**No se tocan:** `php-app/public/.htaccess` (ya correcto), ni código de la aplicación.

## Pendiente de tu lado
Para que la adaptación sea línea por línea sobre lo que ya tienes, pégame el contenido de tu
VirtualHost actual (el archivo en `sites-available/` que apunta al dominio) y de
`/etc/apache2/ports.conf` si lo modificaste. Con eso entrego el `sgcopuebla.conf` ya adaptado
a tus rutas y no uno genérico.
