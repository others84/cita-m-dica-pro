# Despliegue en Ubuntu 26.04 + Apache 2 + PHP-FPM 8.5

Ruta de la aplicación: `/var/www/citas` (raíz web: `/var/www/citas/public`)
Usuario propietario: `citasuser:citasuser`
Dominio: `https://www.sgcopuebla.com.mx`

---

## 1. Módulos de Apache

```bash
a2enmod proxy proxy_fcgi rewrite headers ssl setenvif
systemctl restart apache2
```

## 2. VirtualHost

Guardar como `/etc/apache2/sites-available/sgcopuebla.conf`.

Es la adaptación del VirtualHost de XAMPP (`citas.local`, `D:/xampp/htdocs/citas/public`)
a rutas Linux, PHP-FPM, dominio real y HTTPS.

```apache
# ---- HTTP: solo redirige a HTTPS ----
<VirtualHost *:80>
    ServerName  www.sgcopuebla.com.mx
    ServerAlias sgcopuebla.com.mx

    RewriteEngine On
    RewriteRule ^/?(.*)$ https://www.sgcopuebla.com.mx/$1 [R=301,L]

    ErrorLog  ${APACHE_LOG_DIR}/sgcopuebla_error.log
    CustomLog ${APACHE_LOG_DIR}/sgcopuebla_access.log combined
</VirtualHost>

# ---- HTTPS: el sitio ----
<VirtualHost *:443>
    ServerName    www.sgcopuebla.com.mx
    ServerAlias   sgcopuebla.com.mx
    ServerAdmin   webmaster@sgcopuebla.com.mx

    DocumentRoot /var/www/citas/public

    <Directory /var/www/citas/public>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted

        # No servir archivos sensibles (.env, .sql, logs, config)
        <FilesMatch "(^\.|\.(env|sql|log|properties|md|sh|ini)$)">
            Require all denied
        </FilesMatch>
    </Directory>

    # Nunca exponer las carpetas internas de la app
    <DirectoryMatch "^/var/www/citas/(app|config|sql|storage)">
        Require all denied
    </DirectoryMatch>

    # PHP a través de PHP-FPM 8.5
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.5-fpm.sock|fcgi://localhost"
    </FilesMatch>
    ProxyTimeout 120

    # Cabeceras de seguridad
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set Referrer-Policy "no-referrer"
    Header always set Strict-Transport-Security "max-age=15552000"

    # SSL (certbot sobrescribe/añade estas líneas)
    SSLEngine on
    # SSLCertificateFile    /etc/letsencrypt/live/www.sgcopuebla.com.mx/fullchain.pem
    # SSLCertificateKeyFile /etc/letsencrypt/live/www.sgcopuebla.com.mx/privkey.pem

    ErrorLog  ${APACHE_LOG_DIR}/sgcopuebla_error.log
    CustomLog ${APACHE_LOG_DIR}/sgcopuebla_access.log combined
</VirtualHost>
```

Activar:

```bash
a2dissite 000-default
a2ensite sgcopuebla
apachectl configtest        # debe decir: Syntax OK
systemctl reload apache2
```

> Si el certificado aún no existe, Apache no arrancará el bloque `*:443`.
> En ese caso, primero deja solo el bloque `*:80` sirviendo el sitio
> (`DocumentRoot`, `<Directory>`, `<FilesMatch>` de PHP), emite el certificado
> con certbot y luego aplica este archivo completo.

## 3. Certificado Let's Encrypt

Requiere que el DNS de ambos nombres ya apunte a la IP del servidor.

```bash
apt install -y certbot python3-certbot-apache
certbot --apache -d www.sgcopuebla.com.mx -d sgcopuebla.com.mx
systemctl reload apache2
```

Renovación automática: `systemctl list-timers | grep certbot`

## 4. Código y permisos

```bash
mkdir -p /var/www/citas
# copiar el contenido de php-app/ a /var/www/citas/

chown -R citasuser:citasuser /var/www/citas
find /var/www/citas -type d -exec chmod 755 {} \;
find /var/www/citas -type f -exec chmod 644 {} \;

mkdir -p /var/www/citas/storage/logs
chown -R citasuser:citasuser /var/www/citas/storage
chmod 770 /var/www/citas/storage/logs

mkdir -p /var/lib/citas/tmp
chown -R citasuser:citasuser /var/lib/citas/tmp
chmod 700 /var/lib/citas/tmp
```

## 5. Configuración de la aplicación

```bash
cp /var/www/citas/.env.example /var/www/citas/.env
chown citasuser:citasuser /var/www/citas/.env
chmod 600 /var/www/citas/.env
openssl rand -hex 32        # valor para APP_KEY
nano /var/www/citas/.env
```

Contenido:

```
DB_INSTANCE=localhost
DB_NAME=CitasMedicas
DB_USER=citasadmin
DB_PASSWORD=<contraseña real>
DB_PORT=1433
LOG_RETENTION_DAYS=30
APP_KEY=<el valor generado arriba>
```

`config/config.properties` es opcional: el `.env` tiene prioridad.
Si lo creas, aplícale también `chmod 600`.

## 6. Verificación

```bash
apachectl configtest
systemctl reload apache2
ps -o user,pid,cmd -C php-fpm8.5     # pool www debe correr como citasuser
```

En el navegador:

1. `https://www.sgcopuebla.com.mx/` → pantalla de login.
2. `https://www.sgcopuebla.com.mx/auth/login` → carga (confirma que mod_rewrite funciona).
3. `https://www.sgcopuebla.com.mx/.env` → **403** (bloqueo correcto).
4. `http://www.sgcopuebla.com.mx/` → redirige a HTTPS.
5. Iniciar sesión (valida sesión, CSRF y conexión a SQL Server).

Prueba temporal de PHP (borrar después):

```bash
sudo -u citasuser bash -c 'echo "<?php phpinfo();" > /var/www/citas/public/info.php'
# abrir https://www.sgcopuebla.com.mx/info.php
#   Server API      → FPM/FastCGI
#   pdo_sqlsrv      → presente
rm /var/www/citas/public/info.php
```

## 7. Errores frecuentes

| Síntoma | Causa | Solución |
|---|---|---|
| Se descarga el `.php` en vez de ejecutarse | falta `proxy_fcgi` o el `<FilesMatch \.php$>` | `a2enmod proxy_fcgi` y revisar el VirtualHost |
| Solo funciona `/`, el resto da 404 | falta `AllowOverride All` o `mod_rewrite` | `a2enmod rewrite` y revisar `<Directory>` |
| 503 Service Unavailable | ruta del socket incorrecta | verificar `listen` en `/etc/php/8.5/fpm/pool.d/www.conf` |
| "El driver pdo_sqlsrv no está habilitado" | extensión no cargada en FPM | `php -m` y reiniciar `php8.5-fpm` |
| Error de escritura en logs | permisos de `storage/logs` | `chown citasuser` y `chmod 770` |
