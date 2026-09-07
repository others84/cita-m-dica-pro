# Verificación por código antes de mostrar datos del paciente (cita pública)

## Sobre el SMS

No existe SMS gratuito: todos los proveedores (Twilio, Vonage, AWS) cobran por mensaje, y en México el envío a celular siempre tiene costo. WhatsApp tampoco es gratis para envíos automáticos: la API oficial de Meta cobra por conversación y exige registrar una cuenta de WhatsApp Business.

El único canal que ya está pagado y funcionando en el sistema es el **correo electrónico** (la misma configuración que se usa para restablecer contraseñas). Por eso el plan lo usa como canal principal, dejando el diseño listo para conectar WhatsApp o SMS más adelante sin rehacer nada.

## Cómo quedará el flujo

```text
1) El paciente escribe su celular
2) Si el número NO existe  -> igual que hoy: elige clínica y captura sus datos
3) Si el número SÍ existe   -> NO se muestra ningún dato todavía
   - Se envía un código de 4 dígitos al correo registrado de ese paciente
   - En pantalla solo se ve el correo enmascarado (ej. ma****@gm***.com)
   - El paciente escribe el código
     - Correcto  -> se cargan sus datos y sigue el flujo normal de la cita
     - Incorrecto-> "El código no coincide", hasta 5 intentos
     - Vencido   -> "El código expiró", puede pedir uno nuevo
4) Si el paciente existente NO tiene correo registrado
   -> se le trata como paciente nuevo: captura sus datos a mano
      (nunca se muestran los datos guardados)
```

## Reglas del código

- 4 dígitos, vigencia de 10 minutos, máximo 5 intentos.
- Un solo uso: al validarse queda inutilizado.
- Máximo 3 envíos por hora por número, para evitar abuso.
- Nunca se revela si el número existe o no antes de la verificación: la pantalla siempre dice "Si el número está registrado, te enviamos un código".
- Al enviar y al validar se registra el evento en `LOG` y en `app.log` (sin el código, solo el número enmascarado y el resultado).

## Cambio de comportamiento visible

Hoy, al escribir un celular registrado, se muestran de inmediato nombre, dirección, correo, fecha de nacimiento y notas del paciente. Después del cambio, esos datos solo aparecen tras validar el código.

## Detalles técnicos

- Nueva tabla `citas.CITA_PUBLICA_OTP` (id, telefono_digitos, id_PACIENTE, id_CLINICA, codigo_hash, expira, intentos, usado, fecha_alta, ip) con `GRANT` para el login de la app; SPs `spAltaOtpCitaPublica`, `spRegresaOtpCitaPublica`, `spMarcaOtpUsado`, `spIncrementaIntentoOtp`.
- Código guardado como hash (`hash('sha256')` con `APP_KEY` como sal), nunca en claro; comparación con `hash_equals`.
- `CitapublicaController::buscar()` deja de cargar el paciente: solo genera el OTP, lo envía y pone `paso = 'codigo'`. Nuevas acciones `verificar()` y `reenviar()`. La carga real de datos (`cargarPaciente()`) se ejecuta únicamente desde `verificar()`.
- Cuando el número coincide en varias clínicas, primero se verifica el código y después se muestra la lista de clínicas (solo el nombre de la clínica, como hoy).
- Envío por `Mailer.php` con la configuración SMTP existente; el texto del mensaje queda en un helper único (`otpMensaje()`) para poder reutilizarlo si más adelante se conecta WhatsApp Cloud API o Twilio.
- Vista `citapublica/index.php`: nuevo panel "Escribe tu código" con campo numérico de 4 dígitos, botón Verificar, enlace Reenviar y el texto de ayuda en lenguaje sencillo, siguiendo la guía de pasos ya existente.

## Archivos a modificar (por prioridad)

1. `php-app/app/controllers/CitapublicaController.php` — generar, enviar, validar y reenviar el código; bloquear la carga de datos sin verificación.
2. `php-app/app/views/citapublica/index.php` — pantalla del código y ajuste de los pasos de ayuda.
3. `php-app/app/models/PacienteModel.php` — que la búsqueda por teléfono devuelva solo id, clínica y correo (sin datos personales) hasta que haya verificación.
4. `php-app/app/models/OtpCitaPublicaModel.php` (nuevo) — alta, consulta, intentos y marcado de uso del código.
5. `php-app/sql/patches/2026-09-07_otp_cita_publica.sql` (nuevo) — tabla, SPs y permisos.
6. `php-app/sql/schema.sql` — incorporar la tabla y los SPs al esquema consolidado.
7. `php-app/app/models/LogModel.php` — eventos `OTP CITA PUBLICA ENVIADO` / `VALIDADO` / `FALLIDO`.
8. `php-app/public/assets/css/style.css` — estilos del panel del código.
