# Renovación visual del menú y encabezado

## Objetivo
Adaptar la interfaz interna al estilo de la referencia: limpia, clara y profesional, sin modificar las funciones, permisos ni contenido de cada módulo.

## Qué se va a construir

1. **Paleta clara y profesional**
   - Fondo general gris azulado muy claro.
   - Menú y encabezado blancos, con divisiones y sombras muy sutiles.
   - Azul como color principal para la opción activa, botones y elementos importantes.
   - Texto principal azul oscuro/gris y texto secundario más tenue.
   - Tarjetas y tablas conservarán buena separación visual, con bordes discretos.
   - La nueva apariencia será la predeterminada; las paletas opcionales seguirán funcionando.

2. **Menú lateral inspirado en la referencia**
   - Logo y nombre del sistema en la parte superior.
   - Fondo blanco en lugar del bloque azul oscuro actual.
   - Cada opción tendrá un icono sencillo y una zona de clic amplia.
   - La opción activa se destacará con fondo azul muy claro, texto azul y una marca lateral.
   - Los grupos desplegables conservarán sus opciones y comportamiento actual.
   - No se cambiará el orden ni la visibilidad definida para cada rol.
   - En celular, el menú se abrirá y cerrará desde un botón del encabezado para no ocupar toda la pantalla.

3. **Encabezado superior**
   - Barra blanca horizontal, alineada con el área de trabajo.
   - Botón para abrir/cerrar el menú en pantallas pequeñas.
   - Título de la página a la izquierda.
   - Nombre y rol del usuario a la derecha, junto con una acción clara para cerrar sesión.
   - No se agregarán buscador, notificaciones ni botones decorativos sin función real.

4. **Adaptación a distintos tamaños**
   - Escritorio: menú lateral fijo y encabezado superior compacto.
   - Tablet y celular: menú lateral ocultable con fondo de protección y controles táctiles amplios.
   - Se revisará que tablas, calendario, formularios y contratos sigan usando correctamente el espacio disponible.

## Alcance de esta primera etapa
- Se modifica únicamente la presentación general del sistema autenticado.
- No se rediseñan todavía las pantallas internas, tablas, formularios, calendario ni login.
- No se cambia ninguna regla de negocio, controlador, modelo, procedimiento almacenado o base de datos.

## Archivos a actualizar, por prioridad
1. `php-app/app/views/layout/header.php` — nueva distribución del menú, encabezado, datos del usuario y control móvil.
2. `php-app/public/assets/css/style.css` — paleta base, menú claro, encabezado y adaptación para celular/tablet.
3. `php-app/app/views/layout/footer.php` — apertura/cierre del menú móvil y conservación del estado de los grupos.
4. `php-app/public/assets/css/temas.css` — compatibilidad de las paletas existentes con la nueva estructura.

## Validación
- Revisar el resultado con los cuatro roles: Asistente, Médico, Administrador de Clínica y Administrador de Sistema.
- Comprobar escritorio, tablet y celular.
- Confirmar que la opción activa, grupos desplegables, contador de citas, cierre de sesión y bloqueo por firma sigan funcionando.
