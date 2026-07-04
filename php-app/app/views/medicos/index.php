<?php $controller='medicos'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar medico #' . (int)$editId : 'Nuevo medico' ?></h2>
  <form method="post" action="<?= url('medicos/guardar') ?>" class="form-grid">
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Nombre completo
      <input name="nombre_completo" required maxlength="150" value="<?= htmlspecialchars($editRow['nombre_completo'] ?? '') ?>">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><a class="btn btn-sec" href="<?= url('medicos') ?>">Cancelar</a><?php endif; ?>
    </div>
  </form>
</div>
<table class="data">
  <thead><tr><th>ID</th><th>Nombre</th><th>Activo</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php foreach ($rows as $m): ?>
      <tr>
        <td><?= (int)$m['id_MEDICO'] ?></td>
        <td><?= htmlspecialchars($m['nombre_completo']) ?></td>
        <td><span class="badge <?= empty($m['activo'])?'off':'' ?>"><?= empty($m['activo']) ? 'No' : 'Si' ?></span></td>
        <td class="acts">
          <a class="btn btn-sec" href="<?= url('medicos?edit=' . (int)$m['id_MEDICO']) ?>">Editar</a>
          <form method="post" action="<?= url('medicos/eliminar') ?>" style="display:inline" onsubmit="return confirm('Dar de baja?')">
            <input type="hidden" name="id" value="<?= (int)$m['id_MEDICO'] ?>">
            <button class="btn btn-danger">Baja</button>
          </form>
        </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>