# Plan: Fecha de nacimiento con máscara manual en Pacientes

## Objetivo
En la vista **Pacientes** (roles Asistente y Médico), al dar de alta un paciente el campo de fecha de nacimiento debe:
- Estar **vacío** (no mostrar la fecha de hoy ni calendario).
- Permitir **escritura a mano** con máscara `DD/MM/AAAA`.
- Que el cursor quede al **inicio, en el campo día**, al enfocar.

Se elimina el `<input type="date">` nativo (su popup abre por defecto en la fecha de hoy).

## Alcance
- Roles afectados: `asistente` y `medico` (ambos usan la misma vista `pacientes/index.php`).
- Solo es cambio de frontend. **No** se modifica controlador, modelo, SP ni base de datos: el servidor seguirá recibiendo la fecha en formato `YYYY-MM-DD` (igual que hoy).

## Archivos a modificar (por prioridad)
1. `php-app/app/views/pacientes/index.php`
2. `php-app/public/assets/css/style.css` (solo ajuste menor opcional de estilo, si hace falta)

## Cambios en `pacientes/index.php`
### 1. Reemplazo del campo de fecha
Sustituir el `<input type="date">` actual por:

- Un `<input type="text">` visible con:
  - `inputmode="numeric"`, `maxlength="10"`, `placeholder="DD/MM/AAAA"`
  - `pattern="\d{2}/\d{2}/\d{4}"`, `autocomplete="off"`
  - `name="fecha_nacimiento_display"` (nombre distinto para que el servidor lo ignore).
- Un `<input type="hidden" name="fecha_nacimiento">` que llevará el valor ISO `YYYY-MM-DD` que lee el controlador.

### 2. Valor inicial
- Alta (sin `$editRow`): visible vacío, hidden vacío.
- Edición: el view ya calcula `$fn` en `YYYY-MM-DD`. Se convierte a `DD/MM/AAAA` para precargar el campo visible y se deja el hidden con el ISO original.

### 3. JavaScript de máscara y conversión (vanilla, sin librerías externas)
Bloque `<script>` que:
- **Restringe** a dígitos, inserta `/` automáticamente tras 2 y 4 caracteres, y limita a `DD/MM/AAAA`.
- **Valida** rangos básicos: día `01-31`, mes `01-12`, año `1900`–año actual. Si no es válida y completa, deja el hidden vacío para que el controlador dispare el mensaje "Faltan datos obligatorios: fecha de nacimiento".
- **Cursor al inicio**: al `focus`, si el campo está vacío, fuerza `setSelectionRange(0,0)` para que el cursor quede en el día.
- **Al enviar el formulario**: si la máscara está completa y válida, rellena el hidden con `AAAA-MM-DD`; si no, lo deja vacío.

### 4. Ajuste de validación existente
La validación del controlador (`if ($fnac === '') ...`) se mantiene intacta: el hidden vacío cuando la fecha esté incompleta disparará el mismo mensaje de hoy. No se requiere lógica nueva en el servidor.

## Cambios en `style.css`
- Solo si el `<input type="text">` heredara reglas distintas al `<input type="date">`. Las reglas `.form-grid input` ya deberían aplicarlo igual; si fuese necesario, se añade una regla puntual para mantener el mismo tamaño/alineación. Se evita tocar la paleta o tokens.

## Verificación (a cargo del usuario, en su servidor)
1. Subir el archivo modificado a `php-app/app/views/pacientes/index.php` (y `style.css` si se tocó).
2. Como Asistente o Médico, abrir **Pacientes → Nuevo paciente**:
   - El campo aparece vacío, sin calendario, con placeholder `DD/MM/AAAA`.
   - Al hacer clic, el cursor queda al inicio (campo día).
   - Escribir `05031990` → se forma `05/03/1990`; al Guardar se registra el paciente con `1990-03-05`.
   - Dejarlo vacío o incompleto y Guardar → muestra "Faltan datos obligatorios: fecha de nacimiento".
3. Editar un paciente existente: el campo muestra su fecha en `DD/MM/AAAA` y se conserva al guardar.
4. Verificar sintaxis con `php -l` ya quedó validado en el agente; el usuario confirma en su servidor.

## Notas técnicas
- No se añaden dependencias JS (entorno de producción Ubuntu/Apache sin CDN garantizado).
- Se conserva el contrato ISO con el SP `spAltaPaciente`/`spCambioPaciente`; el cambio es 100% de presentación.
