/* =====================================================================
   PARCHE: la cita se agenda contra un USUARIO con perfil "Medico"
           (dado de alta en Administracion de clinica y asignado a la
           clinica), en lugar del catalogo citas.MEDICO.

   Efecto: citas.CITA.id_MEDICO pasa a referenciar citas.USUARIOS.
   Ejecutar UNA sola vez sobre la BD CitasMedicas.
   ===================================================================== */
USE CitasMedicas;
GO
SET XACT_ABORT ON;
GO

/* ---------------------------------------------------------------------
   1) Migracion de datos: mapear el medico del catalogo al usuario con
      perfil medico que tenga el MISMO nombre_completo y este asignado
      a la misma clinica. Las citas sin correspondencia se reportan.
   --------------------------------------------------------------------- */
IF OBJECT_ID('tempdb..#map') IS NOT NULL DROP TABLE #map;
SELECT m.id_MEDICO, MIN(u.id_USUARIOS) AS id_USUARIOS
  INTO #map
  FROM citas.MEDICO m
  JOIN citas.USUARIOS_CLINICA uc ON uc.id_CLINICA = m.id_CLINICA
  JOIN citas.USUARIOS u          ON u.id_USUARIOS = uc.id_USUARIOS
  JOIN citas.ROLES    r          ON r.id_ROLES    = u.id_ROLES
 WHERE LOWER(r.nombre) LIKE '%medico%'
   AND LTRIM(RTRIM(u.nombre_completo)) = LTRIM(RTRIM(m.nombre_completo))
 GROUP BY m.id_MEDICO;
GO

SELECT ci.id_CITA, ci.id_MEDICO AS id_MEDICO_sin_usuario
  FROM citas.CITA ci
 WHERE NOT EXISTS (SELECT 1 FROM #map mp WHERE mp.id_MEDICO = ci.id_MEDICO);
GO
/* Si la consulta anterior devuelve filas, resuelvelas (crea el usuario
   medico o corrige el nombre) ANTES de continuar: el paso 3 fallara. */

/* ---------------------------------------------------------------------
   2) Quitar la FK actual hacia citas.MEDICO
   --------------------------------------------------------------------- */
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_id_MEDICO_MEDICO_id_MEDICO_CITA')
    ALTER TABLE citas.CITA DROP CONSTRAINT FK_id_MEDICO_MEDICO_id_MEDICO_CITA;
GO

/* ---------------------------------------------------------------------
   3) Reasignar los ids y crear la nueva FK hacia citas.USUARIOS
   --------------------------------------------------------------------- */
BEGIN TRAN;
    UPDATE ci
       SET ci.id_MEDICO = mp.id_USUARIOS
      FROM citas.CITA ci
      JOIN #map mp ON mp.id_MEDICO = ci.id_MEDICO;

    ALTER TABLE citas.CITA WITH CHECK
        ADD CONSTRAINT FK_id_MEDICO_USUARIOS_id_USUARIOS_CITA
        FOREIGN KEY (id_MEDICO) REFERENCES citas.USUARIOS(id_USUARIOS);

    INSERT INTO citas.LOG
    VALUES('CITA','patch_cita_medico_usuario','CITA',
           'CITA.id_MEDICO ahora referencia USUARIOS.id_USUARIOS',GETDATE(),0);
COMMIT;
GO

/* ---------------------------------------------------------------------
   4) spRegresaCitas: el nombre del medico viene de USUARIOS
   --------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE citas.spRegresaCitas
    @id_MEDICO INT = NULL, @id_CLINICA INT = NULL,
    @fecha_desde DATE = NULL, @fecha_hasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  ci.id_CITA, ci.fecha_cita, ci.hora_inicio, ci.hora_fin,
            ci.observaciones, ci.notifica_email, ci.notifica_wa,
            ci.email_notif, ci.celular_notif, ci.horas_anticipacion_notif, ci.precio,
            ci.id_PACIENTE,
            (p.ap_paterno + ' ' + p.ap_materno + ' ' + p.nombre) AS paciente,
            p.id_CLINICA, cl.nombre AS clinica,
            ci.id_MEDICO, u.nombre_completo AS medico,
            ci.id_CATALOGO_ESPECIALIDAD, es.nombre AS especialidad,
            ci.id_CONSULTORIO, co.nombre AS consultorio,
            ci.id_CATALOGO_ESTADO_CITAS, ec.nombre AS estado
      FROM citas.CITA ci
      JOIN citas.PACIENTE              p  ON p.id_PACIENTE              = ci.id_PACIENTE
      JOIN citas.CLINICA               cl ON cl.id_CLINICA              = p.id_CLINICA
      JOIN citas.USUARIOS              u  ON u.id_USUARIOS              = ci.id_MEDICO
      JOIN citas.CATALOGO_ESPECIALIDAD es ON es.id_CATALOGO_ESPECIALIDAD= ci.id_CATALOGO_ESPECIALIDAD
      JOIN citas.CONSULTORIO           co ON co.id_CONSULTORIO          = ci.id_CONSULTORIO
      JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_CATALOGO_ESTADO_CITAS= ci.id_CATALOGO_ESTADO_CITAS
     WHERE (@id_MEDICO    IS NULL OR ci.id_MEDICO  = @id_MEDICO)
       AND (@id_CLINICA   IS NULL OR p.id_CLINICA  = @id_CLINICA)
       AND (@fecha_desde  IS NULL OR ci.fecha_cita >= @fecha_desde)
       AND (@fecha_hasta  IS NULL OR ci.fecha_cita <= @fecha_hasta)
     ORDER BY ci.fecha_cita, ci.hora_inicio;
END
GO

/* ---------------------------------------------------------------------
   5) Usuarios con perfil medico por clinica (para el combo de la cita)
   --------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE citas.spRegresaMedicosUsuarios
    @id_CLINICA INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT u.id_USUARIOS, u.usuario, u.nombre_completo, u.email,
                    uc.id_CLINICA, c.nombre AS clinica
      FROM citas.USUARIOS u
      JOIN citas.ROLES r            ON r.id_ROLES    = u.id_ROLES
      JOIN citas.USUARIOS_CLINICA uc ON uc.id_USUARIOS = u.id_USUARIOS
      JOIN citas.CLINICA c          ON c.id_CLINICA  = uc.id_CLINICA
     WHERE u.activo = 1
       AND LOWER(r.nombre) LIKE '%medico%'
       AND (@id_CLINICA IS NULL OR uc.id_CLINICA = @id_CLINICA)
     ORDER BY u.nombre_completo;
END
GO

GRANT EXECUTE ON citas.spRegresaMedicosUsuarios TO citasadmin;
GO
