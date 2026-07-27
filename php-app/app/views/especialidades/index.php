<?php $controller='especialidades'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar especialidad' : 'Nueva especialidad' ?></h2>
  <form method="post" action="<?= url('especialidades/guardar') ?>" class="form-grid">
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Nombre
      <input name="nombre" required maxlength="120" value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>">
    </label>
    <?php if (($rol ?? '') === 'admin_sistema'): ?>
      <label>Clinica
        <select name="id_CLINICA" required>
          <option value="">-- selecciona --</option>
          <?php foreach (($clinicas ?? []) as $cl):
            $sel = ((int)($editRow['id_CLINICA'] ?? 0) === (int)$cl['id_CLINICA']) ? 'selected' : '';
            if (!$editRow && (int)($fClinica ?? 0) === (int)$cl['id_CLINICA']) $sel = 'selected';
          ?>
            <option value="<?= (int)$cl['id_CLINICA'] ?>" <?= $sel ?>><?= htmlspecialchars($cl['nombre']) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
    <?php else: ?>
      <input type="hidden" name="id_CLINICA" value="<?= (int)($userClin ?? 0) ?>">
    <?php endif; ?>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): post_button('especialidades', ['edit' => ''], 'Cancelar', 'btn btn-sec'); endif; ?>
    </div>
  </form>
</div>
<table class="data">
  <thead><tr><th>Nombre</th><th>Clinica</th><th style="width:160px">Acciones</th></tr></thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="3" style="text-align:center;color:var(--c4);padding:1rem">Sin registros</td></tr>
    <?php else: foreach ($rows as $r): ?>
      <tr>
        <td><?= htmlspecialchars($r['nombre']) ?></td>
        <td><?= htmlspecialchars($r['clinica'] ?? '') ?></td>
        <td class="acts">
          <?php post_button('especialidades', ['edit' => (int)$r['id_CATALOGO_ESPECIALIDAD']], 'Editar', 'btn btn-sec'); ?>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>
