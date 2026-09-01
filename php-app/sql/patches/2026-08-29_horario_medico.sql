/* ============================================================
   Parche: horario de atencion por medico
   - citas.HORARIO_MEDICO
   - citas.spRegresaHorarioMedico
   - citas.spGuardaHorarioMedico
   Los horarios SOLO limitan el agendado desde la pagina publica.
   ============================================================ */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.HORARIO_MEDICO', 'U') IS NULL
BEGIN
    CREATE TABLE citas.HORARIO_MEDICO (
        id_HORARIO_MEDICO        INT IDENTITY(1,1) NOT NULL,
        id_USUARIOS              INT               NOT NULL,
        hora_inicio              TIME(0)           NOT NULL,
        comida_inicio            TIME(0)           NULL,
        comida_fin               TIME(0)           NULL,
        hora_fin                 TIME(0)           NOT NULL,
        id_usuario_creacion      TINYINT           NOT NULL,
        fecha_creacion           SMALLDATETIME     NOT NULL,
        id_usuario_modificacion  TINYINT           NULL,
        fecha_modificacion       SMALLDATETIME     NULL,
        CONSTRAINT PK_id_HORARIO_MEDICO PRIMARY KEY (id_HORARIO_MEDICO),
        CONSTRAINT FK_id_USUARIOS_USUARIOS_id_USUARIOS_HORARIO_MEDICO
            FOREIGN KEY (id_USUARIOS) REFERENCES citas.USUARIOS(id_USUARIOS)
    );

    CREATE UNIQUE INDEX IX_id_USUARIOS_HORARIO_MEDICO
        ON citas.HORARIO_MEDICO(id_USUARIOS);
END
GO

/* Regresa el horario de un medico o de todos (cuando @id_USUARIOS es NULL). */
CREATE OR ALTER PROCEDURE citas.spRegresaHorarioMedico
    @id_USUARIOS INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  h.id_HORARIO_MEDICO,
            h.id_USUARIOS,
            CONVERT(VARCHAR(5), h.hora_inicio, 108)   AS hora_inicio,
            CONVERT(VARCHAR(5), h.comida_inicio, 108) AS comida_inicio,
            CONVERT(VARCHAR(5), h.comida_fin, 108)    AS comida_fin,
            CONVERT(VARCHAR(5), h.hora_fin, 108)      AS hora_fin,
            u.nombre_completo
    FROM citas.HORARIO_MEDICO h
    INNER JOIN citas.USUARIOS u ON u.id_USUARIOS = h.id_USUARIOS
    WHERE (@id_USUARIOS IS NULL OR h.id_USUARIOS = @id_USUARIOS);
END
GO

/* Alta o cambio del horario del medico (un solo renglon por medico). */
CREATE OR ALTER PROCEDURE citas.spGuardaHorarioMedico
    @id_USUARIOS   INT,
    @hora_inicio   VARCHAR(5),
    @comida_inicio VARCHAR(5) = NULL,
    @comida_fin    VARCHAR(5) = NULL,
    @hora_fin      VARCHAR(5),
    @id_usuario    TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @hi TIME(0) = CONVERT(TIME(0), @hora_inicio),
            @ci TIME(0) = CASE WHEN @comida_inicio IS NULL OR @comida_inicio = '' THEN NULL ELSE CONVERT(TIME(0), @comida_inicio) END,
            @cf TIME(0) = CASE WHEN @comida_fin    IS NULL OR @comida_fin    = '' THEN NULL ELSE CONVERT(TIME(0), @comida_fin) END,
            @hf TIME(0) = CONVERT(TIME(0), @hora_fin);

    IF @hf <= @hi
    BEGIN
        RAISERROR('La hora de termino debe ser posterior a la hora de inicio.', 16, 1);
        RETURN;
    END
    IF @ci IS NOT NULL AND @cf IS NOT NULL AND (@cf <= @ci OR @ci < @hi OR @cf > @hf)
    BEGIN
        RAISERROR('El horario de comida debe estar dentro del horario de atencion.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM citas.HORARIO_MEDICO WHERE id_USUARIOS = @id_USUARIOS)
        UPDATE citas.HORARIO_MEDICO
           SET hora_inicio = @hi, comida_inicio = @ci, comida_fin = @cf, hora_fin = @hf,
               id_usuario_modificacion = @id_usuario, fecha_modificacion = GETDATE()
         WHERE id_USUARIOS = @id_USUARIOS;
    ELSE
        INSERT INTO citas.HORARIO_MEDICO(id_USUARIOS, hora_inicio, comida_inicio, comida_fin, hora_fin,
                                         id_usuario_creacion, fecha_creacion)
        VALUES(@id_USUARIOS, @hi, @ci, @cf, @hf, @id_usuario, GETDATE());

    /* --------- Bitacora: un renglon por cada horario definido --------- */
    DECLARE @medico VARCHAR(150) = (SELECT nombre_completo FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS);
    DECLARE @pre VARCHAR(2000) = 'el medico "' + ISNULL(@medico, '') + '" definio el horario: ';
    DECLARE @ev1 VARCHAR(2000) = @pre + 'inicio de consultas ' + CONVERT(VARCHAR(5), @hi, 108);
    DECLARE @ev2 VARCHAR(2000) = @pre + CASE WHEN @ci IS NULL OR @cf IS NULL THEN 'comida sin definir'
                                             ELSE 'comida de ' + CONVERT(VARCHAR(5), @ci, 108) + ' a ' + CONVERT(VARCHAR(5), @cf, 108) END;
    DECLARE @ev3 VARCHAR(2000) = @pre + 'fin de consultas ' + CONVERT(VARCHAR(5), @hf, 108);

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('HORARIO', 'spGuardaHorarioMedico', 'HORARIO_MEDICO', @ev1, GETDATE(), @id_usuario),
          ('HORARIO', 'spGuardaHorarioMedico', 'HORARIO_MEDICO', @ev2, GETDATE(), @id_usuario),
          ('HORARIO', 'spGuardaHorarioMedico', 'HORARIO_MEDICO', @ev3, GETDATE(), @id_usuario);
END
GO

GRANT EXECUTE ON OBJECT::citas.spRegresaHorarioMedico TO citasadmin;
GO
GRANT EXECUTE ON OBJECT::citas.spGuardaHorarioMedico TO citasadmin;
GO
