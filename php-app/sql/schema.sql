/* ============================================================
   Sistema de Citas Médicas - SQL Server 2022 Express
   Script completo: base de datos, login, tablas, datos prueba
   ============================================================ */

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

/* ---------- Login y usuario ---------- */
IF SUSER_ID('citasadmin') IS NULL
    CREATE LOGIN citasadmin WITH PASSWORD = 'admin01$', CHECK_POLICY = OFF;
GO

USE CitasMedicas;
GO

IF USER_ID('citasadmin') IS NULL
    CREATE USER citasadmin FOR LOGIN citasadmin;
GO

ALTER ROLE db_owner ADD MEMBER citasadmin;
GO

/* ---------- Tablas ---------- */
CREATE TABLE Roles (
    id_rol     INT IDENTITY(1,1) PRIMARY KEY,
    nombre     VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE Usuarios (
    id_usuario   INT IDENTITY(1,1) PRIMARY KEY,
    usuario      VARCHAR(50)  NOT NULL UNIQUE,
    password     VARCHAR(255) NOT NULL,
    nombre       VARCHAR(150) NOT NULL,
    id_rol       INT NOT NULL,
    activo       BIT NOT NULL DEFAULT 1,
    creado_en    DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Usuarios_Roles FOREIGN KEY (id_rol) REFERENCES Roles(id_rol)
);

CREATE TABLE Medicos (
    id_medico    INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario   INT NOT NULL UNIQUE,
    especialidad VARCHAR(100) NULL,
    cedula       VARCHAR(50)  NULL,
    CONSTRAINT FK_Medicos_Usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Asistentes (
    id_asistente INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario   INT NOT NULL UNIQUE,
    id_medico    INT NULL,
    CONSTRAINT FK_Asistentes_Usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    CONSTRAINT FK_Asistentes_Medicos  FOREIGN KEY (id_medico)  REFERENCES Medicos(id_medico)
);

CREATE TABLE Pacientes (
    id_paciente  INT IDENTITY(1,1) PRIMARY KEY,
    nombre       VARCHAR(150) NOT NULL,
    telefono     VARCHAR(30)  NULL,
    correo       VARCHAR(150) NULL,
    creado_en    DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE Citas (
    id_cita      INT IDENTITY(1,1) PRIMARY KEY,
    id_paciente  INT NOT NULL,
    id_medico    INT NOT NULL,
    fecha_inicio DATETIME2 NOT NULL,
    fecha_fin    DATETIME2 NOT NULL,
    motivo       VARCHAR(255) NULL,
    estado       VARCHAR(20)  NOT NULL DEFAULT 'agendada',  -- agendada|modificada|cancelada|atendida
    costo        DECIMAL(10,2) NOT NULL DEFAULT 0,
    creado_en    DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Citas_Pacientes FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    CONSTRAINT FK_Citas_Medicos   FOREIGN KEY (id_medico)   REFERENCES Medicos(id_medico)
);

CREATE TABLE Ingresos (
    id_ingreso   INT IDENTITY(1,1) PRIMARY KEY,
    id_cita      INT NOT NULL,
    monto        DECIMAL(10,2) NOT NULL,
    fecha        DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Ingresos_Citas FOREIGN KEY (id_cita) REFERENCES Citas(id_cita)
);
GO

/* ---------- Datos de prueba ---------- */
INSERT INTO Roles (nombre) VALUES ('asistente'), ('medico'), ('administrador');

-- Contraseñas en texto plano para el esqueleto. En producción usar password_hash() en PHP.
INSERT INTO Usuarios (usuario, password, nombre, id_rol) VALUES
 ('asistente', 'asistente1', 'Maria Fernanda Canales', (SELECT id_rol FROM Roles WHERE nombre='asistente')),
 ('medico',    'medico1',    'Estefano Lopez Hamill',  (SELECT id_rol FROM Roles WHERE nombre='medico')),
 ('admin',     'admin1',     'Victor Puig Morales',    (SELECT id_rol FROM Roles WHERE nombre='administrador'));

INSERT INTO Medicos (id_usuario, especialidad, cedula)
 SELECT id_usuario, 'Medicina General', '0000000'
 FROM Usuarios WHERE usuario = 'medico';

INSERT INTO Asistentes (id_usuario, id_medico)
 SELECT u.id_usuario, m.id_medico
 FROM Usuarios u
 CROSS JOIN Medicos m
 WHERE u.usuario = 'asistente';
GO
