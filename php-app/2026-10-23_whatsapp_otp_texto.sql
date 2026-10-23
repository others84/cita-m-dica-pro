/* Texto editable del OTP WhatsApp - SQL Server 2022.
   Ejecutar en DEMO y LIVE DESPUES de 2026-10-23_whatsapp_evolution.sql.
   Sin USE: aplica a la base seleccionada. No toca Meta ni las reglas OTP.
   Reejecutable: conserva el mensaje existente y las credenciales.
*/
SET XACT_ABORT ON;
GO
IF OBJECT_ID('citas.CONFIG_WHATSAPP_EVOLUTION', 'U') IS NULL
    THROW 51000, 'Primero ejecute 2026-10-23_whatsapp_evolution.sql.', 1;
IF OBJECT_ID('citas.LOG', 'U') IS NULL OR DATABASE_PRINCIPAL_ID('citasadmin') IS NULL
    THROW 51000, 'Falta LOG o el usuario de base citasadmin.', 1;
GO
IF COL_LENGTH('citas.CONFIG_WHATSAPP_EVOLUTION', 'plantilla_otp') IS NULL
BEGIN
    ALTER TABLE citas.CONFIG_WHATSAPP_EVOLUTION ADD plantilla_otp NVARCHAR(2000) NOT NULL
        CONSTRAINT DF_plantilla_otp_CONFIG_WHATSAPP_EVOLUTION
        DEFAULT (N'SGCO Citas: tu código de verificación es {codigo}. Es válido por {minutos} minutos. No lo compartas con nadie.') WITH VALUES;
END;
GO
CREATE OR ALTER PROCEDURE citas.spRegresaConfigWhatsappEvolution
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_CONFIG_WHATSAPP_EVOLUTION, api_url, instancia, api_key_cifrada, lada_default, activo, plantilla_otp
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
    @id_usuario TINYINT = 0,
    @plantilla_otp NVARCHAR(MAX) = N'SGCO Citas: tu código de verificación es {codigo}. Es válido por {minutos} minutos. No lo compartas con nadie.'
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
    IF @plantilla_otp IS NULL OR LEN(LTRIM(RTRIM(@plantilla_otp))) = 0
        OR DATALENGTH(@plantilla_otp) > 4000
        OR CHARINDEX(N'{codigo}', @plantilla_otp COLLATE Latin1_General_100_BIN2) = 0
        THROW 51000, 'El mensaje debe incluir {codigo} y tener un maximo de 2000 caracteres.', 1;
    DECLARE @resto NVARCHAR(MAX) = REPLACE(REPLACE(@plantilla_otp COLLATE Latin1_General_100_BIN2, N'{codigo}', N''), N'{minutos}', N'');
    IF CHARINDEX(N'{', @resto) > 0 OR CHARINDEX(N'}', @resto) > 0
        THROW 51000, 'Solo se admiten las variables {codigo} y {minutos}.', 1;
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
                api_url, instancia, api_key_cifrada, lada_default, activo, plantilla_otp,
                id_usuario_creacion, fecha_creacion)
            VALUES (@api_url, @instancia, @api_key_cifrada, @lada_default, @activo, @plantilla_otp, @id_usuario, SYSDATETIME());
        END
        ELSE
            UPDATE citas.CONFIG_WHATSAPP_EVOLUTION
            SET api_url = @api_url, instancia = @instancia,
                api_key_cifrada = CASE WHEN COALESCE(@api_key_cifrada, '') = ''
                    THEN api_key_cifrada ELSE @api_key_cifrada END,
                lada_default = @lada_default, activo = @activo, plantilla_otp = @plantilla_otp,
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
PRINT 'Texto OTP configurable instalado en ' + DB_NAME();
GO
