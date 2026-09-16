/* ============================================================
   Parche: texto de notificacion de WhatsApp por medico
   El texto se guarda en la columna citas.USUARIOS.mensaje_whatsapp
   (ya no existe la tabla citas.MENSAJE_MEDICO).
   - citas.USUARIOS.mensaje_whatsapp
   - citas.spRegresaMensajeMedico
   - citas.spGuardaMensajeMedico
   Las variables del texto se escriben con el prefijo @@
   (@@CLINICA, @@MEDICO, @@PACIENTE, @@ESPECIALIDAD,
    @@CONSULTORIO, @@FECHA, @@HORA).
   Este parche puede ejecutarse aunque ya se haya aplicado la
   version anterior: migra los textos y elimina la tabla vieja.
   ============================================================ */
USE CitasMedicas;
GO

/* ---------- 1. Columna nueva en USUARIOS ---------- */
IF COL_LENGTH('citas.USUARIOS', 'mensaje_whatsapp') IS NULL
    ALTER TABLE citas.USUARIOS ADD mensaje_whatsapp VARCHAR(1000) NULL;
GO

/* ---------- 2. Migracion de los textos ya capturados ---------- */
IF OBJECT_ID('citas.MENSAJE_MEDICO', 'U') IS NOT NULL
BEGIN
    UPDATE u
       SET u.mensaje_whatsapp = m.plantilla
      FROM citas.USUARIOS u
     INNER JOIN citas.MENSAJE_MEDICO m ON m.id_USUARIOS = u.id_USUARIOS
     WHERE LEN(LTRIM(RTRIM(ISNULL(m.plantilla, '')))) > 0;
END
GO

/* ---------- 3. Procedimientos ---------- */
/* Regresa el texto de un medico o de todos (cuando @id_USUARIOS es NULL). */
CREATE OR ALTER PROCEDURE citas.spRegresaMensajeMedico
    @id_USUARIOS INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  u.id_USUARIOS,
            u.mensaje_whatsapp AS plantilla,
            u.nombre_completo
    FROM citas.USUARIOS u
    WHERE LEN(LTRIM(RTRIM(ISNULL(u.mensaje_whatsapp, '')))) > 0
      AND (@id_USUARIOS IS NULL OR u.id_USUARIOS = @id_USUARIOS);
END
GO

/* Guarda el texto del medico en su propio renglon de USUARIOS. */
CREATE OR ALTER PROCEDURE citas.spGuardaMensajeMedico
    @id_USUARIOS INT,
    @plantilla   VARCHAR(1000),
    @id_usuario  TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    SET @plantilla = LTRIM(RTRIM(ISNULL(@plantilla, '')));

    IF @plantilla = ''
    BEGIN
        RAISERROR('El texto de notificacion no puede quedar vacio.', 16, 1);
        RETURN;
    END

    /* El medico debe existir y estar asociado al menos a una clinica. */
    IF NOT EXISTS (
        SELECT 1
        FROM citas.USUARIOS u
        WHERE u.id_USUARIOS = @id_USUARIOS
          AND (u.id_CLINICA IS NOT NULL
               OR EXISTS (SELECT 1 FROM citas.USUARIOS_CLINICA uc WHERE uc.id_USUARIOS = u.id_USUARIOS))
    )
    BEGIN
        RAISERROR('El medico no existe o no pertenece a ninguna clinica.', 16, 1);
        RETURN;
    END

    UPDATE citas.USUARIOS
       SET mensaje_whatsapp = @plantilla
     WHERE id_USUARIOS = @id_USUARIOS;

    /* --------- Bitacora --------- */
    DECLARE @medico VARCHAR(150) = (SELECT nombre_completo FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS);
    DECLARE @ev VARCHAR(2000) = 'se definio el texto de notificacion del medico "' + ISNULL(@medico, '')
                              + '": ' + LEFT(@plantilla, 500);

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('MENSAJE', 'spGuardaMensajeMedico', 'USUARIOS', @ev, GETDATE(), @id_usuario);
END
GO

GRANT EXECUTE ON OBJECT::citas.spRegresaMensajeMedico TO citasadmin;
GO
GRANT EXECUTE ON OBJECT::citas.spGuardaMensajeMedico TO citasadmin;
GO

/* ---------- 4. Se retira la tabla anterior ---------- */
IF OBJECT_ID('citas.MENSAJE_MEDICO', 'U') IS NOT NULL
    DROP TABLE citas.MENSAJE_MEDICO;
GO
