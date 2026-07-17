
## 1. Médicos: botones Activar / Desactivar

- **SQL `spActivaMedico` / `spDesactivaMedico` (`php-app/sql/schema.sql`)**: enriquecer el mensaje de LOG para incluir el nombre del médico y el nombre de la clínica (JOIN a `MEDICO` + `CLINICA`), formato: `Activa/Desactiva Medico id=X nombre='...' clinica='...' por usuario id=U`.
- **`MedicoModel`**: agregar `activa(int $id)` y `desactiva(int $id)` invocando esos SPs.
- **`MedicosController`**: agregar acciones `activar()` y `desactivar()` (POST, roles `administrador`/`admin_sistema`) que llaman al modelo y a `Database::log()` con: acción, id_MEDICO, nombre del médico, clínica y usuario en sesión (`$_SESSION['user']['usuario']`). Redirigen a `medicos`.
- **`views/medicos/index.php`**: en la columna Acciones, sustituir/complementar el botón "Baja" con un botón que muestra "Desactivar" cuando `activo=1` y "Activar" cuando `activo=0`, apuntando a `medicos/desactivar` o `medicos/activar`.

## 2. Especialidades por clínica

- **Esquema `CATALOGO_ESPECIALIDAD` (`schema.sql`)**: añadir columna `id_CLINICA INT NOT NULL` con FK a `CLINICA`. Cambiar índice único a `(nombre, id_CLINICA)` para permitir el mismo nombre en clínicas distintas.
- **SPs**:
  - `spAltaEspecialidad`: agregar `@id_CLINICA INT`; INSERT incluye la columna; LOG con nombre + clínica + usuario.
  - `spCambioEspecialidad`: agregar `@id_CLINICA INT`; UPDATE respectivo.
  - `spRegresaEspecialidades`: filtrar directamente por `e.id_CLINICA = @id_CLINICA` cuando no es NULL; devolver también `id_CLINICA` y `clinica` (JOIN a `CLINICA`). Elimina el join actual vía `CITA/PACIENTE`.
- **`EspecialidadModel`**: firmas `alta(string $nombre, int $idClinica)` y `cambio(int $id, string $nombre, int $idClinica)`.
- **`EspecialidadesController`**:
  - En `index()`: cargar `ClinicaModel::listar()` y pasarlo a la vista.
  - En `guardar()`: leer `id_CLINICA` (para `admin_sistema` viene del `<select>`, para `administrador` usar `$_SESSION['user']['id_CLINICA']`). Después de guardar, `Database::log()` con nombre, clínica y usuario.
- **Vista**: dejar de usar el partial genérico `_partials/simple_catalog.php` y crear `views/especialidades/index.php` con:
  - filtro de clínica (solo `admin_sistema`) reutilizando `_partials/filtro_clinica.php`,
  - formulario con `<select name="id_CLINICA">` (solo `admin_sistema`; el resto lo envía como `hidden` con su clínica),
  - tabla con columnas: Nombre, Clínica, Acciones.

## 3. Clínicas: corregir botón "Activar" y "Desactivar"

Los formularios postean a `clinicas/activar` y `clinicas/desactivar` pero el controlador no tiene esas acciones (de ahí `Acción no encontrada: activar`). Además la tabla `CLINICA` no tiene columna `activo`.

- **Esquema**: agregar `activo BIT NOT NULL DEFAULT 1` a `CLINICA`.
- **SPs nuevos**: `spActivaClinica` y `spDesactivaClinica` (`@id_CLINICA`, `@id_usuario`) que hacen UPDATE y registran en `citas.LOG` incluyendo nombre de la clínica y usuario.
- **`spRegresaClinicas`**: incluir `c.activo` en el SELECT.
- **`ClinicaModel`**: agregar `activa(int $id)` y `desactiva(int $id)`.
- **`ClinicasController`**: agregar acciones `activar()` y `desactivar()`; escribir en `app.log` (nombre de clínica + usuario + acción).

## 4. Filtro "País" en Estados

