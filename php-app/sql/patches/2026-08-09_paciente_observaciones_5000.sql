/* Parche: observaciones del paciente hasta 5000 caracteres. */
USE CitasMedicas;
GO
ALTER TABLE citas.PACIENTE ALTER COLUMN observaciones VARCHAR(5000) NULL;
GO
CREATE OR ALTER PROCEDURE citas.spCambioObservacionesPaciente
    @id_PACIENTE INT, @observaciones VARCHAR(5000), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.PACIENTE
               SET observaciones=@observaciones,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_PACIENTE=@id_PACIENTE;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio observaciones paciente id='+CONVERT(VARCHAR(20),@id_PACIENTE);
            INSERT INTO citas.LOG VALUES('PACIENTE','spCambioObservacionesPaciente','PACIENTE',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioObservacionesPaciente: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('PACIENTE','spCambioObservacionesPaciente','PACIENTE',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO
