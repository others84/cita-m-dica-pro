/* ============================================================================
   2026-10-28 — RFC y cedula profesional del medico (variables de contrato)
   ----------------------------------------------------------------------------
   Agrega las columnas rfc y cedula a citas.USUARIOS y los procedimientos para
   guardarlas y consultarlas. Se usan en las variables @@RFC_MEDICO y @@CEDULA
   de las plantillas de contrato. Ejecutar en CitasMedicas y citasMedicasDEMO.
   Idempotente: se puede ejecutar mas de una vez.
   ============================================================================ */

IF COL_LENGTH('citas.USUARIOS', 'rfc') IS NULL
    ALTER TABLE citas.USUARIOS ADD rfc NVARCHAR(13) NULL;
GO
IF COL_LENGTH('citas.USUARIOS', 'cedula') IS NULL
    ALTER TABLE citas.USUARIOS ADD cedula NVARCHAR(20) NULL;
GO

/* ---------------- spGuardaRfcCedulaMedico ---------------------------
   Actualiza RFC y cedula de un usuario con perfil medico. */
CREATE OR ALTER PROCEDURE citas.spGuardaRfcCedulaMedico
    @id_USUARIOS INT,
    @rfc         NVARCHAR(13) = NULL,
    @cedula      NVARCHAR(20) = NULL,
    @id_usuario  INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (
        SELECT 1
          FROM citas.USUARIOS u
          JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
         WHERE u.id_USUARIOS = @id_USUARIOS
           AND (LOWER(r.nombre) LIKE '%medico%' OR LOWER(r.nombre) LIKE '%médico%')
    )
    BEGIN
        RAISERROR('El usuario no tiene perfil de medico.', 16, 1);
        RETURN;
    END
    UPDATE citas.USUARIOS
       SET rfc = NULLIF(LTRIM(RTRIM(@rfc)), ''),
           cedula = NULLIF(LTRIM(RTRIM(@cedula)), '')
     WHERE id_USUARIOS = @id_USUARIOS;
END
GO
GRANT EXECUTE ON OBJECT::citas.spGuardaRfcCedulaMedico TO citasadmin;
GO

/* ---------------- spRegresaRfcCedulaMedico --------------------------
   Devuelve RFC y cedula de un usuario (vacio si no es medico). */
CREATE OR ALTER PROCEDURE citas.spRegresaRfcCedulaMedico
    @id_USUARIOS INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.id_USUARIOS,
           ISNULL(u.rfc, '')    AS rfc,
           ISNULL(u.cedula, '') AS cedula
      FROM citas.USUARIOS u
     WHERE u.id_USUARIOS = @id_USUARIOS;
END
GO
GRANT EXECUTE ON OBJECT::citas.spRegresaRfcCedulaMedico TO citasadmin;
GO
