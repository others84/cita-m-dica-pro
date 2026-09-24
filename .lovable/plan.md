# Citas: ocultar "Hora fin" en citas de hoy o pasadas y registrar la hora real al atender

## 1. Ocultar el botón "Hora fin"
- En la tabla de citas, el botón "Hora fin" solo aparece si la fecha de la cita es **posterior a hoy** (mañana en adelante).
- Si la cita es de hoy o de un día anterior, el botón no se muestra.
- El servidor también lo valida: si alguien intenta abrir o guardar "Hora fin" en una cita de hoy o pasada, se rechaza con el mensaje "Ya no se puede modificar la hora fin de esta cita."

## 2. Hora fin = hora en que se marca "Atendida"
- Al presionar "Atendida", la hora fin de la cita se reemplaza por la hora actual (horas:minutos), tomada del reloj del servidor de base de datos (igual que el código de verificación, para evitar diferencias de reloj).
- Casos especiales (se conserva la hora fin original y queda registro en el log):
  - Si la hora actual es igual o anterior a la hora de inicio (se atendió antes de tiempo).
  - Si se atiende en un día distinto al de la cita.
- Se registra en el log: "CITA HORA FIN REAL id_CITA=... hora_fin=...".

## Archivos a modificar (por prioridad)
1. `php-app/app/controllers/CitasController.php` — en `atenderGuardar()` actualizar la hora fin antes de cambiar a Atendida; en `horarioForm()`/`horarioGuardar()` bloquear citas de hoy o pasadas.
2. `php-app/app/views/citas/index.php` — mostrar "Hora fin" solo si la fecha de la cita es mayor a hoy.
3. `php-app/app/models/CitaModel.php` — pequeño método para obtener fecha/hora actual de SQL Server (`SELECT GETDATE()`), reutilizando la conexión existente.

## Detalles técnicos
- La actualización de hora fin reutiliza `CitaModel::cambio()` con los datos actuales de la cita (mismo patrón que `horarioGuardar`), por lo que no hay cambios en base de datos ni procedimientos almacenados.
- La comparación de fechas en la vista usa la fecha de hoy del servidor (`date('Y-m-d')`); en el controlador se usa la fecha de SQL Server.
