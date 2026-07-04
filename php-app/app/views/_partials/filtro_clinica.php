<?php
/**
 * Filtro de clinica para admin_sistema.
 * Requiere: $rol, $clinicas, $fClinica, $controller (slug del controlador, ej. 'medicos').
 */
if (($rol ?? '') !== 'admin_sistema') return;
?>
<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Filtro</h3>
  <form method="get" action="<?= url($controller) ?>" class="form-grid">
    <label>Clinica
      <select name="f_clinica" onchange="this.form.submit()">
        <option value="">-- todas --</option>
        <?php foreach (($clinicas ?? []) as $cl): ?>
          <option value="<?= (int)$cl['id_CLINICA'] ?>" <?= (int)($fClinica ?? 0)===(int)$cl['id_CLINICA']?'selected':'' ?>>
            <?= htmlspecialchars($cl['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>
