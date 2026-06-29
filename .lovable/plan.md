# Rediseño de la base de datos `CitasMedicas` (SQL Server 2022 Express)

Sobrescribo `php-app/sql/schema.sql` desde cero y actualizo `php-app/config/config.properties`. Solo se tocan esos 2 archivos en este paso — los modelos PHP se ajustarán en una segunda fase para reflejar el nuevo esquema.

## Decisiones confirmadas

- **MEDICO ↔ CONSULTORIO:** sin relación persistida. Se eligen al crear la CITA.
- **PACIENTE ↔ CLINICA:** `id_CLINICA NOT NULL` en PACIENTE + `UNIQUE (id_CLINICA, ap_paterno, ap_materno, nombre)`.
- **Direcciones:** FK a `CATALOGO_MUNICIPIO` (que apunta a `CATALOGO_ESTADOS` → `CATALOGO_PAIS`). 3FN estricta: la CLINICA y el PACIENTE solo guardan `id_CATALOGO_MUNICIPIO`; estado/país se obtienen por join.
- **USUARIOS:** `usuario`, `password_hash VARBINARY(64)`, `password_salt VARCHAR(36)`, `nombre_completo`, `email`, `activo BIT`. Cifrado `HASHBYTES('SHA2_512', password + salt)` con salt = `CONVERT(VARCHAR(36), NEWID())`.
- **ROLES** semilla fija: `Administrador de sistema`, `Administrador de clinica`, `Medico`, `Asistente`.
- **CITA:** `notifica_email BIT`, `notifica_wa BIT`, `horas_anticipacion_notif TINYINT NOT NULL DEFAULT 24`. `email_notif` y `celular_notif` se copian del PACIENTE al crear/modificar.

## Tablas (16 en esquema `citas`, todas con PK identity + 4 campos de auditoría)

```text
Catálogos:
  CATALOGO_PAIS         (nombre)
  CATALOGO_ESTADOS      (nombre, id_CATALOGO_PAIS FK)
  CATALOGO_MUNICIPIO    (nombre, id_CATALOGO_ESTADOS FK)
  CATALOGO_GENERO       (nombre)
  CATALOGO_ESPECIALIDAD (nombre)
  CATALOGO_ESTADO_CITAS (nombre)

Seguridad:
  ROLES                 (nombre, descripcion)
  USUARIOS              (id_ROLES FK, usuario UQ, password_hash, password_salt,
                         nombre_completo, email, activo)
  USUARIOS_CLINICA      (id_USUARIOS FK, id_CLINICA FK) UQ(par)

Negocio:
  CLINICA               (nombre, direccion, email, telefono,
                         id_CATALOGO_MUNICIPIO FK)
  CONSULTORIO           (nombre, activo)
  CLINICA_CONSULTORIO   (id_CLINICA FK, id_CONSULTORIO FK) UQ(par)
  MEDICO                (nombre_completo, activo)
  MEDICO_ESPECIALIDAD   (id_MEDICO FK, id_CATALOGO_ESPECIALIDAD FK) UQ(par)
  PACIENTE              (id_CLINICA FK, ap_paterno, ap_materno, nombre,
                         direccion, telefono, email, fecha_nacimiento,
                         id_CATALOGO_GENERO FK, id_CATALOGO_MUNICIPIO FK)
                         UQ(id_CLINICA, ap_paterno, ap_materno, nombre)
  CITA                  (id_PACIENTE FK, fecha_cita DATE, hora_inicio TIME,
                         hora_fin TIME, id_CATALOGO_ESTADO_CITAS FK,
                         observaciones, notifica_email BIT, notifica_wa BIT,
                         email_notif, celular_notif, horas_anticipacion_notif,
                         precio DECIMAL(10,2), id_MEDICO FK,
                         id_CATALOGO_ESPECIALIDAD FK, id_CONSULTORIO FK)

Auditoría: LOG (sin los 4 campos de auditoría, según spec)
```

## Restricciones (CHK_*)

- `CHK_hora_CITA`: `hora_fin > hora_inicio`
- `CHK_precio_CITA`: `precio >= 0`
- `CHK_horas_anticipacion_CITA`: `horas_anticipacion_notif BETWEEN 1 AND 168`
- `CHK_email_PACIENTE` / `CHK_email_CLINICA` / `CHK_email_USUARIOS`: patrón básico con `LIKE '%_@_%._%'`
- `CHK_activo_*`: `activo IN (0,1)` (redundante con BIT, pero explícito por convención).

## Índices únicos (IX_*)

- `IX_usuario_USUARIOS`
- `IX_nombre_CATALOGO_PAIS`, `IX_nombre_id_CATALOGO_PAIS_CATALOGO_ESTADOS`, `IX_nombre_id_CATALOGO_ESTADOS_CATALOGO_MUNICIPIO`
- `IX_nombre_CATALOGO_ESPECIALIDAD`, `IX_nombre_CATALOGO_GENERO`, `IX_nombre_CATALOGO_ESTADO_CITAS`, `IX_nombre_ROLES`
- `IX_id_CLINICA_ap_paterno_ap_materno_nombre_PACIENTE`
- `IX_id_CLINICA_id_CONSULTORIO_CLINICA_CONSULTORIO`
- `IX_id_MEDICO_id_CATALOGO_ESPECIALIDAD_MEDICO_ESPECIALIDAD`
- `IX_id_USUARIOS_id_CLINICA_USUARIOS_CLINICA`
- Índices no únicos de apoyo en CITA: `(fecha_cita, id_MEDICO)`, `(id_PACIENTE)`.

