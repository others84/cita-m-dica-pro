-- El correo del paciente es opcional: se permite cadena vacia.
USE CitasMedicas;
GO
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CHK_email_PACIENTE')
    ALTER TABLE citas.PACIENTE DROP CONSTRAINT CHK_email_PACIENTE;
GO
-- Normaliza valores nulos previos (la columna es NOT NULL, pero por seguridad).
UPDATE citas.PACIENTE SET email = '' WHERE email IS NULL;
GO
ALTER TABLE citas.PACIENTE
    ADD CONSTRAINT CHK_email_PACIENTE CHECK (email = '' OR email LIKE '%_@_%._%');
GO
