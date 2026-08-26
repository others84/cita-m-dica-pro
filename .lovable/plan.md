# Ajuste responsive de la tabla de citas

## Objetivo
Hacer que la tabla de **Citas registradas** en la pantalla `citas` se adapte al ancho de la ventana: cuando el contenido no quepa, debe aparecer un scroll horizontal sin cortar columnas ni romper el layout.

## Cambios propuestos

### 1. Vista: `php-app/app/views/citas/index.php`
- Envolver la tabla `<table class="data<?= $ordClass ?>">` (y su `</table>`) en un contenedor `<div class="table-responsive">`.
- El paginador que está debajo de la tabla queda fuera del contenedor, para que no se desplace horizontalmente junto con la tabla.

### 2. Estilos: `php-app/public/assets/css/style.css`
- Agregar la clase `.table-responsive` con:
  - `overflow-x: auto`
  - `-webkit-overflow-scrolling: touch`
  - `min-width: 0`
  - `max-width: 100%`
  - `border: 1px solid var(--c2)` (para mantener el borde visual de la tabla)
  - `border-radius: 8px`
- Mover el `border` y `border-radius` actual de `table.data` al contenedor, o dejar que la tabla los conserve internamente; la prioridad es que el scroll horizontal sea visible y no se corten las columnas.
- Revisar `table.data { min-width: 640px }` para que la tabla mantenga su ancho mínimo y fuerce el scroll cuando el viewport sea menor.

## Resultado esperado
- En pantallas grandes la tabla se ve completa.
- En pantallas medianas/pequeñas (tablets, celulares, ventanas reducidas) la tabla conserva todas sus columnas y el usuario puede desplazarse horizontalmente dentro del contenedor para verlas.
- El resto de la página (filtros, paginador) no se desborda.

## Archivos a modificar
1. `php-app/app/views/citas/index.php`
2. `php-app/public/assets/css/style.css`

No se requieren cambios en base de datos ni en lógica de backend.
