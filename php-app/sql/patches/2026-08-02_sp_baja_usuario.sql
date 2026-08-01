/* ============================================================
   Parche: crea citas.spBajaUsuario (eliminacion definitiva)
   Ejecutar sobre la base CitasMedicas
   ============================================================ */
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spBajaUsuario
    @id_USUARIOS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM citas.CITA WHERE id_MEDICO = @id_USUARIOS)
        BEGIN
            ;THROW 51000, 'No se puede eliminar: el usuario tiene citas registradas. Desactivelo en su lugar.', 1;
        END

        BEGIN TRAN;
            DECLARE @usuario VARCHAR(50);
            SELECT @usuario = usuario FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS;

            DELETE FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS = @id_USUARIOS;
            DELETE FROM citas.USUARIOS        WHERE id_USUARIOS = @id_USUARIOS;

            DECLARE @msg VARCHAR(2000);
            SET @msg='Baja Usuario id='+CONVERT(VARCHAR(20),@id_USUARIOS)+' usuario='+ISNULL(@usuario,'?');
            INSERT INTO citas.LOG VALUES('USUARIOS','spBajaUsuario','USUARIOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaUsuario: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS','spBajaUsuario','USUARIOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

GRANT EXECUTE ON OBJECT::citas.spBajaUsuario TO citasadmin;
GO
