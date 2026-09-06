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

### 3. `/etc/apache2/sites-available/sgcopuebla.conf` (adaptación de tu VirtualHost actual)
Tu configuración actual es la de XAMPP en Windows:

```text
<VirtualHost *:80>
    ServerName citas.local
    DocumentRoot "D:/xampp/htdocs/citas/public"
    <Directory "D:/xampp/htdocs/citas/public">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog  "logs/citas-error.log"
    CustomLog "logs/citas-access.log" common
</VirtualHost>
```

Lo bueno: `AllowOverride All` ya está, que es lo que hace funcionar las URLs limpias.
Cambios necesarios al pasarlo a Linux:

| Actual (XAMPP/Windows) | Nuevo (Ubuntu) | Por qué |
|---|---|---|
| `DocumentRoot "D:/xampp/htdocs/citas/public"` | `/var/www/citas/public` | Ruta Linux acordada |
| `ServerName citas.local` | `www.sgcopuebla.com.mx` + alias `sgcopuebla.com.mx` | Dominio real |
| `Options Indexes FollowSymLinks` | `Options -Indexes +FollowSymLinks` | `Indexes` expone el listado de carpetas |
| (sin PHP handler) | `<FilesMatch \.php$>` con `SetHandler proxy:unix:/run/php/php8.5-fpm.sock` | XAMPP usa mod_php; aquí PHP corre en FPM |
| (sin bloqueo) | `<FilesMatch "(^\.|\.(env|sql|log|properties|md|sh)$)">` → `Require all denied` | Evita servir `.env`, `*.sql`, logs |
| `logs/citas-*.log` (relativo) | `${APACHE_LOG_DIR}/sgcopuebla_*.log` | Ruta estándar de Ubuntu |
| solo `*:80` | `*:80` redirige a HTTPS; contenido en `*:443` | Sitio con certificado |
| (sin cabeceras) | `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy` | Endurecimiento básico |

Se te entrega el archivo completo ya adaptado, listo para pegar.

### 4. Redirección HTTPS (puerto 80 → 443)
El bloque `*:80` solo redirige a `https://www.sgcopuebla.com.mx` (301). El contenido se sirve
en el bloque `*:443`.

### 5. Certificado Let's Encrypt
```
apt install -y certbot python3-certbot-apache
certbot --apache -d www.sgcopuebla.com.mx -d sgcopuebla.com.mx
```
Certbot añade el bloque HTTPS y la redirección automáticamente. Requisito previo: que el DNS de
`www.sgcopuebla.com.mx` y `sgcopuebla.com.mx` ya apunte a la IP de este servidor.


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
