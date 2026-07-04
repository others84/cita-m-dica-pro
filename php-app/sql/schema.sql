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
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CATALOGO_ESPECIALIDAD PRIMARY KEY (id_CATALOGO_ESPECIALIDAD)
);
GO
CREATE UNIQUE INDEX IX_nombre_CATALOGO_ESPECIALIDAD ON citas.CATALOGO_ESPECIALIDAD(nombre);
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
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_CLINICA PRIMARY KEY (id_CLINICA),
    CONSTRAINT FK_id_CATALOGO_MUNICIPIO_CATALOGO_MUNICIPIO_id_CATALOGO_MUNICIPIO_CLINICA
        FOREIGN KEY (id_CATALOGO_MUNICIPIO) REFERENCES citas.CATALOGO_MUNICIPIO(id_CATALOGO_MUNICIPIO),
    CONSTRAINT CHK_email_CLINICA CHECK (email LIKE '%_@_%._%')
);
GO
CREATE UNIQUE INDEX IX_nombre_CLINICA ON citas.CLINICA(nombre);
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
    nombre_completo          VARCHAR(150)      NOT NULL,
    activo                   BIT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_MEDICO PRIMARY KEY (id_MEDICO),
    CONSTRAINT CHK_activo_MEDICO CHECK (activo IN (0,1))
);
GO

