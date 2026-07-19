-- Patch: acceso multi-clinica por usuario (tabla USUARIOS_CLINICA)
-- Aplicar en la base CitasMedicas con el usuario dbo.
USE CitasMedicas;
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables t JOIN sys.schemas s ON s.schema_id=t.schema_id
               WHERE s.name='citas' AND t.name='USUARIOS_CLINICA')
BEGIN
    CREATE TABLE citas.USUARIOS_CLINICA (
        id_USUARIOS_CLINICA INT IDENTITY(1,1) NOT NULL,
        id_USUARIOS INT NOT NULL,
        id_CLINICA INT NOT NULL,
        id_usuario_creacion TINYINT NOT NULL,
        fecha_creacion SMALLDATETIME NOT NULL CONSTRAINT DF_UC_fcrea DEFAULT (GETDATE()),
        id_usuario_modificacion TINYINT NULL,
        fecha_modificacion SMALLDATETIME NULL,
        CONSTRAINT PK_id_USUARIOS_CLINICA PRIMARY KEY CLUSTERED (id_USUARIOS_CLINICA),
        CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_USUARIOS_CLINICA
            FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA),
        CONSTRAINT FK_id_USUARIOS_USUARIOS_id_USUARIOS_USUARIOS_CLINICA
            FOREIGN KEY (id_USUARIOS) REFERENCES citas.USUARIOS(id_USUARIOS)
    );
END
GO

-- Semilla: copia la asignacion existente de USUARIOS.id_CLINICA
INSERT INTO citas.USUARIOS_CLINICA (id_USUARIOS, id_CLINICA, id_usuario_creacion, fecha_creacion)
SELECT u.id_USUARIOS, u.id_CLINICA, 1, GETDATE()
FROM citas.USUARIOS u
WHERE u.id_CLINICA IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM citas.USUARIOS_CLINICA uc
      WHERE uc.id_USUARIOS = u.id_USUARIOS AND uc.id_CLINICA = u.id_CLINICA
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
    FROM citas.USUARIOS_CLINICA uc
    INNER JOIN citas.CLINICA c ON c.id_CLINICA = uc.id_CLINICA
    WHERE uc.id_USUARIOS = @id_USUARIO
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
    IF NOT EXISTS (SELECT 1 FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS=@id_USUARIO AND id_CLINICA=@id_CLINICA)
        INSERT INTO citas.USUARIOS_CLINICA (id_USUARIOS, id_CLINICA, id_usuario_creacion, fecha_creacion)
        VALUES (@id_USUARIO, @id_CLINICA, ISNULL(@id_usuario,1), GETDATE());
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
    DELETE FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS=@id_USUARIO AND id_CLINICA=@id_CLINICA;
END
GO

GRANT EXECUTE ON citas.spRegresaClinicasUsuario TO app_user;
GRANT EXECUTE ON citas.spAsignaUsuarioClinica   TO app_user;
GRANT EXECUTE ON citas.spRemueveUsuarioClinica  TO app_user;
GO