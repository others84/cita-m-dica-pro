/* ============================================================
   Parche: contrato y aviso de privacidad por clinica + firma digital
   - citas.PLANTILLA_LEGAL        (plantillas base, editables por Admin de Sistema)
   - citas.DOCUMENTO_CLINICA      (documentos versionados por clinica)
   - citas.FIRMA_DOCUMENTO        (aceptacion por usuario: fecha/hora, IP, navegador)
   ============================================================ */
USE CitasMedicas;
GO

IF OBJECT_ID('citas.PLANTILLA_LEGAL', 'U') IS NULL
BEGIN
    CREATE TABLE citas.PLANTILLA_LEGAL (
        id_PLANTILLA_LEGAL  INT IDENTITY(1,1) NOT NULL,
        tipo                VARCHAR(10)       NOT NULL,   -- CONTRATO | AVISO
        html                NVARCHAR(MAX)     NOT NULL,
        id_usuario_mod      TINYINT           NOT NULL,
        fecha_mod           DATETIME          NOT NULL,
        CONSTRAINT PK_id_PLANTILLA_LEGAL PRIMARY KEY (id_PLANTILLA_LEGAL),
        CONSTRAINT UQ_tipo_PLANTILLA_LEGAL UNIQUE (tipo),
        CONSTRAINT CK_tipo_PLANTILLA_LEGAL CHECK (tipo IN ('CONTRATO','AVISO'))
    );

    INSERT INTO citas.PLANTILLA_LEGAL(tipo, html, id_usuario_mod, fecha_mod) VALUES
    ('CONTRATO', N'<h2>Contrato de uso del sistema de citas</h2>
<p>En la fecha @@FECHA, <b>@@NOMBRE_USUARIO</b> (usuario <b>@@USUARIO</b>, perfil @@ROL) de la clínica <b>@@CLINICA</b>, con domicilio en @@DIRECCION, acepta los siguientes términos:</p>
<ol>
<li>El usuario utilizará el sistema únicamente para la gestión de citas médicas de la clínica.</li>
<li>El usuario es responsable de la confidencialidad de su contraseña y de toda actividad realizada con su cuenta.</li>
<li>La información de los pacientes es confidencial y no podrá compartirse con terceros no autorizados.</li>
<li>El incumplimiento de estos términos podrá derivar en la suspensión del acceso.</li>
</ol>
<p>Contacto de la clínica: @@EMAIL_CLINICA / @@TELEFONO_CLINICA.</p>
<p><i>Texto de ejemplo: debe ser revisado y ajustado por su asesor legal.</i></p>', 0, GETDATE()),
    ('AVISO', N'<h2>Aviso de privacidad</h2>
<p><b>@@CLINICA</b>, con domicilio en @@DIRECCION, es responsable del tratamiento de los datos personales que se recaban a través de este sistema.</p>
<p>Los datos se utilizan para agendar, confirmar y dar seguimiento a citas médicas, y se protegen conforme a la Ley Federal de Protección de Datos Personales en Posesión de los Particulares.</p>
<p>Para ejercer sus derechos ARCO escriba a @@EMAIL_CLINICA o llame al @@TELEFONO_CLINICA.</p>
<p><i>Texto de ejemplo: debe ser revisado y ajustado por su asesor legal.</i></p>', 0, GETDATE());
END
GO

IF OBJECT_ID('citas.DOCUMENTO_CLINICA', 'U') IS NULL
BEGIN
    CREATE TABLE citas.DOCUMENTO_CLINICA (
        id_DOCUMENTO_CLINICA INT IDENTITY(1,1) NOT NULL,
        id_CLINICA           INT               NOT NULL,
        tipo                 VARCHAR(10)       NOT NULL,
        version              INT               NOT NULL,
        html                 NVARCHAR(MAX)     NOT NULL,
        vigente              BIT               NOT NULL,
        id_usuario_creacion  TINYINT           NOT NULL,
        fecha_creacion       DATETIME          NOT NULL,
        CONSTRAINT PK_id_DOCUMENTO_CLINICA PRIMARY KEY (id_DOCUMENTO_CLINICA),
        CONSTRAINT FK_id_CLINICA_CLINICA_id_CLINICA_DOCUMENTO_CLINICA
            FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA),
        CONSTRAINT CK_tipo_DOCUMENTO_CLINICA CHECK (tipo IN ('CONTRATO','AVISO'))
    );
    CREATE UNIQUE INDEX IX_clinica_tipo_version_DOCUMENTO_CLINICA
        ON citas.DOCUMENTO_CLINICA(id_CLINICA, tipo, version);
END
GO

IF OBJECT_ID('citas.FIRMA_DOCUMENTO', 'U') IS NULL
BEGIN
    CREATE TABLE citas.FIRMA_DOCUMENTO (
        id_FIRMA_DOCUMENTO   INT IDENTITY(1,1) NOT NULL,
        id_DOCUMENTO_CLINICA INT               NOT NULL,
        id_USUARIOS          INT               NOT NULL,
        id_CLINICA           INT               NOT NULL,
        fecha_firma          DATETIME          NOT NULL CONSTRAINT DF_fecha_FIRMA_DOCUMENTO DEFAULT GETDATE(),
        ip                   VARCHAR(45)       NOT NULL,
        user_agent           VARCHAR(400)      NULL,
        CONSTRAINT PK_id_FIRMA_DOCUMENTO PRIMARY KEY (id_FIRMA_DOCUMENTO),
        CONSTRAINT FK_doc_FIRMA_DOCUMENTO FOREIGN KEY (id_DOCUMENTO_CLINICA) REFERENCES citas.DOCUMENTO_CLINICA(id_DOCUMENTO_CLINICA),
        CONSTRAINT FK_usr_FIRMA_DOCUMENTO FOREIGN KEY (id_USUARIOS) REFERENCES citas.USUARIOS(id_USUARIOS),
        CONSTRAINT FK_cli_FIRMA_DOCUMENTO FOREIGN KEY (id_CLINICA) REFERENCES citas.CLINICA(id_CLINICA)
    );
    CREATE UNIQUE INDEX IX_doc_usr_FIRMA_DOCUMENTO ON citas.FIRMA_DOCUMENTO(id_DOCUMENTO_CLINICA, id_USUARIOS);
END
GO

CREATE OR ALTER PROCEDURE citas.spRegresaPlantillas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_PLANTILLA_LEGAL, tipo, html, CONVERT(VARCHAR(19), fecha_mod, 120) AS fecha_mod
    FROM citas.PLANTILLA_LEGAL ORDER BY tipo;
END
GO

CREATE OR ALTER PROCEDURE citas.spGuardaPlantilla
    @tipo VARCHAR(10), @html NVARCHAR(MAX), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    IF @tipo NOT IN ('CONTRATO','AVISO') THROW 50001, 'Tipo de plantilla invalido.', 1;
    IF EXISTS (SELECT 1 FROM citas.PLANTILLA_LEGAL WHERE tipo=@tipo)
        UPDATE citas.PLANTILLA_LEGAL SET html=@html, id_usuario_mod=@id_usuario, fecha_mod=GETDATE() WHERE tipo=@tipo;
    ELSE
        INSERT INTO citas.PLANTILLA_LEGAL(tipo, html, id_usuario_mod, fecha_mod) VALUES(@tipo, @html, @id_usuario, GETDATE());
    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('CONTRATOS', 'spGuardaPlantilla', 'PLANTILLA_LEGAL', CONCAT('Plantilla actualizada tipo=', @tipo), GETDATE(), @id_usuario);
END
GO

/* Documentos vigentes de una clinica (o todas sus versiones si @todas=1). */
CREATE OR ALTER PROCEDURE citas.spRegresaDocumentosClinica
    @id_CLINICA INT, @todas BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id_DOCUMENTO_CLINICA, id_CLINICA, tipo, version, html, vigente,
           CONVERT(VARCHAR(19), fecha_creacion, 120) AS fecha_creacion
    FROM citas.DOCUMENTO_CLINICA
    WHERE id_CLINICA=@id_CLINICA AND (@todas=1 OR vigente=1)
    ORDER BY tipo, version DESC;
END
GO

/* Publica una nueva version del documento de la clinica. */
CREATE OR ALTER PROCEDURE citas.spGuardaDocumentoClinica
    @id_CLINICA INT, @tipo VARCHAR(10), @html NVARCHAR(MAX), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    IF @tipo NOT IN ('CONTRATO','AVISO') THROW 50001, 'Tipo de documento invalido.', 1;
    DECLARE @v INT = ISNULL((SELECT MAX(version) FROM citas.DOCUMENTO_CLINICA WHERE id_CLINICA=@id_CLINICA AND tipo=@tipo), 0) + 1;
    BEGIN TRAN;
        UPDATE citas.DOCUMENTO_CLINICA SET vigente=0 WHERE id_CLINICA=@id_CLINICA AND tipo=@tipo AND vigente=1;
        INSERT INTO citas.DOCUMENTO_CLINICA(id_CLINICA, tipo, version, html, vigente, id_usuario_creacion, fecha_creacion)
        VALUES(@id_CLINICA, @tipo, @v, @html, 1, @id_usuario, GETDATE());
    COMMIT;
    INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
    VALUES('CONTRATOS', 'spGuardaDocumentoClinica', 'DOCUMENTO_CLINICA',
           CONCAT('Documento publicado clinica=', @id_CLINICA, ' tipo=', @tipo, ' version=', @v), GETDATE(), @id_usuario);
END
GO

/* Documentos vigentes de las clinicas activas del usuario que aun no ha firmado. */
CREATE OR ALTER PROCEDURE citas.spRegresaDocumentosPendientes
    @id_USUARIOS INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT d.id_DOCUMENTO_CLINICA, d.id_CLINICA, d.tipo, d.version, d.html,
           c.nombre AS clinica, ISNULL(c.direccion,'') AS direccion,
           ISNULL(c.email,'') AS email_clinica, ISNULL(c.telefono,'') AS telefono_clinica
    FROM citas.USUARIOS_CLINICA uc
    INNER JOIN citas.CLINICA c ON c.id_CLINICA = uc.id_CLINICA AND c.activo = 1
    INNER JOIN citas.DOCUMENTO_CLINICA d ON d.id_CLINICA = uc.id_CLINICA AND d.vigente = 1
    WHERE uc.id_USUARIOS = @id_USUARIOS
      AND NOT EXISTS (SELECT 1 FROM citas.FIRMA_DOCUMENTO f
                      WHERE f.id_DOCUMENTO_CLINICA = d.id_DOCUMENTO_CLINICA AND f.id_USUARIOS = @id_USUARIOS)
    ORDER BY c.nombre, d.tipo;
END
GO

CREATE OR ALTER PROCEDURE citas.spFirmaDocumento
    @id_DOCUMENTO_CLINICA INT, @id_USUARIOS INT, @ip VARCHAR(45), @user_agent VARCHAR(400), @id_usuario TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @cli INT = (SELECT id_CLINICA FROM citas.DOCUMENTO_CLINICA WHERE id_DOCUMENTO_CLINICA=@id_DOCUMENTO_CLINICA AND vigente=1);
    IF @cli IS NULL THROW 50002, 'El documento ya no esta vigente.', 1;
    IF NOT EXISTS (SELECT 1 FROM citas.USUARIOS_CLINICA WHERE id_USUARIOS=@id_USUARIOS AND id_CLINICA=@cli)
        THROW 50003, 'El usuario no pertenece a la clinica del documento.', 1;
    IF NOT EXISTS (SELECT 1 FROM citas.FIRMA_DOCUMENTO WHERE id_DOCUMENTO_CLINICA=@id_DOCUMENTO_CLINICA AND id_USUARIOS=@id_USUARIOS)
    BEGIN
        INSERT INTO citas.FIRMA_DOCUMENTO(id_DOCUMENTO_CLINICA, id_USUARIOS, id_CLINICA, fecha_firma, ip, user_agent)
        VALUES(@id_DOCUMENTO_CLINICA, @id_USUARIOS, @cli, GETDATE(), @ip, @user_agent);
        INSERT INTO citas.LOG(modulo, procedimiento, tabla, evento, fecha, id_usuario)
        VALUES('CONTRATOS', 'spFirmaDocumento', 'FIRMA_DOCUMENTO',
               CONCAT('Firma documento=', @id_DOCUMENTO_CLINICA, ' usuario=', @id_USUARIOS, ' clinica=', @cli, ' ip=', @ip), GETDATE(), @id_usuario);
    END
END
GO

/* Usuarios de la clinica con su estado de firma de los documentos vigentes. */
CREATE OR ALTER PROCEDURE citas.spRegresaFirmasClinica
    @id_CLINICA INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.id_USUARIOS, u.usuario, u.nombre_completo, r.nombre AS rol,
           d.tipo, d.version,
           CONVERT(VARCHAR(19), f.fecha_firma, 120) AS fecha_firma, f.ip
    FROM citas.USUARIOS_CLINICA uc
    INNER JOIN citas.USUARIOS u ON u.id_USUARIOS = uc.id_USUARIOS
    LEFT  JOIN citas.ROLES r ON r.id_ROLES = u.id_ROLES
    INNER JOIN citas.DOCUMENTO_CLINICA d ON d.id_CLINICA = uc.id_CLINICA AND d.vigente = 1
    LEFT  JOIN citas.FIRMA_DOCUMENTO f ON f.id_DOCUMENTO_CLINICA = d.id_DOCUMENTO_CLINICA AND f.id_USUARIOS = u.id_USUARIOS
    WHERE uc.id_CLINICA = @id_CLINICA
    ORDER BY u.nombre_completo, d.tipo;
END
GO
