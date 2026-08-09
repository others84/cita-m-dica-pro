-- =====================================================================
-- Detalle del evento en citas.LOG al marcar una cita como notificada:
-- usuario que la registro, paciente notificado, clinica y consultorio.
-- =====================================================================
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spNotificaCita
    @id_CITA INT, @id_usuario TINYINT, @usuario VARCHAR(40) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CITA
               SET notificado = 1,
                   id_usuario_modificacion = @id_usuario,
                   fecha_modificacion = GETDATE()
             WHERE id_CITA = @id_CITA;

            DECLARE @msg VARCHAR(2000);
            SELECT @msg = 'CITA NOTIFICADA id_CITA=' + CONVERT(VARCHAR(20), ci.id_CITA)
                        + ' usuario=' + ISNULL(@usuario, ISNULL(us.usuario, '(n/d)'))
                        + ' id_usuario=' + CONVERT(VARCHAR(10), @id_usuario)
                        + ' paciente=' + LTRIM(RTRIM(p.ap_paterno + ' ' + p.ap_materno + ' ' + p.nombre))
                        + ' id_PACIENTE=' + CONVERT(VARCHAR(20), p.id_PACIENTE)
                        + ' clinica=' + cl.nombre
                        + ' id_CLINICA=' + CONVERT(VARCHAR(20), cl.id_CLINICA)
                        + ' consultorio=' + co.nombre
                        + ' id_CONSULTORIO=' + CONVERT(VARCHAR(20), co.id_CONSULTORIO)
              FROM citas.CITA ci
              JOIN citas.PACIENTE     p  ON p.id_PACIENTE     = ci.id_PACIENTE
              JOIN citas.CLINICA      cl ON cl.id_CLINICA     = p.id_CLINICA
              JOIN citas.CONSULTORIO  co ON co.id_CONSULTORIO = ci.id_CONSULTORIO
              LEFT JOIN citas.USUARIOS us ON us.id_USUARIOS   = @id_usuario
             WHERE ci.id_CITA = @id_CITA;

            IF @msg IS NULL
                SET @msg = 'CITA NOTIFICADA id_CITA=' + CONVERT(VARCHAR(20), @id_CITA)
                         + ' usuario=' + ISNULL(@usuario, '(n/d)');

            INSERT INTO citas.LOG VALUES('CITA','spNotificaCita','CITA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spNotificaCita: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CITA','spNotificaCita','CITA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

GRANT EXECUTE ON OBJECT::citas.spNotificaCita TO citasadmin;
GO
