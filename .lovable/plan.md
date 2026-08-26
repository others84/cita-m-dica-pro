# Tabla de citas: primero ajustar, y solo al final hacer scroll

## Objetivo
Que la tabla de "Citas registradas" aproveche el ancho disponible partiendo el texto en varias líneas, y que el scroll horizontal aparezca únicamente cuando ya no haya forma de acomodar las columnas. Los botones de la columna Acciones nunca se parten: cada botón ocupa una sola línea.

## Cambios propuestos

### 1. `php-app/public/assets/css/style.css` (prioridad 1)
- Quitar el `white-space:nowrap` general de `table.data th, table.data td` en la tabla de citas: el texto de Paciente, Médico, Especialidad, Consultorio y Observaciones podrá bajar a la siguiente línea.
- Reemplazar `table.data{min-width:max-content}` por un `min-width` mucho menor (solo el ancho realmente indispensable) en la tabla de citas, para que el contenedor no genere scroll de inmediato.
- Añadir reglas de ajuste de texto en esas celdas: `overflow-wrap:anywhere` / `word-break:break-word` y `line-height` cómoda, para evitar palabras largas (correos, nombres compuestos) que fuercen el desbordamiento.
- Reducir el padding horizontal de las celdas en pantallas angostas, para ganar ancho antes de recurrir al scroll.
- Columna Acciones (`.acts`): mantener `display:flex` con `flex-wrap:wrap` para que los botones se acomoden en varios renglones, pero cada botón con `white-space:nowrap` para que su texto ("WhatsApp", "No asistió", "Hora fin") jamás se parta en dos líneas.
- Columnas cortas (Fecha, Hora, Estado, Precio, Notificado) siguen con `white-space:nowrap` para que no se vean rotas.
- El contenedor `.table-responsive` conserva `overflow-x:auto`, así que el scroll sigue disponible como último recurso.

### 2. `php-app/app/views/citas/index.php` (prioridad 2)
- Sin cambios estructurales; solo, de ser necesario, marcar con una clase las columnas "cortas" (fecha, hora, estado, precio, notificado) para aplicarles el `nowrap` de forma precisa en lugar de depender del orden de columnas.

## Resultado esperado
- En ventanas medianas la tabla se acomoda sola: los nombres largos bajan de línea y todas las columnas siguen visibles, sin scroll.
- En ventanas muy angostas (celular) aparece el scroll horizontal, pero solo cuando ya no cabe.
- Los botones de Acciones se apilan en varios renglones si hace falta, cada uno en una sola línea legible.

## Archivos a modificar
1. `php-app/public/assets/css/style.css`
2. `php-app/app/views/citas/index.php` (ajuste menor de clases)

Sin cambios en base de datos ni en la lógica del backend.
