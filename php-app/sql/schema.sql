-- =====================================================================
-- Base de datos CitasMedicas - SQL Server 2022 Express
-- Esquema: citas  |  Usuario: citasadmin
-- 3FN, SPs parametrizados, LOG, acceso solo via EXEC.
-- Concatenacion con '+' y mensajes en variables locales VARCHAR(2000).
-- =====================================================================

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

USE CitasMedicas;
GO

-- ---------------------------------------------------------------------
-- Login, usuario y esquema
-- ---------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'citasadmin')
    CREATE LOGIN citasadmin WITH PASSWORD = 'admin01$', CHECK_POLICY = OFF;
GO

CREATE USER citasadmin FOR LOGIN citasadmin;
GO

CREATE SCHEMA citas AUTHORIZATION citasadmin;
GO

ALTER USER citasadmin WITH DEFAULT_SCHEMA = citas;
GO

-- =====================================================================
-- TABLAS
-- =====================================================================

-- ---------- CATALOGO_PAIS ----------
CREATE TABLE citas.CATALOGO_PAIS (
    id_CATALOGO_PAIS         INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(80)       NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CATALOGO_PAIS PRIMARY KEY (id_CATALOGO_PAIS)
);
GO
CREATE UNIQUE INDEX IX_nombre_CATALOGO_PAIS ON citas.CATALOGO_PAIS(nombre);
GO

-- ---------- CATALOGO_ESTADOS ----------
CREATE TABLE citas.CATALOGO_ESTADOS (
    id_CATALOGO_ESTADOS      INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(80)       NOT NULL,
    id_CATALOGO_PAIS         INT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CATALOGO_ESTADOS PRIMARY KEY (id_CATALOGO_ESTADOS),
    CONSTRAINT FK_id_CATALOGO_PAIS_CATALOGO_PAIS_id_CATALOGO_PAIS_CATALOGO_ESTADOS
        FOREIGN KEY (id_CATALOGO_PAIS) REFERENCES citas.CATALOGO_PAIS(id_CATALOGO_PAIS)
);
GO
CREATE UNIQUE INDEX IX_nombre_id_CATALOGO_PAIS_CATALOGO_ESTADOS
    ON citas.CATALOGO_ESTADOS(nombre, id_CATALOGO_PAIS);
GO

-- ---------- CATALOGO_MUNICIPIO ----------
CREATE TABLE citas.CATALOGO_MUNICIPIO (
    id_CATALOGO_MUNICIPIO    INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(120)      NOT NULL,
    id_CATALOGO_ESTADOS      INT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CATALOGO_MUNICIPIO PRIMARY KEY (id_CATALOGO_MUNICIPIO),
    CONSTRAINT FK_id_CATALOGO_ESTADOS_CATALOGO_ESTADOS_id_CATALOGO_ESTADOS_CATALOGO_MUNICIPIO
        FOREIGN KEY (id_CATALOGO_ESTADOS) REFERENCES citas.CATALOGO_ESTADOS(id_CATALOGO_ESTADOS)
);
GO
CREATE UNIQUE INDEX IX_nombre_id_CATALOGO_ESTADOS_CATALOGO_MUNICIPIO
    ON citas.CATALOGO_MUNICIPIO(nombre, id_CATALOGO_ESTADOS);
GO

-- ---------- CATALOGO_GENERO ----------
CREATE TABLE citas.CATALOGO_GENERO (
    id_CATALOGO_GENERO       INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(30)       NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CATALOGO_GENERO PRIMARY KEY (id_CATALOGO_GENERO)
);
GO
CREATE UNIQUE INDEX IX_nombre_CATALOGO_GENERO ON citas.CATALOGO_GENERO(nombre);
GO

-- ---------- CATALOGO_ESPECIALIDAD ----------
CREATE TABLE citas.CATALOGO_ESPECIALIDAD (
    id_CATALOGO_ESPECIALIDAD INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(120)      NOT NULL,
    id_CLINICA               INT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CATALOGO_ESPECIALIDAD PRIMARY KEY (id_CATALOGO_ESPECIALIDAD)
);
GO
CREATE UNIQUE INDEX IX_nombre_id_CLINICA_CATALOGO_ESPECIALIDAD ON citas.CATALOGO_ESPECIALIDAD(nombre, id_CLINICA);
GO

-- ---------- CATALOGO_ESTADO_CITAS ----------
CREATE TABLE citas.CATALOGO_ESTADO_CITAS (
    id_CATALOGO_ESTADO_CITAS INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(40)       NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CATALOGO_ESTADO_CITAS PRIMARY KEY (id_CATALOGO_ESTADO_CITAS)
);
GO
CREATE UNIQUE INDEX IX_nombre_CATALOGO_ESTADO_CITAS ON citas.CATALOGO_ESTADO_CITAS(nombre);
GO

-- ---------- ROLES ----------
CREATE TABLE citas.ROLES (
    id_ROLES                 INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(60)       NOT NULL,
    descripcion              VARCHAR(200)      NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_ROLES PRIMARY KEY (id_ROLES)
);
GO
CREATE UNIQUE INDEX IX_nombre_ROLES ON citas.ROLES(nombre);
GO

-- ---------- USUARIOS ----------
CREATE TABLE citas.USUARIOS (
    id_USUARIOS              INT IDENTITY(1,1) NOT NULL,
    id_ROLES                 INT               NOT NULL,
    usuario                  VARCHAR(40)       NOT NULL,
    password_hash            VARBINARY(64)     NOT NULL,
    password_salt            VARCHAR(36)       NOT NULL,
    nombre_completo          VARCHAR(150)      NOT NULL,
    email                    VARCHAR(120)      NOT NULL,
    activo                   BIT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_USUARIOS PRIMARY KEY (id_USUARIOS),
    CONSTRAINT FK_id_ROLES_ROLES_id_ROLES_USUARIOS
        FOREIGN KEY (id_ROLES) REFERENCES citas.ROLES(id_ROLES),
    CONSTRAINT CHK_email_USUARIOS CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT CHK_activo_USUARIOS CHECK (activo IN (0,1))
);
GO
CREATE UNIQUE INDEX IX_usuario_USUARIOS ON citas.USUARIOS(usuario);
GO

-- ---------- CLINICA ----------
CREATE TABLE citas.CLINICA (
    id_CLINICA               INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(150)      NOT NULL,
    direccion                VARCHAR(250)      NOT NULL,
    email                    VARCHAR(120)      NOT NULL,
    telefono                 VARCHAR(20)       NOT NULL,
    id_CATALOGO_MUNICIPIO    INT               NOT NULL,
    activo                   BIT               NOT NULL CONSTRAINT DF_activo_CLINICA DEFAULT (1),
    esquema                  VARCHAR(20)       NOT NULL CONSTRAINT DF_esquema_CLINICA DEFAULT ('SOLO_CLINICA'),
    max_asistentes           TINYINT           NOT NULL CONSTRAINT DF_max_asistentes_CLINICA DEFAULT (2),
    max_medicos              TINYINT           NOT NULL CONSTRAINT DF_max_medicos_CLINICA DEFAULT (5),
    max_admins               TINYINT           NOT NULL CONSTRAINT DF_max_admins_CLINICA DEFAULT (1),
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CLINICA PRIMARY KEY (id_CLINICA),
    CONSTRAINT FK_id_CATALOGO_MUNICIPIO_CATALOGO_MUNICIPIO_id_CATALOGO_MUNICIPIO_CLINICA
        FOREIGN KEY (id_CATALOGO_MUNICIPIO) REFERENCES citas.CATALOGO_MUNICIPIO(id_CATALOGO_MUNICIPIO),
    CONSTRAINT CHK_email_CLINICA CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT CHK_esquema_CLINICA CHECK (esquema IN ('SOLO_CONSULTORIO','SOLO_CLINICA'))
);
GO
CREATE UNIQUE INDEX IX_nombre_CLINICA ON citas.CLINICA(nombre);
GO

-- FK diferida: CATALOGO_ESPECIALIDAD.id_CLINICA -> CLINICA.id_CLINICA
ALTER TABLE citas.CATALOGO_ESPECIALIDAD
    ADD CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_CATALOGO_ESPECIALIDAD
    FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA);
GO

-- ---------- USUARIOS_CLINICA ----------
CREATE TABLE citas.USUARIOS_CLINICA (
    id_USUARIOS_CLINICA      INT IDENTITY(1,1) NOT NULL,
    id_USUARIOS              INT               NOT NULL,
    id_CLINICA               INT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_USUARIOS_CLINICA PRIMARY KEY (id_USUARIOS_CLINICA),
    CONSTRAINT FK_id_USUARIOS_USUARIOS_id_USUARIOS_USUARIOS_CLINICA
        FOREIGN KEY (id_USUARIOS) REFERENCES citas.USUARIOS(id_USUARIOS),
    CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_USUARIOS_CLINICA
        FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA)
);
GO
CREATE UNIQUE INDEX IX_id_USUARIOS_id_CLINICA_USUARIOS_CLINICA
    ON citas.USUARIOS_CLINICA(id_USUARIOS, id_CLINICA);
GO

-- ---------- CONSULTORIO ----------
CREATE TABLE citas.CONSULTORIO (
    id_CONSULTORIO           INT IDENTITY(1,1) NOT NULL,
    nombre                   VARCHAR(80)       NOT NULL,
    activo                   BIT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CONSULTORIO PRIMARY KEY (id_CONSULTORIO),
    CONSTRAINT CHK_activo_CONSULTORIO CHECK (activo IN (0,1))
);
GO

-- ---------- CLINICA_CONSULTORIO ----------
CREATE TABLE citas.CLINICA_CONSULTORIO (
    id_CLINICA_CONSULTORIO   INT IDENTITY(1,1) NOT NULL,
    id_CLINICA               INT               NOT NULL,
    id_CONSULTORIO           INT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CLINICA_CONSULTORIO PRIMARY KEY (id_CLINICA_CONSULTORIO),
    CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_CLINICA_CONSULTORIO
        FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA),
    CONSTRAINT FK_id_CONSULTORIO_CONSULTORIO_id_CONSULTORIO_CLINICA_CONSULTORIO
        FOREIGN KEY (id_CONSULTORIO) REFERENCES citas.CONSULTORIO(id_CONSULTORIO)
);
GO
CREATE UNIQUE INDEX IX_id_CLINICA_id_CONSULTORIO_CLINICA_CONSULTORIO
    ON citas.CLINICA_CONSULTORIO(id_CLINICA, id_CONSULTORIO);
GO

-- ---------- MEDICO ----------
CREATE TABLE citas.MEDICO (
    id_MEDICO                INT IDENTITY(1,1) NOT NULL,
    id_CLINICA               INT               NOT NULL,
    nombre_completo          VARCHAR(150)      NOT NULL,
    activo                   BIT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_MEDICO PRIMARY KEY (id_MEDICO),
    CONSTRAINT CHK_activo_MEDICO CHECK (activo IN (0,1)),
    CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_MEDICO
        FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA)
);
GO

