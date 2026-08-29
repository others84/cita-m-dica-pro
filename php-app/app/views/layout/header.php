<?php
if (empty($_SESSION['user'])) { header('Location: ' . url('auth/login')); exit; }
// Nunca servir una copia cacheada: un HTML viejo trae un token CSRF caducado
// y el POST fallaba con "Sesion expirada o solicitud invalida (CSRF)".
if (!headers_sent()) {
    header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
    header('Pragma: no-cache');
    header('Expires: 0');
}
$user = $_SESSION['user'];
$rol  = $user['rol'];
// Ruta actual (sin base) para resaltar la opcion seleccionada del menu.
$__base = app_base_url();
$__cur  = (string)parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH);
if ($__base !== '' && strpos($__cur, $__base) === 0) $__cur = substr($__cur, strlen($__base));
$__cur = strtolower(trim($__cur, '/'));
if (!function_exists('nav_is_active')) {
    function nav_is_active(string $path, string $cur): bool {
        $path = strtolower(trim($path, '/'));
        return $cur === $path || strpos($cur, $path . '/') === 0;
    }
}
if (!function_exists('nav_link')) {
    /** Enlace del menu lateral con clase "active" cuando corresponde a la vista actual. */
    function nav_link(string $path, string $label, string $cur, string $extra = ''): string {
        $cls = trim($extra . (nav_is_active($path, $cur) ? ' active' : ''));
        return '<a class="' . htmlspecialchars($cls) . '" href="' . url($path) . '">' . $label . '</a>';
    }
}
if (!function_exists('nav_group_open')) {
    /** Deja abierto el grupo que contiene la opcion activa. */
    function nav_group_open(array $paths, string $cur): string {
        foreach ($paths as $p) if (nav_is_active($p, $cur)) return ' open';
        return '';
    }
}
// Solo asistente, medico y administrador de clinica monitorean citas por notificar.
$__monitorCitas = in_array($rol, ['asistente','medico','administrador'], true);
$__labelCitas = 'Citas' . ($__monitorCitas ? ' <span id="nav-citas-badge" class="nav-badge" style="display:none"></span>' : '');
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title><?= htmlspecialchars($title ?? 'Citas Médicas') ?></title>
<link rel="stylesheet" href="<?= asset('css/style.css') ?>">
<link rel="icon" type="image/png" href="<?= url('favicon.png') ?>">
<link rel="stylesheet" href="<?= asset('css/temas.css') ?>">
<script>
/* Aplica la apariencia guardada en el dispositivo antes de pintar la pagina. */
(function(){try{
  var d=document.documentElement, g=function(k){return localStorage.getItem(k)||'';};
  var t=g('sgco:tema'), f=g('sgco:fuente'), e=g('sgco:escala');
  if(t) d.setAttribute('data-tema',t);
  if(f) d.setAttribute('data-fuente',f);
  if(e) d.setAttribute('data-escala',e);
}catch(x){}})();
</script>
</head>
<body>
<div class="app">
  <aside class="sidebar">
    <div class="brand"><img src="<?= asset('img/logo.png') ?>" alt="" width="28" height="28"> Citas Médicas</div>
    <div class="user">
      <strong><?= htmlspecialchars($user['nombre']) ?></strong>
      <small><?= htmlspecialchars($rol) ?></small>
    </div>
    <nav>
      <?php if (in_array($rol, ['asistente','medico'], true)): ?>
        <?= nav_link('citas', $__labelCitas, $__cur) ?>
        <?= nav_link('calendario', 'Calendario de citas', $__cur) ?>
        <details class="menu-group"<?= nav_group_open(['opciones/cambiarPassword', 'opciones/apariencia'], $__cur) ?>>
          <summary>Opciones</summary>
          <?= nav_link('opciones/cambiarPassword', 'Cambiar contraseña', $__cur) ?>
          <?= nav_link('opciones/apariencia', 'Apariencia', $__cur) ?>
        </details>
        <?= nav_link('pacientes', 'Pacientes', $__cur) ?>
        <?= nav_link('horarios', 'Horario de atención', $__cur) ?>
      <?php endif; ?>

      <?php if ($rol === 'medico'): ?>
        <details class="menu-group"<?= nav_group_open(['reportes/ingresos', 'reportes/repIngresos', 'reportes/repAtencion'], $__cur) ?>>
          <summary>Reportes</summary>
          <?= nav_link('reportes/ingresos', 'Ingresos por consulta', $__cur) ?>
          <?= nav_link('reportes/repIngresos', 'Ingresos por citas', $__cur) ?>
          <?= nav_link('reportes/repAtencion', 'Atención', $__cur) ?>
        </details>
      <?php endif; ?>

      <?php if ($rol === 'administrador'): ?>
        <?= nav_link('citas', $__labelCitas, $__cur) ?>
        <?= nav_link('calendario', 'Calendario de citas', $__cur) ?>
        <details class="menu-group"<?= nav_group_open(['opciones/cambiarPassword', 'opciones/passwordUsuarios', 'opciones/apariencia'], $__cur) ?>>
          <summary>Opciones</summary>
          <?= nav_link('opciones/cambiarPassword', 'Cambiar contraseña', $__cur) ?>
          <?= nav_link('opciones/passwordUsuarios', 'Contraseña de usuarios', $__cur) ?>
          <?= nav_link('opciones/apariencia', 'Apariencia', $__cur) ?>
        </details>
        <?= nav_link('pacientes', 'Pacientes', $__cur) ?>
        <?= nav_link('medicos', 'Médicos', $__cur) ?>
        <?= nav_link('asistentes', 'Asistentes', $__cur) ?>

        <?= nav_link('especialidades', 'Especialidad', $__cur) ?>
        <?= nav_link('consultorios', 'Consultorios', $__cur) ?>
        <details class="menu-group"<?= nav_group_open(['reportes/ingresos', 'reportes/repIngresos', 'reportes/repAtencion', 'reportes/repTop10', 'reportes/repEspecialidad'], $__cur) ?>>
          <summary>Reportes</summary>
          <?= nav_link('reportes/ingresos', 'Ingresos por consulta', $__cur) ?>
          <?= nav_link('reportes/repIngresos', 'Ingresos por citas', $__cur) ?>
          <?= nav_link('reportes/repAtencion', 'Atención', $__cur) ?>
          <?= nav_link('reportes/repTop10', 'Top 10 médicos', $__cur) ?>
          <?= nav_link('reportes/repEspecialidad', 'Atención por especialidad', $__cur) ?>
        </details>
      <?php endif; ?>

      <?php if ($rol === 'admin_sistema'): ?>
        <?= nav_link('citas', $__labelCitas, $__cur) ?>
        <?= nav_link('calendario', 'Calendario de citas', $__cur) ?>
        <?= nav_link('pacientes', 'Pacientes', $__cur) ?>
        <?= nav_link('especialidades', 'Especialidad', $__cur) ?>
        <?= nav_link('consultorios', 'Consultorios', $__cur) ?>
        <?= nav_link('clinicas', 'Clínicas', $__cur) ?>
        <?= nav_link('usuariosClinica', 'Asignar clínicas a usuarios', $__cur) ?>
        <details class="menu-group"<?= nav_group_open(['catalogos/paises', 'catalogos/estados', 'catalogos/municipios', 'catalogos/generos', 'catalogos/usuarios', 'catalogos/estadosCita', 'catalogos/respaldo'], $__cur) ?>>
          <summary>Catálogos</summary>
          <?= nav_link('catalogos/paises', 'Países', $__cur) ?>
          <?= nav_link('catalogos/estados', 'Estados', $__cur) ?>
          <?= nav_link('catalogos/municipios', 'Municipios', $__cur) ?>
          <?= nav_link('catalogos/generos', 'Géneros', $__cur) ?>
          <?= nav_link('catalogos/usuarios', 'Usuarios', $__cur) ?>
          <?= nav_link('catalogos/estadosCita', 'Edo de citas', $__cur) ?>
          <?= nav_link('catalogos/respaldo', 'Respaldo de base de datos', $__cur) ?>
        </details>
        <details class="menu-group"<?= nav_group_open(['reportes/ingresos', 'reportes/repIngresos', 'reportes/repAtencion', 'reportes/repTop10', 'reportes/repEspecialidad'], $__cur) ?>>
          <summary>Reportes</summary>
          <?= nav_link('reportes/ingresos', 'Ingresos por consulta', $__cur) ?>
          <?= nav_link('reportes/repIngresos', 'Ingresos por citas', $__cur) ?>
          <?= nav_link('reportes/repAtencion', 'Atención', $__cur) ?>
          <?= nav_link('reportes/repTop10', 'Top 10 médicos', $__cur) ?>
          <?= nav_link('reportes/repEspecialidad', 'Atención por especialidad', $__cur) ?>
        </details>
        <details class="menu-group"<?= nav_group_open(['opciones/cambiarPassword', 'opciones/apariencia'], $__cur) ?>>
          <summary>Opciones</summary>
          <?= nav_link('opciones/cambiarPassword', 'Cambiar contraseña', $__cur) ?>
          <?= nav_link('opciones/apariencia', 'Apariencia', $__cur) ?>
        </details>
        <?= nav_link('sistema/bloquearClinicas', 'Bloquear acceso a clínicas', $__cur) ?>
      <?php endif; ?>

      <a class="logout" href="<?= url('auth/logout') ?>">Cerrar sesión</a>
    </nav>
    <?php if ($__monitorCitas): ?>
    <script>
    (function () {
      var url = <?= json_encode(url('citas/pendientes')) ?>;
      var el  = document.getElementById('nav-citas-badge');
      if (!el) return;
      var previo = null;
      // La tabla de citas se recarga cuando el contador cambia (p.ej. otra
      // pestania/usuario marco una cita como notificada).
      var enCitas = /\/citas(\/|$)/.test(window.location.pathname);
      function revisar() {
        fetch(url, { credentials: 'same-origin', headers: { 'Accept': 'application/json' } })
          .then(function (r) { return r.ok ? r.json() : null; })
          .then(function (d) {
            var n = d && d.total ? parseInt(d.total, 10) : 0;
            if (n > 0) { el.textContent = '(' + n + ')'; el.style.display = 'inline'; }
            else { el.textContent = ''; el.style.display = 'none'; }
            if (previo !== null && n !== previo && enCitas) { window.location.reload(); }
            previo = n;
          })
          .catch(function () {});
      }
      revisar();
      setInterval(revisar, 60000); // tarea de monitoreo: cada minuto
    })();
    </script>
    <?php endif; ?>
  </aside>
  <main class="content">
    <header class="topbar"><h1><?= htmlspecialchars($title ?? '') ?></h1></header>
    <section class="page">
      <?php if (!empty($_SESSION['flash'])): foreach ($_SESSION['flash'] as $f): ?>
        <div class="flash flash-<?= htmlspecialchars($f['type']) ?>"><?= htmlspecialchars($f['msg']) ?></div>
      <?php endforeach; $_SESSION['flash'] = []; endif; ?>