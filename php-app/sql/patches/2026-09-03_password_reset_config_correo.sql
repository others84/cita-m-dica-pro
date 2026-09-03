/* ============================================================
   Parche: restablecer contrasena por correo + configuracion SMTP
   - citas.PASSWORD_RESET : tokens de restablecimiento (hash, 1 solo uso)
   - citas.CONFIG_CORREO  : cuenta de correo emisora del sistema (fila unica)
   ============================================================ */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.PASSWORD_RESET', 'U') IS NULL
BEGIN
    CREATE TABLE citas.PASSWORD_RESET (
        id_PASSWORD_RESET  INT IDENTITY(1,1) NOT NULL,
        id_USUARIOS        INT               NOT NULL,
        token_hash         VARCHAR(64)       NOT NULL,
        fecha_expira       DATETIME          NOT NULL,
        usado              BIT               NOT NULL CONSTRAINT DF_usado_PASSWORD_RESET DEFAULT (0),
        ip                 VARCHAR(45)       NULL,
        fecha_creacion     DATETIME          NOT NULL CONSTRAINT DF_fecha_creacion_PASSWORD_RESET DEFAULT (GETDATE()),
        fecha_uso          DATETIME          NULL,
        CONSTRAINT PK_id_PASSWORD_RESET PRIMARY KEY (id_PASSWORD_RESET),
        CONSTRAINT FK_id_USUARIOS_USUARIOS_id_USUARIOS_PASSWORD_RESET
            FOREIGN KEY (id_USUARIOS) REFERENCES citas.USUARIOS(id_USUARIOS),
        CONSTRAINT CHK_usado_PASSWORD_RESET CHECK (usado IN (0,1))
    );
    CREATE UNIQUE INDEX IX_token_hash_PASSWORD_RESET ON citas.PASSWORD_RESET(token_hash);
END
GO

IF OBJECT_ID('citas.CONFIG_CORREO', 'U') IS NULL
BEGIN
    CREATE TABLE citas.CONFIG_CORREO (
        id_CONFIG_CORREO         INT IDENTITY(1,1) NOT NULL,
        host                     VARCHAR(150)      NOT NULL,
        puerto                   INT               NOT NULL CONSTRAINT DF_puerto_CONFIG_CORREO DEFAULT (587),
        cifrado                  VARCHAR(10)       NOT NULL CONSTRAINT DF_cifrado_CONFIG_CORREO DEFAULT ('tls'),
        usuario                  VARCHAR(150)      NOT NULL,
        password_cifrada         VARCHAR(500)      NOT NULL,
        remitente                VARCHAR(120)      NOT NULL,
        remitente_nombre         VARCHAR(120)      NOT NULL,
        activo                   BIT               NOT NULL CONSTRAINT DF_activo_CONFIG_CORREO DEFAULT (1),
        id_usuario_creacion      TINYINT           NOT NULL,
        fecha_creacion           SMALLDATETIME     NOT NULL,
        id_usuario_modificacion  TINYINT           NULL,
        fecha_modificacion       SMALLDATETIME     NULL,
        CONSTRAINT PK_id_CONFIG_CORREO PRIMARY KEY (id_CONFIG_CORREO),
        CONSTRAINT CHK_cifrado_CONFIG_CORREO CHECK (cifrado IN ('ninguno','tls','ssl')),
        CONSTRAINT CHK_activo_CONFIG_CORREO CHECK (activo IN (0,1)),
        CONSTRAINT CHK_remitente_CONFIG_CORREO CHECK (remitente LIKE '%_@_%._%')
    );
END
GO

/* ---------- Alta de token de restablecimiento ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaPasswordReset
    @id_USUARIOS  INT,
    @token_hash   VARCHAR(64),
    @minutos      INT,
    @ip           VARCHAR(45),
    @id_usuario   TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    -- Un solo token vigente por usuario: se invalidan los anteriores.
    UPDATE citas.PASSWORD_RESET
       SET usado = 1, fecha_uso = GETDATE()
     WHERE id_USUARIOS = @id_USUARIOS AND usado = 0;

    INSERT INTO citas.PASSWORD_RESET(id_USUARIOS, token_hash, fecha_expira, usado, ip, fecha_creacion)
    VALUES(@id_USUARIOS, @token_hash, DATEADD(MINUTE, @minutos, GETDATE()), 0, @ip, GETDATE());

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('SEGURIDAD', 'spAltaPasswordReset', 'PASSWORD_RESET',
           'SOLICITUD RESTABLECER PASSWORD: id_USUARIOS=' + CAST(@id_USUARIOS AS VARCHAR(10))
           + ', vigencia_min=' + CAST(@minutos AS VARCHAR(10)) + ', ip=' + ISNULL(@ip,'?'),
           GETDATE(), @id_usuario);
END
GO

/* ---------- Consulta de token vigente ---------- */
CREATE OR ALTER PROCEDURE citas.spRegresaPasswordReset
    @token_hash VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.id_PASSWORD_RESET, r.id_USUARIOS, r.fecha_expira, r.usado,
           u.usuario, u.nombre_completo, u.email, u.activo
      FROM citas.PASSWORD_RESET r
      INNER JOIN citas.USUARIOS u ON u.id_USUARIOS = r.id_USUARIOS
     WHERE r.token_hash = @token_hash;
