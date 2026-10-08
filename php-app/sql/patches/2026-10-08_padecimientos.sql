/* =====================================================================
   Catalogo de padecimientos por medico (con precio) y padecimientos
   elegidos en cada cita. El padecimiento solo depende del medico.
   CITA.precio sigue siendo el total final (editable).
   ===================================================================== */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.PADECIMIENTO','U') IS NULL
BEGIN
    CREATE TABLE citas.PADECIMIENTO (
        id_PADECIMIENTO   INT IDENTITY(1,1) NOT NULL,
        id_MEDICO         INT               NOT NULL,
        nombre            VARCHAR(150)      NOT NULL,
        precio            DECIMAL(10,2)     NOT NULL CONSTRAINT DF_PADECIMIENTO_precio DEFAULT 0,
        activo            BIT               NOT NULL CONSTRAINT DF_PADECIMIENTO_activo DEFAULT 1,
        id_usuario        TINYINT           NOT NULL,
        fecha_actualizacion DATETIME        NOT NULL CONSTRAINT DF_PADECIMIENTO_fecha DEFAULT GETDATE(),
        CONSTRAINT PK_id_PADECIMIENTO PRIMARY KEY (id_PADECIMIENTO),
        CONSTRAINT FK_PADECIMIENTO_id_MEDICO_USUARIOS
            FOREIGN KEY (id_MEDICO) REFERENCES citas.USUARIOS(id_USUARIOS)
    );
    CREATE UNIQUE INDEX IX_PADECIMIENTO_medico_nombre ON citas.PADECIMIENTO(id_MEDICO, nombre);
END
GO

IF OBJECT_ID('citas.CITA_PADECIMIENTO','U') IS NULL
BEGIN
    CREATE TABLE citas.CITA_PADECIMIENTO (
        id_CITA          INT           NOT NULL,
        id_PADECIMIENTO  INT           NOT NULL,
        precio           DECIMAL(10,2) NOT NULL,
        CONSTRAINT PK_CITA_PADECIMIENTO PRIMARY KEY (id_CITA, id_PADECIMIENTO),
        CONSTRAINT FK_CITA_PADECIMIENTO_CITA
            FOREIGN KEY (id_CITA) REFERENCES citas.CITA(id_CITA) ON DELETE CASCADE,
        CONSTRAINT FK_CITA_PADECIMIENTO_PADECIMIENTO
            FOREIGN KEY (id_PADECIMIENTO) REFERENCES citas.PADECIMIENTO(id_PADECIMIENTO)
    );
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaPadecimientos
    @id_MEDICO INT, @solo_activos BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_PADECIMIENTO, id_MEDICO, nombre, precio, activo
      FROM citas.PADECIMIENTO
     WHERE id_MEDICO = @id_MEDICO AND (@solo_activos = 0 OR activo = 1)
     ORDER BY activo DESC, nombre;
END
GO

CREATE OR ALTER PROCEDURE citas.spAltaPadecimiento
    @id_MEDICO INT, @nombre VARCHAR(150), @precio DECIMAL(10,2), @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO citas.PADECIMIENTO(id_MEDICO, nombre, precio, activo, id_usuario, fecha_actualizacion)
        VALUES(@id_MEDICO, LTRIM(RTRIM(@nombre)), @precio, 1, @id_usuario, GETDATE());
        SET @id_nuevo = SCOPE_IDENTITY();
        INSERT INTO citas.LOG VALUES('PADECIMIENTO','spAltaPadecimiento','PADECIMIENTO',
            'Alta padecimiento id=' + CONVERT(VARCHAR(20),@id_nuevo) + ' medico=' + CONVERT(VARCHAR(20),@id_MEDICO)
            + ' nombre=' + @nombre + ' precio=' + CONVERT(VARCHAR(20),@precio), GETDATE(), @id_usuario);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000) = 'ERROR spAltaPadecimiento: ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('PADECIMIENTO','spAltaPadecimiento','PADECIMIENTO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioPadecimiento
    @id_PADECIMIENTO INT, @nombre VARCHAR(150), @precio DECIMAL(10,2), @activo BIT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE citas.PADECIMIENTO
           SET nombre = LTRIM(RTRIM(@nombre)), precio = @precio, activo = @activo,
               id_usuario = @id_usuario, fecha_actualizacion = GETDATE()
         WHERE id_PADECIMIENTO = @id_PADECIMIENTO;
        INSERT INTO citas.LOG VALUES('PADECIMIENTO','spCambioPadecimiento','PADECIMIENTO',
            'Cambio padecimiento id=' + CONVERT(VARCHAR(20),@id_PADECIMIENTO) + ' nombre=' + @nombre
            + ' precio=' + CONVERT(VARCHAR(20),@precio) + ' activo=' + CONVERT(VARCHAR(1),@activo), GETDATE(), @id_usuario);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000) = 'ERROR spCambioPadecimiento: ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('PADECIMIENTO','spCambioPadecimiento','PADECIMIENTO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

