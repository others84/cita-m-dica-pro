/* =====================================================================
   Sistema POLICLINICA - Citas Medicas
   Motor : Microsoft SQL Server 2022 Express Edition
   BD    : CitasMedicas
   Esquema: citas (todos los objetos)
   Usuario aplicativo: citasadmin / admin01$  (puerto 1435)
   Acceso a tablas SOLO a traves de procedimientos almacenados.
   Concatenacion de cadenas: operador +  (NO se usa CONCAT).
   Cadenas largas: variable local VARCHAR(2000).
   Manejo de errores: TRY/CATCH + log en citas.LOG + RAISERROR a la app.
   ===================================================================== */

/* =====================================================================
   1. BASE DE DATOS
   ===================================================================== */
USE master;
GO
IF DB_ID('CitasMedicas') IS NOT NULL
BEGIN
    ALTER DATABASE CitasMedicas SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CitasMedicas;
END
GO
CREATE DATABASE CitasMedicas;
GO
ALTER DATABASE CitasMedicas SET RECOVERY SIMPLE;
GO

/* =====================================================================
   2. LOGIN + USUARIO + ESQUEMA citas
   ===================================================================== */
USE master;
GO
IF SUSER_ID('citasadmin') IS NOT NULL  DROP LOGIN citasadmin;
GO
CREATE LOGIN citasadmin
    WITH PASSWORD = 'admin01$',
         CHECK_POLICY = OFF,
         DEFAULT_DATABASE = CitasMedicas;
GO

USE CitasMedicas;
GO
IF USER_ID('citasadmin') IS NOT NULL  DROP USER citasadmin;
GO
IF SCHEMA_ID('citas') IS NULL  EXEC('CREATE SCHEMA citas AUTHORIZATION dbo');
GO
CREATE USER citasadmin FOR LOGIN citasadmin WITH DEFAULT_SCHEMA = citas;
GO
ALTER AUTHORIZATION ON SCHEMA::citas TO citasadmin;
GO

/* =====================================================================
   3. TABLA LOG  (sin campos de auditoria estandar)
   ===================================================================== */
IF OBJECT_ID('citas.LOG','U') IS NOT NULL  DROP TABLE citas.LOG;
GO
CREATE TABLE citas.LOG(
    id_log         INT IDENTITY(1,1) NOT NULL,
    modulo         VARCHAR(30)   NOT NULL,
    procedimiento  VARCHAR(300)  NOT NULL,
    tabla          VARCHAR(50)   NOT NULL,
    evento         VARCHAR(2000) NOT NULL,
    fecha          SMALLDATETIME NOT NULL,
    id_usuario     TINYINT       NOT NULL,
    CONSTRAINT PK_id_LOG PRIMARY KEY CLUSTERED (id_log)
);
GO

/* =====================================================================
   4. TABLAS DE SEGURIDAD: ROLES / USUARIOS
   ===================================================================== */
IF OBJECT_ID('citas.USUARIOS','U') IS NOT NULL DROP TABLE citas.USUARIOS;
IF OBJECT_ID('citas.ROLES','U')    IS NOT NULL DROP TABLE citas.ROLES;
GO

CREATE TABLE citas.ROLES(
    id_ROLES                 INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(50)  NOT NULL,
    descripcion              VARCHAR(200) NULL,
    activo                   BIT          NOT NULL CONSTRAINT DF_ROLES_activo DEFAULT(1),
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_ROLES PRIMARY KEY CLUSTERED (id_ROLES),
    CONSTRAINT CHK_activo_ROLES CHECK (activo IN (0,1))
);
GO
CREATE UNIQUE INDEX IX_nombre_ROLES ON citas.ROLES(nombre);
GO

CREATE TABLE citas.USUARIOS(
    id_USUARIOS              INT IDENTITY(1,1) NOT NULL,
    id_ROLES                 INT           NOT NULL,
    id_CLINICA               INT           NULL,   -- FK se agrega despues
    usuario                  VARCHAR(50)   NOT NULL,
    password_hash            VARBINARY(64) NOT NULL,   -- SHA2_512(password + salt)
    password_salt            VARCHAR(36)   NOT NULL,
    nombre_completo          VARCHAR(150)  NOT NULL,
    email                    VARCHAR(150)  NULL,
    activo                   BIT           NOT NULL CONSTRAINT DF_USUARIOS_activo DEFAULT(1),
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_USUARIOS PRIMARY KEY CLUSTERED (id_USUARIOS),
    CONSTRAINT FK_id_ROLES_ROLES_id_ROLES_USUARIOS
        FOREIGN KEY (id_ROLES) REFERENCES citas.ROLES(id_ROLES),
    CONSTRAINT CHK_activo_USUARIOS CHECK (activo IN (0,1))
);
GO
CREATE UNIQUE INDEX IX_usuario_USUARIOS ON citas.USUARIOS(usuario);
GO

/* =====================================================================
   5. CATALOGOS
   ===================================================================== */
CREATE TABLE citas.CATALOGO_PAIS(
    id_CATALOGO_PAIS         INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(80) NOT NULL,
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_CATALOGO_PAIS PRIMARY KEY CLUSTERED (id_CATALOGO_PAIS)
);
CREATE UNIQUE INDEX IX_nombre_CATALOGO_PAIS ON citas.CATALOGO_PAIS(nombre);
GO

CREATE TABLE citas.CATALOGO_ESTADOS(
    id_CATALOGO_ESTADOS      INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(80) NOT NULL,
    id_CATALOGO_PAIS         INT NOT NULL,
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_CATALOGO_ESTADOS PRIMARY KEY CLUSTERED (id_CATALOGO_ESTADOS),
    CONSTRAINT FK_id_CATALOGO_PAIS_CATALOGO_PAIS_id_CATALOGO_PAIS_CATALOGO_ESTADOS
        FOREIGN KEY (id_CATALOGO_PAIS) REFERENCES citas.CATALOGO_PAIS(id_CATALOGO_PAIS)
);
CREATE UNIQUE INDEX IX_nombre_id_CATALOGO_PAIS_CATALOGO_ESTADOS
    ON citas.CATALOGO_ESTADOS(nombre, id_CATALOGO_PAIS);
GO

CREATE TABLE citas.CATALOGO_ESTADO_CITAS(
    id_CATALOGO_ESTADO_CITAS INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(50) NOT NULL,
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_CATALOGO_ESTADO_CITAS PRIMARY KEY CLUSTERED (id_CATALOGO_ESTADO_CITAS)
);
CREATE UNIQUE INDEX IX_nombre_CATALOGO_ESTADO_CITAS ON citas.CATALOGO_ESTADO_CITAS(nombre);
GO

CREATE TABLE citas.CATALOGO_GENERO(
    id_CATALOGO_GENERO       INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(30) NOT NULL,
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_CATALOGO_GENERO PRIMARY KEY CLUSTERED (id_CATALOGO_GENERO)
);
CREATE UNIQUE INDEX IX_nombre_CATALOGO_GENERO ON citas.CATALOGO_GENERO(nombre);
GO

CREATE TABLE citas.CATALOGO_ESPECIALIDAD(
    id_CATALOGO_ESPECIALIDAD INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(100) NOT NULL,
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_CATALOGO_ESPECIALIDAD PRIMARY KEY CLUSTERED (id_CATALOGO_ESPECIALIDAD)
);
CREATE UNIQUE INDEX IX_nombre_CATALOGO_ESPECIALIDAD ON citas.CATALOGO_ESPECIALIDAD(nombre);
GO

/* =====================================================================
   6. TABLAS OPERATIVAS
   ===================================================================== */
CREATE TABLE citas.CLINICA(
    id_CLINICA               INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(150) NOT NULL,
    direccion                VARCHAR(250) NOT NULL,
    email                    VARCHAR(150) NULL,
    telefono                 VARCHAR(20)  NULL,
    municipio                VARCHAR(100) NOT NULL,
    id_CATALOGO_ESTADOS      INT          NOT NULL,
    activo                   BIT          NOT NULL CONSTRAINT DF_CLINICA_activo DEFAULT(1),
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_CLINICA PRIMARY KEY CLUSTERED (id_CLINICA),
    CONSTRAINT FK_id_CATALOGO_ESTADOS_CATALOGO_ESTADOS_id_CATALOGO_ESTADOS_CLINICA
        FOREIGN KEY (id_CATALOGO_ESTADOS) REFERENCES citas.CATALOGO_ESTADOS(id_CATALOGO_ESTADOS),
    CONSTRAINT CHK_activo_CLINICA CHECK (activo IN (0,1))
);
CREATE UNIQUE INDEX IX_nombre_CLINICA ON citas.CLINICA(nombre);
GO