-- ---------- MEDICO_ESPECIALIDAD ----------
CREATE TABLE citas.MEDICO_ESPECIALIDAD (
    id_MEDICO_ESPECIALIDAD   INT IDENTITY(1,1) NOT NULL,
    id_MEDICO                INT               NOT NULL,
    id_CATALOGO_ESPECIALIDAD INT               NOT NULL,
    id_CLINICA               INT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_MEDICO_ESPECIALIDAD PRIMARY KEY (id_MEDICO_ESPECIALIDAD),
    CONSTRAINT FK_id_MEDICO_MEDICO_id_MEDICO_MEDICO_ESPECIALIDAD
        FOREIGN KEY (id_MEDICO) REFERENCES citas.MEDICO(id_MEDICO),
    CONSTRAINT FK_id_CATALOGO_ESPECIALIDAD_CATALOGO_ESPECIALIDAD_id_CATALOGO_ESPECIALIDAD_MEDICO_ESPECIALIDAD
        FOREIGN KEY (id_CATALOGO_ESPECIALIDAD) REFERENCES citas.CATALOGO_ESPECIALIDAD(id_CATALOGO_ESPECIALIDAD),
    CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_MEDICO_ESPECIALIDAD
        FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA)
);
GO
CREATE UNIQUE INDEX IX_id_MEDICO_id_CATALOGO_ESPECIALIDAD_id_CLINICA_MEDICO_ESPECIALIDAD
    ON citas.MEDICO_ESPECIALIDAD(id_MEDICO, id_CATALOGO_ESPECIALIDAD, id_CLINICA);
GO

-- ---------- PACIENTE ----------
CREATE TABLE citas.PACIENTE (
    id_PACIENTE              INT IDENTITY(1,1) NOT NULL,
    id_CLINICA               INT               NOT NULL,
    ap_paterno               VARCHAR(80)       NOT NULL,
    ap_materno               VARCHAR(80)       NOT NULL,
    nombre                   VARCHAR(120)      NOT NULL,
    direccion                VARCHAR(250)      NOT NULL,
    telefono                 VARCHAR(20)       NOT NULL,
    email                    VARCHAR(120)      NOT NULL,
    fecha_nacimiento         DATE              NOT NULL,
    id_CATALOGO_GENERO       INT               NOT NULL,
    id_CATALOGO_MUNICIPIO    INT               NOT NULL,
    observaciones            VARCHAR(5000)      NULL,
    notifica_email           BIT               NOT NULL DEFAULT(0),
    notifica_wa              BIT               NOT NULL DEFAULT(0),
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_PACIENTE PRIMARY KEY (id_PACIENTE),
    CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_PACIENTE
        FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA),
    CONSTRAINT FK_id_CATALOGO_GENERO_CATALOGO_GENERO_id_CATALOGO_GENERO_PACIENTE
        FOREIGN KEY (id_CATALOGO_GENERO) REFERENCES citas.CATALOGO_GENERO(id_CATALOGO_GENERO),
    CONSTRAINT FK_id_CATALOGO_MUNICIPIO_CATALOGO_MUNICIPIO_id_CATALOGO_MUNICIPIO_PACIENTE
        FOREIGN KEY (id_CATALOGO_MUNICIPIO) REFERENCES citas.CATALOGO_MUNICIPIO(id_CATALOGO_MUNICIPIO),
    CONSTRAINT CHK_email_PACIENTE CHECK (email = '' OR email LIKE '%_@_%._%')
);
GO
CREATE UNIQUE INDEX IX_id_CLINICA_ap_paterno_ap_materno_nombre_PACIENTE
    ON citas.PACIENTE(id_CLINICA, ap_paterno, ap_materno, nombre);
GO

-- ---------- CITA ----------
CREATE TABLE citas.CITA (
    id_CITA                     INT IDENTITY(1,1) NOT NULL,
    id_PACIENTE                 INT               NOT NULL,
    fecha_cita                  DATE              NOT NULL,
    hora_inicio                 TIME(0)           NOT NULL,
    hora_fin                    TIME(0)           NOT NULL,
    id_CATALOGO_ESTADO_CITAS    INT               NOT NULL,
    observaciones               VARCHAR(500)      NOT NULL,
    horas_anticipacion_notif    TINYINT           NOT NULL CONSTRAINT DF_horas_anticipacion_CITA DEFAULT 24,
    precio                      DECIMAL(10,2)     NOT NULL,
    notificado                  BIT               NOT NULL CONSTRAINT DF_notificado_CITA DEFAULT (0),
    id_MEDICO                   INT               NOT NULL,
    id_CATALOGO_ESPECIALIDAD    INT               NOT NULL,
    id_CONSULTORIO              INT               NOT NULL,
    id_usuario_creacion         TINYINT           NOT NULL,
    fecha_creacion              SMALLDATETIME     NOT NULL,
    id_usuario_modificacion     TINYINT           NULL,
    fecha_modificacion          SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CITA PRIMARY KEY (id_CITA),
    CONSTRAINT FK_id_PACIENTE_PACIENTE_id_PACIENTE_CITA
        FOREIGN KEY (id_PACIENTE) REFERENCES citas.PACIENTE(id_PACIENTE),
    CONSTRAINT FK_id_CATALOGO_ESTADO_CITAS_CATALOGO_ESTADO_CITAS_id_CATALOGO_ESTADO_CITAS_CITA
        FOREIGN KEY (id_CATALOGO_ESTADO_CITAS) REFERENCES citas.CATALOGO_ESTADO_CITAS(id_CATALOGO_ESTADO_CITAS),
    -- El medico de la cita es un USUARIO con perfil "Medico" asignado a la clinica.
    CONSTRAINT FK_id_MEDICO_USUARIOS_id_USUARIOS_CITA
        FOREIGN KEY (id_MEDICO) REFERENCES citas.USUARIOS(id_USUARIOS),
    CONSTRAINT FK_id_CATALOGO_ESPECIALIDAD_CATALOGO_ESPECIALIDAD_id_CATALOGO_ESPECIALIDAD_CITA
        FOREIGN KEY (id_CATALOGO_ESPECIALIDAD) REFERENCES citas.CATALOGO_ESPECIALIDAD(id_CATALOGO_ESPECIALIDAD),
    CONSTRAINT FK_id_CONSULTORIO_CONSULTORIO_id_CONSULTORIO_CITA
        FOREIGN KEY (id_CONSULTORIO) REFERENCES citas.CONSULTORIO(id_CONSULTORIO),
    CONSTRAINT CHK_hora_CITA               CHECK (hora_fin > hora_inicio),
    CONSTRAINT CHK_precio_CITA             CHECK (precio >= 0),
    CONSTRAINT CHK_horas_anticipacion_CITA CHECK (horas_anticipacion_notif BETWEEN 1 AND 168)
);
GO
CREATE INDEX IX_fecha_cita_id_MEDICO_CITA ON citas.CITA(fecha_cita, id_MEDICO);
CREATE INDEX IX_id_PACIENTE_CITA          ON citas.CITA(id_PACIENTE);
GO

-- ---------- LOG ----------
CREATE TABLE citas.LOG (
    id_log         INT IDENTITY(1,1) NOT NULL,
    modulo         VARCHAR(30)       NOT NULL,
    procedimiento  VARCHAR(300)      NOT NULL,
    tabla          VARCHAR(50)       NOT NULL,
    evento         VARCHAR(2000)     NOT NULL,
    fecha          SMALLDATETIME     NOT NULL,
    id_usuario     TINYINT           NOT NULL,
    CONSTRAINT PK_id_LOG PRIMARY KEY (id_log)
);
GO

-- =====================================================================
-- GRANTS: solo EXEC, denegar acceso directo
-- =====================================================================
GRANT EXECUTE ON SCHEMA::citas TO citasadmin;
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::citas TO citasadmin;
GO

-- =====================================================================
-- PROCEDIMIENTOS ALMACENADOS
-- Plantilla: TRY/CATCH + LOG + ;THROW
-- =====================================================================

