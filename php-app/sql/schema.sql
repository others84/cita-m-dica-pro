/* =====================================================================
   Sistema POLICLINICA - Citas Medicas
   Motor: Microsoft SQL Server 2022 Express Edition
   Base de datos: CitasMedicas
   Esquema: citas
   Usuario aplicativo: citasadmin / admin01$
   Acceso a tablas: SOLO a traves de procedimientos almacenados (SPs)
   ===================================================================== */

/* ---------- 1. Crear base de datos ---------- */
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

/* ---------- 2. Login y usuario ---------- */
USE master;
GO
IF SUSER_ID('citasadmin') IS NOT NULL
    DROP LOGIN citasadmin;
GO
CREATE LOGIN citasadmin
    WITH PASSWORD = 'admin01$',
         CHECK_POLICY = OFF,
         DEFAULT_DATABASE = CitasMedicas;
GO

USE CitasMedicas;
GO
IF USER_ID('citasadmin') IS NOT NULL
    DROP USER citasadmin;
GO

/* ---------- 3. Esquema citas ---------- */
IF SCHEMA_ID('citas') IS NULL
    EXEC('CREATE SCHEMA citas AUTHORIZATION dbo');
GO

CREATE USER citasadmin FOR LOGIN citasadmin WITH DEFAULT_SCHEMA = citas;
GO

ALTER AUTHORIZATION ON SCHEMA::citas TO citasadmin;
GO

/* =====================================================================
   4. TABLAS
   Convenciones:
     - PK : PK_id_<tabla>
     - FK : FK_<col_pk>_<TABLA_PK>_<col_fk>_<TABLA_FK>
     - CHK: CHK_<campo>_<TABLA>
     - IX : IX_<campo(s)>_<TABLA>
     - Auditoria al final: id_usuario_creacion, fecha_creacion,
                           id_usuario_modificacion, fecha_modificacion
   ===================================================================== */

/* ---------- 4.1 LOG (sin auditoria) ---------- */
CREATE TABLE citas.LOG (
    id_log         INT IDENTITY(1,1) NOT NULL,
    modulo         VARCHAR(30)   NOT NULL,
    procedimiento  VARCHAR(300)  NOT NULL,
    tabla          VARCHAR(50)   NOT NULL,
    evento         VARCHAR(2000) NOT NULL,
    fecha          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_LOG DEFAULT (GETDATE()),
    id_usuario     TINYINT       NOT NULL,
    CONSTRAINT PK_id_log PRIMARY KEY CLUSTERED (id_log)
);
GO

/* ---------- 4.2 ROLES ---------- */
CREATE TABLE citas.ROLES (
    id_roles       INT IDENTITY(1,1) NOT NULL,
    nombre         VARCHAR(50)  NOT NULL,
    descripcion    VARCHAR(150) NULL,
    activo         BIT NOT NULL CONSTRAINT DF_activo_ROLES DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_ROLES DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_roles PRIMARY KEY CLUSTERED (id_roles),
    CONSTRAINT CHK_activo_ROLES CHECK (activo IN (0,1))
);
GO
CREATE UNIQUE INDEX IX_nombre_ROLES ON citas.ROLES(nombre);
GO

/* ---------- 4.3 CATALOGO_PAIS ---------- */
CREATE TABLE citas.CATALOGO_PAIS (
    id_catalogo_pais INT IDENTITY(1,1) NOT NULL,
    nombre           VARCHAR(80) NOT NULL,
    activo           BIT NOT NULL CONSTRAINT DF_activo_CATALOGO_PAIS DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_CATALOGO_PAIS DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_catalogo_pais PRIMARY KEY CLUSTERED (id_catalogo_pais),
    CONSTRAINT CHK_activo_CATALOGO_PAIS CHECK (activo IN (0,1))
);
GO
CREATE UNIQUE INDEX IX_nombre_CATALOGO_PAIS ON citas.CATALOGO_PAIS(nombre);
GO

/* ---------- 4.4 CATALOGO_ESTADOS ---------- */
CREATE TABLE citas.CATALOGO_ESTADOS (
    id_catalogo_estados INT IDENTITY(1,1) NOT NULL,
    nombre              VARCHAR(80) NOT NULL,
    id_catalogo_pais    INT NOT NULL,
    activo              BIT NOT NULL CONSTRAINT DF_activo_CATALOGO_ESTADOS DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_CATALOGO_ESTADOS DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_catalogo_estados PRIMARY KEY CLUSTERED (id_catalogo_estados),
    CONSTRAINT CHK_activo_CATALOGO_ESTADOS CHECK (activo IN (0,1)),
    CONSTRAINT FK_id_catalogo_pais_CATALOGO_PAIS_id_catalogo_pais_CATALOGO_ESTADOS
        FOREIGN KEY (id_catalogo_pais) REFERENCES citas.CATALOGO_PAIS(id_catalogo_pais)
);
GO
CREATE UNIQUE INDEX IX_nombre_id_catalogo_pais_CATALOGO_ESTADOS
    ON citas.CATALOGO_ESTADOS(nombre, id_catalogo_pais);
GO

/* ---------- 4.5 CATALOGO_ESTADO_CITAS ---------- */
CREATE TABLE citas.CATALOGO_ESTADO_CITAS (
    id_catalogo_estado_citas INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(50) NOT NULL,
    activo                   BIT NOT NULL CONSTRAINT DF_activo_CATALOGO_ESTADO_CITAS DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_CATALOGO_ESTADO_CITAS DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_catalogo_estado_citas PRIMARY KEY CLUSTERED (id_catalogo_estado_citas),
    CONSTRAINT CHK_activo_CATALOGO_ESTADO_CITAS CHECK (activo IN (0,1))
);
GO
CREATE UNIQUE INDEX IX_nombre_CATALOGO_ESTADO_CITAS ON citas.CATALOGO_ESTADO_CITAS(nombre);
GO

/* ---------- 4.6 CATALOGO_GENERO ---------- */
CREATE TABLE citas.CATALOGO_GENERO (
    id_catalogo_genero INT IDENTITY(1,1) NOT NULL,
    nombre             VARCHAR(30) NOT NULL,
    activo             BIT NOT NULL CONSTRAINT DF_activo_CATALOGO_GENERO DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_CATALOGO_GENERO DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_catalogo_genero PRIMARY KEY CLUSTERED (id_catalogo_genero),
    CONSTRAINT CHK_activo_CATALOGO_GENERO CHECK (activo IN (0,1))
);
GO
CREATE UNIQUE INDEX IX_nombre_CATALOGO_GENERO ON citas.CATALOGO_GENERO(nombre);
GO

/* ---------- 4.7 CATALOGO_ESPECIALIDAD ---------- */
CREATE TABLE citas.CATALOGO_ESPECIALIDAD (
    id_catalogo_especialidad INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(100) NOT NULL,
    activo                   BIT NOT NULL CONSTRAINT DF_activo_CATALOGO_ESPECIALIDAD DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_CATALOGO_ESPECIALIDAD DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_catalogo_especialidad PRIMARY KEY CLUSTERED (id_catalogo_especialidad),
    CONSTRAINT CHK_activo_CATALOGO_ESPECIALIDAD CHECK (activo IN (0,1))
);
GO
CREATE UNIQUE INDEX IX_nombre_CATALOGO_ESPECIALIDAD ON citas.CATALOGO_ESPECIALIDAD(nombre);
GO

/* ---------- 4.8 CLINICA ---------- */
CREATE TABLE citas.CLINICA (
    id_clinica          INT IDENTITY(1,1) NOT NULL,
    nombre              VARCHAR(120) NOT NULL,
    direccion           VARCHAR(250) NOT NULL,
    email               VARCHAR(120) NULL,
    telefono            VARCHAR(20)  NULL,
    municipio           VARCHAR(100) NOT NULL,
    id_catalogo_estados INT NOT NULL,
    activo              BIT NOT NULL CONSTRAINT DF_activo_CLINICA DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_CLINICA DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_clinica PRIMARY KEY CLUSTERED (id_clinica),
    CONSTRAINT CHK_activo_CLINICA CHECK (activo IN (0,1)),
    CONSTRAINT CHK_email_CLINICA CHECK (email IS NULL OR email LIKE '%_@_%._%'),
    CONSTRAINT FK_id_catalogo_estados_CATALOGO_ESTADOS_id_catalogo_estados_CLINICA
        FOREIGN KEY (id_catalogo_estados) REFERENCES citas.CATALOGO_ESTADOS(id_catalogo_estados)
);
GO
CREATE UNIQUE INDEX IX_nombre_CLINICA ON citas.CLINICA(nombre);
GO

/* ---------- 4.9 USUARIOS ---------- */
CREATE TABLE citas.USUARIOS (
    id_usuarios     INT IDENTITY(1,1) NOT NULL,
    id_roles        INT NOT NULL,
    id_clinica      INT NULL,
    usuario         VARCHAR(50)  NOT NULL,
    password_hash   VARBINARY(64) NOT NULL,
    password_salt   VARBINARY(32) NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    email           VARCHAR(120) NULL,
    activo          BIT NOT NULL CONSTRAINT DF_activo_USUARIOS DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_USUARIOS DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_usuarios PRIMARY KEY CLUSTERED (id_usuarios),
    CONSTRAINT CHK_activo_USUARIOS CHECK (activo IN (0,1)),
    CONSTRAINT CHK_email_USUARIOS CHECK (email IS NULL OR email LIKE '%_@_%._%'),
    CONSTRAINT FK_id_roles_ROLES_id_roles_USUARIOS
        FOREIGN KEY (id_roles) REFERENCES citas.ROLES(id_roles),
    CONSTRAINT FK_id_clinica_CLINICA_id_clinica_USUARIOS
        FOREIGN KEY (id_clinica) REFERENCES citas.CLINICA(id_clinica)
);
GO
CREATE UNIQUE INDEX IX_usuario_USUARIOS ON citas.USUARIOS(usuario);
GO

