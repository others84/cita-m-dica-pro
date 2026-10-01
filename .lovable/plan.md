# Corregir la captura de la fecha de nacimiento en el celular (Pacientes)

## Qué pasa hoy
Al escribir la fecha en el celular, el cursor se regresa una posición y los números quedan desordenados. Ejemplo: escribes `0`, `5`, `0` y la pantalla muestra `05/0`, pero el cursor queda antes del último `0`. El siguiente número se mete en medio.

## Causa (confirmada en el código)
Cuando el sistema agrega la barra `/` de forma automática, coloca el cursor en el lugar donde estaba **antes** de que se agregara la barra. Además, solo lo adelanta en un caso que casi nunca se cumple. En la computadora casi no se nota, pero en el celular el teclado respeta esa posición y el cursor se recorre hacia atrás.

## Solución
- Colocar el cursor según **cuántos números hay antes de él**, no según los caracteres. Así las barras que se agregan solas nunca lo regresan.
- Si estás escribiendo al final (lo normal), el cursor siempre queda al final.
- Al borrar, el cursor tampoco debe quedar atorado en una barra.
- Hacer el ajuste del cursor justo después de que el teclado del celular termina de escribir, porque en Android a veces se ignora si se hace al mismo tiempo.
- Todo lo demás se queda igual: formato `DD/MM/AAAA`, validación de la fecha, campo vacío al dar de alta y la fecha que se guarda.

## Archivo a modificar
1. `php-app/app/views/pacientes/index.php`: solo cambia la parte que acomoda el cursor en la máscara de la fecha.

## Detalles técnicos
- En el listener `input`, contar los dígitos que hay a la izquierda de `selectionStart` en el valor original (`nDig`), aplicar la máscara y buscar en el valor nuevo la posición que sigue al dígito número `nDig`. Si el cursor estaba al final del texto, ponerlo en `novo.length`.
- Aplicar `setSelectionRange` dentro de `requestAnimationFrame` (o `setTimeout(...,0)`) para evitar que Chrome/Gboard en Android lo sobrescriba.
- Asignar `input.value` solo si cambió, para no interrumpir la escritura del teclado.
- Verificar con Playwright usando un viewport de celular: escribir `05031990` tecla por tecla y confirmar que queda `05/03/1990` y que el campo oculto contiene `1990-03-05`.
