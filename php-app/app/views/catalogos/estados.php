<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar estado' : 'Nuevo estado' ?></h2>
  <form method="post" action="<?= url('catalogos/estadosGuardar') ?>" class="form-grid">
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
      <?php if ($editId): ?><a class="btn btn-sec" href="<?= url('catalogos/estados') ?>">Cancelar</a><?php endif; ?>
    </div>
  </form>
</div>
<table class="data">
  <thead><tr><th>ID</th><th>Nombre</th><th>Pais</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php foreach ($rows as $r): ?>
      <tr>
        <td><?= (int)$r['id_CATALOGO_ESTADOS'] ?></td>
        <td><?= htmlspecialchars($r['nombre']) ?></td>
        <td><?= (int)($r['id_CATALOGO_PAIS'] ?? 0) ?></td>
        <td class="acts"><a class="btn btn-sec" href="<?= url('catalogos/estados?edit=' . (int)$r['id_CATALOGO_ESTADOS']) ?>">Editar</a></td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>