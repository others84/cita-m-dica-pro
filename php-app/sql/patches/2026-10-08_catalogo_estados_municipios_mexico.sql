-- ============================================================
-- Catalogo de estados y municipios de la Republica Mexicana
-- Fuente: INEGI. Ejecutar en la base CitasMedicas.
-- Es seguro ejecutarlo mas de una vez: no duplica registros.
-- ============================================================
SET NOCOUNT ON;

-- Pais Mexico (se crea si no existe)
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_PAIS WHERE nombre = N'Mexico' OR nombre = N'México')
    INSERT INTO citas.CATALOGO_PAIS (nombre, id_usuario_creacion, fecha_creacion)
    VALUES (N'Mexico', 0, GETDATE());
GO

DECLARE @idPais INT = (SELECT TOP 1 id_CATALOGO_PAIS FROM citas.CATALOGO_PAIS WHERE nombre = N'Mexico' OR nombre = N'México');
DECLARE @idEstado INT;

-- ---------- Aguascalientes (11 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Aguascalientes' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Aguascalientes', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Aguascalientes' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aguascalientes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aguascalientes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Asientos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Asientos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calvillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calvillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cosío' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cosío', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Llano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Llano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jesús María' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jesús María', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pabellón de Arteaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pabellón de Arteaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rincón de Romos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rincón de Romos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco de los Romo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco de los Romo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José de Gracia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José de Gracia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepezalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepezalá', @idEstado, 0, GETDATE());

-- ---------- Baja California (7 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Baja California' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Baja California', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Baja California' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ensenada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ensenada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mexicali' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mexicali', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Playas de Rosarito' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Playas de Rosarito', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Quintín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Quintín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecate' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecate', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tijuana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tijuana', @idEstado, 0, GETDATE());

