# Sitio web — Clínica (Consulta general / Pediatría / Obstetricia)

Sitio 100% en PHP + HTML + CSS + JavaScript, sin base de datos. Todo el
contenido se guarda en el archivo `data/content.php`.

## Requisitos

- Servidor con PHP 7.4 o superior (recomendado 8.x).
- No necesita MySQL ni ninguna otra base de datos.
- El usuario del servidor web debe poder **escribir** en el archivo
  `data/content.php` (para que el panel de administración pueda guardar
  cambios).

## Instalación

1. Sube toda la carpeta a tu hosting (por ejemplo dentro de `public_html`).
2. Da permisos de escritura a `data/content.php`:
   ```
   chmod 664 data/content.php
   ```
3. Abre `https://tu-dominio.com/` para ver el sitio.
4. Abre `https://tu-dominio.com/admin/login.php` para entrar al panel de
   administración.

## Acceso al panel de administración

- **Usuario:** `admin`
- **Contraseña:** `Clinica2026!`

**Importante:** cambia la contraseña antes de publicar el sitio.
Para generarla, ejecuta en una terminal con PHP instalado:

```
php -r "echo password_hash('tu_nueva_contraseña', PASSWORD_DEFAULT);"
```

Copia el resultado (empieza con `$2y$...`) y pégalo en
`includes/config.php`, en la constante `ADMIN_PASS_HASH`. También puedes
cambiar el usuario en `ADMIN_USER`.

## ¿Qué se puede editar desde el panel?

Desde `/admin` (una vez dentro con tu usuario y contraseña) puedes editar:

- **Datos generales:** nombre de la clínica, teléfono, correo, horario y
  el enlace externo donde los pacientes agendan su cita.
- **Inicio:** título, subtítulo y texto del botón principal.
- **Quiénes somos:** nombre del doctor(a), especialidad, cédula y el
  texto de presentación.
- **Servicios:** puedes editar, agregar o quitar servicios (cada uno con
  nombre, descripción e ícono).
- **Ubicación:** dirección, referencias para llegar y el mapa embebido
  de Google Maps.

Todos los cambios se guardan de inmediato en `data/content.php` al dar
clic en "Guardar cambios", y se reflejan al instante en el sitio público.

## Cómo obtener el enlace del mapa

1. Abre [Google Maps](https://maps.google.com) y busca la dirección de
   la clínica.
2. Clic en "Compartir" → pestaña "Insertar un mapa".
3. Copia únicamente la URL que aparece dentro de `src="..."` del código
   que te da Google (algo como `https://www.google.com/maps?...&output=embed`).
4. Pega esa URL en el campo "Enlace del mapa" dentro del panel.

## Estructura del proyecto

```
clinica/
├── index.php              → Página principal (Inicio, Quiénes somos, Servicios, Ubicación)
├── data/
│   └── content.php         → Todo el contenido editable del sitio (se sobrescribe desde /admin)
├── includes/
│   ├── config.php          → Usuario/contraseña del admin y rutas
│   ├── functions.php       → Cargar/guardar contenido, sesión, CSRF
│   ├── icons.php            → Íconos SVG de los servicios
│   ├── header.php / footer.php
├── assets/
│   ├── css/style.css
│   └── js/main.js
└── admin/
    ├── login.php / logout.php
    ├── dashboard.php        → Formulario de edición de contenido
    ├── save.php              → Procesa y guarda los cambios
    └── assets/admin.css, admin.js
```

## Notas de seguridad

- El panel usa sesiones PHP y un token CSRF en el formulario de edición.
- La contraseña se guarda como hash (`password_hash`), nunca en texto
  plano.
- Si tu hosting lo permite, considera activar HTTPS para el sitio y
  restringir el acceso a `/admin` por IP como capa adicional.
