/* ============================================================
   Parche: centro de ayuda - registro de bienvenida vista
   Ejecutar en CitasMedicas y en citasMedicasDEMO (cambiar USE).
   ============================================================ */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.USUARIO_BIENVENIDA') IS NULL
BEGIN
    CREATE TABLE citas.USUARIO_BIENVENIDA(
        id_USUARIOS INT NOT NULL PRIMARY KEY,
        fecha_vista DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

CREATE OR ALTER PROCEDURE citas.spBienvenidaVista
    @id_USUARIOS INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CASE WHEN EXISTS(SELECT 1 FROM citas.USUARIO_BIENVENIDA WHERE id_USUARIOS=@id_USUARIOS)
                THEN 1 ELSE 0 END AS vista;
END
GO

CREATE OR ALTER PROCEDURE citas.spMarcarBienvenidaVista
    @id_USUARIOS INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS(SELECT 1 FROM citas.USUARIO_BIENVENIDA WHERE id_USUARIOS=@id_USUARIOS)
        INSERT INTO citas.USUARIO_BIENVENIDA(id_USUARIOS) VALUES(@id_USUARIOS);
END
GO
