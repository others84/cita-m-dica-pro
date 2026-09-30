/* =====================================================================
   Citas en espera: la cita puede marcarse "en espera de un espacio
   anterior". La marca se conserva al adelantar la cita y solo se quita
   al cancelarla, atenderla o marcarla como "No asistio".
   ===================================================================== */
USE CitasMedicas;
GO

IF COL_LENGTH('citas.CITA', 'en_espera') IS NULL
    ALTER TABLE citas.CITA ADD en_espera BIT NOT NULL CONSTRAINT DF_CITA_en_espera DEFAULT (0);
GO
IF COL_LENGTH('citas.CITA', 'fecha_en_espera') IS NULL
    ALTER TABLE citas.CITA ADD fecha_en_espera DATETIME NULL;
GO

/* Marca o desmarca la cita. Al volver a marcar conserva la fecha original
   (prioridad de quien lo pidio primero). */
CREATE OR ALTER PROCEDURE citas.spMarcaCitaEspera
    @id_CITA INT, @en_espera BIT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DECLARE @antes BIT;
            SELECT @antes = en_espera FROM citas.CITA WHERE id_CITA = @id_CITA;
            UPDATE citas.CITA
               SET en_espera = @en_espera,
                   fecha_en_espera = CASE WHEN @en_espera = 1 THEN ISNULL(fecha_en_espera, GETDATE()) ELSE NULL END
             WHERE id_CITA = @id_CITA;
            IF ISNULL(@antes, 0) <> @en_espera
            BEGIN
                DECLARE @msg VARCHAR(2000);
                SET @msg = 'Cita en espera id=' + CONVERT(VARCHAR(20), @id_CITA)
                         + ' valor=' + CONVERT(VARCHAR(1), @en_espera);
                INSERT INTO citas.LOG VALUES('CITA','spMarcaCitaEspera','CITA',@msg,GETDATE(),@id_usuario);
            END
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err = 'ERROR spMarcaCitaEspera: ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CITA','spMarcaCitaEspera','CITA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

/* Citas marcadas en espera (id y fecha en que se marcaron). */
CREATE OR ALTER PROCEDURE citas.spRegresaCitasEspera
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_CITA, fecha_en_espera
      FROM citas.CITA
     WHERE en_espera = 1;
END
GO
