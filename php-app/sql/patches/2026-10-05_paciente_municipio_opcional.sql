-- El municipio del paciente es opcional: se permite NULL.
-- Estado y municipio pueden capturarse despues editando al paciente.
USE CitasMedicas;
GO

-- 1) La columna acepta NULL (la FK se mantiene: NULL no la viola).
ALTER TABLE citas.PACIENTE ALTER COLUMN id_CATALOGO_MUNICIPIO INT NULL;
GO

-- 2) El listado de pacientes debe seguir mostrando al paciente aunque no
--    tenga municipio: LEFT JOIN a municipio/estado y pais "Mexico" por defecto.
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
           e.id_CATALOGO_PAIS, COALESCE(pa.nombre, 'Mexico') AS pais
      FROM citas.PACIENTE p
      JOIN citas.CLINICA           c  ON c.id_CLINICA            = p.id_CLINICA
      JOIN citas.CATALOGO_GENERO   g  ON g.id_CATALOGO_GENERO    = p.id_CATALOGO_GENERO
      LEFT JOIN citas.CATALOGO_MUNICIPIO m ON m.id_CATALOGO_MUNICIPIO = p.id_CATALOGO_MUNICIPIO
      LEFT JOIN citas.CATALOGO_ESTADOS  e  ON e.id_CATALOGO_ESTADOS   = m.id_CATALOGO_ESTADOS
      LEFT JOIN citas.CATALOGO_PAIS     pa ON pa.id_CATALOGO_PAIS     = e.id_CATALOGO_PAIS
     WHERE (@id_CLINICA IS NULL OR p.id_CLINICA = @id_CLINICA)
     ORDER BY p.ap_paterno, p.ap_materno, p.nombre;
END
GO