-- FK pendiente USUARIOS -> CLINICA
ALTER TABLE citas.USUARIOS
    ADD CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_USUARIOS
        FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA);
GO

CREATE TABLE citas.CONSULTORIO(
    id_CONSULTORIO           INT IDENTITY(1,1) NOT NULL,
    id_CLINICA               INT NOT NULL,
    nombre                   VARCHAR(100) NOT NULL,
    activo                   BIT NOT NULL CONSTRAINT DF_CONSULTORIO_activo DEFAULT(1),
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_CONSULTORIO PRIMARY KEY CLUSTERED (id_CONSULTORIO),
    CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_CONSULTORIO
        FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA),
    CONSTRAINT CHK_activo_CONSULTORIO CHECK (activo IN (0,1))
);
CREATE UNIQUE INDEX IX_id_CLINICA_nombre_CONSULTORIO ON citas.CONSULTORIO(id_CLINICA, nombre);
GO

CREATE TABLE citas.MEDICO(
    id_MEDICO                INT IDENTITY(1,1) NOT NULL,
    nombre_completo          VARCHAR(150) NOT NULL,
    activo                   BIT NOT NULL CONSTRAINT DF_MEDICO_activo DEFAULT(1),
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_MEDICO PRIMARY KEY CLUSTERED (id_MEDICO),
    CONSTRAINT CHK_activo_MEDICO CHECK (activo IN (0,1))
);
CREATE UNIQUE INDEX IX_nombre_completo_MEDICO ON citas.MEDICO(nombre_completo);
GO

CREATE TABLE citas.MEDICO_ESPECIALIDAD(
    id_MEDICO_ESPECIALIDAD   INT IDENTITY(1,1) NOT NULL,
    id_MEDICO                INT NOT NULL,
    id_CATALOGO_ESPECIALIDAD INT NOT NULL,
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_MEDICO_ESPECIALIDAD PRIMARY KEY CLUSTERED (id_MEDICO_ESPECIALIDAD),
    CONSTRAINT FK_id_MEDICO_MEDICO_id_MEDICO_MEDICO_ESPECIALIDAD
        FOREIGN KEY (id_MEDICO) REFERENCES citas.MEDICO(id_MEDICO),
    CONSTRAINT FK_id_CATALOGO_ESPECIALIDAD_CATALOGO_ESPECIALIDAD_id_CATALOGO_ESPECIALIDAD_MEDICO_ESPECIALIDAD
        FOREIGN KEY (id_CATALOGO_ESPECIALIDAD) REFERENCES citas.CATALOGO_ESPECIALIDAD(id_CATALOGO_ESPECIALIDAD)
);
CREATE UNIQUE INDEX IX_id_MEDICO_id_CATALOGO_ESPECIALIDAD_MEDICO_ESPECIALIDAD
    ON citas.MEDICO_ESPECIALIDAD(id_MEDICO, id_CATALOGO_ESPECIALIDAD);
GO

CREATE TABLE citas.MEDICO_CONSULTORIO(
    id_MEDICO_CONSULTORIO    INT IDENTITY(1,1) NOT NULL,
    id_MEDICO                INT NOT NULL,
    id_CONSULTORIO           INT NOT NULL,
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_MEDICO_CONSULTORIO PRIMARY KEY CLUSTERED (id_MEDICO_CONSULTORIO),
    CONSTRAINT FK_id_MEDICO_MEDICO_id_MEDICO_MEDICO_CONSULTORIO
        FOREIGN KEY (id_MEDICO) REFERENCES citas.MEDICO(id_MEDICO),
    CONSTRAINT FK_id_CONSULTORIO_CONSULTORIO_id_CONSULTORIO_MEDICO_CONSULTORIO
        FOREIGN KEY (id_CONSULTORIO) REFERENCES citas.CONSULTORIO(id_CONSULTORIO)
);
CREATE UNIQUE INDEX IX_id_MEDICO_id_CONSULTORIO_MEDICO_CONSULTORIO
    ON citas.MEDICO_CONSULTORIO(id_MEDICO, id_CONSULTORIO);
GO

CREATE TABLE citas.PACIENTE(
    id_PACIENTE              INT IDENTITY(1,1) NOT NULL,
    id_CLINICA               INT NOT NULL,
    ap_paterno               VARCHAR(80) NOT NULL,
    ap_materno               VARCHAR(80) NULL,
    nombre                   VARCHAR(80) NOT NULL,
    direccion                VARCHAR(250) NULL,
    telefono                 VARCHAR(20)  NULL,
    email                    VARCHAR(150) NULL,
    fecha_nacimiento         DATE         NULL,
    id_CATALOGO_GENERO       INT          NULL,
    municipio                VARCHAR(100) NULL,
    id_CATALOGO_ESTADOS      INT          NULL,
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_PACIENTE PRIMARY KEY CLUSTERED (id_PACIENTE),
    CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_PACIENTE
        FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA),
    CONSTRAINT FK_id_CATALOGO_GENERO_CATALOGO_GENERO_id_CATALOGO_GENERO_PACIENTE
        FOREIGN KEY (id_CATALOGO_GENERO) REFERENCES citas.CATALOGO_GENERO(id_CATALOGO_GENERO),
    CONSTRAINT FK_id_CATALOGO_ESTADOS_CATALOGO_ESTADOS_id_CATALOGO_ESTADOS_PACIENTE
        FOREIGN KEY (id_CATALOGO_ESTADOS) REFERENCES citas.CATALOGO_ESTADOS(id_CATALOGO_ESTADOS)
);
CREATE UNIQUE INDEX IX_id_CLINICA_ap_paterno_ap_materno_nombre_fecha_nacimiento_PACIENTE
    ON citas.PACIENTE(id_CLINICA, ap_paterno, ap_materno, nombre, fecha_nacimiento);
GO

CREATE TABLE citas.CITA(
    id_CITA                  INT IDENTITY(1,1) NOT NULL,
    id_PACIENTE              INT NOT NULL,
    id_MEDICO                INT NOT NULL,
    id_CONSULTORIO           INT NOT NULL,
    id_CATALOGO_ESPECIALIDAD INT NOT NULL,
    fecha_cita               DATE NOT NULL,
    hora_inicio              TIME(0) NOT NULL,
    hora_fin                 TIME(0) NOT NULL,
    id_CATALOGO_ESTADO_CITAS INT NOT NULL,
    observaciones            VARCHAR(500) NULL,
    notifica_email           BIT NOT NULL CONSTRAINT DF_CITA_notif_email DEFAULT(0),
    notifica_wa              BIT NOT NULL CONSTRAINT DF_CITA_notif_wa    DEFAULT(0),
    email_notif              VARCHAR(150) NULL,
    celular_notif            VARCHAR(20)  NULL,
    horas_anticipacion_notif TINYINT NOT NULL CONSTRAINT DF_CITA_horas_anticip DEFAULT(24),
    precio                   DECIMAL(10,2) NOT NULL CONSTRAINT DF_CITA_precio DEFAULT(0),
    id_usuario_creacion      TINYINT       NOT NULL,
    fecha_creacion           SMALLDATETIME NOT NULL,
    id_usuario_modificacion  TINYINT       NULL,
    fecha_modificacion       SMALLDATETIME NULL,
    CONSTRAINT PK_id_CITA PRIMARY KEY CLUSTERED (id_CITA),
    CONSTRAINT FK_id_PACIENTE_PACIENTE_id_PACIENTE_CITA
        FOREIGN KEY (id_PACIENTE) REFERENCES citas.PACIENTE(id_PACIENTE),
    CONSTRAINT FK_id_MEDICO_MEDICO_id_MEDICO_CITA
        FOREIGN KEY (id_MEDICO) REFERENCES citas.MEDICO(id_MEDICO),
    CONSTRAINT FK_id_CONSULTORIO_CONSULTORIO_id_CONSULTORIO_CITA
        FOREIGN KEY (id_CONSULTORIO) REFERENCES citas.CONSULTORIO(id_CONSULTORIO),
    CONSTRAINT FK_id_CATALOGO_ESPECIALIDAD_CATALOGO_ESPECIALIDAD_id_CATALOGO_ESPECIALIDAD_CITA
        FOREIGN KEY (id_CATALOGO_ESPECIALIDAD) REFERENCES citas.CATALOGO_ESPECIALIDAD(id_CATALOGO_ESPECIALIDAD),
    CONSTRAINT FK_id_CATALOGO_ESTADO_CITAS_CATALOGO_ESTADO_CITAS_id_CATALOGO_ESTADO_CITAS_CITA
        FOREIGN KEY (id_CATALOGO_ESTADO_CITAS) REFERENCES citas.CATALOGO_ESTADO_CITAS(id_CATALOGO_ESTADO_CITAS),
    CONSTRAINT CHK_hora_fin_CITA           CHECK (hora_fin > hora_inicio),
    CONSTRAINT CHK_precio_CITA             CHECK (precio >= 0),
    CONSTRAINT CHK_notifica_email_CITA     CHECK (notifica_email IN (0,1)),
    CONSTRAINT CHK_notifica_wa_CITA        CHECK (notifica_wa    IN (0,1))
);
CREATE INDEX IX_fecha_cita_id_MEDICO_CITA ON citas.CITA(fecha_cita, id_MEDICO);
CREATE INDEX IX_id_PACIENTE_CITA          ON citas.CITA(id_PACIENTE);
GO

