# Verificación de identidad en citas públicas por Correo o WhatsApp

Cuando un paciente ya registrado escribe su celular en la pantalla pública, hoy el sistema muestra de inmediato todos sus datos (nombre, dirección, correo, notas). Con este cambio, primero se le pedirá confirmar su identidad con un código de 4 dígitos, y él elige cómo recibirlo: por correo o por WhatsApp.

Además se agrega, dentro del módulo de Administrador de sistema, una pantalla de configuración de WhatsApp (Meta Cloud API), al mismo estilo de la que ya existe para el correo.

## Cómo funcionará

1. El paciente escribe su celular y presiona buscar.
2. Si el número existe, no se muestra ningún dato: solo aparecen las opciones de envío disponibles, con el destino enmascarado (por ejemplo, `a***@gmail.com` y `••••••1234`).
3. El paciente elige canal y recibe un código de 4 dígitos, vigente 10 minutos, con máximo 5 intentos y opción de reenviar.
4. Al validar el código, se cargan sus datos y continúa el flujo normal de la cita.
5. Si el número no existe, el paciente nuevo continúa sin código, como hoy.

Reglas de disponibilidad de canales:
- Correo aparece solo si el paciente tiene correo registrado y la configuración de correo del sistema está activa.
- WhatsApp aparece solo si la configuración de WhatsApp está activa y verificada.
- Si ningún canal está disponible, se muestra un mensaje pidiendo acudir con la asistente de la clínica; nunca se muestran los datos.

## Pantalla de configuración de WhatsApp (Administrador de sistema)

Ubicada en Configuración, junto a "Configuración de correo". Campos:
- Activo (sí/no)
- Phone Number ID
- WhatsApp Business Account ID (WABA)
- Token de acceso permanente (guardado cifrado, se muestra enmascarado)
- Versión de la API (por defecto v21.0)
- Nombre e idioma de la plantilla de código (por defecto una plantilla de autenticación)
- Botón "Enviar mensaje de prueba" a un número indicado

El token se guarda cifrado con AES-256-GCM usando `APP_KEY`, igual que la contraseña SMTP actual.

## Archivos a modificar o crear (por prioridad)

1. `php-app/sql/patch_otp_whatsapp.sql` (nuevo) y `php-app/sql/schema.sql`: tabla `citas.OTP_CITA_PUBLICA` (teléfono, hash del código, canal, intentos, expiración, usado), tabla `citas.CONFIG_WHATSAPP` (fila única, token cifrado, activo), procedimientos `spGuardaOtpCitaPublica`, `spRegresaOtpCitaPublica`, `spConsumeOtpCitaPublica`, `spRegresaConfigWhatsapp`, `spGuardaConfigWhatsapp`, con sus GRANT EXECUTE y registro en LOG.
2. `php-app/app/controllers/CitapublicaController.php`: nuevo paso de verificación (`enviarCodigo`, `verificarCodigo`, `reenviarCodigo`); `buscar()` deja de exponer datos y solo devuelve identificador interno y destinos enmascarados.
3. `php-app/app/views/citapublica/index.php`: panel de selección de canal (Correo / WhatsApp), captura del código de 4 dígitos, reenvío, mensajes de error y ayuda en lenguaje sencillo.
4. `php-app/app/models/PacienteModel.php`: método que devuelve solo id, clínica y destinos enmascarados; la carga completa de datos requiere OTP validado.
5. `php-app/app/models/OtpCitaPublicaModel.php` (nuevo): generar, guardar hash, validar, contar intentos y expirar códigos.
6. `php-app/app/models/ConfigWhatsappModel.php` (nuevo): leer/guardar configuración con cifrado del token.
7. `php-app/app/core/Whatsapp.php` (nuevo): cliente de Meta Cloud API vía cURL para enviar el código con plantilla; manejo de errores y tiempo de espera.
8. `php-app/app/controllers/OpcionesController.php`: acciones `whatsapp`, `whatsappGuardar`, `whatsappPrueba`, restringidas a Administrador de sistema.
9. `php-app/app/views/opciones/whatsapp.php` (nuevo): formulario de configuración y prueba.
10. `php-app/app/views/layout/header.php`: opción "Configuración de WhatsApp" en el menú Configuración del Administrador de sistema.
11. `php-app/app/models/LogModel.php`: eventos de envío, validación correcta, código incorrecto y bloqueo por intentos (nunca se guarda el código).
12. `php-app/public/assets/css/style.css`: estilos del panel de verificación y de la casilla del código.
13. `php-app/.env.example`: nota de que el token de WhatsApp se guarda en base de datos cifrado con `APP_KEY`.

## Notas técnicas

- El código se guarda solo como hash (SHA-256 con sal), nunca en claro, ni en base de datos ni en `app.log`.
- Límite de 5 envíos por hora por número, reutilizando el patrón del restablecimiento de contraseña.
- Respuesta uniforme ante números inexistentes para no permitir descubrir pacientes.
- El envío por WhatsApp fuera de la ventana de 24 horas requiere plantilla aprobada de tipo autenticación; el nombre de la plantilla es configurable en la pantalla nueva.
- Si el envío por WhatsApp falla, se ofrece automáticamente el canal de correo cuando exista.
