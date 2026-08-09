-- =====================================================================
-- Elimina de citas.CITA los campos de notificacion:
--   notifica_email, notifica_wa, email_notif, celular_notif
-- Esa informacion ahora vive unicamente en citas.PACIENTE.
-- spRegresaCitas sigue exponiendo esos alias, pero derivados del PACIENTE.
-- =====================================================================
USE CitasMedicas;
GO

/* ---------- 1) SPs sin dependencia de las columnas ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaCita
    @id_PACIENTE INT, @fecha_cita DATE, @hora_inicio TIME(0), @hora_fin TIME(0),
    @id_CATALOGO_ESTADO_CITAS INT, @observaciones VARCHAR(500),
    @horas_anticipacion_notif TINYINT, @precio DECIMAL(10,2),
    @id_MEDICO INT, @id_CATALOGO_ESPECIALIDAD INT, @id_CONSULTORIO INT,
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CITA(id_PACIENTE,fecha_cita,hora_inicio,hora_fin,
                                    id_CATALOGO_ESTADO_CITAS,observaciones,
                                    horas_anticipacion_notif,precio,
                                    id_MEDICO,id_CATALOGO_ESPECIALIDAD,id_CONSULTORIO,
                                    id_usuario_creacion,fecha_creacion)
            VALUES(@id_PACIENTE,@fecha_cita,@hora_inicio,@hora_fin,
                   @id_CATALOGO_ESTADO_CITAS,@observaciones,
                   @horas_anticipacion_notif,@precio,
                   @id_MEDICO,@id_CATALOGO_ESPECIALIDAD,@id_CONSULTORIO,
                   @id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Cita id='+CONVERT(VARCHAR(20),@id_nuevo)
                   +' paciente='+CONVERT(VARCHAR(20),@id_PACIENTE)
                   +' fecha='+CONVERT(VARCHAR(10),@fecha_cita,120);
            INSERT INTO citas.LOG VALUES('CITA','spAltaCita','CITA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaCita: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CITA','spAltaCita','CITA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioCita
    @id_CITA INT, @id_PACIENTE INT, @fecha_cita DATE,
    @hora_inicio TIME(0), @hora_fin TIME(0),
    @id_CATALOGO_ESTADO_CITAS INT, @observaciones VARCHAR(500),
    @horas_anticipacion_notif TINYINT, @precio DECIMAL(10,2),
    @id_MEDICO INT, @id_CATALOGO_ESPECIALIDAD INT, @id_CONSULTORIO INT,
    @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CITA
               SET id_PACIENTE=@id_PACIENTE, fecha_cita=@fecha_cita,
                   hora_inicio=@hora_inicio, hora_fin=@hora_fin,
                   id_CATALOGO_ESTADO_CITAS=@id_CATALOGO_ESTADO_CITAS,
                   observaciones=@observaciones,
                   horas_anticipacion_notif=@horas_anticipacion_notif,
                   precio=@precio, id_MEDICO=@id_MEDICO,
                   id_CATALOGO_ESPECIALIDAD=@id_CATALOGO_ESPECIALIDAD,
                   id_CONSULTORIO=@id_CONSULTORIO,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CITA=@id_CITA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Cita id='+CONVERT(VARCHAR(20),@id_CITA);
            INSERT INTO citas.LOG VALUES('CITA','spCambioCita','CITA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioCita: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CITA','spCambioCita','CITA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaCitas
    @id_MEDICO INT = NULL, @id_CLINICA INT = NULL,
    @fecha_desde DATE = NULL, @fecha_hasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  ci.id_CITA, ci.fecha_cita, ci.hora_inicio, ci.hora_fin,
            ci.observaciones,
            p.notifica_email, p.notifica_wa,
            p.email AS email_notif, p.telefono AS celular_notif,
            ci.horas_anticipacion_notif, ci.precio,
            ci.notificado,
            ci.id_PACIENTE,
            (p.ap_paterno + ' ' + p.ap_materno + ' ' + p.nombre) AS paciente,
            p.observaciones AS observaciones_paciente,
            p.id_CLINICA, cl.nombre AS clinica,
            ci.id_MEDICO, u.nombre_completo AS medico,
            ci.id_CATALOGO_ESPECIALIDAD, es.nombre AS especialidad,
            ci.id_CONSULTORIO, co.nombre AS consultorio,
            ci.id_CATALOGO_ESTADO_CITAS, ec.nombre AS estado
      FROM citas.CITA ci
      JOIN citas.PACIENTE              p  ON p.id_PACIENTE              = ci.id_PACIENTE
      JOIN citas.CLINICA               cl ON cl.id_CLINICA              = p.id_CLINICA
      JOIN citas.USUARIOS              u  ON u.id_USUARIOS              = ci.id_MEDICO
      JOIN citas.CATALOGO_ESPECIALIDAD es ON es.id_CATALOGO_ESPECIALIDAD= ci.id_CATALOGO_ESPECIALIDAD
      JOIN citas.CONSULTORIO           co ON co.id_CONSULTORIO          = ci.id_CONSULTORIO
      JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_CATALOGO_ESTADO_CITAS= ci.id_CATALOGO_ESTADO_CITAS
     WHERE (@id_MEDICO    IS NULL OR ci.id_MEDICO  = @id_MEDICO)
       AND (@id_CLINICA   IS NULL OR p.id_CLINICA  = @id_CLINICA)
       AND (@fecha_desde  IS NULL OR ci.fecha_cita >= @fecha_desde)
       AND (@fecha_hasta  IS NULL OR ci.fecha_cita <= @fecha_hasta)
     ORDER BY ci.fecha_cita, ci.hora_inicio;
END
GO

/* ---------- 2) Se eliminan constraints y columnas ---------- */
IF OBJECT_ID('citas.CHK_notifica_email_CITA','C') IS NOT NULL
    ALTER TABLE citas.CITA DROP CONSTRAINT CHK_notifica_email_CITA;
IF OBJECT_ID('citas.CHK_notifica_wa_CITA','C') IS NOT NULL
    ALTER TABLE citas.CITA DROP CONSTRAINT CHK_notifica_wa_CITA;
GO

DECLARE @col SYSNAME, @sql NVARCHAR(500);
DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT c.name
      FROM sys.columns c
     WHERE c.object_id = OBJECT_ID('citas.CITA')
       AND c.name IN ('notifica_email','notifica_wa','email_notif','celular_notif');
OPEN cur;
FETCH NEXT FROM cur INTO @col;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- quita defaults asociados a la columna
    SELECT @sql = 'ALTER TABLE citas.CITA DROP CONSTRAINT ' + QUOTENAME(dc.name)
      FROM sys.default_constraints dc
      JOIN sys.columns c ON c.object_id = dc.parent_object_id AND c.column_id = dc.parent_column_id
     WHERE dc.parent_object_id = OBJECT_ID('citas.CITA') AND c.name = @col;
    IF @sql IS NOT NULL EXEC sp_executesql @sql;
    SET @sql = NULL;

    SET @sql = 'ALTER TABLE citas.CITA DROP COLUMN ' + QUOTENAME(@col);
    EXEC sp_executesql @sql;
    FETCH NEXT FROM cur INTO @col;
END
CLOSE cur;
DEALLOCATE cur;
GO

GRANT EXECUTE ON OBJECT::citas.spAltaCita     TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spCambioCita   TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spRegresaCitas TO citasadmin;
GO