/* ---------- 4.10 CONSULTORIO ---------- */
CREATE TABLE citas.CONSULTORIO (
    id_consultorio INT IDENTITY(1,1) NOT NULL,
    id_clinica     INT NOT NULL,
    nombre         VARCHAR(80) NOT NULL,
    activo         BIT NOT NULL CONSTRAINT DF_activo_CONSULTORIO DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_CONSULTORIO DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_consultorio PRIMARY KEY CLUSTERED (id_consultorio),
    CONSTRAINT CHK_activo_CONSULTORIO CHECK (activo IN (0,1)),
    CONSTRAINT FK_id_clinica_CLINICA_id_clinica_CONSULTORIO
        FOREIGN KEY (id_clinica) REFERENCES citas.CLINICA(id_clinica)
);
GO
CREATE UNIQUE INDEX IX_id_clinica_nombre_CONSULTORIO ON citas.CONSULTORIO(id_clinica, nombre);
GO

/* ---------- 4.11 MEDICO ---------- */
CREATE TABLE citas.MEDICO (
    id_medico       INT IDENTITY(1,1) NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    activo          BIT NOT NULL CONSTRAINT DF_activo_MEDICO DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_MEDICO DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_medico PRIMARY KEY CLUSTERED (id_medico),
    CONSTRAINT CHK_activo_MEDICO CHECK (activo IN (0,1))
);
GO
CREATE UNIQUE INDEX IX_nombre_completo_MEDICO ON citas.MEDICO(nombre_completo);
GO

/* ---------- 4.12 MEDICO_ESPECIALIDAD (N:M) ---------- */
CREATE TABLE citas.MEDICO_ESPECIALIDAD (
    id_medico_especialidad  INT IDENTITY(1,1) NOT NULL,
    id_medico               INT NOT NULL,
    id_catalogo_especialidad INT NOT NULL,
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_MEDICO_ESPECIALIDAD DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_medico_especialidad PRIMARY KEY CLUSTERED (id_medico_especialidad),
    CONSTRAINT FK_id_medico_MEDICO_id_medico_MEDICO_ESPECIALIDAD
        FOREIGN KEY (id_medico) REFERENCES citas.MEDICO(id_medico),
    CONSTRAINT FK_id_catalogo_especialidad_CATALOGO_ESPECIALIDAD_id_catalogo_especialidad_MEDICO_ESPECIALIDAD
        FOREIGN KEY (id_catalogo_especialidad) REFERENCES citas.CATALOGO_ESPECIALIDAD(id_catalogo_especialidad)
);
GO
CREATE UNIQUE INDEX IX_id_medico_id_catalogo_especialidad_MEDICO_ESPECIALIDAD
    ON citas.MEDICO_ESPECIALIDAD(id_medico, id_catalogo_especialidad);
GO

/* ---------- 4.13 MEDICO_CONSULTORIO (N:M) ---------- */
CREATE TABLE citas.MEDICO_CONSULTORIO (
    id_medico_consultorio INT IDENTITY(1,1) NOT NULL,
    id_medico             INT NOT NULL,
    id_consultorio        INT NOT NULL,
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_MEDICO_CONSULTORIO DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_medico_consultorio PRIMARY KEY CLUSTERED (id_medico_consultorio),
    CONSTRAINT FK_id_medico_MEDICO_id_medico_MEDICO_CONSULTORIO
        FOREIGN KEY (id_medico) REFERENCES citas.MEDICO(id_medico),
    CONSTRAINT FK_id_consultorio_CONSULTORIO_id_consultorio_MEDICO_CONSULTORIO
        FOREIGN KEY (id_consultorio) REFERENCES citas.CONSULTORIO(id_consultorio)
);
GO
CREATE UNIQUE INDEX IX_id_medico_id_consultorio_MEDICO_CONSULTORIO
    ON citas.MEDICO_CONSULTORIO(id_medico, id_consultorio);
GO

/* ---------- 4.14 PACIENTE (unico por clinica) ---------- */
CREATE TABLE citas.PACIENTE (
    id_paciente         INT IDENTITY(1,1) NOT NULL,
    id_clinica          INT NOT NULL,
    apellido_paterno    VARCHAR(80)  NOT NULL,
    apellido_materno    VARCHAR(80)  NULL,
    nombre              VARCHAR(100) NOT NULL,
    direccion           VARCHAR(250) NULL,
    telefono            VARCHAR(20)  NULL,
    email               VARCHAR(120) NULL,
    fecha_nacimiento    DATE NOT NULL,
    id_catalogo_genero  INT NOT NULL,
    municipio           VARCHAR(100) NULL,
    id_catalogo_estados INT NULL,
    activo              BIT NOT NULL CONSTRAINT DF_activo_PACIENTE DEFAULT (1),
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_PACIENTE DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_paciente PRIMARY KEY CLUSTERED (id_paciente),
    CONSTRAINT CHK_activo_PACIENTE CHECK (activo IN (0,1)),
    CONSTRAINT CHK_email_PACIENTE CHECK (email IS NULL OR email LIKE '%_@_%._%'),
    CONSTRAINT CHK_fecha_nacimiento_PACIENTE CHECK (fecha_nacimiento <= CAST(GETDATE() AS DATE)),
    CONSTRAINT FK_id_clinica_CLINICA_id_clinica_PACIENTE
        FOREIGN KEY (id_clinica) REFERENCES citas.CLINICA(id_clinica),
    CONSTRAINT FK_id_catalogo_genero_CATALOGO_GENERO_id_catalogo_genero_PACIENTE
        FOREIGN KEY (id_catalogo_genero) REFERENCES citas.CATALOGO_GENERO(id_catalogo_genero),
    CONSTRAINT FK_id_catalogo_estados_CATALOGO_ESTADOS_id_catalogo_estados_PACIENTE
        FOREIGN KEY (id_catalogo_estados) REFERENCES citas.CATALOGO_ESTADOS(id_catalogo_estados)
);
GO
CREATE UNIQUE INDEX IX_id_clinica_apellido_paterno_apellido_materno_nombre_fecha_nacimiento_PACIENTE
    ON citas.PACIENTE(id_clinica, apellido_paterno, apellido_materno, nombre, fecha_nacimiento);
GO

/* ---------- 4.15 CITA ---------- */
CREATE TABLE citas.CITA (
    id_cita                  INT IDENTITY(1,1) NOT NULL,
    id_paciente              INT NOT NULL,
    id_medico                INT NOT NULL,
    id_consultorio           INT NOT NULL,
    id_catalogo_especialidad INT NOT NULL,
    fecha_cita               DATE NOT NULL,
    hora_inicio              TIME(0) NOT NULL,
    hora_fin                 TIME(0) NOT NULL,
    id_catalogo_estado_citas INT NOT NULL,
    observaciones            VARCHAR(500) NULL,
    notifica_email           BIT NOT NULL CONSTRAINT DF_notifica_email_CITA DEFAULT (0),
    notifica_wa              BIT NOT NULL CONSTRAINT DF_notifica_wa_CITA DEFAULT (0),
    horas_anticipacion_notif TINYINT NOT NULL CONSTRAINT DF_horas_anticipacion_notif_CITA DEFAULT (24),
    email_notif              VARCHAR(120) NULL,
    celular_notif            VARCHAR(20)  NULL,
    precio                   DECIMAL(10,2) NOT NULL,
    id_usuario_creacion     TINYINT       NOT NULL,
    fecha_creacion          SMALLDATETIME NOT NULL CONSTRAINT DF_fecha_creacion_CITA DEFAULT (GETDATE()),
    id_usuario_modificacion TINYINT       NULL,
    fecha_modificacion      SMALLDATETIME NULL,
    CONSTRAINT PK_id_cita PRIMARY KEY CLUSTERED (id_cita),
    CONSTRAINT CHK_horas_CITA CHECK (hora_fin > hora_inicio),
    CONSTRAINT CHK_precio_CITA CHECK (precio >= 0),
    CONSTRAINT CHK_notifica_email_CITA CHECK (notifica_email IN (0,1)),
    CONSTRAINT CHK_notifica_wa_CITA CHECK (notifica_wa IN (0,1)),
    CONSTRAINT FK_id_paciente_PACIENTE_id_paciente_CITA
        FOREIGN KEY (id_paciente) REFERENCES citas.PACIENTE(id_paciente),
    CONSTRAINT FK_id_medico_MEDICO_id_medico_CITA
        FOREIGN KEY (id_medico) REFERENCES citas.MEDICO(id_medico),
    CONSTRAINT FK_id_consultorio_CONSULTORIO_id_consultorio_CITA
        FOREIGN KEY (id_consultorio) REFERENCES citas.CONSULTORIO(id_consultorio),
    CONSTRAINT FK_id_catalogo_especialidad_CATALOGO_ESPECIALIDAD_id_catalogo_especialidad_CITA
        FOREIGN KEY (id_catalogo_especialidad) REFERENCES citas.CATALOGO_ESPECIALIDAD(id_catalogo_especialidad),
    CONSTRAINT FK_id_catalogo_estado_citas_CATALOGO_ESTADO_CITAS_id_catalogo_estado_citas_CITA
        FOREIGN KEY (id_catalogo_estado_citas) REFERENCES citas.CATALOGO_ESTADO_CITAS(id_catalogo_estado_citas)
);
GO
CREATE INDEX IX_id_medico_fecha_cita_CITA ON citas.CITA(id_medico, fecha_cita);
CREATE INDEX IX_id_consultorio_fecha_cita_CITA ON citas.CITA(id_consultorio, fecha_cita);
CREATE INDEX IX_id_paciente_fecha_cita_CITA ON citas.CITA(id_paciente, fecha_cita);
GO

