## Objetivo

Conectar la aplicación PHP MVC a SQL Server 2022 (BD `CitasMedicas`, esquema `citas`, usuario `citasadmin`) ejecutando los Stored Procedures del `schema.sql` final, generar todos los CRUDs y mejorar el preview de cada cita en el calendario para mostrar **paciente, médico y especialidad**.

## Capa de acceso a datos

Crear `php-app/app/core/Database.php` (singleton PDO `sqlsrv`):
- Lee `config/config.properties` (instancia, puerto 1435, BD, usuario, password).
- DSN: `sqlsrv:Server=DESKTOP-2QTU4NO\SQLEXPRESS2019,1435;Database=CitasMedicas;Encrypt=yes;TrustServerCertificate=yes`.
- Modo error excepción, manejo de mensajes informativos para capturar `RAISERROR`/`THROW` del catch de cada SP.

Crear `php-app/app/core/Model.php` con helpers:
- `call(string $sp, array $params)` → ejecuta SP y devuelve filas.
- `exec(string $sp, array $params, array $outParams = [])` → ejecuta SP sin resultset, devolviendo parámetros OUTPUT (vía `bindParam` + `PDO::PARAM_INPUT_OUTPUT`).
- Manejo central de excepciones con log a `php-app/storage/logs/app.log`.

## Modelos (uno por entidad, todos en `php-app/app/models/`)

Cada modelo invoca exclusivamente los SPs del schema, sin SQL embebido:

| Modelo | SPs |
|---|---|
| `UsuarioModel` | `spLoginUsuario`, `spAltaUsuario`, `spCambioUsuario`, `spCambioPassword`, `spBajaUsuario`, `spActivaUsuario`, `spDesactivaUsuario`, `spRegresaUsuarios` |
| `RolModel` | `spAltaRol`, `spCambioRol`, `spBajaRol`, `spActivaRol`, `spDesactivaRol`, `spRegresaRoles` |
| `PaisModel` | `spAltaPais`, `spCambioPais`, `spRegresaPaises` |
| `EstadoModel` | `spAltaEstado`, `spCambioEstado`, `spRegresaEstados` |
| `EstadoCitaModel` | `spAltaEstadoCita`, `spCambioEstadoCita`, `spRegresaEstadosCita` |
| `GeneroModel` | `spAltaGenero`, `spCambioGenero`, `spRegresaGeneros` |
| `EspecialidadModel` | `spAltaEspecialidad`, `spCambioEspecialidad`, `spRegresaEspecialidades` |
| `ClinicaModel` | `spAltaClinica`, `spCambioClinica`, `spBajaClinica`, `spActivaClinica`, `spDesactivaClinica`, `spRegresaClinicas` |
| `ConsultorioModel` | `spAltaConsultorio`, `spCambioConsultorio`, `spBajaConsultorio`, `spRegresaConsultorios` |
| `MedicoModel` | `spAltaMedico`, `spCambioMedico`, `spBajaMedico`, `spRegresaMedicos` |
| `PacienteModel` | `spAltaPaciente`, `spCambioPaciente`, `spBajaPaciente`, `spRegresaPacientes` |
| `CitaModel` | `spAltaCita`, `spCambioCita`, `spCancelaCita`, `spRegresaCitas` |

## Autenticación real

Reemplazar `Auth::attempt` mock por `UsuarioModel::login($usuario, $password)` que llame a `citas.spLoginUsuario`. La sesión guardará: `id_USUARIOS`, `usuario`, `nombre_completo`, `id_ROLES`, `rol`, `id_CLINICA`. El mapeo de rol → menú usará el nombre devuelto por la tabla `ROLES` (`asistente`, `medico`, `administrador`, `admin_sistema`).

## CRUDs (controladores + vistas)

Patrón uniforme para cada entidad (`index`, `crear`, `guardar`, `editar`, `actualizar`, `eliminar` cuando aplique):

