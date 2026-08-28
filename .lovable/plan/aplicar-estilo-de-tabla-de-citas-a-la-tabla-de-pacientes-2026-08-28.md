# Aplicar estilo de tabla de citas a la tabla de pacientes

## Objetivo
Que la tabla de **Pacientes** use el mismo comportamiento responsive, paginación (15 elementos por página) y apilado de botones de acciones que ya tiene la tabla de **Citas**.

## Cambios propuestos

### 1. Controlador: `php-app/app/controllers/PacientesController.php`
- En `index()`:
  - Mantener la carga de pacientes filtrados por clínica.
  - Agregar paginación de 15 elementos por página, leyendo la página actual desde el estado de sesión (`$_SESSION['ui']['pacientes']['pag']`).
  - Calcular `pag`, `paginas`, `totalPacientes` y `porPagina`.
  - Pasar esas variables a la vista.
- Agregar método `pagina()` para cambiar de página vía POST (igual que en `CitasController`).

### 2. Vista: `php-app/app/views/pacientes/index.php`
- Envolver la tabla `<table class="data">` dentro de `<div class="table-responsive">`.
- Cambiar la clase de la tabla a `data tabla-pacientes`.
- En la columna **Acciones**, apilar los botones para que cada uno ocupe una línea (usar `flex-wrap` con cada botón en línea propia, igual que en citas).
- Reemplazar el formulario de eliminación inline por `post_button('pacientes/eliminar', ...)` con confirmación, para que todos los botones de acciones compartan el mismo estilo apilado.
- Debajo de la tabla agregar el paginador idéntico al de citas: información "Página X de Y · N pacientes", botones « ‹ números › ».

### 3. Estilos: `php-app/public/assets/css/style.css`
- Agregar reglas para `table.tabla-pacientes` equivalentes a `table.tabla-citas`:
  - `min-width: 0; table-layout: auto`
  - `white-space: normal; overflow-wrap: normal; word-break: normal; hyphens: none` en celdas generales.
  - Permitir romper palabras largas sin espacios solo en la columna de observaciones.
  - Mantener en una sola línea las columnas cortas (teléfono, fecha de nacimiento, género, país, estado, municipio).
  - `.acts { flex-wrap: wrap; gap: .3rem }` y que cada botón ocupe una línea (`width: 100%` o `display: block`).
- Ajustar padding en pantallas medianas (`@media (max-width:1200px)`).

## Resultado esperado
- La tabla de pacientes se ajusta al ancho disponible y solo usa scroll horizontal como último recurso.
- El texto largo (nombre, dirección, email, observaciones) baja de línea entre palabras sin cortar letras.
- Los botones de **Acciones** se apilan verticalmente, uno por línea.
- Se muestran 15 pacientes por página con paginador funcional.
- El paginador queda fuera del contenedor con scroll, igual que en citas.

## Archivos a modificar
1. `php-app/app/controllers/PacientesController.php`
2. `php-app/app/views/pacientes/index.php`
3. `php-app/public/assets/css/style.css`

No se requieren cambios en base de datos ni en stored procedures.