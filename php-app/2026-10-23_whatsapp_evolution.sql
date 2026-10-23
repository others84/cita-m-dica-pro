/* Evolution API - SQL Server 2022
   Ejecutar primero en la base elegida con sqlcmd -b -d CitasMedicas
   o -d citasMedicasDEMO. No incluye USE para no cambiar accidentalmente de base.
   Requiere el esquema citas, citas.LOG y el usuario de BD citasadmin.
   Conserva CONFIG_WHATSAPP (Meta) y OTP_CITA_PUBLICA sin modificaciones.
   No copia tokens de Meta: guardar URL, instancia y API Key desde el aplicativo.
*/
SET XACT_ABORT ON;
GO
IF SCHEMA_ID('citas') IS NULL OR OBJECT_ID('citas.LOG', 'U') IS NULL
    THROW 51000, 'Falta el esquema citas o la tabla LOG. Ejecute sobre la base del sistema de citas.', 1;
IF DATABASE_PRINCIPAL_ID('citasadmin') IS NULL
    THROW 51000, 'Falta el usuario de base de datos citasadmin.', 1;
GO
IF OBJECT_ID('citas.CONFIG_WHATSAPP_EVOLUTION', 'U') IS NULL
BEGIN
    CREATE TABLE citas.CONFIG_WHATSAPP_EVOLUTION (
        id_CONFIG_WHATSAPP_EVOLUTION TINYINT NOT NULL
            CONSTRAINT DF_id_CONFIG_WHATSAPP_EVOLUTION DEFAULT (1),
        api_url VARCHAR(500) NOT NULL,
        instancia VARCHAR(60) NOT NULL,
        api_key_cifrada VARCHAR(2000) NOT NULL,
        lada_default VARCHAR(5) NOT NULL
            CONSTRAINT DF_lada_CONFIG_WHATSAPP_EVOLUTION DEFAULT ('52'),
        activo BIT NOT NULL
            CONSTRAINT DF_activo_CONFIG_WHATSAPP_EVOLUTION DEFAULT (0),
        id_usuario_creacion TINYINT NOT NULL,
        fecha_creacion DATETIME2(0) NOT NULL,
        id_usuario_modificacion TINYINT NULL,
        fecha_modificacion DATETIME2(0) NULL,
        CONSTRAINT PK_CONFIG_WHATSAPP_EVOLUTION PRIMARY KEY (id_CONFIG_WHATSAPP_EVOLUTION),
        CONSTRAINT CHK_unica_CONFIG_WHATSAPP_EVOLUTION CHECK (id_CONFIG_WHATSAPP_EVOLUTION = 1),
        CONSTRAINT CHK_url_CONFIG_WHATSAPP_EVOLUTION CHECK (
            api_url LIKE 'http://_%' OR api_url LIKE 'https://_%'),
        CONSTRAINT CHK_instancia_CONFIG_WHATSAPP_EVOLUTION CHECK (LEN(instancia) BETWEEN 1 AND 60),
        CONSTRAINT CHK_lada_CONFIG_WHATSAPP_EVOLUTION CHECK (
            LEN(lada_default) BETWEEN 1 AND 5 AND lada_default NOT LIKE '%[^0-9]%' AND LEFT(lada_default, 1) <> '0'),
        CONSTRAINT CHK_key_CONFIG_WHATSAPP_EVOLUTION CHECK (LEN(api_key_cifrada) > 0)
    );
END;
GO
CREATE OR ALTER PROCEDURE citas.spRegresaConfigWhatsappEvolution
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_CONFIG_WHATSAPP_EVOLUTION, api_url, instancia, api_key_cifrada, lada_default, activo
    FROM citas.CONFIG_WHATSAPP_EVOLUTION
    WHERE id_CONFIG_WHATSAPP_EVOLUTION = 1;
END;
GO
CREATE OR ALTER PROCEDURE citas.spGuardaConfigWhatsappEvolution
    @api_url VARCHAR(500),
    @instancia VARCHAR(60),
    @api_key_cifrada VARCHAR(2000) = '',
    @lada_default VARCHAR(5) = '52',
    @activo BIT = 1,
    @id_usuario TINYINT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    IF @api_url IS NULL OR NOT (@api_url LIKE 'http://_%' OR @api_url LIKE 'https://_%')
        THROW 51000, 'URL de Evolution no valida.', 1;
    IF @instancia IS NULL OR LEN(@instancia) = 0
        OR @instancia COLLATE Latin1_General_100_BIN2 LIKE '%[^A-Za-z0-9_-]%'
        THROW 51000, 'Nombre de instancia no valido.', 1;
    IF @lada_default IS NULL OR LEN(@lada_default) = 0
        OR @lada_default LIKE '%[^0-9]%' OR LEFT(@lada_default, 1) = '0'
        THROW 51000, 'Lada no valida.', 1;
    BEGIN TRY
        BEGIN TRANSACTION;
        -- Bloqueo de rango: evita dos altas simultaneas de la configuracion unica.
        DECLARE @existe TINYINT;
        SELECT @existe = id_CONFIG_WHATSAPP_EVOLUTION
        FROM citas.CONFIG_WHATSAPP_EVOLUTION WITH (UPDLOCK, HOLDLOCK)
        WHERE id_CONFIG_WHATSAPP_EVOLUTION = 1;
        IF @existe IS NULL
        BEGIN
            IF @api_key_cifrada IS NULL OR LEN(@api_key_cifrada) = 0
                THROW 51000, 'Capture la API Key para crear la configuracion.', 1;
            INSERT INTO citas.CONFIG_WHATSAPP_EVOLUTION (
                api_url, instancia, api_key_cifrada, lada_default, activo,
                id_usuario_creacion, fecha_creacion)
            VALUES (@api_url, @instancia, @api_key_cifrada, @lada_default, @activo, @id_usuario, SYSDATETIME());
        END
        ELSE
            UPDATE citas.CONFIG_WHATSAPP_EVOLUTION
            SET api_url = @api_url, instancia = @instancia,
                api_key_cifrada = CASE WHEN COALESCE(@api_key_cifrada, '') = ''
                    THEN api_key_cifrada ELSE @api_key_cifrada END,
                lada_default = @lada_default, activo = @activo,
                id_usuario_modificacion = @id_usuario, fecha_modificacion = SYSDATETIME()
            WHERE id_CONFIG_WHATSAPP_EVOLUTION = 1;
        INSERT INTO citas.LOG (modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES ('SISTEMA', 'spGuardaConfigWhatsappEvolution', 'CONFIG_WHATSAPP_EVOLUTION',
            'CONFIGURACION EVOLUTION GUARDADA; activo=' + CAST(@activo AS VARCHAR(1)), GETDATE(), @id_usuario);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON OBJECT::citas.spRegresaConfigWhatsappEvolution TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spGuardaConfigWhatsappEvolution TO citasadmin;
GO
PRINT 'Evolution instalado en ' + DB_NAME() + '. Capture la configuracion en el aplicativo.';
GO