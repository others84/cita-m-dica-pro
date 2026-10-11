/* ============================================================
   Parche: proteccion anti-bots de la cita publica
   - citas.LIMITE_IP: registro de acciones por IP
   - citas.CONFIG_ANTIBOT: CAPTCHA (Turnstile) y limites
   Ejecutar en CitasMedicas y en citasMedicasDEMO (cambiar USE).
   ============================================================ */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.LIMITE_IP') IS NULL
BEGIN
    CREATE TABLE citas.LIMITE_IP(
        id_LIMITE_IP BIGINT IDENTITY(1,1) PRIMARY KEY,
        ip           VARCHAR(45) NOT NULL,
        accion       VARCHAR(20) NOT NULL,
        fecha        DATETIME NOT NULL DEFAULT GETDATE()
    );
    CREATE INDEX IX_LIMITE_IP_ip_accion ON citas.LIMITE_IP(ip, accion, fecha);
END
GO

IF OBJECT_ID('citas.CONFIG_ANTIBOT') IS NULL
BEGIN
    CREATE TABLE citas.CONFIG_ANTIBOT(
        id_CONFIG_ANTIBOT     INT IDENTITY(1,1) PRIMARY KEY,
        captcha_activo        BIT NOT NULL DEFAULT 0,
        site_key              VARCHAR(200) NULL,
        secret_cifrado        VARCHAR(1000) NULL,
        lim_buscar_hora       INT NOT NULL DEFAULT 20,
        lim_otp_hora          INT NOT NULL DEFAULT 10,
        lim_paciente_dia      INT NOT NULL DEFAULT 3,
        lim_cita_dia          INT NOT NULL DEFAULT 5,
        lim_citas_futuras     INT NOT NULL DEFAULT 2,
        fecha_modificacion    DATETIME NULL,
        id_usuario            TINYINT NULL
    );
    INSERT INTO citas.CONFIG_ANTIBOT(captcha_activo) VALUES(0);
END
GO

CREATE OR ALTER PROCEDURE citas.spRegistraLimiteIp @ip VARCHAR(45), @accion VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO citas.LIMITE_IP(ip, accion, fecha) VALUES(@ip, @accion, GETDATE());
    -- Purga ocasional de registros viejos
    IF ABS(CHECKSUM(NEWID())) % 50 = 0
        DELETE FROM citas.LIMITE_IP WHERE fecha < DATEADD(DAY, -2, GETDATE());
END
GO

CREATE OR ALTER PROCEDURE citas.spCuentaLimiteIp @ip VARCHAR(45), @accion VARCHAR(20), @minutos INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) AS total FROM citas.LIMITE_IP
     WHERE ip = @ip AND accion = @accion AND fecha >= DATEADD(MINUTE, -@minutos, GETDATE());
END
GO

CREATE OR ALTER PROCEDURE citas.spPurgaLimiteIp
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM citas.LIMITE_IP WHERE fecha < DATEADD(DAY, -2, GETDATE());
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaConfigAntibot
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 * FROM citas.CONFIG_ANTIBOT ORDER BY id_CONFIG_ANTIBOT;
END
GO

CREATE OR ALTER PROCEDURE citas.spGuardaConfigAntibot
    @captcha_activo BIT, @site_key VARCHAR(200), @secret_cifrado VARCHAR(1000),
    @lim_buscar_hora INT, @lim_otp_hora INT, @lim_paciente_dia INT, @lim_cita_dia INT,
    @lim_citas_futuras INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS(SELECT 1 FROM citas.CONFIG_ANTIBOT) INSERT INTO citas.CONFIG_ANTIBOT(captcha_activo) VALUES(0);
        UPDATE citas.CONFIG_ANTIBOT SET
            captcha_activo = @captcha_activo,
            site_key = @site_key,
            secret_cifrado = CASE WHEN ISNULL(@secret_cifrado,'') = '' THEN secret_cifrado ELSE @secret_cifrado END,
            lim_buscar_hora = @lim_buscar_hora, lim_otp_hora = @lim_otp_hora,
            lim_paciente_dia = @lim_paciente_dia, lim_cita_dia = @lim_cita_dia,
            lim_citas_futuras = @lim_citas_futuras,
            fecha_modificacion = GETDATE(), id_usuario = @id_usuario;
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('CONFIGURACION','spGuardaConfigAntibot','CONFIG_ANTIBOT','CAMBIO CONFIG ANTIBOT', GETDATE(), @id_usuario);
    END TRY
    BEGIN CATCH
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('CONFIGURACION','spGuardaConfigAntibot','CONFIG_ANTIBOT','ERROR: ' + ERROR_MESSAGE(), GETDATE(), @id_usuario);
        THROW;
    END CATCH
END
GO

/* Citas futuras activas (Agendada/Confirmada) de un celular con un medico */
CREATE OR ALTER PROCEDURE citas.spCuentaCitasFuturasTelefono @telefono VARCHAR(20), @id_MEDICO INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) AS total
      FROM citas.CITA c
      JOIN citas.PACIENTE p ON p.id_PACIENTE = c.id_PACIENTE
      JOIN citas.CATALOGO_ESTADO_CITAS e ON e.id_CATALOGO_ESTADO_CITAS = c.id_CATALOGO_ESTADO_CITAS
     WHERE c.id_MEDICO = @id_MEDICO
       AND c.fecha_cita >= CAST(GETDATE() AS DATE)
       AND (e.nombre LIKE '%agendad%' OR e.nombre LIKE '%confirm%')
       AND REPLACE(REPLACE(REPLACE(REPLACE(p.telefono,' ',''),'-',''),'(',''),')','') LIKE '%' + @telefono;
END
GO

GRANT EXECUTE ON OBJECT::citas.spRegistraLimiteIp TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spCuentaLimiteIp TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spPurgaLimiteIp TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spRegresaConfigAntibot TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spGuardaConfigAntibot TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spCuentaCitasFuturasTelefono TO citasadmin;
GO
