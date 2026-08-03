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
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title><?= htmlspecialchars($title ?? 'Citas Médicas') ?></title>
<link rel="stylesheet" href="<?= asset('css/style.css') ?>">
</head>
<body>
<div class="app">
  <aside class="sidebar">
    <div class="brand">Citas Médicas</div>
    <div class="user">
      <strong><?= htmlspecialchars($user['nombre']) ?></strong>
      <small><?= htmlspecialchars($rol) ?></small>
    </div>
    <nav>
      <?php if (in_array($rol, ['asistente','medico'], true)): ?>
        <a href="<?= url('citas') ?>">Citas</a>
        <a href="<?= url('calendario') ?>">Calendario de citas</a>
        <details class="menu-group">
          <summary>Opciones</summary>
          <a href="<?= url('opciones/cambiarPassword') ?>">Cambiar contraseña</a>
        </details>
        <a href="<?= url('pacientes') ?>">Pacientes</a>
      <?php endif; ?>

      <?php if ($rol === 'administrador'): ?>
        <a href="<?= url('citas') ?>">Citas</a>
        <a href="<?= url('calendario') ?>">Calendario de citas</a>
        <details class="menu-group">
          <summary>Opciones</summary>
          <a href="<?= url('opciones/cambiarPassword') ?>">Cambiar contraseña</a>
          <a href="<?= url('opciones/passwordUsuarios') ?>">Contraseña de usuarios</a>
        </details>
        <a href="<?= url('pacientes') ?>">Pacientes</a>
        <a href="<?= url('medicos') ?>">Médicos</a>
        <a href="<?= url('especialidades') ?>">Especialidad</a>
        <a href="<?= url('consultorios') ?>">Consultorios</a>
        <details class="menu-group">
          <summary>Reportes</summary>
          <a href="<?= url('reportes/ingresos') ?>">Ingresos por consulta</a>
          <a href="<?= url('reportes/repIngresos') ?>">Ingresos por citas</a>
          <a href="<?= url('reportes/repAtencion') ?>">Atención</a>
          <a href="<?= url('reportes/repTop10') ?>">Top 10 médicos</a>
          <a href="<?= url('reportes/repEspecialidad') ?>">Atención por especialidad</a>
        </details>
      <?php endif; ?>

      <?php if ($rol === 'admin_sistema'): ?>
        <a href="<?= url('citas') ?>">Citas</a>
        <a href="<?= url('calendario') ?>">Calendario de citas</a>
        <a href="<?= url('pacientes') ?>">Pacientes</a>
        <a href="<?= url('especialidades') ?>">Especialidad</a>
        <a href="<?= url('consultorios') ?>">Consultorios</a>
        <a href="<?= url('clinicas') ?>">Clínicas</a>
        <a href="<?= url('usuariosClinica') ?>">Asignar clínicas a usuarios</a>
        <details class="menu-group">
          <summary>Catálogos</summary>
          <a href="<?= url('catalogos/paises') ?>">Países</a>
          <a href="<?= url('catalogos/estados') ?>">Estados</a>
          <a href="<?= url('catalogos/municipios') ?>">Municipios</a>
          <a href="<?= url('catalogos/generos') ?>">Géneros</a>
          <a href="<?= url('catalogos/usuarios') ?>">Usuarios</a>
          <a href="<?= url('catalogos/estadosCita') ?>">Edo de citas</a>
          <a href="<?= url('catalogos/respaldo') ?>">Respaldo de base de datos</a>
        </details>
        <details class="menu-group">
          <summary>Reportes</summary>
          <a href="<?= url('reportes/ingresos') ?>">Ingresos por consulta</a>
          <a href="<?= url('reportes/repIngresos') ?>">Ingresos por citas</a>
          <a href="<?= url('reportes/repAtencion') ?>">Atención</a>
          <a href="<?= url('reportes/repTop10') ?>">Top 10 médicos</a>
          <a href="<?= url('reportes/repEspecialidad') ?>">Atención por especialidad</a>
        </details>
        <a href="<?= url('sistema/bloquearClinicas') ?>">Bloquear acceso a clínicas</a>
      <?php endif; ?>

      <a class="logout" href="<?= url('auth/logout') ?>">Cerrar sesión</a>
    </nav>
  </aside>
  <main class="content">
    <header class="topbar"><h1><?= htmlspecialchars($title ?? '') ?></h1></header>
    <section class="page">
      <?php if (!empty($_SESSION['flash'])): foreach ($_SESSION['flash'] as $f): ?>
        <div class="flash flash-<?= htmlspecialchars($f['type']) ?>"><?= htmlspecialchars($f['msg']) ?></div>
      <?php endforeach; $_SESSION['flash'] = []; endif; ?>