/* =====================================================================
   7. SEGURIDAD: solo SPs, nada de acceso directo a tablas
   ===================================================================== */
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::citas TO citasadmin;
GRANT EXECUTE ON SCHEMA::citas TO citasadmin;
GO

/* =====================================================================
   8. PROCEDIMIENTOS ALMACENADOS
   Patron general:
     - Parametrizados.
     - BEGIN TRY / BEGIN TRAN ... COMMIT / END TRY
       BEGIN CATCH  ROLLBACK + insertar en citas.LOG + RAISERROR  END CATCH
     - Cadena de evento se arma en VARIABLE LOCAL VARCHAR(2000) usando + .
     - NO se usa CONCAT.
   ===================================================================== */

/* ---------- 8.1 spLoginUsuario ---------- */
IF OBJECT_ID('citas.spLoginUsuario','P') IS NOT NULL DROP PROCEDURE citas.spLoginUsuario;
GO
CREATE PROCEDURE citas.spLoginUsuario
    @usuario  VARCHAR(50),
    @password VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        SELECT u.id_USUARIOS, u.usuario, u.nombre_completo, u.email,
               u.id_ROLES, r.nombre AS rol, u.id_CLINICA, u.activo
        FROM   citas.USUARIOS u
        INNER JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
        WHERE  u.usuario = @usuario
          AND  u.activo  = 1
          AND  u.password_hash = HASHBYTES('SHA2_512', @password + u.password_salt);

        SET @evento = 'Login intento usuario=' + ISNULL(@usuario,'');
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES ('LOGIN','spLoginUsuario','USUARIOS', @evento, GETDATE(), 0);
    END TRY
    BEGIN CATCH
        SET @evento = 'ERROR ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES ('LOGIN','spLoginUsuario','USUARIOS', LEFT(@evento,2000), GETDATE(), 0);
        ;THROW;
    END CATCH
END
GO

