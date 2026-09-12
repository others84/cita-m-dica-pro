# Ajustes de menú y usuarios para el Administrador de clínica

## Qué cambia

1. El Administrador de clínica ya no verá ni podrá entrar a: Países, Estados, Municipios, Géneros y Estados de cita. Esas opciones quedan solo para el Administrador de sistema.
2. Bloqueo real de acceso: aunque alguien escriba la dirección directa de esas pantallas, el sistema lo rechaza si no es Administrador de sistema.
3. En la pantalla de Usuarios, el Administrador de clínica solo verá usuarios de sus clínicas, y solo podrá crear, editar, activar, desactivar o eliminar usuarios de esas clínicas. El filtro de clínica también se limita a las suyas y no podrá asignar un usuario a una clínica ajena.
4. Sin cambios para el Administrador de sistema ni para los demás roles.

## Detalles técnicos

Archivos a modificar, por prioridad:

1. `php-app/app/controllers/CatalogosController.php`
   - Guard exclusivo (`requireLogin(['admin_sistema'])`) en países, estados, municipios, géneros y estados de cita, incluyendo sus `*Guardar` y `*Eliminar`.
   - `usuarios()`: cuando `clinicasPermitidas()` no es nulo, filtrar `UsuarioModel::listar()` a esas clínicas (también la búsqueda del registro en edición) y pasar a la vista solo las clínicas permitidas.
   - `usuariosGuardar()`, `usuariosActivar()`, `usuariosDesactivar()`, `usuariosEliminar()`: validar con `clinicaPermitida()` la clínica del usuario objetivo (y la clínica destino en el alta/cambio); si no corresponde, cortar con `denegarRecurso()` para que quede registrado en el log.
2. `php-app/app/views/layout/header.php` — en el bloque del rol `administrador`, eliminar los enlaces a `catalogos/paises`, `catalogos/estados`, `catalogos/municipios`, `catalogos/generos` y `catalogos/estadosCita`, y quitarlos de la lista de `nav_group_open`.
3. `php-app/app/views/catalogos/usuarios.php` — usar la lista de clínicas ya filtrada que envía el controlador (sin cambios de diseño).
