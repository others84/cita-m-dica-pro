# Página pública "Generar cita"

Nueva página accesible sin iniciar sesión desde un botón **Generar cita** en la pantalla de login. Permite a un paciente (nuevo o existente) agendar su cita viendo el calendario del médico.

## Flujo del usuario

```text
[Login] --boton "Generar cita"--> [/cita-publica]

1) ¿Ya eres paciente?  -> captura celular (campo llave)
   ├─ Encontrado en 1 clínica  -> se fija esa clínica y se llenan sus datos
   ├─ Encontrado en varias      -> elige clínica -> se llenan sus datos
   └─ No encontrado             -> elige clínica -> captura datos de paciente nuevo

2) Panel CLÍNICA (habilitado tras el paso 1)
   - Clínica (fija según paso 1)
   - Médicos de la clínica
   - Consultorios de la clínica
   - Especialidades de la clínica
   - Calendario del médico seleccionado (solo citas agendadas de ese médico/clínica)

3) Panel PACIENTE
   - Mismos campos del alta de paciente del sistema
     (ap. paterno, ap. materno, nombre, dirección, teléfono, email,
      fecha de nacimiento, género, país/estado/municipio, observaciones,
      notificar por email / WhatsApp)

4) Botón AGENDAR
   - Fecha/hora: clic en un hueco del calendario rellena los campos,
     y también se pueden editar manualmente.
   - Estado: Agendada. Precio: 0. Anticipación de notificación: 24 h.
   - La cita nueva aparece de inmediato en el calendario.
```

## Usuario GENERICO

Todas las altas (paciente y cita) se registran con el usuario **GENERICO** (rol asistente) que dará de alta el cliente. El sistema lo busca en la base por nombre de usuario y valida que esté asignado a la clínica elegida.

Si no existe o no pertenece a esa clínica: no se guarda nada, se muestra un error claro en pantalla y el error se registra en `app.log` y en la tabla `LOG`.

## Reglas y seguridad

- La página es pública: sin sesión, sin datos de otras clínicas y sin listados de pacientes.
- Búsqueda por celular: solo devuelve datos si hay coincidencia exacta del teléfono; nunca lista pacientes.
- Formularios por POST con token CSRF; validación de todos los campos en servidor (obligatorios, formato de email, fecha, longitudes).
- El calendario público solo muestra bloques ocupados (paciente anónimo: "Ocupado"), sin nombres ni datos sensibles.
- Se valida que médico, consultorio y especialidad pertenezcan a la clínica seleccionada antes de guardar.
- Se valida traslape de horario con las citas agendadas del médico.

## Detalles técnicos

Archivos a crear / modificar (por prioridad):

1. `php-app/app/controllers/CitaPublicaController.php` (nuevo) — acciones `index`, `buscar` (por celular), `seleccionarClinica`, `medico` (recarga calendario) y `agendar`. Sin `requireLogin()`; todo el estado en `$_SESSION['ui']['citapublica']`.
2. `php-app/app/views/citapublica/index.php` (nuevo) — vista de página completa (no usa el layout con menú): paneles Clínica, Calendario y Paciente, con el mismo componente event-calendar ya usado en el sistema y selección de hueco horario.
3. `php-app/app/models/UsuarioModel.php` — método para obtener el usuario `GENERICO` (id y clínicas asignadas).
4. `php-app/app/models/PacienteModel.php` — búsqueda de paciente por teléfono (devuelve coincidencias con su clínica) y alta con id de usuario explícito.
5. `php-app/app/models/CitaModel.php` — alta de cita con id de usuario explícito (GENERICO) en lugar del de sesión.
6. `php-app/app/models/LogModel.php` — registro del evento `ALTA CITA PUBLICA` y de los errores de usuario GENERICO.
7. `php-app/app/views/auth/login.php` — botón "Generar cita" que abre la nueva página.
8. `php-app/public/assets/css/style.css` — estilos de los paneles de la página pública (respetando los temas actuales).
9. `php-app/sql/patches/2026-08-18_cita_publica.sql` (nuevo) — SP de búsqueda de paciente por teléfono y permisos `GRANT EXECUTE` correspondientes.
