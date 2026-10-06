/* =====================================================================
   Borrado definitivo de una cita desde la pantalla de Citas.
   Elimina el registro por completo y deja constancia en citas.LOG.
   ===================================================================== */
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spBajaCita
    @id_CITA INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DECLARE @msg VARCHAR(2000);
            SELECT @msg = 'Baja Cita id=' + CONVERT(VARCHAR(20), @id_CITA)
                        + ' paciente=' + ISNULL(CONVERT(VARCHAR(20), id_PACIENTE), '?')
                        + ' fecha=' + ISNULL(CONVERT(VARCHAR(10), fecha_cita, 120), '?')
              FROM citas.CITA WHERE id_CITA = @id_CITA;
            DELETE FROM citas.CITA WHERE id_CITA = @id_CITA;
            IF @msg IS NULL SET @msg = 'Baja Cita id=' + CONVERT(VARCHAR(20), @id_CITA) + ' (no existia)';
            INSERT INTO citas.LOG VALUES('CITA','spBajaCita','CITA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaCita: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CITA','spBajaCita','CITA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO
