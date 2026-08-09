-- Patch: log detallado al asignar/remover clinicas a un usuario (medico).
-- Registra en citas.LOG quien realizo el movimiento y a que clinica.
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spAltaUsuarioClinica
    @id_USUARIOS INT,
    @id_CLINICA INT,
    @id_usuario TINYINT,
    @actor VARCHAR(150) = NULL,
    @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.USUARIOS_CLINICA(id_USUARIOS,id_CLINICA,id_usuario_creacion,fecha_creacion)
            VALUES(@id_USUARIOS,@id_CLINICA,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();

            DECLARE @medico VARCHAR(150), @clinica VARCHAR(150), @rol VARCHAR(100);
            SELECT @medico = u.nombre_completo, @rol = r.nombre
              FROM citas.USUARIOS u
              LEFT JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
             WHERE u.id_USUARIOS = @id_USUARIOS;
            SELECT @clinica = c.nombre FROM citas.CLINICA c WHERE c.id_CLINICA = @id_CLINICA;

            IF @actor IS NULL
                SELECT @actor = u.nombre_completo FROM citas.USUARIOS u WHERE u.id_USUARIOS = @id_usuario;

            DECLARE @msg VARCHAR(2000);
            SET @msg = 'CLINICA ASIGNADA A USUARIO: usuario=' + ISNULL(@medico,CONVERT(VARCHAR(20),@id_USUARIOS))
                     + ', rol=' + ISNULL(@rol,'?')
                     + ', clinica=' + ISNULL(@clinica,CONVERT(VARCHAR(20),@id_CLINICA))
                     + ', agregado por=' + ISNULL(@actor,CONVERT(VARCHAR(20),@id_usuario))
                     + ', id_USUARIOS_CLINICA=' + CONVERT(VARCHAR(20),@id_nuevo);
            INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spAltaUsuarioClinica','USUARIOS_CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaUsuarioClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spAltaUsuarioClinica','USUARIOS_CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaUsuarioClinica
    @id_USUARIOS_CLINICA INT,
    @id_usuario TINYINT,
    @actor VARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DECLARE @medico VARCHAR(150), @clinica VARCHAR(150);
            SELECT @medico = u.nombre_completo, @clinica = c.nombre
              FROM citas.USUARIOS_CLINICA uc
              LEFT JOIN citas.USUARIOS u ON u.id_USUARIOS = uc.id_USUARIOS
              LEFT JOIN citas.CLINICA  c ON c.id_CLINICA  = uc.id_CLINICA
             WHERE uc.id_USUARIOS_CLINICA = @id_USUARIOS_CLINICA;

            IF @actor IS NULL
                SELECT @actor = u.nombre_completo FROM citas.USUARIOS u WHERE u.id_USUARIOS = @id_usuario;

            DELETE FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS_CLINICA=@id_USUARIOS_CLINICA;

            DECLARE @msg VARCHAR(2000);
            SET @msg = 'CLINICA REMOVIDA A USUARIO: usuario=' + ISNULL(@medico,'?')
                     + ', clinica=' + ISNULL(@clinica,'?')
                     + ', removido por=' + ISNULL(@actor,CONVERT(VARCHAR(20),@id_usuario))
                     + ', id_USUARIOS_CLINICA=' + CONVERT(VARCHAR(20),@id_USUARIOS_CLINICA);
            INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spBajaUsuarioClinica','USUARIOS_CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaUsuarioClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spBajaUsuarioClinica','USUARIOS_CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

GRANT EXECUTE ON citas.spAltaUsuarioClinica TO app_user;
GRANT EXECUTE ON citas.spBajaUsuarioClinica TO app_user;
GO
