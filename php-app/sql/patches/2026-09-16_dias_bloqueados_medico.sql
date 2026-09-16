/* ============================================================
   Parche: dias bloqueados en la agenda del medico
   - citas.DIA_BLOQUEADO_MEDICO
   - citas.spRegresaDiasBloqueadosMedico
   - citas.spGuardaDiaBloqueadoMedico
   - citas.spBajaDiaBloqueadoMedico
   Los dias bloqueados SOLO limitan el agendado desde la pagina publica.
   ============================================================ */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.DIA_BLOQUEADO_MEDICO', 'U') IS NULL
BEGIN
    CREATE TABLE citas.DIA_BLOQUEADO_MEDICO (
        id_DIA_BLOQUEADO_MEDICO INT IDENTITY(1,1) NOT NULL,
        id_USUARIOS             INT               NOT NULL,
        fecha                   DATE              NOT NULL,
        motivo                  VARCHAR(200)      NULL,
        id_usuario_creacion     TINYINT           NOT NULL,
        fecha_creacion          SMALLDATETIME     NOT NULL,
        CONSTRAINT PK_id_DIA_BLOQUEADO_MEDICO PRIMARY KEY (id_DIA_BLOQUEADO_MEDICO),
        CONSTRAINT FK_id_USUARIOS_USUARIOS_id_USUARIOS_DIA_BLOQUEADO_MEDICO
            FOREIGN KEY (id_USUARIOS) REFERENCES citas.USUARIOS(id_USUARIOS)
    );

    CREATE UNIQUE INDEX IX_id_USUARIOS_fecha_DIA_BLOQUEADO_MEDICO
        ON citas.DIA_BLOQUEADO_MEDICO(id_USUARIOS, fecha);
END
GO

/* Dias bloqueados de un medico (o de todos cuando @id_USUARIOS es NULL).
   @desde permite limitar la consulta a fechas de hoy en adelante. */
CREATE OR ALTER PROCEDURE citas.spRegresaDiasBloqueadosMedico
    @id_USUARIOS INT  = NULL,
    @desde       DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  d.id_DIA_BLOQUEADO_MEDICO,
            d.id_USUARIOS,
            CONVERT(VARCHAR(10), d.fecha, 23) AS fecha,
            ISNULL(d.motivo, '')              AS motivo,
            u.nombre_completo
    FROM citas.DIA_BLOQUEADO_MEDICO d
    INNER JOIN citas.USUARIOS u ON u.id_USUARIOS = d.id_USUARIOS
    WHERE (@id_USUARIOS IS NULL OR d.id_USUARIOS = @id_USUARIOS)
      AND (@desde IS NULL OR d.fecha >= @desde)
    ORDER BY d.fecha;
END
GO

/* Alta de un dia bloqueado (idempotente: si ya existe solo actualiza el motivo). */
CREATE OR ALTER PROCEDURE citas.spGuardaDiaBloqueadoMedico
    @id_USUARIOS INT,
    @fecha       VARCHAR(10),
    @motivo      VARCHAR(200) = NULL,
    @id_usuario  TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @f DATE = CONVERT(DATE, @fecha, 23);

    /* El medico siempre debe pertenecer al menos a una clinica. */
    IF NOT EXISTS (SELECT 1 FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS = @id_USUARIOS)
    BEGIN
        RAISERROR('El medico no esta asignado a ninguna clinica.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM citas.DIA_BLOQUEADO_MEDICO WHERE id_USUARIOS = @id_USUARIOS AND fecha = @f)
        UPDATE citas.DIA_BLOQUEADO_MEDICO
           SET motivo = NULLIF(LTRIM(RTRIM(ISNULL(@motivo, ''))), '')
         WHERE id_USUARIOS = @id_USUARIOS AND fecha = @f;
    ELSE
        INSERT INTO citas.DIA_BLOQUEADO_MEDICO(id_USUARIOS, fecha, motivo, id_usuario_creacion, fecha_creacion)
        VALUES(@id_USUARIOS, @f, NULLIF(LTRIM(RTRIM(ISNULL(@motivo, ''))), ''), @id_usuario, GETDATE());

    DECLARE @medico VARCHAR(150) = (SELECT nombre_completo FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS);
    DECLARE @ev VARCHAR(2000) = 'el medico "' + ISNULL(@medico, '') + '" bloqueo el dia: '
        + CONVERT(VARCHAR(10), @f, 23)
        + CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(@motivo, ''))), '') IS NULL THEN '' ELSE ' (' + @motivo + ')' END;

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('HORARIO', 'spGuardaDiaBloqueadoMedico', 'DIA_BLOQUEADO_MEDICO', @ev, GETDATE(), @id_usuario);
END
GO

/* Baja de un dia bloqueado. */
CREATE OR ALTER PROCEDURE citas.spBajaDiaBloqueadoMedico
    @id_DIA_BLOQUEADO_MEDICO INT,
    @id_usuario              TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @idm INT, @f DATE;
    SELECT @idm = id_USUARIOS, @f = fecha
      FROM citas.DIA_BLOQUEADO_MEDICO
     WHERE id_DIA_BLOQUEADO_MEDICO = @id_DIA_BLOQUEADO_MEDICO;

    IF @idm IS NULL
    BEGIN
        RAISERROR('El dia bloqueado no existe.', 16, 1);
        RETURN;
    END

    DELETE FROM citas.DIA_BLOQUEADO_MEDICO WHERE id_DIA_BLOQUEADO_MEDICO = @id_DIA_BLOQUEADO_MEDICO;

    DECLARE @medico VARCHAR(150) = (SELECT nombre_completo FROM citas.USUARIOS WHERE id_USUARIOS = @idm);
    DECLARE @ev VARCHAR(2000) = 'el medico "' + ISNULL(@medico, '') + '" libero el dia: ' + CONVERT(VARCHAR(10), @f, 23);

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('HORARIO', 'spBajaDiaBloqueadoMedico', 'DIA_BLOQUEADO_MEDICO', @ev, GETDATE(), @id_usuario);
END
GO

GRANT EXECUTE ON OBJECT::citas.spRegresaDiasBloqueadosMedico TO citasadmin;
GO
GRANT EXECUTE ON OBJECT::citas.spGuardaDiaBloqueadoMedico TO citasadmin;
GO
GRANT EXECUTE ON OBJECT::citas.spBajaDiaBloqueadoMedico TO citasadmin;
GO
