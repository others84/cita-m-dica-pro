-- Parche: esquema comercial y limites de usuarios por clinica.
-- Agrega columnas a citas.CLINICA (no se crean tablas nuevas) y actualiza los
-- procedimientos que dependen de esa tabla.
-- Esquemas: SOLO_CONSULTORIO (1 asistente, 1 medico, 1 admin de clinica)
--           SOLO_CLINICA     (2 asistentes, 5 medicos, 1 admin de clinica)
-- Aplicar en la BD CitasMedicas con el usuario dbo.
USE CitasMedicas;
GO

IF COL_LENGTH('citas.CLINICA','esquema') IS NULL
    ALTER TABLE citas.CLINICA ADD esquema VARCHAR(20) NOT NULL
        CONSTRAINT DF_esquema_CLINICA DEFAULT ('SOLO_CLINICA');
GO
IF COL_LENGTH('citas.CLINICA','max_asistentes') IS NULL
    ALTER TABLE citas.CLINICA ADD max_asistentes TINYINT NOT NULL
        CONSTRAINT DF_max_asistentes_CLINICA DEFAULT (2);
GO
IF COL_LENGTH('citas.CLINICA','max_medicos') IS NULL
    ALTER TABLE citas.CLINICA ADD max_medicos TINYINT NOT NULL
        CONSTRAINT DF_max_medicos_CLINICA DEFAULT (5);
GO
IF COL_LENGTH('citas.CLINICA','max_admins') IS NULL
    ALTER TABLE citas.CLINICA ADD max_admins TINYINT NOT NULL
        CONSTRAINT DF_max_admins_CLINICA DEFAULT (1);
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CHK_esquema_CLINICA')
    ALTER TABLE citas.CLINICA ADD CONSTRAINT CHK_esquema_CLINICA
        CHECK (esquema IN ('SOLO_CONSULTORIO','SOLO_CLINICA'));
GO

-- Clinicas existentes: esquema SOLO_CLINICA (2/5/1)
UPDATE citas.CLINICA
   SET esquema        = 'SOLO_CLINICA',
       max_asistentes = 2,
       max_medicos    = 5,
       max_admins     = 1
 WHERE esquema IS NULL OR esquema = '';
GO

