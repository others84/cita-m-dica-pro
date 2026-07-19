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
    SELECT uc.id_USUARIOS_CLINICA, c.id_CLINICA, c.nombre, ISNULL(c.activo, 1) AS activo
    FROM citas.USUARIOS_CLINICA uc
    INNER JOIN citas.CLINICA c ON c.id_CLINICA = uc.id_CLINICA
    WHERE uc.id_USUARIOS = @id_USUARIO
      AND ISNULL(c.activo, 1) = 1
    ORDER BY c.nombre;
END
GO

-- Alta / baja de asignacion usuario-clinica.
-- Usa los SPs oficiales citas.spAltaUsuarioClinica y citas.spBajaUsuarioClinica
-- que ya viven en schema.sql. Se recrean aqui con CREATE OR ALTER para
-- garantizar que existen despues de aplicar este patch.
GO
CREATE OR ALTER PROCEDURE citas.spAltaUsuarioClinica
    @id_USUARIOS INT, @id_CLINICA INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.USUARIOS_CLINICA(id_USUARIOS,id_CLINICA,id_usuario_creacion,fecha_creacion)
            VALUES(@id_USUARIOS,@id_CLINICA,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta UsuarioClinica id='+CONVERT(VARCHAR(20),@id_nuevo)
                   +' usuario='+CONVERT(VARCHAR(20),@id_USUARIOS)
                   +' clinica='+CONVERT(VARCHAR(20),@id_CLINICA);
            INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spAltaUsuarioClinica','USUARIOS_CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaUsuarioClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spAltaUsuarioClinica','USUARIOS_CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaUsuarioClinica
    @id_USUARIOS_CLINICA INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DELETE FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS_CLINICA=@id_USUARIOS_CLINICA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Baja UsuarioClinica id='+CONVERT(VARCHAR(20),@id_USUARIOS_CLINICA);
            INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spBajaUsuarioClinica','USUARIOS_CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaUsuarioClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spBajaUsuarioClinica','USUARIOS_CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

GRANT EXECUTE ON citas.spRegresaClinicasUsuario TO app_user;
GRANT EXECUTE ON citas.spAltaUsuarioClinica     TO app_user;
GRANT EXECUTE ON citas.spBajaUsuarioClinica     TO app_user;
GO