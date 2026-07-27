<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar clinica' : 'Nueva clinica' ?></h2>
  <form method="post" action="<?= url('clinicas/guardar') ?>" class="form-grid">
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Nombre <input name="nombre" required value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>"></label>
    <label>Direccion <input name="direccion" required value="<?= htmlspecialchars($editRow['direccion'] ?? '') ?>"></label>
    <label>Email <input type="email" name="email" value="<?= htmlspecialchars($editRow['email'] ?? '') ?>"></label>
    <label>Telefono <input name="telefono" value="<?= htmlspecialchars($editRow['telefono'] ?? '') ?>"></label>
    <label>Municipio
      <select name="id_CATALOGO_MUNICIPIO" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($municipios as $mu): ?>
          <option value="<?= (int)$mu['id_CATALOGO_MUNICIPIO'] ?>" <?= isset($editRow)&&(int)($editRow['id_CATALOGO_MUNICIPIO']??0)===(int)$mu['id_CATALOGO_MUNICIPIO']?'selected':'' ?>>
            <?= htmlspecialchars($mu['nombre'] . ' - ' . ($mu['estado'] ?? '')) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url('clinicas') ?>">Cancelar</button><?php  endif; ?>
    </div>
  </form>
</div>
<table class="data">
  <thead><tr><th>Nombre</th><th>Municipio</th><th>Telefono</th><th>Activa</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php foreach ($rows as $c): ?>
      <tr>
        <td><?= htmlspecialchars($c['nombre']) ?></td>
        <td><?= htmlspecialchars($c['municipio'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['telefono'] ?? '') ?></td>
        <td><span class="badge <?= empty($c['activo'])?'off':'' ?>"><?= empty($c['activo']) ? 'No' : 'Si' ?></span></td>
        <td class="acts">
          <?php post_button('clinicas', ['edit' => (int)$c['id_CLINICA']], 'Editar', 'btn btn-sec'); ?>
          <?php if (!empty($c['activo'])): ?>
            <form method="post" action="<?= url('clinicas/desactivar') ?>" style="display:inline">
              <input type="hidden" name="id" value="<?= (int)$c['id_CLINICA'] ?>"><button class="btn btn-danger">Desactivar</button>
            </form>
          <?php else: ?>
            <form method="post" action="<?= url('clinicas/activar') ?>" style="display:inline">
              <input type="hidden" name="id" value="<?= (int)$c['id_CLINICA'] ?>"><button class="btn">Activar</button>
            </form>
          <?php endif; ?>
        </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>