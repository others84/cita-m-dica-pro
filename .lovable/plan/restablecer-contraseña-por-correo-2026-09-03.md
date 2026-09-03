# Restablecer contraseña por correo

Los usuarios de cualquier rol podrán recuperar su acceso desde la pantalla de login, y el administrador de sistema podrá configurar la cuenta de correo desde la que salen esos avisos.

## Cómo funcionará

1. En el login aparece el enlace "¿Olvidaste tu contraseña?".
2. El usuario escribe su nombre de usuario y su correo. Solo se envía el link si ambos coinciden con lo registrado en el sistema.
3. El mensaje siempre responde igual ("Si los datos son correctos, recibirás un correo"), para no revelar qué usuarios existen.
4. El correo lleva un link único con vigencia de 5 minutos y un solo uso.
5. Al abrirlo, el usuario captura la nueva contraseña dos veces y queda actualizada; el link se invalida y las sesiones abiertas de ese usuario dejan de ser válidas.
6. Si el link expiró o ya se usó, se muestra un aviso con opción de solicitarlo de nuevo.

## Configuración del correo (Administrador de sistema)

Nueva pantalla en Opciones → "Configuración de correo", con:

- Servidor (host), puerto, tipo de cifrado (Ninguno / TLS / SSL).
- Usuario y contraseña de la cuenta (la contraseña se guarda cifrada y nunca se vuelve a mostrar; solo se reemplaza).
- Correo y nombre del remitente.
- Botón "Enviar correo de prueba" para validar la configuración antes de guardar el uso real.

## Seguridad y bitácora

- Los tokens se guardan solo como hash; no se almacena el link en claro.
- Máximo de solicitudes por usuario/IP para evitar abuso (5 por hora).
- Se registra en la tabla LOG y en app.log: solicitud de restablecimiento, envío del correo, restablecimiento exitoso, intento con link inválido/expirado, y cada cambio en la configuración de correo (qué usuario y qué valores, sin contraseña).

## Detalle técnico

Archivos a crear/modificar, por prioridad:

1. `php-app/sql/patches/2026-09-03_password_reset_config_correo.sql` — tabla `citas.PASSWORD_RESET` (id, id_USUARIOS, token_hash, expira, usado, ip, fecha_alta) y tabla `citas.CONFIG_CORREO` (fila única: host, puerto, cifrado, usuario, password cifrada, remitente, nombre remitente, activo). SPs: `spAltaPasswordReset`, `spRegresaPasswordReset`, `spUsaPasswordReset`, `spRegresaConfigCorreo`, `spGuardaConfigCorreo`, más GRANT EXECUTE al usuario de la aplicación y escritura en LOG desde los SPs.
2. `php-app/sql/schema.sql` — incorporar las mismas tablas y SPs al esquema base.
3. `php-app/app/core/Mailer.php` — cliente SMTP mínimo por sockets (`stream_socket_client`, EHLO/STARTTLS/AUTH LOGIN/DATA), sin dependencias externas; correo en HTML + texto plano.
4. `php-app/app/models/PasswordResetModel.php` y `php-app/app/models/ConfigCorreoModel.php` — acceso vía SPs; cifrado de la contraseña SMTP con `openssl_encrypt` (AES-256-GCM) usando una clave derivada de `APP_KEY` en `.env` (con respaldo generado en el primer guardado).
5. `php-app/app/controllers/AuthController.php` — acciones `recuperar` (form + POST), `restablecer` (GET con token + POST nueva contraseña), verificación usuario+correo, límite de intentos, envío del correo y logging.
6. `php-app/app/views/auth/recuperar.php` y `php-app/app/views/auth/restablecer.php` — vistas públicas con el mismo encabezado/pie del login, CSRF y validación de longitud mínima.
7. `php-app/app/views/auth/login.php` — enlace "¿Olvidaste tu contraseña?" debajo del botón Acceder.
8. `php-app/app/controllers/OpcionesController.php` — acciones `correo` (form), `correoGuardar` y `correoPrueba`, restringidas a `admin_sistema`.
9. `php-app/app/views/opciones/correo.php` — formulario de configuración SMTP con prueba de envío.
10. `php-app/app/views/layout/header.php` — nueva opción "Configuración de correo" en el grupo Opciones del rol `admin_sistema`.
11. `php-app/app/models/UsuarioModel.php` — método para localizar usuario por usuario+correo (usando `spRegresaUsuarios`) reutilizando `cambioPassword` para el cambio final.
12. `php-app/public/assets/css/style.css` — estilos mínimos para las vistas de recuperación (reutilizando `.login-card`).
13. `php-app/.env.example` — documentar `APP_KEY` para el cifrado de la contraseña SMTP.

Notas: las rutas `auth/recuperar` y `auth/restablecer` quedan públicas (sin sesión); el resto del flujo de login no cambia.
