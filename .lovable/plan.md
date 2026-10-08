# Sitio DEMO y sitio LIVE en el mismo dominio

## Objetivo

Tener dos copias independientes del sistema en el mismo servidor:

- **Producción:** `https://sgcopuebla.com.mx/live` → base de datos `CitasMedicas`
- **Demo (pruebas con clientes):** `https://sgcopuebla.com.mx/demo` → base de datos `CitasMedicasDEMO`

Cada copia tiene su propio código, su propia configuración y su propia base de datos. Lo que pase en DEMO no afecta al productivo.

## Buenas noticias: no hay que tocar el código

Verifiqué que la aplicación construye todas sus ligas y redirecciones de forma relativa (función `url()` en `App.php`, que detecta sola la subcarpeta desde la que se ejecuta). Por eso la misma aplicación puede vivir en `/demo` y en `/live` sin cambiar ni una línea de PHP.

## Cambios a nivel servidor (Apache)

### 1. Dos carpetas de código

```bash
cp -r /var/www/citas /var/www/citas-live
cp -r /var/www/citas /var/www/citas-demo
```

- `/var/www/citas-live` → la copia productiva.
- `/var/www/citas-demo` → la copia de demostración.
- La carpeta actual `/var/www/citas` se puede conservar como respaldo o eliminar al final.

### 2. Un `.env` por copia

`/var/www/citas-live/.env` (sin cambios, apunta a la base actual):

```
DB_INSTANCE=localhost
DB_NAME=CitasMedicas
DB_USER=citasadmin
DB_PASSWORD=<la actual>
DB_PORT=1433
APP_KEY=<la actual>
```

`/var/www/citas-demo/.env` (apunta a la base DEMO y con su propia APP_KEY):

```
DB_INSTANCE=localhost
DB_NAME=CitasMedicasDEMO
DB_USER=citasadmin
DB_PASSWORD=<la actual>
DB_PORT=1433
APP_KEY=<generar otra con: openssl rand -hex 32>
```

Permisos en ambas: `chown citasuser:citasuser .env && chmod 600 .env`.

### 3. VirtualHost de Apache

En `/etc/apache2/sites-available/sgcopuebla.conf`, dentro del bloque `*:443`, se reemplaza el `DocumentRoot` directo por dos alias:

```apache
# Quitar: DocumentRoot /var/www/citas/public

Alias /live /var/www/citas-live/public
Alias /demo /var/www/citas-demo/public

<Directory /var/www/citas-live/public>
    Options -Indexes +FollowSymLinks
    AllowOverride All
    Require all granted
    <FilesMatch "(^\.|\.(env|sql|log|properties|md|sh|ini)$)">
        Require all denied
    </FilesMatch>
</Directory>

<Directory /var/www/citas-demo/public>
    Options -Indexes +FollowSymLinks
    AllowOverride All
    Require all granted
    <FilesMatch "(^\.|\.(env|sql|log|properties|md|sh|ini)$)">
        Require all denied
    </FilesMatch>
</Directory>

<DirectoryMatch "^/var/www/citas-(live|demo)/(app|config|sql|storage)">
    Require all denied
</DirectoryMatch>

# PHP por PHP-FPM (el bloque <FilesMatch \.php$> actual se conserva igual)
```

El `.htaccess` de cada copia ya funciona con `Alias` sin modificarse (Apache ajusta la ruta base automáticamente).

Después:

```bash
apachectl configtest     # debe decir Syntax OK
systemctl reload apache2
```

### 4. Sesiones y bitácoras separadas

Cada copia ya escribe sus propios logs en su propia carpeta `storage/logs/`. Las sesiones de PHP se comparten en `/var/lib/citas/tmp`, pero no hay conflicto porque cada sitio se identifica por su ruta (`/demo` y `/live` generan cookies de sesión distintas). No requiere cambio.

### 5. Preparar la base `CitasMedicasDEMO`

Como la base DEMO ya existe, solo hay que dejarla al día:

1. Verificar que tenga la misma estructura que la productiva: aplicar en `CitasMedicasDEMO` todos los parches de `php-app/sql/patches/` que ya se hayan aplicado en producción (contratos, aviso de acceso, citas en espera, municipio opcional, borrado de citas, etc.).
2. Cargar el catálogo de estados y municipios: `2026-10-08_catalogo_estados_municipios_mexico.sql`.
3. Crear en DEMO al menos: 1 usuario `admin_sistema`, 1 clínica de ejemplo, 1 administrador de clínica, 1 médico, 1 asistente, el consultorio y la especialidad `GENERICO` (los usa la cita pública).
4. Opcional: datos de prueba (pacientes y citas ficticias) para las demostraciones.

### 6. Detalles a considerar en DEMO

- **Correos y WhatsApp:** la copia DEMO enviará correos y generará enlaces de WhatsApp igual que la productiva. Conviene configurar en DEMO otra cuenta de correo (o dejarla sin configurar) para que los clientes de prueba no reciban avisos mezclados con los reales. Se ajusta en Configuración > Configuración de correo dentro del propio DEMO.
- **Usuarios:** los usuarios de DEMO son independientes; hay que crearlos ahí (no se copian solos).

## Verificación

1. `https://sgcopuebla.com.mx/live` → pantalla de login; entrar y confirmar que se ven los datos reales.
2. `https://sgcopuebla.com.mx/demo` → pantalla de login; entrar con el usuario de prueba y confirmar que se ven solo los datos DEMO.
3. Agendar una cita en DEMO y confirmar que NO aparece en LIVE.
4. `https://sgcopuebla.com.mx/demo/.env` → debe dar 403.
5. Probar la cita pública en ambas: `/live/citapublica` y `/demo/citapublica`.

## Archivos

**No se modifica ningún archivo del código.** Todo el trabajo es en el servidor:

1. `/etc/apache2/sites-available/sgcopuebla.conf` — los dos Alias y sus bloques Directory.
2. `/var/www/citas-live/.env` — apunta a `CitasMedicas`.
3. `/var/www/citas-demo/.env` — apunta a `CitasMedicasDEMO`.
4. Base `CitasMedicasDEMO` — aplicar parches pendientes, catálogo de estados/municipios y datos iniciales de prueba.
