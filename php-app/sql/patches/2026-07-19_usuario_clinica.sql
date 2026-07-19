-- Patch: acceso multi-clinica por usuario
-- Aplicar en la base CitasMedicas con el usuario dbo.
USE CitasMedicas;
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
               WHERE s.name='citas' AND t.name='USUARIO_CLINICA')
BEGIN
    CREATE TABLE citas.USUARIO_CLINICA (
        id_USUARIO INT NOT NULL,
        id_CLINICA INT NOT NULL,
        fecha_asignacion DATETIME2 NOT NULL CONSTRAINT DF_UC_fec DEFAULT SYSDATETIME(),
        CONSTRAINT PK_USUARIO_CLINICA PRIMARY KEY (id_USUARIO, id_CLINICA),
        CONSTRAINT FK_UC_USUARIO FOREIGN KEY (id_USUARIO) REFERENCES citas.USUARIOS(id_USUARIOS) ON DELETE CASCADE,
        CONSTRAINT FK_UC_CLINICA FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA)
    );
END
GO

-- Semilla: copia la asignacion existente de USUARIOS.id_CLINICA
INSERT INTO citas.USUARIO_CLINICA (id_USUARIO, id_CLINICA)
SELECT u.id_USUARIOS, u.id_CLINICA
FROM citas.USUARIOS u
WHERE u.id_CLINICA IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM citas.USUARIO_CLINICA uc
      WHERE uc.id_USUARIO = u.id_USUARIOS AND uc.id_CLINICA = u.id_CLINICA
  );
GO

IF OBJECT_ID('citas.spRegresaClinicasUsuario','P') IS NOT NULL DROP PROCEDURE citas.spRegresaClinicasUsuario;
GO
CREATE PROCEDURE citas.spRegresaClinicasUsuario
    @id_USUARIO INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.id_CLINICA, c.nombre, ISNULL(c.activo, 1) AS activo
    FROM citas.USUARIO_CLINICA uc
    INNER JOIN citas.CLINICA c ON c.id_CLINICA = uc.id_CLINICA
    WHERE uc.id_USUARIO = @id_USUARIO
      AND ISNULL(c.activo, 1) = 1
    ORDER BY c.nombre;
END
GO

IF OBJECT_ID('citas.spAsignaUsuarioClinica','P') IS NOT NULL DROP PROCEDURE citas.spAsignaUsuarioClinica;
GO
CREATE PROCEDURE citas.spAsignaUsuarioClinica
    @id_USUARIO INT,
    @id_CLINICA INT,
    @id_usuario INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM citas.USUARIO_CLINICA WHERE id_USUARIO=@id_USUARIO AND id_CLINICA=@id_CLINICA)
        INSERT INTO citas.USUARIO_CLINICA (id_USUARIO, id_CLINICA) VALUES (@id_USUARIO, @id_CLINICA);
END
GO

IF OBJECT_ID('citas.spRemueveUsuarioClinica','P') IS NOT NULL DROP PROCEDURE citas.spRemueveUsuarioClinica;
GO
CREATE PROCEDURE citas.spRemueveUsuarioClinica
    @id_USUARIO INT,
    @id_CLINICA INT,
    @id_usuario INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM citas.USUARIO_CLINICA WHERE id_USUARIO=@id_USUARIO AND id_CLINICA=@id_CLINICA;
END
GO

GRANT EXECUTE ON citas.spRegresaClinicasUsuario TO app_user;
GRANT EXECUTE ON citas.spAsignaUsuarioClinica   TO app_user;
GRANT EXECUTE ON citas.spRemueveUsuarioClinica  TO app_user;
GO