/* ============================================================
   Parche: citas.spLogEstadoCita (detalle de CITA ATENDIDA)
   Agrega medico, paciente, especialidad y consultorio al evento
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
    @medico           VARCHAR(200) = NULL,
    @paciente         VARCHAR(200) = NULL,
    @especialidad     VARCHAR(150) = NULL,
    @consultorio      VARCHAR(150) = NULL,
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

        IF @prefijo = 'CITA ATENDIDA'
        BEGIN
            /* Completa los datos faltantes desde la cita */
            SELECT
                @medico       = ISNULL(@medico, LTRIM(RTRIM(ISNULL(u.nombre,'') + ' ' + ISNULL(u.ap_paterno,'') + ' ' + ISNULL(u.ap_materno,'')))),
                @paciente     = ISNULL(@paciente, LTRIM(RTRIM(ISNULL(p.nombre,'') + ' ' + ISNULL(p.ap_paterno,'') + ' ' + ISNULL(p.ap_materno,'')))),
                @especialidad = ISNULL(@especialidad, e.nombre),
                @consultorio  = ISNULL(@consultorio, co.nombre),
                @clinica      = ISNULL(@clinica, cl.nombre)
            FROM citas.CITA c
            LEFT JOIN citas.USUARIOS u                 ON u.id_USUARIOS = c.id_MEDICO
            LEFT JOIN citas.PACIENTE p                 ON p.id_PACIENTE = c.id_PACIENTE
            LEFT JOIN citas.CATALOGO_ESPECIALIDAD e    ON e.id_CATALOGO_ESPECIALIDAD = c.id_CATALOGO_ESPECIALIDAD
            LEFT JOIN citas.CONSULTORIO co             ON co.id_CONSULTORIO = c.id_CONSULTORIO
            LEFT JOIN citas.CLINICA cl                 ON cl.id_CLINICA = co.id_CLINICA
            WHERE c.id_CITA = @id_CITA;

            SET @evento = 'CITA ATENDIDA' +
                ' medico=' + ISNULL(NULLIF(LTRIM(RTRIM(@medico)), ''), '(n/d)') +
                ' paciente=' + ISNULL(NULLIF(LTRIM(RTRIM(@paciente)), ''), '(n/d)') +
                ' clinica=' + ISNULL(NULLIF(LTRIM(RTRIM(@clinica)), ''), '(n/d)') +
                ' especialidad=' + ISNULL(NULLIF(LTRIM(RTRIM(@especialidad)), ''), '(n/d)') +
                ' consultorio=' + ISNULL(NULLIF(LTRIM(RTRIM(@consultorio)), ''), '(n/d)') +
                ' id_CITA=' + CONVERT(VARCHAR(20), @id_CITA) +
                ' usuario=' + ISNULL(@usuario, '(n/d)') +
                ' id_usuario=' + CONVERT(VARCHAR(10), @id_usuario);
        END
        ELSE IF @prefijo = 'CITA CANCELADA'
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