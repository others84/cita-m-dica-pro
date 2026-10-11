# Protección anti-bots en la cita pública

Hoy la página pública deja crear pacientes, agendar y pedir códigos OTP sin ningún freno por IP ni verificación humana. Se agregan dos defensas: un CAPTCHA y límites por IP.

## Qué verá el paciente

- Una casilla "No soy un robot" (Cloudflare Turnstile, gratis, casi siempre se resuelve sola) antes de **Enviar código** y antes de **Agendar**.
- Si alguien excede los límites: "Se alcanzó el máximo de solicitudes desde tu conexión. Intenta más tarde o llama a la clínica."

## Límites por IP (configurables por el Administrador de sistema)

| Acción | Límite por defecto |
|---|---|
| Buscar celular | 20 por hora |
| Envío de código OTP | 10 por hora (además del límite actual de 5 por celular) |
| Alta de paciente nuevo | 3 por día |
| Agendar cita | 5 por día |

Además: máximo 2 citas futuras agendadas por el mismo celular con el mismo médico.

## Pantalla de configuración (Administrador de sistema)

Nueva opción "Protección cita pública" en Configuración: activar CAPTCHA, clave pública y clave secreta de Turnstile (secreta cifrada con `APP_KEY`, como SMTP/WhatsApp) y los cuatro límites. Si el CAPTCHA está desactivado o sin claves, los límites por IP siguen funcionando.

## Archivos a modificar o crear (por prioridad)

1. `php-app/sql/patches/2026-10-11_antibot_cita_publica.sql` (nuevo) y `sql/schema.sql`: tabla `citas.LIMITE_IP` (ip, acción, fecha), tabla `citas.CONFIG_ANTIBOT` (fila única), SPs `spRegistraLimiteIp`, `spCuentaLimiteIp`, `spPurgaLimiteIp`, `spRegresaConfigAntibot`, `spGuardaConfigAntibot`, conteo de citas futuras por celular/médico, con GRANT EXECUTE.
2. `php-app/app/controllers/CitapublicaController.php`: validar CAPTCHA y límite por IP en `buscar`, `enviarCodigo`, `reenviarCodigo` y `agendar`; registrar cada acción exitosa; rechazos al LOG.
3. `php-app/app/views/citapublica/index.php`: widget Turnstile y mensajes de límite.
4. `php-app/app/core/Captcha.php` (nuevo): verificación servidor contra Cloudflare vía cURL, con tiempo de espera.
5. `php-app/app/models/LimiteIpModel.php` (nuevo) y `ConfigAntibotModel.php` (nuevo).
6. `php-app/app/controllers/OpcionesController.php` + `app/views/opciones/antibot.php` (nuevo): pantalla de configuración solo para Administrador de sistema.
7. `php-app/app/views/layout/header.php`: opción de menú con icono de escudo.
8. `php-app/app/models/LogModel.php`: eventos "BLOQUEO IP" y "CAPTCHA FALLIDO".

## Notas técnicas

- IP tomada de `REMOTE_ADDR`; `X-Forwarded-For` solo si se configura un proxy de confianza (evita falsificación).
- Purga automática de registros de `LIMITE_IP` con más de 2 días.
- Se ejecuta el parche en `CitasMedicas` y en `citasMedicasDEMO` (cambiando el `USE`).
- Para Turnstile hay que crear un sitio gratis en Cloudflare para `sgcopuebla.com.mx` y pegar las dos claves en la nueva pantalla.