-- =====================  CLINICA: alta / cambio / consultas  =====================
CREATE OR ALTER PROCEDURE citas.spAltaClinica
    @nombre VARCHAR(150), @direccion VARCHAR(250), @email VARCHAR(120),
    @telefono VARCHAR(20), @id_CATALOGO_MUNICIPIO INT,
    @id_usuario TINYINT,
    @esquema VARCHAR(20) = 'SOLO_CLINICA',
    @max_asistentes TINYINT = 2,
    @max_medicos TINYINT = 5,
    @max_admins TINYINT = 1,
    @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CLINICA(nombre,direccion,email,telefono,id_CATALOGO_MUNICIPIO,
                                      esquema,max_asistentes,max_medicos,max_admins,
                                      id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@direccion,@email,@telefono,@id_CATALOGO_MUNICIPIO,
                   @esquema,@max_asistentes,@max_medicos,@max_admins,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();

            DECLARE @actor VARCHAR(150);
            SELECT @actor = u.usuario FROM citas.USUARIOS u WHERE u.id_USUARIOS = @id_usuario;

            DECLARE @msg VARCHAR(2000);
            SET @msg='ALTA CLINICA: usuario="'+ISNULL(@actor,CONVERT(VARCHAR(10),@id_usuario))+'"'
                    +' clinica="'+@nombre+'"'
                    +' esquema='+@esquema
                    +' max_asistentes='+CONVERT(VARCHAR(10),@max_asistentes)
                    +' max_medicos='+CONVERT(VARCHAR(10),@max_medicos)
                    +' max_admins='+CONVERT(VARCHAR(10),@max_admins)
                    +' id_CLINICA='+CONVERT(VARCHAR(20),@id_nuevo);
            INSERT INTO citas.LOG VALUES('CLINICA','spAltaClinica','CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CLINICA','spAltaClinica','CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioClinica
    @id_CLINICA INT, @nombre VARCHAR(150), @direccion VARCHAR(250),
    @email VARCHAR(120), @telefono VARCHAR(20),
    @id_CATALOGO_MUNICIPIO INT, @id_usuario TINYINT,
    @esquema VARCHAR(20) = NULL,
    @max_asistentes TINYINT = NULL,
    @max_medicos TINYINT = NULL,
    @max_admins TINYINT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DECLARE @oe VARCHAR(20), @oa TINYINT, @om TINYINT, @od TINYINT;
            SELECT @oe=esquema, @oa=max_asistentes, @om=max_medicos, @od=max_admins
              FROM citas.CLINICA WHERE id_CLINICA=@id_CLINICA;

            SET @esquema        = ISNULL(@esquema, @oe);
            SET @max_asistentes = ISNULL(@max_asistentes, @oa);
            SET @max_medicos    = ISNULL(@max_medicos, @om);
            SET @max_admins     = ISNULL(@max_admins, @od);

            UPDATE citas.CLINICA
               SET nombre=@nombre, direccion=@direccion, email=@email, telefono=@telefono,
                   id_CATALOGO_MUNICIPIO=@id_CATALOGO_MUNICIPIO,
                   esquema=@esquema, max_asistentes=@max_asistentes,
                   max_medicos=@max_medicos, max_admins=@max_admins,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CLINICA=@id_CLINICA;

            DECLARE @actor VARCHAR(150);
            SELECT @actor = u.usuario FROM citas.USUARIOS u WHERE u.id_USUARIOS = @id_usuario;

            DECLARE @msg VARCHAR(2000);
            SET @msg='CAMBIO LIMITES CLINICA: usuario="'+ISNULL(@actor,CONVERT(VARCHAR(10),@id_usuario))+'"'
                    +' clinica="'+@nombre+'"'
                    +' esquema='+ISNULL(@oe,'?')+'->'+@esquema
                    +' max_asistentes='+CONVERT(VARCHAR(10),ISNULL(@oa,0))+'->'+CONVERT(VARCHAR(10),@max_asistentes)
                    +' max_medicos='+CONVERT(VARCHAR(10),ISNULL(@om,0))+'->'+CONVERT(VARCHAR(10),@max_medicos)
                    +' max_admins='+CONVERT(VARCHAR(10),ISNULL(@od,0))+'->'+CONVERT(VARCHAR(10),@max_admins)
                    +' id_CLINICA='+CONVERT(VARCHAR(20),@id_CLINICA);
            INSERT INTO citas.LOG VALUES('CLINICA','spCambioClinica','CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CLINICA','spCambioClinica','CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaClinicas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.id_CLINICA, c.nombre, c.direccion, c.email, c.telefono, c.activo,
           c.esquema, c.max_asistentes, c.max_medicos, c.max_admins,
           c.id_CATALOGO_MUNICIPIO, m.nombre AS municipio,
           m.id_CATALOGO_ESTADOS, e.nombre AS estado,
           e.id_CATALOGO_PAIS, p.nombre AS pais,
           (SELECT COUNT(DISTINCT uc.id_USUARIOS) FROM citas.USUARIOS_CLINICA uc
              JOIN citas.USUARIOS u ON u.id_USUARIOS = uc.id_USUARIOS
              JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
             WHERE uc.id_CLINICA = c.id_CLINICA AND u.activo = 1 AND r.nombre LIKE 'Asistente%') AS usuarios_asistentes,
           (SELECT COUNT(DISTINCT uc.id_USUARIOS) FROM citas.USUARIOS_CLINICA uc
              JOIN citas.USUARIOS u ON u.id_USUARIOS = uc.id_USUARIOS
              JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
             WHERE uc.id_CLINICA = c.id_CLINICA AND u.activo = 1 AND (r.nombre LIKE 'M_dico%' OR r.nombre LIKE 'Medico%')) AS usuarios_medicos,
           (SELECT COUNT(DISTINCT uc.id_USUARIOS) FROM citas.USUARIOS_CLINICA uc
              JOIN citas.USUARIOS u ON u.id_USUARIOS = uc.id_USUARIOS
              JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
             WHERE uc.id_CLINICA = c.id_CLINICA AND u.activo = 1 AND r.nombre LIKE 'Administrador de cl%') AS usuarios_admins
      FROM citas.CLINICA c
      JOIN citas.CATALOGO_MUNICIPIO m ON m.id_CATALOGO_MUNICIPIO = c.id_CATALOGO_MUNICIPIO
      JOIN citas.CATALOGO_ESTADOS   e ON e.id_CATALOGO_ESTADOS   = m.id_CATALOGO_ESTADOS
      JOIN citas.CATALOGO_PAIS      p ON p.id_CATALOGO_PAIS      = e.id_CATALOGO_PAIS
     ORDER BY c.nombre;
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaClinicasResumen
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.id_CLINICA, c.nombre, c.activo,
           c.esquema, c.max_asistentes, c.max_medicos, c.max_admins,
           (SELECT COUNT(DISTINCT uc.id_USUARIOS) FROM citas.USUARIOS_CLINICA uc WHERE uc.id_CLINICA = c.id_CLINICA) AS total_usuarios,
           (SELECT COUNT(*) FROM citas.PACIENTE p WHERE p.id_CLINICA = c.id_CLINICA) AS total_pacientes,
           (SELECT COUNT(*) FROM citas.CITA ci JOIN citas.PACIENTE p ON p.id_PACIENTE = ci.id_PACIENTE WHERE p.id_CLINICA = c.id_CLINICA) AS total_citas
      FROM citas.CLINICA c
     ORDER BY c.nombre;
END
GO

-- =====================  VALIDACION DE CUPO  =====================
CREATE OR ALTER PROCEDURE citas.spValidaCupoUsuarioClinica
    @id_CLINICA INT,
    @id_ROLES INT,
    @id_usuario TINYINT = 0,
    @id_USUARIOS INT = NULL   -- usuario que se pretende asignar/activar (se excluye del conteo)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @rol VARCHAR(60), @limite INT = NULL, @actuales INT = 0,
            @clinica VARCHAR(150), @esquema VARCHAR(20), @actor VARCHAR(150);

    SELECT @rol = nombre FROM citas.ROLES WHERE id_ROLES = @id_ROLES;
    SELECT @clinica = nombre, @esquema = esquema,
           @limite = CASE
                WHEN @rol LIKE 'Asistente%'            THEN max_asistentes
                WHEN @rol LIKE 'M_dico%' OR @rol LIKE 'Medico%' THEN max_medicos
                WHEN @rol LIKE 'Administrador de cl%'  THEN max_admins
                ELSE NULL END
      FROM citas.CLINICA WHERE id_CLINICA = @id_CLINICA;

    IF @limite IS NULL RETURN;  -- rol sin limite (p.ej. admin de sistema) o clinica inexistente

    SELECT @actuales = COUNT(DISTINCT uc.id_USUARIOS)
      FROM citas.USUARIOS_CLINICA uc
      JOIN citas.USUARIOS u ON u.id_USUARIOS = uc.id_USUARIOS
     WHERE uc.id_CLINICA = @id_CLINICA
       AND u.activo = 1
       AND u.id_ROLES = @id_ROLES
       AND (@id_USUARIOS IS NULL OR uc.id_USUARIOS <> @id_USUARIOS);

    IF @actuales >= @limite
    BEGIN
        SELECT @actor = usuario FROM citas.USUARIOS WHERE id_USUARIOS = @id_usuario;
        DECLARE @msg VARCHAR(2000);
        SET @msg='LIMITE EXCEDIDO: usuario="'+ISNULL(@actor,CONVERT(VARCHAR(10),@id_usuario))+'"'
                +' clinica="'+ISNULL(@clinica,'?')+'"'
                +' esquema='+ISNULL(@esquema,'?')
                +' rol='+ISNULL(@rol,'?')
                +' limite='+CONVERT(VARCHAR(10),@limite)
                +' actuales='+CONVERT(VARCHAR(10),@actuales);
        INSERT INTO citas.LOG VALUES('CLINICA','spValidaCupoUsuarioClinica','USUARIOS_CLINICA',@msg,GETDATE(),ISNULL(@id_usuario,0));

        DECLARE @errmsg NVARCHAR(400);
        SET @errmsg = N'La clinica "' + ISNULL(@clinica,'?') + N'" (esquema ' + ISNULL(@esquema,'?')
                    + N') ya alcanzo el maximo de ' + CONVERT(NVARCHAR(10),@limite) + N' usuario(s) con perfil '
                    + ISNULL(@rol,'?') + N'. Ajuste los limites desde Administrador de Sistema.';
        THROW 51010, @errmsg, 1;
    END
END
GO

-- =====================  ASIGNACION Y ACTIVACION CON VALIDACION  =====================
CREATE OR ALTER PROCEDURE citas.spAltaUsuarioClinica
    @id_USUARIOS INT,
    @id_CLINICA INT,
    @id_usuario TINYINT,
    @actor VARCHAR(150) = NULL,
    @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @id_ROLES INT;
        SELECT @id_ROLES = id_ROLES FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS;
        EXEC citas.spValidaCupoUsuarioClinica @id_CLINICA=@id_CLINICA, @id_ROLES=@id_ROLES,
             @id_usuario=@id_usuario, @id_USUARIOS=@id_USUARIOS;

        BEGIN TRAN;
            INSERT INTO citas.USUARIOS_CLINICA(id_USUARIOS,id_CLINICA,id_usuario_creacion,fecha_creacion)
            VALUES(@id_USUARIOS,@id_CLINICA,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();

            DECLARE @medico VARCHAR(150), @clinica VARCHAR(150), @rol VARCHAR(100);
            SELECT @medico = u.nombre_completo, @rol = r.nombre
              FROM citas.USUARIOS u
              LEFT JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
             WHERE u.id_USUARIOS = @id_USUARIOS;
            SELECT @clinica = c.nombre FROM citas.CLINICA c WHERE c.id_CLINICA = @id_CLINICA;

            IF @actor IS NULL
                SELECT @actor = u.nombre_completo FROM citas.USUARIOS u WHERE u.id_USUARIOS = @id_usuario;

            DECLARE @msg VARCHAR(2000);
            SET @msg = 'CLINICA ASIGNADA A USUARIO: usuario=' + ISNULL(@medico,CONVERT(VARCHAR(20),@id_USUARIOS))
                     + ', rol=' + ISNULL(@rol,'?')
                     + ', clinica=' + ISNULL(@clinica,CONVERT(VARCHAR(20),@id_CLINICA))
                     + ', agregado por=' + ISNULL(@actor,CONVERT(VARCHAR(20),@id_usuario))
                     + ', id_USUARIOS_CLINICA=' + CONVERT(VARCHAR(20),@id_nuevo);
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

CREATE OR ALTER PROCEDURE citas.spActivaUsuario
    @id_USUARIOS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @id_ROLES INT;
        SELECT @id_ROLES = id_ROLES FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS;

        DECLARE @cli INT;
        DECLARE cur_cli CURSOR LOCAL FAST_FORWARD FOR
            SELECT DISTINCT id_CLINICA FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS = @id_USUARIOS;
        OPEN cur_cli;
        FETCH NEXT FROM cur_cli INTO @cli;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC citas.spValidaCupoUsuarioClinica @id_CLINICA=@cli, @id_ROLES=@id_ROLES,
                 @id_usuario=@id_usuario, @id_USUARIOS=@id_USUARIOS;
            FETCH NEXT FROM cur_cli INTO @cli;
        END
        CLOSE cur_cli; DEALLOCATE cur_cli;

        BEGIN TRAN;
            UPDATE citas.USUARIOS
               SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_USUARIOS=@id_USUARIOS;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Activa Usuario id='+CONVERT(VARCHAR(20),@id_USUARIOS);
            INSERT INTO citas.LOG VALUES('USUARIOS','spActivaUsuario','USUARIOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spActivaUsuario: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS','spActivaUsuario','USUARIOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

GRANT EXECUTE ON citas.spAltaClinica                 TO app_user;
GRANT EXECUTE ON citas.spCambioClinica               TO app_user;
GRANT EXECUTE ON citas.spRegresaClinicas             TO app_user;
GRANT EXECUTE ON citas.spRegresaClinicasResumen      TO app_user;
GRANT EXECUTE ON citas.spValidaCupoUsuarioClinica    TO app_user;
GRANT EXECUTE ON citas.spAltaUsuarioClinica          TO app_user;
GRANT EXECUTE ON citas.spActivaUsuario               TO app_user;
GO
