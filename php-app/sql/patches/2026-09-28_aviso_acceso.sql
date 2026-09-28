/* ============================================================
   Parche: aviso por correo de accesos de administradores
   - citas.CONFIG_AVISO_ACCESO (fila unica)
   - citas.spRegresaConfigAvisoAcceso
   - citas.spGuardaConfigAvisoAcceso
   Variables del texto: @@USUARIO, @@NOMBRE, @@ROL, @@FECHA,
   @@HORA, @@IP, @@CLINICA
   ============================================================ */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.CONFIG_AVISO_ACCESO', 'U') IS NULL
BEGIN
    CREATE TABLE citas.CONFIG_AVISO_ACCESO (
        id_CONFIG_AVISO_ACCESO   INT IDENTITY(1,1) NOT NULL,
        destinos                 VARCHAR(500)      NOT NULL,
        asunto                   VARCHAR(200)      NOT NULL,
        plantilla                VARCHAR(2000)     NOT NULL,
        activo                   BIT               NOT NULL CONSTRAINT DF_activo_CONFIG_AVISO_ACCESO DEFAULT (1),
        id_usuario_creacion      TINYINT           NOT NULL,
        fecha_creacion           SMALLDATETIME     NOT NULL,
        id_usuario_modificacion  TINYINT           NULL,
        fecha_modificacion       SMALLDATETIME     NULL,
        CONSTRAINT PK_id_CONFIG_AVISO_ACCESO PRIMARY KEY (id_CONFIG_AVISO_ACCESO),
        CONSTRAINT CHK_activo_CONFIG_AVISO_ACCESO CHECK (activo IN (0,1))
    );
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaConfigAvisoAcceso
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 id_CONFIG_AVISO_ACCESO, destinos, asunto, plantilla, activo,
           CONVERT(varchar(19), GETDATE(), 120) AS ahora
      FROM citas.CONFIG_AVISO_ACCESO
     ORDER BY id_CONFIG_AVISO_ACCESO;
END
GO

CREATE OR ALTER PROCEDURE citas.spGuardaConfigAvisoAcceso
    @destinos   VARCHAR(500),
    @asunto     VARCHAR(200),
    @plantilla  VARCHAR(2000),
    @activo     BIT,
    @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    IF LEN(LTRIM(RTRIM(ISNULL(@destinos,'')))) = 0 OR LEN(LTRIM(RTRIM(ISNULL(@plantilla,'')))) = 0
    BEGIN
        RAISERROR('Los correos destino y el texto son obligatorios.', 16, 1);
        RETURN;
    END

    DECLARE @id INT = (SELECT TOP 1 id_CONFIG_AVISO_ACCESO FROM citas.CONFIG_AVISO_ACCESO ORDER BY id_CONFIG_AVISO_ACCESO);
    IF @id IS NULL
    BEGIN
        INSERT INTO citas.CONFIG_AVISO_ACCESO(destinos, asunto, plantilla, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@destinos, @asunto, @plantilla, @activo, @id_usuario, GETDATE());
        SET @id = SCOPE_IDENTITY();
    END
    ELSE
        UPDATE citas.CONFIG_AVISO_ACCESO
           SET destinos = @destinos, asunto = @asunto, plantilla = @plantilla, activo = @activo,
               id_usuario_modificacion = @id_usuario, fecha_modificacion = GETDATE()
         WHERE id_CONFIG_AVISO_ACCESO = @id;

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('SISTEMA', 'spGuardaConfigAvisoAcceso', 'CONFIG_AVISO_ACCESO',
           'CONFIGURACION AVISO ACCESO: destinos=' + @destinos + ', activo=' + CAST(@activo AS VARCHAR(1))
           + ', asunto=' + @asunto, GETDATE(), @id_usuario);

    SELECT @id AS id_CONFIG_AVISO_ACCESO;
END
GO

GRANT EXECUTE ON OBJECT::citas.spRegresaConfigAvisoAcceso TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spGuardaConfigAvisoAcceso  TO citasadmin;
GO
