# Quitar catálogos globales al Administrador de clínica

El Administrador de clínica ya no verá ni podrá entrar a: Países, Estados, Municipios, Géneros y Estados de cita. Esas opciones quedan solo para el Administrador de sistema.

## Qué cambia

1. Menú lateral del Administrador de clínica: el grupo "Catálogos" queda con Pacientes, Asistentes, Médicos, Especialidad, Consultorios y Usuarios.
2. Bloqueo real de acceso: aunque alguien escriba la dirección directa de esas pantallas, el sistema lo rechaza si no es Administrador de sistema.
3. Sin cambios para el Administrador de sistema ni para los demás roles.

## Detalles técnicos

Archivos a modificar, por prioridad:

1. `php-app/app/views/layout/header.php` — en el bloque del rol `administrador`, eliminar los enlaces a `catalogos/paises`, `catalogos/estados`, `catalogos/municipios`, `catalogos/generos` y `catalogos/estadosCita`, y quitarlos también de la lista de `nav_group_open`.
2. `php-app/app/controllers/CatalogosController.php` — agregar un guard exclusivo (`requireLogin(['admin_sistema'])`) en los métodos de países, estados, municipios, géneros y estados de cita (incluidos sus `*Guardar` y `*Eliminar`), dejando `usuarios*` y el resto con el guard actual (`administrador`, `admin_sistema`).