/* ---------- 8.2 ROLES ---------- */
IF OBJECT_ID('citas.spAltaRol','P')      IS NOT NULL DROP PROCEDURE citas.spAltaRol;
IF OBJECT_ID('citas.spCambioRol','P')    IS NOT NULL DROP PROCEDURE citas.spCambioRol;
IF OBJECT_ID('citas.spBajaRol','P')      IS NOT NULL DROP PROCEDURE citas.spBajaRol;
IF OBJECT_ID('citas.spActivaRol','P')    IS NOT NULL DROP PROCEDURE citas.spActivaRol;
IF OBJECT_ID('citas.spDesactivaRol','P') IS NOT NULL DROP PROCEDURE citas.spDesactivaRol;
IF OBJECT_ID('citas.spRegresaRoles','P') IS NOT NULL DROP PROCEDURE citas.spRegresaRoles;
GO
CREATE PROCEDURE citas.spAltaRol
    @nombre      VARCHAR(50),
    @descripcion VARCHAR(200),
    @id_usuario  TINYINT,
    @id_nuevo    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.ROLES(nombre, descripcion, activo, id_usuario_creacion, fecha_creacion)
        VALUES (@nombre, @descripcion, 1, @id_usuario, GETDATE());
        SET @id_nuevo = SCOPE_IDENTITY();

        SET @evento = 'ALTA ROL nombre=' + ISNULL(@nombre,'') + ' id=' + CONVERT(VARCHAR(10), @id_nuevo);
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES ('ROLES','spAltaRol','ROLES', @evento, GETDATE(), @id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        SET @evento = 'ERROR ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES ('ROLES','spAltaRol','ROLES', LEFT(@evento,2000), GETDATE(), @id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioRol
    @id_ROLES    INT,
    @nombre      VARCHAR(50),
    @descripcion VARCHAR(200),
    @id_usuario  TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.ROLES
           SET nombre = @nombre,
               descripcion = @descripcion,
               id_usuario_modificacion = @id_usuario,
               fecha_modificacion = GETDATE()
         WHERE id_ROLES = @id_ROLES;

        SET @evento = 'CAMBIO ROL id=' + CONVERT(VARCHAR(10), @id_ROLES) + ' nombre=' + ISNULL(@nombre,'');
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES ('ROLES','spCambioRol','ROLES', @evento, GETDATE(), @id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        SET @evento = 'ERROR ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES ('ROLES','spCambioRol','ROLES', LEFT(@evento,2000), GETDATE(), @id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spBajaRol
    @id_ROLES   INT,
    @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.ROLES
           SET activo = 0,
               id_usuario_modificacion = @id_usuario,
               fecha_modificacion = GETDATE()
         WHERE id_ROLES = @id_ROLES;

        SET @evento = 'BAJA LOGICA ROL id=' + CONVERT(VARCHAR(10), @id_ROLES);
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES ('ROLES','spBajaRol','ROLES', @evento, GETDATE(), @id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        SET @evento = 'ERROR ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES ('ROLES','spBajaRol','ROLES', LEFT(@evento,2000), GETDATE(), @id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spActivaRol    @id_ROLES INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.ROLES SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_ROLES=@id_ROLES;
        SET @evento = 'ACTIVA ROL id=' + CONVERT(VARCHAR(10), @id_ROLES);
        INSERT INTO citas.LOG VALUES ('ROLES','spActivaRol','ROLES',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento = 'ERROR ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('ROLES','spActivaRol','ROLES',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spDesactivaRol @id_ROLES INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.ROLES SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_ROLES=@id_ROLES;
        SET @evento = 'DESACTIVA ROL id=' + CONVERT(VARCHAR(10), @id_ROLES);
        INSERT INTO citas.LOG VALUES ('ROLES','spDesactivaRol','ROLES',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento = 'ERROR ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('ROLES','spDesactivaRol','ROLES',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaRoles AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_ROLES, nombre, descripcion, activo FROM citas.ROLES ORDER BY nombre;
END
GO

/* ---------- 8.3 USUARIOS ---------- */
IF OBJECT_ID('citas.spAltaUsuario','P')      IS NOT NULL DROP PROCEDURE citas.spAltaUsuario;
IF OBJECT_ID('citas.spCambioUsuario','P')    IS NOT NULL DROP PROCEDURE citas.spCambioUsuario;
IF OBJECT_ID('citas.spCambioPassword','P')   IS NOT NULL DROP PROCEDURE citas.spCambioPassword;
IF OBJECT_ID('citas.spBajaUsuario','P')      IS NOT NULL DROP PROCEDURE citas.spBajaUsuario;
IF OBJECT_ID('citas.spActivaUsuario','P')    IS NOT NULL DROP PROCEDURE citas.spActivaUsuario;
IF OBJECT_ID('citas.spDesactivaUsuario','P') IS NOT NULL DROP PROCEDURE citas.spDesactivaUsuario;
IF OBJECT_ID('citas.spRegresaUsuarios','P')  IS NOT NULL DROP PROCEDURE citas.spRegresaUsuarios;
GO
CREATE PROCEDURE citas.spAltaUsuario
    @id_ROLES        INT,
    @id_CLINICA      INT,
    @usuario         VARCHAR(50),
    @password        VARCHAR(100),
    @nombre_completo VARCHAR(150),
    @email           VARCHAR(150),
    @id_usuario      TINYINT,
    @id_nuevo        INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @evento VARCHAR(2000);
    DECLARE @salt   VARCHAR(36) = CONVERT(VARCHAR(36), NEWID());
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.USUARIOS(id_ROLES, id_CLINICA, usuario, password_hash, password_salt,
                                   nombre_completo, email, activo, id_usuario_creacion, fecha_creacion)
        VALUES (@id_ROLES, @id_CLINICA, @usuario,
                HASHBYTES('SHA2_512', @password + @salt), @salt,
                @nombre_completo, @email, 1, @id_usuario, GETDATE());
        SET @id_nuevo = SCOPE_IDENTITY();

        SET @evento = 'ALTA USUARIO usuario=' + ISNULL(@usuario,'') + ' id=' + CONVERT(VARCHAR(10), @id_nuevo);
        INSERT INTO citas.LOG VALUES ('USUARIOS','spAltaUsuario','USUARIOS',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        SET @evento = 'ERROR ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('USUARIOS','spAltaUsuario','USUARIOS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioUsuario
    @id_USUARIOS     INT,
    @id_ROLES        INT,
    @id_CLINICA      INT,
    @nombre_completo VARCHAR(150),
    @email           VARCHAR(150),
    @id_usuario      TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.USUARIOS
           SET id_ROLES=@id_ROLES, id_CLINICA=@id_CLINICA,
               nombre_completo=@nombre_completo, email=@email,
               id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_USUARIOS=@id_USUARIOS;
        SET @evento = 'CAMBIO USUARIO id=' + CONVERT(VARCHAR(10), @id_USUARIOS);
        INSERT INTO citas.LOG VALUES ('USUARIOS','spCambioUsuario','USUARIOS',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        SET @evento = 'ERROR ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('USUARIOS','spCambioUsuario','USUARIOS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioPassword
    @id_USUARIOS INT,
    @password    VARCHAR(100),
    @id_usuario  TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @evento VARCHAR(2000);
    DECLARE @salt   VARCHAR(36) = CONVERT(VARCHAR(36), NEWID());
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.USUARIOS
           SET password_hash = HASHBYTES('SHA2_512', @password + @salt),
               password_salt = @salt,
               id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_USUARIOS=@id_USUARIOS;
        SET @evento = 'CAMBIO PASSWORD usuario id=' + CONVERT(VARCHAR(10), @id_USUARIOS);
        INSERT INTO citas.LOG VALUES ('USUARIOS','spCambioPassword','USUARIOS',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        SET @evento = 'ERROR ' + CONVERT(VARCHAR(10), ERROR_NUMBER()) + ' - ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('USUARIOS','spCambioPassword','USUARIOS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spBajaUsuario      @id_USUARIOS INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.USUARIOS SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_USUARIOS=@id_USUARIOS;
        SET @evento='BAJA LOGICA USUARIO id='+CONVERT(VARCHAR(10),@id_USUARIOS);
        INSERT INTO citas.LOG VALUES ('USUARIOS','spBajaUsuario','USUARIOS',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('USUARIOS','spBajaUsuario','USUARIOS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spActivaUsuario    @id_USUARIOS INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.USUARIOS SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_USUARIOS=@id_USUARIOS;
        SET @evento='ACTIVA USUARIO id='+CONVERT(VARCHAR(10),@id_USUARIOS);
        INSERT INTO citas.LOG VALUES ('USUARIOS','spActivaUsuario','USUARIOS',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('USUARIOS','spActivaUsuario','USUARIOS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spDesactivaUsuario @id_USUARIOS INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.USUARIOS SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_USUARIOS=@id_USUARIOS;
        SET @evento='DESACTIVA USUARIO id='+CONVERT(VARCHAR(10),@id_USUARIOS);
        INSERT INTO citas.LOG VALUES ('USUARIOS','spDesactivaUsuario','USUARIOS',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('USUARIOS','spDesactivaUsuario','USUARIOS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaUsuarios AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.id_USUARIOS, u.usuario, u.nombre_completo, u.email, u.activo,
           u.id_ROLES, r.nombre AS rol, u.id_CLINICA
    FROM citas.USUARIOS u INNER JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
    ORDER BY u.usuario;
END
GO

/* ---------- 8.4 Helper: macro para CRUD de catalogos simples ----------
   Se replica el patron para cada catalogo: Alta, Cambio, Regresa.
   ---------------------------------------------------------------------- */

/* ----- CATALOGO_PAIS ----- */
IF OBJECT_ID('citas.spAltaPais','P')     IS NOT NULL DROP PROCEDURE citas.spAltaPais;
IF OBJECT_ID('citas.spCambioPais','P')   IS NOT NULL DROP PROCEDURE citas.spCambioPais;
IF OBJECT_ID('citas.spRegresaPaises','P')IS NOT NULL DROP PROCEDURE citas.spRegresaPaises;
GO
CREATE PROCEDURE citas.spAltaPais @nombre VARCHAR(80), @id_usuario TINYINT, @id_nuevo INT OUTPUT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.CATALOGO_PAIS(nombre,id_usuario_creacion,fecha_creacion) VALUES (@nombre,@id_usuario,GETDATE());
        SET @id_nuevo = SCOPE_IDENTITY();
        SET @evento='ALTA PAIS '+ISNULL(@nombre,'')+' id='+CONVERT(VARCHAR(10),@id_nuevo);
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaPais','CATALOGO_PAIS',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaPais','CATALOGO_PAIS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioPais @id_CATALOGO_PAIS INT, @nombre VARCHAR(80), @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.CATALOGO_PAIS SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_CATALOGO_PAIS=@id_CATALOGO_PAIS;
        SET @evento='CAMBIO PAIS id='+CONVERT(VARCHAR(10),@id_CATALOGO_PAIS);
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioPais','CATALOGO_PAIS',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioPais','CATALOGO_PAIS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaPaises AS BEGIN SET NOCOUNT ON; SELECT id_CATALOGO_PAIS, nombre FROM citas.CATALOGO_PAIS ORDER BY nombre; END
GO

/* ----- CATALOGO_ESTADOS ----- */
IF OBJECT_ID('citas.spAltaEstado','P')    IS NOT NULL DROP PROCEDURE citas.spAltaEstado;
IF OBJECT_ID('citas.spCambioEstado','P')  IS NOT NULL DROP PROCEDURE citas.spCambioEstado;
IF OBJECT_ID('citas.spRegresaEstados','P')IS NOT NULL DROP PROCEDURE citas.spRegresaEstados;
GO
CREATE PROCEDURE citas.spAltaEstado @nombre VARCHAR(80), @id_CATALOGO_PAIS INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.CATALOGO_ESTADOS(nombre,id_CATALOGO_PAIS,id_usuario_creacion,fecha_creacion)
        VALUES (@nombre,@id_CATALOGO_PAIS,@id_usuario,GETDATE());
        SET @id_nuevo=SCOPE_IDENTITY();
        SET @evento='ALTA ESTADO '+ISNULL(@nombre,'')+' pais='+CONVERT(VARCHAR(10),@id_CATALOGO_PAIS);
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaEstado','CATALOGO_ESTADOS',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaEstado','CATALOGO_ESTADOS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioEstado @id_CATALOGO_ESTADOS INT, @nombre VARCHAR(80), @id_CATALOGO_PAIS INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.CATALOGO_ESTADOS
           SET nombre=@nombre, id_CATALOGO_PAIS=@id_CATALOGO_PAIS,
               id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_CATALOGO_ESTADOS=@id_CATALOGO_ESTADOS;
        SET @evento='CAMBIO ESTADO id='+CONVERT(VARCHAR(10),@id_CATALOGO_ESTADOS);
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioEstado','CATALOGO_ESTADOS',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioEstado','CATALOGO_ESTADOS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaEstados @id_CATALOGO_PAIS INT = NULL AS
BEGIN
    SET NOCOUNT ON;
    SELECT e.id_CATALOGO_ESTADOS, e.nombre, e.id_CATALOGO_PAIS, p.nombre AS pais
      FROM citas.CATALOGO_ESTADOS e
      INNER JOIN citas.CATALOGO_PAIS p ON p.id_CATALOGO_PAIS = e.id_CATALOGO_PAIS
     WHERE (@id_CATALOGO_PAIS IS NULL OR e.id_CATALOGO_PAIS = @id_CATALOGO_PAIS)
     ORDER BY e.nombre;
END
GO

/* ----- CATALOGO_ESTADO_CITAS, CATALOGO_GENERO, CATALOGO_ESPECIALIDAD ----- */
IF OBJECT_ID('citas.spAltaEstadoCita','P')      IS NOT NULL DROP PROCEDURE citas.spAltaEstadoCita;
IF OBJECT_ID('citas.spCambioEstadoCita','P')    IS NOT NULL DROP PROCEDURE citas.spCambioEstadoCita;
IF OBJECT_ID('citas.spRegresaEstadosCita','P')  IS NOT NULL DROP PROCEDURE citas.spRegresaEstadosCita;
IF OBJECT_ID('citas.spAltaGenero','P')          IS NOT NULL DROP PROCEDURE citas.spAltaGenero;
IF OBJECT_ID('citas.spCambioGenero','P')        IS NOT NULL DROP PROCEDURE citas.spCambioGenero;
IF OBJECT_ID('citas.spRegresaGeneros','P')      IS NOT NULL DROP PROCEDURE citas.spRegresaGeneros;
IF OBJECT_ID('citas.spAltaEspecialidad','P')    IS NOT NULL DROP PROCEDURE citas.spAltaEspecialidad;
IF OBJECT_ID('citas.spCambioEspecialidad','P')  IS NOT NULL DROP PROCEDURE citas.spCambioEspecialidad;
IF OBJECT_ID('citas.spRegresaEspecialidades','P')IS NOT NULL DROP PROCEDURE citas.spRegresaEspecialidades;
GO
CREATE PROCEDURE citas.spAltaEstadoCita @nombre VARCHAR(50), @id_usuario TINYINT, @id_nuevo INT OUTPUT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.CATALOGO_ESTADO_CITAS(nombre,id_usuario_creacion,fecha_creacion) VALUES (@nombre,@id_usuario,GETDATE());
        SET @id_nuevo=SCOPE_IDENTITY();
        SET @evento='ALTA EST_CITA '+ISNULL(@nombre,'');
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaEstadoCita','CATALOGO_ESTADO_CITAS',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaEstadoCita','CATALOGO_ESTADO_CITAS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioEstadoCita @id_CATALOGO_ESTADO_CITAS INT, @nombre VARCHAR(50), @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.CATALOGO_ESTADO_CITAS SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_CATALOGO_ESTADO_CITAS=@id_CATALOGO_ESTADO_CITAS;
        SET @evento='CAMBIO EST_CITA id='+CONVERT(VARCHAR(10),@id_CATALOGO_ESTADO_CITAS);
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioEstadoCita','CATALOGO_ESTADO_CITAS',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioEstadoCita','CATALOGO_ESTADO_CITAS',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaEstadosCita AS BEGIN SET NOCOUNT ON; SELECT id_CATALOGO_ESTADO_CITAS, nombre FROM citas.CATALOGO_ESTADO_CITAS ORDER BY nombre; END
GO
CREATE PROCEDURE citas.spAltaGenero @nombre VARCHAR(30), @id_usuario TINYINT, @id_nuevo INT OUTPUT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.CATALOGO_GENERO(nombre,id_usuario_creacion,fecha_creacion) VALUES (@nombre,@id_usuario,GETDATE());
        SET @id_nuevo=SCOPE_IDENTITY();
        SET @evento='ALTA GENERO '+ISNULL(@nombre,'');
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaGenero','CATALOGO_GENERO',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaGenero','CATALOGO_GENERO',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioGenero @id_CATALOGO_GENERO INT, @nombre VARCHAR(30), @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.CATALOGO_GENERO SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_CATALOGO_GENERO=@id_CATALOGO_GENERO;
        SET @evento='CAMBIO GENERO id='+CONVERT(VARCHAR(10),@id_CATALOGO_GENERO);
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioGenero','CATALOGO_GENERO',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioGenero','CATALOGO_GENERO',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaGeneros AS BEGIN SET NOCOUNT ON; SELECT id_CATALOGO_GENERO, nombre FROM citas.CATALOGO_GENERO ORDER BY nombre; END
GO
CREATE PROCEDURE citas.spAltaEspecialidad @nombre VARCHAR(100), @id_usuario TINYINT, @id_nuevo INT OUTPUT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.CATALOGO_ESPECIALIDAD(nombre,id_usuario_creacion,fecha_creacion) VALUES (@nombre,@id_usuario,GETDATE());
        SET @id_nuevo=SCOPE_IDENTITY();
        SET @evento='ALTA ESPECIALIDAD '+ISNULL(@nombre,'');
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaEspecialidad','CATALOGO_ESPECIALIDAD',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spAltaEspecialidad','CATALOGO_ESPECIALIDAD',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioEspecialidad @id_CATALOGO_ESPECIALIDAD INT, @nombre VARCHAR(100), @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.CATALOGO_ESPECIALIDAD SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_CATALOGO_ESPECIALIDAD=@id_CATALOGO_ESPECIALIDAD;
        SET @evento='CAMBIO ESPECIALIDAD id='+CONVERT(VARCHAR(10),@id_CATALOGO_ESPECIALIDAD);
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioEspecialidad','CATALOGO_ESPECIALIDAD',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CATALOGOS','spCambioEspecialidad','CATALOGO_ESPECIALIDAD',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaEspecialidades AS BEGIN SET NOCOUNT ON; SELECT id_CATALOGO_ESPECIALIDAD, nombre FROM citas.CATALOGO_ESPECIALIDAD ORDER BY nombre; END
GO

/* ---------- 8.5 CLINICA ---------- */
IF OBJECT_ID('citas.spAltaClinica','P')      IS NOT NULL DROP PROCEDURE citas.spAltaClinica;
IF OBJECT_ID('citas.spCambioClinica','P')    IS NOT NULL DROP PROCEDURE citas.spCambioClinica;
IF OBJECT_ID('citas.spBajaClinica','P')      IS NOT NULL DROP PROCEDURE citas.spBajaClinica;
IF OBJECT_ID('citas.spActivaClinica','P')    IS NOT NULL DROP PROCEDURE citas.spActivaClinica;
IF OBJECT_ID('citas.spDesactivaClinica','P') IS NOT NULL DROP PROCEDURE citas.spDesactivaClinica;
IF OBJECT_ID('citas.spRegresaClinicas','P')  IS NOT NULL DROP PROCEDURE citas.spRegresaClinicas;
GO
CREATE PROCEDURE citas.spAltaClinica
    @nombre VARCHAR(150), @direccion VARCHAR(250), @email VARCHAR(150),
    @telefono VARCHAR(20), @municipio VARCHAR(100), @id_CATALOGO_ESTADOS INT,
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.CLINICA(nombre,direccion,email,telefono,municipio,id_CATALOGO_ESTADOS,activo,id_usuario_creacion,fecha_creacion)
        VALUES (@nombre,@direccion,@email,@telefono,@municipio,@id_CATALOGO_ESTADOS,1,@id_usuario,GETDATE());
        SET @id_nuevo=SCOPE_IDENTITY();
        SET @evento='ALTA CLINICA '+ISNULL(@nombre,'')+' id='+CONVERT(VARCHAR(10),@id_nuevo);
        INSERT INTO citas.LOG VALUES ('CLINICAS','spAltaClinica','CLINICA',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CLINICAS','spAltaClinica','CLINICA',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioClinica
    @id_CLINICA INT, @nombre VARCHAR(150), @direccion VARCHAR(250),
    @email VARCHAR(150), @telefono VARCHAR(20),
    @municipio VARCHAR(100), @id_CATALOGO_ESTADOS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.CLINICA
           SET nombre=@nombre, direccion=@direccion, email=@email, telefono=@telefono,
               municipio=@municipio, id_CATALOGO_ESTADOS=@id_CATALOGO_ESTADOS,
               id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_CLINICA=@id_CLINICA;
        SET @evento='CAMBIO CLINICA id='+CONVERT(VARCHAR(10),@id_CLINICA);
        INSERT INTO citas.LOG VALUES ('CLINICAS','spCambioClinica','CLINICA',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CLINICAS','spCambioClinica','CLINICA',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spBajaClinica      @id_CLINICA INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.CLINICA SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_CLINICA=@id_CLINICA;
        SET @evento='BAJA LOGICA CLINICA id='+CONVERT(VARCHAR(10),@id_CLINICA);
        INSERT INTO citas.LOG VALUES ('CLINICAS','spBajaClinica','CLINICA',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CLINICAS','spBajaClinica','CLINICA',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spActivaClinica    @id_CLINICA INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.CLINICA SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_CLINICA=@id_CLINICA;
        SET @evento='ACTIVA CLINICA id='+CONVERT(VARCHAR(10),@id_CLINICA);
        INSERT INTO citas.LOG VALUES ('CLINICAS','spActivaClinica','CLINICA',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CLINICAS','spActivaClinica','CLINICA',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spDesactivaClinica @id_CLINICA INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.CLINICA SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_CLINICA=@id_CLINICA;
        SET @evento='DESACTIVA CLINICA id='+CONVERT(VARCHAR(10),@id_CLINICA);
        INSERT INTO citas.LOG VALUES ('CLINICAS','spDesactivaClinica','CLINICA',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CLINICAS','spDesactivaClinica','CLINICA',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaClinicas AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.id_CLINICA, c.nombre, c.direccion, c.email, c.telefono, c.municipio,
           c.id_CATALOGO_ESTADOS, e.nombre AS estado, c.activo
    FROM   citas.CLINICA c
    INNER JOIN citas.CATALOGO_ESTADOS e ON e.id_CATALOGO_ESTADOS = c.id_CATALOGO_ESTADOS
    ORDER BY c.nombre;
END
GO

/* ---------- 8.6 CONSULTORIO ---------- */
IF OBJECT_ID('citas.spAltaConsultorio','P')     IS NOT NULL DROP PROCEDURE citas.spAltaConsultorio;
IF OBJECT_ID('citas.spCambioConsultorio','P')   IS NOT NULL DROP PROCEDURE citas.spCambioConsultorio;
IF OBJECT_ID('citas.spBajaConsultorio','P')     IS NOT NULL DROP PROCEDURE citas.spBajaConsultorio;
IF OBJECT_ID('citas.spRegresaConsultorios','P') IS NOT NULL DROP PROCEDURE citas.spRegresaConsultorios;
GO
CREATE PROCEDURE citas.spAltaConsultorio @id_CLINICA INT, @nombre VARCHAR(100), @id_usuario TINYINT, @id_nuevo INT OUTPUT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.CONSULTORIO(id_CLINICA,nombre,activo,id_usuario_creacion,fecha_creacion)
        VALUES (@id_CLINICA,@nombre,1,@id_usuario,GETDATE());
        SET @id_nuevo=SCOPE_IDENTITY();
        SET @evento='ALTA CONSULTORIO clinica='+CONVERT(VARCHAR(10),@id_CLINICA)+' nombre='+ISNULL(@nombre,'');
        INSERT INTO citas.LOG VALUES ('CONSULTORIOS','spAltaConsultorio','CONSULTORIO',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CONSULTORIOS','spAltaConsultorio','CONSULTORIO',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioConsultorio @id_CONSULTORIO INT, @id_CLINICA INT, @nombre VARCHAR(100), @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.CONSULTORIO
           SET id_CLINICA=@id_CLINICA, nombre=@nombre,
               id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_CONSULTORIO=@id_CONSULTORIO;
        SET @evento='CAMBIO CONSULTORIO id='+CONVERT(VARCHAR(10),@id_CONSULTORIO);
        INSERT INTO citas.LOG VALUES ('CONSULTORIOS','spCambioConsultorio','CONSULTORIO',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CONSULTORIOS','spCambioConsultorio','CONSULTORIO',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spBajaConsultorio @id_CONSULTORIO INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.CONSULTORIO SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_CONSULTORIO=@id_CONSULTORIO;
        SET @evento='BAJA CONSULTORIO id='+CONVERT(VARCHAR(10),@id_CONSULTORIO);
        INSERT INTO citas.LOG VALUES ('CONSULTORIOS','spBajaConsultorio','CONSULTORIO',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CONSULTORIOS','spBajaConsultorio','CONSULTORIO',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaConsultorios @id_CLINICA INT = NULL AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_CONSULTORIO, id_CLINICA, nombre, activo
      FROM citas.CONSULTORIO
     WHERE (@id_CLINICA IS NULL OR id_CLINICA=@id_CLINICA)
     ORDER BY nombre;
END
GO

/* ---------- 8.7 MEDICO ---------- */
IF OBJECT_ID('citas.spAltaMedico','P')     IS NOT NULL DROP PROCEDURE citas.spAltaMedico;
IF OBJECT_ID('citas.spCambioMedico','P')   IS NOT NULL DROP PROCEDURE citas.spCambioMedico;
IF OBJECT_ID('citas.spBajaMedico','P')     IS NOT NULL DROP PROCEDURE citas.spBajaMedico;
IF OBJECT_ID('citas.spRegresaMedicos','P') IS NOT NULL DROP PROCEDURE citas.spRegresaMedicos;
GO
CREATE PROCEDURE citas.spAltaMedico @nombre_completo VARCHAR(150), @id_usuario TINYINT, @id_nuevo INT OUTPUT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.MEDICO(nombre_completo,activo,id_usuario_creacion,fecha_creacion)
        VALUES (@nombre_completo,1,@id_usuario,GETDATE());
        SET @id_nuevo=SCOPE_IDENTITY();
        SET @evento='ALTA MEDICO '+ISNULL(@nombre_completo,'');
        INSERT INTO citas.LOG VALUES ('MEDICOS','spAltaMedico','MEDICO',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('MEDICOS','spAltaMedico','MEDICO',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioMedico @id_MEDICO INT, @nombre_completo VARCHAR(150), @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.MEDICO SET nombre_completo=@nombre_completo, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_MEDICO=@id_MEDICO;
        SET @evento='CAMBIO MEDICO id='+CONVERT(VARCHAR(10),@id_MEDICO);
        INSERT INTO citas.LOG VALUES ('MEDICOS','spCambioMedico','MEDICO',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('MEDICOS','spCambioMedico','MEDICO',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spBajaMedico @id_MEDICO INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        UPDATE citas.MEDICO SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_MEDICO=@id_MEDICO;
        SET @evento='BAJA MEDICO id='+CONVERT(VARCHAR(10),@id_MEDICO);
        INSERT INTO citas.LOG VALUES ('MEDICOS','spBajaMedico','MEDICO',@evento,GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('MEDICOS','spBajaMedico','MEDICO',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaMedicos AS BEGIN SET NOCOUNT ON; SELECT id_MEDICO, nombre_completo, activo FROM citas.MEDICO ORDER BY nombre_completo; END
GO

/* ---------- 8.8 PACIENTE ---------- */
IF OBJECT_ID('citas.spAltaPaciente','P')     IS NOT NULL DROP PROCEDURE citas.spAltaPaciente;
IF OBJECT_ID('citas.spCambioPaciente','P')   IS NOT NULL DROP PROCEDURE citas.spCambioPaciente;
IF OBJECT_ID('citas.spBajaPaciente','P')     IS NOT NULL DROP PROCEDURE citas.spBajaPaciente;
IF OBJECT_ID('citas.spRegresaPacientes','P') IS NOT NULL DROP PROCEDURE citas.spRegresaPacientes;
GO
CREATE PROCEDURE citas.spAltaPaciente
    @id_CLINICA INT, @ap_paterno VARCHAR(80), @ap_materno VARCHAR(80), @nombre VARCHAR(80),
    @direccion VARCHAR(250), @telefono VARCHAR(20), @email VARCHAR(150),
    @fecha_nacimiento DATE, @id_CATALOGO_GENERO INT, @municipio VARCHAR(100),
    @id_CATALOGO_ESTADOS INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.PACIENTE(id_CLINICA,ap_paterno,ap_materno,nombre,direccion,telefono,email,
                                   fecha_nacimiento,id_CATALOGO_GENERO,municipio,id_CATALOGO_ESTADOS,
                                   id_usuario_creacion,fecha_creacion)
        VALUES (@id_CLINICA,@ap_paterno,@ap_materno,@nombre,@direccion,@telefono,@email,
                @fecha_nacimiento,@id_CATALOGO_GENERO,@municipio,@id_CATALOGO_ESTADOS,
                @id_usuario,GETDATE());
        SET @id_nuevo=SCOPE_IDENTITY();
        SET @evento='ALTA PACIENTE '+ISNULL(@ap_paterno,'')+' '+ISNULL(@nombre,'')+' clinica='+CONVERT(VARCHAR(10),@id_CLINICA);
        INSERT INTO citas.LOG VALUES ('PACIENTES','spAltaPaciente','PACIENTE',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('PACIENTES','spAltaPaciente','PACIENTE',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioPaciente
    @id_PACIENTE INT, @ap_paterno VARCHAR(80), @ap_materno VARCHAR(80), @nombre VARCHAR(80),
    @direccion VARCHAR(250), @telefono VARCHAR(20), @email VARCHAR(150),
    @fecha_nacimiento DATE, @id_CATALOGO_GENERO INT, @municipio VARCHAR(100),
    @id_CATALOGO_ESTADOS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.PACIENTE
           SET ap_paterno=@ap_paterno, ap_materno=@ap_materno, nombre=@nombre,
               direccion=@direccion, telefono=@telefono, email=@email,
               fecha_nacimiento=@fecha_nacimiento, id_CATALOGO_GENERO=@id_CATALOGO_GENERO,
               municipio=@municipio, id_CATALOGO_ESTADOS=@id_CATALOGO_ESTADOS,
               id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_PACIENTE=@id_PACIENTE;
        SET @evento='CAMBIO PACIENTE id='+CONVERT(VARCHAR(10),@id_PACIENTE);
        INSERT INTO citas.LOG VALUES ('PACIENTES','spCambioPaciente','PACIENTE',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('PACIENTES','spCambioPaciente','PACIENTE',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spBajaPaciente @id_PACIENTE INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        DELETE FROM citas.PACIENTE WHERE id_PACIENTE=@id_PACIENTE;
        SET @evento='BAJA PACIENTE id='+CONVERT(VARCHAR(10),@id_PACIENTE);
        INSERT INTO citas.LOG VALUES ('PACIENTES','spBajaPaciente','PACIENTE',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('PACIENTES','spBajaPaciente','PACIENTE',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaPacientes @id_CLINICA INT = NULL AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_PACIENTE, id_CLINICA, ap_paterno, ap_materno, nombre, direccion,
           telefono, email, fecha_nacimiento, id_CATALOGO_GENERO, municipio, id_CATALOGO_ESTADOS
      FROM citas.PACIENTE
     WHERE (@id_CLINICA IS NULL OR id_CLINICA=@id_CLINICA)
     ORDER BY ap_paterno, ap_materno, nombre;
END
GO

/* ---------- 8.9 CITA ---------- */
IF OBJECT_ID('citas.spAltaCita','P')         IS NOT NULL DROP PROCEDURE citas.spAltaCita;
IF OBJECT_ID('citas.spCambioCita','P')       IS NOT NULL DROP PROCEDURE citas.spCambioCita;
IF OBJECT_ID('citas.spCancelaCita','P')      IS NOT NULL DROP PROCEDURE citas.spCancelaCita;
IF OBJECT_ID('citas.spRegresaCitas','P')     IS NOT NULL DROP PROCEDURE citas.spRegresaCitas;
GO
CREATE PROCEDURE citas.spAltaCita
    @id_PACIENTE INT, @id_MEDICO INT, @id_CONSULTORIO INT, @id_CATALOGO_ESPECIALIDAD INT,
    @fecha_cita DATE, @hora_inicio TIME(0), @hora_fin TIME(0),
    @id_CATALOGO_ESTADO_CITAS INT, @observaciones VARCHAR(500),
    @notifica_email BIT, @notifica_wa BIT,
    @email_notif VARCHAR(150), @celular_notif VARCHAR(20),
    @horas_anticipacion_notif TINYINT, @precio DECIMAL(10,2),
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.CITA(id_PACIENTE,id_MEDICO,id_CONSULTORIO,id_CATALOGO_ESPECIALIDAD,
                               fecha_cita,hora_inicio,hora_fin,id_CATALOGO_ESTADO_CITAS,
                               observaciones,notifica_email,notifica_wa,email_notif,celular_notif,
                               horas_anticipacion_notif,precio,id_usuario_creacion,fecha_creacion)
        VALUES (@id_PACIENTE,@id_MEDICO,@id_CONSULTORIO,@id_CATALOGO_ESPECIALIDAD,
                @fecha_cita,@hora_inicio,@hora_fin,@id_CATALOGO_ESTADO_CITAS,
                @observaciones,@notifica_email,@notifica_wa,@email_notif,@celular_notif,
                @horas_anticipacion_notif,@precio,@id_usuario,GETDATE());
        SET @id_nuevo=SCOPE_IDENTITY();
        SET @evento='ALTA CITA paciente='+CONVERT(VARCHAR(10),@id_PACIENTE)
                  + ' medico='+CONVERT(VARCHAR(10),@id_MEDICO)
                  + ' fecha='+CONVERT(VARCHAR(10),@fecha_cita,120);
        INSERT INTO citas.LOG VALUES ('CITAS','spAltaCita','CITA',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CITAS','spAltaCita','CITA',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCambioCita
    @id_CITA INT, @id_PACIENTE INT, @id_MEDICO INT, @id_CONSULTORIO INT,
    @id_CATALOGO_ESPECIALIDAD INT, @fecha_cita DATE, @hora_inicio TIME(0), @hora_fin TIME(0),
    @id_CATALOGO_ESTADO_CITAS INT, @observaciones VARCHAR(500),
    @notifica_email BIT, @notifica_wa BIT,
    @email_notif VARCHAR(150), @celular_notif VARCHAR(20),
    @horas_anticipacion_notif TINYINT, @precio DECIMAL(10,2), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.CITA
           SET id_PACIENTE=@id_PACIENTE, id_MEDICO=@id_MEDICO, id_CONSULTORIO=@id_CONSULTORIO,
               id_CATALOGO_ESPECIALIDAD=@id_CATALOGO_ESPECIALIDAD,
               fecha_cita=@fecha_cita, hora_inicio=@hora_inicio, hora_fin=@hora_fin,
               id_CATALOGO_ESTADO_CITAS=@id_CATALOGO_ESTADO_CITAS,
               observaciones=@observaciones, notifica_email=@notifica_email,
               notifica_wa=@notifica_wa, email_notif=@email_notif, celular_notif=@celular_notif,
               horas_anticipacion_notif=@horas_anticipacion_notif, precio=@precio,
               id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_CITA=@id_CITA;
        SET @evento='CAMBIO CITA id='+CONVERT(VARCHAR(10),@id_CITA);
        INSERT INTO citas.LOG VALUES ('CITAS','spCambioCita','CITA',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CITAS','spCambioCita','CITA',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spCancelaCita @id_CITA INT, @id_CATALOGO_ESTADO_CITAS INT, @id_usuario TINYINT AS
BEGIN
    SET NOCOUNT ON; DECLARE @evento VARCHAR(2000);
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.CITA SET id_CATALOGO_ESTADO_CITAS=@id_CATALOGO_ESTADO_CITAS,
                              id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_CITA=@id_CITA;
        SET @evento='CANCELA CITA id='+CONVERT(VARCHAR(10),@id_CITA);
        INSERT INTO citas.LOG VALUES ('CITAS','spCancelaCita','CITA',@evento,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        SET @evento='ERROR '+CONVERT(VARCHAR(10),ERROR_NUMBER())+' - '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES ('CITAS','spCancelaCita','CITA',LEFT(@evento,2000),GETDATE(),@id_usuario);
        ;THROW;
    END CATCH
END
GO
CREATE PROCEDURE citas.spRegresaCitas
    @id_MEDICO INT = NULL, @fecha_desde DATE = NULL, @fecha_hasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.id_CITA, c.fecha_cita, c.hora_inicio, c.hora_fin,
           c.id_PACIENTE, p.ap_paterno + ' ' + ISNULL(p.ap_materno,'') + ' ' + p.nombre AS paciente,
           c.id_MEDICO, m.nombre_completo AS medico,
           c.id_CONSULTORIO, co.nombre AS consultorio,
           c.id_CATALOGO_ESPECIALIDAD, e.nombre AS especialidad,
           c.id_CATALOGO_ESTADO_CITAS, ec.nombre AS estado,
           c.precio, c.observaciones, c.notifica_email, c.notifica_wa,
           c.email_notif, c.celular_notif, c.horas_anticipacion_notif
    FROM citas.CITA c
    INNER JOIN citas.PACIENTE p              ON p.id_PACIENTE = c.id_PACIENTE
    INNER JOIN citas.MEDICO m                ON m.id_MEDICO = c.id_MEDICO
    INNER JOIN citas.CONSULTORIO co          ON co.id_CONSULTORIO = c.id_CONSULTORIO
    INNER JOIN citas.CATALOGO_ESPECIALIDAD e ON e.id_CATALOGO_ESPECIALIDAD = c.id_CATALOGO_ESPECIALIDAD
    INNER JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_CATALOGO_ESTADO_CITAS = c.id_CATALOGO_ESTADO_CITAS
    WHERE (@id_MEDICO   IS NULL OR c.id_MEDICO   = @id_MEDICO)
      AND (@fecha_desde IS NULL OR c.fecha_cita >= @fecha_desde)
      AND (@fecha_hasta IS NULL OR c.fecha_cita <= @fecha_hasta)
    ORDER BY c.fecha_cita, c.hora_inicio;
END
GO

/* =====================================================================
   9. VISTAS
   ===================================================================== */
IF OBJECT_ID('citas.vwCitasDelDia','V')      IS NOT NULL DROP VIEW citas.vwCitasDelDia;
IF OBJECT_ID('citas.vwMedicosPorClinica','V')IS NOT NULL DROP VIEW citas.vwMedicosPorClinica;
IF OBJECT_ID('citas.vwIngresosPorMedico','V')IS NOT NULL DROP VIEW citas.vwIngresosPorMedico;
GO
CREATE VIEW citas.vwCitasDelDia AS
SELECT c.id_CITA, c.fecha_cita, c.hora_inicio, c.hora_fin,
       p.ap_paterno + ' ' + ISNULL(p.ap_materno,'') + ' ' + p.nombre AS paciente,
       m.nombre_completo AS medico, co.nombre AS consultorio,
       e.nombre AS especialidad, ec.nombre AS estado, c.precio
FROM citas.CITA c
INNER JOIN citas.PACIENTE p ON p.id_PACIENTE = c.id_PACIENTE
INNER JOIN citas.MEDICO m ON m.id_MEDICO = c.id_MEDICO
INNER JOIN citas.CONSULTORIO co ON co.id_CONSULTORIO = c.id_CONSULTORIO
INNER JOIN citas.CATALOGO_ESPECIALIDAD e ON e.id_CATALOGO_ESPECIALIDAD = c.id_CATALOGO_ESPECIALIDAD
INNER JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_CATALOGO_ESTADO_CITAS = c.id_CATALOGO_ESTADO_CITAS
WHERE c.fecha_cita = CAST(GETDATE() AS DATE);
GO
CREATE VIEW citas.vwMedicosPorClinica AS
SELECT DISTINCT cl.id_CLINICA, cl.nombre AS clinica, m.id_MEDICO, m.nombre_completo AS medico
FROM citas.CLINICA cl
INNER JOIN citas.CONSULTORIO co ON co.id_CLINICA = cl.id_CLINICA
INNER JOIN citas.MEDICO_CONSULTORIO mc ON mc.id_CONSULTORIO = co.id_CONSULTORIO
INNER JOIN citas.MEDICO m ON m.id_MEDICO = mc.id_MEDICO;
GO
CREATE VIEW citas.vwIngresosPorMedico AS
SELECT c.id_MEDICO, m.nombre_completo AS medico,
       CONVERT(VARCHAR(7), c.fecha_cita, 120) AS periodo,
       SUM(c.precio) AS total
FROM citas.CITA c
INNER JOIN citas.MEDICO m ON m.id_MEDICO = c.id_MEDICO
INNER JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_CATALOGO_ESTADO_CITAS = c.id_CATALOGO_ESTADO_CITAS
WHERE ec.nombre IN ('Atendida','Confirmada')
GROUP BY c.id_MEDICO, m.nombre_completo, CONVERT(VARCHAR(7), c.fecha_cita, 120);
GO

/* =====================================================================
   10. DATOS SEMILLA
   ===================================================================== */
-- Roles
DECLARE @id INT;
EXEC citas.spAltaRol 'admin_sistema',    'Administrador del sistema (global)', 0, @id OUTPUT;
EXEC citas.spAltaRol 'administrador',    'Administrador de clinica',           0, @id OUTPUT;
EXEC citas.spAltaRol 'medico',           'Medico',                              0, @id OUTPUT;
EXEC citas.spAltaRol 'asistente',        'Asistente de clinica',                0, @id OUTPUT;
GO

-- Catalogos
DECLARE @id INT;
EXEC citas.spAltaPais 'Mexico', 0, @id OUTPUT;
DECLARE @id_pais INT = (SELECT id_CATALOGO_PAIS FROM citas.CATALOGO_PAIS WHERE nombre='Mexico');
EXEC citas.spAltaEstado 'Puebla',      @id_pais, 0, @id OUTPUT;
EXEC citas.spAltaEstado 'CDMX',        @id_pais, 0, @id OUTPUT;
EXEC citas.spAltaEstado 'Tlaxcala',    @id_pais, 0, @id OUTPUT;
EXEC citas.spAltaGenero 'Masculino', 0, @id OUTPUT;
EXEC citas.spAltaGenero 'Femenino',  0, @id OUTPUT;
EXEC citas.spAltaGenero 'Otro',      0, @id OUTPUT;
EXEC citas.spAltaEstadoCita 'Agendada',    0, @id OUTPUT;
EXEC citas.spAltaEstadoCita 'Confirmada',  0, @id OUTPUT;
EXEC citas.spAltaEstadoCita 'Cancelada',   0, @id OUTPUT;
EXEC citas.spAltaEstadoCita 'Atendida',    0, @id OUTPUT;
EXEC citas.spAltaEstadoCita 'No asistio',  0, @id OUTPUT;
EXEC citas.spAltaEspecialidad 'Medicina General', 0, @id OUTPUT;
EXEC citas.spAltaEspecialidad 'Pediatria',        0, @id OUTPUT;
EXEC citas.spAltaEspecialidad 'Ginecologia',      0, @id OUTPUT;
EXEC citas.spAltaEspecialidad 'Cardiologia',      0, @id OUTPUT;
GO

-- Usuarios de prueba (passwords se cifran dentro del SP)
DECLARE @id INT;
DECLARE @id_rol_admsis  INT = (SELECT id_ROLES FROM citas.ROLES WHERE nombre='admin_sistema');
DECLARE @id_rol_admin   INT = (SELECT id_ROLES FROM citas.ROLES WHERE nombre='administrador');
DECLARE @id_rol_medico  INT = (SELECT id_ROLES FROM citas.ROLES WHERE nombre='medico');
DECLARE @id_rol_asist   INT = (SELECT id_ROLES FROM citas.ROLES WHERE nombre='asistente');

EXEC citas.spAltaUsuario @id_rol_admsis, NULL, 'adminMaster', 'adminMaster1', 'Victor Puig Morales',     'admin.master@policlinica.local', 0, @id OUTPUT;
EXEC citas.spAltaUsuario @id_rol_admin,  NULL, 'admin',       'admin1',       'Juan Lopez',              'admin@policlinica.local',        0, @id OUTPUT;
EXEC citas.spAltaUsuario @id_rol_medico, NULL, 'medico',      'medico1',      'Estefano Lopez Hamill',   'medico@policlinica.local',       0, @id OUTPUT;
EXEC citas.spAltaUsuario @id_rol_asist,  NULL, 'asistente',   'asistente1',   'Maria Fernanda Canales',  'asistente@policlinica.local',    0, @id OUTPUT;
GO

PRINT '=== Script ejecutado correctamente ===';
GO