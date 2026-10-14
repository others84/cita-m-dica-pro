# Centro de ayuda por rol + bienvenida en el primer acceso

## Qué verá cada usuario
- Una nueva opción **"Ayuda"** en el menú lateral, para los 4 roles (Administrador de Sistema, Administrador de Clínica, Médico y Asistente).
- La pantalla de Ayuda muestra solo la guía de **su rol**, organizada en secciones desplegables (por ejemplo, para el Asistente: Calendario, Agendar cita, Citas mañana y WhatsApp, Citas en espera, Pacientes, Configuración).
- Cada sección explica paso a paso cómo se hace la tarea y tiene un botón "Ir a la pantalla" que lleva directo a esa opción.
- **Primer acceso:** después de firmar el contrato (si aplica), aparece una ventana de bienvenida con los 3–4 pasos clave del rol y dos botones: "Ver la guía completa" y "Entendido". Al cerrarla ya no vuelve a salir; la guía sigue disponible en el menú.
- Un enlace "¿Cómo se usa esta pantalla?" en el encabezado lleva a la sección de ayuda correspondiente a la pantalla actual.

## Contenido de las guías (resumen)
- **Asistente:** calendario y agendar desde un horario libre, alta/edición de citas y padecimientos, confirmar por WhatsApp, citas mañana, citas en espera y adelantar, pacientes e historial, horarios y días bloqueados.
- **Médico:** lo anterior más confirmar/atendida (horas reales), catálogo de padecimientos con precio, texto de notificación y reportes.
- **Administrador de Clínica:** catálogos (médicos, asistentes, consultorios, especialidades, usuarios), contraseñas de usuarios, configuración y reportes.
- **Administrador de Sistema:** clínicas, asignación de usuarios, bloqueo de clínicas, plantillas legales, correo, WhatsApp, aviso de accesos, protección de cita pública y catálogos globales.

## Archivos (en orden de prioridad)
1. `php-app/sql/patches/2026-10-14_ayuda_bienvenida.sql` (nuevo) — agrega la marca "ya vio la bienvenida" al usuario y su procedimiento. Ejecutar en `CitasMedicas` y `citasMedicasDEMO`.
2. `php-app/app/controllers/AyudaController.php` (nuevo) — muestra la guía del rol y registra que se cerró la bienvenida.
3. `php-app/app/views/ayuda/index.php` (nuevo) — pantalla de ayuda con secciones por rol.
4. `php-app/app/views/ayuda/_contenido.php` (nuevo) — textos de las guías de los 4 roles en un solo lugar para editarlos fácil.
5. `php-app/app/views/ayuda/_modal_bienvenida.php` (nuevo) — ventana del primer acceso.
6. `php-app/app/models/UsuarioModel.php` — leer y marcar la bienvenida vista.
7. `php-app/app/controllers/AuthController.php` — al iniciar sesión, guardar en la sesión si debe mostrarse la bienvenida.
8. `php-app/app/views/layout/header.php` — opción "Ayuda" en el menú con su icono, enlace contextual y carga de la ventana de bienvenida.
9. `php-app/public/assets/css/style.css` — estilos de la guía y la ventana.

Copiar los mismos archivos a las carpetas live y demo.

## Detalles técnicos
- Columna `bienvenida_vista BIT NOT NULL DEFAULT 0` en `USUARIOS`, `spMarcarBienvenidaVista @id_usuario`; el patch es idempotente.
- `POST ayuda/cerrarBienvenida` con CSRF, responde JSON; actualiza `$_SESSION['user']['bienvenida_vista']`.
- El modal no se muestra mientras haya `contratos_pendientes`.
- Mapa ruta→sección (`calendario`→`#calendario`, etc.) para el enlace contextual.
