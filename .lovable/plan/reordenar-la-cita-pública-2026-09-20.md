# Reordenar la cita pública

## Objetivo
Cambiar el flujo público a cinco pasos:

1. **Elige médico y clínica**: mostrar todos los médicos activos. Al elegir uno, mostrar únicamente las clínicas activas donde atiende; si solo tiene una, seleccionarla automáticamente.
2. **Identifícate**: mostrar el panel de celular con dos opciones claras: **Soy paciente nuevo** y **Buscar mis datos**.
3. **Elige el día y la hora**: conservar el calendario actual del médico y la clínica elegidos.
4. **Tus datos**: conservar el formulario actual, oculto hasta seleccionar una hora.
5. **Revisa y confirma**: conservar el resumen y el botón **Confirmar mi cita**.

También se eliminará el enlace **Agendar cita** que actualmente solo reinicia el formulario. El botón final **Confirmar mi cita** se mantiene porque es el que registra la cita.

## Comportamiento del nuevo flujo

- La página abrirá mostrando la lista global de médicos activos.
- Al seleccionar un médico, se validará en el servidor y se cargarán solo sus clínicas activas.
- Si el médico atiende en varias clínicas, el paciente elegirá una; si atiende en una sola, quedará seleccionada automáticamente.
- El paso 2 aparecerá cuando médico y clínica estén definidos.
- **Soy paciente nuevo** continuará directamente al calendario sin exigir celular en ese momento; el celular se capturará después en “Tus datos”.
- **Buscar mis datos** buscará el celular únicamente dentro de la clínica elegida. Si existe, conservará la verificación por correo o WhatsApp antes de mostrar información personal. Si no existe en esa clínica, continuará como paciente nuevo.
- Elegir “Soy paciente nuevo”, buscar el celular o completar la verificación no borrará el médico ni la clínica elegidos.
- Si cambia el médico o la clínica, se limpiarán paciente, horario y datos dependientes para evitar combinar información de selecciones anteriores.
- Las validaciones actuales de pertenencia médico–clínica, horarios, días bloqueados, traslapes, consultorio/especialidad GENERICO y usuario GENERICO permanecerán activas.

## Cambios técnicos

1. **`php-app/app/controllers/CitapublicaController.php`**
   - Cargar médicos activos sin exigir una clínica previa y obtener las clínicas asignadas al médico seleccionado.
   - Incorporar la selección segura de médico antes de la clínica y auto-seleccionar una clínica única.
   - Reordenar el estado de sesión para conservar médico/clínica durante búsqueda, alta nueva y OTP.
   - Limitar las coincidencias del teléfono a la clínica ya elegida.
   - Actualizar los mensajes de validación para la nueva numeración de pasos.

2. **`php-app/app/views/citapublica/index.php`**
   - Convertir la selección de médico y clínica en el paso 1.
   - Convertir la identificación por celular en el paso 2 con los botones **Soy paciente nuevo** y **Buscar mis datos**.
   - Eliminar el enlace **Agendar cita**.
   - Mantener calendario, datos y confirmación como pasos 3, 4 y 5, incluyendo el ocultamiento de los pasos 4 y 5 hasta elegir hora.

No se requieren cambios en la base de datos ni en los procedimientos almacenados.

## Validación

- Probar médicos con una y con varias clínicas.
- Confirmar que solo aparezcan clínicas asociadas al médico elegido.
- Probar paciente nuevo sin escribir celular en el paso 2.
- Probar paciente existente, OTP válido/incorrecto/vencido y paciente no registrado en la clínica elegida.
- Confirmar que cambiar médico o clínica limpie selecciones incompatibles.
- Confirmar que el calendario, los días bloqueados y la creación final de la cita sigan funcionando.
