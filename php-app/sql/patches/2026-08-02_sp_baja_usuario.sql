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
        DECLARE @usuario VARCHAR(50), @detalle VARCHAR(1000) = '';
        SELECT @usuario = usuario FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS;

        IF @usuario IS NULL
            ;THROW 51001, 'El usuario no existe o ya fue eliminado.', 1;

        DECLARE @nClinicas INT, @nCitas INT, @nConsultorios INT;

        SELECT @nClinicas = COUNT(*) FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS = @id_USUARIOS;
        SELECT @nCitas    = COUNT(*) FROM citas.CITA            WHERE id_MEDICO   = @id_USUARIOS;
        SELECT @nConsultorios = COUNT(DISTINCT cc.id_CONSULTORIO)
          FROM citas.USUARIOS_CLINICA uc
          JOIN citas.CLINICA_CONSULTORIO cc ON cc.id_CLINICA = uc.id_CLINICA
         WHERE uc.id_USUARIOS = @id_USUARIOS;

        IF (@nClinicas > 0 OR @nCitas > 0 OR @nConsultorios > 0)
        BEGIN
            IF @nClinicas > 0
                SET @detalle = @detalle + CONVERT(VARCHAR(10),@nClinicas) + ' clinica(s); ';
            IF @nConsultorios > 0
                SET @detalle = @detalle + CONVERT(VARCHAR(10),@nConsultorios) + ' consultorio(s); ';
            IF @nCitas > 0
                SET @detalle = @detalle + CONVERT(VARCHAR(10),@nCitas) + ' cita(s); ';

            DECLARE @logNo VARCHAR(2000) =
                'BAJA RECHAZADA Usuario id=' + CONVERT(VARCHAR(20),@id_USUARIOS) +
                ' usuario=' + @usuario + ' asociaciones: ' + @detalle +
                ' solicitada por id_usuario=' + CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('USUARIOS','spBajaUsuario','USUARIOS',@logNo,GETDATE(),@id_usuario);

            DECLARE @msgErr NVARCHAR(2000) =
                N'No se puede eliminar el usuario "' + @usuario +
                N'" porque tiene informacion asociada: ' + @detalle +
                N'Elimine o reasigne esas asociaciones, o desactive el usuario.';
            ;THROW 51000, @msgErr, 1;
        END

        BEGIN TRAN;
            DELETE FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS;
            DECLARE @msg VARCHAR(2000) =
                'BAJA OK Usuario id=' + CONVERT(VARCHAR(20),@id_USUARIOS) +
                ' usuario=' + @usuario +
                ' realizada por id_usuario=' + CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('USUARIOS','spBajaUsuario','USUARIOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaUsuario id=' + CONVERT(VARCHAR(20),@id_USUARIOS) +
                 ' por id_usuario=' + CONVERT(VARCHAR(10),ISNULL(@id_usuario,0)) + ': ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS','spBajaUsuario','USUARIOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

GRANT EXECUTE ON OBJECT::citas.spBajaUsuario TO citasadmin;
GO
