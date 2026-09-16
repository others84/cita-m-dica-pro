# Plan: Cita pública — ocultar pasos 4-5 hasta elegir hora y correo opcional

## Objetivo
En la página pública "Generar cita":
1. Los pasos **4 (Tus datos)** y **5 (Revisa y confirma)** deben permanecer ocultos hasta que el usuario seleccione un día y hora en el calendario del **paso 3**. Una vez seleccionada la hora, se muestran y se desplaza hasta ellos.
2. El campo **correo electrónico** pasa a ser **opcional**, igual que en la pantalla de Pacientes (se valida el formato solo si se escribe algo; si queda vacío, no se exige y se desactiva la notificación por correo).

## Cambios

### 1. `php-app/app/views/citapublica/index.php` (vista)

- Envolver las dos secciones del **paso 4** y **paso 5** dentro de un contenedor:
  ```html
  <div id="pasos-restantes" hidden>
    ... sección paso 4 (Tus datos) ...
    ... sección paso 5 (Revisa y confirma) ...
  </div>
  ```
  Quedan dentro del `<form id="form-cita">` existente; el calendario (paso 3) y los campos ocultos (`id_MEDICO`, etc.) permanecen fuera del contenedor y visibles.

- En la función JS `tomar(start)` (la que se llama al tocar el calendario), después de validar con `permitido(s)` y de asignar la fecha/hora, **mostrar** el contenedor y hacer scroll hacia él:
  ```js
  var restantes = document.getElementById('pasos-restantes');
  if (restantes) { restantes.hidden = false; }
  ```
  (manteniendo el `scrollIntoView` existente hacia `#resumen-cita`).

- Al cargar la página: si ya hay fecha y hora precargadas (por ejemplo tras un error de validación), mostrar el contenedor y reconstruir el resumen. Esto se logra con la lógica existente del IIFE que ya llama a `calc()` y `resumen()` al final; se añade ahí la muestra del contenedor cuando `f_fecha` y `f_hi` tienen valor.

- **Correo opcional**: en el input de Email del paso 4:
  - Cambiar etiqueta a `Email (opcional)`.
  - Quitar el atributo `required`.
  - Ajustar el texto de ayuda a: "Tu correo, como nombre@correo.com. Si no tienes, puedes dejarlo en blanco."

- Pre-poblar fecha/hora desde sesión para no perder la selección tras un error de validación:
  - `f_fecha`: añadir `value="<?= htmlspecialchars($fechaCita ?? '') ?>"`.
  - `f_hi`: añadir `value="<?= htmlspecialchars($horaInicio ?? '') ?>"`.

### 2. `php-app/app/controllers/CitapublicaController.php` (controlador)

- En `index()`, pasar al render dos valores nuevos leídos de sesión:
  ```php
  'fechaCita' => (string)$this->get('fecha_cita', ''),
  'horaInicio'=> (string)$this->get('hora_inicio', ''),
  ```

- En `agendar()`, guardar la fecha/hora elegidas en sesión justo después de parsearlas (antes de las validaciones), para que se conserven si hay error:
  ```php
  $this->set('fecha_cita', $fecha);
  $this->set('hora_inicio', $hi);
  ```
  En el flujo de éxito ya se llama a `$this->reset()`, que limpia estos valores.

- **Correo opcional**: cambiar la validación del bloque de "paciente nuevo":
  - Antes (línea ~580):
    ```php
    if (!filter_var($p['email'], FILTER_VALIDATE_EMAIL)) $err[] = 'Revisa tu correo. Debe ser como: nombre@correo.com';
    ```
  - Ahora:
    ```php
    if (trim($p['email']) !== '' && !filter_var($p['email'], FILTER_VALIDATE_EMAIL)) {
        $err[] = 'Revisa tu correo. Debe ser como: nombre@correo.com';
    }
    if (trim($p['email']) === '') {
        $p['notifica_email'] = 0; // sin correo no se puede notificar
    }
    ```

## Notas
- `PacienteModel::alta` ya acepta correo vacío (cadena `''`) gracias al cambio previo que hizo opcional el email en la tabla `PACIENTE` (restricción `CHK_email_PACIENTE` y parche `2026-09-15_paciente_email_opcional.sql`). No se requieren cambios de base de datos.
- El paso 3 (calendario) y los campos ocultos del formulario permanecen siempre visibles; solo se ocultan los pasos 4 y 5.
- No se cambia el flujo de paciente existente (verificado): sus datos siguen cargándose igual; simplemente el bloque donde se muestran queda oculto hasta elegir hora.

## Archivos a modificar (por prioridad)
1. `php-app/app/views/citapublica/index.php` — contenedor oculto, lógica JS al seleccionar hora, correo opcional, pre-poblado de fecha/hora.
2. `php-app/app/controllers/CitapublicaController.php` — guardar fecha/hora en sesión, pasarlas al render, validar correo opcional.

## Validación
- Revisar sintaxis PHP en el servidor (este entorno no tiene PHP instalado).
- Probar: abrir cita pública, elegir clínica y médico; confirmar que los pasos 4 y 5 no aparecen hasta tocar una hora válida en el calendario; al elegirla, aparecen y se hace scroll.
- Probar: dejar el correo vacío y completar el resto; la cita debe registrarse sin error. Escribir un correo mal formado; debe mostrar el aviso de formato.
- Probar: forzar un error de validación (ej. faltar un dato) y confirmar que la hora elegida se conserva y los pasos 4-5 siguen visibles.
