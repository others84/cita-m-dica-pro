/* ============================================================
   Parche: texto de notificacion de WhatsApp por medico
   - citas.MENSAJE_MEDICO
   - citas.spRegresaMensajeMedico
   - citas.spGuardaMensajeMedico
   Las variables del texto se escriben con el prefijo @@
   (@@CLINICA, @@MEDICO, @@PACIENTE, @@ESPECIALIDAD,
    @@CONSULTORIO, @@FECHA, @@HORA).
   ============================================================ */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.MENSAJE_MEDICO', 'U') IS NULL
BEGIN
    CREATE TABLE citas.MENSAJE_MEDICO (
        id_MENSAJE_MEDICO        INT IDENTITY(1,1) NOT NULL,
        id_USUARIOS              INT               NOT NULL,
        plantilla                VARCHAR(1000)     NOT NULL,
        id_usuario_creacion      TINYINT           NOT NULL,
        fecha_creacion           SMALLDATETIME     NOT NULL,
        id_usuario_modificacion  TINYINT           NULL,
        fecha_modificacion       SMALLDATETIME     NULL,
        CONSTRAINT PK_id_MENSAJE_MEDICO PRIMARY KEY (id_MENSAJE_MEDICO),
        CONSTRAINT CHK_plantilla_MENSAJE_MEDICO CHECK (LEN(LTRIM(RTRIM(plantilla))) > 0),
        CONSTRAINT FK_id_USUARIOS_USUARIOS_id_USUARIOS_MENSAJE_MEDICO
            FOREIGN KEY (id_USUARIOS) REFERENCES citas.USUARIOS(id_USUARIOS)
    );

    CREATE UNIQUE INDEX IX_id_USUARIOS_MENSAJE_MEDICO
        ON citas.MENSAJE_MEDICO(id_USUARIOS);
END
GO

/* Regresa el texto de un medico o de todos (cuando @id_USUARIOS es NULL). */
CREATE OR ALTER PROCEDURE citas.spRegresaMensajeMedico
    @id_USUARIOS INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  m.id_MENSAJE_MEDICO,
            m.id_USUARIOS,
            m.plantilla,
            u.nombre_completo
    FROM citas.MENSAJE_MEDICO m
    INNER JOIN citas.USUARIOS u ON u.id_USUARIOS = m.id_USUARIOS
    WHERE (@id_USUARIOS IS NULL OR m.id_USUARIOS = @id_USUARIOS);
END
GO

/* Alta o cambio del texto del medico (un solo renglon por medico). */
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

    IF EXISTS (SELECT 1 FROM citas.MENSAJE_MEDICO WHERE id_USUARIOS = @id_USUARIOS)
        UPDATE citas.MENSAJE_MEDICO
           SET plantilla = @plantilla,
               id_usuario_modificacion = @id_usuario,
               fecha_modificacion = GETDATE()
         WHERE id_USUARIOS = @id_USUARIOS;
    ELSE
        INSERT INTO citas.MENSAJE_MEDICO(id_USUARIOS, plantilla, id_usuario_creacion, fecha_creacion)
        VALUES(@id_USUARIOS, @plantilla, @id_usuario, GETDATE());

    /* --------- Bitacora --------- */
    DECLARE @medico VARCHAR(150) = (SELECT nombre_completo FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS);
    DECLARE @ev VARCHAR(2000) = 'se definio el texto de notificacion del medico "' + ISNULL(@medico, '')
                              + '": ' + LEFT(@plantilla, 500);

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('MENSAJE', 'spGuardaMensajeMedico', 'MENSAJE_MEDICO', @ev, GETDATE(), @id_usuario);
END
GO

GRANT EXECUTE ON OBJECT::citas.spRegresaMensajeMedico TO citasadmin;
GO
GRANT EXECUTE ON OBJECT::citas.spGuardaMensajeMedico TO citasadmin;
GO
