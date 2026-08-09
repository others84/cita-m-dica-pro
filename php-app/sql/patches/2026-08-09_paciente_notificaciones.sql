-- Notificaciones por paciente: email y WhatsApp
USE CitasMedicas;
GO
IF COL_LENGTH('citas.PACIENTE','notifica_email') IS NULL
    ALTER TABLE citas.PACIENTE ADD notifica_email BIT NOT NULL CONSTRAINT DF_notifica_email_PACIENTE DEFAULT(0);
GO
IF COL_LENGTH('citas.PACIENTE','notifica_wa') IS NULL
    ALTER TABLE citas.PACIENTE ADD notifica_wa BIT NOT NULL CONSTRAINT DF_notifica_wa_PACIENTE DEFAULT(0);
GO

CREATE OR ALTER PROCEDURE citas.spAltaPaciente
    @id_CLINICA INT, @ap_paterno VARCHAR(80), @ap_materno VARCHAR(80), @nombre VARCHAR(120),
    @direccion VARCHAR(250), @telefono VARCHAR(20), @email VARCHAR(120),
    @fecha_nacimiento DATE, @id_CATALOGO_GENERO INT, @id_CATALOGO_MUNICIPIO INT,
    @observaciones VARCHAR(5000) = NULL,
    @notifica_email BIT = 0, @notifica_wa BIT = 0,
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.PACIENTE(id_CLINICA,ap_paterno,ap_materno,nombre,direccion,
                                        telefono,email,fecha_nacimiento,id_CATALOGO_GENERO,
                                        id_CATALOGO_MUNICIPIO,observaciones,notifica_email,notifica_wa,
                                        id_usuario_creacion,fecha_creacion)
            VALUES(@id_CLINICA,@ap_paterno,@ap_materno,@nombre,@direccion,@telefono,@email,
                   @fecha_nacimiento,@id_CATALOGO_GENERO,@id_CATALOGO_MUNICIPIO,@observaciones,
                   ISNULL(@notifica_email,0),ISNULL(@notifica_wa,0),@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Paciente id='+CONVERT(VARCHAR(20),@id_nuevo)
                   +' nombre='+@ap_paterno+' '+@ap_materno+' '+@nombre
                   +' notif_email='+CONVERT(VARCHAR(1),ISNULL(@notifica_email,0))
                   +' notif_wa='+CONVERT(VARCHAR(1),ISNULL(@notifica_wa,0));
            INSERT INTO citas.LOG VALUES('PACIENTE','spAltaPaciente','PACIENTE',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaPaciente: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('PACIENTE','spAltaPaciente','PACIENTE',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioPaciente
    @id_PACIENTE INT, @id_CLINICA INT,
    @ap_paterno VARCHAR(80), @ap_materno VARCHAR(80), @nombre VARCHAR(120),
    @direccion VARCHAR(250), @telefono VARCHAR(20), @email VARCHAR(120),
    @fecha_nacimiento DATE, @id_CATALOGO_GENERO INT, @id_CATALOGO_MUNICIPIO INT,
    @observaciones VARCHAR(5000) = NULL,
    @notifica_email BIT = 0, @notifica_wa BIT = 0,
    @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.PACIENTE
               SET id_CLINICA=@id_CLINICA, ap_paterno=@ap_paterno, ap_materno=@ap_materno,
                   nombre=@nombre, direccion=@direccion, telefono=@telefono, email=@email,
                   fecha_nacimiento=@fecha_nacimiento, id_CATALOGO_GENERO=@id_CATALOGO_GENERO,
                   id_CATALOGO_MUNICIPIO=@id_CATALOGO_MUNICIPIO, observaciones=@observaciones,
                   notifica_email=ISNULL(@notifica_email,0), notifica_wa=ISNULL(@notifica_wa,0),
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_PACIENTE=@id_PACIENTE;
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

CREATE OR ALTER PROCEDURE citas.spRegresaPacientes
    @id_CLINICA INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.id_PACIENTE, p.id_CLINICA, c.nombre AS clinica,
           p.ap_paterno, p.ap_materno, p.nombre, p.direccion, p.telefono, p.email,
           p.fecha_nacimiento, p.id_CATALOGO_GENERO, g.nombre AS genero,
           p.id_CATALOGO_MUNICIPIO, m.nombre AS municipio,
           p.observaciones, p.notifica_email, p.notifica_wa,
           m.id_CATALOGO_ESTADOS, e.nombre AS estado,
           e.id_CATALOGO_PAIS, pa.nombre AS pais
      FROM citas.PACIENTE p
      JOIN citas.CLINICA           c  ON c.id_CLINICA            = p.id_CLINICA
      JOIN citas.CATALOGO_GENERO   g  ON g.id_CATALOGO_GENERO    = p.id_CATALOGO_GENERO
      JOIN citas.CATALOGO_MUNICIPIO m ON m.id_CATALOGO_MUNICIPIO = p.id_CATALOGO_MUNICIPIO
      JOIN citas.CATALOGO_ESTADOS  e  ON e.id_CATALOGO_ESTADOS   = m.id_CATALOGO_ESTADOS
      JOIN citas.CATALOGO_PAIS     pa ON pa.id_CATALOGO_PAIS     = e.id_CATALOGO_PAIS
     WHERE (@id_CLINICA IS NULL OR p.id_CLINICA = @id_CLINICA)
     ORDER BY p.ap_paterno, p.ap_materno, p.nombre;
END
GO
