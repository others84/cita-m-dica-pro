<?php
if (empty($_SESSION['user'])) { header('Location: ' . url('auth/login')); exit; }
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
      <a href="<?= url('dashboard') ?>">Inicio</a>

      <?php if (in_array($rol, ['asistente','medico','administrador','admin_sistema'], true)): ?>
        <a href="<?= url('citas') ?>">CRUD Citas</a>
        <a href="<?= url('calendario') ?>">Calendario</a>
        <a href="<?= url('pacientes') ?>">CRUD Pacientes</a>
        <details class="menu-group">
          <summary>Opciones</summary>
          <a href="<?= url('opciones/cambiarPassword') ?>">Cambiar contraseña</a>
          <a href="<?= url('opciones/actualizarDatos') ?>">Actualizar datos</a>
        </details>
      <?php endif; ?>

      <?php if (in_array($rol, ['medico','administrador','admin_sistema'], true)): ?>
        <a href="<?= url('asistentes') ?>">CRUD Asistentes</a>
        <details class="menu-group">
          <summary>Reportes</summary>
          <a href="<?= url('reportes/ingresos') ?>">Ingresos</a>
        </details>
      <?php endif; ?>

      <?php if (in_array($rol, ['administrador','admin_sistema'], true)): ?>
        <a href="<?= url('medicos') ?>">CRUD Médicos</a>
        <a href="<?= url('especialidades') ?>">CRUD Especialidades</a>
        <a href="<?= url('consultorios') ?>">CRUD Consultorios</a>
        <details class="menu-group">
          <summary>Catálogos</summary>
          <a href="<?= url('catalogos/paises') ?>">Países</a>
          <a href="<?= url('catalogos/estados') ?>">Estados</a>
          <a href="<?= url('catalogos/generos') ?>">Géneros</a>
          <a href="<?= url('catalogos/usuarios') ?>">Usuarios de clínica</a>
          <a href="<?= url('catalogos/estadosCita') ?>">Estado de citas</a>
          <a href="<?= url('catalogos/respaldo') ?>">Respaldo de BD</a>
        </details>
      <?php endif; ?>

      <?php if ($rol === 'admin_sistema'): ?>
        <details class="menu-group">
          <summary>Sistema</summary>
          <a href="<?= url('clinicas') ?>">CRUD Clínicas</a>
          <a href="<?= url('administradores') ?>">CRUD Administradores</a>
          <a href="<?= url('sistema/bloquearClinicas') ?>">Bloquear clínicas</a>
        </details>
      <?php endif; ?>

      <a class="logout" href="<?= url('auth/logout') ?>">Cerrar sesión</a>
    </nav>
  </aside>
  <main class="content">
    <header class="topbar"><h1><?= htmlspecialchars($title ?? '') ?></h1></header>
    <section class="page">