/* =====================================================================
   5. PROCEDIMIENTOS ALMACENADOS
   Nomenclatura: sp<Alta|Baja|Cambio|Regresa|Activa|Desactiva><Accion>
   Cada SP registra evento en citas.LOG
   ===================================================================== */

/* ---------- 5.1 Helper interno: spInsertaLog ---------- */
CREATE OR ALTER PROCEDURE citas.spInsertaLog
    @modulo        VARCHAR(30),
    @procedimiento VARCHAR(300),
    @tabla         VARCHAR(50),
    @evento        VARCHAR(2000),
    @id_usuario    TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES(@modulo, @procedimiento, @tabla, @evento, GETDATE(), @id_usuario);
END
GO

/* ---------- 5.2 ROLES ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaRol
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @nombre VARCHAR(50), @descripcion VARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.ROLES(nombre, descripcion, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@nombre, @descripcion, 1, @id_usuario, GETDATE());
        DECLARE @id INT = SCOPE_IDENTITY();
        EXEC citas.spInsertaLog @modulo, 'spAltaRol', 'ROLES',
             ('Alta rol ' + CONVERT(NVARCHAR(50), @nombre) + ' id=' + CONVERT(NVARCHAR(50), @id)), @id_usuario;
        COMMIT;
        SELECT @id AS id_roles;
    END TRY
    BEGIN CATCH ROLLBACK; THROW; END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioRol
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_roles INT, @nombre VARCHAR(50), @descripcion VARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.ROLES
           SET nombre = @nombre, descripcion = @descripcion,
               id_usuario_modificacion = @id_usuario, fecha_modificacion = GETDATE()
         WHERE id_roles = @id_roles;
        EXEC citas.spInsertaLog @modulo, 'spCambioRol', 'ROLES',
             ('Cambio rol id=' + CONVERT(NVARCHAR(50), @id_roles)), @id_usuario;
        COMMIT;
    END TRY
    BEGIN CATCH ROLLBACK; THROW; END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spActivaRol
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_roles INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.ROLES SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
     WHERE id_roles = @id_roles;
    EXEC citas.spInsertaLog @modulo, 'spActivaRol', 'ROLES', ('Activa rol id=' + CONVERT(NVARCHAR(50), @id_roles)), @id_usuario;
END
GO

CREATE OR ALTER PROCEDURE citas.spDesactivaRol
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_roles INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.ROLES SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
     WHERE id_roles = @id_roles;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaRol', 'ROLES', ('Desactiva rol id=' + CONVERT(NVARCHAR(50), @id_roles)), @id_usuario;
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaRol
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_roles INT
AS
BEGIN
    EXEC citas.spDesactivaRol @modulo, @id_usuario, @id_roles;
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaRoles
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_roles, nombre, descripcion, activo FROM citas.ROLES ORDER BY nombre;
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaRolPorId @id_roles INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_roles, nombre, descripcion, activo FROM citas.ROLES WHERE id_roles = @id_roles;
END
GO

/* ---------- 5.3 USUARIOS (con HASHBYTES SHA2_512 + salt) ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaUsuario
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_roles INT, @id_clinica INT = NULL,
    @usuario VARCHAR(50), @password NVARCHAR(100),
    @nombre_completo VARCHAR(150), @email VARCHAR(120) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        DECLARE @salt VARBINARY(32) = CRYPT_GEN_RANDOM(32);
        DECLARE @hash VARBINARY(64) = HASHBYTES('SHA2_512', CAST(@password AS VARBINARY(200)) + @salt);
        INSERT INTO citas.USUARIOS(id_roles, id_clinica, usuario, password_hash, password_salt,
                                   nombre_completo, email, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@id_roles, @id_clinica, @usuario, @hash, @salt,
               @nombre_completo, @email, 1, @id_usuario, GETDATE());
        DECLARE @id INT = SCOPE_IDENTITY();
        EXEC citas.spInsertaLog @modulo, 'spAltaUsuario', 'USUARIOS',
             ('Alta usuario ' + CONVERT(NVARCHAR(50), @usuario) + ' id=' + CONVERT(NVARCHAR(50), @id)), @id_usuario;
        COMMIT;
        SELECT @id AS id_usuarios;
    END TRY
    BEGIN CATCH ROLLBACK; THROW; END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioUsuario
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_usuarios INT, @id_roles INT, @id_clinica INT = NULL,
    @nombre_completo VARCHAR(150), @email VARCHAR(120) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        UPDATE citas.USUARIOS
           SET id_roles = @id_roles, id_clinica = @id_clinica,
               nombre_completo = @nombre_completo, email = @email,
               id_usuario_modificacion = @id_usuario, fecha_modificacion = GETDATE()
         WHERE id_usuarios = @id_usuarios;
        EXEC citas.spInsertaLog @modulo, 'spCambioUsuario', 'USUARIOS',
             ('Cambio usuario id=' + CONVERT(NVARCHAR(50), @id_usuarios)), @id_usuario;
        COMMIT;
    END TRY
    BEGIN CATCH ROLLBACK; THROW; END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioPasswordUsuario
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_usuarios INT, @password_nuevo NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @salt VARBINARY(32) = CRYPT_GEN_RANDOM(32);
    DECLARE @hash VARBINARY(64) = HASHBYTES('SHA2_512', CAST(@password_nuevo AS VARBINARY(200)) + @salt);
    UPDATE citas.USUARIOS
       SET password_hash = @hash, password_salt = @salt,
           id_usuario_modificacion = @id_usuario, fecha_modificacion = GETDATE()
     WHERE id_usuarios = @id_usuarios;
    EXEC citas.spInsertaLog @modulo, 'spCambioPasswordUsuario', 'USUARIOS',
         ('Cambio password usuario id=' + CONVERT(NVARCHAR(50), @id_usuarios)), @id_usuario;
END
GO

CREATE OR ALTER PROCEDURE citas.spActivaUsuario
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_usuarios INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.USUARIOS SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
     WHERE id_usuarios = @id_usuarios;
    EXEC citas.spInsertaLog @modulo, 'spActivaUsuario', 'USUARIOS', ('Activa usuario id=' + CONVERT(NVARCHAR(50), @id_usuarios)), @id_usuario;
END
GO

CREATE OR ALTER PROCEDURE citas.spDesactivaUsuario
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_usuarios INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.USUARIOS SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
     WHERE id_usuarios = @id_usuarios;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaUsuario', 'USUARIOS', ('Desactiva usuario id=' + CONVERT(NVARCHAR(50), @id_usuarios)), @id_usuario;
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaUsuario
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_usuarios INT
AS
BEGIN
    EXEC citas.spDesactivaUsuario @modulo, @id_usuario, @id_usuarios;
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaUsuarios
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.id_usuarios, u.usuario, u.nombre_completo, u.email, u.activo,
           r.id_roles, r.nombre AS rol,
           u.id_clinica, c.nombre AS clinica
      FROM citas.USUARIOS u
      JOIN citas.ROLES r ON r.id_roles = u.id_roles
      LEFT JOIN citas.CLINICA c ON c.id_clinica = u.id_clinica
     ORDER BY u.usuario;
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaUsuarioPorId @id_usuarios INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.id_usuarios, u.usuario, u.nombre_completo, u.email, u.activo,
           u.id_roles, r.nombre AS rol, u.id_clinica
      FROM citas.USUARIOS u
      JOIN citas.ROLES r ON r.id_roles = u.id_roles
     WHERE u.id_usuarios = @id_usuarios;
END
GO

CREATE OR ALTER PROCEDURE citas.spLoginUsuario
    @usuario VARCHAR(50), @password NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id INT, @hash VARBINARY(64), @salt VARBINARY(32), @activo BIT;
    SELECT @id = id_usuarios, @hash = password_hash, @salt = password_salt, @activo = activo
      FROM citas.USUARIOS WHERE usuario = @usuario;
    IF @id IS NULL OR @activo = 0
    BEGIN
        SELECT CAST(NULL AS INT) AS id_usuarios; RETURN;
    END
    DECLARE @calc VARBINARY(64) = HASHBYTES('SHA2_512', CAST(@password AS VARBINARY(200)) + @salt);
    IF @calc = @hash
    BEGIN
        SELECT u.id_usuarios, u.usuario, u.nombre_completo, u.email,
               r.nombre AS rol, u.id_clinica
          FROM citas.USUARIOS u JOIN citas.ROLES r ON r.id_roles = u.id_roles
         WHERE u.id_usuarios = @id;
    END
    ELSE
        SELECT CAST(NULL AS INT) AS id_usuarios;
END
GO

/* ---------- 5.4 CLINICA ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaClinica
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @nombre VARCHAR(120), @direccion VARCHAR(250), @email VARCHAR(120) = NULL,
    @telefono VARCHAR(20) = NULL, @municipio VARCHAR(100), @id_catalogo_estados INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO citas.CLINICA(nombre, direccion, email, telefono, municipio, id_catalogo_estados,
                                  activo, id_usuario_creacion, fecha_creacion)
        VALUES(@nombre, @direccion, @email, @telefono, @municipio, @id_catalogo_estados, 1, @id_usuario, GETDATE());
        DECLARE @id INT = SCOPE_IDENTITY();
        EXEC citas.spInsertaLog @modulo, 'spAltaClinica', 'CLINICA',
             ('Alta clinica ' + CONVERT(NVARCHAR(50), @nombre) + ' id=' + CONVERT(NVARCHAR(50), @id)), @id_usuario;
        COMMIT;
        SELECT @id AS id_clinica;
    END TRY
    BEGIN CATCH ROLLBACK; THROW; END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioClinica
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_clinica INT, @nombre VARCHAR(120), @direccion VARCHAR(250),
    @email VARCHAR(120) = NULL, @telefono VARCHAR(20) = NULL,
    @municipio VARCHAR(100), @id_catalogo_estados INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.CLINICA
       SET nombre=@nombre, direccion=@direccion, email=@email, telefono=@telefono,
           municipio=@municipio, id_catalogo_estados=@id_catalogo_estados,
           id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
     WHERE id_clinica = @id_clinica;
    EXEC citas.spInsertaLog @modulo, 'spCambioClinica', 'CLINICA', ('Cambio clinica id=' + CONVERT(NVARCHAR(50), @id_clinica)), @id_usuario;
END
GO

CREATE OR ALTER PROCEDURE citas.spActivaClinica @modulo VARCHAR(30), @id_usuario TINYINT, @id_clinica INT
AS BEGIN
    UPDATE citas.CLINICA SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_clinica=@id_clinica;
    EXEC citas.spInsertaLog @modulo, 'spActivaClinica', 'CLINICA', ('Activa clinica id=' + CONVERT(NVARCHAR(50), @id_clinica)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spDesactivaClinica @modulo VARCHAR(30), @id_usuario TINYINT, @id_clinica INT
AS BEGIN
    UPDATE citas.CLINICA SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_clinica=@id_clinica;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaClinica', 'CLINICA', ('Desactiva clinica id=' + CONVERT(NVARCHAR(50), @id_clinica)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spBajaClinica @modulo VARCHAR(30), @id_usuario TINYINT, @id_clinica INT
AS BEGIN EXEC citas.spDesactivaClinica @modulo, @id_usuario, @id_clinica; END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaClinicas
AS BEGIN
    SET NOCOUNT ON;
    SELECT c.id_clinica, c.nombre, c.direccion, c.email, c.telefono, c.municipio,
           c.id_catalogo_estados, e.nombre AS estado, c.activo
      FROM citas.CLINICA c
      JOIN citas.CATALOGO_ESTADOS e ON e.id_catalogo_estados = c.id_catalogo_estados
     ORDER BY c.nombre;
END GO

CREATE OR ALTER PROCEDURE citas.spRegresaClinicaPorId @id_clinica INT
AS BEGIN
    SET NOCOUNT ON;
    SELECT * FROM citas.CLINICA WHERE id_clinica = @id_clinica;
END GO

/* ---------- 5.5 CONSULTORIO ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaConsultorio
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_clinica INT, @nombre VARCHAR(80)
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRY BEGIN TRAN;
        INSERT INTO citas.CONSULTORIO(id_clinica, nombre, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@id_clinica, @nombre, 1, @id_usuario, GETDATE());
        DECLARE @id INT = SCOPE_IDENTITY();
        EXEC citas.spInsertaLog @modulo, 'spAltaConsultorio', 'CONSULTORIO',
             ('Alta consultorio ' + CONVERT(NVARCHAR(50), @nombre) + ' clinica=' + CONVERT(NVARCHAR(50), @id_clinica) + ' id=' + CONVERT(NVARCHAR(50), @id)), @id_usuario;
        COMMIT; SELECT @id AS id_consultorio;
    END TRY BEGIN CATCH ROLLBACK; THROW; END CATCH
END GO

CREATE OR ALTER PROCEDURE citas.spCambioConsultorio
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_consultorio INT, @id_clinica INT, @nombre VARCHAR(80)
AS BEGIN
    UPDATE citas.CONSULTORIO SET id_clinica=@id_clinica, nombre=@nombre,
        id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
     WHERE id_consultorio=@id_consultorio;
    EXEC citas.spInsertaLog @modulo, 'spCambioConsultorio', 'CONSULTORIO', ('Cambio consultorio id=' + CONVERT(NVARCHAR(50), @id_consultorio)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spActivaConsultorio @modulo VARCHAR(30), @id_usuario TINYINT, @id_consultorio INT
AS BEGIN
    UPDATE citas.CONSULTORIO SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_consultorio=@id_consultorio;
    EXEC citas.spInsertaLog @modulo, 'spActivaConsultorio', 'CONSULTORIO', ('Activa consultorio id=' + CONVERT(NVARCHAR(50), @id_consultorio)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spDesactivaConsultorio @modulo VARCHAR(30), @id_usuario TINYINT, @id_consultorio INT
AS BEGIN
    UPDATE citas.CONSULTORIO SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_consultorio=@id_consultorio;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaConsultorio', 'CONSULTORIO', ('Desactiva consultorio id=' + CONVERT(NVARCHAR(50), @id_consultorio)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spBajaConsultorio @modulo VARCHAR(30), @id_usuario TINYINT, @id_consultorio INT
AS BEGIN EXEC citas.spDesactivaConsultorio @modulo, @id_usuario, @id_consultorio; END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaConsultorios @id_clinica INT = NULL
AS BEGIN
    SET NOCOUNT ON;
    SELECT c.id_consultorio, c.id_clinica, cl.nombre AS clinica, c.nombre, c.activo
      FROM citas.CONSULTORIO c
      JOIN citas.CLINICA cl ON cl.id_clinica = c.id_clinica
     WHERE (@id_clinica IS NULL OR c.id_clinica = @id_clinica)
     ORDER BY cl.nombre, c.nombre;
END GO

CREATE OR ALTER PROCEDURE citas.spRegresaConsultorioPorId @id_consultorio INT
AS BEGIN SELECT * FROM citas.CONSULTORIO WHERE id_consultorio = @id_consultorio; END
GO

/* ---------- 5.6 MEDICO ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaMedico
    @modulo VARCHAR(30), @id_usuario TINYINT, @nombre_completo VARCHAR(150)
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRY BEGIN TRAN;
        INSERT INTO citas.MEDICO(nombre_completo, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@nombre_completo, 1, @id_usuario, GETDATE());
        DECLARE @id INT = SCOPE_IDENTITY();
        EXEC citas.spInsertaLog @modulo, 'spAltaMedico', 'MEDICO', ('Alta medico ' + CONVERT(NVARCHAR(50), @nombre_completo) + ' id=' + CONVERT(NVARCHAR(50), @id)), @id_usuario;
        COMMIT; SELECT @id AS id_medico;
    END TRY BEGIN CATCH ROLLBACK; THROW; END CATCH
END GO

CREATE OR ALTER PROCEDURE citas.spCambioMedico
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_medico INT, @nombre_completo VARCHAR(150)
AS BEGIN
    UPDATE citas.MEDICO SET nombre_completo=@nombre_completo,
        id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
     WHERE id_medico=@id_medico;
    EXEC citas.spInsertaLog @modulo, 'spCambioMedico', 'MEDICO', ('Cambio medico id=' + CONVERT(NVARCHAR(50), @id_medico)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spActivaMedico @modulo VARCHAR(30), @id_usuario TINYINT, @id_medico INT
AS BEGIN
    UPDATE citas.MEDICO SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_medico=@id_medico;
    EXEC citas.spInsertaLog @modulo, 'spActivaMedico', 'MEDICO', ('Activa medico id=' + CONVERT(NVARCHAR(50), @id_medico)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spDesactivaMedico @modulo VARCHAR(30), @id_usuario TINYINT, @id_medico INT
AS BEGIN
    UPDATE citas.MEDICO SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_medico=@id_medico;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaMedico', 'MEDICO', ('Desactiva medico id=' + CONVERT(NVARCHAR(50), @id_medico)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spBajaMedico @modulo VARCHAR(30), @id_usuario TINYINT, @id_medico INT
AS BEGIN EXEC citas.spDesactivaMedico @modulo, @id_usuario, @id_medico; END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaMedicos
AS BEGIN SELECT id_medico, nombre_completo, activo FROM citas.MEDICO ORDER BY nombre_completo; END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaMedicoPorId @id_medico INT
AS BEGIN SELECT * FROM citas.MEDICO WHERE id_medico = @id_medico; END
GO

/* ---------- 5.7 MEDICO_ESPECIALIDAD / MEDICO_CONSULTORIO ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaMedicoEspecialidad
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_medico INT, @id_catalogo_especialidad INT
AS BEGIN
    INSERT INTO citas.MEDICO_ESPECIALIDAD(id_medico, id_catalogo_especialidad, id_usuario_creacion, fecha_creacion)
    VALUES(@id_medico, @id_catalogo_especialidad, @id_usuario, GETDATE());
    EXEC citas.spInsertaLog @modulo, 'spAltaMedicoEspecialidad', 'MEDICO_ESPECIALIDAD',
         ('Asocia medico=' + CONVERT(NVARCHAR(50), @id_medico) + ' especialidad=' + CONVERT(NVARCHAR(50), @id_catalogo_especialidad)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spBajaMedicoEspecialidad
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_medico_especialidad INT
AS BEGIN
    DELETE FROM citas.MEDICO_ESPECIALIDAD WHERE id_medico_especialidad = @id_medico_especialidad;
    EXEC citas.spInsertaLog @modulo, 'spBajaMedicoEspecialidad', 'MEDICO_ESPECIALIDAD',
         ('Baja id=' + CONVERT(NVARCHAR(50), @id_medico_especialidad)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spRegresaEspecialidadesPorMedico @id_medico INT
AS BEGIN
    SELECT me.id_medico_especialidad, e.id_catalogo_especialidad, e.nombre
      FROM citas.MEDICO_ESPECIALIDAD me
      JOIN citas.CATALOGO_ESPECIALIDAD e ON e.id_catalogo_especialidad = me.id_catalogo_especialidad
     WHERE me.id_medico = @id_medico ORDER BY e.nombre;
END GO

CREATE OR ALTER PROCEDURE citas.spAltaMedicoConsultorio
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_medico INT, @id_consultorio INT
AS BEGIN
    INSERT INTO citas.MEDICO_CONSULTORIO(id_medico, id_consultorio, id_usuario_creacion, fecha_creacion)
    VALUES(@id_medico, @id_consultorio, @id_usuario, GETDATE());
    EXEC citas.spInsertaLog @modulo, 'spAltaMedicoConsultorio', 'MEDICO_CONSULTORIO',
         ('Asocia medico=' + CONVERT(NVARCHAR(50), @id_medico) + ' consultorio=' + CONVERT(NVARCHAR(50), @id_consultorio)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spBajaMedicoConsultorio
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_medico_consultorio INT
AS BEGIN
    DELETE FROM citas.MEDICO_CONSULTORIO WHERE id_medico_consultorio = @id_medico_consultorio;
    EXEC citas.spInsertaLog @modulo, 'spBajaMedicoConsultorio', 'MEDICO_CONSULTORIO',
         ('Baja id=' + CONVERT(NVARCHAR(50), @id_medico_consultorio)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spRegresaConsultoriosPorMedico @id_medico INT
AS BEGIN
    SELECT mc.id_medico_consultorio, c.id_consultorio, c.nombre AS consultorio,
           c.id_clinica, cl.nombre AS clinica
      FROM citas.MEDICO_CONSULTORIO mc
      JOIN citas.CONSULTORIO c ON c.id_consultorio = mc.id_consultorio
      JOIN citas.CLINICA cl ON cl.id_clinica = c.id_clinica
     WHERE mc.id_medico = @id_medico ORDER BY cl.nombre, c.nombre;
END GO

/* ---------- 5.8 PACIENTE ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaPaciente
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_clinica INT, @apellido_paterno VARCHAR(80), @apellido_materno VARCHAR(80) = NULL,
    @nombre VARCHAR(100), @direccion VARCHAR(250) = NULL, @telefono VARCHAR(20) = NULL,
    @email VARCHAR(120) = NULL, @fecha_nacimiento DATE, @id_catalogo_genero INT,
    @municipio VARCHAR(100) = NULL, @id_catalogo_estados INT = NULL
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRY BEGIN TRAN;
        INSERT INTO citas.PACIENTE(id_clinica, apellido_paterno, apellido_materno, nombre, direccion,
                                   telefono, email, fecha_nacimiento, id_catalogo_genero, municipio,
                                   id_catalogo_estados, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@id_clinica, @apellido_paterno, @apellido_materno, @nombre, @direccion, @telefono,
               @email, @fecha_nacimiento, @id_catalogo_genero, @municipio, @id_catalogo_estados,
               1, @id_usuario, GETDATE());
        DECLARE @id INT = SCOPE_IDENTITY();
        EXEC citas.spInsertaLog @modulo, 'spAltaPaciente', 'PACIENTE',
             ('Alta paciente id=' + CONVERT(NVARCHAR(50), @id) + ' clinica=' + CONVERT(NVARCHAR(50), @id_clinica)), @id_usuario;
        COMMIT; SELECT @id AS id_paciente;
    END TRY BEGIN CATCH ROLLBACK; THROW; END CATCH
END GO

CREATE OR ALTER PROCEDURE citas.spCambioPaciente
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_paciente INT, @apellido_paterno VARCHAR(80), @apellido_materno VARCHAR(80) = NULL,
    @nombre VARCHAR(100), @direccion VARCHAR(250) = NULL, @telefono VARCHAR(20) = NULL,
    @email VARCHAR(120) = NULL, @fecha_nacimiento DATE, @id_catalogo_genero INT,
    @municipio VARCHAR(100) = NULL, @id_catalogo_estados INT = NULL
AS BEGIN
    UPDATE citas.PACIENTE
       SET apellido_paterno=@apellido_paterno, apellido_materno=@apellido_materno, nombre=@nombre,
           direccion=@direccion, telefono=@telefono, email=@email, fecha_nacimiento=@fecha_nacimiento,
           id_catalogo_genero=@id_catalogo_genero, municipio=@municipio, id_catalogo_estados=@id_catalogo_estados,
           id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
     WHERE id_paciente=@id_paciente;
    EXEC citas.spInsertaLog @modulo, 'spCambioPaciente', 'PACIENTE', ('Cambio paciente id=' + CONVERT(NVARCHAR(50), @id_paciente)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spActivaPaciente @modulo VARCHAR(30), @id_usuario TINYINT, @id_paciente INT
AS BEGIN
    UPDATE citas.PACIENTE SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_paciente=@id_paciente;
    EXEC citas.spInsertaLog @modulo, 'spActivaPaciente', 'PACIENTE', ('Activa paciente id=' + CONVERT(NVARCHAR(50), @id_paciente)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spDesactivaPaciente @modulo VARCHAR(30), @id_usuario TINYINT, @id_paciente INT
AS BEGIN
    UPDATE citas.PACIENTE SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_paciente=@id_paciente;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaPaciente', 'PACIENTE', ('Desactiva paciente id=' + CONVERT(NVARCHAR(50), @id_paciente)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spBajaPaciente @modulo VARCHAR(30), @id_usuario TINYINT, @id_paciente INT
AS BEGIN EXEC citas.spDesactivaPaciente @modulo, @id_usuario, @id_paciente; END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaPacientes @id_clinica INT
AS BEGIN
    SET NOCOUNT ON;
    SELECT p.id_paciente, p.apellido_paterno, p.apellido_materno, p.nombre, p.telefono, p.email,
           p.fecha_nacimiento, g.nombre AS genero, p.activo
      FROM citas.PACIENTE p
      JOIN citas.CATALOGO_GENERO g ON g.id_catalogo_genero = p.id_catalogo_genero
     WHERE p.id_clinica = @id_clinica
     ORDER BY p.apellido_paterno, p.apellido_materno, p.nombre;
END GO

CREATE OR ALTER PROCEDURE citas.spRegresaPacientePorId @id_paciente INT
AS BEGIN SELECT * FROM citas.PACIENTE WHERE id_paciente = @id_paciente; END
GO

/* ---------- 5.9 CITA ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaCita
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_paciente INT, @id_medico INT, @id_consultorio INT, @id_catalogo_especialidad INT,
    @fecha_cita DATE, @hora_inicio TIME(0), @hora_fin TIME(0),
    @id_catalogo_estado_citas INT, @observaciones VARCHAR(500) = NULL,
    @notifica_email BIT = 0, @notifica_wa BIT = 0, @horas_anticipacion_notif TINYINT = 24,
    @precio DECIMAL(10,2)
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRY BEGIN TRAN;
        DECLARE @email VARCHAR(120), @cel VARCHAR(20);
        SELECT @email = email, @cel = telefono FROM citas.PACIENTE WHERE id_paciente = @id_paciente;

        -- Valida traslape de horarios para el mismo medico
        IF EXISTS(
            SELECT 1 FROM citas.CITA
             WHERE id_medico = @id_medico AND fecha_cita = @fecha_cita
               AND id_catalogo_estado_citas <> (SELECT id_catalogo_estado_citas FROM citas.CATALOGO_ESTADO_CITAS WHERE nombre = 'Cancelada')
               AND hora_inicio < @hora_fin AND hora_fin > @hora_inicio)
        BEGIN
            ;THROW 50001, 'El medico ya tiene una cita en ese horario.', 1;
        END

        INSERT INTO citas.CITA(id_paciente, id_medico, id_consultorio, id_catalogo_especialidad,
                               fecha_cita, hora_inicio, hora_fin, id_catalogo_estado_citas, observaciones,
                               notifica_email, notifica_wa, horas_anticipacion_notif,
                               email_notif, celular_notif, precio,
                               id_usuario_creacion, fecha_creacion)
        VALUES(@id_paciente, @id_medico, @id_consultorio, @id_catalogo_especialidad,
               @fecha_cita, @hora_inicio, @hora_fin, @id_catalogo_estado_citas, @observaciones,
               @notifica_email, @notifica_wa, @horas_anticipacion_notif,
               @email, @cel, @precio, @id_usuario, GETDATE());
        DECLARE @id INT = SCOPE_IDENTITY();
        EXEC citas.spInsertaLog @modulo, 'spAltaCita', 'CITA',
             ('Alta cita id=' + CONVERT(NVARCHAR(50), @id) + ' paciente=' + CONVERT(NVARCHAR(50), @id_paciente) + ' medico=' + CONVERT(NVARCHAR(50), @id_medico) + ' fecha=' + CONVERT(NVARCHAR(50), CONVERT(VARCHAR(10), @fecha_cita, 120))), @id_usuario;
        COMMIT; SELECT @id AS id_cita;
    END TRY BEGIN CATCH ROLLBACK; THROW; END CATCH
END GO

CREATE OR ALTER PROCEDURE citas.spCambioCita
    @modulo VARCHAR(30), @id_usuario TINYINT,
    @id_cita INT, @id_paciente INT, @id_medico INT, @id_consultorio INT, @id_catalogo_especialidad INT,
    @fecha_cita DATE, @hora_inicio TIME(0), @hora_fin TIME(0),
    @id_catalogo_estado_citas INT, @observaciones VARCHAR(500) = NULL,
    @notifica_email BIT = 0, @notifica_wa BIT = 0, @horas_anticipacion_notif TINYINT = 24,
    @precio DECIMAL(10,2)
AS BEGIN
    SET NOCOUNT ON;
    BEGIN TRY BEGIN TRAN;
        DECLARE @email VARCHAR(120), @cel VARCHAR(20);
        SELECT @email = email, @cel = telefono FROM citas.PACIENTE WHERE id_paciente = @id_paciente;

        IF EXISTS(
            SELECT 1 FROM citas.CITA
             WHERE id_medico = @id_medico AND fecha_cita = @fecha_cita
               AND id_cita <> @id_cita
               AND id_catalogo_estado_citas <> (SELECT id_catalogo_estado_citas FROM citas.CATALOGO_ESTADO_CITAS WHERE nombre = 'Cancelada')
               AND hora_inicio < @hora_fin AND hora_fin > @hora_inicio)
        BEGIN ;THROW 50001, 'El medico ya tiene una cita en ese horario.', 1; END

        UPDATE citas.CITA
           SET id_paciente=@id_paciente, id_medico=@id_medico, id_consultorio=@id_consultorio,
               id_catalogo_especialidad=@id_catalogo_especialidad, fecha_cita=@fecha_cita,
               hora_inicio=@hora_inicio, hora_fin=@hora_fin,
               id_catalogo_estado_citas=@id_catalogo_estado_citas, observaciones=@observaciones,
               notifica_email=@notifica_email, notifica_wa=@notifica_wa,
               horas_anticipacion_notif=@horas_anticipacion_notif,
               email_notif=@email, celular_notif=@cel, precio=@precio,
               id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
         WHERE id_cita=@id_cita;
        EXEC citas.spInsertaLog @modulo, 'spCambioCita', 'CITA', ('Cambio cita id=' + CONVERT(NVARCHAR(50), @id_cita)), @id_usuario;
        COMMIT;
    END TRY BEGIN CATCH ROLLBACK; THROW; END CATCH
END GO

CREATE OR ALTER PROCEDURE citas.spCancelaCita
    @modulo VARCHAR(30), @id_usuario TINYINT, @id_cita INT
AS BEGIN
    DECLARE @idEstado INT = (SELECT id_catalogo_estado_citas FROM citas.CATALOGO_ESTADO_CITAS WHERE nombre = 'Cancelada');
    UPDATE citas.CITA SET id_catalogo_estado_citas=@idEstado,
        id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
     WHERE id_cita=@id_cita;
    EXEC citas.spInsertaLog @modulo, 'spCancelaCita', 'CITA', ('Cancela cita id=' + CONVERT(NVARCHAR(50), @id_cita)), @id_usuario;
END GO

CREATE OR ALTER PROCEDURE citas.spBajaCita @modulo VARCHAR(30), @id_usuario TINYINT, @id_cita INT
AS BEGIN EXEC citas.spCancelaCita @modulo, @id_usuario, @id_cita; END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaCitasPorMedicoFecha
    @id_medico INT, @fecha_ini DATE, @fecha_fin DATE
AS BEGIN
    SET NOCOUNT ON;
    SELECT c.id_cita, c.fecha_cita, c.hora_inicio, c.hora_fin, c.precio,
           p.id_paciente, (CONVERT(NVARCHAR(50), p.apellido_paterno) + ' ' + CONVERT(NVARCHAR(50), ISNULL(p.apellido_materno,'')) + ' ' + CONVERT(NVARCHAR(50), p.nombre)) AS paciente,
           e.nombre AS especialidad, ec.nombre AS estado,
           co.nombre AS consultorio, cl.nombre AS clinica
      FROM citas.CITA c
      JOIN citas.PACIENTE p ON p.id_paciente = c.id_paciente
      JOIN citas.CATALOGO_ESPECIALIDAD e ON e.id_catalogo_especialidad = c.id_catalogo_especialidad
      JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_catalogo_estado_citas = c.id_catalogo_estado_citas
      JOIN citas.CONSULTORIO co ON co.id_consultorio = c.id_consultorio
      JOIN citas.CLINICA cl ON cl.id_clinica = co.id_clinica
     WHERE c.id_medico = @id_medico
       AND c.fecha_cita BETWEEN @fecha_ini AND @fecha_fin
     ORDER BY c.fecha_cita, c.hora_inicio;
END GO

CREATE OR ALTER PROCEDURE citas.spRegresaCitasPorClinicaFecha
    @id_clinica INT, @fecha_ini DATE, @fecha_fin DATE
AS BEGIN
    SET NOCOUNT ON;
    SELECT c.id_cita, c.fecha_cita, c.hora_inicio, c.hora_fin, c.precio,
           p.id_paciente, (CONVERT(NVARCHAR(50), p.apellido_paterno) + ' ' + CONVERT(NVARCHAR(50), ISNULL(p.apellido_materno,'')) + ' ' + CONVERT(NVARCHAR(50), p.nombre)) AS paciente,
           m.id_medico, m.nombre_completo AS medico,
           e.nombre AS especialidad, ec.nombre AS estado, co.nombre AS consultorio
      FROM citas.CITA c
      JOIN citas.PACIENTE p ON p.id_paciente = c.id_paciente
      JOIN citas.MEDICO m ON m.id_medico = c.id_medico
      JOIN citas.CATALOGO_ESPECIALIDAD e ON e.id_catalogo_especialidad = c.id_catalogo_especialidad
      JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_catalogo_estado_citas = c.id_catalogo_estado_citas
      JOIN citas.CONSULTORIO co ON co.id_consultorio = c.id_consultorio
     WHERE co.id_clinica = @id_clinica
       AND c.fecha_cita BETWEEN @fecha_ini AND @fecha_fin
     ORDER BY c.fecha_cita, c.hora_inicio;
END GO

CREATE OR ALTER PROCEDURE citas.spRegresaCitaPorId @id_cita INT
AS BEGIN SELECT * FROM citas.CITA WHERE id_cita = @id_cita; END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaIngresosPorMedico
    @id_medico INT, @fecha_ini DATE, @fecha_fin DATE
AS BEGIN
    SET NOCOUNT ON;
    SELECT m.id_medico, m.nombre_completo AS medico,
           COUNT(*) AS total_citas, SUM(c.precio) AS ingresos
      FROM citas.CITA c
      JOIN citas.MEDICO m ON m.id_medico = c.id_medico
      JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_catalogo_estado_citas = c.id_catalogo_estado_citas
     WHERE c.id_medico = @id_medico
       AND c.fecha_cita BETWEEN @fecha_ini AND @fecha_fin
       AND ec.nombre IN ('Atendida','Confirmada','Agendada')
     GROUP BY m.id_medico, m.nombre_completo;
END GO

CREATE OR ALTER PROCEDURE citas.spRegresaIngresosPorClinica
    @id_clinica INT, @fecha_ini DATE, @fecha_fin DATE
AS BEGIN
    SET NOCOUNT ON;
    SELECT cl.id_clinica, cl.nombre AS clinica,
           COUNT(*) AS total_citas, SUM(c.precio) AS ingresos
      FROM citas.CITA c
      JOIN citas.CONSULTORIO co ON co.id_consultorio = c.id_consultorio
      JOIN citas.CLINICA cl ON cl.id_clinica = co.id_clinica
      JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_catalogo_estado_citas = c.id_catalogo_estado_citas
     WHERE cl.id_clinica = @id_clinica
       AND c.fecha_cita BETWEEN @fecha_ini AND @fecha_fin
       AND ec.nombre IN ('Atendida','Confirmada','Agendada')
     GROUP BY cl.id_clinica, cl.nombre;
END GO

/* ---------- 5.10 SPs para catalogos (genericos por catalogo) ---------- */
/* CATALOGO_PAIS */
CREATE OR ALTER PROCEDURE citas.spAltaPais @modulo VARCHAR(30), @id_usuario TINYINT, @nombre VARCHAR(80)
AS BEGIN
    INSERT INTO citas.CATALOGO_PAIS(nombre, activo, id_usuario_creacion, fecha_creacion)
    VALUES(@nombre, 1, @id_usuario, GETDATE());
    DECLARE @id INT = SCOPE_IDENTITY();
    EXEC citas.spInsertaLog @modulo, 'spAltaPais', 'CATALOGO_PAIS', ('Alta pais ' + CONVERT(NVARCHAR(50), @nombre)), @id_usuario;
    SELECT @id AS id_catalogo_pais;
