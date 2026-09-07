/* =====================================================================
   Parche: verificacion por codigo (OTP) en la cita PUBLICA y
           configuracion de WhatsApp Cloud API (Meta).

   - citas.CONFIG_WHATSAPP   : credenciales de WhatsApp Cloud API (fila unica)
   - citas.OTP_CITA_PUBLICA  : codigos de verificacion (solo hash, 1 solo uso)

   Ejecutar con:
     sqlcmd -S localhost,1433 -U sa -C -i patch_otp_whatsapp.sql
   ===================================================================== */
USE CitasMedicas;
GO

/* ---------------------- tabla CONFIG_WHATSAPP ---------------------- */
IF OBJECT_ID('citas.CONFIG_WHATSAPP', 'U') IS NULL
BEGIN
    CREATE TABLE citas.CONFIG_WHATSAPP (
        id_CONFIG_WHATSAPP       INT IDENTITY(1,1) NOT NULL,
        phone_number_id          VARCHAR(60)       NOT NULL,
        waba_id                  VARCHAR(60)       NULL,
        token_cifrado            VARCHAR(2000)     NOT NULL,
        api_version              VARCHAR(10)       NOT NULL CONSTRAINT DF_api_version_CONFIG_WHATSAPP DEFAULT ('v21.0'),
        plantilla                VARCHAR(120)      NOT NULL CONSTRAINT DF_plantilla_CONFIG_WHATSAPP DEFAULT ('codigo_verificacion'),
        plantilla_idioma         VARCHAR(20)       NOT NULL CONSTRAINT DF_plantilla_idioma_CONFIG_WHATSAPP DEFAULT ('es_MX'),
        lada_default             VARCHAR(5)        NOT NULL CONSTRAINT DF_lada_default_CONFIG_WHATSAPP DEFAULT ('52'),
        activo                   BIT               NOT NULL CONSTRAINT DF_activo_CONFIG_WHATSAPP DEFAULT (1),
        id_usuario_creacion      TINYINT           NOT NULL,
        fecha_creacion           SMALLDATETIME     NOT NULL,
        id_usuario_modificacion  TINYINT           NULL,
        fecha_modificacion       SMALLDATETIME     NULL,
        CONSTRAINT PK_id_CONFIG_WHATSAPP PRIMARY KEY (id_CONFIG_WHATSAPP),
        CONSTRAINT CHK_activo_CONFIG_WHATSAPP CHECK (activo IN (0,1))
    );
END
GO

/* --------------------- tabla OTP_CITA_PUBLICA ---------------------- */
IF OBJECT_ID('citas.OTP_CITA_PUBLICA', 'U') IS NULL
BEGIN
    CREATE TABLE citas.OTP_CITA_PUBLICA (
        id_OTP_CITA_PUBLICA  INT IDENTITY(1,1) NOT NULL,
        telefono             VARCHAR(20)       NOT NULL,
        codigo_hash          VARCHAR(64)       NOT NULL,
        canal                VARCHAR(10)       NOT NULL,
        intentos             TINYINT           NOT NULL CONSTRAINT DF_intentos_OTP_CITA_PUBLICA DEFAULT (0),
        usado                BIT               NOT NULL CONSTRAINT DF_usado_OTP_CITA_PUBLICA DEFAULT (0),
        fecha_expira         DATETIME          NOT NULL,
        ip                   VARCHAR(45)       NULL,
        fecha_creacion       DATETIME          NOT NULL CONSTRAINT DF_fecha_creacion_OTP_CITA_PUBLICA DEFAULT (GETDATE()),
        fecha_uso            DATETIME          NULL,
        CONSTRAINT PK_id_OTP_CITA_PUBLICA PRIMARY KEY (id_OTP_CITA_PUBLICA),
        CONSTRAINT CHK_canal_OTP_CITA_PUBLICA CHECK (canal IN ('correo','whatsapp')),
        CONSTRAINT CHK_usado_OTP_CITA_PUBLICA CHECK (usado IN (0,1))
    );
    CREATE INDEX IX_telefono_OTP_CITA_PUBLICA ON citas.OTP_CITA_PUBLICA(telefono, fecha_creacion);
END
GO

/* ---------------- spRegresaConfigWhatsapp -------------------------- */
CREATE OR ALTER PROCEDURE citas.spRegresaConfigWhatsapp
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 id_CONFIG_WHATSAPP, phone_number_id, waba_id, token_cifrado, api_version,
                 plantilla, plantilla_idioma, lada_default, activo
      FROM citas.CONFIG_WHATSAPP
     ORDER BY id_CONFIG_WHATSAPP;
END
GO
GRANT EXECUTE ON OBJECT::citas.spRegresaConfigWhatsapp TO citasadmin;
GO

