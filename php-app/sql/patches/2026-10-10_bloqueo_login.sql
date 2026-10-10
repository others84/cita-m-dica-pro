/* =====================================================================
   Seguridad de acceso:
   - Bloqueo temporal del usuario tras intentos fallidos de login.
   - spAltaUsuario rechaza contrasena vacia.
   Si se aplica en CitasMedicasDEMO, cambiar la linea USE.
   ===================================================================== */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.LOGIN_INTENTO','U') IS NULL
CREATE TABLE citas.LOGIN_INTENTO (
    usuario          VARCHAR(40) NOT NULL,
    intentos         INT         NOT NULL CONSTRAINT DF_LOGIN_INTENTO_intentos DEFAULT 0,
    bloqueado_hasta  DATETIME    NULL,
    fecha_ultimo     DATETIME    NOT NULL CONSTRAINT DF_LOGIN_INTENTO_fecha DEFAULT GETDATE(),
    ip               VARCHAR(45) NULL,
    CONSTRAINT PK_LOGIN_INTENTO PRIMARY KEY (usuario)
);
GO

/* Segundos que faltan para que termine el bloqueo (0 = no bloqueado). */
CREATE OR ALTER PROCEDURE citas.spEstadoLogin
    @usuario VARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CASE WHEN bloqueado_hasta IS NOT NULL AND bloqueado_hasta > GETDATE()
                THEN DATEDIFF(SECOND, GETDATE(), bloqueado_hasta) ELSE 0 END AS segundos_restantes,
           intentos
    FROM citas.LOGIN_INTENTO WHERE usuario = @usuario;
END
GO

/* Registra un intento fallido. Devuelve bloqueado=1 si este intento provoco el bloqueo. */
CREATE OR ALTER PROCEDURE citas.spRegistraLoginFallido
    @usuario VARCHAR(40), @ip VARCHAR(45), @max INT = 5, @minutos INT = 5
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @bloqueado BIT = 0, @intentos INT;
    BEGIN TRY
        BEGIN TRAN;
        IF NOT EXISTS (SELECT 1 FROM citas.LOGIN_INTENTO WITH (UPDLOCK, HOLDLOCK) WHERE usuario=@usuario)
            INSERT INTO citas.LOGIN_INTENTO(usuario,intentos,fecha_ultimo,ip) VALUES(@usuario,0,GETDATE(),@ip);

        -- Si un bloqueo anterior ya vencio, se reinicia el contador.
        UPDATE citas.LOGIN_INTENTO SET intentos=0, bloqueado_hasta=NULL
         WHERE usuario=@usuario AND bloqueado_hasta IS NOT NULL AND bloqueado_hasta <= GETDATE();

        UPDATE citas.LOGIN_INTENTO SET intentos=intentos+1, fecha_ultimo=GETDATE(), ip=@ip
         WHERE usuario=@usuario AND (bloqueado_hasta IS NULL OR bloqueado_hasta <= GETDATE());

        SELECT @intentos=intentos FROM citas.LOGIN_INTENTO WHERE usuario=@usuario;
        IF @intentos >= @max
        BEGIN
            UPDATE citas.LOGIN_INTENTO SET bloqueado_hasta=DATEADD(MINUTE,@minutos,GETDATE()), intentos=0
             WHERE usuario=@usuario;
            SET @bloqueado = 1;
            DECLARE @msg VARCHAR(2000) = 'LOGIN BLOQUEADO usuario=' + @usuario + ' ip=' + ISNULL(@ip,'') +
                                         ' minutos=' + CONVERT(VARCHAR(10),@minutos);
            INSERT INTO citas.LOG VALUES('SEGURIDAD','spRegistraLoginFallido','LOGIN_INTENTO',@msg,GETDATE(),0);
        END
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        ;THROW;
    END CATCH
    SELECT @bloqueado AS bloqueado, ISNULL(@intentos,0) AS intentos;
END
GO

CREATE OR ALTER PROCEDURE citas.spReiniciaLogin
    @usuario VARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM citas.LOGIN_INTENTO WHERE usuario=@usuario;
END
GO

CREATE OR ALTER PROCEDURE citas.spAltaUsuario
    @id_ROLES INT, @usuario VARCHAR(40), @password VARCHAR(200),
    @nombre_completo VARCHAR(150), @email VARCHAR(120),
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @password IS NULL OR LEN(LTRIM(RTRIM(@password))) = 0
            THROW 50001, 'La contraseña es obligatoria al crear un usuario.', 1;
        BEGIN TRAN;
            DECLARE @salt VARCHAR(36) = CONVERT(VARCHAR(36), NEWID());
            DECLARE @hash VARBINARY(64) = HASHBYTES('SHA2_512', @password + @salt);
            INSERT INTO citas.USUARIOS(id_ROLES,usuario,password_hash,password_salt,
                                       nombre_completo,email,activo,id_usuario_creacion,fecha_creacion)
            VALUES(@id_ROLES,@usuario,@hash,@salt,@nombre_completo,@email,1,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Usuario id='+CONVERT(VARCHAR(20),@id_nuevo)+' usuario='+@usuario;
            INSERT INTO citas.LOG VALUES('USUARIOS','spAltaUsuario','USUARIOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaUsuario: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS','spAltaUsuario','USUARIOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO
