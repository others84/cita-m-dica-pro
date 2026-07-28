<?php $controller='consultorios'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar consultorio' : 'Nuevo consultorio' ?></h2>
  <form method="post" action="<?= url('consultorios/guardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <?php
      // La clinica se toma del filtro superior; no se elige en el formulario.
      $clinicaForm = (int)($editRow['id_CLINICA'] ?? $fClinica ?? 0);
    ?>
    <input type="hidden" name="id_CLINICA" value="<?= $clinicaForm ?>">
    <?php if ($clinicaForm <= 0): ?>
      <p style="grid-column:1/-1;color:var(--c5);margin:0">Selecciona una clinica en el filtro para registrar un consultorio.</p>
    <?php endif; ?>
    <label>Nombre
      <input name="nombre" required maxlength="100" value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url('consultorios') ?>">Cancelar</button><?php  endif; ?>
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
                onsubmit="return confirm('¿Eliminar el consultorio &quot;<?= htmlspecialchars(addslashes($c['nombre'])) ?>&quot;? Esta acción no se puede deshacer.');"><?= csrf_field() ?>
            <input type="hidden" name="id" value="<?= (int)$c['id_CONSULTORIO'] ?>">
            <button class="btn btn-danger">Baja</button>
          </form>
        </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>