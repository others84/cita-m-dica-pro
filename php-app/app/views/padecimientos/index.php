<?php $controller='padecimientos'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<?php
$editRow = null;
foreach (($items ?? []) as $it) if ((int)$it['id_PADECIMIENTO'] === (int)($editId ?? 0)) { $editRow = $it; break; }
?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0">Padecimientos</h2>
  <p style="margin:.2rem 0 1rem;color:var(--c5)">
    Lista de padecimientos que atiende el médico y su precio. Al agendar una cita se pueden elegir uno o varios
    y el precio de la cita se llena solo con la suma (se puede modificar).
  </p>
  <form method="post" action="<?= url('padecimientos') ?>" class="form-grid"><?= csrf_field() ?>
    <label class="col-span">Médico
      <select name="medico" onchange="this.form.submit()">
        <option value="">-- selecciona --</option>
        <?php foreach ($medicos as $m): ?>
          <option value="<?= (int)$m['id_USUARIOS'] ?>" <?= (int)$idMedico === (int)$m['id_USUARIOS'] ? 'selected' : '' ?>>
            <?= htmlspecialchars((string)($m['nombre_completo'] ?? '')) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>

<?php if ($idMedico): ?>
<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0"><?= $editRow ? 'Modificar padecimiento' : 'Agregar padecimiento' ?></h3>
  <form method="post" action="<?= url('padecimientos/guardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id_MEDICO" value="<?= (int)$idMedico ?>">
    <input type="hidden" name="id_PADECIMIENTO" value="<?= (int)($editRow['id_PADECIMIENTO'] ?? 0) ?>">
    <label class="col-span">Padecimiento
      <input type="text" name="nombre" maxlength="150" required placeholder="Ej. Consulta general, Curación, Ultrasonido"
             value="<?= htmlspecialchars((string)($editRow['nombre'] ?? '')) ?>">
    </label>
    <label>Precio
      <input type="number" name="precio" step="0.01" min="0" required value="<?= htmlspecialchars(number_format((float)($editRow['precio'] ?? 0), 2, '.', '')) ?>">
    </label>
    <?php if ($editRow): ?>
    <label class="chk"><input type="checkbox" name="activo" value="1" <?= !empty($editRow['activo']) ? 'checked' : '' ?>> Activo</label>
    <?php endif; ?>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editRow ? 'Guardar cambios' : 'Agregar' ?></button>
      <?php if ($editRow): ?><a class="btn btn-sec" href="<?= url('padecimientos') ?>">Cancelar</a><?php endif; ?>
    </div>
  </form>
</div>

<div class="table-responsive">
  <table class="data">
    <thead><tr><th>Padecimiento</th><th>Precio</th><th>Estado</th><th>Acciones</th></tr></thead>
    <tbody>
      <?php if (empty($items)): ?>
        <tr><td colspan="4" style="text-align:center;color:var(--c4);padding:1rem">Sin padecimientos registrados</td></tr>
      <?php else: foreach ($items as $p): ?>
        <tr>
          <td><?= htmlspecialchars((string)$p['nombre']) ?></td>
          <td>$<?= number_format((float)$p['precio'], 2) ?></td>
          <td><span class="badge"><?= !empty($p['activo']) ? 'Activo' : 'Inactivo' ?></span></td>
          <td class="acts">
            <form method="post" action="<?= url('padecimientos') ?>"><?= csrf_field() ?>
              <input type="hidden" name="medico" value="<?= (int)$idMedico ?>">
              <input type="hidden" name="editar" value="<?= (int)$p['id_PADECIMIENTO'] ?>">
              <button class="btn btn-sec">Editar</button>
            </form>
            <form method="post" action="<?= url('padecimientos/activo') ?>"><?= csrf_field() ?>
              <input type="hidden" name="id_MEDICO" value="<?= (int)$idMedico ?>">
              <input type="hidden" name="id_PADECIMIENTO" value="<?= (int)$p['id_PADECIMIENTO'] ?>">
              <button class="btn btn-sec"><?= !empty($p['activo']) ? 'Desactivar' : 'Activar' ?></button>
            </form>
          </td>
        </tr>
      <?php endforeach; endif; ?>
    </tbody>
  </table>
</div>
<?php else: ?>
  <p style="color:var(--c5)">Selecciona un médico para ver y definir sus padecimientos.</p>
<?php endif; ?>