## Procedimientos almacenados

Por cada tabla de catálogo y entidad: `spAlta...`, `spCambio...`, `spBaja...` (lógica donde aplique), `spActiva...` / `spDesactiva...` (solo donde existe `activo`), `spRegresa...`.

Además:
- `spLoginUsuario(@usuario, @password)` → devuelve datos del usuario + rol + (cuando aplique) `id_CLINICA` desde `USUARIOS_CLINICA`.
- `spCambioPassword(@id_USUARIOS, @password, @id_usuario)` — regenera salt y hash.
- `spRegresaCitas(@id_MEDICO, @id_CLINICA, @fecha_desde, @fecha_hasta)` — join con PACIENTE, MEDICO, CATALOGO_ESPECIALIDAD, CONSULTORIO, CATALOGO_ESTADO_CITAS para el calendario.
- `spRegresaEspecialidadesPorMedico(@id_MEDICO)` — para el combo dependiente de la pantalla CITA.
- `spRegresaConsultoriosPorClinica(@id_CLINICA)`.

### Estructura estándar de cada SP

```sql
CREATE OR ALTER PROCEDURE citas.spAltaXxx (...params..., @id_usuario TINYINT, @id_nuevo INT OUTPUT)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    BEGIN TRAN;
      -- validaciones de negocio (existencia FK, duplicados, etc.)
      INSERT INTO citas.XXX (...) VALUES (...);
      SET @id_nuevo = SCOPE_IDENTITY();

      DECLARE @msg VARCHAR(2000);
      SET @msg = 'Alta XXX id=' + CONVERT(VARCHAR(20), @id_nuevo);
      INSERT INTO citas.LOG (modulo, procedimiento, tabla, evento, fecha, id_usuario)
      VALUES ('XXX', 'spAltaXxx', 'XXX', @msg, GETDATE(), @id_usuario);
    COMMIT;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    DECLARE @err VARCHAR(2000);
    SET @err = 'ERROR spAltaXxx: ' + ERROR_MESSAGE();
    INSERT INTO citas.LOG (modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES ('XXX', 'spAltaXxx', 'XXX', @err, GETDATE(), ISNULL(@id_usuario,0));
    ;THROW;
  END CATCH
END
GO
```

Reglas aplicadas en todos los SPs:
- Concatenación con `+`, nunca `CONCAT`. Valores no `varchar` van envueltos en `CONVERT(VARCHAR(...), ...)`.
- Mensajes a `LOG` siempre via variable local `@msg VARCHAR(2000)` / `@err VARCHAR(2000)`.
- Errores se registran en `LOG` y se relanzan con `;THROW` para que PHP los reciba.

## Seguridad

```sql
CREATE LOGIN citasadmin WITH PASSWORD = 'admin01$', CHECK_POLICY = OFF;
CREATE USER  citasadmin FOR LOGIN citasadmin WITH DEFAULT_SCHEMA = citas;
ALTER AUTHORIZATION ON SCHEMA::citas TO citasadmin;

-- Solo ejecución de SPs, nada directo a tablas
GRANT EXECUTE ON SCHEMA::citas TO citasadmin;
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::citas TO citasadmin;
```

## Datos semilla

- `CATALOGO_PAIS`: Mexico
- `CATALOGO_GENERO`: Masculino, Femenino, Otro
- `CATALOGO_ESTADO_CITAS`: Agendada, Confirmada, Cancelada, Atendida, NoAsistio
- `ROLES`: 4 fijos
- 1 usuario semilla `adminMaster1` con rol `Administrador de sistema` (sin `USUARIOS_CLINICA`).

## Orden del script

1. `DROP DATABASE IF EXISTS CitasMedicas;` + `CREATE DATABASE` + `USE`.
2. `CREATE SCHEMA citas` + login/usuario/grants.
3. Tablas en orden de dependencia (catálogos → ROLES/USUARIOS → CLINICA → puentes → MEDICO/PACIENTE → CITA → LOG).
4. Índices únicos y CHKs.
5. SPs (catálogos → seguridad → negocio → consultas para calendario).
6. INSERTs de semilla (incluido el usuario master con salt+hash generado in-line).

## Archivo `config.properties`

Se mantiene tal cual ya está (instancia, BD, usuario, password, puerto 1435).

## Fuera de alcance de este plan

- No se tocan controladores ni modelos PHP. Una vez aprobado este schema, en un siguiente turno alineo `UsuarioModel`, `PacienteModel`, `CitaModel`, etc., a los nuevos parámetros (por ejemplo `id_CATALOGO_MUNICIPIO` en lugar de `municipio` + `id_CATALOGO_ESTADOS`, y los nuevos SPs `spRegresaEspecialidadesPorMedico` / `spRegresaConsultoriosPorClinica`).
