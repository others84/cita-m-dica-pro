/* Corrige el vencimiento del codigo OTP: la vigencia se calcula con el
   reloj de SQL Server (DATEDIFF) y ya no con el reloj de PHP, que podia
   estar en otra zona horaria y marcar el codigo como vencido de inmediato. */
USE CitasMedicas;
GO
CREATE OR ALTER PROCEDURE citas.spRegresaOtpCitaPublica
    @telefono VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 id_OTP_CITA_PUBLICA, telefono, codigo_hash, canal, intentos, usado, fecha_expira,
                 DATEDIFF(SECOND, GETDATE(), fecha_expira) AS segundos_restantes
      FROM citas.OTP_CITA_PUBLICA
     WHERE telefono = @telefono AND usado = 0
     ORDER BY id_OTP_CITA_PUBLICA DESC;
END
GO
GRANT EXECUTE ON OBJECT::citas.spRegresaOtpCitaPublica TO citasadmin;
GO
