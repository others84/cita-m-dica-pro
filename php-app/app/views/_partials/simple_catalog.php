<?php
/**
 * Render generico para catalogos {id, nombre}.
 * Variables esperadas: $rows, $idField, $title, $controller (slug), $editId, $editRow
 */
// El Router mapea parts[0]=controlador y parts[1]=accion. Como $controller ya
// trae "catalogos/paises", la accion de guardar debe ir en la MISMA segunda
// parte: "catalogos/paisesGuardar" (no "catalogos/paises/guardar", que caeria
// en la accion "paises" con "guardar" como parametro y nunca ejecutaria el SP).
// Si el slug ya trae subruta (ej. "catalogos/paises"), concatenamos
// la accion pegada: "catalogos/paisesGuardar". Si es un controlador
// dedicado (ej. "especialidades"), la accion se separa con "/":
// "especialidades/guardar".
if (strpos($controller, '/') !== false) {
    $saveAction   = $controller . 'Guardar';
    $deleteAction = $controller . 'Eliminar';
} else {
    $saveAction   = $controller . '/guardar';
    $deleteAction = $controller . '/eliminar';
}
// Nombre a precargar al editar (tolerante a la capitalizacion del SP).
$editNombre = '';
if (!empty($editRow) && is_array($editRow)) {
    foreach ($editRow as $col => $val) {
        if (strtolower((string)$col) === 'nombre') { $editNombre = (string)$val; break; }
    }
}
?>
<?php if (!empty($rol) && $rol==='admin_sistema' && !empty($clinicas)): ?>
<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Filtro</h3>
  <form method="post" action="<?= url($controller) ?>" class="form-grid"><?= csrf_field() ?>
    <label>Clinica
      <select name="f_clinica" onchange="this.form.submit()">
        <option value="">-- todas --</option>
        <?php foreach ($clinicas as $cl): ?>
          <option value="<?= (int)$cl['id_CLINICA'] ?>" <?= (int)($fClinica ?? 0)===(int)$cl['id_CLINICA']?'selected':'' ?>>
            <?= htmlspecialchars($cl['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>
<?php endif; ?>
<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)"><?= htmlspecialchars($title) ?></h2>
</div>

<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0"><?= $editId ? 'Editar' : 'Nuevo' ?></h3>
  <form method="post" action="<?= url($saveAction) ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Nombre
      <input type="text" name="nombre" required maxlength="120"
             value="<?= htmlspecialchars($editNombre) ?>">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?>
        <button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url($controller) ?>">Cancelar</button><?php  ?>
      <?php endif; ?>
    </div>
  </form>
</div>

<table class="data">
  <thead><tr><th>Nombre</th><th style="width:220px">Acciones</th></tr></thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="2" style="text-align:center;color:var(--c4);padding:1rem">Sin registros</td></tr>
    <?php else: foreach ($rows as $r): ?>
      <tr>
        <td><?= htmlspecialchars((string)$r['nombre']) ?></td>
        <td class="acts">
          <?php post_button($controller, ['edit' => (int)$r[$idField]], 'Editar', 'btn btn-sec'); ?>
          <form method="post" action="<?= url($deleteAction) ?>" style="display:inline"
                onsubmit="return confirm('¿Eliminar el registro &quot;<?= htmlspecialchars(addslashes((string)$r['nombre'])) ?>&quot;? Esta acción no se puede deshacer.');"><?= csrf_field() ?>
            <input type="hidden" name="id" value="<?= (int)$r[$idField] ?>">
            <button class="btn btn-danger" type="submit">Baja</button>
          </form>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>