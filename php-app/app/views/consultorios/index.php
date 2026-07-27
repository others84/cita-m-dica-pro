<?php $controller='consultorios'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar consultorio' : 'Nuevo consultorio' ?></h2>
  <form method="post" action="<?= url('consultorios/guardar') ?>" class="form-grid">
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Clinica
      <select name="id_CLINICA" required>
        <option value="">--</option>
        <?php foreach ($clinicas as $cl): ?>
          <option value="<?= (int)$cl['id_CLINICA'] ?>" <?= isset($editRow)&&(int)($editRow['id_CLINICA']??0)===(int)$cl['id_CLINICA']?'selected':'' ?>>
            <?= htmlspecialchars($cl['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Nombre
      <input name="nombre" required maxlength="100" value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" name="edit" value="" formaction="<?= url('consultorios') ?>">Cancelar</button><?php  endif; ?>
    </div>
  </form>
</div>
<table class="data">
  <thead><tr><th>Clinica</th><th>Nombre</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php foreach ($rows as $c): ?>
      <tr>
        <td><?= htmlspecialchars((string)($c['clinica'] ?? '')) ?></td>
        <td><?= htmlspecialchars($c['nombre']) ?></td>
        <td class="acts">
          <?php post_button('consultorios', ['edit' => (int)$c['id_CONSULTORIO']], 'Editar', 'btn btn-sec'); ?>
          <form method="post" action="<?= url('consultorios/eliminar') ?>" style="display:inline"
                onsubmit="return confirm('¿Eliminar el consultorio &quot;<?= htmlspecialchars(addslashes($c['nombre'])) ?>&quot;? Esta acción no se puede deshacer.');">
            <input type="hidden" name="id" value="<?= (int)$c['id_CONSULTORIO'] ?>">
            <button class="btn btn-danger">Baja</button>
          </form>
        </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>