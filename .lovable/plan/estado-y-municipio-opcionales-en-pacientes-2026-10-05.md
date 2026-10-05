# Estado y municipio opcionales en Pacientes

## Objetivo

Al dar de alta un paciente, solo el **País** queda fijo en "México" (ya viene preseleccionado). **Estado** y **Municipio** dejan de ser obligatorios: se pueden dejar en blanco y el paciente se guarda igual. Más adelante, el médico, la asistente o el administrador pueden editar al paciente y capturar esos datos sin problema.

## Cómo se verá

- En el formulario de paciente, País sigue mostrando "México" preseleccionado.
- Estado y Municipio se pueden dejar en "-- seleccione --" y el botón Guardar ya no los exige.
- En la tabla de pacientes, cuando no haya municipio, las columnas Municipio y Estado se muestran vacías (sin texto raro).
- Al editar el paciente, se pueden elegir Estado y Municipio con normalidad y se guardan.

## Cambio en la base de datos

Hoy la columna de municipio del paciente no acepta vacío y el listado de pacientes la usa para obtener el estado y el país (si estuviera vacía, el paciente desaparecería de la lista). Por eso el ajuste es:

1. Permitir que la columna `id_CATALOGO_MUNICIPIO` de `PACIENTE` acepte vacío (NULL).
2. Ajustar el procedimiento que lista pacientes (`spRegresaPacientes`) para que el paciente siga apareciendo aunque no tenga municipio: el país se tomará del catálogo "México" cuando no haya estado/municipio, y municipio/estado saldrán vacíos.

Los procedimientos de alta y cambio (`spAltaPaciente`, `spCambioPaciente`) ya reciben el municipio como dato; solo se les permite recibirlo vacío.

Se entrega como script para ejecutar en el servidor (un parche nuevo), y se actualiza `schema.sql` para instalaciones nuevas.

## Detalles técnicos

Archivos a modificar, por prioridad:

1. `php-app/sql/patches/2026-10-05_paciente_municipio_opcional.sql` (nuevo) — `ALTER TABLE citas.PACIENTE ALTER COLUMN id_CATALOGO_MUNICIPIO INT NULL`; recrear `spRegresaPacientes` con `LEFT JOIN` a `CATALOGO_MUNICIPIO`/`CATALOGO_ESTADOS` y país por `COALESCE` al catálogo "México"; ajustar `spAltaPaciente`/`spCambioPaciente` para aceptar `@id_CATALOGO_MUNICIPIO INT = NULL`.
2. `php-app/app/views/pacientes/index.php` — quitar `required` de los select de Estado y Municipio; la cascada País→Estado→Municipio sigue igual; en edición, si no hay municipio, los select quedan en blanco.
3. `php-app/app/controllers/PacientesController.php` — en `guardar()`, quitar "municipio" de la lista de obligatorios y permitir `idMun = 0` (se envía como NULL).
4. `php-app/app/models/PacienteModel.php` — en `alta()` y `cambio()`, enviar `NULL` cuando el municipio venga en 0 (hoy el modelo fuerza cadenas/enteros no nulos).
5. `php-app/app/views/pacientes/_tabla.php` — mostrar celda vacía cuando municipio/estado vengan NULL (verificar que ya lo haga con `?? ''`).
6. `php-app/sql/schema.sql` — reflejar la columna nullable y los procedimientos actualizados.

Sin cambios en la cita pública: ahí el paciente nuevo se crea con el consultorio/especialidad GENERICO y no captura municipio, por lo que no se ve afectada (se verificará que el alta pública siga funcionando con municipio NULL o con el valor que ya usa hoy).