-- ---------- Baja California Sur (5 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Baja California Sur' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Baja California Sur', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Baja California Sur' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Comondú' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Comondú', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Paz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Paz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Loreto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Loreto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Los Cabos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Los Cabos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mulegé' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mulegé', @idEstado, 0, GETDATE());

-- ---------- Campeche (13 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Campeche' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Campeche', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Campeche' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calakmul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calakmul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calkiní' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calkiní', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Campeche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Campeche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Candelaria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Candelaria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Carmen' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Carmen', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Champotón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Champotón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dzitbalché' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dzitbalché', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Escárcega' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Escárcega', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hecelchakán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hecelchakán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hopelchén' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hopelchén', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Palizada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Palizada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Seybaplaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Seybaplaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenabo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenabo', @idEstado, 0, GETDATE());

-- ---------- Coahuila de Zaragoza (38 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Coahuila de Zaragoza' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Coahuila de Zaragoza', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Coahuila de Zaragoza' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Abasolo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Abasolo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acuña' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acuña', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Allende' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Allende', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Arteaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Arteaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Candela' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Candela', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Castaños' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Castaños', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuatro Ciénegas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuatro Ciénegas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Escobedo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Escobedo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Francisco I. Madero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Francisco I. Madero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Frontera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Frontera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Cepeda' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Cepeda', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jiménez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jiménez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lamadrid' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lamadrid', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Matamoros' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Matamoros', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Monclova' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Monclova', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Múzquiz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Múzquiz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nadadores' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nadadores', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nava' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nava', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Parras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Parras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Piedras Negras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Piedras Negras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Progreso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Progreso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ramos Arizpe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ramos Arizpe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sabinas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sabinas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sacramento' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sacramento', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Saltillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Saltillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Buenaventura' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Buenaventura', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan de Sabinas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan de Sabinas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sierra Mojada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sierra Mojada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Torreón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Torreón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Viesca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Viesca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Unión' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Unión', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zaragoza', @idEstado, 0, GETDATE());

-- ---------- Colima (10 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Colima' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Colima', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Colima' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Armería' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Armería', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Colima' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Colima', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Comala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Comala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coquimatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coquimatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuauhtémoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuauhtémoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtlahuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtlahuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Manzanillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Manzanillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Minatitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Minatitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecomán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecomán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Álvarez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Álvarez', @idEstado, 0, GETDATE());

-- ---------- Chiapas (124 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Chiapas' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Chiapas', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Chiapas' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acacoyagua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acacoyagua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acapetahua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acapetahua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aldama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aldama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Altamirano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Altamirano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amatenango de la Frontera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amatenango de la Frontera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amatenango del Valle' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amatenango del Valle', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amatán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amatán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Arriaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Arriaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bejucal de Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bejucal de Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bella Vista' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bella Vista', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Benemérito de las Américas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Benemérito de las Américas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Berriozábal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Berriozábal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bochil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bochil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cacahoatán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cacahoatán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Capitán Luis Ángel Vidal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Capitán Luis Ángel Vidal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Catazajá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Catazajá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chalchihuitán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chalchihuitán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chamula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chamula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chanal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chanal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chapultenango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chapultenango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chenalhó' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chenalhó', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiapa de Corzo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiapa de Corzo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiapilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiapilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chicoasén' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chicoasén', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chicomuselo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chicomuselo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chilón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chilón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cintalapa de Figueroa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cintalapa de Figueroa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coapilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coapilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Comitán de Domínguez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Comitán de Domínguez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Copainalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Copainalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Bosque' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Bosque', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Parral' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Parral', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Porvenir' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Porvenir', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Emiliano Zapata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Emiliano Zapata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Escuintla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Escuintla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Francisco León' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Francisco León', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Frontera Comalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Frontera Comalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Frontera Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Frontera Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Honduras de la Sierra' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Honduras de la Sierra', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huehuetán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huehuetán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huitiupán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huitiupán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huixtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huixtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huixtán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huixtán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixhuatán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixhuatán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtacomitán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtacomitán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtapangajoya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtapangajoya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jiquipilas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jiquipilas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jitotol' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jitotol', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Concordia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Concordia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Grandeza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Grandeza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Independencia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Independencia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Libertad' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Libertad', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Trinitaria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Trinitaria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Larráinzar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Larráinzar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Las Margaritas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Las Margaritas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Las Rosas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Las Rosas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mapastepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mapastepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Maravilla Tenejapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Maravilla Tenejapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Marqués de Comillas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Marqués de Comillas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazapa de Madero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazapa de Madero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazatán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazatán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Metapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Metapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mezcalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mezcalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mitontic' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mitontic', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Montecristo de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Montecristo de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Motozintla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Motozintla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nicolás Ruíz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nicolás Ruíz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocosingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocosingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocozocoautla de Espinosa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocozocoautla de Espinosa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ostuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ostuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Osumacinta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Osumacinta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Oxchuc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Oxchuc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Palenque' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Palenque', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pantelhó' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pantelhó', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pantepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pantepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pichucalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pichucalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pijijiapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pijijiapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pueblo Nuevo Solistahuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pueblo Nuevo Solistahuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rayón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rayón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Reforma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Reforma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rincón Chamula San Pedro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rincón Chamula San Pedro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sabanilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sabanilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Salto de Agua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Salto de Agua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Duraznal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Duraznal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Cristóbal de las Casas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Cristóbal de las Casas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Fernando' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Fernando', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Cancuc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Cancuc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lucas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lucas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago el Pinar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago el Pinar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Siltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Siltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Simojovel' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Simojovel', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sitalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sitalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Socoltenango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Socoltenango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Solosuchiapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Solosuchiapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soyaló' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soyaló', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Suchiapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Suchiapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Suchiate' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Suchiate', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sunuapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sunuapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tapachula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tapachula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tapalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tapalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tapilula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tapilula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecpatán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecpatán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenejapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenejapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teopisca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teopisca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tonalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tonalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Totolapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Totolapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tumbalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tumbalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuxtla Chico' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuxtla Chico', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuxtla Gutiérrez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuxtla Gutiérrez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuzantán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuzantán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tzimol' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tzimol', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Unión Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Unión Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Venustiano Carranza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Venustiano Carranza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Comaltitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Comaltitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Corzo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Corzo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villaflores' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villaflores', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yajalón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yajalón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zinacantán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zinacantán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ángel Albino Corzo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ángel Albino Corzo', @idEstado, 0, GETDATE());

-- ---------- Chihuahua (67 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Chihuahua' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Chihuahua', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Chihuahua' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahumada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahumada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aldama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aldama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Allende' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Allende', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aquiles Serdán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aquiles Serdán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ascensión' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ascensión', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bachíniva' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bachíniva', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Balleza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Balleza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Batopilas de Manuel Gómez Morín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Batopilas de Manuel Gómez Morín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bocoyna' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bocoyna', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Buenaventura' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Buenaventura', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Camargo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Camargo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Carichí' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Carichí', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Casas Grandes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Casas Grandes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chihuahua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chihuahua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chínipas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chínipas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coronado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coronado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coyame del Sotol' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coyame del Sotol', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuauhtémoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuauhtémoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cusihuiriachi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cusihuiriachi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Delicias' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Delicias', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dr. Belisario Domínguez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dr. Belisario Domínguez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Tule' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Tule', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Galeana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Galeana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Gran Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Gran Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guachochi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guachochi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalupe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalupe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalupe y Calvo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalupe y Calvo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guazapares' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guazapares', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Gómez Farías' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Gómez Farías', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hidalgo del Parral' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hidalgo del Parral', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huejotitán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huejotitán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ignacio Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ignacio Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Janos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Janos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jiménez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jiménez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Julimes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Julimes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Cruz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Cruz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'López' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'López', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Madera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Madera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Maguarichi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Maguarichi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Manuel Benavides' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Manuel Benavides', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Matachí' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Matachí', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Matamoros' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Matamoros', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Meoqui' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Meoqui', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Moris' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Moris', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Namiquipa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Namiquipa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nonoava' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nonoava', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nuevo Casas Grandes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nuevo Casas Grandes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ojinaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ojinaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Praxedis G. Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Praxedis G. Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Riva Palacio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Riva Palacio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rosales' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rosales', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco de Borja' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco de Borja', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco de Conchos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco de Conchos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco del Oro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco del Oro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Bárbara' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Bárbara', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Isabel' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Isabel', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Satevó' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Satevó', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Saucillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Saucillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temósachic' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temósachic', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Urique' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Urique', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Uruachi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Uruachi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valle de Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valle de Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valle del Rosario' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valle del Rosario', @idEstado, 0, GETDATE());

-- ---------- Ciudad de México (16 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Ciudad de México' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Ciudad de México', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Ciudad de México' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Azcapotzalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Azcapotzalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Benito Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Benito Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coyoacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coyoacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuajimalpa de Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuajimalpa de Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuauhtémoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuauhtémoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Gustavo A. Madero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Gustavo A. Madero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Iztacalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Iztacalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Iztapalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Iztapalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Magdalena Contreras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Magdalena Contreras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Miguel Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Miguel Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Milpa Alta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Milpa Alta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tláhuac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tláhuac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Venustiano Carranza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Venustiano Carranza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochimilco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochimilco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Álvaro Obregón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Álvaro Obregón', @idEstado, 0, GETDATE());

-- ---------- Durango (39 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Durango' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Durango', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Durango' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Canatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Canatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Canelas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Canelas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coneto de Comonfort' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coneto de Comonfort', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuencamé' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuencamé', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Durango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Durango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Oro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Oro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Simón Bolívar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Simón Bolívar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalupe Victoria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalupe Victoria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guanaceví' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guanaceví', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Gómez Palacio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Gómez Palacio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Indé' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Indé', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lerdo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lerdo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mapimí' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mapimí', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mezquital' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mezquital', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nazas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nazas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nombre de Dios' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nombre de Dios', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nuevo Ideal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nuevo Ideal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Otáez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Otáez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Peñón Blanco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Peñón Blanco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Poanas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Poanas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pueblo Nuevo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pueblo Nuevo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pánuco de Coronado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pánuco de Coronado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rodeo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rodeo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bernardo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bernardo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Dimas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Dimas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan de Guadalupe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan de Guadalupe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Luis del Cordero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Luis del Cordero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro del Gallo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro del Gallo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Clara' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Clara', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Papasquiaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Papasquiaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Súchil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Súchil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tamazula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tamazula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepehuanes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepehuanes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlahualilo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlahualilo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Topia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Topia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Vicente Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Vicente Guerrero', @idEstado, 0, GETDATE());

-- ---------- Guanajuato (46 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Guanajuato' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Guanajuato', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Guanajuato' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Abasolo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Abasolo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acámbaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acámbaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apaseo el Alto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apaseo el Alto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apaseo el Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apaseo el Grande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atarjea' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atarjea', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Celaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Celaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Comonfort' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Comonfort', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coroneo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coroneo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cortazar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cortazar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuerámaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuerámaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Doctor Mora' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Doctor Mora', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dolores Hidalgo Cuna de la Independencia Nacional' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dolores Hidalgo Cuna de la Independencia Nacional', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guanajuato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guanajuato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huanímaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huanímaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Irapuato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Irapuato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jaral del Progreso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jaral del Progreso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jerécuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jerécuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'León' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'León', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Manuel Doblado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Manuel Doblado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Moroleón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Moroleón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pueblo Nuevo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pueblo Nuevo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Purísima del Rincón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Purísima del Rincón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pénjamo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pénjamo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Romita' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Romita', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Salamanca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Salamanca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Salvatierra' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Salvatierra', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Diego de la Unión' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Diego de la Unión', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco del Rincón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco del Rincón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José de Iturbide' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José de Iturbide', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Luis de la Paz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Luis de la Paz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel de Allende' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel de Allende', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz de Juventino Rosas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz de Juventino Rosas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Maravatío' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Maravatío', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Silao de la Victoria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Silao de la Victoria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tarandacuao' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tarandacuao', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tarimoro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tarimoro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tierra Blanca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tierra Blanca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Uriangato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Uriangato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valle de Santiago' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valle de Santiago', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Victoria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Victoria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villagrán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villagrán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xichú' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xichú', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yuriria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yuriria', @idEstado, 0, GETDATE());

-- ---------- Guerrero (85 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Guerrero' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Guerrero', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Guerrero' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acapulco de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acapulco de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahuacuotzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahuacuotzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ajuchitlán del Progreso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ajuchitlán del Progreso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Alcozauca de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Alcozauca de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Alpoyeca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Alpoyeca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apaxtla de Castrejón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apaxtla de Castrejón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Arcelia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Arcelia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atenango del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atenango del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlamajalcingo del Monte' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlamajalcingo del Monte', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlixtac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlixtac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atoyac de Álvarez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atoyac de Álvarez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ayutla de los Libres' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ayutla de los Libres', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Azoyú' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Azoyú', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Benito Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Benito Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Buenavista de Cuéllar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Buenavista de Cuéllar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chilapa de Álvarez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chilapa de Álvarez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chilpancingo de los Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chilpancingo de los Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coahuayutla de José María Izazaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coahuayutla de José María Izazaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cochoapa el Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cochoapa el Grande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cocula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cocula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Copala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Copala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Copalillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Copalillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Copanatoyac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Copanatoyac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coyuca de Benítez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coyuca de Benítez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coyuca de Catalán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coyuca de Catalán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuajinicuilapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuajinicuilapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cualác' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cualác', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuetzala del Progreso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuetzala del Progreso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cutzamala de Pinzón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cutzamala de Pinzón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Eduardo Neri' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Eduardo Neri', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Florencio Villarreal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Florencio Villarreal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Canuto A. Neri' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Canuto A. Neri', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Heliodoro Castillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Heliodoro Castillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huamuxtitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huamuxtitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huitzuco de los Figueroa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huitzuco de los Figueroa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Iguala de la Independencia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Iguala de la Independencia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Igualapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Igualapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Iliatenco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Iliatenco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixcateopan de Cuauhtémoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixcateopan de Cuauhtémoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'José Joaquín de Herrera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'José Joaquín de Herrera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juan R. Escudero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juan R. Escudero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juchitán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juchitán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Unión de Isidoro Montes de Oca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Unión de Isidoro Montes de Oca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Las Vigas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Las Vigas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Leonardo Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Leonardo Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Malinaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Malinaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Marquelia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Marquelia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Metlatónoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Metlatónoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mochitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mochitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mártir de Cuilapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mártir de Cuilapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Olinalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Olinalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ometepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ometepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pedro Ascencio Alquisiras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pedro Ascencio Alquisiras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Petatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Petatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pilcaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pilcaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pungarabato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pungarabato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Quechultenango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Quechultenango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Luis Acatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Luis Acatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Marcos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Marcos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Totolapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Totolapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Nicolás' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Nicolás', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz del Rincón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz del Rincón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Taxco de Alarcón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Taxco de Alarcón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecoanapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecoanapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teloloapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teloloapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepecoacuilco de Trujano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepecoacuilco de Trujano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tetipac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tetipac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tixtla de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tixtla de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacoachistlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacoachistlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacoapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacoapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalchapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalchapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalixtaquilla de Maldonado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalixtaquilla de Maldonado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlapa de Comonfort' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlapa de Comonfort', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlapehuala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlapehuala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Técpan de Galeana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Técpan de Galeana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xalpatláhuac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xalpatláhuac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochihuehuetlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochihuehuetlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochistlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochistlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotitlán Tablas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotitlán Tablas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zihuatanejo de Azueta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zihuatanejo de Azueta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zirándaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zirándaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zitlala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zitlala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ñuu Savi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ñuu Savi', @idEstado, 0, GETDATE());

-- ---------- Hidalgo (84 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Hidalgo' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Hidalgo', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Hidalgo' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acaxochitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acaxochitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Actopan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Actopan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Agua Blanca de Iturbide' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Agua Blanca de Iturbide', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ajacuba' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ajacuba', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Alfajayucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Alfajayucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Almoloya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Almoloya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atitalaquia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atitalaquia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlapexco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlapexco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atotonilco de Tula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atotonilco de Tula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atotonilco el Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atotonilco el Grande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calnali' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calnali', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cardonal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cardonal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chapantongo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chapantongo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chapulhuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chapulhuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chilcuautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chilcuautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautepec de Hinojosa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautepec de Hinojosa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Arenal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Arenal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Eloxochitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Eloxochitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Emiliano Zapata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Emiliano Zapata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Epazoyucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Epazoyucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Francisco I. Madero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Francisco I. Madero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huasca de Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huasca de Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huazalingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huazalingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huehuetla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huehuetla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huejutla de Reyes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huejutla de Reyes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huichapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huichapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixmiquilpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixmiquilpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jacala de Ledezma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jacala de Ledezma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jaltocán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jaltocán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juárez Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juárez Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Misión' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Misión', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lolotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lolotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Metepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Metepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Metztitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Metztitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mineral de la Reforma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mineral de la Reforma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mineral del Chico' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mineral del Chico', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mineral del Monte' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mineral del Monte', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mixquiahuala de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mixquiahuala de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Molango de Escamilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Molango de Escamilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nicolás Flores' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nicolás Flores', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nopala de Villagrán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nopala de Villagrán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Omitlán de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Omitlán de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pachuca de Soto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pachuca de Soto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pacula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pacula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pisaflores' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pisaflores', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Progreso de Obregón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Progreso de Obregón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín Metzquititlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín Metzquititlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín Tlaxiaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín Tlaxiaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bartolo Tutotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bartolo Tutotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe Orizatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe Orizatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Salvador' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Salvador', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tulantepec de Lugo Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tulantepec de Lugo Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago de Anaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago de Anaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Singuilucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Singuilucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tasquillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tasquillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecozautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecozautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenango de Doria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenango de Doria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepeapulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepeapulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepehuacán de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepehuacán de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepeji del Río de Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepeji del Río de Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepetitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepetitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tetepango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tetepango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tezontepec de Aldama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tezontepec de Aldama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tianguistengo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tianguistengo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tizayuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tizayuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlahuelilpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlahuelilpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlahuiltepa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlahuiltepa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlanalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlanalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlanchinol' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlanchinol', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaxcoapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaxcoapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tolcayuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tolcayuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tula de Allende' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tula de Allende', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tulancingo de Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tulancingo de Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Tezontepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Tezontepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochiatipan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochiatipan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochicoatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochicoatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yahualica' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yahualica', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacualtipán de Ángeles' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacualtipán de Ángeles', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotlán de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotlán de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zempoala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zempoala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zimapán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zimapán', @idEstado, 0, GETDATE());

-- ---------- Jalisco (125 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Jalisco' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Jalisco', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Jalisco' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acatic' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acatic', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acatlán de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acatlán de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahualulco de Mercado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahualulco de Mercado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amacueca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amacueca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amatitán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amatitán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ameca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ameca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Arandas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Arandas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atemajac de Brizuela' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atemajac de Brizuela', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atengo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atengo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atenguillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atenguillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atotonilco el Alto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atotonilco el Alto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atoyac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atoyac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Autlán de Navarro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Autlán de Navarro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ayotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ayotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ayutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ayutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bolaños' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bolaños', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cabo Corrientes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cabo Corrientes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Casimiro Castillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Casimiro Castillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cañadas de Obregón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cañadas de Obregón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chapala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chapala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chimaltitán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chimaltitán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiquilistlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiquilistlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cihuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cihuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cocula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cocula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Colotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Colotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Concepción de Buenos Aires' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Concepción de Buenos Aires', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautitlán de García Barragán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautitlán de García Barragán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuquío' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuquío', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Degollado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Degollado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ejutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ejutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Arenal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Arenal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Grullo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Grullo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Limón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Limón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Salto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Salto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Encarnación de Díaz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Encarnación de Díaz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Etzatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Etzatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guachinango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guachinango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalajara' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalajara', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Gómez Farías' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Gómez Farías', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hostotipaquillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hostotipaquillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huejuquilla el Alto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huejuquilla el Alto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huejúcar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huejúcar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtlahuacán de los Membrillos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtlahuacán de los Membrillos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtlahuacán del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtlahuacán del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jalostotitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jalostotitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jamay' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jamay', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jesús María' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jesús María', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jilotlán de los Dolores' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jilotlán de los Dolores', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jocotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jocotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juanacatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juanacatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juchitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juchitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Barca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Barca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Huerta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Huerta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Manzanilla de la Paz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Manzanilla de la Paz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lagos de Moreno' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lagos de Moreno', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mascota' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mascota', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazamitla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazamitla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mexticacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mexticacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mezquitic' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mezquitic', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mixtlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mixtlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ojuelos de Jalisco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ojuelos de Jalisco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pihuamo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pihuamo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Poncitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Poncitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Puerto Vallarta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Puerto Vallarta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Quitupan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Quitupan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Cristóbal de la Barranca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Cristóbal de la Barranca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Diego de Alejandría' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Diego de Alejandría', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Gabriel' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Gabriel', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Ignacio Cerro Gordo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Ignacio Cerro Gordo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan de los Lagos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan de los Lagos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juanito de Escobedo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juanito de Escobedo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Julián' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Julián', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Marcos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Marcos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín de Bolaños' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín de Bolaños', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel el Alto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel el Alto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Tlaquepaque' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Tlaquepaque', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián del Oeste' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián del Oeste', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María de los Ángeles' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María de los Ángeles', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María del Oro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María del Oro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sayula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sayula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Talpa de Allende' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Talpa de Allende', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tamazula de Gordiano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tamazula de Gordiano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tapalpa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tapalpa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecalitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecalitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Techaluta de Montenegro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Techaluta de Montenegro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecolotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecolotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenamaxtlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenamaxtlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teocaltiche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teocaltiche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teocuitatlán de Corona' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teocuitatlán de Corona', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepatitlán de Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepatitlán de Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tequila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tequila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teuchitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teuchitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tizapán el Alto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tizapán el Alto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlajomulco de Zúñiga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlajomulco de Zúñiga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tolimán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tolimán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tomatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tomatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tonalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tonalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tonaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tonaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tonila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tonila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Totatiche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Totatiche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tototlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tototlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuxcacuesco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuxcacuesco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuxcueca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuxcueca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuxpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuxpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Unión de San Antonio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Unión de San Antonio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Unión de Tula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Unión de Tula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valle de Guadalupe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valle de Guadalupe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valle de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valle de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Corona' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Corona', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Purificación' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Purificación', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yahualica de González Gallo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yahualica de González Gallo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacoalco de Torres' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacoalco de Torres', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapopan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapopan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotiltic' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotiltic', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotitlán de Vadillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotitlán de Vadillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotlanejo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotlanejo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotlán del Rey' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotlán del Rey', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotlán el Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotlán el Grande', @idEstado, 0, GETDATE());

-- ---------- México (125 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'México' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'México', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'México' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acambay de Ruíz Castañeda' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acambay de Ruíz Castañeda', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acolman' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acolman', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aculco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aculco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Almoloya de Alquisiras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Almoloya de Alquisiras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Almoloya de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Almoloya de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Almoloya del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Almoloya del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amanalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amanalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amecameca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amecameca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apaxco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apaxco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atenco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atenco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atizapán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atizapán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atizapán de Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atizapán de Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlacomulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlacomulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Axapusco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Axapusco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ayapango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ayapango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calimaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calimaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Capulhuac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Capulhuac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chapa de Mota' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chapa de Mota', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chapultepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chapultepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chicoloapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chicoloapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiconcuac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiconcuac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chimalhuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chimalhuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coacalco de Berriozábal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coacalco de Berriozábal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coatepec Harinas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coatepec Harinas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cocotitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cocotitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coyotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coyotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautitlán Izcalli' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautitlán Izcalli', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Donato Guerra' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Donato Guerra', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ecatepec de Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ecatepec de Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ecatzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ecatzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Oro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Oro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huehuetoca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huehuetoca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hueypoxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hueypoxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huixquilucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huixquilucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Isidro Fabela' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Isidro Fabela', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtapaluca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtapaluca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtapan de la Sal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtapan de la Sal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtapan del Oro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtapan del Oro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jaltenco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jaltenco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jilotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jilotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jilotzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jilotzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jiquipilco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jiquipilco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jocotitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jocotitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Joquicingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Joquicingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juchitepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juchitepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Paz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Paz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lerma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lerma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Luvianos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Luvianos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Malinalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Malinalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Melchor Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Melchor Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Metepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Metepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mexicaltzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mexicaltzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Naucalpan de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Naucalpan de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nextlalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nextlalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nezahualcóyotl' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nezahualcóyotl', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nicolás Romero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nicolás Romero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nopaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nopaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocoyoacac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocoyoacac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocuilan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocuilan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Otumba' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Otumba', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Otzoloapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Otzoloapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Otzolotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Otzolotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ozumba' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ozumba', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Papalotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Papalotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Polotitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Polotitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rayón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rayón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonio la Isla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonio la Isla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe del Progreso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe del Progreso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José del Rincón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José del Rincón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín de las Pirámides' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín de las Pirámides', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Atenco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Atenco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Simón de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Simón de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Tomás' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Tomás', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soyaniquilpan de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soyaniquilpan de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sultepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sultepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecámac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecámac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tejupilco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tejupilco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temamatla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temamatla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temascalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temascalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temascalcingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temascalcingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temascaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temascaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temoaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temoaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenancingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenancingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenango del Aire' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenango del Aire', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenango del Valle' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenango del Valle', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teoloyucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teoloyucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teotihuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teotihuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepetlaoxtoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepetlaoxtoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepetlixpa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepetlixpa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepotzotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepotzotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tequixquiac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tequixquiac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Texcaltitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Texcaltitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Texcalyacac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Texcalyacac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Texcoco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Texcoco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tezoyuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tezoyuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tianguistenco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tianguistenco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Timilpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Timilpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalmanalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalmanalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalnepantla de Baz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalnepantla de Baz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlatlaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlatlaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Toluca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Toluca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tonanitla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tonanitla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tonatico' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tonatico', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tultepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tultepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tultitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tultitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valle de Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valle de Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valle de Chalco Solidaridad' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valle de Chalco Solidaridad', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Victoria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Victoria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Allende' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Allende', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa del Carbón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa del Carbón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xalatlaco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xalatlaco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xonacatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xonacatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacazonapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacazonapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacualpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacualpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zinacantepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zinacantepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zumpahuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zumpahuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zumpango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zumpango', @idEstado, 0, GETDATE());

-- ---------- Michoacán de Ocampo (113 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Michoacán de Ocampo' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Michoacán de Ocampo', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Michoacán de Ocampo' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acuitzio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acuitzio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aguililla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aguililla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Angamacutiro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Angamacutiro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Angangueo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Angangueo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apatzingán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apatzingán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aporo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aporo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aquila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aquila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ario' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ario', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Arteaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Arteaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Briseñas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Briseñas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Buenavista' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Buenavista', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Carácuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Carácuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Charapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Charapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Charo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Charo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chavinda' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chavinda', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cherán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cherán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chilchota' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chilchota', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chinicuila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chinicuila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chucándiro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chucándiro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Churintzio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Churintzio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Churumuco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Churumuco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coahuayana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coahuayana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coalcomán de Vázquez Pallares' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coalcomán de Vázquez Pallares', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coeneo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coeneo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cojumatlán de Régules' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cojumatlán de Régules', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Contepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Contepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Copándaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Copándaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cotija' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cotija', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuitzeo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuitzeo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ecuandureo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ecuandureo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Epitacio Huerta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Epitacio Huerta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Erongarícuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Erongarícuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Gabriel Zamora' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Gabriel Zamora', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huandacareo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huandacareo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huaniqueo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huaniqueo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huetamo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huetamo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huiramba' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huiramba', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Indaparapeo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Indaparapeo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Irimbo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Irimbo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jacona' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jacona', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jiménez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jiménez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jiquilpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jiquilpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'José Sixto Verduzco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'José Sixto Verduzco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jungapeo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jungapeo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Huacana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Huacana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Piedad' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Piedad', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lagunillas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lagunillas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Los Reyes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Los Reyes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lázaro Cárdenas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lázaro Cárdenas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Madero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Madero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Maravatío' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Maravatío', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Marcos Castellanos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Marcos Castellanos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Morelia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Morelia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Múgica' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Múgica', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nahuatzen' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nahuatzen', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nocupétaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nocupétaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nuevo Parangaricutiro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nuevo Parangaricutiro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nuevo Urecho' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nuevo Urecho', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Numarán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Numarán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pajacuarán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pajacuarán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Panindícuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Panindícuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Paracho' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Paracho', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Parácuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Parácuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Penjamillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Penjamillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Peribán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Peribán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Puruándiro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Puruándiro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Purépero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Purépero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pátzcuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pátzcuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Queréndaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Queréndaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Quiroga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Quiroga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sahuayo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sahuayo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Salvador Escalante' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Salvador Escalante', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lucas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lucas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana Maya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana Maya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Senguio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Senguio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Susupuato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Susupuato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tacámbaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tacámbaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tancítaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tancítaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tangamandapio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tangamandapio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tangancícuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tangancícuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tanhuato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tanhuato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Taretan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Taretan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tarímbaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tarímbaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepalcatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepalcatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tingambato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tingambato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tingüindín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tingüindín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tiquicheo de Nicolás Romero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tiquicheo de Nicolás Romero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalpujahua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalpujahua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlazazalca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlazazalca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tocumbo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tocumbo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tumbiscatío' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tumbiscatío', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Turicato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Turicato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuxpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuxpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuzantla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuzantla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tzintzuntzan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tzintzuntzan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tzitzio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tzitzio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Uruapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Uruapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Venustiano Carranza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Venustiano Carranza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villamar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villamar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Vista Hermosa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Vista Hermosa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yurécuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yurécuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacapu' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacapu', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zamora' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zamora', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zinapécuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zinapécuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zináparo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zináparo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ziracuaretiro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ziracuaretiro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zitácuaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zitácuaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Álvaro Obregón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Álvaro Obregón', @idEstado, 0, GETDATE());

-- ---------- Morelos (36 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Morelos' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Morelos', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Morelos' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amacuzac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amacuzac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlatlahucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlatlahucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Axochiapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Axochiapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ayala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ayala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coatetelco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coatetelco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coatlán del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coatlán del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuernavaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuernavaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Emiliano Zapata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Emiliano Zapata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hueyapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hueyapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huitzilac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huitzilac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jantetelco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jantetelco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jiutepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jiutepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jojutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jojutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jonacatepec de Leandro Valle' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jonacatepec de Leandro Valle', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Miacatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Miacatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocuituco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocuituco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Puente de Ixtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Puente de Ixtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temixco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temixco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temoac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temoac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepalcingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepalcingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepoztlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepoztlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tetecala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tetecala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tetela del Volcán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tetela del Volcán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalnepantla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalnepantla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaltizapán de Zapata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaltizapán de Zapata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaquiltenango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaquiltenango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlayacapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlayacapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Totolapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Totolapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochitepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochitepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xoxocotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xoxocotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yautepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yautepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yecapixtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yecapixtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacualpan de Amilpas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacualpan de Amilpas', @idEstado, 0, GETDATE());

-- ---------- Nayarit (20 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Nayarit' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Nayarit', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Nayarit' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acaponeta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acaponeta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahuacatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahuacatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amatlán de Cañas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amatlán de Cañas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bahía de Banderas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bahía de Banderas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Compostela' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Compostela', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Del Nayar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Del Nayar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huajicori' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huajicori', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtlán del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtlán del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Yesca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Yesca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rosamorada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rosamorada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ruíz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ruíz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Blas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Blas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Lagunillas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Lagunillas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María del Oro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María del Oro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Ixcuintla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Ixcuintla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecuala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecuala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepic' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepic', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuxpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuxpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xalisco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xalisco', @idEstado, 0, GETDATE());

-- ---------- Nuevo León (51 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Nuevo León' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Nuevo León', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Nuevo León' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Abasolo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Abasolo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Agualeguas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Agualeguas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Allende' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Allende', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Anáhuac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Anáhuac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apodaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apodaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aramberri' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aramberri', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bustamante' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bustamante', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cadereyta Jiménez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cadereyta Jiménez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cerralvo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cerralvo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'China' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'China', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ciénega de Flores' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ciénega de Flores', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Doctor Arroyo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Doctor Arroyo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Doctor Coss' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Doctor Coss', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Doctor González' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Doctor González', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Carmen' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Carmen', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Galeana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Galeana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'García' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'García', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Escobedo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Escobedo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Terán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Terán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Treviño' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Treviño', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Zuazua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Zuazua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalupe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalupe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Higueras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Higueras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hualahuises' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hualahuises', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Iturbide' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Iturbide', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lampazos de Naranjo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lampazos de Naranjo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Linares' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Linares', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Los Aldamas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Los Aldamas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Los Herreras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Los Herreras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Los Ramones' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Los Ramones', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Marín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Marín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Melchor Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Melchor Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mier y Noriega' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mier y Noriega', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mina' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mina', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Montemorelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Montemorelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Monterrey' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Monterrey', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Parás' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Parás', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pesquería' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pesquería', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rayones' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rayones', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sabinas Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sabinas Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Salinas Victoria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Salinas Victoria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Nicolás de los Garza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Nicolás de los Garza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Garza García' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Garza García', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Vallecillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Vallecillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villaldama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villaldama', @idEstado, 0, GETDATE());

-- ---------- Oaxaca (570 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Oaxaca' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Oaxaca', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Oaxaca' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Abejones' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Abejones', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acatlán de Pérez Figueroa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acatlán de Pérez Figueroa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Asunción Cacalotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Asunción Cacalotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Asunción Cuyotepeji' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Asunción Cuyotepeji', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Asunción Ixtaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Asunción Ixtaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Asunción Nochixtlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Asunción Nochixtlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Asunción Ocotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Asunción Ocotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Asunción Tlacolulita' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Asunción Tlacolulita', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ayoquezco de Aldama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ayoquezco de Aldama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ayotzintepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ayotzintepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calihualá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calihualá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Candelaria Loxicha' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Candelaria Loxicha', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Capulálpam de Méndez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Capulálpam de Méndez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chahuites' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chahuites', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chalcatongo de Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chalcatongo de Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiquihuitlán de Benito Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiquihuitlán de Benito Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ciudad Ixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ciudad Ixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ciénega de Zimatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ciénega de Zimatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coatecas Altas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coatecas Altas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coicoyán de las Flores' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coicoyán de las Flores', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Concepción Buenavista' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Concepción Buenavista', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Concepción Pápalo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Concepción Pápalo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Constancia del Rosario' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Constancia del Rosario', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cosolapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cosolapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cosoltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cosoltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuilápam de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuilápam de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuyamecalco Villa de Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuyamecalco Villa de Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Barrio de la Soledad' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Barrio de la Soledad', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Espinal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Espinal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Eloxochitlán de Flores Magón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Eloxochitlán de Flores Magón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Fresnillo de Trujano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Fresnillo de Trujano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalupe Etla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalupe Etla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalupe de Ramírez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalupe de Ramírez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guelatao de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guelatao de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guevea de Humboldt' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guevea de Humboldt', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Heroica Ciudad de Ejutla de Crespo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Heroica Ciudad de Ejutla de Crespo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Heroica Ciudad de Huajuapan de León' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Heroica Ciudad de Huajuapan de León', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Heroica Ciudad de Juchitán de Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Heroica Ciudad de Juchitán de Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Heroica Ciudad de Miahuatlán de Porfirio Díaz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Heroica Ciudad de Miahuatlán de Porfirio Díaz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Heroica Ciudad de Tlaxiaco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Heroica Ciudad de Tlaxiaco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Heroica Villa Tezoatlán de Segura y Luna, Cuna de la Independencia de Oaxaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Heroica Villa Tezoatlán de Segura y Luna, Cuna de la Independencia de Oaxaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Heroica Villa de San Blas Atempa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Heroica Villa de San Blas Atempa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Heroico San Martín de los Cansecos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Heroico San Martín de los Cansecos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huautepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huautepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huautla de Jiménez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huautla de Jiménez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixpantepec Nieves' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixpantepec Nieves', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtlán de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtlán de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Compañía' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Compañía', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Pe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Pe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Reforma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Reforma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Trinidad Vista Hermosa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Trinidad Vista Hermosa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Loma Bonita' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Loma Bonita', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Apasco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Apasco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Jaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Jaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Mixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Mixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Ocotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Ocotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Peñasco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Peñasco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Teitipac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Teitipac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Tequisistlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Tequisistlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Tlacotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Tlacotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Yodocono de Porfirio Díaz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Yodocono de Porfirio Díaz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena Zahuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena Zahuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mariscala de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mariscala de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Matías Romero Avendaño' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Matías Romero Avendaño', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazatlán Villa de Flores' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazatlán Villa de Flores', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mesones Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mesones Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mixistlán de la Reforma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mixistlán de la Reforma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Monjas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Monjas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mártires de Tacubaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mártires de Tacubaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Natividad' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Natividad', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nazareno Etla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nazareno Etla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nejapa de Madero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nejapa de Madero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nuevo Zoquiápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nuevo Zoquiápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Oaxaca de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Oaxaca de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocotlán de Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocotlán de Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pinotepa de Don Luis' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pinotepa de Don Luis', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pluma Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pluma Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Putla Villa de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Putla Villa de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Reforma de Pineda' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Reforma de Pineda', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Reyes Etla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Reyes Etla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rojas de Cuauhtémoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rojas de Cuauhtémoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Salina Cruz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Salina Cruz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín Amatengo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín Amatengo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín Atenango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín Atenango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín Chayuco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín Chayuco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín Etla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín Etla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín Loxicha' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín Loxicha', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín Tlacotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín Tlacotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín Yatareni' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín Yatareni', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Agustín de las Juntas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Agustín de las Juntas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Cabecera Nueva' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Cabecera Nueva', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Dinicuiti' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Dinicuiti', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Huaxpaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Huaxpaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Huayápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Huayápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Ixtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Ixtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Lagunas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Lagunas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Nuxiño' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Nuxiño', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Paxtlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Paxtlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Sinaxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Sinaxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Solaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Solaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Teotilálpam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Teotilálpam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Tepetlapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Tepetlapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Yaá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Yaá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Zabache' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Zabache', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Zautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Zautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonino Castillo Velasco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonino Castillo Velasco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonino Monte Verde' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonino Monte Verde', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonino el Alto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonino el Alto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonio Acutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonio Acutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonio Huitepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonio Huitepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonio Nanahuatípam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonio Nanahuatípam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonio Sinicahua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonio Sinicahua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonio Tepetlapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonio Tepetlapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonio de la Cal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonio de la Cal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Baltazar Chichicápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Baltazar Chichicápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Baltazar Loxicha' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Baltazar Loxicha', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Baltazar Yatzachi el Bajo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Baltazar Yatzachi el Bajo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bartolo Coyotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bartolo Coyotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bartolo Soyaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bartolo Soyaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bartolo Yautepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bartolo Yautepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bartolomé Ayautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bartolomé Ayautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bartolomé Loxicha' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bartolomé Loxicha', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bartolomé Quialana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bartolomé Quialana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bartolomé Yucuañe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bartolomé Yucuañe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bartolomé Zoogocho' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bartolomé Zoogocho', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Bernardo Mixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Bernardo Mixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Carlos Yautepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Carlos Yautepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Cristóbal Amatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Cristóbal Amatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Cristóbal Amoltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Cristóbal Amoltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Cristóbal Lachirioag' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Cristóbal Lachirioag', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Cristóbal Suchixtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Cristóbal Suchixtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Dionisio Ocotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Dionisio Ocotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Dionisio Ocotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Dionisio Ocotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Dionisio del Mar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Dionisio del Mar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Esteban Atatlahuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Esteban Atatlahuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe Jalapa de Díaz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe Jalapa de Díaz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe Tejalápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe Tejalápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe Usila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe Usila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Cahuacuá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Cahuacuá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Cajonos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Cajonos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Chapulapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Chapulapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Chindúa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Chindúa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Huehuetlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Huehuetlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Ixhuatán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Ixhuatán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Jaltepetongo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Jaltepetongo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Lachigoló' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Lachigoló', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Logueche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Logueche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Nuxaño' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Nuxaño', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Ozolotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Ozolotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Sola' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Sola', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Telixtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Telixtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Teopan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Teopan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Tlapancingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Tlapancingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco del Mar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco del Mar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Gabriel Mixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Gabriel Mixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Ildefonso Amatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Ildefonso Amatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Ildefonso Sola' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Ildefonso Sola', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Ildefonso Villa Alta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Ildefonso Villa Alta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jacinto Amilpas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jacinto Amilpas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jacinto Tlacotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jacinto Tlacotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jerónimo Coatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jerónimo Coatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jerónimo Silacayoapilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jerónimo Silacayoapilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jerónimo Sosola' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jerónimo Sosola', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jerónimo Taviche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jerónimo Taviche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jerónimo Tecóatl' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jerónimo Tecóatl', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jerónimo Tlacochahuaya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jerónimo Tlacochahuaya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jorge Nuchita' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jorge Nuchita', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José Ayuquila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José Ayuquila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José Chiltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José Chiltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José Estancia Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José Estancia Grande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José Independencia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José Independencia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José Lachiguiri' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José Lachiguiri', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José Tenango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José Tenango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José del Peñasco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José del Peñasco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José del Progreso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José del Progreso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Achiutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Achiutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Atepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Atepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Atatlahuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Atatlahuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Coixtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Coixtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Cuicatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Cuicatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Guelache' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Guelache', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Jayacatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Jayacatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Lo de Soto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Lo de Soto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Suchitepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Suchitepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Tlachichilco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Tlachichilco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Tlacoatzintepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Tlacoatzintepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Tuxtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Tuxtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Bautista Valle Nacional' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Bautista Valle Nacional', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Cacahuatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Cacahuatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Chicomezúchil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Chicomezúchil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Chilateca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Chilateca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Cieneguilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Cieneguilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Coatzóspam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Coatzóspam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Colorado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Colorado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Comaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Comaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Cotzocón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Cotzocón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Diuxi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Diuxi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Evangelista Analco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Evangelista Analco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Guelavía' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Guelavía', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Guichicovi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Guichicovi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Ihualtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Ihualtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Juquila Mixes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Juquila Mixes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Juquila Vijanos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Juquila Vijanos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Lachao' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Lachao', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Lachigalla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Lachigalla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Lajarcia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Lajarcia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Lalana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Lalana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Mazatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Mazatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Mixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Mixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Mixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Mixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Ozolotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Ozolotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Petlapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Petlapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Quiahije' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Quiahije', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Quiotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Quiotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Sayultepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Sayultepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Tabaá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Tabaá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Tamazola' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Tamazola', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Teita' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Teita', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Teitipac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Teitipac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Tepeuxila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Tepeuxila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Teposcolula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Teposcolula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Yaeé' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Yaeé', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Yatzona' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Yatzona', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Yucuita' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Yucuita', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan de los Cués' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan de los Cués', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan del Estado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan del Estado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Ñumí' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Ñumí', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lorenzo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lorenzo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lorenzo Albarradas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lorenzo Albarradas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lorenzo Cacaotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lorenzo Cacaotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lorenzo Cuaunecuiltitla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lorenzo Cuaunecuiltitla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lorenzo Texmelúcan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lorenzo Texmelúcan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lorenzo Victoria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lorenzo Victoria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lucas Camotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lucas Camotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lucas Ojitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lucas Ojitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lucas Quiaviní' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lucas Quiaviní', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lucas Zoquiápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lucas Zoquiápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Luis Amatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Luis Amatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Marcial Ozolotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Marcial Ozolotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Marcos Arteaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Marcos Arteaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Huamelúlpam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Huamelúlpam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Itunyoso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Itunyoso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Lachilá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Lachilá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Peras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Peras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Tilcajete' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Tilcajete', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Toxpalan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Toxpalan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Zacatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Zacatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Cajonos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Cajonos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Etlatongo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Etlatongo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Nejápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Nejápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Peñasco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Peñasco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Piñas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Piñas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Río Hondo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Río Hondo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Sindihui' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Sindihui', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Tlapiltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Tlapiltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Yoloxochitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Yoloxochitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo Yucutindoo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo Yucutindoo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Mateo del Mar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Mateo del Mar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Melchor Betaza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Melchor Betaza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Achiutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Achiutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Ahuehuetitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Ahuehuetitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Aloápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Aloápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Amatitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Amatitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Amatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Amatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Chicahua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Chicahua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Chimalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Chimalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Coatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Coatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Ejutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Ejutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Huautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Huautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Mixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Mixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Panixtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Panixtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Peras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Peras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Piedras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Piedras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Quetzaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Quetzaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Santa Flor' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Santa Flor', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Soyaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Soyaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Suchixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Suchixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Tecomatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Tecomatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Tenango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Tenango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Tequixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Tequixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Tilquiápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Tilquiápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Tlacamama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Tlacamama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Tlacotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Tlacotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Tulancingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Tulancingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Yotao' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Yotao', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel del Puerto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel del Puerto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel el Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel el Grande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Nicolás' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Nicolás', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Nicolás Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Nicolás Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Coatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Coatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Cuatro Venados' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Cuatro Venados', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Etla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Etla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Huitzo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Huitzo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Huixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Huixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Macuiltianguis' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Macuiltianguis', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Tijaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Tijaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Villa de Mitla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Villa de Mitla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Yaganiza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Yaganiza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Amuzgos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Amuzgos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Apóstol' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Apóstol', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Atoyac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Atoyac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Cajonos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Cajonos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Comitancillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Comitancillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Coxcaltepec Cántaros' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Coxcaltepec Cántaros', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Huamelula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Huamelula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Huilotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Huilotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Ixcatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Ixcatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Ixtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Ixtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Jaltepetongo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Jaltepetongo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Jicayán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Jicayán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Jocotipac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Jocotipac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Juchatengo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Juchatengo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Mixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Mixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Mixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Mixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Molinos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Molinos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Mártir' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Mártir', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Mártir Quiechapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Mártir Quiechapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Mártir Yucuxaco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Mártir Yucuxaco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Nopala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Nopala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Ocopetatillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Ocopetatillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Ocotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Ocotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Pochutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Pochutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Quiatoni' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Quiatoni', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Sochiápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Sochiápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Tapanatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Tapanatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Taviche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Taviche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Teozacoalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Teozacoalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Teutila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Teutila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Tidaá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Tidaá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Topiltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Topiltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Totolápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Totolápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Yaneri' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Yaneri', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Yucunama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Yucunama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Yólox' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Yólox', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro el Alto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro el Alto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro y San Pablo Ayutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro y San Pablo Ayutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro y San Pablo Teposcolula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro y San Pablo Teposcolula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro y San Pablo Tequixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro y San Pablo Tequixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Raymundo Jalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Raymundo Jalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián Abasolo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián Abasolo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián Coatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián Coatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián Ixcapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián Ixcapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián Nicananduta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián Nicananduta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián Río Hondo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián Río Hondo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián Tecomaxtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián Tecomaxtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián Teitipac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián Teitipac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián Tutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián Tutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Simón Almolongas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Simón Almolongas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Simón Zahuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Simón Zahuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Vicente Coatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Vicente Coatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Vicente Lachixío' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Vicente Lachixío', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Vicente Nuñú' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Vicente Nuñú', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana Ateixtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana Ateixtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana Cuauhtémoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana Cuauhtémoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana Tavela' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana Tavela', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana Tlapacoyan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana Tlapacoyan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana Yareni' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana Yareni', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana Zegache' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana Zegache', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana del Valle' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana del Valle', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catalina Quierí' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catalina Quierí', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Cuixtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Cuixtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Ixtepeji' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Ixtepeji', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Juquila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Juquila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Lachatao' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Lachatao', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Loxicha' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Loxicha', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Mechoacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Mechoacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Minas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Minas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Quiané' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Quiané', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Quioquitani' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Quioquitani', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Tayata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Tayata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Ticuá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Ticuá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Yosonotú' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Yosonotú', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Zapoquila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Zapoquila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Acatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Acatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Amilpas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Amilpas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Itundujia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Itundujia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Mixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Mixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Nundaco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Nundaco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Papalutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Papalutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Tacache de Mina' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Tacache de Mina', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Tacahua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Tacahua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Tayata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Tayata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Xitla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Xitla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Xoxocotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Xoxocotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Zenzontepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Zenzontepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz de Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz de Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Gertrudis' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Gertrudis', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Inés Yatzeche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Inés Yatzeche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Inés de Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Inés de Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Inés del Monte' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Inés del Monte', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Lucía Miahuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Lucía Miahuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Lucía Monteverde' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Lucía Monteverde', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Lucía Ocotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Lucía Ocotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Lucía del Camino' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Lucía del Camino', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Magdalena Jicotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Magdalena Jicotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Alotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Alotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Apazco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Apazco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Atzompa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Atzompa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Camotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Camotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Chachoápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Chachoápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Chilchotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Chilchotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Chimalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Chimalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Colotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Colotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Cortijo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Cortijo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Coyotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Coyotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Ecatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Ecatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Guelacé' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Guelacé', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Guienagati' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Guienagati', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Huatulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Huatulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Huazolotitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Huazolotitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Ipalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Ipalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Ixcatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Ixcatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Jacatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Jacatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Jalapa del Marqués' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Jalapa del Marqués', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Jaltianguis' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Jaltianguis', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Lachixío' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Lachixío', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Mixtequilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Mixtequilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Nativitas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Nativitas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Nduayaco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Nduayaco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Ozolotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Ozolotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Petapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Petapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Peñoles' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Peñoles', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Pápalo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Pápalo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Quiegolani' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Quiegolani', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Sola' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Sola', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Tataltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Tataltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Tecomavaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Tecomavaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Temaxcalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Temaxcalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Temaxcaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Temaxcaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Teopoxco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Teopoxco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Tepantlali' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Tepantlali', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Texcatitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Texcatitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Tlahuitoltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Tlahuitoltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Tlalixtac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Tlalixtac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Tonameca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Tonameca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Totolapilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Totolapilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Xadani' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Xadani', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Yalina' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Yalina', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Yavesía' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Yavesía', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Yolotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Yolotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Yosoyúa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Yosoyúa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Yucuhiti' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Yucuhiti', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Zacatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Zacatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Zaniza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Zaniza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María Zoquitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María Zoquitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María del Rosario' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María del Rosario', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María del Tule' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María del Tule', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María la Asunción' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María la Asunción', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Amoltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Amoltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Apoala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Apoala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Apóstol' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Apóstol', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Astata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Astata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Atitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Atitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Ayuquililla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Ayuquililla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Cacaloxtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Cacaloxtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Camotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Camotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Choápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Choápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Comaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Comaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Huajolotitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Huajolotitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Huauclilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Huauclilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Ihuitlán Plumas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Ihuitlán Plumas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Ixcuintepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Ixcuintepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Ixtayutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Ixtayutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Jamiltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Jamiltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Jocotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Jocotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Juxtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Juxtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Lachiguiri' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Lachiguiri', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Lalopa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Lalopa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Laollaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Laollaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Laxopa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Laxopa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Llano Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Llano Grande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Matatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Matatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Miltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Miltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Minas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Minas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Nacaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Nacaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Nejapilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Nejapilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Niltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Niltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Nundiche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Nundiche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Nuyoó' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Nuyoó', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Pinotepa Nacional' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Pinotepa Nacional', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Suchilquitongo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Suchilquitongo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tamazola' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tamazola', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tapextla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tapextla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tenango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tenango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tepetlapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tepetlapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tetepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tetepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Texcalcingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Texcalcingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Textitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Textitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tilantongo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tilantongo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tlazoyaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tlazoyaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Xanica' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Xanica', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Xiacuí' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Xiacuí', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Yaitepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Yaitepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Yaveo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Yaveo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Yolomécatl' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Yolomécatl', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Yosondúa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Yosondúa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Yucuyachi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Yucuyachi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Zacatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Zacatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Zoochila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Zoochila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Albarradas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Albarradas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Armenta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Armenta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Chihuitán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Chihuitán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Ingenio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Ingenio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Ixcatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Ixcatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Nuxaá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Nuxaá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Ozolotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Ozolotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Petapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Petapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Roayaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Roayaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Tehuantepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Tehuantepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Teojomulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Teojomulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Tepuxtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Tepuxtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Tlatayápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Tlatayápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Tomaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Tomaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Tonaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Tonaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Tonalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Tonalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Xagacía' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Xagacía', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Yanhuitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Yanhuitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Yodohino' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Yodohino', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo Zanatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo Zanatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo de Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo de Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Tomás Jalieza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Tomás Jalieza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Tomás Mazaltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Tomás Mazaltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Tomás Ocotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Tomás Ocotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Tomás Tamazulapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Tomás Tamazulapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santos Reyes Nopala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santos Reyes Nopala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santos Reyes Pápalo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santos Reyes Pápalo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santos Reyes Tepejillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santos Reyes Tepejillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santos Reyes Yucuná' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santos Reyes Yucuná', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Silacayoápam' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Silacayoápam', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sitio de Xitlapehua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sitio de Xitlapehua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soledad Etla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soledad Etla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tamazulápam del Espíritu Santo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tamazulápam del Espíritu Santo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tanetze de Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tanetze de Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Taniche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Taniche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tataltepec de Valdés' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tataltepec de Valdés', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teococuilco de Marcos Pérez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teococuilco de Marcos Pérez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teotitlán de Flores Magón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teotitlán de Flores Magón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teotitlán del Valle' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teotitlán del Valle', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teotongo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teotongo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepelmeme Villa de Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepelmeme Villa de Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacolula de Matamoros' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacolula de Matamoros', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacotepec Plumas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacotepec Plumas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalixtac de Cabrera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalixtac de Cabrera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Totontepec Villa de Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Totontepec Villa de Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Trinidad Zaachila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Trinidad Zaachila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Unión Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Unión Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valerio Trujano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valerio Trujano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Díaz Ordaz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Díaz Ordaz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Hidalgo Yalálag' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Hidalgo Yalálag', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Sola de Vega' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Sola de Vega', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Talea de Castro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Talea de Castro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Tejúpam de la Unión' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Tejúpam de la Unión', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Chilapa de Díaz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Chilapa de Díaz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Etla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Etla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Santiago Chazumba' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Santiago Chazumba', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Tamazulápam del Progreso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Tamazulápam del Progreso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Tututepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Tututepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Zaachila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Zaachila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yaxe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yaxe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yogana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yogana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yutanduchi de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yutanduchi de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotitlán Lagunas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotitlán Lagunas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotitlán Palmas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotitlán Palmas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zimatlán de Álvarez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zimatlán de Álvarez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ánimas Trujano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ánimas Trujano', @idEstado, 0, GETDATE());

-- ---------- Puebla (217 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Puebla' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Puebla', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Puebla' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acajete' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acajete', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acateno' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acateno', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acatzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acatzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acteopan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acteopan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahuacatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahuacatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahuazotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahuazotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahuehuetitla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahuehuetitla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ajalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ajalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Albino Zertuche' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Albino Zertuche', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aljojuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aljojuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Altepexi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Altepexi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amixtlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amixtlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amozoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amozoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aquixtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aquixtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atempan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atempan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atexcal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atexcal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlequizayan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlequizayan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlixco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlixco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atoyatempan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atoyatempan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atzala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atzala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atzitzihuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atzitzihuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atzitzintla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atzitzintla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Axutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Axutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ayotoxco de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ayotoxco de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Caltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Caltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Camocuautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Camocuautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Caxhuacan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Caxhuacan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cañada Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cañada Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chalchicomula de Sesma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chalchicomula de Sesma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chapulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chapulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiautzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiautzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chichiquila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chichiquila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiconcuautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiconcuautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chietla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chietla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chigmecatitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chigmecatitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chignahuapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chignahuapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chignautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chignautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chila de la Sal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chila de la Sal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chilchotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chilchotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chinantla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chinantla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coatzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coatzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cohetzala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cohetzala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cohuecan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cohuecan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coronango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coronango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coxcatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coxcatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coyomeapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coyomeapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coyotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coyotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuapiaxtla de Madero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuapiaxtla de Madero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautempan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautempan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautinchán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautinchán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuautlancingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuautlancingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuayuca de Andrade' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuayuca de Andrade', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuetzalan del Progreso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuetzalan del Progreso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuyoaco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuyoaco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Domingo Arenas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Domingo Arenas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Eloxochitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Eloxochitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Epatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Epatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Esperanza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Esperanza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Francisco Z. Mena' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Francisco Z. Mena', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Felipe Ángeles' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Felipe Ángeles', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalupe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalupe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalupe Victoria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalupe Victoria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hermenegildo Galeana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hermenegildo Galeana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Honey' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Honey', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huaquechula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huaquechula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huatlatlauca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huatlatlauca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huauchinango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huauchinango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huehuetla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huehuetla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huehuetlán el Chico' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huehuetlán el Chico', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huehuetlán el Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huehuetlán el Grande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huejotzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huejotzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hueyapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hueyapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hueytamalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hueytamalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hueytlalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hueytlalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huitzilan de Serdán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huitzilan de Serdán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huitziltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huitziltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixcamilpa de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixcamilpa de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixcaquixtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixcaquixtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtacamaxtitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtacamaxtitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Izúcar de Matamoros' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Izúcar de Matamoros', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jolalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jolalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jonotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jonotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jopala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jopala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juan C. Bonilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juan C. Bonilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juan Galindo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juan Galindo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juan N. Méndez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juan N. Méndez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Magdalena Tlatlauquitepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Magdalena Tlatlauquitepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lafragua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lafragua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Libres' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Libres', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Los Reyes de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Los Reyes de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazapiltepec de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazapiltepec de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mixtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mixtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Molcaxac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Molcaxac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Naupan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Naupan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nauzontla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nauzontla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nealtican' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nealtican', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nicolás Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nicolás Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nopalucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nopalucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocoyucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocoyucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Olintla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Olintla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Oriental' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Oriental', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pahuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pahuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Palmar de Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Palmar de Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pantepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pantepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Petlalcingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Petlalcingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Piaxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Piaxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Puebla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Puebla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Quecholac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Quecholac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Quimixtlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Quimixtlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rafael Lara Grajales' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rafael Lara Grajales', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Cholula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Cholula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonio Cañada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonio Cañada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Diego la Mesa Tochimiltzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Diego la Mesa Tochimiltzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe Teotlalcingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe Teotlalcingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe Tepatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe Tepatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Gabriel Chilac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Gabriel Chilac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Gregorio Atzompa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Gregorio Atzompa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jerónimo Tecuanipan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jerónimo Tecuanipan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jerónimo Xayacatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jerónimo Xayacatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José Chiapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José Chiapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José Miahuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José Miahuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Atenco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Atenco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Atzompa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Atzompa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Texmelucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Texmelucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Totoltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Totoltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Matías Tlalancaleca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Matías Tlalancaleca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Ixitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Ixitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel Xoxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel Xoxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Nicolás Buenos Aires' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Nicolás Buenos Aires', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Nicolás de los Ranchos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Nicolás de los Ranchos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo Anicano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo Anicano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Cholula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Cholula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro Yeloixtlahuaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro Yeloixtlahuaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Salvador Huixcolotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Salvador Huixcolotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Salvador el Seco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Salvador el Seco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Salvador el Verde' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Salvador el Verde', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Sebastián Tlacotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Sebastián Tlacotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Tlaltempan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Tlaltempan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Inés Ahuatempan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Inés Ahuatempan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Isabel Cholula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Isabel Cholula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Miahuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Miahuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Tomás Hueyotlipan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Tomás Hueyotlipan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecali de Herrera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecali de Herrera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecamachalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecamachalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecomatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecomatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tehuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tehuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tehuitzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tehuitzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenampulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenampulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teopantlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teopantlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teotlalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teotlalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepanco de López' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepanco de López', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepango de Rodríguez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepango de Rodríguez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepatlaxco de Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepatlaxco de Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepeaca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepeaca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepemaxalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepemaxalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepeojuma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepeojuma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepetzintla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepetzintla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepexco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepexco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepexi de Rodríguez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepexi de Rodríguez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepeyahualco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepeyahualco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepeyahualco de Cuauhtémoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepeyahualco de Cuauhtémoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tetela de Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tetela de Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teteles de Ávila Castillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teteles de Ávila Castillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teziutlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teziutlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tianguismanalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tianguismanalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tilapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tilapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlachichuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlachichuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacotepec de Benito Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacotepec de Benito Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacuilotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacuilotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlahuapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlahuapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaltenango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaltenango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlanepantla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlanepantla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaola' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaola', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlapacoya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlapacoya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlapanalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlapanalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlatlauquitepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlatlauquitepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaxco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaxco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tochimilco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tochimilco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tochtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tochtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Totoltepec de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Totoltepec de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tulcingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tulcingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuzamapan de Galeana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuzamapan de Galeana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tzicatlacoyan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tzicatlacoyan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Venustiano Carranza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Venustiano Carranza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Vicente Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Vicente Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xayacatlán de Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xayacatlán de Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xicotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xicotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xicotlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xicotlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xiutetelco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xiutetelco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochiapulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochiapulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochiltepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochiltepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochitlán Todos Santos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochitlán Todos Santos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xochitlán de Vicente Suárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xochitlán de Vicente Suárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yaonáhuac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yaonáhuac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yehualtepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yehualtepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacapala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacapala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacapoaxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacapoaxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zapotitlán de Méndez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zapotitlán de Méndez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zihuateutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zihuateutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zinacatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zinacatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zongozotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zongozotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zoquiapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zoquiapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zoquitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zoquitlán', @idEstado, 0, GETDATE());

-- ---------- Querétaro (18 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Querétaro' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Querétaro', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Querétaro' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amealco de Bonfil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amealco de Bonfil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Arroyo Seco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Arroyo Seco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cadereyta de Montes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cadereyta de Montes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Colón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Colón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Corregidora' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Corregidora', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Marqués' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Marqués', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ezequiel Montes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ezequiel Montes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huimilpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huimilpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jalpan de Serra' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jalpan de Serra', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Landa de Matamoros' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Landa de Matamoros', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pedro Escobedo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pedro Escobedo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Peñamiller' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Peñamiller', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pinal de Amoles' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pinal de Amoles', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Querétaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Querétaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Joaquín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Joaquín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tequisquiapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tequisquiapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tolimán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tolimán', @idEstado, 0, GETDATE());

-- ---------- Quintana Roo (11 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Quintana Roo' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Quintana Roo', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Quintana Roo' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bacalar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bacalar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Benito Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Benito Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cozumel' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cozumel', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Felipe Carrillo Puerto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Felipe Carrillo Puerto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Isla Mujeres' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Isla Mujeres', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'José María Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'José María Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lázaro Cárdenas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lázaro Cárdenas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Othón P. Blanco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Othón P. Blanco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Playa del Carmen' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Playa del Carmen', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Puerto Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Puerto Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tulum' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tulum', @idEstado, 0, GETDATE());

-- ---------- San Luis Potosí (59 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'San Luis Potosí' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'San Luis Potosí', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'San Luis Potosí' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahualulco del Sonido 13' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahualulco del Sonido 13', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Alaquines' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Alaquines', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aquismón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aquismón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Armadillo de los Infante' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Armadillo de los Infante', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Axtla de Terrazas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Axtla de Terrazas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Catorce' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Catorce', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cedral' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cedral', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cerritos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cerritos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cerro de San Pedro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cerro de San Pedro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Charcas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Charcas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ciudad Fernández' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ciudad Fernández', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ciudad Valles' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ciudad Valles', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ciudad del Maíz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ciudad del Maíz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coxcatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coxcatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cárdenas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cárdenas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ebano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ebano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Naranjo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Naranjo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalcázar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalcázar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huehuetlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huehuetlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lagunillas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lagunillas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Matehuala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Matehuala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Matlapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Matlapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mexquitic de Carmona' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mexquitic de Carmona', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Moctezuma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Moctezuma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rayón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rayón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rioverde' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rioverde', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Salinas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Salinas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Antonio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Antonio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Ciro de Acosta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Ciro de Acosta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Luis Potosí' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Luis Potosí', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Martín Chalchicuautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Martín Chalchicuautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Nicolás Tolentino' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Nicolás Tolentino', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Vicente Tancuayalab' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Vicente Tancuayalab', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santo Domingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santo Domingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soledad de Graciano Sánchez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soledad de Graciano Sánchez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tamasopo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tamasopo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tamazunchale' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tamazunchale', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tampacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tampacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tampamolón Corona' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tampamolón Corona', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tamuín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tamuín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tancanhuitz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tancanhuitz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tanlajás' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tanlajás', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tanquián de Escobedo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tanquián de Escobedo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tierra Nueva' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tierra Nueva', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Vanegas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Vanegas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Venado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Venado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Arista' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Arista', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Arriaga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Arriaga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Guadalupe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Guadalupe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Pozos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Pozos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Ramos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Ramos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Reyes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Reyes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de la Paz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de la Paz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xilitla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xilitla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zaragoza', @idEstado, 0, GETDATE());

-- ---------- Sinaloa (20 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Sinaloa' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Sinaloa', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Sinaloa' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ahome' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ahome', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Angostura' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Angostura', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Badiraguato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Badiraguato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Choix' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Choix', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Concordia' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Concordia', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cosalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cosalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Culiacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Culiacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Fuerte' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Fuerte', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Eldorado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Eldorado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Elota' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Elota', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Escuinapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Escuinapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guasave' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guasave', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juan José Ríos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juan José Ríos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mocorito' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mocorito', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Navolato' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Navolato', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rosario' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rosario', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Salvador Alvarado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Salvador Alvarado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Ignacio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Ignacio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sinaloa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sinaloa', @idEstado, 0, GETDATE());

-- ---------- Sonora (72 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Sonora' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Sonora', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Sonora' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aconchi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aconchi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Agua Prieta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Agua Prieta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Altar' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Altar', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Arivechi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Arivechi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Arizpe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Arizpe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bacadéhuachi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bacadéhuachi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bacanora' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bacanora', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bacerac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bacerac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bacoachi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bacoachi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Banámichi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Banámichi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bavispe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bavispe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Baviácora' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Baviácora', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Benito Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Benito Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Benjamín Hill' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Benjamín Hill', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bácum' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bácum', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Caborca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Caborca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cajeme' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cajeme', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cananea' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cananea', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Carbó' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Carbó', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cucurpe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cucurpe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cumpas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cumpas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Divisaderos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Divisaderos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Empalme' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Empalme', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Etchojoa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Etchojoa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Fronteras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Fronteras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Plutarco Elías Calles' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Plutarco Elías Calles', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Granados' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Granados', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guaymas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guaymas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hermosillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hermosillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huachinera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huachinera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huatabampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huatabampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huásabas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huásabas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huépac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huépac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Imuris' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Imuris', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Colorada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Colorada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazatán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazatán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Moctezuma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Moctezuma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Naco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Naco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nacozari de García' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nacozari de García', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Navojoa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Navojoa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nogales' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nogales', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nácori Chico' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nácori Chico', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Opodepe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Opodepe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Oquitoa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Oquitoa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pitiquito' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pitiquito', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Puerto Peñasco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Puerto Peñasco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Quiriego' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Quiriego', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rayón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rayón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rosario' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rosario', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sahuaripa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sahuaripa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe de Jesús' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe de Jesús', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Ignacio Río Muerto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Ignacio Río Muerto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Javier' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Javier', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Luis Río Colorado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Luis Río Colorado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Miguel de Horcasitas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Miguel de Horcasitas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pedro de la Cueva' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pedro de la Cueva', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soyopa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soyopa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Suaqui Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Suaqui Grande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sáric' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sáric', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepache' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepache', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Trincheras' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Trincheras', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tubutama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tubutama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ures' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ures', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Pesqueira' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Pesqueira', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yécora' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yécora', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Álamos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Álamos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ónavas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ónavas', @idEstado, 0, GETDATE());

-- ---------- Tabasco (17 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Tabasco' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Tabasco', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Tabasco' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Balancán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Balancán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Centla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Centla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Centro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Centro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Comalcalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Comalcalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cunduacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cunduacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cárdenas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cárdenas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Emiliano Zapata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Emiliano Zapata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huimanguillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huimanguillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jalpa de Méndez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jalpa de Méndez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jonuta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jonuta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Macuspana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Macuspana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nacajuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nacajuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Paraíso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Paraíso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tacotalpa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tacotalpa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenosique' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenosique', @idEstado, 0, GETDATE());

-- ---------- Tamaulipas (43 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Tamaulipas' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Tamaulipas', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Tamaulipas' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Abasolo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Abasolo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aldama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aldama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Altamira' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Altamira', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Antiguo Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Antiguo Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Burgos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Burgos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bustamante' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bustamante', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Camargo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Camargo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Casas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Casas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ciudad Madero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ciudad Madero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cruillas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cruillas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Mante' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Mante', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'González' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'González', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Gustavo Díaz Ordaz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Gustavo Díaz Ordaz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Gómez Farías' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Gómez Farías', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Güémez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Güémez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jaumave' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jaumave', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jiménez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jiménez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Llera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Llera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mainero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mainero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Matamoros' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Matamoros', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mier' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mier', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Miguel Alemán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Miguel Alemán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Miquihuana' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Miquihuana', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Méndez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Méndez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nuevo Laredo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nuevo Laredo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nuevo Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nuevo Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Padilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Padilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Palmillas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Palmillas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Reynosa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Reynosa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Río Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Río Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Carlos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Carlos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Fernando' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Fernando', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Nicolás' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Nicolás', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soto la Marina' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soto la Marina', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tampico' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tampico', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valle Hermoso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valle Hermoso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Victoria' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Victoria', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villagrán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villagrán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xicoténcatl' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xicoténcatl', @idEstado, 0, GETDATE());

-- ---------- Tlaxcala (60 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Tlaxcala' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Tlaxcala', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Tlaxcala' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acuamanala de Miguel Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acuamanala de Miguel Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amaxac de Guerrero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amaxac de Guerrero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apetatitlán de Antonio Carvajal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apetatitlán de Antonio Carvajal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apizaco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apizaco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlangatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlangatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atltzayanca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atltzayanca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Benito Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Benito Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calpulalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calpulalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiautempan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiautempan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Contla de Juan Cuamatzi' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Contla de Juan Cuamatzi', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuapiaxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuapiaxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuaxomulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuaxomulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Carmen Tequexquitla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Carmen Tequexquitla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Emiliano Zapata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Emiliano Zapata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Españita' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Españita', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huamantla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huamantla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hueyotlipan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hueyotlipan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtacuixtla de Mariano Matamoros' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtacuixtla de Mariano Matamoros', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtenco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtenco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Magdalena Tlaltelulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Magdalena Tlaltelulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lázaro Cárdenas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lázaro Cárdenas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazatecochco de José María Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazatecochco de José María Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Muñoz de Domingo Arenas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Muñoz de Domingo Arenas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nanacamilpa de Mariano Arista' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nanacamilpa de Mariano Arista', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Natívitas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Natívitas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Panotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Panotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Papalotla de Xicohténcatl' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Papalotla de Xicohténcatl', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Damián Texóloc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Damián Texóloc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Francisco Tetlanohcan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Francisco Tetlanohcan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Jerónimo Zacualpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Jerónimo Zacualpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San José Teacalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San José Teacalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Huactzinco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Huactzinco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lorenzo Axocomanitla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lorenzo Axocomanitla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Lucas Tecopilco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Lucas Tecopilco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Pablo del Monte' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Pablo del Monte', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sanctórum de Lázaro Cárdenas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sanctórum de Lázaro Cárdenas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Ana Nopalucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Ana Nopalucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Apolonia Teacalco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Apolonia Teacalco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Catarina Ayometla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Catarina Ayometla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Quilehtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Quilehtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Cruz Tlaxcala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Cruz Tlaxcala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Isabel Xiloxoxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Isabel Xiloxoxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenancingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenancingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teolocholco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teolocholco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepetitla de Lardizábal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepetitla de Lardizábal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepeyanco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepeyanco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Terrenate' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Terrenate', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tetla de la Solidaridad' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tetla de la Solidaridad', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tetlatlahuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tetlatlahuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaxcala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaxcala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaxco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaxco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tocatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tocatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Totolac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Totolac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tzompantepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tzompantepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xaloztoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xaloztoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xaltocan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xaltocan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xicohtzinco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xicohtzinco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yauhquemehcan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yauhquemehcan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacatelco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacatelco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ziltlaltépec de Trinidad Sánchez Santos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ziltlaltépec de Trinidad Sánchez Santos', @idEstado, 0, GETDATE());

-- ---------- Veracruz de Ignacio de la Llave (212 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Veracruz de Ignacio de la Llave' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Veracruz de Ignacio de la Llave', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Veracruz de Ignacio de la Llave' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acajete' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acajete', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acayucan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acayucan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Actopan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Actopan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acula' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acula', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acultzingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acultzingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Agua Dulce' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Agua Dulce', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Alpatláhuac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Alpatláhuac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Alto Lucero de Gutiérrez Barrios' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Alto Lucero de Gutiérrez Barrios', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Altotonga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Altotonga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Alvarado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Alvarado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amatitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amatitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Amatlán de los Reyes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Amatlán de los Reyes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Angel R. Cabada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Angel R. Cabada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apazapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apazapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Aquila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Aquila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Astacinga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Astacinga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atlahuilco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atlahuilco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atoyac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atoyac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atzacan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atzacan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atzalan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atzalan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ayahualulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ayahualulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Banderilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Banderilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Benito Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Benito Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Boca del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Boca del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calcahualco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calcahualco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Camarón de Tejeda' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Camarón de Tejeda', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Camerino Z. Mendoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Camerino Z. Mendoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Carlos A. Carrillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Carlos A. Carrillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Carrillo Puerto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Carrillo Puerto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Castillo de Teayo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Castillo de Teayo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Catemaco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Catemaco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cazones de Herrera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cazones de Herrera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cerro Azul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cerro Azul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chacaltianguis' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chacaltianguis', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chalma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chalma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiconamel' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiconamel', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chiconquiaco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chiconquiaco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chicontepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chicontepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chinameca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chinameca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chinampa de Gorostiza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chinampa de Gorostiza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chocamán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chocamán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chontla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chontla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chumatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chumatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Citlaltépetl' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Citlaltépetl', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coacoatzintla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coacoatzintla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coahuitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coahuitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coatzacoalcos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coatzacoalcos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coatzintla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coatzintla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coetzala' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coetzala', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Colipa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Colipa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Comapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Comapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cosamaloapan de Carpio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cosamaloapan de Carpio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cosautlán de Carvajal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cosautlán de Carvajal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coscomatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coscomatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cosoleacaque' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cosoleacaque', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cotaxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cotaxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coxquihui' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coxquihui', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Coyutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Coyutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuichapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuichapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuitláhuac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuitláhuac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Córdoba' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Córdoba', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Higo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Higo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Emiliano Zapata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Emiliano Zapata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Espinal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Espinal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Filomeno Mata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Filomeno Mata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Fortín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Fortín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Gutiérrez Zamora' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Gutiérrez Zamora', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hidalgotitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hidalgotitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huatusco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huatusco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huayacocotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huayacocotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hueyapan de Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hueyapan de Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huiloapan de Cuauhtémoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huiloapan de Cuauhtémoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ignacio de la Llave' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ignacio de la Llave', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ilamatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ilamatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Isla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Isla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixcatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixcatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixhuacán de los Reyes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixhuacán de los Reyes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixhuatlancillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixhuatlancillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixhuatlán de Madero' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixhuatlán de Madero', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixhuatlán del Café' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixhuatlán del Café', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixhuatlán del Sureste' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixhuatlán del Sureste', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixmatlahuacan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixmatlahuacan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixtaczoquitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixtaczoquitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jalacingo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jalacingo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jalcomulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jalcomulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jamapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jamapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jesús Carranza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jesús Carranza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jilotepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jilotepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'José Azueta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'José Azueta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juan Rodríguez Clara' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juan Rodríguez Clara', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juchique de Ferrer' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juchique de Ferrer', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jáltipan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jáltipan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Antigua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Antigua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'La Perla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'La Perla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Landero y Coss' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Landero y Coss', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Las Choapas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Las Choapas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Las Minas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Las Minas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Las Vigas de Ramírez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Las Vigas de Ramírez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Lerdo de Tejada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Lerdo de Tejada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Los Reyes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Los Reyes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Magdalena' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Magdalena', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Maltrata' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Maltrata', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Manlio Fabio Altamirano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Manlio Fabio Altamirano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mariano Escobedo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mariano Escobedo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Martínez de la Torre' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Martínez de la Torre', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mecatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mecatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mecayapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mecayapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Medellín de Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Medellín de Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Miahuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Miahuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Minatitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Minatitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Misantla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Misantla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mixtla de Altamirano' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mixtla de Altamirano', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Moloacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Moloacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nanchital de Lázaro Cárdenas del Río' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nanchital de Lázaro Cárdenas del Río', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Naolinco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Naolinco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Naranjal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Naranjal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Naranjos Amatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Naranjos Amatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nautla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nautla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nogales' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nogales', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Oluta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Oluta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Omealca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Omealca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Orizaba' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Orizaba', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Otatitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Otatitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Oteapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Oteapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ozuluama de Mascareñas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ozuluama de Mascareñas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pajapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pajapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Papantla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Papantla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Paso de Ovejas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Paso de Ovejas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Paso del Macho' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Paso del Macho', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Perote' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Perote', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Platón Sánchez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Platón Sánchez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Playa Vicente' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Playa Vicente', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Poza Rica de Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Poza Rica de Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pueblo Viejo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pueblo Viejo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Puente Nacional' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Puente Nacional', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pánuco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pánuco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rafael Delgado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rafael Delgado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Rafael Lucio' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Rafael Lucio', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Río Blanco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Río Blanco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Saltabarranca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Saltabarranca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Tenejapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Tenejapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Andrés Tuxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Andrés Tuxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Juan Evangelista' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Juan Evangelista', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Rafael' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Rafael', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Sochiapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Sochiapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santiago Tuxtla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santiago Tuxtla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sayula de Alemán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sayula de Alemán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sochiapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sochiapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soconusco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soconusco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soledad Atzompa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soledad Atzompa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soledad de Doblado' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soledad de Doblado', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Soteapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Soteapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tamalín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tamalín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tamiahua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tamiahua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tampico Alto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tampico Alto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tancoco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tancoco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tantima' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tantima', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tantoyuca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tantoyuca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tatahuicapan de Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tatahuicapan de Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tatatila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tatatila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecolutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecolutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tehuipango' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tehuipango', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tempoal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tempoal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenampa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenampa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tenochtitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tenochtitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teocelo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teocelo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepatlaxco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepatlaxco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepetlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepetlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepetzintla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepetzintla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tequila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tequila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Texcatepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Texcatepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Texhuacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Texhuacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Texistepec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Texistepec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tezonapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tezonapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tierra Blanca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tierra Blanca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tihuatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tihuatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlachichilco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlachichilco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacojalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacojalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacolulan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacolulan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacotalpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacotalpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlacotepec de Mejía' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlacotepec de Mejía', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalixcoyan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalixcoyan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlalnelhuayocan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlalnelhuayocan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaltetela' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaltetela', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlapacoyan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlapacoyan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaquilpa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaquilpa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlilapan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlilapan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tomatlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tomatlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tonayán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tonayán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Totutla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Totutla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tres Valles' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tres Valles', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuxpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuxpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tuxtilla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tuxtilla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ursulo Galván' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ursulo Galván', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Uxpanapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Uxpanapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Vega de Alatorre' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Vega de Alatorre', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Veracruz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Veracruz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Aldama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Aldama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xalapa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xalapa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xico' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xico', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xoxocotla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xoxocotla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yanga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yanga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yecuatla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yecuatla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacualpan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacualpan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zaragoza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zaragoza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zentla' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zentla', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zongolica' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zongolica', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zontecomatlán de López y Fuentes' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zontecomatlán de López y Fuentes', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zozocolco de Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zozocolco de Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Álamo Temapache' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Álamo Temapache', @idEstado, 0, GETDATE());

-- ---------- Yucatán (106 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Yucatán' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Yucatán', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Yucatán' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Abalá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Abalá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Acanceh' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Acanceh', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Akil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Akil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Baca' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Baca', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Bokobá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Bokobá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Buctzotz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Buctzotz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cacalchén' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cacalchén', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calotmul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calotmul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cansahcab' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cansahcab', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cantamayec' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cantamayec', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Celestún' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Celestún', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cenotillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cenotillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chacsinkín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chacsinkín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chankom' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chankom', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chapab' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chapab', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chemax' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chemax', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chichimilá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chichimilá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chicxulub Pueblo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chicxulub Pueblo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chikindzonot' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chikindzonot', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chocholá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chocholá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chumayel' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chumayel', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Conkal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Conkal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuncunul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuncunul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuzamá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuzamá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dzan' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dzan', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dzemul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dzemul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dzidzantún' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dzidzantún', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dzilam González' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dzilam González', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dzilam de Bravo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dzilam de Bravo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dzitás' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dzitás', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Dzoncauich' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Dzoncauich', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Espita' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Espita', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Halachó' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Halachó', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hocabá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hocabá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hoctún' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hoctún', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Homún' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Homún', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huhí' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huhí', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Hunucmá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Hunucmá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ixil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ixil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Izamal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Izamal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Kanasín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Kanasín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Kantunil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Kantunil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Kaua' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Kaua', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Kinchil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Kinchil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Kopomá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Kopomá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Maní' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Maní', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Maxcanú' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Maxcanú', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mayapán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mayapán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mocochá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mocochá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Motul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Motul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Muna' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Muna', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Muxupip' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Muxupip', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mérida' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mérida', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Opichén' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Opichén', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Oxkutzcab' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Oxkutzcab', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Panabá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Panabá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Peto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Peto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Progreso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Progreso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Quintana Roo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Quintana Roo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Río Lagartos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Río Lagartos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sacalum' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sacalum', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Samahil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Samahil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'San Felipe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'San Felipe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sanahcat' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sanahcat', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa Elena' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa Elena', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Seyé' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Seyé', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sinanché' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sinanché', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sotuta' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sotuta', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sucilá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sucilá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sudzal' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sudzal', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Suma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Suma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tahdziú' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tahdziú', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tahmek' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tahmek', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teabo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teabo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tecoh' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tecoh', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tekal de Venegas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tekal de Venegas', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tekantó' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tekantó', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tekax' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tekax', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tekit' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tekit', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tekom' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tekom', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Telchac Pueblo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Telchac Pueblo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Telchac Puerto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Telchac Puerto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temax' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temax', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Temozón' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Temozón', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepakán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepakán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tetiz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tetiz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ticul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ticul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Timucuy' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Timucuy', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tinum' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tinum', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tixcacalcupul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tixcacalcupul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tixkokob' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tixkokob', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tixméhuac' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tixméhuac', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tixpéhual' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tixpéhual', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tizimín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tizimín', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tunkás' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tunkás', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tzucacab' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tzucacab', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Uayma' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Uayma', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ucú' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ucú', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Umán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Umán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valladolid' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valladolid', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Xocchel' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Xocchel', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yaxcabá' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yaxcabá', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yaxkukul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yaxkukul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Yobaín' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Yobaín', @idEstado, 0, GETDATE());

-- ---------- Zacatecas (58 municipios) ----------
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Zacatecas' AND id_CATALOGO_PAIS = @idPais)
    INSERT INTO citas.CATALOGO_ESTADOS (nombre, id_CATALOGO_PAIS, id_usuario_creacion, fecha_creacion)
    VALUES (N'Zacatecas', @idPais, 0, GETDATE());
SET @idEstado = (SELECT id_CATALOGO_ESTADOS FROM citas.CATALOGO_ESTADOS WHERE nombre = N'Zacatecas' AND id_CATALOGO_PAIS = @idPais);
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apozol' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apozol', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Apulco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Apulco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Atolinga' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Atolinga', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Benito Juárez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Benito Juárez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Calera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Calera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cañitas de Felipe Pescador' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cañitas de Felipe Pescador', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Chalchihuites' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Chalchihuites', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Concepción del Oro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Concepción del Oro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Cuauhtémoc' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Cuauhtémoc', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Plateado de Joaquín Amaro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Plateado de Joaquín Amaro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'El Salvador' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'El Salvador', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Fresnillo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Fresnillo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Genaro Codina' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Genaro Codina', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Enrique Estrada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Enrique Estrada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Francisco R. Murguía' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Francisco R. Murguía', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'General Pánfilo Natera' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'General Pánfilo Natera', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Guadalupe' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Guadalupe', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Huanusco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Huanusco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jalpa' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jalpa', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jerez' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jerez', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Jiménez del Teul' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Jiménez del Teul', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juan Aldama' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juan Aldama', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Juchipila' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Juchipila', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Loreto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Loreto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Luis Moya' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Luis Moya', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mazapil' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mazapil', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Melchor Ocampo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Melchor Ocampo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Mezquital del Oro' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Mezquital del Oro', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Miguel Auza' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Miguel Auza', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Momax' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Momax', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Monte Escobedo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Monte Escobedo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Morelos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Morelos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Moyahua de Estrada' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Moyahua de Estrada', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Nochistlán de Mejía' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Nochistlán de Mejía', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Noria de Ángeles' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Noria de Ángeles', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Ojocaliente' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Ojocaliente', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pinos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pinos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Pánuco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Pánuco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Río Grande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Río Grande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sain Alto' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sain Alto', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Santa María de la Paz' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Santa María de la Paz', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Sombrerete' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Sombrerete', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Susticacán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Susticacán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tabasco' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tabasco', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepechitlán' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepechitlán', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tepetongo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tepetongo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Teúl de González Ortega' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Teúl de González Ortega', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Tlaltenango de Sánchez Román' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Tlaltenango de Sánchez Román', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Trancoso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Trancoso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Trinidad García de la Cadena' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Trinidad García de la Cadena', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Valparaíso' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Valparaíso', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Vetagrande' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Vetagrande', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa García' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa García', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa González Ortega' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa González Ortega', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa Hidalgo' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa Hidalgo', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villa de Cos' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villa de Cos', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Villanueva' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Villanueva', @idEstado, 0, GETDATE());
IF NOT EXISTS (SELECT 1 FROM citas.CATALOGO_MUNICIPIO WHERE nombre = N'Zacatecas' AND id_CATALOGO_ESTADOS = @idEstado)
    INSERT INTO citas.CATALOGO_MUNICIPIO (nombre, id_CATALOGO_ESTADOS, id_usuario_creacion, fecha_creacion) VALUES (N'Zacatecas', @idEstado, 0, GETDATE());

