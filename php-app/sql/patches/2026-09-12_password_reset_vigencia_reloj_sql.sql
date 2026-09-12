/* ============================================================
   Vigencia del enlace de restablecimiento calculada por SQL Server.
   Evita falsos "enlace expirado" cuando el reloj/zona horaria de PHP
   no coincide con el del motor de base de datos.
   ============================================================ */
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spRegresaPasswordReset
    @token_hash VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.id_PASSWORD_RESET, r.id_USUARIOS, r.fecha_expira, r.usado,
           DATEDIFF(SECOND, GETDATE(), r.fecha_expira) AS segundos_restantes,
           u.usuario, u.nombre_completo, u.email, u.activo
      FROM citas.PASSWORD_RESET r
      INNER JOIN citas.USUARIOS u ON u.id_USUARIOS = r.id_USUARIOS
     WHERE r.token_hash = @token_hash;
END
GO

GRANT EXECUTE ON OBJECT::citas.spRegresaPasswordReset TO citasadmin;
GO
