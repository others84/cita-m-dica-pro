<?php
/** Filtros comunes de reportes: clinica, medico, fecha inicio/fin. */
$controller = $destino; // el filtro de clinica regresa a este reporte
include __DIR__ . '/../_partials/filtro_clinica.php';
?>
<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Filtros del reporte</h3>
  <form method="post" action="<?= url('reportes/filtrar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="destino" value="<?= htmlspecialchars($destino) ?>">
    <input type="hidden" name="ns" value="<?= htmlspecialchars($ns) ?>">
    <label>Medico
      <select name="f_medico" onchange="this.form.submit()">
        <option value="">-- todos --</option>
        <?php foreach (($medicos ?? []) as $m): ?>
          <option value="<?= (int)$m['id_USUARIOS'] ?>" <?= (int)($medico ?? 0) === (int)$m['id_USUARIOS'] ? 'selected' : '' ?>>
            <?= htmlspecialchars($m['nombre_completo'] ?? '') ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Fecha inicio
      <input type="date" name="f_ini" value="<?= htmlspecialchars($ini) ?>" onchange="this.form.submit()">
    </label>
    <label>Fecha fin
      <input type="date" name="f_fin" value="<?= htmlspecialchars($fin) ?>" onchange="this.form.submit()">
    </label>
    <label style="align-self:end"><button class="btn" type="submit">Aplicar</button></label>
  </form>
</div>
