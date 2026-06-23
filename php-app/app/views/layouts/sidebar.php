<?php $rol = $_SESSION['user']['rol'] ?? ''; $nombre = $_SESSION['user']['nombre'] ?? ''; ?>
<aside class="sidebar">
  <h2>Citas Médicas</h2>
  <div class="user"><?= htmlspecialchars($nombre) ?><br><small><?= htmlspecialchars($rol) ?></small></div>

  <div class="grupo">Citas</div>
  <nav>
    <a href="/citas/agendar">Agendar cita</a>
    <a href="/citas/modificar">Modificar cita</a>
    <a href="/citas/cancelar">Cancelar cita</a>
    <a href="/calendario">Ver calendario</a>
  </nav>

  <div class="grupo">Opciones</div>
  <nav>
    <a href="/opciones/password">Cambiar contraseña</a>
    <a href="/opciones/datos">Actualizar datos</a>
  </nav>

  <?php if (in_array($rol, ['medico','administrador'])): ?>
    <div class="grupo">Médico</div>
    <nav>
      <a href="/asistentes">Asistentes</a>
      <a href="/reportes/ingresos">Reporte de ingresos</a>
    </nav>
  <?php endif; ?>

  <?php if ($rol === 'administrador'): ?>
    <div class="grupo">Administración</div>
    <nav>
      <a href="/medicos">Médicos</a>
      <a href="/restaurar">Restaurar sistema</a>
      <a href="/roles">Roles</a>
    </nav>
  <?php endif; ?>

  <div class="grupo">Sesión</div>
  <nav><a href="/logout">Cerrar sesión</a></nav>
</aside>
