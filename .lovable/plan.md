# Citas: ocultar "Hora fin" en citas de hoy o pasadas, registrar horas reales al atender y corregir hora del log

## 1. Ocultar el botón "Hora fin"
- En la tabla de citas, "Hora fin" solo aparece si la fecha de la cita es **posterior a hoy**.
- El servidor también lo valida: abrir o guardar "Hora fin" en una cita de hoy o pasada se rechaza con "Ya no se puede modificar la hora fin de esta cita."

## 2. Horas reales al marcar "Atendida"
- **Inicio de la consulta** = momento en que el médico presiona "Atender" (se abre la ventana de atención). Esa hora se guarda temporalmente en la sesión para esa cita.
- **Fin de la consulta** = momento en que presiona "Atendida".
- Siempre, sin importar si se atiende antes, el mismo día o después de lo programado: al guardar como Atendida, la fecha de la cita pasa a ser el día en que se presionó "Atender", la hora inicio la hora en que se presionó "Atender" y la hora fin la hora en que se presionó "Atendida".
- Si por alguna razón no se tiene la hora de inicio (p. ej. sesión expirada), se usa la hora de fin menos 1 minuto.
- La hora se toma del reloj de SQL Server para evitar diferencias de reloj.
- Log: "CITA HORAS REALES id_CITA=... fecha=... inicio=... fin=...".

## 3. Desfase de horas en app.log
- Causa: la aplicación nunca define la zona horaria de PHP, así que escribe la hora del log en la zona por defecto del servidor (UTC u otra), no en la hora de México.
- Solución: definir la zona horaria al arrancar la aplicación con una nueva variable `APP_TIMEZONE` en `.env` (por defecto `America/Mexico_City`). Afecta a app.log y a cualquier fecha calculada por PHP (p. ej. "hoy" en la tabla de citas).
- Recomendación en el servidor: revisar también `date.timezone` en el php.ini de PHP-FPM y `timedatectl` de Ubuntu.

## Archivos a modificar (por prioridad)
1. `php-app/app/controllers/CitasController.php` — `atenderForm()` guarda la hora de inicio real; `atenderGuardar()` aplica las reglas de fecha/horas antes de cambiar a Atendida; `horarioForm()`/`horarioGuardar()` bloquean citas de hoy o pasadas.
2. `php-app/public/index.php` — fijar la zona horaria desde `APP_TIMEZONE`.
3. `php-app/app/views/citas/index.php` — mostrar "Hora fin" solo si la fecha es mayor a hoy.
4. `php-app/app/models/CitaModel.php` — método para leer fecha/hora actual de SQL Server (`SELECT GETDATE()`).
5. `php-app/.env.example` — agregar `APP_TIMEZONE=America/Mexico_City` (también agregarlo en `/var/www/citas/.env` del servidor).

## Detalles técnicos
- Los cambios de fecha/horas reutilizan `CitaModel::cambio()` con los datos actuales de la cita (mismo patrón que `horarioGuardar`); no hay cambios en base de datos ni procedimientos almacenados.