END GO
CREATE OR ALTER PROCEDURE citas.spCambioPais @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_pais INT, @nombre VARCHAR(80)
AS BEGIN
    UPDATE citas.CATALOGO_PAIS SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_pais=@id_catalogo_pais;
    EXEC citas.spInsertaLog @modulo, 'spCambioPais', 'CATALOGO_PAIS', ('Cambio pais id=' + CONVERT(NVARCHAR(50), @id_catalogo_pais)), @id_usuario;
END GO
CREATE OR ALTER PROCEDURE citas.spActivaPais @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_pais INT
AS BEGIN UPDATE citas.CATALOGO_PAIS SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_pais=@id_catalogo_pais;
    EXEC citas.spInsertaLog @modulo, 'spActivaPais', 'CATALOGO_PAIS', ('Activa pais id=' + CONVERT(NVARCHAR(50), @id_catalogo_pais)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spDesactivaPais @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_pais INT
AS BEGIN UPDATE citas.CATALOGO_PAIS SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_pais=@id_catalogo_pais;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaPais', 'CATALOGO_PAIS', ('Desactiva pais id=' + CONVERT(NVARCHAR(50), @id_catalogo_pais)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spBajaPais @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_pais INT
AS BEGIN EXEC citas.spDesactivaPais @modulo, @id_usuario, @id_catalogo_pais; END GO
CREATE OR ALTER PROCEDURE citas.spRegresaPaises AS BEGIN SELECT * FROM citas.CATALOGO_PAIS ORDER BY nombre; END GO

/* CATALOGO_ESTADOS */
CREATE OR ALTER PROCEDURE citas.spAltaEstado @modulo VARCHAR(30), @id_usuario TINYINT, @nombre VARCHAR(80), @id_catalogo_pais INT
AS BEGIN
    INSERT INTO citas.CATALOGO_ESTADOS(nombre, id_catalogo_pais, activo, id_usuario_creacion, fecha_creacion)
    VALUES(@nombre, @id_catalogo_pais, 1, @id_usuario, GETDATE());
    DECLARE @id INT = SCOPE_IDENTITY();
    EXEC citas.spInsertaLog @modulo, 'spAltaEstado', 'CATALOGO_ESTADOS', ('Alta estado ' + CONVERT(NVARCHAR(50), @nombre)), @id_usuario;
    SELECT @id AS id_catalogo_estados;
END GO
CREATE OR ALTER PROCEDURE citas.spCambioEstado @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_estados INT, @nombre VARCHAR(80), @id_catalogo_pais INT
AS BEGIN
    UPDATE citas.CATALOGO_ESTADOS SET nombre=@nombre, id_catalogo_pais=@id_catalogo_pais, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_estados=@id_catalogo_estados;
    EXEC citas.spInsertaLog @modulo, 'spCambioEstado', 'CATALOGO_ESTADOS', ('Cambio estado id=' + CONVERT(NVARCHAR(50), @id_catalogo_estados)), @id_usuario;
END GO
CREATE OR ALTER PROCEDURE citas.spActivaEstado @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_estados INT
AS BEGIN UPDATE citas.CATALOGO_ESTADOS SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_estados=@id_catalogo_estados;
    EXEC citas.spInsertaLog @modulo, 'spActivaEstado', 'CATALOGO_ESTADOS', ('Activa estado id=' + CONVERT(NVARCHAR(50), @id_catalogo_estados)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spDesactivaEstado @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_estados INT
AS BEGIN UPDATE citas.CATALOGO_ESTADOS SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_estados=@id_catalogo_estados;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaEstado', 'CATALOGO_ESTADOS', ('Desactiva estado id=' + CONVERT(NVARCHAR(50), @id_catalogo_estados)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spBajaEstado @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_estados INT
AS BEGIN EXEC citas.spDesactivaEstado @modulo, @id_usuario, @id_catalogo_estados; END GO
CREATE OR ALTER PROCEDURE citas.spRegresaEstados @id_catalogo_pais INT = NULL
AS BEGIN
    SELECT e.id_catalogo_estados, e.nombre, e.activo, e.id_catalogo_pais, p.nombre AS pais
      FROM citas.CATALOGO_ESTADOS e JOIN citas.CATALOGO_PAIS p ON p.id_catalogo_pais = e.id_catalogo_pais
     WHERE (@id_catalogo_pais IS NULL OR e.id_catalogo_pais = @id_catalogo_pais)
     ORDER BY p.nombre, e.nombre;
END GO

/* CATALOGO_ESTADO_CITAS */
CREATE OR ALTER PROCEDURE citas.spAltaEstadoCita @modulo VARCHAR(30), @id_usuario TINYINT, @nombre VARCHAR(50)
AS BEGIN
    INSERT INTO citas.CATALOGO_ESTADO_CITAS(nombre, activo, id_usuario_creacion, fecha_creacion)
    VALUES(@nombre, 1, @id_usuario, GETDATE());
    DECLARE @id INT = SCOPE_IDENTITY();
    EXEC citas.spInsertaLog @modulo, 'spAltaEstadoCita', 'CATALOGO_ESTADO_CITAS', ('Alta estado cita ' + CONVERT(NVARCHAR(50), @nombre)), @id_usuario;
    SELECT @id AS id_catalogo_estado_citas;
END GO
CREATE OR ALTER PROCEDURE citas.spCambioEstadoCita @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_estado_citas INT, @nombre VARCHAR(50)
AS BEGIN
    UPDATE citas.CATALOGO_ESTADO_CITAS SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_estado_citas=@id_catalogo_estado_citas;
    EXEC citas.spInsertaLog @modulo, 'spCambioEstadoCita', 'CATALOGO_ESTADO_CITAS', ('Cambio estado cita id=' + CONVERT(NVARCHAR(50), @id_catalogo_estado_citas)), @id_usuario;
END GO
CREATE OR ALTER PROCEDURE citas.spActivaEstadoCita @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_estado_citas INT
AS BEGIN UPDATE citas.CATALOGO_ESTADO_CITAS SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_estado_citas=@id_catalogo_estado_citas;
    EXEC citas.spInsertaLog @modulo, 'spActivaEstadoCita', 'CATALOGO_ESTADO_CITAS', ('Activa id=' + CONVERT(NVARCHAR(50), @id_catalogo_estado_citas)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spDesactivaEstadoCita @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_estado_citas INT
AS BEGIN UPDATE citas.CATALOGO_ESTADO_CITAS SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_estado_citas=@id_catalogo_estado_citas;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaEstadoCita', 'CATALOGO_ESTADO_CITAS', ('Desactiva id=' + CONVERT(NVARCHAR(50), @id_catalogo_estado_citas)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spBajaEstadoCita @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_estado_citas INT
AS BEGIN EXEC citas.spDesactivaEstadoCita @modulo, @id_usuario, @id_catalogo_estado_citas; END GO
CREATE OR ALTER PROCEDURE citas.spRegresaEstadosCita AS BEGIN SELECT * FROM citas.CATALOGO_ESTADO_CITAS ORDER BY nombre; END GO

/* CATALOGO_GENERO */
CREATE OR ALTER PROCEDURE citas.spAltaGenero @modulo VARCHAR(30), @id_usuario TINYINT, @nombre VARCHAR(30)
AS BEGIN
    INSERT INTO citas.CATALOGO_GENERO(nombre, activo, id_usuario_creacion, fecha_creacion) VALUES(@nombre, 1, @id_usuario, GETDATE());
    DECLARE @id INT = SCOPE_IDENTITY();
    EXEC citas.spInsertaLog @modulo, 'spAltaGenero', 'CATALOGO_GENERO', ('Alta genero ' + CONVERT(NVARCHAR(50), @nombre)), @id_usuario;
    SELECT @id AS id_catalogo_genero;
END GO
CREATE OR ALTER PROCEDURE citas.spCambioGenero @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_genero INT, @nombre VARCHAR(30)
AS BEGIN UPDATE citas.CATALOGO_GENERO SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_genero=@id_catalogo_genero;
    EXEC citas.spInsertaLog @modulo, 'spCambioGenero', 'CATALOGO_GENERO', ('Cambio genero id=' + CONVERT(NVARCHAR(50), @id_catalogo_genero)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spActivaGenero @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_genero INT
AS BEGIN UPDATE citas.CATALOGO_GENERO SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_genero=@id_catalogo_genero;
    EXEC citas.spInsertaLog @modulo, 'spActivaGenero', 'CATALOGO_GENERO', ('Activa id=' + CONVERT(NVARCHAR(50), @id_catalogo_genero)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spDesactivaGenero @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_genero INT
AS BEGIN UPDATE citas.CATALOGO_GENERO SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_genero=@id_catalogo_genero;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaGenero', 'CATALOGO_GENERO', ('Desactiva id=' + CONVERT(NVARCHAR(50), @id_catalogo_genero)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spBajaGenero @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_genero INT
AS BEGIN EXEC citas.spDesactivaGenero @modulo, @id_usuario, @id_catalogo_genero; END GO
CREATE OR ALTER PROCEDURE citas.spRegresaGeneros AS BEGIN SELECT * FROM citas.CATALOGO_GENERO ORDER BY nombre; END GO

/* CATALOGO_ESPECIALIDAD */
CREATE OR ALTER PROCEDURE citas.spAltaEspecialidad @modulo VARCHAR(30), @id_usuario TINYINT, @nombre VARCHAR(100)
AS BEGIN
    INSERT INTO citas.CATALOGO_ESPECIALIDAD(nombre, activo, id_usuario_creacion, fecha_creacion) VALUES(@nombre, 1, @id_usuario, GETDATE());
    DECLARE @id INT = SCOPE_IDENTITY();
    EXEC citas.spInsertaLog @modulo, 'spAltaEspecialidad', 'CATALOGO_ESPECIALIDAD', ('Alta especialidad ' + CONVERT(NVARCHAR(50), @nombre)), @id_usuario;
    SELECT @id AS id_catalogo_especialidad;
END GO
CREATE OR ALTER PROCEDURE citas.spCambioEspecialidad @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_especialidad INT, @nombre VARCHAR(100)
AS BEGIN UPDATE citas.CATALOGO_ESPECIALIDAD SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_especialidad=@id_catalogo_especialidad;
    EXEC citas.spInsertaLog @modulo, 'spCambioEspecialidad', 'CATALOGO_ESPECIALIDAD', ('Cambio especialidad id=' + CONVERT(NVARCHAR(50), @id_catalogo_especialidad)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spActivaEspecialidad @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_especialidad INT
AS BEGIN UPDATE citas.CATALOGO_ESPECIALIDAD SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_especialidad=@id_catalogo_especialidad;
    EXEC citas.spInsertaLog @modulo, 'spActivaEspecialidad', 'CATALOGO_ESPECIALIDAD', ('Activa id=' + CONVERT(NVARCHAR(50), @id_catalogo_especialidad)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spDesactivaEspecialidad @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_especialidad INT
AS BEGIN UPDATE citas.CATALOGO_ESPECIALIDAD SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE() WHERE id_catalogo_especialidad=@id_catalogo_especialidad;
    EXEC citas.spInsertaLog @modulo, 'spDesactivaEspecialidad', 'CATALOGO_ESPECIALIDAD', ('Desactiva id=' + CONVERT(NVARCHAR(50), @id_catalogo_especialidad)), @id_usuario; END GO
CREATE OR ALTER PROCEDURE citas.spBajaEspecialidad @modulo VARCHAR(30), @id_usuario TINYINT, @id_catalogo_especialidad INT
AS BEGIN EXEC citas.spDesactivaEspecialidad @modulo, @id_usuario, @id_catalogo_especialidad; END GO
CREATE OR ALTER PROCEDURE citas.spRegresaEspecialidades AS BEGIN SELECT * FROM citas.CATALOGO_ESPECIALIDAD ORDER BY nombre; END GO

/* =====================================================================
   6. VISTAS
   ===================================================================== */
CREATE OR ALTER VIEW citas.vwCitasDelDia AS
SELECT c.id_cita, c.fecha_cita, c.hora_inicio, c.hora_fin, c.precio,
       m.id_medico, m.nombre_completo AS medico,
       (CONVERT(NVARCHAR(50), p.apellido_paterno) + ' ' + CONVERT(NVARCHAR(50), ISNULL(p.apellido_materno,'')) + ' ' + CONVERT(NVARCHAR(50), p.nombre)) AS paciente,
       e.nombre AS especialidad, ec.nombre AS estado,
       co.nombre AS consultorio, cl.id_clinica, cl.nombre AS clinica
  FROM citas.CITA c
  JOIN citas.MEDICO m ON m.id_medico = c.id_medico
  JOIN citas.PACIENTE p ON p.id_paciente = c.id_paciente
  JOIN citas.CATALOGO_ESPECIALIDAD e ON e.id_catalogo_especialidad = c.id_catalogo_especialidad
  JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_catalogo_estado_citas = c.id_catalogo_estado_citas
  JOIN citas.CONSULTORIO co ON co.id_consultorio = c.id_consultorio
  JOIN citas.CLINICA cl ON cl.id_clinica = co.id_clinica;
GO

CREATE OR ALTER VIEW citas.vwMedicosPorClinica AS
SELECT DISTINCT cl.id_clinica, cl.nombre AS clinica, m.id_medico, m.nombre_completo AS medico
  FROM citas.MEDICO_CONSULTORIO mc
  JOIN citas.MEDICO m ON m.id_medico = mc.id_medico
  JOIN citas.CONSULTORIO co ON co.id_consultorio = mc.id_consultorio
  JOIN citas.CLINICA cl ON cl.id_clinica = co.id_clinica;
GO

CREATE OR ALTER VIEW citas.vwIngresosPorMedico AS
SELECT m.id_medico, m.nombre_completo AS medico,
       YEAR(c.fecha_cita) AS anio, MONTH(c.fecha_cita) AS mes,
       COUNT(*) AS total_citas, SUM(c.precio) AS ingresos
  FROM citas.CITA c
  JOIN citas.MEDICO m ON m.id_medico = c.id_medico
  JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_catalogo_estado_citas = c.id_catalogo_estado_citas
 WHERE ec.nombre IN ('Atendida','Confirmada','Agendada')
 GROUP BY m.id_medico, m.nombre_completo, YEAR(c.fecha_cita), MONTH(c.fecha_cita);
GO

/* =====================================================================
   7. SEGURIDAD: acceso solo via SPs
   ===================================================================== */
GRANT EXECUTE ON SCHEMA::citas TO citasadmin;
GO
DENY SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::citas TO citasadmin;
GO

/* =====================================================================
   8. DATOS SEMILLA
   ===================================================================== */
SET NOCOUNT ON;

-- Roles
INSERT INTO citas.ROLES(nombre, descripcion, activo, id_usuario_creacion, fecha_creacion) VALUES
 ('admin_sistema',  'Administrador de sistema (acceso total)', 1, 1, GETDATE()),
 ('administrador',  'Administrador de clinica',                1, 1, GETDATE()),
 ('medico',         'Medico',                                  1, 1, GETDATE()),
 ('asistente',      'Asistente de medico',                     1, 1, GETDATE());
GO

-- Pais y estados base
INSERT INTO citas.CATALOGO_PAIS(nombre, activo, id_usuario_creacion, fecha_creacion) VALUES ('Mexico', 1, 1, GETDATE());
DECLARE @idPais INT = (SELECT id_catalogo_pais FROM citas.CATALOGO_PAIS WHERE nombre='Mexico');
INSERT INTO citas.CATALOGO_ESTADOS(nombre, id_catalogo_pais, activo, id_usuario_creacion, fecha_creacion) VALUES
 ('Puebla',          @idPais, 1, 1, GETDATE()),
 ('Tlaxcala',        @idPais, 1, 1, GETDATE()),
 ('Veracruz',        @idPais, 1, 1, GETDATE()),
 ('Ciudad de Mexico',@idPais, 1, 1, GETDATE());
GO

-- Generos
INSERT INTO citas.CATALOGO_GENERO(nombre, activo, id_usuario_creacion, fecha_creacion) VALUES
 ('Masculino', 1, 1, GETDATE()),
 ('Femenino',  1, 1, GETDATE()),
 ('Otro',      1, 1, GETDATE());
GO

-- Estados de cita
INSERT INTO citas.CATALOGO_ESTADO_CITAS(nombre, activo, id_usuario_creacion, fecha_creacion) VALUES
 ('Agendada',   1, 1, GETDATE()),
 ('Confirmada', 1, 1, GETDATE()),
 ('Cancelada',  1, 1, GETDATE()),
 ('Atendida',   1, 1, GETDATE()),
 ('No asistio', 1, 1, GETDATE());
GO

-- Especialidades base
INSERT INTO citas.CATALOGO_ESPECIALIDAD(nombre, activo, id_usuario_creacion, fecha_creacion) VALUES
 ('Medicina General',  1, 1, GETDATE()),
 ('Pediatria',         1, 1, GETDATE()),
 ('Ginecologia',       1, 1, GETDATE()),
 ('Cardiologia',       1, 1, GETDATE()),
 ('Dermatologia',      1, 1, GETDATE()),
 ('Odontologia',       1, 1, GETDATE());
GO

-- Usuarios de prueba (passwords cifradas con SHA2_512 + salt)
DECLARE @idAdminSis INT = (SELECT id_roles FROM citas.ROLES WHERE nombre='admin_sistema');
DECLARE @idAdmin    INT = (SELECT id_roles FROM citas.ROLES WHERE nombre='administrador');
DECLARE @idMedico   INT = (SELECT id_roles FROM citas.ROLES WHERE nombre='medico');
DECLARE @idAsist    INT = (SELECT id_roles FROM citas.ROLES WHERE nombre='asistente');

EXEC citas.spAltaUsuario 'SEED', 1, @idAdminSis, NULL, 'adminMaster', N'adminMaster1', 'Victor Puig Morales',   'adminmaster@citas.local';
EXEC citas.spAltaUsuario 'SEED', 1, @idAdmin,    NULL, 'admin',       N'admin1',       'Juan Lopez',             'admin@citas.local';
EXEC citas.spAltaUsuario 'SEED', 1, @idMedico,   NULL, 'medico',      N'medico1',      'Estefano Lopez Hamill',  'medico@citas.local';
EXEC citas.spAltaUsuario 'SEED', 1, @idAsist,    NULL, 'asistente',   N'asistente1',   'Maria Fernanda Canales', 'asistente@citas.local';
GO

PRINT '==========================================================';
PRINT ' Base de datos CitasMedicas creada correctamente.';
PRINT ' Usuario: citasadmin / admin01$';
PRINT ' Acceso a tablas SOLO via procedimientos almacenados.';
PRINT '==========================================================';
GO