/* ---------------- spGuardaConfigWhatsapp --------------------------- */
CREATE OR ALTER PROCEDURE citas.spGuardaConfigWhatsapp
    @phone_number_id  VARCHAR(60),
    @waba_id          VARCHAR(60) = NULL,
    @token_cifrado    VARCHAR(2000) = '',
    @api_version      VARCHAR(10) = 'v21.0',
    @plantilla        VARCHAR(120) = 'codigo_verificacion',
    @plantilla_idioma VARCHAR(20) = 'es_MX',
    @lada_default     VARCHAR(5) = '52',
    @activo           BIT = 1,
    @id_usuario       TINYINT = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id INT = (SELECT TOP 1 id_CONFIG_WHATSAPP FROM citas.CONFIG_WHATSAPP ORDER BY id_CONFIG_WHATSAPP);

    IF @id IS NULL
    BEGIN
        INSERT INTO citas.CONFIG_WHATSAPP(phone_number_id, waba_id, token_cifrado, api_version, plantilla,
                                          plantilla_idioma, lada_default, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@phone_number_id, @waba_id, @token_cifrado, @api_version, @plantilla,
               @plantilla_idioma, @lada_default, @activo, @id_usuario, GETDATE());
        SET @id = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE citas.CONFIG_WHATSAPP
           SET phone_number_id = @phone_number_id,
               waba_id         = @waba_id,
               token_cifrado   = CASE WHEN @token_cifrado = '' THEN token_cifrado ELSE @token_cifrado END,
               api_version     = @api_version,
               plantilla       = @plantilla,
               plantilla_idioma= @plantilla_idioma,
               lada_default    = @lada_default,
               activo          = @activo,
               id_usuario_modificacion = @id_usuario,
               fecha_modificacion      = GETDATE()
         WHERE id_CONFIG_WHATSAPP = @id;
    END

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('SISTEMA', 'spGuardaConfigWhatsapp', 'CONFIG_WHATSAPP',
           'CONFIGURACION WHATSAPP GUARDADA: phone_number_id=' + @phone_number_id
           + ' activo=' + CAST(@activo AS VARCHAR(1)), GETDATE(), @id_usuario);

    SELECT @id AS id_CONFIG_WHATSAPP;
END
GO
GRANT EXECUTE ON OBJECT::citas.spGuardaConfigWhatsapp TO citasadmin;
GO

/* ---------------- spAltaOtpCitaPublica ----------------------------- */
CREATE OR ALTER PROCEDURE citas.spAltaOtpCitaPublica
    @telefono     VARCHAR(20),
    @codigo_hash  VARCHAR(64),
    @canal        VARCHAR(10),
    @minutos      INT = 10,
    @ip           VARCHAR(45) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    -- Un solo codigo vigente por telefono.
    UPDATE citas.OTP_CITA_PUBLICA
       SET usado = 1, fecha_uso = GETDATE()
     WHERE telefono = @telefono AND usado = 0;

    INSERT INTO citas.OTP_CITA_PUBLICA(telefono, codigo_hash, canal, fecha_expira, ip)
    VALUES(@telefono, @codigo_hash, @canal, DATEADD(MINUTE, @minutos, GETDATE()), @ip);

    SELECT SCOPE_IDENTITY() AS id_OTP_CITA_PUBLICA;
END
GO
GRANT EXECUTE ON OBJECT::citas.spAltaOtpCitaPublica TO citasadmin;
GO

/* ---------------- spRegresaOtpCitaPublica -------------------------- */
CREATE OR ALTER PROCEDURE citas.spRegresaOtpCitaPublica
    @telefono VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 id_OTP_CITA_PUBLICA, telefono, codigo_hash, canal, intentos, usado, fecha_expira,
                 DATEDIFF(SECOND, GETDATE(), fecha_expira) AS segundos_restantes
      FROM citas.OTP_CITA_PUBLICA
     WHERE telefono = @telefono AND usado = 0
     ORDER BY id_OTP_CITA_PUBLICA DESC;
END
GO
GRANT EXECUTE ON OBJECT::citas.spRegresaOtpCitaPublica TO citasadmin;
GO

/* ---------------- spIntentoOtpCitaPublica -------------------------- */
CREATE OR ALTER PROCEDURE citas.spIntentoOtpCitaPublica
    @id_OTP_CITA_PUBLICA INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.OTP_CITA_PUBLICA
       SET intentos = intentos + 1
     WHERE id_OTP_CITA_PUBLICA = @id_OTP_CITA_PUBLICA;

    SELECT intentos FROM citas.OTP_CITA_PUBLICA WHERE id_OTP_CITA_PUBLICA = @id_OTP_CITA_PUBLICA;
END
GO
GRANT EXECUTE ON OBJECT::citas.spIntentoOtpCitaPublica TO citasadmin;
GO

/* ---------------- spUsaOtpCitaPublica ------------------------------ */
CREATE OR ALTER PROCEDURE citas.spUsaOtpCitaPublica
    @id_OTP_CITA_PUBLICA INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.OTP_CITA_PUBLICA
       SET usado = 1, fecha_uso = GETDATE()
     WHERE id_OTP_CITA_PUBLICA = @id_OTP_CITA_PUBLICA;
END
GO
GRANT EXECUTE ON OBJECT::citas.spUsaOtpCitaPublica TO citasadmin;
GO

/* ---------------- spCuentaOtpCitaPublica --------------------------- */
CREATE OR ALTER PROCEDURE citas.spCuentaOtpCitaPublica
    @telefono VARCHAR(20),
    @minutos  INT = 60
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) AS total
      FROM citas.OTP_CITA_PUBLICA
     WHERE telefono = @telefono
       AND fecha_creacion >= DATEADD(MINUTE, -@minutos, GETDATE());
END
GO
GRANT EXECUTE ON OBJECT::citas.spCuentaOtpCitaPublica TO citasadmin;
GO
