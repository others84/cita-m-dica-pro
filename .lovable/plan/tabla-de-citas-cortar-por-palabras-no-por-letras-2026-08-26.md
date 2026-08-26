# Tabla de citas: cortar por palabras, no por letras

## Problema
Las celdas usan `overflow-wrap:anywhere` y `word-break:break-word`, lo que parte las palabras a la mitad (ej. "Gonzá / lez"). El texto debe bajar de línea solo entre palabras.

## Cambio propuesto

### `php-app/public/assets/css/style.css` (único archivo a modificar)
- En `table.tabla-citas th, table.tabla-citas td`: quitar `overflow-wrap:anywhere` y `word-break:break-word`; dejar `white-space:normal`, `word-break:normal`, `overflow-wrap:normal` y `hyphens:none`.
- Añadir una excepción solo para columnas con posibles cadenas larguísimas sin espacios (Observaciones y Observaciones paciente): `overflow-wrap:break-word` para que un token que no cabe no rompa el ancho, pero sin partir palabras normales.
- Mantener el resto: columnas cortas en `nowrap`, botones de Acciones en una sola línea con `flex-wrap:wrap`, y `overflow-x:auto` en `.table-responsive` como último recurso.

## Resultado esperado
- Los nombres y textos bajan de línea completos, nunca partidos por letra.
- Las filas crecen en alto en vez de forzar scroll horizontal.
- El scroll horizontal sigue apareciendo solo cuando ya no cabe de ninguna forma.

Sin cambios en backend ni base de datos.
