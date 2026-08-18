/* ============================================================
   Parche: pagina publica "Generar cita"
   - citas.spLogEvento: registro libre en citas.LOG
   ============================================================ */
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spLogEvento
    @modulo        VARCHAR(60),
    @procedimiento VARCHAR(60),
    @tabla         VARCHAR(60),
    @evento        VARCHAR(2000),
    @id_usuario    TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES(@modulo, @procedimiento, @tabla, @evento, GETDATE(), @id_usuario);
    END TRY
    BEGIN CATCH
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('SISTEMA', 'spLogEvento', 'LOG',
               'ERROR spLogEvento: ' + ERROR_MESSAGE(), GETDATE(), ISNULL(@id_usuario, 0));
    END CATCH
END
GO

GRANT EXECUTE ON OBJECT::citas.spLogEvento TO citasadmin;
GO
