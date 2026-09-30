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
    function nav_icon(string $name): string {
        $paths = [
            'calendar' => '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M16 3v4M8 3v4M3 10h18"/>',
            'appointments' => '<path d="M8 2v4M16 2v4M4 5h16a2 2 0 0 1 2 2v13a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2Z"/><path d="m9 16 2 2 4-5"/>',
            'patients' => '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M19 8v6M22 11h-6"/>',
            'patient' => '<circle cx="12" cy="7" r="3.5"/><path d="M5.5 21v-2.5a6.5 6.5 0 0 1 13 0V21M9 15.2l3 2.3 3-2.3"/>',
            'assistant' => '<circle cx="12" cy="6.5" r="3"/><path d="M6 21v-3.5a6 6 0 0 1 12 0V21M9 12.3V10h6v2.3M4 16h16v5H4zM9 18.5h6"/>',
            'doctor' => '<path d="M6 3v5a6 6 0 0 0 12 0V3M4 3h4M16 3h4M12 14v2a4 4 0 0 0 4 4h1"/><circle cx="19" cy="19" r="2"/>',
            'user-computer' => '<circle cx="8" cy="7" r="3"/><path d="M2.5 17a5.5 5.5 0 0 1 9-4.2M13 13h9v6h-9zM16 22h3M17.5 19v3"/>',
            'mask' => '<path d="M3 5.5c3-1.3 6-1.3 9 0 3-1.3 6-1.3 9 0v5c0 5.4-3.7 9.1-9 10.5-5.3-1.4-9-5.1-9-10.5zM6.5 10c1.2-1 2.4-1 3.6 0M13.9 10c1.2-1 2.4-1 3.6 0M9 15.5c2 1.4 4 1.4 6 0"/>',
            'hourglass' => '<path d="M6 2h12M6 22h12M7 2v4l5 6-5 6v4M17 2v4l-5 6 5 6v4"/>',
            'clock' => '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/>',
            'blocked-calendar' => '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M8 3v4M16 3v4M3 10h18M12 12v7"/>',
            'phone' => '<rect x="7" y="2" width="10" height="20" rx="2"/><path d="M10 5h4M11 18h2"/>',
            'password' => '<path d="M4 8l1.2 2.1L7.5 9M12 8l1.2 2.1L15.5 9M8 14l1.2 2.1 2.3-1.1M16 14l1.2 2.1 2.3-1.1"/>',
            'user-password' => '<circle cx="7" cy="7" r="3"/><path d="M2 20v-2a5 5 0 0 1 9.5-2.2M14 12l1.1 1.9 2.1-1M19 12l1.1 1.9 2.1-1M16.5 17l1.1 1.9 2.1-1"/>',
            'globe' => '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/>',
            'mexico' => '<path d="M3 5l4 1 2-2 3 3 3-1 2 3 4 2-2 3 1 3-4 1-2 3-3-2-2-4-3-2z"/>',
            'puebla' => '<path d="M9 2l4 2-1 4 4 2-2 3 3 4-4 1-2 4-3-3-4-1 2-4-2-3 4-2z"/>',
            'gender' => '<circle cx="7" cy="6" r="3"/><path d="M2 20v-2a5 5 0 0 1 10 0v2M17 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6M14 20v-4h-2l2.5-5h5l2.5 5h-2v4"/>',
            'seated' => '<circle cx="9" cy="5" r="2.5"/><path d="M9 8v6h5l3 6M9 11H5v6h7M5 17v4"/>',
            'mail' => '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="m4 7 8 6 8-6"/>',
            'clinic-blocked' => '<path d="M3 21h12M5 21V6l5-3 5 3v5M8 9h2M8 13h2"/><circle cx="18" cy="17" r="4"/><path d="m15.2 14.2 5.6 5.6"/>',
            'settings' => '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .34 1.88l.06.06-2.83 2.83-.06-.06a1.7 1.7 0 0 0-1.88-.34 1.7 1.7 0 0 0-1.03 1.55V21h-4v-.08A1.7 1.7 0 0 0 8.94 19.4a1.7 1.7 0 0 0-1.88.34l-.06.06-2.83-2.83.06-.06A1.7 1.7 0 0 0 4.6 15 1.7 1.7 0 0 0 3.08 14H3v-4h.08A1.7 1.7 0 0 0 4.6 9a1.7 1.7 0 0 0-.34-1.88L4.2 7.06 7.03 4.2l.06.06A1.7 1.7 0 0 0 9 4.6 1.7 1.7 0 0 0 10 3.08V3h4v.08A1.7 1.7 0 0 0 15 4.6a1.7 1.7 0 0 0 1.88-.34l.06-.06 2.83 2.83-.06.06A1.7 1.7 0 0 0 19.4 9 1.7 1.7 0 0 0 20.92 10H21v4h-.08A1.7 1.7 0 0 0 19.4 15Z"/>',
            'reports' => '<path d="M4 19V9M10 19V5M16 19v-7M22 19H2"/>',
            'clinic' => '<path d="M3 21h18M5 21V5l7-3 7 3v16M9 9h2M13 9h2M9 13h2M13 13h2M10 21v-4h4v4"/>',
            'catalog' => '<path d="M4 5h16v14H4zM8 2v6M16 2v6M4 10h16"/>',
            'document' => '<path d="M6 2h9l5 5v15H6zM14 2v6h6M9 13h6M9 17h6"/>',
            'logout' => '<path d="M10 17l5-5-5-5M15 12H3M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>',
        ];
        $path = $paths[$name] ?? $paths['document'];
        return '<svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">' . $path . '</svg>';
    }
    function nav_icon_for_path(string $path): string {
        $p = strtolower(trim($path, '/'));
        $exact = [
            'pacientes' => 'patient',
            'asistentes' => 'assistant',
            'medicos' => 'doctor',
            'catalogos/usuarios' => 'user-computer',
            'opciones/apariencia' => 'mask',
            'horarios' => 'clock',
            'citasespera' => 'hourglass',
            'diasbloqueados' => 'blocked-calendar',
            'mensajes' => 'phone',
            'opciones/cambiarpassword' => 'password',
            'opciones/passwordusuarios' => 'user-password',
            'catalogos/paises' => 'globe',
            'catalogos/estados' => 'mexico',
            'catalogos/municipios' => 'puebla',
            'catalogos/generos' => 'gender',
            'catalogos/estadoscita' => 'seated',
            'opciones/correo' => 'mail',
            'opciones/whatsapp' => 'phone',
            'opciones/avisoAcceso' => 'mail',
            'sistema/bloquearclinicas' => 'clinic-blocked',
        ];
        if (isset($exact[$p])) return $exact[$p];
        if (strpos($p, 'calendario') !== false) return 'calendar';
        if (strpos($p, 'citas') !== false) return 'appointments';
        if (strpos($p, 'pacientes') !== false || strpos($p, 'medicos') !== false || strpos($p, 'asistentes') !== false || strpos($p, 'usuarios') !== false) return 'patients';
        if (strpos($p, 'reportes') !== false) return 'reports';
        if (strpos($p, 'clinica') !== false || strpos($p, 'consultorios') !== false) return 'clinic';
        if (strpos($p, 'contratos') !== false) return 'document';
        if (strpos($p, 'opciones') !== false || strpos($p, 'horarios') !== false || strpos($p, 'diasbloqueados') !== false || strpos($p, 'mensajes') !== false) return 'settings';
        return 'catalog';
    }
    /** Enlace del menu lateral con clase "active" cuando corresponde a la vista actual. */
    function nav_link(string $path, string $label, string $cur, string $extra = ''): string {
        $cls = trim($extra . (nav_is_active($path, $cur) ? ' active' : ''));
        return '<a class="' . htmlspecialchars($cls) . '" href="' . url($path) . '">' . nav_icon(nav_icon_for_path($path)) . '<span class="nav-label">' . $label . '</span></a>';
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
$__soloFirma = $rol !== 'admin_sistema' && !empty($_SESSION['contratos_pendientes']);
$__monitorCitas = !$__soloFirma && in_array($rol, ['asistente','medico','administrador'], true);
$__labelCitas = 'Citas' . ($__monitorCitas ? ' <span id="nav-citas-badge" class="nav-badge" style="display:none"></span>' : '');
$__labelEspera = 'Citas en espera' . ($__monitorCitas ? ' <span id="nav-espera-badge" class="nav-badge" style="display:none"></span>' : '');
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
  <aside class="sidebar" id="sidebar" aria-label="Menú principal">
    <div class="sidebar-head">
      <div class="brand"><img src="<?= asset('img/logo.png') ?>" alt="" width="32" height="32"><span>Citas Médicas</span></div>
      <button class="sidebar-close" type="button" aria-label="Cerrar menú" title="Cerrar menú"><?= nav_icon('logout') ?></button>
    </div>
    <nav aria-label="Navegación principal">
      <?php if ($__soloFirma): ?>
        <?= nav_link('contratos/firmar', 'Contrato y aviso', $__cur) ?>
      <?php else: ?>
      <?php if ($rol === 'asistente'): ?>
        <?= nav_link('calendario', 'Calendario de citas', $__cur) ?>
        <?= nav_link('citas', $__labelCitas, $__cur) ?>
        <?= nav_link('citasmanana', 'Citas mañana', $__cur) ?>
        <?= nav_link('citasespera', 'Citas en espera', $__cur) ?>
        <?= nav_link('pacientes', 'Pacientes', $__cur) ?>
        <details class="menu-group"<?= nav_group_open(['opciones/cambiarPassword', 'horarios', 'diasbloqueados', 'mensajes', 'opciones/apariencia'], $__cur) ?>>
          <summary><?= nav_icon('settings') ?><span>Configuración</span></summary>
          <?= nav_link('opciones/cambiarPassword', 'Cambiar contraseña', $__cur) ?>
          <?= nav_link('horarios', 'Horario de atención', $__cur) ?>
          <?= nav_link('diasbloqueados', 'Días bloqueados', $__cur) ?>
          <?= nav_link('mensajes', 'Texto de notificación', $__cur) ?>
          <?= nav_link('opciones/apariencia', 'Apariencia', $__cur) ?>
        </details>

      <?php endif; ?>

      <?php if ($rol === 'medico'): ?>
        <?= nav_link('calendario', 'Calendario de citas', $__cur) ?>
        <?= nav_link('citas', $__labelCitas, $__cur) ?>
        <?= nav_link('citasmanana', 'Citas mañana', $__cur) ?>
        <?= nav_link('citasespera', 'Citas en espera', $__cur) ?>
        <?= nav_link('pacientes', 'Pacientes', $__cur) ?>
        <details class="menu-group"<?= nav_group_open(['opciones/cambiarPassword', 'horarios', 'diasbloqueados', 'mensajes', 'opciones/apariencia'], $__cur) ?>>
          <summary><?= nav_icon('settings') ?><span>Configuración</span></summary>
          <?= nav_link('opciones/apariencia', 'Apariencia', $__cur) ?>
          <?= nav_link('horarios', 'Horario de atención', $__cur) ?>
          <?= nav_link('diasbloqueados', 'Días bloqueados', $__cur) ?>
          <?= nav_link('mensajes', 'Texto de notificación', $__cur) ?>
          <?= nav_link('opciones/cambiarPassword', 'Cambiar contraseña', $__cur) ?>
        </details>

        <details class="menu-group"<?= nav_group_open(['reportes/ingresos', 'reportes/repIngresos', 'reportes/repAtencion'], $__cur) ?>>
          <summary><?= nav_icon('reports') ?><span>Reportes</span></summary>
          <?= nav_link('reportes/ingresos', 'Ingresos por consulta', $__cur) ?>
          <?= nav_link('reportes/repIngresos', 'Ingresos por citas', $__cur) ?>
          <?= nav_link('reportes/repAtencion', 'Atención', $__cur) ?>
        </details>
      <?php endif; ?>

      <?php if ($rol === 'administrador'): ?>
        <?= nav_link('calendario', 'Calendario de citas', $__cur) ?>
        <?= nav_link('citas', $__labelCitas, $__cur) ?>
        <?= nav_link('citasespera', 'Citas en espera', $__cur) ?>
        <details class="menu-group"<?= nav_group_open(['pacientes', 'asistentes', 'medicos', 'especialidades', 'consultorios', 'catalogos/usuarios'], $__cur) ?>>
          <summary><?= nav_icon('catalog') ?><span>Catálogos</span></summary>
          <?= nav_link('pacientes', 'Pacientes', $__cur) ?>
          <?= nav_link('asistentes', 'Asistentes', $__cur) ?>
          <?= nav_link('medicos', 'Médicos', $__cur) ?>
          <?= nav_link('especialidades', 'Especialidad', $__cur) ?>
          <?= nav_link('consultorios', 'Consultorios', $__cur) ?>
          <?= nav_link('catalogos/usuarios', 'Usuarios', $__cur) ?>
        </details>
        <details class="menu-group"<?= nav_group_open(['opciones/apariencia', 'horarios', 'diasbloqueados', 'mensajes', 'opciones/cambiarPassword', 'opciones/passwordUsuarios'], $__cur) ?>>
          <summary><?= nav_icon('settings') ?><span>Configuración</span></summary>
          <?= nav_link('opciones/apariencia', 'Apariencia', $__cur) ?>
          <?= nav_link('horarios', 'Horario de atención', $__cur) ?>
          <?= nav_link('diasbloqueados', 'Días bloqueados', $__cur) ?>
          <?= nav_link('mensajes', 'Texto de notificación', $__cur) ?>
          <?= nav_link('opciones/cambiarPassword', 'Cambiar contraseña', $__cur) ?>
          <?= nav_link('opciones/passwordUsuarios', 'Contraseña de usuarios', $__cur) ?>
        </details>

        <details class="menu-group"<?= nav_group_open(['reportes/ingresos', 'reportes/repIngresos', 'reportes/repAtencion', 'reportes/repTop10', 'reportes/repEspecialidad'], $__cur) ?>>
          <summary><?= nav_icon('reports') ?><span>Reportes</span></summary>
          <?= nav_link('reportes/ingresos', 'Ingresos por consulta', $__cur) ?>
          <?= nav_link('reportes/repIngresos', 'Ingresos por citas', $__cur) ?>
          <?= nav_link('reportes/repAtencion', 'Atención', $__cur) ?>
          <?= nav_link('reportes/repTop10', 'Top 10 médicos', $__cur) ?>
          <?= nav_link('reportes/repEspecialidad', 'Atención por especialidad', $__cur) ?>
        </details>
      <?php endif; ?>

      <?php if ($rol === 'admin_sistema'): ?>
        <?= nav_link('calendario', 'Calendario de citas', $__cur) ?>
        <?= nav_link('citas', $__labelCitas, $__cur) ?>
        <details class="menu-group"<?= nav_group_open(['pacientes', 'especialidades', 'consultorios', 'catalogos/paises', 'catalogos/estados', 'catalogos/municipios', 'catalogos/generos', 'catalogos/estadosCita', 'catalogos/usuarios'], $__cur) ?>>
          <summary><?= nav_icon('catalog') ?><span>Catálogos</span></summary>
          <?= nav_link('pacientes', 'Pacientes', $__cur) ?>
          <?= nav_link('especialidades', 'Especialidad', $__cur) ?>
          <?= nav_link('consultorios', 'Consultorios', $__cur) ?>
          <?= nav_link('catalogos/paises', 'Países', $__cur) ?>
          <?= nav_link('catalogos/estados', 'Estados', $__cur) ?>
          <?= nav_link('catalogos/municipios', 'Municipios', $__cur) ?>
          <?= nav_link('catalogos/generos', 'Géneros', $__cur) ?>
          <?= nav_link('catalogos/estadosCita', 'Edo de citas', $__cur) ?>
          <?= nav_link('catalogos/usuarios', 'Usuarios', $__cur) ?>
        </details>
        <details class="menu-group"<?= nav_group_open(['opciones/apariencia', 'opciones/cambiarPassword', 'opciones/correo', 'opciones/whatsapp', 'opciones/avisoAcceso'], $__cur) ?>>
          <summary><?= nav_icon('settings') ?><span>Configuración</span></summary>
          <?= nav_link('opciones/apariencia', 'Apariencia', $__cur) ?>
          <?= nav_link('opciones/cambiarPassword', 'Cambiar contraseña', $__cur) ?>
          <?= nav_link('opciones/correo', 'Configuración de correo', $__cur) ?>
          <?= nav_link('opciones/whatsapp', 'Configuración de WhatsApp', $__cur) ?>
          <?= nav_link('opciones/avisoAcceso', 'Aviso de accesos', $__cur) ?>
        </details>
        <details class="menu-group"<?= nav_group_open(['clinicas', 'usuariosClinica', 'sistema/bloquearClinicas', 'contratos/plantillas', 'contratos/clinica'], $__cur) ?>>
          <summary><?= nav_icon('clinic') ?><span>Clínicas</span></summary>
          <?= nav_link('clinicas', 'Clínicas', $__cur) ?>
          <?= nav_link('usuariosClinica', 'Asignar clínicas a usuarios', $__cur) ?>
          <?= nav_link('sistema/bloquearClinicas', 'Bloquear acceso a clínicas', $__cur) ?>
          <?= nav_link('contratos/plantillas', 'Plantillas legales', $__cur) ?>
        </details>
        <details class="menu-group"<?= nav_group_open(['reportes/ingresos', 'reportes/repIngresos', 'reportes/repAtencion', 'reportes/repTop10', 'reportes/repEspecialidad'], $__cur) ?>>
          <summary><?= nav_icon('reports') ?><span>Reportes</span></summary>
          <?= nav_link('reportes/ingresos', 'Ingresos por consulta', $__cur) ?>
          <?= nav_link('reportes/repIngresos', 'Ingresos por citas', $__cur) ?>
          <?= nav_link('reportes/repAtencion', 'Atención', $__cur) ?>
          <?= nav_link('reportes/repTop10', 'Top 10 médicos', $__cur) ?>
          <?= nav_link('reportes/repEspecialidad', 'Atención por especialidad', $__cur) ?>
        </details>
      <?php endif; ?>
      <?php endif; ?>

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
  <button class="sidebar-backdrop" type="button" aria-label="Cerrar menú" tabindex="-1"></button>
  <main class="content">
    <header class="topbar">
      <div class="topbar-title">
        <button class="menu-toggle" type="button" aria-label="Abrir menú" aria-controls="sidebar" aria-expanded="false" title="Abrir menú">
          <svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M4 7h16M4 12h16M4 17h16"/></svg>
        </button>
        <h1><?= htmlspecialchars($title ?? '') ?></h1>
      </div>
      <div class="topbar-account">
        <span class="user-avatar" aria-hidden="true"><?= htmlspecialchars(mb_strtoupper(mb_substr((string)$user['nombre'], 0, 1))) ?></span>
        <span class="user-summary"><strong><?= htmlspecialchars($user['nombre']) ?></strong><small><?= htmlspecialchars(str_replace('_', ' ', $rol)) ?></small></span>
        <a class="topbar-logout" href="<?= url('auth/logout') ?>" title="Cerrar sesión" aria-label="Cerrar sesión"><?= nav_icon('logout') ?><span>Cerrar sesión</span></a>
      </div>
    </header>
    <section class="page">
      <?php if (!empty($_SESSION['flash'])): foreach ($_SESSION['flash'] as $f): ?>
        <div class="flash flash-<?= htmlspecialchars($f['type']) ?>"><?= htmlspecialchars($f['msg']) ?></div>
      <?php endforeach; $_SESSION['flash'] = []; endif; ?>