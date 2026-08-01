/* =====================================================================
   FIX del error:
     Msg 547 ... conflicted with the FOREIGN KEY constraint
     "FK_id_MEDICO_USUARIOS_id_USUARIOS_CITA"

   Causa: quedaron citas cuyo id_MEDICO NO existe en citas.USUARIOS
          (el mapeo por nombre_completo no encontro usuario medico).

   Este script:
     A) Diagnostica que citas quedaron huerfanas.
     B) (Opcional) Crea automaticamente el USUARIO con perfil medico a
        partir del catalogo citas.MEDICO y lo asigna a su clinica.
     C) Reasigna los id_MEDICO pendientes y crea la FK con validacion.
   Ejecutar por bloques, revisando la salida de cada uno.
   ===================================================================== */
USE CitasMedicas;
GO
SET XACT_ABORT ON;
GO

/* ---------------------------------------------------------------------
   A) DIAGNOSTICO: citas cuyo id_MEDICO no existe en USUARIOS
   --------------------------------------------------------------------- */
SELECT ci.id_CITA, ci.id_MEDICO,
       m.nombre_completo AS medico_catalogo, m.id_CLINICA
  FROM citas.CITA ci
  LEFT JOIN citas.MEDICO m ON m.id_MEDICO = ci.id_MEDICO
 WHERE NOT EXISTS (SELECT 1 FROM citas.USUARIOS u WHERE u.id_USUARIOS = ci.id_MEDICO)
 ORDER BY ci.id_CITA;
GO
/* Si no devuelve filas, salta al bloque C. */

/* ---------------------------------------------------------------------
   B) CREAR usuarios medico faltantes a partir del catalogo MEDICO
      (usuario = medico<id>, password temporal = Temporal01$)
      Ajusta el rol si el nombre de tu rol medico es distinto.
   --------------------------------------------------------------------- */
DECLARE @id_ROL_MEDICO INT =
    (SELECT TOP 1 id_ROLES FROM citas.ROLES WHERE LOWER(nombre) LIKE '%medico%' ORDER BY id_ROLES);

IF @id_ROL_MEDICO IS NULL
    THROW 50001, 'No existe un rol con nombre similar a "medico" en citas.ROLES.', 1;

DECLARE @id_MEDICO INT, @nombre NVARCHAR(200), @id_CLINICA INT, @nuevo INT;

DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT DISTINCT m.id_MEDICO, m.nombre_completo, m.id_CLINICA
      FROM citas.CITA ci
      JOIN citas.MEDICO m ON m.id_MEDICO = ci.id_MEDICO
     WHERE NOT EXISTS (SELECT 1 FROM citas.USUARIOS u WHERE u.id_USUARIOS = ci.id_MEDICO)
       AND NOT EXISTS (
             SELECT 1
               FROM citas.USUARIOS u
               JOIN citas.ROLES r            ON r.id_ROLES     = u.id_ROLES
               JOIN citas.USUARIOS_CLINICA uc ON uc.id_USUARIOS = u.id_USUARIOS
              WHERE LOWER(r.nombre) LIKE '%medico%'
                AND uc.id_CLINICA = m.id_CLINICA
                AND LTRIM(RTRIM(u.nombre_completo)) = LTRIM(RTRIM(m.nombre_completo)));

OPEN cur;
FETCH NEXT FROM cur INTO @id_MEDICO, @nombre, @id_CLINICA;
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC citas.spAltaUsuario
         @id_ROLES        = @id_ROL_MEDICO,
         @usuario         = NULL,   -- se sustituye abajo
         @password        = 'Temporal01$',
         @nombre_completo = @nombre,
         @email           = NULL,
         @id_usuario      = 0,
         @id_USUARIOS_OUT = @nuevo OUTPUT;

    EXEC citas.spAltaUsuarioClinica
         @id_USUARIOS = @nuevo,
         @id_CLINICA  = @id_CLINICA,
         @id_usuario  = 0;

    FETCH NEXT FROM cur INTO @id_MEDICO, @nombre, @id_CLINICA;
END
CLOSE cur; DEALLOCATE cur;
GO
/* NOTA: si tu spAltaUsuario exige @usuario no nulo o firma distinta,
   crea los usuarios manualmente desde la aplicacion (Administracion de
   clinica -> Usuarios) y vuelve al bloque C. */

/* ---------------------------------------------------------------------
   C) REASIGNAR ids y crear la FK (aborta si quedan huerfanas)
   --------------------------------------------------------------------- */
IF OBJECT_ID('tempdb..#map') IS NOT NULL DROP TABLE #map;
SELECT m.id_MEDICO, MIN(u.id_USUARIOS) AS id_USUARIOS
  INTO #map
  FROM citas.MEDICO m
  JOIN citas.USUARIOS_CLINICA uc ON uc.id_CLINICA  = m.id_CLINICA
  JOIN citas.USUARIOS u          ON u.id_USUARIOS  = uc.id_USUARIOS
  JOIN citas.ROLES    r          ON r.id_ROLES     = u.id_ROLES
 WHERE LOWER(r.nombre) LIKE '%medico%'
   AND LTRIM(RTRIM(u.nombre_completo)) = LTRIM(RTRIM(m.nombre_completo))
 GROUP BY m.id_MEDICO;

BEGIN TRAN;

    /* Solo se convierten las citas que aun apuntan al catalogo MEDICO. */
    UPDATE ci
       SET ci.id_MEDICO = mp.id_USUARIOS
      FROM citas.CITA ci
      JOIN #map mp ON mp.id_MEDICO = ci.id_MEDICO
     WHERE NOT EXISTS (SELECT 1 FROM citas.USUARIOS u WHERE u.id_USUARIOS = ci.id_MEDICO);

    IF EXISTS (SELECT 1 FROM citas.CITA ci
                WHERE NOT EXISTS (SELECT 1 FROM citas.USUARIOS u
                                   WHERE u.id_USUARIOS = ci.id_MEDICO))
    BEGIN
        ROLLBACK;
        THROW 50002, 'Aun hay citas sin usuario medico equivalente. Ejecuta el bloque A y resuelvelas antes de crear la FK.', 1;
    END

    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys
                    WHERE name = 'FK_id_MEDICO_USUARIOS_id_USUARIOS_CITA')
        ALTER TABLE citas.CITA WITH CHECK
            ADD CONSTRAINT FK_id_MEDICO_USUARIOS_id_USUARIOS_CITA
            FOREIGN KEY (id_MEDICO) REFERENCES citas.USUARIOS(id_USUARIOS);

    INSERT INTO citas.LOG
    VALUES('CITA','patch_fix_cita_medico_usuario','CITA',
           'FK CITA.id_MEDICO -> USUARIOS creada tras reparar huerfanas',GETDATE(),0);
COMMIT;
GO