- **`CatalogosController::estados()`**: leer `f_pais` de `$_GET`, pasarlo a `EstadoModel::listar($fPais)` y a la vista.
- **`views/catalogos/estados.php`**: agregar `<form GET>` con `<select name="f_pais">` (opciones desde `$paises`, opción "-- todos --") con `onchange="this.form.submit()"`, arriba de la tabla.

## 5. Filtros "País" y "Estado" en Municipios

- **`MunicipioModel::listar`**: aceptar también `?int $idPais = null`. Como `spRegresaMunicipios` ya recibe `@id_CATALOGO_ESTADOS`, el filtrado por país se hará en PHP con `array_filter` sobre `$row['id_CATALOGO_PAIS']` cuando venga en el resultset (verificar el SELECT del SP; si no lo devuelve, extenderlo para incluir `id_CATALOGO_PAIS`).
- **`CatalogosController::municipios()`**: leer `f_pais` y `f_estado`, cargar `PaisModel::listar()` y `EstadoModel::listar($fPais)` para poblar los selects encadenados; aplicar filtros al listado.
- **`views/catalogos/municipios.php`**: agregar bloque de filtros con dos `<select>` (País → Estado). Cuando cambia País, el submit recarga con los estados de ese país.

## 6. Pantalla "Bloquear acceso a clínicas"

- **SP nuevo `spRegresaClinicasResumen`**: por cada clínica devolver `id_CLINICA, nombre, activo, total_usuarios (COUNT DISTINCT USUARIOS_CLINICA), total_pacientes (COUNT PACIENTE), total_citas (COUNT CITA vía PACIENTE)`.
- **Modelo `ClinicaModel::resumen()`**: ejecuta ese SP.
- **`SistemaController::bloquearClinicas()`**: consumir el resumen y pasarlo a la vista. Agregar acciones `bloquear()` y `desbloquear()` (POST, `admin_sistema`) que llaman a `spDesactivaClinica` / `spActivaClinica` del punto 3 (misma bandera `activo`) y escriben en `app.log` (clínica, usuario, acción).
- **Vista `views/sistema/bloquear_clinicas.php`**: tabla con columnas Nombre, Usuarios, Pacientes, Citas, Estado, Acción (botón "Bloquear" cuando `activo=1`, "Desbloquear" cuando `activo=0`).
- **Efecto del bloqueo en el login (`Auth::attempt` / `spLoginUsuario`)**: si el usuario tiene `id_CLINICA` y esa clínica está `activo=0`, retornar `null` y registrar en `app.log`. Se implementa como verificación adicional en PHP tras leer `id_CLINICA` de la sesión (consulta rápida a `CLINICA.activo`) para no tocar el SP de login. Se aplica solo a roles distintos de `admin_sistema`.

## Detalles técnicos

Archivos a modificar:
- `php-app/sql/schema.sql` (tabla `CLINICA`, tabla `CATALOGO_ESPECIALIDAD`, SPs de médicos/especialidades/clínicas, nuevos SPs `spActivaClinica`, `spDesactivaClinica`, `spRegresaClinicasResumen`)
- `php-app/app/controllers/MedicosController.php`
- `php-app/app/controllers/EspecialidadesController.php`
- `php-app/app/controllers/ClinicasController.php`
- `php-app/app/controllers/CatalogosController.php`
- `php-app/app/controllers/SistemaController.php`
- `php-app/app/core/Auth.php`
- `php-app/app/models/MedicoModel.php`
- `php-app/app/models/EspecialidadModel.php`
- `php-app/app/models/ClinicaModel.php`
- `php-app/app/models/MunicipioModel.php`
- `php-app/app/views/medicos/index.php`
- `php-app/app/views/catalogos/estados.php`
- `php-app/app/views/catalogos/municipios.php`
- `php-app/app/views/sistema/bloquear_clinicas.php`

Archivos nuevos:
- `php-app/app/views/especialidades/index.php`

Todos los `Database::log()` incluirán: acción, entidad, id, nombre, clínica, y `usuario` de sesión (`$_SESSION['user']['usuario']`).
