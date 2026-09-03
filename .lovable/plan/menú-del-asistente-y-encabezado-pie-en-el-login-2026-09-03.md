# Menú del asistente y encabezado/pie en el login

## 1. Menú lateral (rol Asistente)

Nuevo orden, solo para el rol asistente (el rol médico conserva su orden actual):

1. Calendario de citas
2. Citas (con su indicador de pendientes)
3. Pacientes
4. Configuración (grupo desplegable, antes "Opciones")
   - Cambiar contraseña
   - Horario de atención
   - Apariencia
5. Cerrar sesión

"Horario de atención" deja de ser opción suelta y pasa dentro de Configuración. Los demás roles (médico, administrador de clínica, administrador de sistema) no cambian.

## 2. Login con encabezado y pie de página

- Encabezado fijo arriba de la tarjeta de acceso, con una franja que muestra el logo del sistema (y espacio para texto a futuro).
- Pie de página al fondo, como área reservada y vacía por ahora, lista para agregar contenido cuando se indique.
- La tarjeta de inicio de sesión queda centrada entre ambos, y el diseño se mantiene legible en celular.
- Encabezado y pie existen únicamente en la pantalla de login y en la página pública de generar cita; una vez dentro del sistema no aparecen (el layout interno no se toca).

## Detalles técnicos

Archivos a modificar, por prioridad:

1. `php-app/app/views/layout/header.php` — separar el bloque del asistente del bloque del médico, reordenar enlaces, renombrar el grupo a "Configuración" y mover "Horario de atención" dentro de él.
2. `php-app/app/views/auth/login.php` — envolver el contenido en `<div class="login-shell">` con `<header class="login-header">` (logo) y `<footer class="login-footer">` vacío.
3. `php-app/public/assets/css/style.css` — estilos `.login-shell` (flex columna, `min-height:100dvh`), `.login-header`, `.login-footer` y ajuste de `.login-body` para acomodar la nueva estructura, incluyendo reglas responsive.

Nota: al separar los bloques del asistente y del médico, se conserva el resaltado de opción activa (`nav_link`) y el badge de citas por notificar.