/* Reemplaza los padecimientos de una cita. @ids = lista separada por comas.
   Solo acepta padecimientos del mismo medico de la cita; guarda el precio vigente. */
CREATE OR ALTER PROCEDURE citas.spGuardaPadecimientosCita
    @id_CITA INT, @ids VARCHAR(2000), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DECLARE @med INT = (SELECT id_MEDICO FROM citas.CITA WHERE id_CITA = @id_CITA);
            DECLARE @sel TABLE(id INT PRIMARY KEY);
            INSERT INTO @sel(id)
                SELECT DISTINCT TRY_CONVERT(INT, value) FROM STRING_SPLIT(ISNULL(@ids,''), ',')
                 WHERE TRY_CONVERT(INT, value) IS NOT NULL;
            DELETE cp FROM citas.CITA_PADECIMIENTO cp
             WHERE cp.id_CITA = @id_CITA AND cp.id_PADECIMIENTO NOT IN (SELECT id FROM @sel);
            INSERT INTO citas.CITA_PADECIMIENTO(id_CITA, id_PADECIMIENTO, precio)
                SELECT @id_CITA, p.id_PADECIMIENTO, p.precio
                  FROM citas.PADECIMIENTO p JOIN @sel s ON s.id = p.id_PADECIMIENTO
                 WHERE p.id_MEDICO = @med
                   AND NOT EXISTS (SELECT 1 FROM citas.CITA_PADECIMIENTO x
                                    WHERE x.id_CITA = @id_CITA AND x.id_PADECIMIENTO = p.id_PADECIMIENTO);
            INSERT INTO citas.LOG VALUES('CITA','spGuardaPadecimientosCita','CITA_PADECIMIENTO',
                'Padecimientos cita id=' + CONVERT(VARCHAR(20),@id_CITA) + ' ids=' + ISNULL(@ids,''), GETDATE(), @id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        DECLARE @err VARCHAR(2000) = 'ERROR spGuardaPadecimientosCita: ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CITA','spGuardaPadecimientosCita','CITA_PADECIMIENTO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaPadecimientosCita
    @id_CITA INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT cp.id_PADECIMIENTO, p.nombre, cp.precio
      FROM citas.CITA_PADECIMIENTO cp JOIN citas.PADECIMIENTO p ON p.id_PADECIMIENTO = cp.id_PADECIMIENTO
     WHERE cp.id_CITA = @id_CITA
     ORDER BY p.nombre;
END
GO

/* Texto "A, B, C" por cita (para listados). */
CREATE OR ALTER PROCEDURE citas.spRegresaPadecimientosCitas
    @id_MEDICO INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT cp.id_CITA, STRING_AGG(p.nombre, ', ') WITHIN GROUP (ORDER BY p.nombre) AS padecimientos
      FROM citas.CITA_PADECIMIENTO cp
      JOIN citas.PADECIMIENTO p ON p.id_PADECIMIENTO = cp.id_PADECIMIENTO
     WHERE @id_MEDICO IS NULL OR p.id_MEDICO = @id_MEDICO
     GROUP BY cp.id_CITA;
END
GO
