<?php
/**
 * Filtro de clinica.
 * - admin_sistema: puede elegir entre todas las clinicas o "-- todas --".
 * - otros roles: puede elegir entre las clinicas asignadas (si tiene mas de una).
 *
 * Requiere: $rol, $fClinica, $controller (slug del controlador).
 * Opcional: $clinicasFiltro (lista a mostrar). Si no viene, cae a $clinicas.
 */
$rol = $rol ?? ($_SESSION['user']['rol'] ?? '');
if ($rol === 'admin_sistema') {
    $opts = $clinicasFiltro ?? $clinicas ?? [];
} else {
    // Otros roles: SIEMPRE limitar a las clinicas asignadas al usuario en sesion.
    $opts = $_SESSION['user']['clinicas'] ?? [];
}
// Diagnostico: registra que clinicas ve el partial para el usuario actual.
if (class_exists('Database')) {
    $ids = array_map(fn($c) => (int)($c['id_CLINICA'] ?? 0), $opts);
    Database::log(sprintf(
        'filtro_clinica rol=%s user=%s ctrl=%s opts=[%s]',
        $rol,
        $_SESSION['user']['usuario'] ?? '?',
        $controller ?? '?',
        implode(',', $ids)
    ));
}
if (empty($opts)) return;
$permitirTodas = ($rol === 'admin_sistema');
?>
<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Filtro</h3>
  <form method="get" action="<?= url($controller) ?>" class="form-grid">
    <label>Clinica
      <select name="f_clinica" onchange="this.form.submit()">
        <?php if ($permitirTodas): ?>
          <option value="">-- todas --</option>
        <?php endif; ?>
        <?php foreach ($opts as $cl): ?>
          <option value="<?= (int)$cl['id_CLINICA'] ?>" <?= (int)($fClinica ?? 0)===(int)$cl['id_CLINICA']?'selected':'' ?>>
            <?= htmlspecialchars($cl['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>