END
GO

/* ---------- Marca el token como usado ---------- */
CREATE OR ALTER PROCEDURE citas.spUsaPasswordReset
    @id_PASSWORD_RESET INT,
    @id_usuario        TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.PASSWORD_RESET
       SET usado = 1, fecha_uso = GETDATE()
     WHERE id_PASSWORD_RESET = @id_PASSWORD_RESET;

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('SEGURIDAD', 'spUsaPasswordReset', 'PASSWORD_RESET',
           'PASSWORD RESTABLECIDO: id_PASSWORD_RESET=' + CAST(@id_PASSWORD_RESET AS VARCHAR(10)),
           GETDATE(), @id_usuario);
END
GO

/* ---------- Solicitudes recientes (control de abuso) ---------- */
CREATE OR ALTER PROCEDURE citas.spCuentaPasswordReset
    @id_USUARIOS INT,
    @minutos     INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) AS total
      FROM citas.PASSWORD_RESET
     WHERE id_USUARIOS = @id_USUARIOS
       AND fecha_creacion >= DATEADD(MINUTE, -@minutos, GETDATE());
END
GO

/* ---------- Configuracion de correo ---------- */
CREATE OR ALTER PROCEDURE citas.spRegresaConfigCorreo
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 id_CONFIG_CORREO, host, puerto, cifrado, usuario, password_cifrada,
                 remitente, remitente_nombre, activo
      FROM citas.CONFIG_CORREO
     ORDER BY id_CONFIG_CORREO;
END
GO

CREATE OR ALTER PROCEDURE citas.spGuardaConfigCorreo
    @host             VARCHAR(150),
    @puerto           INT,
    @cifrado          VARCHAR(10),
    @usuario          VARCHAR(150),
    @password_cifrada VARCHAR(500),
    @remitente        VARCHAR(120),
    @remitente_nombre VARCHAR(120),
    @activo           BIT,
    @id_usuario       TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id INT = (SELECT TOP 1 id_CONFIG_CORREO FROM citas.CONFIG_CORREO ORDER BY id_CONFIG_CORREO);

    IF @id IS NULL
    BEGIN
        INSERT INTO citas.CONFIG_CORREO(host, puerto, cifrado, usuario, password_cifrada, remitente,
                                        remitente_nombre, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@host, @puerto, @cifrado, @usuario, @password_cifrada, @remitente,
               @remitente_nombre, @activo, @id_usuario, GETDATE());
        SET @id = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE citas.CONFIG_CORREO
           SET host = @host, puerto = @puerto, cifrado = @cifrado, usuario = @usuario,
               password_cifrada = CASE WHEN @password_cifrada = '' THEN password_cifrada ELSE @password_cifrada END,
               remitente = @remitente, remitente_nombre = @remitente_nombre, activo = @activo,
               id_usuario_modificacion = @id_usuario, fecha_modificacion = GETDATE()
         WHERE id_CONFIG_CORREO = @id;
    END

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('SISTEMA', 'spGuardaConfigCorreo', 'CONFIG_CORREO',
           'CONFIGURACION CORREO: host=' + @host + ', puerto=' + CAST(@puerto AS VARCHAR(10))
           + ', cifrado=' + @cifrado + ', usuario=' + @usuario + ', remitente=' + @remitente
           + ', activo=' + CAST(@activo AS VARCHAR(1)),
           GETDATE(), @id_usuario);

    SELECT @id AS id_CONFIG_CORREO;
END
GO

GRANT EXECUTE ON OBJECT::citas.spAltaPasswordReset    TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spRegresaPasswordReset TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spUsaPasswordReset     TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spCuentaPasswordReset  TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spRegresaConfigCorreo  TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spGuardaConfigCorreo   TO citasadmin;
GO
