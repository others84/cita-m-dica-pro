## Objetivo

Hoy varias pantallas envían sus datos por la URL (`?f_clinica=1`, `?edit=5`, `?id=12`, `?f_pais=`, `?id_USUARIO=`). Eso los deja visibles y editables a mano por el usuario. La actualización cambia todo ese envío a **POST** y guarda el estado (filtros / registro en edición) en la **sesión del servidor**, de modo que la URL quede limpia (`.../pacientes`, `.../citas`, etc.).

## Qué se hace

### 1. Helper central en `core/Controller.php`
- Nuevo método `stateParam(string $clave, $default = null)`: lee el valor de `$_POST`, si no viene lo toma de la sesión (`$_SESSION['ui'][controlador][clave]`) y lo persiste. Con esto ya no se lee nada de `$_GET`.
- Nuevo método `clearState(string $clave)` para limpiar el estado (p. ej. al cancelar una edición o después de guardar).
- `resolveClinicaContext()` deja de leer `$_GET['f_clinica']` y pasa a usar `stateParam('f_clinica')`, conservando la lógica actual de validación por rol y de "última selección válida".

### 2. Filtros (selects que hoy recargan por GET)
Archivos: `_partials/filtro_clinica.php`, `_partials/simple_catalog.php`, `catalogos/estados.php`, `catalogos/municipios.php`, `usuarios_clinica/index.php`.
- Cambiar `method="get"` por `method="post"` apuntando a la misma acción del controlador.
- El controlador recibe el filtro por POST, lo guarda en sesión y renderiza (sin redirección, para no perder el POST).

### 3. Botones de acción que hoy llevan el ID en la URL
Afecta: Editar / Baja / Activar-Desactivar / Remover en `citas`, `pacientes`, `medicos`, `especialidades`, `consultorios`, `clinicas`, `catalogos/*`, `usuarios_clinica`, `opciones/password_usuarios`.
- Reemplazar los `<a href="...?edit=N">` por un formulario POST mínimo con `<input type="hidden">` y un `<button>` estilizado igual que el botón actual (misma clase `btn btn-sec`, misma confirmación `confirm()` en las bajas).
- Para no repetir código en cada vista, se agrega un partial `_partials/post_button.php` que recibe acción, campos ocultos, etiqueta, clase y mensaje de confirmación.

### 4. Controladores
`CitasController`, `PacientesController`, `MedicosController`, `EspecialidadesController`, `ConsultoriosController`, `ClinicasController`, `CatalogosController`, `UsuariosClinicaController`, `OpcionesController`:
- Sustituir cada lectura de `$_GET[...]` por `stateParam(...)` / `$this->input(...)` en POST.
- Tras guardar o eliminar, mantener el patrón Post-Redirect-Get pero **sin** query string: la clínica y los filtros ya viven en sesión, así que basta con `redirect('pacientes')`, `redirect('citas')`, etc.
- Al terminar una edición o al cancelar, limpiar la clave de estado correspondiente para que no quede un formulario "pegado" en modo edición.

### 5. Enlaces del sidebar
`layout/header.php` ya no necesita arrastrar `f_clinica`: los enlaces quedan limpios y el contexto se resuelve desde sesión.

## Detalles técnicos

- La sesión ya está activa en `public/index.php`, así que no hace falta infraestructura nueva.
- El estado se guarda namespaced por controlador para que el `edit` de Pacientes no colisione con el de Médicos.
- Se conserva el logging actual en `app.log`, ajustando los mensajes para reportar el origen del valor (`post` o `session`) en lugar de `get_f_clinica`.
- Nota de seguridad: los datos dejan de ser visibles/manipulables desde la barra de direcciones, pero un POST sigue siendo modificable con herramientas de desarrollador; por eso se mantiene (y se refuerza) la validación en servidor de que la clínica/registro pertenezca al usuario. Si quieres, en un paso posterior se puede añadir token CSRF a todos los formularios.

## Archivos a actualizar en tu servidor

`app/core/Controller.php`, los 9 controladores listados, `app/views/_partials/filtro_clinica.php`, `_partials/simple_catalog.php`, nuevo `_partials/post_button.php`, `views/layout/header.php` y las vistas de citas, pacientes, medicos, especialidades, consultorios, clinicas, catalogos (estados, municipios, paises, generos, usuarios, estados_cita), usuarios_clinica y opciones/password_usuarios.
