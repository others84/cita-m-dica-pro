-- Defensa en profundidad (IDOR) a nivel base de datos.
-- Se agrega el parametro opcional @id_CLINICA_esperada a los SP de cambio/baja.
-- Si viene NULL, el SP se comporta exactamente igual que antes (compatibilidad).
-- Si viene con valor y NO coincide con la clinica actual del registro, se aborta.
USE CitasMedicas;
GO

-- ---------------------------------------------------------------- PACIENTE
CREATE OR ALTER PROCEDURE citas.spCambioPaciente
    @id_PACIENTE INT, @id_CLINICA INT,
    @ap_paterno VARCHAR(80), @ap_materno VARCHAR(80), @nombre VARCHAR(120),
    @direccion VARCHAR(250), @telefono VARCHAR(20), @email VARCHAR(120),
    @fecha_nacimiento DATE, @id_CATALOGO_GENERO INT, @id_CATALOGO_MUNICIPIO INT,
    @observaciones VARCHAR(5000) = NULL,
    @notifica_email BIT = 0, @notifica_wa BIT = 0,
    @id_usuario TINYINT,
    @id_CLINICA_esperada INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @cli_actual INT;
        SELECT @cli_actual = id_CLINICA FROM citas.PACIENTE WHERE id_PACIENTE=@id_PACIENTE;
        IF @cli_actual IS NULL
        BEGIN
            RAISERROR('El paciente no existe.',16,1); RETURN;
        END
        IF @id_CLINICA_esperada IS NOT NULL AND @cli_actual <> @id_CLINICA_esperada
        BEGIN
            DECLARE @den VARCHAR(2000);
            SET @den='ACCESO DENEGADO spCambioPaciente id_PACIENTE='+CONVERT(VARCHAR(20),@id_PACIENTE)
                    +' clinica_real='+CONVERT(VARCHAR(20),@cli_actual)
                    +' clinica_esperada='+CONVERT(VARCHAR(20),@id_CLINICA_esperada);
            INSERT INTO citas.LOG VALUES('PACIENTE','spCambioPaciente','PACIENTE',@den,GETDATE(),ISNULL(@id_usuario,0));
            RAISERROR('No tiene permiso para modificar ese paciente.',16,1); RETURN;
        END
        BEGIN TRAN;
            UPDATE citas.PACIENTE
               SET id_CLINICA=@id_CLINICA, ap_paterno=@ap_paterno, ap_materno=@ap_materno,
                   nombre=@nombre, direccion=@direccion, telefono=@telefono, email=@email,
                   fecha_nacimiento=@fecha_nacimiento, id_CATALOGO_GENERO=@id_CATALOGO_GENERO,
                   id_CATALOGO_MUNICIPIO=@id_CATALOGO_MUNICIPIO, observaciones=@observaciones,
                   notifica_email=ISNULL(@notifica_email,0), notifica_wa=ISNULL(@notifica_wa,0),
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_PACIENTE=@id_PACIENTE
               AND (@id_CLINICA_esperada IS NULL OR id_CLINICA=@id_CLINICA_esperada);
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Paciente id='+CONVERT(VARCHAR(20),@id_PACIENTE)
                   +' notif_email='+CONVERT(VARCHAR(1),ISNULL(@notifica_email,0))
                   +' notif_wa='+CONVERT(VARCHAR(1),ISNULL(@notifica_wa,0));
            INSERT INTO citas.LOG VALUES('PACIENTE','spCambioPaciente','PACIENTE',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioPaciente: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('PACIENTE','spCambioPaciente','PACIENTE',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaPaciente
    @id_PACIENTE INT, @id_usuario TINYINT, @id_CLINICA_esperada INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @cli_actual INT;
        SELECT @cli_actual = id_CLINICA FROM citas.PACIENTE WHERE id_PACIENTE=@id_PACIENTE;
        IF @cli_actual IS NULL
        BEGIN
            RAISERROR('El paciente no existe.',16,1); RETURN;
        END
        IF @id_CLINICA_esperada IS NOT NULL AND @cli_actual <> @id_CLINICA_esperada
        BEGIN
            DECLARE @den VARCHAR(2000);
            SET @den='ACCESO DENEGADO spBajaPaciente id_PACIENTE='+CONVERT(VARCHAR(20),@id_PACIENTE)
                    +' clinica_real='+CONVERT(VARCHAR(20),@cli_actual)
                    +' clinica_esperada='+CONVERT(VARCHAR(20),@id_CLINICA_esperada);
            INSERT INTO citas.LOG VALUES('PACIENTE','spBajaPaciente','PACIENTE',@den,GETDATE(),ISNULL(@id_usuario,0));
            RAISERROR('No tiene permiso para eliminar ese paciente.',16,1); RETURN;
        END
        BEGIN TRAN;
            DELETE FROM citas.PACIENTE
             WHERE id_PACIENTE=@id_PACIENTE
               AND (@id_CLINICA_esperada IS NULL OR id_CLINICA=@id_CLINICA_esperada);
            DECLARE @msg VARCHAR(2000);
            SET @msg='Baja Paciente id='+CONVERT(VARCHAR(20),@id_PACIENTE);
            INSERT INTO citas.LOG VALUES('PACIENTE','spBajaPaciente','PACIENTE',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaPaciente: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('PACIENTE','spBajaPaciente','PACIENTE',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

-- ------------------------------------------------------------- CONSULTORIO
CREATE OR ALTER PROCEDURE citas.spCambioConsultorio
    @id_CONSULTORIO INT, @id_CLINICA INT, @nombre VARCHAR(80), @id_usuario TINYINT,
    @id_CLINICA_esperada INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @cli_actual INT;
        SELECT @cli_actual = id_CLINICA FROM citas.CLINICA_CONSULTORIO WHERE id_CONSULTORIO=@id_CONSULTORIO;
        IF @id_CLINICA_esperada IS NOT NULL AND ISNULL(@cli_actual,-1) <> @id_CLINICA_esperada
        BEGIN
            DECLARE @den VARCHAR(2000);
            SET @den='ACCESO DENEGADO spCambioConsultorio id_CONSULTORIO='+CONVERT(VARCHAR(20),@id_CONSULTORIO)
                    +' clinica_real='+ISNULL(CONVERT(VARCHAR(20),@cli_actual),'NULL')
                    +' clinica_esperada='+CONVERT(VARCHAR(20),@id_CLINICA_esperada);
            INSERT INTO citas.LOG VALUES('CONSULTORIO','spCambioConsultorio','CONSULTORIO',@den,GETDATE(),ISNULL(@id_usuario,0));
            RAISERROR('No tiene permiso para modificar ese consultorio.',16,1); RETURN;
        END
        BEGIN TRAN;
            UPDATE citas.CONSULTORIO
               SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CONSULTORIO=@id_CONSULTORIO;
            IF EXISTS(SELECT 1 FROM citas.CLINICA_CONSULTORIO WHERE id_CONSULTORIO=@id_CONSULTORIO)
                UPDATE citas.CLINICA_CONSULTORIO
                   SET id_CLINICA=@id_CLINICA, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
                 WHERE id_CONSULTORIO=@id_CONSULTORIO;
            ELSE
                INSERT INTO citas.CLINICA_CONSULTORIO(id_CLINICA,id_CONSULTORIO,id_usuario_creacion,fecha_creacion)
                VALUES(@id_CLINICA,@id_CONSULTORIO,@id_usuario,GETDATE());
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Consultorio id='+CONVERT(VARCHAR(20),@id_CONSULTORIO);
            INSERT INTO citas.LOG VALUES('CONSULTORIO','spCambioConsultorio','CONSULTORIO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioConsultorio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CONSULTORIO','spCambioConsultorio','CONSULTORIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaConsultorio
    @id_CONSULTORIO INT, @id_usuario TINYINT, @id_CLINICA_esperada INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @cli_actual INT;
        SELECT @cli_actual = id_CLINICA FROM citas.CLINICA_CONSULTORIO WHERE id_CONSULTORIO=@id_CONSULTORIO;
        IF @id_CLINICA_esperada IS NOT NULL AND ISNULL(@cli_actual,-1) <> @id_CLINICA_esperada
        BEGIN
            DECLARE @den VARCHAR(2000);
            SET @den='ACCESO DENEGADO spBajaConsultorio id_CONSULTORIO='+CONVERT(VARCHAR(20),@id_CONSULTORIO)
                    +' clinica_real='+ISNULL(CONVERT(VARCHAR(20),@cli_actual),'NULL')
                    +' clinica_esperada='+CONVERT(VARCHAR(20),@id_CLINICA_esperada);
            INSERT INTO citas.LOG VALUES('CONSULTORIO','spBajaConsultorio','CONSULTORIO',@den,GETDATE(),ISNULL(@id_usuario,0));
            RAISERROR('No tiene permiso para eliminar ese consultorio.',16,1); RETURN;
        END
        BEGIN TRAN;
            DELETE FROM citas.CLINICA_CONSULTORIO WHERE id_CONSULTORIO=@id_CONSULTORIO;
            DELETE FROM citas.CONSULTORIO WHERE id_CONSULTORIO=@id_CONSULTORIO;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Baja Consultorio id='+CONVERT(VARCHAR(20),@id_CONSULTORIO);
            INSERT INTO citas.LOG VALUES('CONSULTORIO','spBajaConsultorio','CONSULTORIO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaConsultorio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CONSULTORIO','spBajaConsultorio','CONSULTORIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

-- ------------------------------------------------------------ ESPECIALIDAD
CREATE OR ALTER PROCEDURE citas.spCambioEspecialidad
    @id_CATALOGO_ESPECIALIDAD INT, @nombre VARCHAR(120), @id_CLINICA INT, @id_usuario TINYINT,
    @id_CLINICA_esperada INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @cli_actual INT;
        SELECT @cli_actual = id_CLINICA FROM citas.CATALOGO_ESPECIALIDAD
         WHERE id_CATALOGO_ESPECIALIDAD=@id_CATALOGO_ESPECIALIDAD;
        IF @cli_actual IS NULL
        BEGIN
            RAISERROR('La especialidad no existe.',16,1); RETURN;
        END
        IF @id_CLINICA_esperada IS NOT NULL AND @cli_actual <> @id_CLINICA_esperada
        BEGIN
            DECLARE @den VARCHAR(2000);
            SET @den='ACCESO DENEGADO spCambioEspecialidad id='+CONVERT(VARCHAR(20),@id_CATALOGO_ESPECIALIDAD)
                    +' clinica_real='+CONVERT(VARCHAR(20),@cli_actual)
                    +' clinica_esperada='+CONVERT(VARCHAR(20),@id_CLINICA_esperada);
            INSERT INTO citas.LOG VALUES('CATALOGO_ESPECIALIDAD','spCambioEspecialidad','CATALOGO_ESPECIALIDAD',@den,GETDATE(),ISNULL(@id_usuario,0));
            RAISERROR('No tiene permiso para modificar esa especialidad.',16,1); RETURN;
        END
        BEGIN TRAN;
            UPDATE citas.CATALOGO_ESPECIALIDAD
               SET nombre=@nombre, id_CLINICA=@id_CLINICA,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CATALOGO_ESPECIALIDAD=@id_CATALOGO_ESPECIALIDAD
               AND (@id_CLINICA_esperada IS NULL OR id_CLINICA=@id_CLINICA_esperada);
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Especialidad id='+CONVERT(VARCHAR(20),@id_CATALOGO_ESPECIALIDAD);
            INSERT INTO citas.LOG VALUES('CATALOGO_ESPECIALIDAD','spCambioEspecialidad','CATALOGO_ESPECIALIDAD',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioEspecialidad: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_ESPECIALIDAD','spCambioEspecialidad','CATALOGO_ESPECIALIDAD',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO
