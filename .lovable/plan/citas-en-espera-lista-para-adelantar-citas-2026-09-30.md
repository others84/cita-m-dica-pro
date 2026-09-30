# Citas en espera (lista para adelantar citas)

## Idea general
Algunos pacientes ya tienen su cita, pero quieren que les avisen si se libera un espacio antes. Eso se marca **en la cita**, no en el paciente, y aparece en una nueva pantalla, **"Citas en espera"**, desde donde el médico o la asistente adelantan la cita en pocos clics.

## 1. Casilla en la cita
- En el formulario para agendar o editar una cita se agrega la casilla **"En espera de un espacio anterior"**.
- En la tabla de **Citas** aparece una pequeña etiqueta "En espera" en esas citas.
- La casilla **se mantiene al adelantar la cita**, porque puede volver a moverse. Solo se quita sola cuando la cita se cancela, se atiende o se marca como "No asistió". También se puede quitar a mano desde la edición de la cita.

## 2. Nueva pantalla "Citas en espera"
- Está en el menú para Asistente, Médico y Administrador de clínica, con su propio icono (un reloj de arena). Respeta el filtro de clínica y cada médico solo ve sus propias citas.
- Muestra solo las citas **agendadas o confirmadas, a futuro y con la casilla marcada**. Van ordenadas por antigüedad de la solicitud (quien la pidió primero sale arriba) y se pueden filtrar por médico.
- Columnas: paciente, teléfono, médico, especialidad, fecha y hora actual, días que se pueden adelantar como máximo y acciones.
- El menú muestra un contador con las citas en espera, igual que el de "por notificar".

## 3. Adelantar una cita en pocos pasos
Botón **"Adelantar"** en cada fila:
1. Se abre una ventana con los **horarios libres del mismo médico** entre hoy y la fecha actual de la cita. Toma en cuenta su horario de atención, los días bloqueados y las citas ya ocupadas.
2. Se elige un horario y se presiona **"Mover cita"**. Se conservan el mismo médico, la especialidad, el consultorio y el precio, y la duración de la cita no cambia.
3. La cita sigue en la lista de espera con su nueva fecha, por si se libera otro espacio antes. Se guarda el cambio en la bitácora (fecha anterior, fecha nueva y quién la movió) y aparece un botón de **WhatsApp** con un mensaje listo que avisa al paciente de su nueva fecha.

## 4. Aviso cuando se libera un espacio (recomendado)
Cuando una cita se marca como **Cancelada** o **No asistió**, el sistema revisa si hay citas en espera con ese médico en fechas posteriores. Si las hay, muestra un mensaje: "Se liberó un espacio el 12/10 a las 10:00. Hay 3 pacientes en espera", con un botón que lleva a la pantalla filtrada. Desde ahí se adelanta la cita con un solo clic en ese mismo horario.

## Archivos a modificar, por prioridad
1. `php-app/sql/patches/2026-09-30_citas_en_espera.sql` (nuevo): agrega a la cita los datos de "en espera" y la fecha en que se marcó, actualiza los procedimientos de alta, cambio y consulta de citas y agrega un procedimiento para mover la cita y otro para listar las citas en espera. También se agrega al final de `schema.sql`.
2. `php-app/app/models/CitaModel.php`: guarda la casilla, lista las citas en espera, calcula los horarios libres y mueve la cita.
3. `php-app/app/controllers/CitasesperaController.php` (nuevo): pantalla, ventana de "Adelantar" y acción de mover, con permisos por rol y clínica.
4. `php-app/app/views/citasespera/index.php` (nuevo): tabla y ventana para elegir el horario.
5. `php-app/app/controllers/CitasController.php`: guarda la casilla al agendar o editar y muestra el aviso de espacio liberado al cancelar o marcar "No asistió".
6. `php-app/app/views/citas/form.php`: agrega la casilla.
7. `php-app/app/views/citas/index.php`: agrega la etiqueta "En espera".
8. `php-app/app/views/layout/header.php`: agrega la opción de menú, el icono y el contador.
9. `php-app/app/controllers/FiltroController.php`: agrega el destino para el filtro de clínica.
10. `php-app/public/assets/css/style.css`: estilos de la etiqueta y de la ventana.

## Detalles técnicos
- Nuevas columnas en `CITA`: `en_espera BIT NOT NULL DEFAULT 0` y `fecha_en_espera DATETIME NULL`, que sirve para dar prioridad a quien la pidió primero.
- `spAltaCita` y `spCambioCita` reciben `@en_espera` como opcional con valor 0 por defecto, para seguir funcionando con las llamadas actuales. `spRegresaCitas` también devuelve estas columnas.
- `spMueveCitaEspera(@id_CITA, @fecha, @hora_inicio, @hora_fin, @id_usuario)` revalida en el servidor que el horario siga libre, conserva `en_espera=1` y `fecha_en_espera` (para no perder la prioridad) y escribe en `LOG`.
- Al cancelar, atender o marcar "No asistió", los procedimientos correspondientes ponen `en_espera=0`.
- Los horarios libres se calculan con `HorarioMedicoModel`, `DiaBloqueadoModel` y las citas del médico. La fecha y hora de referencia se toman de SQL Server (`CitaModel::ahoraSql()`).
- Las acciones usan POST con CSRF, como en el resto del sistema.
