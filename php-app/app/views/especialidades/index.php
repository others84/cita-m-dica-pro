<?php $controller='especialidades'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar especialidad' : 'Nueva especialidad' ?></h2>
  <form method="post" action="<?= url('especialidades/guardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <?php
      // La clinica se toma del filtro superior; no se elige en el formulario.
      $clinicaForm = (int)($editRow['id_CLINICA'] ?? $fClinica ?? 0);
    ?>
    <input type="hidden" name="id_CLINICA" value="<?= $clinicaForm ?>">
    <?php if ($clinicaForm <= 0): ?>
      <p style="grid-column:1/-1;color:var(--c5);margin:0">Selecciona una clinica en el filtro para registrar una especialidad.</p>
    <?php endif; ?>
    <label>Nombre
      <input name="nombre" required maxlength="120" value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url('especialidades') ?>">Cancelar</button><?php  endif; ?>
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
