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
        DECLARE @nuevoNorm VARCHAR(60) = LOWER(LTRIM(RTRIM(ISNULL(@estado_nuevo, ''))));
        DECLARE @prefijo VARCHAR(40);

        IF (@estado_anterior IS NULL OR LTRIM(RTRIM(@estado_anterior)) = '')
            SET @prefijo = 'ALTA CITA';
        ELSE IF @nuevoNorm IN ('atendida', 'atendido')
            SET @prefijo = 'CITA ATENDIDA';
        ELSE IF @nuevoNorm IN ('cancelada', 'cancelado')
            SET @prefijo = 'CITA CANCELADA';
        ELSE IF @nuevoNorm IN ('confirmada', 'confirmado')
            SET @prefijo = 'CITA CONFIRMADA';
        ELSE IF @nuevoNorm IN ('no asistio', 'no asistió', 'noasistio')
            SET @prefijo = 'CITA NO ASISTIO';
        ELSE IF @nuevoNorm IN ('agendada', 'agendado')
            SET @prefijo = 'CITA AGENDADA';
        ELSE
            SET @prefijo = 'CAMBIO ESTATUS CITA';

        DECLARE @evento VARCHAR(2000);

        IF @prefijo = 'CITA CANCELADA'
            SET @evento = 'CITA CANCELADA' +
                ' clinica=' + ISNULL(@clinica, '(n/d)') +
                ' id_CLINICA=' + ISNULL(CONVERT(VARCHAR(20), @id_CLINICA), '(n/d)') +
                ' usuario=' + ISNULL(@usuario, '(n/d)') +
                ' id_usuario=' + CONVERT(VARCHAR(10), @id_usuario) +
                ' id_CITA=' + CONVERT(VARCHAR(20), @id_CITA);
        ELSE
        SET @evento =
            @prefijo + ' id_CITA=' + CONVERT(VARCHAR(20), @id_CITA) +
            CASE WHEN @prefijo = 'ALTA CITA' THEN ''
                 ELSE ' estado_anterior=' + ISNULL(@estado_anterior, '(sin estado)') END +
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
