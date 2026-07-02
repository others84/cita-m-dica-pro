<?php
/**
 * Render generico para catalogos {id, nombre}.
 * Variables esperadas: $rows, $idField, $title, $controller (slug), $editId, $editRow
 */
// El Router mapea parts[0]=controlador y parts[1]=accion. Como $controller ya
// trae "catalogos/paises", la accion de guardar debe ir en la MISMA segunda
// parte: "catalogos/paisesGuardar" (no "catalogos/paises/guardar", que caeria
// en la accion "paises" con "guardar" como parametro y nunca ejecutaria el SP).
$saveAction = $controller . 'Guardar';
?>
<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)"><?= htmlspecialchars($title) ?></h2>
</div>

<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0"><?= $editId ? 'Editar' : 'Nuevo' ?></h3>
  <form method="post" action="<?= url($saveAction) ?>" class="form-grid">
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Nombre
      <input type="text" name="nombre" required maxlength="120"
             value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?>
        <a class="btn btn-sec" href="<?= url($controller) ?>">Cancelar</a>
      <?php endif; ?>
    </div>
  </form>
</div>

<table class="data">
  <thead><tr><th>ID</th><th>Nombre</th><th style="width:160px">Acciones</th></tr></thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="3" style="text-align:center;color:var(--c4);padding:1rem">Sin registros</td></tr>
    <?php else: foreach ($rows as $r): ?>
      <tr>
        <td><?= htmlspecialchars((string)$r[$idField]) ?></td>
        <td><?= htmlspecialchars((string)$r['nombre']) ?></td>
        <td class="acts">
          <a class="btn btn-sec" href="<?= url($controller . '?edit=' . $r[$idField]) ?>">Editar</a>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>