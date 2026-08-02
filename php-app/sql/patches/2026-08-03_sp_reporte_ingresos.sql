-- Reporte: ingresos por medico (mensual). Reemplaza la vista citas.vwIngresosPorMedico
-- que no existia y provocaba: Invalid object name 'citas.vwIngresosPorMedico'.
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spReporteIngresosPorMedico
    @id_CLINICA INT = NULL,
    @fecha_desde DATE = NULL,
    @fecha_hasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  CONVERT(CHAR(7), ci.fecha_cita, 126) AS periodo,
            u.nombre_completo                    AS medico,
            SUM(ci.precio)                       AS total
      FROM citas.CITA ci
      JOIN citas.PACIENTE p ON p.id_PACIENTE = ci.id_PACIENTE
      JOIN citas.USUARIOS u ON u.id_USUARIOS = ci.id_MEDICO
      JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_CATALOGO_ESTADO_CITAS = ci.id_CATALOGO_ESTADO_CITAS
     WHERE ec.nombre LIKE 'Atendid%'
       AND (@id_CLINICA  IS NULL OR p.id_CLINICA  = @id_CLINICA)
       AND (@fecha_desde IS NULL OR ci.fecha_cita >= @fecha_desde)
       AND (@fecha_hasta IS NULL OR ci.fecha_cita <= @fecha_hasta)
     GROUP BY CONVERT(CHAR(7), ci.fecha_cita, 126), u.nombre_completo
     ORDER BY periodo DESC, total DESC;
END
GO

GRANT EXECUTE ON OBJECT::citas.spReporteIngresosPorMedico TO citasadmin;
GO
