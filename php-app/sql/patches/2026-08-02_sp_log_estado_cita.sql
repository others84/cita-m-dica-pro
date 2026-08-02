/* ============================================================
   Parche: citas.spLogEstadoCita
   Registra en citas.LOG los cambios de estatus de una cita
   (Agendada, Confirmada, Atendida, Cancelada, No asistio)
   ============================================================ */
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spLogEstadoCita
    @id_CITA          INT,
    @estado_anterior  VARCHAR(60) = NULL,
    @estado_nuevo     VARCHAR(60),
    @id_CLINICA       INT          = NULL,
    @clinica          VARCHAR(150) = NULL,
    @usuario          VARCHAR(60)  = NULL,
    @id_usuario       TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @evento VARCHAR(2000) =
            'CAMBIO ESTATUS CITA id_CITA=' + CONVERT(VARCHAR(20), @id_CITA) +
            ' estado_anterior=' + ISNULL(@estado_anterior, '(sin estado)') +
            ' estado_nuevo=' + @estado_nuevo +
            ' clinica=' + ISNULL(@clinica, '(n/d)') +
            ' id_CLINICA=' + ISNULL(CONVERT(VARCHAR(20), @id_CLINICA), '(n/d)') +
            ' usuario=' + ISNULL(@usuario, '(n/d)') +
            ' id_usuario=' + CONVERT(VARCHAR(10), @id_usuario);

        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('CITA', 'spLogEstadoCita', 'CITA', @evento, GETDATE(), @id_usuario);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000) = 'ERROR spLogEstadoCita id_CITA=' +
            CONVERT(VARCHAR(20), ISNULL(@id_CITA,0)) + ': ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('CITA', 'spLogEstadoCita', 'CITA', @err, GETDATE(), ISNULL(@id_usuario,0));
    END CATCH
END
GO

GRANT EXECUTE ON OBJECT::citas.spLogEstadoCita TO citasadmin;
GO
