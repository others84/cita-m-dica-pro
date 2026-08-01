<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Filtro</h3>
  <form method="post" action="<?= url('catalogos/estados') ?>" class="form-grid"><?= csrf_field() ?>
    <label>Pais
      <select name="f_pais" onchange="this.form.submit()">
        <option value="">-- todos --</option>
        <?php foreach (($paises ?? []) as $p): ?>
          <option value="<?= (int)$p['id_CATALOGO_PAIS'] ?>" <?= (int)($fPais ?? 0)===(int)$p['id_CATALOGO_PAIS']?'selected':'' ?>>
            <?= htmlspecialchars($p['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar estado' : 'Nuevo estado' ?></h2>
  <form method="post" action="<?= url('catalogos/estadosGuardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Nombre <input name="nombre" required value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>"></label>
    <label>Pais
      <select name="id_CATALOGO_PAIS" required>
        <?php foreach ($paises as $p): ?>
          <option value="<?= (int)$p['id_CATALOGO_PAIS'] ?>" <?= isset($editRow)&&(int)($editRow['id_CATALOGO_PAIS']??0)===(int)$p['id_CATALOGO_PAIS']?'selected':'' ?>>
            <?= htmlspecialchars($p['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId?'Actualizar':'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url('catalogos/estados') ?>">Cancelar</button><?php  endif; ?>
    </div>
  </form>
</div>
<table class="data">
  <thead><tr><th>Nombre</th><th>País</th><th style="width:220px">Acciones</th></tr></thead>
  <tbody>
    <?php foreach ($rows as $r): ?>
      <tr>
        <td><?= htmlspecialchars($r['nombre']) ?></td>
        <td><?= htmlspecialchars((string)($r['pais'] ?? '')) ?></td>
        <td class="acts">
          <?php post_button('catalogos/estados', ['edit' => (int)$r['id_CATALOGO_ESTADOS']], 'Editar', 'btn btn-sec'); ?>
          <form method="post" action="<?= url('catalogos/estadosEliminar') ?>" style="display:inline"
                onsubmit="return confirm('¿Eliminar el estado "<?= htmlspecialchars(addslashes($r['nombre'])) ?>"? Esta acción no se puede deshacer.');"><?= csrf_field() ?>
            <input type="hidden" name="id" value="<?= (int)$r['id_CATALOGO_ESTADOS'] ?>">
            <button class="btn btn-danger" type="submit">Baja</button>
          </form>
        </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>