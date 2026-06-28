## Objetivo

Generar el script completo de base de datos para **SQL Server 2022 Express** del sistema POLICLÍNICA, siguiendo las convenciones de DBA senior solicitadas, y actualizar `config.properties` con los nuevos datos de conexión.

## Entregables

1. **`php-app/sql/schema.sql`** — script idempotente (DROP IF EXISTS + CREATE) que contiene:
   - Creación de la BD `CitasMedicas`
   - Login y usuario `citasadmin` con password `admin01$`
   - Esquema `citas` enlazado como default a `citasadmin`
   - Tablas, PKs, FKs, índices únicos, CHECKs
   - Tabla `citas.LOG`
   - Procedimientos almacenados parametrizados (sp...)
   - Vista(s) base (vw...)
   - Datos semilla de catálogos y roles/usuarios de prueba

2. **`php-app/config/config.properties`** — actualizado con la instancia, puerto 1435 y nombre de BD pedidos.

## Estructura de tablas (esquema `citas`)

Todas con `id_<tabla> INT IDENTITY(1,1) PK` al inicio y los 4 campos de auditoría al final (`id_usuario_creacion TINYINT NOT NULL`, `fecha_creacion SMALLDATETIME NOT NULL`, `id_usuario_modificacion TINYINT NULL`, `fecha_modificacion SMALLDATETIME NULL`), excepto `citas.LOG`.

**Seguridad / usuarios**
- `ROLES` (nombre, descripcion, activo)
- `USUARIOS` (id_rol FK, id_clinica FK NULL, usuario UNIQUE, password VARBINARY cifrada con `HASHBYTES('SHA2_512', password+salt)`, salt, nombre_completo, email, activo)

**Catálogos**
- `CATALOGO_PAIS` (nombre)
- `CATALOGO_ESTADOS` (nombre, id_pais FK)
- `CATALOGO_ESTADO_CITAS` (nombre)
- `CATALOGO_GENERO` (nombre)
- `CATALOGO_ESPECIALIDAD` (nombre)

**Operativas**
- `CLINICA` (nombre, direccion, email, telefono, municipio, id_estado FK, activo)
- `CONSULTORIO` (id_clinica FK, nombre, activo)
- `MEDICO` (nombre_completo, activo)
- `MEDICO_ESPECIALIDAD` (id_medico FK, id_especialidad FK) — relación N:M
- `MEDICO_CONSULTORIO` (id_medico FK, id_consultorio FK) — un médico puede atender en varios consultorios
- `PACIENTE` (id_clinica FK, ap_paterno, ap_materno, nombre, direccion, telefono, email, fecha_nacimiento, id_genero FK, municipio, id_estado FK) — UNIQUE por clínica
- `CITA` (id_paciente FK, id_medico FK, id_consultorio FK, id_especialidad FK, fecha_cita, hora_inicio, hora_fin, id_estado_cita FK, observaciones, notifica_email BIT, notifica_wa BIT, horas_anticipacion_notif TINYINT, email_notif, celular_notif, precio DECIMAL(10,2))

**Auditoría**
- `LOG` (id_log, modulo, procedimiento, tabla, evento, fecha, id_usuario)

## Convenciones aplicadas

- PK: `PK_id_<tabla>`
- FK: `FK_<col_pk>_<TABLA_PK>_<col_fk>_<TABLA_FK>`
- CHK: `CHK_<campo>_<TABLA>` (ej. hora_fin > hora_inicio, precio >= 0, email regex básica, activo 0/1)
- IX único: `IX_<campo(s)>_<TABLA>` (usuario, nombre de catálogos, paciente+clinica, etc.)
- SP: `spAlta…`, `spBaja…` (baja lógica vía `activo=0` donde aplica), `spCambio…`, `spRegresa…`, `spActiva…`, `spDesactiva…`
- Vistas: `vwCitasDelDia`, `vwMedicosPorClinica`, `vwIngresosPorMedico`

## Procedimientos almacenados (parametrizados)

Para cada entidad principal: Alta, Cambio, Baja (lógica), Activa, Desactiva, Regresa (lista) y RegresaPorId. Más:
- `spLoginUsuario` (valida usuario/password contra HASHBYTES)
- `spAltaCita`, `spCambioCita`, `spCancelaCita`, `spRegresaCitasPorMedicoFecha`, `spRegresaCitasPorClinicaFecha`
- `spRegresaIngresosPorMedico`, `spRegresaIngresosPorClinica`

Cada SP escribe en `citas.LOG` el módulo, nombre del SP, tabla afectada, evento (JSON corto con los parámetros), fecha y usuario. Todos usan `BEGIN TRY/CATCH` + `TRANSACTION` y devuelven `id` generado o código de error.

## Seguridad de acceso

- `GRANT EXECUTE ON SCHEMA::citas TO citasadmin`
- `DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::citas TO citasadmin` (acceso solo vía SP)
- Default schema del usuario = `citas`

## Datos semilla

- 4 roles: `admin_sistema`, `administrador`, `medico`, `asistente`
- 4 usuarios de prueba (los mismos del mock actual) con password cifrada
- Catálogos base: países (México), estados de Puebla, géneros, estados de cita (Agendada, Confirmada, Cancelada, Atendida, No asistió)

## Cambios en `config.properties`

```
db.driver=sqlsrv
db.instance=DESKTOP-2QTU4NO\SQLEXPRESS2019
db.name=CitasMedicas
db.user=citasadmin
db.password=admin01$
db.port=1435
```

## Fuera de alcance

- No se modifica todavía el `Database.php` ni los controladores PHP para consumir los SPs; eso queda para una siguiente iteración una vez validado el script.