- **Citas** (`CitasController`): listado filtrable por médico y rango de fechas; alta/modificación con selects dependientes (clínica→pacientes/consultorios, médico→especialidades); cancelar usa `spCancelaCita`.
- **Pacientes** (`PacientesController`): ámbito por `id_CLINICA` de la sesión.
- **Médicos** (`MedicosController`): CRUD + asignación de especialidades y consultorios (insertando vía SPs auxiliares; si faltan, se documentan como pendientes y se gestionan desde la BD).
- **Especialidades, Consultorios, Clínicas, Países, Estados, Géneros, Estado de citas, Roles, Usuarios**: CRUDs estándar.
- **Reportes / Ingresos**: leer vista `vwIngresosPorMedico` mediante SP wrapper o `SELECT` directo (se añadirá `spRegresaIngresos` si el usuario lo aprueba; mientras tanto se consume la vista desde el modelo).
- **Respaldo de BD**: ejecuta `BACKUP DATABASE` (sólo `admin_sistema`).

Vistas: tablas con acciones (Editar, Activar/Desactivar, Eliminar) y formularios usando la paleta existente (`#EAF6FF` → `#1E3A5F`). Mensajes flash en sesión.

Restricciones de rol existentes en `Controller::requireLogin([...])` se conservan.

## Calendario con preview enriquecido

`CalendarioController::index` cargará las citas reales:
- Llama a `CitaModel::listar(null, hoy-30, hoy+90)` (rango configurable).
- Mapea cada fila a un evento con:
  - `start`: `fecha_cita + 'T' + hora_inicio`
  - `end`: `fecha_cita + 'T' + hora_fin`
  - `title`: `paciente` (corto)
  - `extendedProps`: `{ paciente, medico, especialidad, consultorio, estado, precio }`
- Envía los eventos al view como JSON.

`app/views/calendario/index.php`:
- Eliminar los eventos hardcodeados; usar el JSON inyectado.
- Configurar `eventContent` (callback de Event Calendar v5) para renderizar dentro del evento:
  ```
  <strong>{paciente}</strong>
  Dr. {medico}
  {especialidad}
  ```
- Agregar `eventClick` que abre un modal/tooltip con los mismos 3 datos + consultorio, estado y precio.
- Estilos para que el bloque sea legible en `timeGridWeek` y `dayGridMonth` (truncado con CSS).

## Configuración

- `config/config.properties` ya tiene los datos; verificar y documentar en `php-app/README.md` cómo habilitar `php_sqlsrv` y `php_pdo_sqlsrv` en XAMPP.
- `schema.sql` actual del proyecto se reemplaza con el aprobado por el usuario (`/mnt/user-uploads/schema.sql`).
- No se tocará el ZIP `con_calendario_funcionando_25062026.zip`; sólo se usa como referencia de que el calendario ya funcionaba.

## Detalles técnicos

- Parámetros OUTPUT con `sqlsrv` requieren `PDO::PARAM_INPUT_OUTPUT` + longitud explícita.
- Para `id_usuario` (TINYINT) usar el `id_USUARIOS` de sesión, truncado al rango 0–255 (los SPs reciben TINYINT; se valida en modelo).
- Errores de SPs (`;THROW`) se capturan en `try/catch`, se loguean y se muestran como `flash error` en la UI.
- Sin cambios en `src/` (proyecto React/TanStack del workspace).

## Entregables

1. `Database.php`, `Model.php`, 12 modelos.
2. Controladores y vistas CRUD completos (formularios + listados).
3. `Auth.php` conectado a `spLoginUsuario`.
4. Calendario poblado con datos reales y preview enriquecido (paciente, médico, especialidad).
5. `schema.sql` del proyecto actualizado al adjunto del usuario.
6. README breve con pasos de habilitación de drivers en XAMPP.

## Confirmación pendiente

¿Quieres que el calendario muestre las citas de **todos los médicos de la clínica del usuario logueado**, o sólo las del médico cuando el rol sea `medico` (y todas para asistente / administrador)?