-- =========================  CATALOGO_PAIS  ===========================
CREATE OR ALTER PROCEDURE citas.spAltaPais
    @nombre VARCHAR(80), @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CATALOGO_PAIS(nombre, id_usuario_creacion, fecha_creacion)
            VALUES(@nombre, @id_usuario, GETDATE());
            SET @id_nuevo = SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg = 'Alta Pais id=' + CONVERT(VARCHAR(20), @id_nuevo) + ' nombre=' + @nombre;
            INSERT INTO citas.LOG(modulo,procedimiento,tabla,evento,fecha,id_usuario)
            VALUES('CATALOGO_PAIS','spAltaPais','CATALOGO_PAIS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err = 'ERROR spAltaPais: ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG(modulo,procedimiento,tabla,evento,fecha,id_usuario)
        VALUES('CATALOGO_PAIS','spAltaPais','CATALOGO_PAIS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioPais
    @id_CATALOGO_PAIS INT, @nombre VARCHAR(80), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CATALOGO_PAIS
               SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CATALOGO_PAIS=@id_CATALOGO_PAIS;
            DECLARE @msg VARCHAR(2000);
            SET @msg = 'Cambio Pais id=' + CONVERT(VARCHAR(20), @id_CATALOGO_PAIS);
            INSERT INTO citas.LOG(modulo,procedimiento,tabla,evento,fecha,id_usuario)
            VALUES('CATALOGO_PAIS','spCambioPais','CATALOGO_PAIS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioPais: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_PAIS','spCambioPais','CATALOGO_PAIS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaPaises
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_CATALOGO_PAIS, nombre FROM citas.CATALOGO_PAIS ORDER BY nombre;
END
GO

-- =========================  CATALOGO_ESTADOS  ========================
CREATE OR ALTER PROCEDURE citas.spAltaEstado
    @nombre VARCHAR(80), @id_CATALOGO_PAIS INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CATALOGO_ESTADOS(nombre,id_CATALOGO_PAIS,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@id_CATALOGO_PAIS,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Estado id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre;
            INSERT INTO citas.LOG VALUES('CATALOGO_ESTADOS','spAltaEstado','CATALOGO_ESTADOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaEstado: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_ESTADOS','spAltaEstado','CATALOGO_ESTADOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioEstado
    @id_CATALOGO_ESTADOS INT, @nombre VARCHAR(80), @id_CATALOGO_PAIS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CATALOGO_ESTADOS
               SET nombre=@nombre, id_CATALOGO_PAIS=@id_CATALOGO_PAIS,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CATALOGO_ESTADOS=@id_CATALOGO_ESTADOS;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Estado id='+CONVERT(VARCHAR(20),@id_CATALOGO_ESTADOS);
            INSERT INTO citas.LOG VALUES('CATALOGO_ESTADOS','spCambioEstado','CATALOGO_ESTADOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioEstado: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_ESTADOS','spCambioEstado','CATALOGO_ESTADOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaEstados
    @id_CATALOGO_PAIS INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT e.id_CATALOGO_ESTADOS, e.nombre, e.id_CATALOGO_PAIS, p.nombre AS pais
      FROM citas.CATALOGO_ESTADOS e
      JOIN citas.CATALOGO_PAIS    p ON p.id_CATALOGO_PAIS = e.id_CATALOGO_PAIS
     WHERE (@id_CATALOGO_PAIS IS NULL OR e.id_CATALOGO_PAIS = @id_CATALOGO_PAIS)
     ORDER BY e.nombre;
END
GO

-- =========================  CATALOGO_MUNICIPIO  ======================
CREATE OR ALTER PROCEDURE citas.spAltaMunicipio
    @nombre VARCHAR(120), @id_CATALOGO_ESTADOS INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CATALOGO_MUNICIPIO(nombre,id_CATALOGO_ESTADOS,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@id_CATALOGO_ESTADOS,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Municipio id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre;
            INSERT INTO citas.LOG VALUES('CATALOGO_MUNICIPIO','spAltaMunicipio','CATALOGO_MUNICIPIO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaMunicipio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_MUNICIPIO','spAltaMunicipio','CATALOGO_MUNICIPIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioMunicipio
    @id_CATALOGO_MUNICIPIO INT, @nombre VARCHAR(120), @id_CATALOGO_ESTADOS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CATALOGO_MUNICIPIO
               SET nombre=@nombre, id_CATALOGO_ESTADOS=@id_CATALOGO_ESTADOS,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CATALOGO_MUNICIPIO=@id_CATALOGO_MUNICIPIO;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Municipio id='+CONVERT(VARCHAR(20),@id_CATALOGO_MUNICIPIO);
            INSERT INTO citas.LOG VALUES('CATALOGO_MUNICIPIO','spCambioMunicipio','CATALOGO_MUNICIPIO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioMunicipio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_MUNICIPIO','spCambioMunicipio','CATALOGO_MUNICIPIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaMunicipios
    @id_CATALOGO_ESTADOS INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT m.id_CATALOGO_MUNICIPIO, m.nombre, m.id_CATALOGO_ESTADOS, e.nombre AS estado,
           e.id_CATALOGO_PAIS, p.nombre AS pais
      FROM citas.CATALOGO_MUNICIPIO m
      JOIN citas.CATALOGO_ESTADOS   e ON e.id_CATALOGO_ESTADOS = m.id_CATALOGO_ESTADOS
      JOIN citas.CATALOGO_PAIS      p ON p.id_CATALOGO_PAIS    = e.id_CATALOGO_PAIS
     WHERE (@id_CATALOGO_ESTADOS IS NULL OR m.id_CATALOGO_ESTADOS = @id_CATALOGO_ESTADOS)
     ORDER BY m.nombre;
END
GO

-- =========================  CATALOGO_GENERO  =========================
CREATE OR ALTER PROCEDURE citas.spAltaGenero
    @nombre VARCHAR(30), @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CATALOGO_GENERO(nombre,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Genero id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre;
            INSERT INTO citas.LOG VALUES('CATALOGO_GENERO','spAltaGenero','CATALOGO_GENERO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaGenero: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_GENERO','spAltaGenero','CATALOGO_GENERO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioGenero
    @id_CATALOGO_GENERO INT, @nombre VARCHAR(30), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CATALOGO_GENERO
               SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CATALOGO_GENERO=@id_CATALOGO_GENERO;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Genero id='+CONVERT(VARCHAR(20),@id_CATALOGO_GENERO);
            INSERT INTO citas.LOG VALUES('CATALOGO_GENERO','spCambioGenero','CATALOGO_GENERO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioGenero: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_GENERO','spCambioGenero','CATALOGO_GENERO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaGeneros
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_CATALOGO_GENERO, nombre FROM citas.CATALOGO_GENERO ORDER BY nombre;
END
GO

-- =========================  CATALOGO_ESPECIALIDAD  ===================
CREATE OR ALTER PROCEDURE citas.spAltaEspecialidad
    @nombre VARCHAR(120), @id_CLINICA INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CATALOGO_ESPECIALIDAD(nombre,id_CLINICA,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@id_CLINICA,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            DECLARE @cli VARCHAR(150);
            SELECT @cli=nombre FROM citas.CLINICA WHERE id_CLINICA=@id_CLINICA;
            SET @msg='Alta Especialidad id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre
                    +' clinica='+ISNULL(@cli,'?')
                    +' por usuario id='+CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('CATALOGO_ESPECIALIDAD','spAltaEspecialidad','CATALOGO_ESPECIALIDAD',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaEspecialidad: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_ESPECIALIDAD','spAltaEspecialidad','CATALOGO_ESPECIALIDAD',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioEspecialidad
    @id_CATALOGO_ESPECIALIDAD INT, @nombre VARCHAR(120), @id_CLINICA INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CATALOGO_ESPECIALIDAD
               SET nombre=@nombre, id_CLINICA=@id_CLINICA,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CATALOGO_ESPECIALIDAD=@id_CATALOGO_ESPECIALIDAD;
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

CREATE OR ALTER PROCEDURE citas.spRegresaEspecialidades
    @id_CLINICA INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT e.id_CATALOGO_ESPECIALIDAD, e.nombre, e.id_CLINICA, c.nombre AS clinica
      FROM citas.CATALOGO_ESPECIALIDAD e
      JOIN citas.CLINICA c ON c.id_CLINICA = e.id_CLINICA
     WHERE (@id_CLINICA IS NULL OR e.id_CLINICA = @id_CLINICA)
     ORDER BY e.nombre;
END
GO

-- =========================  CATALOGO_ESTADO_CITAS  ===================
CREATE OR ALTER PROCEDURE citas.spAltaEstadoCita
    @nombre VARCHAR(40), @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CATALOGO_ESTADO_CITAS(nombre,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta EstadoCita id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre;
            INSERT INTO citas.LOG VALUES('CATALOGO_ESTADO_CITAS','spAltaEstadoCita','CATALOGO_ESTADO_CITAS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaEstadoCita: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_ESTADO_CITAS','spAltaEstadoCita','CATALOGO_ESTADO_CITAS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioEstadoCita
    @id_CATALOGO_ESTADO_CITAS INT, @nombre VARCHAR(40), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CATALOGO_ESTADO_CITAS
               SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CATALOGO_ESTADO_CITAS=@id_CATALOGO_ESTADO_CITAS;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio EstadoCita id='+CONVERT(VARCHAR(20),@id_CATALOGO_ESTADO_CITAS);
            INSERT INTO citas.LOG VALUES('CATALOGO_ESTADO_CITAS','spCambioEstadoCita','CATALOGO_ESTADO_CITAS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioEstadoCita: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_ESTADO_CITAS','spCambioEstadoCita','CATALOGO_ESTADO_CITAS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaEstadosCita
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_CATALOGO_ESTADO_CITAS, nombre FROM citas.CATALOGO_ESTADO_CITAS ORDER BY nombre;
END
GO

-- =========================  ROLES  ===================================
CREATE OR ALTER PROCEDURE citas.spAltaRol
    @nombre VARCHAR(60), @descripcion VARCHAR(200), @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.ROLES(nombre,descripcion,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@descripcion,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Rol id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre;
            INSERT INTO citas.LOG VALUES('ROLES','spAltaRol','ROLES',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaRol: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('ROLES','spAltaRol','ROLES',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioRol
    @id_ROLES INT, @nombre VARCHAR(60), @descripcion VARCHAR(200), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.ROLES
               SET nombre=@nombre, descripcion=@descripcion,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_ROLES=@id_ROLES;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Rol id='+CONVERT(VARCHAR(20),@id_ROLES);
            INSERT INTO citas.LOG VALUES('ROLES','spCambioRol','ROLES',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioRol: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('ROLES','spCambioRol','ROLES',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaRoles
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_ROLES, nombre, descripcion FROM citas.ROLES ORDER BY nombre;
END
GO

-- =========================  USUARIOS  ================================
CREATE OR ALTER PROCEDURE citas.spAltaUsuario
    @id_ROLES INT, @usuario VARCHAR(40), @password VARCHAR(200),
    @nombre_completo VARCHAR(150), @email VARCHAR(120),
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DECLARE @salt VARCHAR(36) = CONVERT(VARCHAR(36), NEWID());
            DECLARE @hash VARBINARY(64) = HASHBYTES('SHA2_512', @password + @salt);
            INSERT INTO citas.USUARIOS(id_ROLES,usuario,password_hash,password_salt,
                                       nombre_completo,email,activo,id_usuario_creacion,fecha_creacion)
            VALUES(@id_ROLES,@usuario,@hash,@salt,@nombre_completo,@email,1,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Usuario id='+CONVERT(VARCHAR(20),@id_nuevo)+' usuario='+@usuario;
            INSERT INTO citas.LOG VALUES('USUARIOS','spAltaUsuario','USUARIOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaUsuario: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS','spAltaUsuario','USUARIOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioUsuario
    @id_USUARIOS INT, @id_ROLES INT, @nombre_completo VARCHAR(150),
    @email VARCHAR(120), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.USUARIOS
               SET id_ROLES=@id_ROLES, nombre_completo=@nombre_completo, email=@email,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_USUARIOS=@id_USUARIOS;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Usuario id='+CONVERT(VARCHAR(20),@id_USUARIOS);
            INSERT INTO citas.LOG VALUES('USUARIOS','spCambioUsuario','USUARIOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioUsuario: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS','spCambioUsuario','USUARIOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioPassword
    @id_USUARIOS INT, @password VARCHAR(200), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DECLARE @salt VARCHAR(36) = CONVERT(VARCHAR(36), NEWID());
            DECLARE @hash VARBINARY(64) = HASHBYTES('SHA2_512', @password + @salt);
            UPDATE citas.USUARIOS
               SET password_hash=@hash, password_salt=@salt,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_USUARIOS=@id_USUARIOS;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Password id='+CONVERT(VARCHAR(20),@id_USUARIOS);
            INSERT INTO citas.LOG VALUES('USUARIOS','spCambioPassword','USUARIOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioPassword: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS','spCambioPassword','USUARIOS',@err,GETDATE(),ISNULL(@id_usuario,0));
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
        DECLARE @id_ROLES_act INT, @cli_act INT;
        SELECT @id_ROLES_act = id_ROLES FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS;
        DECLARE cur_cli CURSOR LOCAL FAST_FORWARD FOR
            SELECT DISTINCT id_CLINICA FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS = @id_USUARIOS;
        OPEN cur_cli;
        FETCH NEXT FROM cur_cli INTO @cli_act;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC citas.spValidaCupoUsuarioClinica @id_CLINICA=@cli_act, @id_ROLES=@id_ROLES_act,
                 @id_usuario=@id_usuario, @id_USUARIOS=@id_USUARIOS;
            FETCH NEXT FROM cur_cli INTO @cli_act;
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

CREATE OR ALTER PROCEDURE citas.spDesactivaUsuario
    @id_USUARIOS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.USUARIOS
               SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_USUARIOS=@id_USUARIOS;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Desactiva Usuario id='+CONVERT(VARCHAR(20),@id_USUARIOS);
            INSERT INTO citas.LOG VALUES('USUARIOS','spDesactivaUsuario','USUARIOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spDesactivaUsuario: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS','spDesactivaUsuario','USUARIOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaUsuario
    @id_USUARIOS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @usuario VARCHAR(50), @detalle VARCHAR(1000) = '';
        SELECT @usuario = usuario FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS;

        IF @usuario IS NULL
            ;THROW 51001, 'El usuario no existe o ya fue eliminado.', 1;

        DECLARE @nClinicas INT, @nCitas INT, @nConsultorios INT;

        SELECT @nClinicas = COUNT(*) FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS = @id_USUARIOS;
        SELECT @nCitas    = COUNT(*) FROM citas.CITA            WHERE id_MEDICO   = @id_USUARIOS;
        SELECT @nConsultorios = COUNT(DISTINCT cc.id_CONSULTORIO)
          FROM citas.USUARIOS_CLINICA uc
          JOIN citas.CLINICA_CONSULTORIO cc ON cc.id_CLINICA = uc.id_CLINICA
         WHERE uc.id_USUARIOS = @id_USUARIOS;

        IF (@nClinicas > 0 OR @nCitas > 0 OR @nConsultorios > 0)
        BEGIN
            IF @nClinicas > 0
                SET @detalle = @detalle + CONVERT(VARCHAR(10),@nClinicas) + ' clinica(s); ';
            IF @nConsultorios > 0
                SET @detalle = @detalle + CONVERT(VARCHAR(10),@nConsultorios) + ' consultorio(s); ';
            IF @nCitas > 0
                SET @detalle = @detalle + CONVERT(VARCHAR(10),@nCitas) + ' cita(s); ';

            DECLARE @logNo VARCHAR(2000) =
                'BAJA RECHAZADA Usuario id=' + CONVERT(VARCHAR(20),@id_USUARIOS) +
                ' usuario=' + @usuario + ' asociaciones: ' + @detalle +
                ' solicitada por id_usuario=' + CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('USUARIOS','spBajaUsuario','USUARIOS',@logNo,GETDATE(),@id_usuario);

            DECLARE @msgErr NVARCHAR(2000) =
                N'No se puede eliminar el usuario "' + @usuario +
                N'" porque tiene informacion asociada: ' + @detalle +
                N'Elimine o reasigne esas asociaciones, o desactive el usuario.';
            ;THROW 51000, @msgErr, 1;
        END

        BEGIN TRAN;
            DELETE FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS;
            DECLARE @msg VARCHAR(2000) =
                'BAJA OK Usuario id=' + CONVERT(VARCHAR(20),@id_USUARIOS) +
                ' usuario=' + @usuario +
                ' realizada por id_usuario=' + CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('USUARIOS','spBajaUsuario','USUARIOS',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaUsuario id=' + CONVERT(VARCHAR(20),@id_USUARIOS) +
                 ' por id_usuario=' + CONVERT(VARCHAR(10),ISNULL(@id_usuario,0)) + ': ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS','spBajaUsuario','USUARIOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaUsuarios
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.id_USUARIOS, u.usuario, u.nombre_completo, u.email, u.activo,
           u.id_ROLES, r.nombre AS rol,
           uc.id_CLINICA, c.nombre AS clinica
      FROM citas.USUARIOS u
      JOIN citas.ROLES    r  ON r.id_ROLES = u.id_ROLES
      LEFT JOIN citas.USUARIOS_CLINICA uc ON uc.id_USUARIOS = u.id_USUARIOS
      LEFT JOIN citas.CLINICA c  ON c.id_CLINICA = uc.id_CLINICA
     ORDER BY u.usuario;
END
GO

CREATE OR ALTER PROCEDURE citas.spLoginUsuario
    @usuario VARCHAR(40), @password VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT TOP 1
               u.id_USUARIOS, u.usuario, u.nombre_completo, u.email,
               u.id_ROLES, r.nombre AS rol,
               uc.id_CLINICA
          FROM citas.USUARIOS u
          JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
          LEFT JOIN citas.USUARIOS_CLINICA uc ON uc.id_USUARIOS = u.id_USUARIOS
         WHERE u.usuario = @usuario
           AND u.activo  = 1
           AND u.password_hash = HASHBYTES('SHA2_512', @password + u.password_salt);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spLoginUsuario: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('LOGIN','spLoginUsuario','USUARIOS',@err,GETDATE(),0);
        ;THROW;
    END CATCH
END
GO

-- =========================  USUARIOS_CLINICA  ========================
CREATE OR ALTER PROCEDURE citas.spAltaUsuarioClinica
    @id_USUARIOS INT, @id_CLINICA INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @id_ROLES_asg INT;
        SELECT @id_ROLES_asg = id_ROLES FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS;
        EXEC citas.spValidaCupoUsuarioClinica @id_CLINICA=@id_CLINICA, @id_ROLES=@id_ROLES_asg,
             @id_usuario=@id_usuario, @id_USUARIOS=@id_USUARIOS;
        BEGIN TRAN;
            INSERT INTO citas.USUARIOS_CLINICA(id_USUARIOS,id_CLINICA,id_usuario_creacion,fecha_creacion)
            VALUES(@id_USUARIOS,@id_CLINICA,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta UsuarioClinica id='+CONVERT(VARCHAR(20),@id_nuevo)
                   +' usuario='+CONVERT(VARCHAR(20),@id_USUARIOS)
                   +' clinica='+CONVERT(VARCHAR(20),@id_CLINICA);
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

CREATE OR ALTER PROCEDURE citas.spBajaUsuarioClinica
    @id_USUARIOS_CLINICA INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DELETE FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS_CLINICA=@id_USUARIOS_CLINICA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Baja UsuarioClinica id='+CONVERT(VARCHAR(20),@id_USUARIOS_CLINICA);
            INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spBajaUsuarioClinica','USUARIOS_CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaUsuarioClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('USUARIOS_CLINICA','spBajaUsuarioClinica','USUARIOS_CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaUsuariosClinica
    @id_CLINICA INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT uc.id_USUARIOS_CLINICA, uc.id_USUARIOS, u.usuario, u.nombre_completo,
           uc.id_CLINICA, c.nombre AS clinica
      FROM citas.USUARIOS_CLINICA uc
      JOIN citas.USUARIOS u ON u.id_USUARIOS = uc.id_USUARIOS
      JOIN citas.CLINICA  c ON c.id_CLINICA  = uc.id_CLINICA
     WHERE (@id_CLINICA IS NULL OR uc.id_CLINICA = @id_CLINICA)
     ORDER BY c.nombre, u.usuario;
END
GO

-- =========================  CLINICA  =================================
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
                                       activo,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@direccion,@email,@telefono,@id_CATALOGO_MUNICIPIO,
                   @esquema,@max_asistentes,@max_medicos,@max_admins,1,@id_usuario,GETDATE());
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

CREATE OR ALTER PROCEDURE citas.spBajaClinica
    @id_CLINICA INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DELETE FROM citas.CLINICA WHERE id_CLINICA=@id_CLINICA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Baja Clinica id='+CONVERT(VARCHAR(20),@id_CLINICA);
            INSERT INTO citas.LOG VALUES('CLINICA','spBajaClinica','CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CLINICA','spBajaClinica','CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spValidaCupoUsuarioClinica
    @id_CLINICA INT,
    @id_ROLES INT,
    @id_usuario TINYINT = 0,
    @id_USUARIOS INT = NULL
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

    IF @limite IS NULL RETURN;

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

CREATE OR ALTER PROCEDURE citas.spActivaClinica
    @id_CLINICA INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CLINICA SET activo=1,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CLINICA=@id_CLINICA;
            DECLARE @cli VARCHAR(150);
            SELECT @cli=nombre FROM citas.CLINICA WHERE id_CLINICA=@id_CLINICA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Activa Clinica id='+CONVERT(VARCHAR(20),@id_CLINICA)
                    +' nombre='+ISNULL(@cli,'?')
                    +' por usuario id='+CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('CLINICA','spActivaClinica','CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spActivaClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CLINICA','spActivaClinica','CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spDesactivaClinica
    @id_CLINICA INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CLINICA SET activo=0,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CLINICA=@id_CLINICA;
            DECLARE @cli VARCHAR(150);
            SELECT @cli=nombre FROM citas.CLINICA WHERE id_CLINICA=@id_CLINICA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Desactiva Clinica id='+CONVERT(VARCHAR(20),@id_CLINICA)
                    +' nombre='+ISNULL(@cli,'?')
                    +' por usuario id='+CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('CLINICA','spDesactivaClinica','CLINICA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spDesactivaClinica: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CLINICA','spDesactivaClinica','CLINICA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
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

-- =========================  CONSULTORIO  =============================
CREATE OR ALTER PROCEDURE citas.spAltaConsultorio
    @id_CLINICA INT, @nombre VARCHAR(80), @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CONSULTORIO(nombre,activo,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,1,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            INSERT INTO citas.CLINICA_CONSULTORIO(id_CLINICA,id_CONSULTORIO,id_usuario_creacion,fecha_creacion)
            VALUES(@id_CLINICA,@id_nuevo,@id_usuario,GETDATE());
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Consultorio id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre+' clinica='+CONVERT(VARCHAR(20),@id_CLINICA);
            INSERT INTO citas.LOG VALUES('CONSULTORIO','spAltaConsultorio','CONSULTORIO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaConsultorio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CONSULTORIO','spAltaConsultorio','CONSULTORIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioConsultorio
    @id_CONSULTORIO INT, @id_CLINICA INT, @nombre VARCHAR(80), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
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

CREATE OR ALTER PROCEDURE citas.spActivaConsultorio
    @id_CONSULTORIO INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CONSULTORIO
               SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CONSULTORIO=@id_CONSULTORIO;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Activa Consultorio id='+CONVERT(VARCHAR(20),@id_CONSULTORIO);
            INSERT INTO citas.LOG VALUES('CONSULTORIO','spActivaConsultorio','CONSULTORIO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spActivaConsultorio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CONSULTORIO','spActivaConsultorio','CONSULTORIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaConsultorio
    @id_CONSULTORIO INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
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

CREATE OR ALTER PROCEDURE citas.spDesactivaConsultorio
    @id_CONSULTORIO INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CONSULTORIO
               SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CONSULTORIO=@id_CONSULTORIO;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Desactiva Consultorio id='+CONVERT(VARCHAR(20),@id_CONSULTORIO);
            INSERT INTO citas.LOG VALUES('CONSULTORIO','spDesactivaConsultorio','CONSULTORIO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spDesactivaConsultorio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CONSULTORIO','spDesactivaConsultorio','CONSULTORIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaConsultorios
AS
BEGIN
    SET NOCOUNT ON;
    SELECT co.id_CONSULTORIO, co.nombre, co.activo,
           cc.id_CLINICA, cl.nombre AS clinica
      FROM citas.CONSULTORIO co
      LEFT JOIN citas.CLINICA_CONSULTORIO cc ON cc.id_CONSULTORIO = co.id_CONSULTORIO
      LEFT JOIN citas.CLINICA cl ON cl.id_CLINICA = cc.id_CLINICA
     ORDER BY co.nombre;
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaConsultoriosPorClinica
    @id_CLINICA INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT co.id_CONSULTORIO, co.nombre, co.activo
      FROM citas.CLINICA_CONSULTORIO cc
      JOIN citas.CONSULTORIO co ON co.id_CONSULTORIO = cc.id_CONSULTORIO
     WHERE cc.id_CLINICA = @id_CLINICA AND co.activo = 1
     ORDER BY co.nombre;
END
GO

-- =========================  CLINICA_CONSULTORIO  =====================
CREATE OR ALTER PROCEDURE citas.spAltaClinicaConsultorio
    @id_CLINICA INT, @id_CONSULTORIO INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CLINICA_CONSULTORIO(id_CLINICA,id_CONSULTORIO,id_usuario_creacion,fecha_creacion)
            VALUES(@id_CLINICA,@id_CONSULTORIO,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta ClinicaConsultorio id='+CONVERT(VARCHAR(20),@id_nuevo);
            INSERT INTO citas.LOG VALUES('CLINICA_CONSULTORIO','spAltaClinicaConsultorio','CLINICA_CONSULTORIO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaClinicaConsultorio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CLINICA_CONSULTORIO','spAltaClinicaConsultorio','CLINICA_CONSULTORIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaClinicaConsultorio
    @id_CLINICA_CONSULTORIO INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DELETE FROM citas.CLINICA_CONSULTORIO WHERE id_CLINICA_CONSULTORIO=@id_CLINICA_CONSULTORIO;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Baja ClinicaConsultorio id='+CONVERT(VARCHAR(20),@id_CLINICA_CONSULTORIO);
            INSERT INTO citas.LOG VALUES('CLINICA_CONSULTORIO','spBajaClinicaConsultorio','CLINICA_CONSULTORIO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaClinicaConsultorio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CLINICA_CONSULTORIO','spBajaClinicaConsultorio','CLINICA_CONSULTORIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaClinicaConsultorio
    @id_CLINICA INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT cc.id_CLINICA_CONSULTORIO, cc.id_CLINICA, c.nombre AS clinica,
           cc.id_CONSULTORIO, co.nombre AS consultorio, co.activo
      FROM citas.CLINICA_CONSULTORIO cc
      JOIN citas.CLINICA     c  ON c.id_CLINICA     = cc.id_CLINICA
      JOIN citas.CONSULTORIO co ON co.id_CONSULTORIO= cc.id_CONSULTORIO
     WHERE (@id_CLINICA IS NULL OR cc.id_CLINICA = @id_CLINICA)
     ORDER BY c.nombre, co.nombre;
END
GO

-- =========================  MEDICO  ==================================
CREATE OR ALTER PROCEDURE citas.spAltaMedico
    @id_CLINICA INT, @nombre_completo VARCHAR(150), @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.MEDICO(id_CLINICA,nombre_completo,activo,id_usuario_creacion,fecha_creacion)
            VALUES(@id_CLINICA,@nombre_completo,1,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Medico id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre_completo;
            INSERT INTO citas.LOG VALUES('MEDICO','spAltaMedico','MEDICO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaMedico: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('MEDICO','spAltaMedico','MEDICO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spCambioMedico
    @id_MEDICO INT, @id_CLINICA INT, @nombre_completo VARCHAR(150), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.MEDICO
               SET id_CLINICA=@id_CLINICA,
                   nombre_completo=@nombre_completo,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_MEDICO=@id_MEDICO;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Medico id='+CONVERT(VARCHAR(20),@id_MEDICO);
            INSERT INTO citas.LOG VALUES('MEDICO','spCambioMedico','MEDICO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCambioMedico: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('MEDICO','spCambioMedico','MEDICO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spActivaMedico
    @id_MEDICO INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.MEDICO SET activo=1, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_MEDICO=@id_MEDICO;
            DECLARE @msg VARCHAR(2000);
            DECLARE @nm VARCHAR(150), @cli VARCHAR(150);
            SELECT @nm=m.nombre_completo, @cli=c.nombre
              FROM citas.MEDICO m JOIN citas.CLINICA c ON c.id_CLINICA=m.id_CLINICA
             WHERE m.id_MEDICO=@id_MEDICO;
            SET @msg='Activa Medico id='+CONVERT(VARCHAR(20),@id_MEDICO)
                    +' nombre='+ISNULL(@nm,'?')
                    +' clinica='+ISNULL(@cli,'?')
                    +' por usuario id='+CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('MEDICO','spActivaMedico','MEDICO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spActivaMedico: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('MEDICO','spActivaMedico','MEDICO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spDesactivaMedico
    @id_MEDICO INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.MEDICO SET activo=0, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_MEDICO=@id_MEDICO;
            DECLARE @msg VARCHAR(2000);
            DECLARE @nm VARCHAR(150), @cli VARCHAR(150);
            SELECT @nm=m.nombre_completo, @cli=c.nombre
              FROM citas.MEDICO m JOIN citas.CLINICA c ON c.id_CLINICA=m.id_CLINICA
             WHERE m.id_MEDICO=@id_MEDICO;
            SET @msg='Desactiva Medico id='+CONVERT(VARCHAR(20),@id_MEDICO)
                    +' nombre='+ISNULL(@nm,'?')
                    +' clinica='+ISNULL(@cli,'?')
                    +' por usuario id='+CONVERT(VARCHAR(10),@id_usuario);
            INSERT INTO citas.LOG VALUES('MEDICO','spDesactivaMedico','MEDICO',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spDesactivaMedico: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('MEDICO','spDesactivaMedico','MEDICO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaMedicos
    @id_CLINICA INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT m.id_MEDICO, m.id_CLINICA, c.nombre AS clinica,
           m.nombre_completo, m.activo
      FROM citas.MEDICO m
      JOIN citas.CLINICA c ON c.id_CLINICA = m.id_CLINICA
     WHERE (@id_CLINICA IS NULL OR m.id_CLINICA = @id_CLINICA)
     ORDER BY m.nombre_completo;
END
GO

-- =========================  MEDICO_ESPECIALIDAD  =====================
CREATE OR ALTER PROCEDURE citas.spAltaMedicoEspecialidad
    @id_MEDICO INT, @id_CATALOGO_ESPECIALIDAD INT, @id_CLINICA INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.MEDICO_ESPECIALIDAD(id_MEDICO,id_CATALOGO_ESPECIALIDAD,id_CLINICA,id_usuario_creacion,fecha_creacion)
            VALUES(@id_MEDICO,@id_CATALOGO_ESPECIALIDAD,@id_CLINICA,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta MedicoEspecialidad id='+CONVERT(VARCHAR(20),@id_nuevo);
            INSERT INTO citas.LOG VALUES('MEDICO_ESPECIALIDAD','spAltaMedicoEspecialidad','MEDICO_ESPECIALIDAD',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spAltaMedicoEspecialidad: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('MEDICO_ESPECIALIDAD','spAltaMedicoEspecialidad','MEDICO_ESPECIALIDAD',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaMedicoEspecialidad
    @id_MEDICO_ESPECIALIDAD INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DELETE FROM citas.MEDICO_ESPECIALIDAD WHERE id_MEDICO_ESPECIALIDAD=@id_MEDICO_ESPECIALIDAD;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Baja MedicoEspecialidad id='+CONVERT(VARCHAR(20),@id_MEDICO_ESPECIALIDAD);
            INSERT INTO citas.LOG VALUES('MEDICO_ESPECIALIDAD','spBajaMedicoEspecialidad','MEDICO_ESPECIALIDAD',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spBajaMedicoEspecialidad: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('MEDICO_ESPECIALIDAD','spBajaMedicoEspecialidad','MEDICO_ESPECIALIDAD',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaEspecialidadesPorMedico
    @id_MEDICO INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT me.id_MEDICO_ESPECIALIDAD, me.id_CATALOGO_ESPECIALIDAD, e.nombre AS especialidad,
           me.id_CLINICA, c.nombre AS clinica
      FROM citas.MEDICO_ESPECIALIDAD me
      JOIN citas.CATALOGO_ESPECIALIDAD e ON e.id_CATALOGO_ESPECIALIDAD = me.id_CATALOGO_ESPECIALIDAD
      JOIN citas.CLINICA c ON c.id_CLINICA = me.id_CLINICA
     WHERE me.id_MEDICO = @id_MEDICO
     ORDER BY e.nombre;
END
GO

-- =========================  PACIENTE  ================================
CREATE OR ALTER PROCEDURE citas.spAltaPaciente
    @id_CLINICA INT, @ap_paterno VARCHAR(80), @ap_materno VARCHAR(80), @nombre VARCHAR(120),
    @direccion VARCHAR(250), @telefono VARCHAR(20), @email VARCHAR(120),
    @fecha_nacimiento DATE, @id_CATALOGO_GENERO INT, @id_CATALOGO_MUNICIPIO INT,
    @observaciones VARCHAR(500) = NULL,
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.PACIENTE(id_CLINICA,ap_paterno,ap_materno,nombre,direccion,
                                        telefono,email,fecha_nacimiento,id_CATALOGO_GENERO,
                                        id_CATALOGO_MUNICIPIO,observaciones,id_usuario_creacion,fecha_creacion)
            VALUES(@id_CLINICA,@ap_paterno,@ap_materno,@nombre,@direccion,@telefono,@email,
                   @fecha_nacimiento,@id_CATALOGO_GENERO,@id_CATALOGO_MUNICIPIO,@observaciones,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Paciente id='+CONVERT(VARCHAR(20),@id_nuevo)
                   +' nombre='+@ap_paterno+' '+@ap_materno+' '+@nombre;
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
    @observaciones VARCHAR(500) = NULL,
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
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_PACIENTE=@id_PACIENTE;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Paciente id='+CONVERT(VARCHAR(20),@id_PACIENTE);
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
    @id_PACIENTE INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DELETE FROM citas.PACIENTE WHERE id_PACIENTE=@id_PACIENTE;
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

CREATE OR ALTER PROCEDURE citas.spRegresaPacientes
    @id_CLINICA INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.id_PACIENTE, p.id_CLINICA, c.nombre AS clinica,
           p.ap_paterno, p.ap_materno, p.nombre, p.direccion, p.telefono, p.email,
           p.fecha_nacimiento, p.id_CATALOGO_GENERO, g.nombre AS genero,
           p.id_CATALOGO_MUNICIPIO, m.nombre AS municipio,
           p.observaciones,
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

CREATE OR ALTER PROCEDURE citas.spCambioObservacionesPaciente
    @id_PACIENTE INT, @observaciones VARCHAR(5000), @id_usuario TINYINT
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

-- =========================  CITA  ====================================
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

CREATE OR ALTER PROCEDURE citas.spCancelaCita
    @id_CITA INT, @id_CATALOGO_ESTADO_CITAS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CITA
               SET id_CATALOGO_ESTADO_CITAS=@id_CATALOGO_ESTADO_CITAS,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CITA=@id_CITA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cancela Cita id='+CONVERT(VARCHAR(20),@id_CITA);
            INSERT INTO citas.LOG VALUES('CITA','spCancelaCita','CITA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spCancelaCita: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CITA','spCancelaCita','CITA',@err,GETDATE(),ISNULL(@id_usuario,0));
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

-- =====================================================================
-- SEMILLA
-- =====================================================================

-- =====================================================================
-- BAJAS DE CATALOGOS (DELETE fisico, propaga error de FK)
-- =====================================================================
CREATE OR ALTER PROCEDURE citas.spBajaPais
    @id_CATALOGO_PAIS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM citas.CATALOGO_PAIS WHERE id_CATALOGO_PAIS=@id_CATALOGO_PAIS;
        INSERT INTO citas.LOG VALUES('CATALOGO_PAIS','spBajaPais','CATALOGO_PAIS',
            'Baja Pais id='+CONVERT(VARCHAR(20),@id_CATALOGO_PAIS),GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000)='ERROR spBajaPais: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_PAIS','spBajaPais','CATALOGO_PAIS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaEstado
    @id_CATALOGO_ESTADOS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM citas.CATALOGO_ESTADOS WHERE id_CATALOGO_ESTADOS=@id_CATALOGO_ESTADOS;
        INSERT INTO citas.LOG VALUES('CATALOGO_ESTADOS','spBajaEstado','CATALOGO_ESTADOS',
            'Baja Estado id='+CONVERT(VARCHAR(20),@id_CATALOGO_ESTADOS),GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000)='ERROR spBajaEstado: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_ESTADOS','spBajaEstado','CATALOGO_ESTADOS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaMunicipio
    @id_CATALOGO_MUNICIPIO INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM citas.CATALOGO_MUNICIPIO WHERE id_CATALOGO_MUNICIPIO=@id_CATALOGO_MUNICIPIO;
        INSERT INTO citas.LOG VALUES('CATALOGO_MUNICIPIO','spBajaMunicipio','CATALOGO_MUNICIPIO',
            'Baja Municipio id='+CONVERT(VARCHAR(20),@id_CATALOGO_MUNICIPIO),GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000)='ERROR spBajaMunicipio: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_MUNICIPIO','spBajaMunicipio','CATALOGO_MUNICIPIO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaGenero
    @id_CATALOGO_GENERO INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM citas.CATALOGO_GENERO WHERE id_CATALOGO_GENERO=@id_CATALOGO_GENERO;
        INSERT INTO citas.LOG VALUES('CATALOGO_GENERO','spBajaGenero','CATALOGO_GENERO',
            'Baja Genero id='+CONVERT(VARCHAR(20),@id_CATALOGO_GENERO),GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000)='ERROR spBajaGenero: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_GENERO','spBajaGenero','CATALOGO_GENERO',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE citas.spBajaEstadoCita
    @id_CATALOGO_ESTADO_CITAS INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM citas.CATALOGO_ESTADO_CITAS WHERE id_CATALOGO_ESTADO_CITAS=@id_CATALOGO_ESTADO_CITAS;
        INSERT INTO citas.LOG VALUES('CATALOGO_ESTADO_CITAS','spBajaEstadoCita','CATALOGO_ESTADO_CITAS',
            'Baja EstadoCita id='+CONVERT(VARCHAR(20),@id_CATALOGO_ESTADO_CITAS),GETDATE(),@id_usuario);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000)='ERROR spBajaEstadoCita: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG VALUES('CATALOGO_ESTADO_CITAS','spBajaEstadoCita','CATALOGO_ESTADO_CITAS',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO

-- Catalogos base
DECLARE @id_pais INT;
INSERT INTO citas.CATALOGO_PAIS(nombre,id_usuario_creacion,fecha_creacion)
VALUES('Mexico',0,GETDATE());
SET @id_pais = SCOPE_IDENTITY();

INSERT INTO citas.CATALOGO_GENERO(nombre,id_usuario_creacion,fecha_creacion) VALUES
('Masculino',0,GETDATE()),('Femenino',0,GETDATE()),('Otro',0,GETDATE());

INSERT INTO citas.CATALOGO_ESTADO_CITAS(nombre,id_usuario_creacion,fecha_creacion) VALUES
('Agendada',0,GETDATE()),('Confirmada',0,GETDATE()),('Cancelada',0,GETDATE()),
('Atendida',0,GETDATE()),('NoAsistio',0,GETDATE());

INSERT INTO citas.ROLES(nombre,descripcion,id_usuario_creacion,fecha_creacion) VALUES
('Administrador de sistema','Acceso total al sistema y todas las clinicas',0,GETDATE()),
('Administrador de clinica','Administra una clinica asignada',0,GETDATE()),
('Medico','Consulta sus citas y reportes',0,GETDATE()),
('Asistente','Gestiona citas y pacientes de la clinica',0,GETDATE());
GO

-- Usuario semilla: adminMaster1 / Admin01$
DECLARE @id_rol INT = (SELECT id_ROLES FROM citas.ROLES WHERE nombre='Administrador de sistema');
DECLARE @salt VARCHAR(36) = CONVERT(VARCHAR(36), NEWID());
DECLARE @pwd  VARCHAR(20) = 'Admin01$';
INSERT INTO citas.USUARIOS(id_ROLES,usuario,password_hash,password_salt,
                            nombre_completo,email,activo,id_usuario_creacion,fecha_creacion)
VALUES(@id_rol,'adminMaster1',
       HASHBYTES('SHA2_512', @pwd + @salt), @salt,
       'Administrador Maestro','admin@citas.local',1,0,GETDATE());
GO

PRINT 'Base de datos CitasMedicas creada correctamente.';
GO/* ============================================================
   Parche: citas.spLogEstadoCita
   Registra en citas.LOG los cambios de estatus de una cita
   (Agendada, Confirmada, Atendida, Cancelada, No asistio)
   ============================================================ */
USE CitasMedicas;
GO

CREATE OR ALTER PROCEDURE citas.spLogEstadoCita
    @id_CITA          INT,
    @estado_anterior  VARCHAR(60) = NULL,
    @estado_nuevo     VARCHAR(60),
    @id_CLINICA       INT          = NULL,
    @clinica          VARCHAR(150) = NULL,
    @usuario          VARCHAR(60)  = NULL,
    @id_usuario       TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @evento VARCHAR(2000) =
            'CAMBIO ESTATUS CITA id_CITA=' + CONVERT(VARCHAR(20), @id_CITA) +
            ' estado_anterior=' + ISNULL(@estado_anterior, '(sin estado)') +
            ' estado_nuevo=' + @estado_nuevo +
            ' clinica=' + ISNULL(@clinica, '(n/d)') +
            ' id_CLINICA=' + ISNULL(CONVERT(VARCHAR(20), @id_CLINICA), '(n/d)') +
            ' usuario=' + ISNULL(@usuario, '(n/d)') +
            ' id_usuario=' + CONVERT(VARCHAR(10), @id_usuario);

        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('CITA', 'spLogEstadoCita', 'CITA', @evento, GETDATE(), @id_usuario);
    END TRY
    BEGIN CATCH
        DECLARE @err VARCHAR(2000) = 'ERROR spLogEstadoCita id_CITA=' +
            CONVERT(VARCHAR(20), ISNULL(@id_CITA,0)) + ': ' + ERROR_MESSAGE();
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('CITA', 'spLogEstadoCita', 'CITA', @err, GETDATE(), ISNULL(@id_usuario,0));
    END CATCH
END
GO

GRANT EXECUTE ON OBJECT::citas.spLogEstadoCita TO citasadmin;
GO

GO
-- =============== HORARIO DE ATENCION POR MEDICO ===============
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

-- =====================================================================
-- Restablecer contrasena por correo + configuracion SMTP (2026-09-03)
-- =====================================================================
   - citas.PASSWORD_RESET : tokens de restablecimiento (hash, 1 solo uso)
   - citas.CONFIG_CORREO  : cuenta de correo emisora del sistema (fila unica)
   ============================================================ */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.PASSWORD_RESET', 'U') IS NULL
BEGIN
    CREATE TABLE citas.PASSWORD_RESET (
        id_PASSWORD_RESET  INT IDENTITY(1,1) NOT NULL,
        id_USUARIOS        INT               NOT NULL,
        token_hash         VARCHAR(64)       NOT NULL,
        fecha_expira       DATETIME          NOT NULL,
        usado              BIT               NOT NULL CONSTRAINT DF_usado_PASSWORD_RESET DEFAULT (0),
        ip                 VARCHAR(45)       NULL,
        fecha_creacion     DATETIME          NOT NULL CONSTRAINT DF_fecha_creacion_PASSWORD_RESET DEFAULT (GETDATE()),
        fecha_uso          DATETIME          NULL,
        CONSTRAINT PK_id_PASSWORD_RESET PRIMARY KEY (id_PASSWORD_RESET),
        CONSTRAINT FK_id_USUARIOS_USUARIOS_id_USUARIOS_PASSWORD_RESET
            FOREIGN KEY (id_USUARIOS) REFERENCES citas.USUARIOS(id_USUARIOS),
        CONSTRAINT CHK_usado_PASSWORD_RESET CHECK (usado IN (0,1))
    );
    CREATE UNIQUE INDEX IX_token_hash_PASSWORD_RESET ON citas.PASSWORD_RESET(token_hash);
END
GO

IF OBJECT_ID('citas.CONFIG_CORREO', 'U') IS NULL
BEGIN
    CREATE TABLE citas.CONFIG_CORREO (
        id_CONFIG_CORREO         INT IDENTITY(1,1) NOT NULL,
        host                     VARCHAR(150)      NOT NULL,
        puerto                   INT               NOT NULL CONSTRAINT DF_puerto_CONFIG_CORREO DEFAULT (587),
        cifrado                  VARCHAR(10)       NOT NULL CONSTRAINT DF_cifrado_CONFIG_CORREO DEFAULT ('tls'),
        usuario                  VARCHAR(150)      NOT NULL,
        password_cifrada         VARCHAR(500)      NOT NULL,
        remitente                VARCHAR(120)      NOT NULL,
        remitente_nombre         VARCHAR(120)      NOT NULL,
        activo                   BIT               NOT NULL CONSTRAINT DF_activo_CONFIG_CORREO DEFAULT (1),
        id_usuario_creacion      TINYINT           NOT NULL,
        fecha_creacion           SMALLDATETIME     NOT NULL,
        id_usuario_modificacion  TINYINT           NULL,
        fecha_modificacion       SMALLDATETIME     NULL,
        CONSTRAINT PK_id_CONFIG_CORREO PRIMARY KEY (id_CONFIG_CORREO),
        CONSTRAINT CHK_cifrado_CONFIG_CORREO CHECK (cifrado IN ('ninguno','tls','ssl')),
        CONSTRAINT CHK_activo_CONFIG_CORREO CHECK (activo IN (0,1)),
        CONSTRAINT CHK_remitente_CONFIG_CORREO CHECK (remitente LIKE '%_@_%._%')
    );
END
GO

/* ---------- Alta de token de restablecimiento ---------- */
CREATE OR ALTER PROCEDURE citas.spAltaPasswordReset
    @id_USUARIOS  INT,
    @token_hash   VARCHAR(64),
    @minutos      INT,
    @ip           VARCHAR(45),
    @id_usuario   TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    -- Un solo token vigente por usuario: se invalidan los anteriores.
    UPDATE citas.PASSWORD_RESET
       SET usado = 1, fecha_uso = GETDATE()
     WHERE id_USUARIOS = @id_USUARIOS AND usado = 0;

    INSERT INTO citas.PASSWORD_RESET(id_USUARIOS, token_hash, fecha_expira, usado, ip, fecha_creacion)
    VALUES(@id_USUARIOS, @token_hash, DATEADD(MINUTE, @minutos, GETDATE()), 0, @ip, GETDATE());

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('SEGURIDAD', 'spAltaPasswordReset', 'PASSWORD_RESET',
           'SOLICITUD RESTABLECER PASSWORD: id_USUARIOS=' + CAST(@id_USUARIOS AS VARCHAR(10))
           + ', vigencia_min=' + CAST(@minutos AS VARCHAR(10)) + ', ip=' + ISNULL(@ip,'?'),
           GETDATE(), @id_usuario);
END
GO

/* ---------- Consulta de token vigente ---------- */
CREATE OR ALTER PROCEDURE citas.spRegresaPasswordReset
    @token_hash VARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.id_PASSWORD_RESET, r.id_USUARIOS, r.fecha_expira, r.usado,
           DATEDIFF(SECOND, GETDATE(), r.fecha_expira) AS segundos_restantes,
           u.usuario, u.nombre_completo, u.email, u.activo
      FROM citas.PASSWORD_RESET r
      INNER JOIN citas.USUARIOS u ON u.id_USUARIOS = r.id_USUARIOS
     WHERE r.token_hash = @token_hash;
END
GO

/* ---------- Marca el token como usado ---------- */
CREATE OR ALTER PROCEDURE citas.spUsaPasswordReset
    @id_PASSWORD_RESET INT,
    @id_usuario        TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.PASSWORD_RESET
       SET usado = 1, fecha_uso = GETDATE()
     WHERE id_PASSWORD_RESET = @id_PASSWORD_RESET;

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('SEGURIDAD', 'spUsaPasswordReset', 'PASSWORD_RESET',
           'PASSWORD RESTABLECIDO: id_PASSWORD_RESET=' + CAST(@id_PASSWORD_RESET AS VARCHAR(10)),
           GETDATE(), @id_usuario);
END
GO

/* ---------- Solicitudes recientes (control de abuso) ---------- */
CREATE OR ALTER PROCEDURE citas.spCuentaPasswordReset
    @id_USUARIOS INT,
    @minutos     INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) AS total
      FROM citas.PASSWORD_RESET
     WHERE id_USUARIOS = @id_USUARIOS
       AND fecha_creacion >= DATEADD(MINUTE, -@minutos, GETDATE());
END
GO

/* ---------- Configuracion de correo ---------- */
CREATE OR ALTER PROCEDURE citas.spRegresaConfigCorreo
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 id_CONFIG_CORREO, host, puerto, cifrado, usuario, password_cifrada,
                 remitente, remitente_nombre, activo
      FROM citas.CONFIG_CORREO
     ORDER BY id_CONFIG_CORREO;
END
GO

CREATE OR ALTER PROCEDURE citas.spGuardaConfigCorreo
    @host             VARCHAR(150),
    @puerto           INT,
    @cifrado          VARCHAR(10),
    @usuario          VARCHAR(150),
    @password_cifrada VARCHAR(500),
    @remitente        VARCHAR(120),
    @remitente_nombre VARCHAR(120),
    @activo           BIT,
    @id_usuario       TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id INT = (SELECT TOP 1 id_CONFIG_CORREO FROM citas.CONFIG_CORREO ORDER BY id_CONFIG_CORREO);

    IF @id IS NULL
    BEGIN
        INSERT INTO citas.CONFIG_CORREO(host, puerto, cifrado, usuario, password_cifrada, remitente,
                                        remitente_nombre, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@host, @puerto, @cifrado, @usuario, @password_cifrada, @remitente,
               @remitente_nombre, @activo, @id_usuario, GETDATE());
        SET @id = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE citas.CONFIG_CORREO
           SET host = @host, puerto = @puerto, cifrado = @cifrado, usuario = @usuario,
               password_cifrada = CASE WHEN @password_cifrada = '' THEN password_cifrada ELSE @password_cifrada END,
               remitente = @remitente, remitente_nombre = @remitente_nombre, activo = @activo,
               id_usuario_modificacion = @id_usuario, fecha_modificacion = GETDATE()
         WHERE id_CONFIG_CORREO = @id;
    END

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('SISTEMA', 'spGuardaConfigCorreo', 'CONFIG_CORREO',
           'CONFIGURACION CORREO: host=' + @host + ', puerto=' + CAST(@puerto AS VARCHAR(10))
           + ', cifrado=' + @cifrado + ', usuario=' + @usuario + ', remitente=' + @remitente
           + ', activo=' + CAST(@activo AS VARCHAR(1)),
           GETDATE(), @id_usuario);

    SELECT @id AS id_CONFIG_CORREO;
END
GO

GRANT EXECUTE ON OBJECT::citas.spAltaPasswordReset    TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spRegresaPasswordReset TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spUsaPasswordReset     TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spCuentaPasswordReset  TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spRegresaConfigCorreo  TO citasadmin;
GRANT EXECUTE ON OBJECT::citas.spGuardaConfigCorreo   TO citasadmin;
GO

-- =====================================================================
-- PROCEDIMIENTOS COMPLEMENTARIOS (consolidados desde patches/)
-- Se agregan al final para que una instalacion fresca con schema.sql
-- quede completa sin necesidad de aplicar los parches uno a uno.
-- =====================================================================
USE CitasMedicas;
GO

-- ---------- spRegresaMedicosUsuarios (combo de medicos en Cita) -----
CREATE OR ALTER PROCEDURE citas.spRegresaMedicosUsuarios
    @id_CLINICA INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT u.id_USUARIOS, u.usuario, u.nombre_completo, u.email,
                    uc.id_CLINICA, c.nombre AS clinica
      FROM citas.USUARIOS u
      JOIN citas.ROLES r             ON r.id_ROLES     = u.id_ROLES
      JOIN citas.USUARIOS_CLINICA uc ON uc.id_USUARIOS = u.id_USUARIOS
      JOIN citas.CLINICA c           ON c.id_CLINICA   = uc.id_CLINICA
     WHERE u.activo = 1
       AND LOWER(r.nombre) LIKE '%medico%'
       AND (@id_CLINICA IS NULL OR uc.id_CLINICA = @id_CLINICA)
     ORDER BY u.nombre_completo;
END
GO
GRANT EXECUTE ON citas.spRegresaMedicosUsuarios TO citasadmin;
GO

-- ---------- spNotificaCita (marca notificado + LOG detalle) ---------
CREATE OR ALTER PROCEDURE citas.spNotificaCita
    @id_CITA INT, @id_usuario TINYINT, @usuario VARCHAR(40) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CITA
               SET notificado = 1,
                   id_usuario_modificacion = @id_usuario,
                   fecha_modificacion = GETDATE()
             WHERE id_CITA = @id_CITA;

            DECLARE @msg VARCHAR(2000);
            SELECT @msg = 'CITA NOTIFICADA id_CITA=' + CONVERT(VARCHAR(20), ci.id_CITA)
                        + ' usuario=' + ISNULL(@usuario, ISNULL(us.usuario, '(n/d)'))
                        + ' id_usuario=' + CONVERT(VARCHAR(10), @id_usuario)
                        + ' paciente=' + LTRIM(RTRIM(p.ap_paterno + ' ' + p.ap_materno + ' ' + p.nombre))
                        + ' id_PACIENTE=' + CONVERT(VARCHAR(20), p.id_PACIENTE)
                        + ' clinica=' + cl.nombre
                        + ' id_CLINICA=' + CONVERT(VARCHAR(20), cl.id_CLINICA)
                        + ' consultorio=' + co.nombre
                        + ' id_CONSULTORIO=' + CONVERT(VARCHAR(20), co.id_CONSULTORIO)
              FROM citas.CITA ci
              JOIN citas.PACIENTE     p  ON p.id_PACIENTE     = ci.id_PACIENTE
              JOIN citas.CLINICA      cl ON cl.id_CLINICA     = p.id_CLINICA
              JOIN citas.CONSULTORIO  co ON co.id_CONSULTORIO = ci.id_CONSULTORIO
              LEFT JOIN citas.USUARIOS us ON us.id_USUARIOS   = @id_usuario
             WHERE ci.id_CITA = @id_CITA;

            IF @msg IS NULL
                SET @msg = 'CITA NOTIFICADA id_CITA=' + CONVERT(VARCHAR(20), @id_CITA)
                         + ' usuario=' + ISNULL(@usuario, '(n/d)');

            INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
            VALUES('CITA','spNotificaCita','CITA',@msg,GETDATE(),@id_usuario);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        DECLARE @err VARCHAR(2000);
        SET @err='ERROR spNotificaCita: '+ERROR_MESSAGE();
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('CITA','spNotificaCita','CITA',@err,GETDATE(),ISNULL(@id_usuario,0));
        ;THROW;
    END CATCH
END
GO
GRANT EXECUTE ON OBJECT::citas.spNotificaCita TO citasadmin;
GO

-- ---------- spLogEvento (registro libre en LOG, usado por cita publica) --
CREATE OR ALTER PROCEDURE citas.spLogEvento
    @modulo        VARCHAR(30),
    @procedimiento VARCHAR(300),
    @tabla         VARCHAR(50),
    @evento        VARCHAR(2000),
    @id_usuario    TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES(@modulo, @procedimiento, @tabla, @evento, GETDATE(), @id_usuario);
    END TRY
    BEGIN CATCH
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('SISTEMA', 'spLogEvento', 'LOG',
               'ERROR spLogEvento: ' + ERROR_MESSAGE(), GETDATE(), ISNULL(@id_usuario, 0));
    END CATCH
END
GO
GRANT EXECUTE ON OBJECT::citas.spLogEvento TO citasadmin;
GO

-- ---------- spReporteIngresosPorMedico (reporte ingresos por medico) ----
CREATE OR ALTER PROCEDURE citas.spReporteIngresosPorMedico
    @id_CLINICA INT = NULL,
    @fecha_desde DATE = NULL,
    @fecha_hasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  CONVERT(CHAR(7), ci.fecha_cita, 126) AS periodo,
            u.nombre_completo                    AS medico,
            SUM(ci.precio)                       AS total
      FROM citas.CITA ci
      JOIN citas.PACIENTE p ON p.id_PACIENTE = ci.id_PACIENTE
      JOIN citas.USUARIOS u ON u.id_USUARIOS = ci.id_MEDICO
      JOIN citas.CATALOGO_ESTADO_CITAS ec ON ec.id_CATALOGO_ESTADO_CITAS = ci.id_CATALOGO_ESTADO_CITAS
     WHERE ec.nombre LIKE 'Atendid%'
       AND (@id_CLINICA  IS NULL OR p.id_CLINICA  = @id_CLINICA)
       AND (@fecha_desde IS NULL OR ci.fecha_cita >= @fecha_desde)
       AND (@fecha_hasta IS NULL OR ci.fecha_cita <= @fecha_hasta)
     GROUP BY CONVERT(CHAR(7), ci.fecha_cita, 126), u.nombre_completo
     ORDER BY periodo DESC, total DESC;
END
GO
GRANT EXECUTE ON OBJECT::citas.spReporteIngresosPorMedico TO citasadmin;
GO
/* =====================================================================
   Parche: verificacion por codigo (OTP) en la cita PUBLICA y
           configuracion de WhatsApp Cloud API (Meta).

   - citas.CONFIG_WHATSAPP   : credenciales de WhatsApp Cloud API (fila unica)
   - citas.OTP_CITA_PUBLICA  : codigos de verificacion (solo hash, 1 solo uso)

   Ejecutar con:
     sqlcmd -S localhost,1433 -U sa -C -i patch_otp_whatsapp.sql
   ===================================================================== */
USE CitasMedicas;
GO

/* ---------------------- tabla CONFIG_WHATSAPP ---------------------- */
IF OBJECT_ID('citas.CONFIG_WHATSAPP', 'U') IS NULL
BEGIN
    CREATE TABLE citas.CONFIG_WHATSAPP (
        id_CONFIG_WHATSAPP       INT IDENTITY(1,1) NOT NULL,
        phone_number_id          VARCHAR(60)       NOT NULL,
        waba_id                  VARCHAR(60)       NULL,
        token_cifrado            VARCHAR(2000)     NOT NULL,
        api_version              VARCHAR(10)       NOT NULL CONSTRAINT DF_api_version_CONFIG_WHATSAPP DEFAULT ('v21.0'),
        plantilla                VARCHAR(120)      NOT NULL CONSTRAINT DF_plantilla_CONFIG_WHATSAPP DEFAULT ('codigo_verificacion'),
        plantilla_idioma         VARCHAR(20)       NOT NULL CONSTRAINT DF_plantilla_idioma_CONFIG_WHATSAPP DEFAULT ('es_MX'),
        lada_default             VARCHAR(5)        NOT NULL CONSTRAINT DF_lada_default_CONFIG_WHATSAPP DEFAULT ('52'),
        activo                   BIT               NOT NULL CONSTRAINT DF_activo_CONFIG_WHATSAPP DEFAULT (1),
        id_usuario_creacion      TINYINT           NOT NULL,
        fecha_creacion           SMALLDATETIME     NOT NULL,
        id_usuario_modificacion  TINYINT           NULL,
        fecha_modificacion       SMALLDATETIME     NULL,
        CONSTRAINT PK_id_CONFIG_WHATSAPP PRIMARY KEY (id_CONFIG_WHATSAPP),
        CONSTRAINT CHK_activo_CONFIG_WHATSAPP CHECK (activo IN (0,1))
    );
END
GO

/* --------------------- tabla OTP_CITA_PUBLICA ---------------------- */
IF OBJECT_ID('citas.OTP_CITA_PUBLICA', 'U') IS NULL
BEGIN
    CREATE TABLE citas.OTP_CITA_PUBLICA (
        id_OTP_CITA_PUBLICA  INT IDENTITY(1,1) NOT NULL,
        telefono             VARCHAR(20)       NOT NULL,
        codigo_hash          VARCHAR(64)       NOT NULL,
        canal                VARCHAR(10)       NOT NULL,
        intentos             TINYINT           NOT NULL CONSTRAINT DF_intentos_OTP_CITA_PUBLICA DEFAULT (0),
        usado                BIT               NOT NULL CONSTRAINT DF_usado_OTP_CITA_PUBLICA DEFAULT (0),
        fecha_expira         DATETIME          NOT NULL,
        ip                   VARCHAR(45)       NULL,
        fecha_creacion       DATETIME          NOT NULL CONSTRAINT DF_fecha_creacion_OTP_CITA_PUBLICA DEFAULT (GETDATE()),
        fecha_uso            DATETIME          NULL,
        CONSTRAINT PK_id_OTP_CITA_PUBLICA PRIMARY KEY (id_OTP_CITA_PUBLICA),
        CONSTRAINT CHK_canal_OTP_CITA_PUBLICA CHECK (canal IN ('correo','whatsapp')),
        CONSTRAINT CHK_usado_OTP_CITA_PUBLICA CHECK (usado IN (0,1))
    );
    CREATE INDEX IX_telefono_OTP_CITA_PUBLICA ON citas.OTP_CITA_PUBLICA(telefono, fecha_creacion);
END
GO

/* ---------------- spRegresaConfigWhatsapp -------------------------- */
CREATE OR ALTER PROCEDURE citas.spRegresaConfigWhatsapp
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 id_CONFIG_WHATSAPP, phone_number_id, waba_id, token_cifrado, api_version,
                 plantilla, plantilla_idioma, lada_default, activo
      FROM citas.CONFIG_WHATSAPP
     ORDER BY id_CONFIG_WHATSAPP;
END
GO
GRANT EXECUTE ON OBJECT::citas.spRegresaConfigWhatsapp TO citasadmin;
GO

/* ---------------- spGuardaConfigWhatsapp --------------------------- */
CREATE OR ALTER PROCEDURE citas.spGuardaConfigWhatsapp
    @phone_number_id  VARCHAR(60),
    @waba_id          VARCHAR(60) = NULL,
    @token_cifrado    VARCHAR(2000) = '',
    @api_version      VARCHAR(10) = 'v21.0',
    @plantilla        VARCHAR(120) = 'codigo_verificacion',
    @plantilla_idioma VARCHAR(20) = 'es_MX',
    @lada_default     VARCHAR(5) = '52',
    @activo           BIT = 1,
    @id_usuario       TINYINT = 0
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id INT = (SELECT TOP 1 id_CONFIG_WHATSAPP FROM citas.CONFIG_WHATSAPP ORDER BY id_CONFIG_WHATSAPP);

    IF @id IS NULL
    BEGIN
        INSERT INTO citas.CONFIG_WHATSAPP(phone_number_id, waba_id, token_cifrado, api_version, plantilla,
                                          plantilla_idioma, lada_default, activo, id_usuario_creacion, fecha_creacion)
        VALUES(@phone_number_id, @waba_id, @token_cifrado, @api_version, @plantilla,
               @plantilla_idioma, @lada_default, @activo, @id_usuario, GETDATE());
        SET @id = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        UPDATE citas.CONFIG_WHATSAPP
           SET phone_number_id = @phone_number_id,
               waba_id         = @waba_id,
               token_cifrado   = CASE WHEN @token_cifrado = '' THEN token_cifrado ELSE @token_cifrado END,
               api_version     = @api_version,
               plantilla       = @plantilla,
               plantilla_idioma= @plantilla_idioma,
               lada_default    = @lada_default,
               activo          = @activo,
               id_usuario_modificacion = @id_usuario,
               fecha_modificacion      = GETDATE()
         WHERE id_CONFIG_WHATSAPP = @id;
    END

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('SISTEMA', 'spGuardaConfigWhatsapp', 'CONFIG_WHATSAPP',
           'CONFIGURACION WHATSAPP GUARDADA: phone_number_id=' + @phone_number_id
           + ' activo=' + CAST(@activo AS VARCHAR(1)), GETDATE(), @id_usuario);

    SELECT @id AS id_CONFIG_WHATSAPP;
END
GO
GRANT EXECUTE ON OBJECT::citas.spGuardaConfigWhatsapp TO citasadmin;
GO

/* ---------------- spAltaOtpCitaPublica ----------------------------- */
CREATE OR ALTER PROCEDURE citas.spAltaOtpCitaPublica
    @telefono     VARCHAR(20),
    @codigo_hash  VARCHAR(64),
    @canal        VARCHAR(10),
    @minutos      INT = 10,
    @ip           VARCHAR(45) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    -- Un solo codigo vigente por telefono.
    UPDATE citas.OTP_CITA_PUBLICA
       SET usado = 1, fecha_uso = GETDATE()
     WHERE telefono = @telefono AND usado = 0;

    INSERT INTO citas.OTP_CITA_PUBLICA(telefono, codigo_hash, canal, fecha_expira, ip)
    VALUES(@telefono, @codigo_hash, @canal, DATEADD(MINUTE, @minutos, GETDATE()), @ip);

    SELECT SCOPE_IDENTITY() AS id_OTP_CITA_PUBLICA;
END
GO
GRANT EXECUTE ON OBJECT::citas.spAltaOtpCitaPublica TO citasadmin;
GO

/* ---------------- spRegresaOtpCitaPublica -------------------------- */
CREATE OR ALTER PROCEDURE citas.spRegresaOtpCitaPublica
    @telefono VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 id_OTP_CITA_PUBLICA, telefono, codigo_hash, canal, intentos, usado, fecha_expira,
                 DATEDIFF(SECOND, GETDATE(), fecha_expira) AS segundos_restantes
      FROM citas.OTP_CITA_PUBLICA
     WHERE telefono = @telefono AND usado = 0
     ORDER BY id_OTP_CITA_PUBLICA DESC;
END
GO
GRANT EXECUTE ON OBJECT::citas.spRegresaOtpCitaPublica TO citasadmin;
GO

/* ---------------- spIntentoOtpCitaPublica -------------------------- */
CREATE OR ALTER PROCEDURE citas.spIntentoOtpCitaPublica
    @id_OTP_CITA_PUBLICA INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.OTP_CITA_PUBLICA
       SET intentos = intentos + 1
     WHERE id_OTP_CITA_PUBLICA = @id_OTP_CITA_PUBLICA;

    SELECT intentos FROM citas.OTP_CITA_PUBLICA WHERE id_OTP_CITA_PUBLICA = @id_OTP_CITA_PUBLICA;
END
GO
GRANT EXECUTE ON OBJECT::citas.spIntentoOtpCitaPublica TO citasadmin;
GO

/* ---------------- spUsaOtpCitaPublica ------------------------------ */
CREATE OR ALTER PROCEDURE citas.spUsaOtpCitaPublica
    @id_OTP_CITA_PUBLICA INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE citas.OTP_CITA_PUBLICA
       SET usado = 1, fecha_uso = GETDATE()
     WHERE id_OTP_CITA_PUBLICA = @id_OTP_CITA_PUBLICA;
END
GO
GRANT EXECUTE ON OBJECT::citas.spUsaOtpCitaPublica TO citasadmin;
GO

/* ---------------- spCuentaOtpCitaPublica --------------------------- */
CREATE OR ALTER PROCEDURE citas.spCuentaOtpCitaPublica
    @telefono VARCHAR(20),
    @minutos  INT = 60
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) AS total
      FROM citas.OTP_CITA_PUBLICA
     WHERE telefono = @telefono
       AND fecha_creacion >= DATEADD(MINUTE, -@minutos, GETDATE());
END
GO
GRANT EXECUTE ON OBJECT::citas.spCuentaOtpCitaPublica TO citasadmin;
GO
GO

IF OBJECT_ID('citas.MENSAJE_MEDICO', 'U') IS NULL
BEGIN
    CREATE TABLE citas.MENSAJE_MEDICO (
        id_MENSAJE_MEDICO        INT IDENTITY(1,1) NOT NULL,
        id_USUARIOS              INT               NOT NULL,
        plantilla                VARCHAR(1000)     NOT NULL,
        id_usuario_creacion      TINYINT           NOT NULL,
        fecha_creacion           SMALLDATETIME     NOT NULL,
        id_usuario_modificacion  TINYINT           NULL,
        fecha_modificacion       SMALLDATETIME     NULL,
        CONSTRAINT PK_id_MENSAJE_MEDICO PRIMARY KEY (id_MENSAJE_MEDICO),
        CONSTRAINT CHK_plantilla_MENSAJE_MEDICO CHECK (LEN(LTRIM(RTRIM(plantilla))) > 0),
        CONSTRAINT FK_id_USUARIOS_USUARIOS_id_USUARIOS_MENSAJE_MEDICO
            FOREIGN KEY (id_USUARIOS) REFERENCES citas.USUARIOS(id_USUARIOS)
    );

    CREATE UNIQUE INDEX IX_id_USUARIOS_MENSAJE_MEDICO
        ON citas.MENSAJE_MEDICO(id_USUARIOS);
END
GO

/* Regresa el texto de un medico o de todos (cuando @id_USUARIOS es NULL). */
CREATE OR ALTER PROCEDURE citas.spRegresaMensajeMedico
    @id_USUARIOS INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  m.id_MENSAJE_MEDICO,
            m.id_USUARIOS,
            m.plantilla,
            u.nombre_completo
    FROM citas.MENSAJE_MEDICO m
    INNER JOIN citas.USUARIOS u ON u.id_USUARIOS = m.id_USUARIOS
    WHERE (@id_USUARIOS IS NULL OR m.id_USUARIOS = @id_USUARIOS);
END
GO

/* Alta o cambio del texto del medico (un solo renglon por medico). */
CREATE OR ALTER PROCEDURE citas.spGuardaMensajeMedico
    @id_USUARIOS INT,
    @plantilla   VARCHAR(1000),
    @id_usuario  TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    SET @plantilla = LTRIM(RTRIM(ISNULL(@plantilla, '')));

    IF @plantilla = ''
    BEGIN
        RAISERROR('El texto de notificacion no puede quedar vacio.', 16, 1);
        RETURN;
    END

    /* El medico debe existir y estar asociado al menos a una clinica. */
    IF NOT EXISTS (
        SELECT 1
        FROM citas.USUARIOS u
        WHERE u.id_USUARIOS = @id_USUARIOS
          AND (u.id_CLINICA IS NOT NULL
               OR EXISTS (SELECT 1 FROM citas.USUARIOS_CLINICA uc WHERE uc.id_USUARIOS = u.id_USUARIOS))
    )
    BEGIN
        RAISERROR('El medico no existe o no pertenece a ninguna clinica.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM citas.MENSAJE_MEDICO WHERE id_USUARIOS = @id_USUARIOS)
        UPDATE citas.MENSAJE_MEDICO
           SET plantilla = @plantilla,
               id_usuario_modificacion = @id_usuario,
               fecha_modificacion = GETDATE()
         WHERE id_USUARIOS = @id_USUARIOS;
    ELSE
        INSERT INTO citas.MENSAJE_MEDICO(id_USUARIOS, plantilla, id_usuario_creacion, fecha_creacion)
        VALUES(@id_USUARIOS, @plantilla, @id_usuario, GETDATE());

    /* --------- Bitacora --------- */
    DECLARE @medico VARCHAR(150) = (SELECT nombre_completo FROM citas.USUARIOS WHERE id_USUARIOS = @id_USUARIOS);
    DECLARE @ev VARCHAR(2000) = 'se definio el texto de notificacion del medico "' + ISNULL(@medico, '')
                              + '": ' + LEFT(@plantilla, 500);

    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('MENSAJE', 'spGuardaMensajeMedico', 'MENSAJE_MEDICO', @ev, GETDATE(), @id_usuario);
END
GO

GRANT EXECUTE ON OBJECT::citas.spRegresaMensajeMedico TO citasadmin;
GO
GRANT EXECUTE ON OBJECT::citas.spGuardaMensajeMedico TO citasadmin;
GO
