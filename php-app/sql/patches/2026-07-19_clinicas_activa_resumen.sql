-- Parche: agrega columna activo a CLINICA (si no existe) y crea SPs
-- spActivaClinica, spDesactivaClinica y spRegresaClinicasResumen.
-- Aplicar en la BD CitasMedicas con el usuario dbo.
USE CitasMedicas;
GO

IF COL_LENGTH('citas.CLINICA','activo') IS NULL
BEGIN
    ALTER TABLE citas.CLINICA ADD activo BIT NOT NULL CONSTRAINT DF_activo_CLINICA DEFAULT (1);
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaClinicas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.id_CLINICA, c.nombre, c.direccion, c.email, c.telefono, c.activo,
           c.id_CATALOGO_MUNICIPIO, m.nombre AS municipio,
           m.id_CATALOGO_ESTADOS, e.nombre AS estado,
           e.id_CATALOGO_PAIS, p.nombre AS pais
      FROM citas.CLINICA c
      JOIN citas.CATALOGO_MUNICIPIO m ON m.id_CATALOGO_MUNICIPIO = c.id_CATALOGO_MUNICIPIO
      JOIN citas.CATALOGO_ESTADOS   e ON e.id_CATALOGO_ESTADOS   = m.id_CATALOGO_ESTADOS
      JOIN citas.CATALOGO_PAIS      p ON p.id_CATALOGO_PAIS      = e.id_CATALOGO_PAIS
     ORDER BY c.nombre;
END
GO

CREATE OR ALTER PROCEDURE citas.spActivaClinica
    @id_CLINICA INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CLINICA SET activo=1,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CLINICA=@id_CLINICA;
            DECLARE @cli VARCHAR(150);
            SELECT @cli=nombre FROM citas.CLINICA WHERE id_CLINICA=@id_CLINICA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Activa Clinica id='+CONVERT(VARCHAR(20),@id_CLINICA)
                    +' nombre='+ISNULL(@cli,'?')
                    +' por usuario id='+CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('CLINICA','spActivaClinica','CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spActivaClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CLINICA','spActivaClinica','CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spDesactivaClinica
    @id_CLINICA INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CLINICA SET activo=0,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CLINICA=@id_CLINICA;
            DECLARE @cli VARCHAR(150);
            SELECT @cli=nombre FROM citas.CLINICA WHERE id_CLINICA=@id_CLINICA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Desactiva Clinica id='+CONVERT(VARCHAR(20),@id_CLINICA)
                    +' nombre='+ISNULL(@cli,'?')
                    +' por usuario id='+CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('CLINICA','spDesactivaClinica','CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spDesactivaClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CLINICA','spDesactivaClinica','CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaClinicasResumen
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.id_CLINICA, c.nombre, c.activo,
           (SELECT COUNT(DISTINCT uc.id_USUARIOS) FROM citas.USUARIOS_CLINICA uc WHERE uc.id_CLINICA = c.id_CLINICA) AS total_usuarios,
           (SELECT COUNT(*) FROM citas.PACIENTE p WHERE p.id_CLINICA = c.id_CLINICA) AS total_pacientes,
           (SELECT COUNT(*) FROM citas.CITA ci JOIN citas.PACIENTE p ON p.id_PACIENTE = ci.id_PACIENTE WHERE p.id_CLINICA = c.id_CLINICA) AS total_citas
      FROM citas.CLINICA c
     ORDER BY c.nombre;
END
GO

GRANT EXECUTE ON citas.spActivaClinica TO citasadmin;
GRANT EXECUTE ON citas.spDesactivaClinica TO citasadmin;
GRANT EXECUTE ON citas.spRegresaClinicasResumen TO citasadmin;
GRANT EXECUTE ON citas.spRegresaClinicas TO citasadmin;
GO