# Días bloqueados en la agenda del médico

Cada médico podrá tener una lista de **fechas específicas** en las que no da consulta (vacaciones, congresos, días festivos). Esos días quedan cerrados **solo** para la página pública de Citas.

El médico, la asistente y el administrador de clínica siguen agendando normalmente desde la pantalla interna de Citas, sin importar si el día está bloqueado.

## Comportamiento

- **Página pública (Generar cita):** al elegir médico, los días bloqueados se pintan como no disponibles en el calendario y no se puede seleccionar una hora en ellos. Si aun así se intenta enviar, el sistema lo rechaza con un mensaje claro ("El médico no da consulta el 24/12/2026").
- **Nueva pantalla "Días bloqueados"** en el menú de Configuración, disponible para médico (solo el suyo), asistente y administrador de clínica (los médicos de las clínicas a las que tienen acceso). Permite:
  - Elegir el médico (cuando el rol lo permite).
  - Agregar una fecha o un rango de fechas con un motivo opcional.
  - Ver la lista de días bloqueados futuros y eliminarlos.
- **Citas ya agendadas:** se conservan tal cual. Bloquear un día no cancela ni modifica citas existentes.
- Se registra en la tabla `LOG` y en `app.log` cada alta y baja de un día bloqueado, con el nombre del médico, la fecha y el usuario que lo hizo.

## Archivos a crear / modificar (por prioridad)

1. `php-app/sql/patches/2026-09-16_dias_bloqueados_medico.sql` (nuevo) — tabla `citas.DIA_BLOQUEADO_MEDICO` (id, id_USUARIOS, fecha, motivo, auditoría, índice único por médico+fecha) y los SP `spRegresaDiasBloqueadosMedico`, `spGuardaDiaBloqueadoMedico`, `spBajaDiaBloqueadoMedico`, con inserción en `citas.LOG` y `GRANT EXECUTE` a `citasadmin`.
2. `php-app/app/models/DiaBloqueadoModel.php` (nuevo) — `porMedico()`, `futurosPorMedico()`, `guardar()` (soporta rango de fechas), `eliminar()`.
3. `php-app/app/controllers/DiasbloqueadosController.php` (nuevo) — `index()`, `guardar()`, `eliminar()`; mismo patrón de `HorariosController` (roles médico/asistente/administrador, `resolveClinicaContext()`, validación de que el médico pertenezca a las clínicas permitidas, CSRF).
4. `php-app/app/views/diasbloqueados/index.php` (nueva) — formulario (médico, fecha inicio, fecha fin opcional, motivo) y tabla de días bloqueados con botón de baja confirmada.
5. `php-app/app/controllers/CitapublicaController.php` — cargar los días bloqueados del médico, pasarlos a la vista y validar en `agendar()` que la fecha elegida no esté bloqueada (validación en servidor).
6. `php-app/app/views/citapublica/index.php` — pintar los días bloqueados como no disponibles en el calendario, junto con el bloque de comida y los fines de semana ya existentes.
7. `php-app/app/views/layout/header.php` — opción de menú "Días bloqueados" dentro de Configuración, junto a "Horario de atención", para los tres roles.
8. `php-app/app/controllers/FiltroController.php` — agregar `diasbloqueados` a la lista de destinos permitidos del filtro de clínica.
9. `php-app/sql/schema.sql` — incorporar la tabla y los SP nuevos al script base.

## Notas técnicas

- La validación real se hace en el servidor dentro de `CitapublicaController::agendar()`; el calendario es solo ayuda visual.
- Un rango de fechas se guarda como un renglón por día, para que la baja sea individual y la consulta sea directa.
- Los días bloqueados se consultan solo hacia adelante (desde hoy) en la pantalla de captura; la validación pública usa la fecha exacta solicitada.
- Ningún cambio afecta a `CitasController.php`, `citas/form.php` ni al calendario interno: el agendado interno queda sin restricciones.
