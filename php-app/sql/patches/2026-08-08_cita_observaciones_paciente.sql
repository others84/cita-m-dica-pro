/* Parche: campo observaciones_paciente editable desde cita y visible en tabla de citas. */
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spCambioObservacionesPaciente
    @id_PACIENTE INT, @observaciones VARCHAR(500), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.PACIENTE
               SET observaciones=@observaciones,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_PACIENTE=@id_PACIENTE;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio observaciones paciente id='+CONVERT(VARCHAR(20),@id_PACIENTE);
            INSERT INTO citas.LOG VALUES('PACIENTE','spCambioObservacionesPaciente','PACIENTE',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioObservacionesPaciente: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('PACIENTE','spCambioObservacionesPaciente','PACIENTE',@err,GETDATE(),ISNULL(@id_usuario,0));
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
            ci.observaciones, ci.notifica_email, ci.notifica_wa,
            ci.email_notif, ci.celular_notif, ci.horas_anticipacion_notif, ci.precio,
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
