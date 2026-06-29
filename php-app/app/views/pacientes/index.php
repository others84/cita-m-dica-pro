<?php
$fn = $editRow['fecha_nacimiento'] ?? '';
if ($fn instanceof DateTime) $fn = $fn->format('Y-m-d');
$fn = $fn ? substr((string)$fn,0,10) : '';
?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0;color:var(--c5)"><?= $editId ? 'Modificar paciente #' . (int)$editId : 'Nuevo paciente' ?></h2>
  <form method="post" action="<?= url('pacientes/guardar') ?>" class="form-grid">
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Clinica
      <select name="id_CLINICA" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($clinicas as $cl): ?>
          <option value="<?= (int)$cl['id_CLINICA'] ?>" <?= isset($editRow)&&(int)($editRow['id_CLINICA']??0)===(int)$cl['id_CLINICA']?'selected':'' ?>>
            <?= htmlspecialchars($cl['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Apellido paterno <input name="ap_paterno" required value="<?= htmlspecialchars($editRow['ap_paterno'] ?? '') ?>"></label>
    <label>Apellido materno <input name="ap_materno" value="<?= htmlspecialchars($editRow['ap_materno'] ?? '') ?>"></label>
    <label>Nombre(s) <input name="nombre" required value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>"></label>
    <label>Direccion <input name="direccion" value="<?= htmlspecialchars($editRow['direccion'] ?? '') ?>"></label>
    <label>Telefono <input name="telefono" value="<?= htmlspecialchars($editRow['telefono'] ?? '') ?>"></label>
    <label>Email <input type="email" name="email" value="<?= htmlspecialchars($editRow['email'] ?? '') ?>"></label>
    <label>Fecha nacimiento <input type="date" name="fecha_nacimiento" value="<?= htmlspecialchars($fn) ?>"></label>
    <label>Genero
      <select name="id_CATALOGO_GENERO">
        <option value="">--</option>
        <?php foreach ($generos as $g): ?>
          <option value="<?= (int)$g['id_CATALOGO_GENERO'] ?>" <?= isset($editRow)&&(int)($editRow['id_CATALOGO_GENERO']??0)===(int)$g['id_CATALOGO_GENERO']?'selected':'' ?>>
            <?= htmlspecialchars($g['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Municipio <input name="municipio" value="<?= htmlspecialchars($editRow['municipio'] ?? '') ?>"></label>
    <label>Estado
      <select name="id_CATALOGO_ESTADOS">
        <option value="">--</option>
        <?php foreach ($estados as $es): ?>
          <option value="<?= (int)$es['id_CATALOGO_ESTADOS'] ?>" <?= isset($editRow)&&(int)($editRow['id_CATALOGO_ESTADOS']??0)===(int)$es['id_CATALOGO_ESTADOS']?'selected':'' ?>>
            <?= htmlspecialchars($es['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><a class="btn btn-sec" href="<?= url('pacientes') ?>">Cancelar</a><?php endif; ?>
    </div>
  </form>
</div>

<table class="data">
  <thead><tr><th>ID</th><th>Nombre</th><th>Telefono</th><th>Email</th><th>Municipio</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="6" style="text-align:center;padding:1rem;color:var(--c4)">Sin pacientes</td></tr>
    <?php else: foreach ($rows as $p):
      $nom = trim(($p['ap_paterno']??'').' '.($p['ap_materno']??'').' '.($p['nombre']??'')); ?>
      <tr>
        <td><?= (int)$p['id_PACIENTE'] ?></td>
        <td><?= htmlspecialchars($nom) ?></td>
        <td><?= htmlspecialchars($p['telefono'] ?? '') ?></td>
        <td><?= htmlspecialchars($p['email'] ?? '') ?></td>
        <td><?= htmlspecialchars($p['municipio'] ?? '') ?></td>
        <td class="acts">
          <a class="btn btn-sec" href="<?= url('pacientes?edit=' . (int)$p['id_PACIENTE']) ?>">Editar</a>
          <form method="post" action="<?= url('pacientes/eliminar') ?>" style="display:inline" onsubmit="return confirm('Eliminar paciente?')">
            <input type="hidden" name="id" value="<?= (int)$p['id_PACIENTE'] ?>">
            <button class="btn btn-danger" type="submit">Eliminar</button>
          </form>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>