-- ---------- MEDICO_ESPECIALIDAD ----------
CREATE TABLE citas.MEDICO_ESPECIALIDAD (
    id_MEDICO_ESPECIALIDAD   INT IDENTITY(1,1) NOT NULL,
    id_MEDICO                INT               NOT NULL,
    id_CATALOGO_ESPECIALIDAD INT               NOT NULL,
    id_usuario_creacion      TINYINT           NOT NULL,
    fecha_creacion           SMALLDATETIME     NOT NULL,
    id_usuario_modificacion  TINYINT           NULL,
    fecha_modificacion       SMALLDATETIME     NULL,
    CONSTRAINT PK_id_MEDICO_ESPECIALIDAD PRIMARY KEY (id_MEDICO_ESPECIALIDAD),
    CONSTRAINT FK_id_MEDICO_MEDICO_id_MEDICO_MEDICO_ESPECIALIDAD
        FOREIGN KEY (id_MEDICO) REFERENCES citas.MEDICO(id_MEDICO),
    CONSTRAINT FK_id_CATALOGO_ESPECIALIDAD_CATALOGO_ESPECIALIDAD_id_CATALOGO_ESPECIALIDAD_MEDICO_ESPECIALIDAD
        FOREIGN KEY (id_CATALOGO_ESPECIALIDAD) REFERENCES citas.CATALOGO_ESPECIALIDAD(id_CATALOGO_ESPECIALIDAD)
);
GO
CREATE UNIQUE INDEX IX_id_MEDICO_id_CATALOGO_ESPECIALIDAD_MEDICO_ESPECIALIDAD
    ON citas.MEDICO_ESPECIALIDAD(id_MEDICO, id_CATALOGO_ESPECIALIDAD);
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
    CONSTRAINT CHK_email_PACIENTE CHECK (email LIKE '%_@_%._%')
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
    notifica_email              BIT               NOT NULL,
    notifica_wa                 BIT               NOT NULL,
    email_notif                 VARCHAR(120)      NOT NULL,
    celular_notif               VARCHAR(20)       NOT NULL,
    horas_anticipacion_notif    TINYINT           NOT NULL CONSTRAINT DF_horas_anticipacion_CITA DEFAULT 24,
    precio                      DECIMAL(10,2)     NOT NULL,
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
    CONSTRAINT FK_id_MEDICO_MEDICO_id_MEDICO_CITA
        FOREIGN KEY (id_MEDICO) REFERENCES citas.MEDICO(id_MEDICO),
    CONSTRAINT FK_id_CATALOGO_ESPECIALIDAD_CATALOGO_ESPECIALIDAD_id_CATALOGO_ESPECIALIDAD_CITA
        FOREIGN KEY (id_CATALOGO_ESPECIALIDAD) REFERENCES citas.CATALOGO_ESPECIALIDAD(id_CATALOGO_ESPECIALIDAD),
    CONSTRAINT FK_id_CONSULTORIO_CONSULTORIO_id_CONSULTORIO_CITA
        FOREIGN KEY (id_CONSULTORIO) REFERENCES citas.CONSULTORIO(id_CONSULTORIO),
    CONSTRAINT CHK_hora_CITA               CHECK (hora_fin > hora_inicio),
    CONSTRAINT CHK_precio_CITA             CHECK (precio >= 0),
    CONSTRAINT CHK_horas_anticipacion_CITA CHECK (horas_anticipacion_notif BETWEEN 1 AND 168),
    CONSTRAINT CHK_notifica_email_CITA     CHECK (notifica_email IN (0,1)),
    CONSTRAINT CHK_notifica_wa_CITA        CHECK (notifica_wa IN (0,1))
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
    @nombre VARCHAR(120), @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CATALOGO_ESPECIALIDAD(nombre,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Especialidad id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre;
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
    @id_CATALOGO_ESPECIALIDAD INT, @nombre VARCHAR(120), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CATALOGO_ESPECIALIDAD
               SET nombre=@nombre, id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
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
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_CATALOGO_ESPECIALIDAD, nombre FROM citas.CATALOGO_ESPECIALIDAD ORDER BY nombre;
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
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.CLINICA(nombre,direccion,email,telefono,id_CATALOGO_MUNICIPIO,
                                       id_usuario_creacion,fecha_creacion)
            VALUES(@nombre,@direccion,@email,@telefono,@id_CATALOGO_MUNICIPIO,@id_usuario,GETDATE());
            SET @id_nuevo=SCOPE_IDENTITY();
            DECLARE @msg VARCHAR(2000);
            SET @msg='Alta Clinica id='+CONVERT(VARCHAR(20),@id_nuevo)+' nombre='+@nombre;
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
    @id_CATALOGO_MUNICIPIO INT, @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.CLINICA
               SET nombre=@nombre, direccion=@direccion, email=@email, telefono=@telefono,
                   id_CATALOGO_MUNICIPIO=@id_CATALOGO_MUNICIPIO,
                   id_usuario_modificacion=@id_usuario, fecha_modificacion=GETDATE()
             WHERE id_CLINICA=@id_CLINICA;
            DECLARE @msg VARCHAR(2000);
            SET @msg='Cambio Clinica id='+CONVERT(VARCHAR(20),@id_CLINICA);
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

CREATE OR ALTER PROCEDURE citas.spRegresaClinicas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.id_CLINICA, c.nombre, c.direccion, c.email, c.telefono,
           c.id_CATALOGO_MUNICIPIO, m.nombre AS municipio,
           m.id_CATALOGO_ESTADOS, e.nombre AS estado,
           e.id_CATALOGO_PAIS, p.nombre AS pais
      FROM citas.CLINICA c
      JOIN citas.CATALOGO_MUNICIPIO m ON m.id_CATALOGO_MUNICIPIO = c.id_CATALOGO_MUNICIPIO
      JOIN citas.CATALOGO_ESTADOS   e ON e.id_CATALOGO_ESTADOS   = m.id_CATALOGO_ESTADOS
      JOIN citas.CATALOGO_PAIS      p ON p.id_CATALOGO_PAIS      = e.id_CATALOGO_PAIS
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
    @nombre_completo VARCHAR(150), @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.MEDICO(nombre_completo,activo,id_usuario_creacion,fecha_creacion)
            VALUES(@nombre_completo,1,@id_usuario,GETDATE());
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
    @id_MEDICO INT, @nombre_completo VARCHAR(150), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            UPDATE citas.MEDICO
               SET nombre_completo=@nombre_completo,
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
            SET @msg='Activa Medico id='+CONVERT(VARCHAR(20),@id_MEDICO);
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
            SET @msg='Desactiva Medico id='+CONVERT(VARCHAR(20),@id_MEDICO);
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
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_MEDICO, nombre_completo, activo FROM citas.MEDICO ORDER BY nombre_completo;
END
GO

-- =========================  MEDICO_ESPECIALIDAD  =====================
CREATE OR ALTER PROCEDURE citas.spAltaMedicoEspecialidad
    @id_MEDICO INT, @id_CATALOGO_ESPECIALIDAD INT, @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.MEDICO_ESPECIALIDAD(id_MEDICO,id_CATALOGO_ESPECIALIDAD,id_usuario_creacion,fecha_creacion)
            VALUES(@id_MEDICO,@id_CATALOGO_ESPECIALIDAD,@id_usuario,GETDATE());
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
    SELECT me.id_MEDICO_ESPECIALIDAD, me.id_CATALOGO_ESPECIALIDAD, e.nombre AS especialidad
      FROM citas.MEDICO_ESPECIALIDAD me
      JOIN citas.CATALOGO_ESPECIALIDAD e ON e.id_CATALOGO_ESPECIALIDAD = me.id_CATALOGO_ESPECIALIDAD
     WHERE me.id_MEDICO = @id_MEDICO
     ORDER BY e.nombre;
END
GO

-- =========================  PACIENTE  ================================
CREATE OR ALTER PROCEDURE citas.spAltaPaciente
    @id_CLINICA INT, @ap_paterno VARCHAR(80), @ap_materno VARCHAR(80), @nombre VARCHAR(120),
    @direccion VARCHAR(250), @telefono VARCHAR(20), @email VARCHAR(120),
    @fecha_nacimiento DATE, @id_CATALOGO_GENERO INT, @id_CATALOGO_MUNICIPIO INT,
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            INSERT INTO citas.PACIENTE(id_CLINICA,ap_paterno,ap_materno,nombre,direccion,
                                        telefono,email,fecha_nacimiento,id_CATALOGO_GENERO,
                                        id_CATALOGO_MUNICIPIO,id_usuario_creacion,fecha_creacion)
            VALUES(@id_CLINICA,@ap_paterno,@ap_materno,@nombre,@direccion,@telefono,@email,
                   @fecha_nacimiento,@id_CATALOGO_GENERO,@id_CATALOGO_MUNICIPIO,@id_usuario,GETDATE());
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
                   id_CATALOGO_MUNICIPIO=@id_CATALOGO_MUNICIPIO,
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

-- =========================  CITA  ====================================
CREATE OR ALTER PROCEDURE citas.spAltaCita
    @id_PACIENTE INT, @fecha_cita DATE, @hora_inicio TIME(0), @hora_fin TIME(0),
    @id_CATALOGO_ESTADO_CITAS INT, @observaciones VARCHAR(500),
    @notifica_email BIT, @notifica_wa BIT,
    @horas_anticipacion_notif TINYINT, @precio DECIMAL(10,2),
    @id_MEDICO INT, @id_CATALOGO_ESPECIALIDAD INT, @id_CONSULTORIO INT,
    @id_usuario TINYINT, @id_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            -- Copia email/celular desde el paciente (no se aceptan como parametros).
            DECLARE @email_notif VARCHAR(120), @celular_notif VARCHAR(20);
            SELECT @email_notif = email, @celular_notif = telefono
              FROM citas.PACIENTE WHERE id_PACIENTE = @id_PACIENTE;

            INSERT INTO citas.CITA(id_PACIENTE,fecha_cita,hora_inicio,hora_fin,
                                    id_CATALOGO_ESTADO_CITAS,observaciones,
                                    notifica_email,notifica_wa,email_notif,celular_notif,
                                    horas_anticipacion_notif,precio,
                                    id_MEDICO,id_CATALOGO_ESPECIALIDAD,id_CONSULTORIO,
                                    id_usuario_creacion,fecha_creacion)
            VALUES(@id_PACIENTE,@fecha_cita,@hora_inicio,@hora_fin,
                   @id_CATALOGO_ESTADO_CITAS,@observaciones,
                   @notifica_email,@notifica_wa,@email_notif,@celular_notif,
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
    @notifica_email BIT, @notifica_wa BIT,
    @horas_anticipacion_notif TINYINT, @precio DECIMAL(10,2),
    @id_MEDICO INT, @id_CATALOGO_ESPECIALIDAD INT, @id_CONSULTORIO INT,
    @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;
            DECLARE @email_notif VARCHAR(120), @celular_notif VARCHAR(20);
            SELECT @email_notif = email, @celular_notif = telefono
              FROM citas.PACIENTE WHERE id_PACIENTE = @id_PACIENTE;

            UPDATE citas.CITA
               SET id_PACIENTE=@id_PACIENTE, fecha_cita=@fecha_cita,
                   hora_inicio=@hora_inicio, hora_fin=@hora_fin,
                   id_CATALOGO_ESTADO_CITAS=@id_CATALOGO_ESTADO_CITAS,
                   observaciones=@observaciones, notifica_email=@notifica_email,
                   notifica_wa=@notifica_wa, email_notif=@email_notif,
                   celular_notif=@celular_notif, horas_anticipacion_notif=@horas_anticipacion_notif,
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
            ci.observaciones, ci.notifica_email, ci.notifica_wa,
            ci.email_notif, ci.celular_notif, ci.horas_anticipacion_notif, ci.precio,
            ci.id_PACIENTE,
            (p.ap_paterno + ' ' + p.ap_materno + ' ' + p.nombre) AS paciente,
            p.id_CLINICA, cl.nombre AS clinica,
            ci.id_MEDICO, m.nombre_completo AS medico,
            ci.id_CATALOGO_ESPECIALIDAD, es.nombre AS especialidad,
            ci.id_CONSULTORIO, co.nombre AS consultorio,
            ci.id_CATALOGO_ESTADO_CITAS, ec.nombre AS estado
      FROM citas.CITA ci
      JOIN citas.PACIENTE              p  ON p.id_PACIENTE              = ci.id_PACIENTE
      JOIN citas.CLINICA               cl ON cl.id_CLINICA              = p.id_CLINICA
      JOIN citas.MEDICO                m  ON m.id_MEDICO                = ci.id_MEDICO
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
GO