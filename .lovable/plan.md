# Aviso por correo de accesos de administradores

## Qué se agrega

Nueva opción en el menú **Configuración** (solo Administrador de sistema): **Aviso de accesos**.

En esa pantalla se captura:
- **Correo(s) destino** donde llegarán los avisos (se permiten varios separados por coma).
- **Activo** Sí/No.
- **Asunto** y **texto** del aviso, editables, con variables que se insertan con un botón (igual que el texto de WhatsApp de citas):
  - `@@USUARIO` (usuario de acceso)
  - `@@NOMBRE` (nombre completo)
  - `@@ROL`
  - `@@FECHA` (dd/mm/aaaa)
  - `@@HORA` (hh:mm:ss)
  - `@@IP`
  - `@@CLINICA` (clínicas del administrador; vacío para Administrador de sistema)
- Vista previa con datos de ejemplo y botón **Enviar prueba**.

Texto por omisión:
> Aviso de acceso: el usuario @@USUARIO (@@NOMBRE), rol @@ROL, ingresó al sistema el @@FECHA a las @@HORA desde la IP @@IP.

## Cuándo se envía

Cada vez que un **Administrador de clínica** o **Administrador de sistema** inicia sesión correctamente. Se usa la cuenta emisora ya definida en "Configuración de correo". Fecha y hora se toman de SQL Server. Si el envío falla, el usuario entra igual y el error se registra en la bitácora (no se bloquea el acceso). Cada envío queda en `LOG`.

## Detalles técnicos

- Parche `php-app/sql/patches/2026-09-28_aviso_acceso.sql`: tabla `citas.CONFIG_AVISO_ACCESO` (fila única: `destinos VARCHAR(500)`, `asunto VARCHAR(200)`, `plantilla VARCHAR(2000)`, `activo BIT`, auditoría), SPs `spRegresaConfigAvisoAcceso` y `spGuardaConfigAvisoAcceso` (upsert + `LOG`), `GRANT EXECUTE` a `citasadmin`. También al final de `schema.sql`.
- Nuevo `app/models/ConfigAvisoAccesoModel.php`: `obtener()`, `guardar()`, `porDefecto()`, `render($plantilla, $datos)` (sustituye `@@...`, escapa HTML).
- Nuevo `app/core/AvisoAcceso.php`: `notificar($user, $ip)` — lee config, si activa y rol admin arma el mensaje y usa `Mailer::enviar()` con la config SMTP; captura toda excepción y la registra.
- `OpcionesController.php`: acciones `avisoAcceso`, `avisoAccesoGuardar`, `avisoAccesoPrueba` (`admin_sistema`, validación de cada correo con `FILTER_VALIDATE_EMAIL`, límites de longitud, CSRF global).
- Nueva vista `app/views/opciones/aviso_acceso.php` con botones de variables y vista previa JS.
- `AuthController.php`: tras login exitoso llama `AvisoAcceso::notificar()` (IP con la misma lógica de `TRUSTED_PROXY` usada en contratos).
- `header.php`: enlace `opciones/avisoAcceso` en Configuración con icono de sobre/escudo.

## Archivos a crear/actualizar (por prioridad)

1. `php-app/sql/patches/2026-09-28_aviso_acceso.sql` (nuevo) — ejecutarlo primero.
2. `php-app/app/models/ConfigAvisoAccesoModel.php` (nuevo)
3. `php-app/app/core/AvisoAcceso.php` (nuevo)
4. `php-app/app/controllers/OpcionesController.php`
5. `php-app/app/views/opciones/aviso_acceso.php` (nuevo)
6. `php-app/app/controllers/AuthController.php`
7. `php-app/app/views/layout/header.php`
8. `php-app/sql/schema.sql`
