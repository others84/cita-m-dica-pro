# Esquemas de venta y límites de usuarios por clínica

## Qué se va a lograr

Cada clínica tendrá un esquema comercial (SOLO-CONSULTORIO o SOLO-CLINICA) con límites de usuarios editables en cualquier momento desde el módulo de Administrador de Sistema. El sistema impedirá crear o asignar usuarios por encima del límite y dejará registro en la tabla LOG.

- SOLO-CONSULTORIO: 1 asistente, 1 médico, 1 administrador de clínica.
- SOLO-CLINICA: 2 asistentes, 5 médicos, 1 administrador de clínica.
- Al elegir el esquema, los tres números se precargan, pero el administrador de sistema puede ajustarlos.
- El conteo considera únicamente usuarios activos asignados a esa clínica.
- Las clínicas existentes quedan con esquema SOLO-CLINICA (2/5/1).

## Dónde se valida

Toda alta o asignación de usuario a una clínica pasa por la validación:

```text
Alta de médico (admin clínica)      -> valida cupo de médicos
Alta de asistente (admin clínica)   -> valida cupo de asistentes
Alta de usuario (admin sistema)     -> valida cupo según el rol elegido
Asignar clínica a usuario existente -> valida cupo del rol de ese usuario
Reactivar un usuario                -> valida cupo (porque vuelve a ocupar lugar)
```

Si no hay cupo, la operación se rechaza con un mensaje claro, por ejemplo:
"La clínica 'X' (esquema SOLO-CONSULTORIO) ya alcanzó el máximo de 1 médico. Ajuste los límites desde Administrador de Sistema."

## Registro en LOG

Los stored procedures escriben en `citas.LOG`:

- Alta de clínica: `ALTA CLINICA: usuario="<usuario>" clinica="<nombre>" esquema=<esquema> max_asistentes=<n> max_medicos=<n> max_admins=<n>`
- Cambio de límites: mismo formato con prefijo `CAMBIO LIMITES CLINICA` incluyendo valores anteriores y nuevos.
- Intento rechazado por límite: `LIMITE EXCEDIDO: usuario="<usuario>" clinica="<nombre>" rol=<rol> limite=<n> actuales=<n>`.

Además se escribe la misma información en `app.log`.

## Vista de clínicas (Administrador de Sistema)

En el formulario Nueva/Editar clínica se agregan: combo "Esquema" y tres campos numéricos (Máx. asistentes, Máx. médicos, Máx. administradores de clínica) que se autocompletan al cambiar el esquema y siguen siendo editables. En la tabla se muestran columnas Esquema y "Usuarios (activos/límite)" por rol.

## Detalles técnicos

1. `php-app/sql/patches/2026-09-01_clinica_esquema_limites.sql` (nuevo)
   - `ALTER TABLE citas.CLINICA` agregando `esquema VARCHAR(20) NOT NULL DEFAULT 'SOLO_CLINICA'`, `max_asistentes TINYINT NOT NULL DEFAULT 2`, `max_medicos TINYINT NOT NULL DEFAULT 5`, `max_admins TINYINT NOT NULL DEFAULT 1`, con CHECK de valores válidos de esquema.
   - `spAltaClinica` y `spCambioClinica`: nuevos parámetros y los INSERT en `citas.LOG` con el formato descrito (en cambio, comparando valores anteriores vs nuevos).
   - `spRegresaClinicas`: devuelve los nuevos campos.
   - Nuevo `spValidaCupoUsuarioClinica @id_CLINICA, @id_ROLES, @id_usuario`: cuenta usuarios activos por rol en esa clínica, y si excede el límite escribe el renglón `LIMITE EXCEDIDO` en `citas.LOG` y hace THROW.
   - `spAltaUsuarioClinica` y `spActivaUsuario` invocan la validación antes de insertar/activar.
2. `php-app/sql/schema.sql` — mismos cambios en el esquema base.
3. `php-app/app/models/ClinicaModel.php` — firmas de `alta`/`cambio` con esquema y límites; helper `cupoDisponible(idClinica, rol)` y `conteoUsuarios(idClinica)`.
4. `php-app/app/controllers/ClinicasController.php` — leer y validar los nuevos campos (números ≥ 0, esquema válido) y registrar en `app.log`.
5. `php-app/app/views/clinicas/index.php` — combo de esquema, tres campos numéricos con autollenado por JS, y columnas nuevas en la tabla.
6. `php-app/app/controllers/MedicosController.php`, `AsistentesController.php`, `CatalogosController.php` (alta de usuarios), `UsuariosClinicaController.php` — validar cupo antes de dar de alta/asignar y mostrar el mensaje de error como flash; también bloquear la reactivación sin cupo.
7. `php-app/app/models/UsuarioClinicaModel.php` / `UsuarioModel.php` — propagar el error del SP sin romper el flujo actual.

## Notas

- La validación queda tanto en PHP (mensaje amigable) como en el SP (defensa real), para que ninguna ruta la evada.
- No se desactivan usuarios existentes que ya superen un límite: el límite solo bloquea nuevas altas/asignaciones/reactivaciones.
