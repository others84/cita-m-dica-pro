<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)">Municipios</h2>
</div>

<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Filtros</h3>
  <form method="get" action="<?= url('catalogos/municipios') ?>" class="form-grid">
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
    <label>Estado
      <select name="f_estado" onchange="this.form.submit()">
        <option value="">-- todos --</option>
        <?php foreach (($estados ?? []) as $e): ?>
          <option value="<?= (int)$e['id_CATALOGO_ESTADOS'] ?>" <?= (int)($fEstado ?? 0)===(int)$e['id_CATALOGO_ESTADOS']?'selected':'' ?>>
            <?= htmlspecialchars($e['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>

<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0"><?= $editId ? 'Editar municipio' : 'Nuevo municipio' ?></h3>
  <form method="post" action="<?= url('catalogos/municipiosGuardar') ?>" class="form-grid">
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Nombre
      <input name="nombre" required maxlength="120"
             value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>">
    </label>
    <label>Estado
      <select name="id_CATALOGO_ESTADOS" required>
        <?php foreach ($estados as $e): ?>
          <option value="<?= (int)$e['id_CATALOGO_ESTADOS'] ?>"
            <?= isset($editRow)&&(int)($editRow['id_CATALOGO_ESTADOS']??0)===(int)$e['id_CATALOGO_ESTADOS']?'selected':'' ?>>
            <?= htmlspecialchars($e['nombre']) ?> — <?= htmlspecialchars($e['pais'] ?? '') ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId?'Actualizar':'Guardar' ?></button>
      <?php if ($editId): ?><a class="btn btn-sec" href="<?= url('catalogos/municipios') ?>">Cancelar</a><?php endif; ?>
    </div>
  </form>
</div>

<table class="data">
  <thead><tr><th>Nombre</th><th>Estado</th><th>País</th><th style="width:160px">Acciones</th></tr></thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="4" style="text-align:center;color:var(--c4);padding:1rem">Sin registros</td></tr>
    <?php else: foreach ($rows as $r): ?>
      <tr>
        <td><?= htmlspecialchars($r['nombre']) ?></td>
        <td><?= htmlspecialchars((string)($r['estado'] ?? '')) ?></td>
        <td><?= htmlspecialchars((string)($r['pais'] ?? '')) ?></td>
        <td class="acts">
          <a class="btn btn-sec" href="<?= url('catalogos/municipios?edit=' . (int)$r['id_CATALOGO_MUNICIPIO']) ?>">Editar</a>
          <form method="post" action="<?= url('catalogos/municipiosEliminar') ?>" style="display:inline"
                onsubmit="return confirm('¿Eliminar el municipio &quot;<?= htmlspecialchars(addslashes($r['nombre'])) ?>&quot;? Esta acción no se puede deshacer.');">
            <input type="hidden" name="id" value="<?= (int)$r['id_CATALOGO_MUNICIPIO'] ?>">
            <button class="btn btn-danger" type="submit">Baja</button>
          </form>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>