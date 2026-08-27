# Separar observaciones del paciente y de la cita

## Problema detectado

1. En la cita pública, lo que el paciente escribe en "Observaciones - motivo de la consulta" se guarda **dos veces**: como observaciones del paciente y, tal cual, como observaciones de la cita (`CitapublicaController`, alta de cita usa `$p['observaciones']`). Por eso parece que se "copia" el texto de un campo al otro.
2. En la pantalla de Citas, al recargar el formulario de edición el texto de observaciones del paciente se re-escribe desde el catálogo de pacientes, sobre-escribiendo lo capturado; el campo de observaciones de la cita se mantiene separado, pero la confusión visual viene del punto 1.

## Cambios

### 1. Cita pública: observaciones independientes
- Las observaciones del **paciente** siguen guardándose en el expediente del paciente (sin cambios).
- Las observaciones de la **cita** se arman así:
  - Siempre inician con el texto fijo: `Cita generada desde la pagina publica`
  - Si el paciente escribió un motivo, se agrega **después** de ese texto, en la línea siguiente.
  - Si no escribió nada, la cita queda solo con el texto fijo.

Ejemplo guardado en la cita:

```text
Cita generada desde la pagina publica
Me duele la rodilla desde hace una semana.
```

### 2. Pantalla de Citas: no mezclar campos
- Al abrir una cita existente para editar/atender, el campo "Observaciones paciente" solo se rellena desde el catálogo cuando el usuario **cambia** de paciente o cuando es una cita nueva; ya no se sobrescribe con el valor del catálogo al cargar una cita guardada.
- El campo "Observaciones" (de la cita) nunca recibe el texto del paciente.

## Archivos a modificar (por prioridad)

1. `php-app/app/controllers/CitapublicaController.php` — construir las observaciones de la cita con el prefijo fijo + el motivo escrito por el paciente, sin reutilizar el campo del paciente.
2. `php-app/app/views/citas/form.php` — ajustar el script para no re-copiar las observaciones del paciente al cargar una cita ya guardada.
