<?php $controller='medicos'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<?php
  // La clinica se toma del filtro superior; no se elige en el formulario.
  $clinicaForm = (int)($editRow['id_CLINICA'] ?? $fClinica ?? 0);
?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar medico' : 'Nuevo medico' ?></h2>
  <p style="margin:.2rem 0 1rem;color:var(--c5)">El usuario se da de alta con perfil <strong>medico</strong> y se asigna automaticamente a la clinica seleccionada en el filtro.</p>
  <form method="post" action="<?= url('medicos/guardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <input type="hidden" name="id_CLINICA" value="<?= $clinicaForm ?>">
    <?php if ($clinicaForm <= 0): ?>
      <p style="grid-column:1/-1;color:var(--c5);margin:0">Selecciona una clinica en el filtro para registrar un medico.</p>
    <?php endif; ?>
    <label>Usuario
      <input name="usuario" required maxlength="50" value="<?= htmlspecialchars($editRow['usuario'] ?? '') ?>" <?= $editId?'readonly':'' ?>>
    </label>
    <label>Nombre completo
      <input name="nombre_completo" required maxlength="150" value="<?= htmlspecialchars($editRow['nombre_completo'] ?? '') ?>">
    </label>
    <label>Email <input type="email" name="email" value="<?= htmlspecialchars($editRow['email'] ?? '') ?>"></label>
    <label>RFC
      <input name="rfc" maxlength="13" style="text-transform:uppercase" value="<?= htmlspecialchars($editRow['rfc'] ?? '') ?>" placeholder="XAXX010101000">
    </label>
    <label>Cedula profesional
      <input name="cedula" maxlength="20" value="<?= htmlspecialchars($editRow['cedula'] ?? '') ?>">
    </label>
    <label>Password <?= $editId ? '(dejar vacio para no cambiar)' : '' ?>
      <input type="password" name="password" <?= $editId?'':'required' ?> minlength="8" pattern="(?=.*[A-Za-zÁÉÍÓÚáéíóúÑñ])(?=.*\d).{8,}" title="Mínimo 8 caracteres, con al menos una letra y un número">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" <?= $clinicaForm <= 0 ? 'disabled' : '' ?>><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url('medicos') ?>">Cancelar</button><?php  endif; ?>
    </div>
  </form>
  <?php if ($editId): ?>
    <form method="post" action="<?= url('medicos/asignarClinica') ?>" class="form-grid" style="margin-top:1rem"><?= csrf_field() ?>
      <input type="hidden" name="id_MEDICO" value="<?= (int)$editId ?>">
      <label>Asignar clinica
        <select name="id_CLINICA" required>
          <option value="">-- seleccione --</option>
          <?php foreach (($clinicasFiltro ?? []) as $cl):
                if (in_array((int)$cl['id_CLINICA'], $asignadasIds ?? [], true)) continue; ?>
            <option value="<?= (int)$cl['id_CLINICA'] ?>"><?= htmlspecialchars($cl['nombre']) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <div class="form-actions" style="grid-column:1/-1"><button class="btn">Asignar clinica</button></div>
    </form>
  <?php endif; ?>
</div>

<table class="data">
  <thead><tr><th>Usuario</th><th>Nombre</th><th>Email</th><th>Clinica</th><th>Clinicas asignadas</th><th>Activo</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php foreach ($rows as $m): $idU = (int)($m['id_USUARIOS'] ?? 0); ?>
      <tr>
        <td><?= htmlspecialchars($m['usuario'] ?? '') ?></td>
        <td><?= htmlspecialchars($m['nombre_completo'] ?? '') ?></td>
        <td><?= htmlspecialchars($m['email'] ?? '') ?></td>
        <td><?= htmlspecialchars($m['clinica'] ?? '') ?></td>
        <td>
          <?php $asg = ($clinicasPorMedico[$idU] ?? []); ?>
          <?php if (empty($asg)): ?>
            <span style="color:var(--c5)">Sin asignar</span>
          <?php else: ?>
            <div style="display:flex;flex-wrap:wrap;gap:.35rem">
              <?php foreach ($asg as $a): ?>
                <form method="post" action="<?= url('medicos/removerClinica') ?>" style="display:inline-flex;align-items:center;gap:.25rem"
                      onsubmit="return confirm('Eliminar la clinica <?= htmlspecialchars(addslashes((string)$a['nombre'])) ?> de este medico?')"><?= csrf_field() ?>
                  <input type="hidden" name="id_MEDICO" value="<?= $idU ?>">
                  <input type="hidden" name="id_USUARIOS_CLINICA" value="<?= (int)$a['id_USUARIOS_CLINICA'] ?>">
                  <input type="hidden" name="id_CLINICA" value="<?= (int)$a['id_CLINICA'] ?>">
                  <span><?= htmlspecialchars((string)$a['nombre']) ?></span>
                  <button class="btn btn-danger" style="padding:.1rem .4rem;line-height:1" title="Eliminar clinica">&times;</button>
                </form>
              <?php endforeach; ?>
            </div>
          <?php endif; ?>
        </td>
        <td><span class="badge <?= empty($m['activo'])?'off':'' ?>"><?= empty($m['activo']) ? 'No' : 'Si' ?></span></td>
        <td class="acts">
          <?php post_button('medicos', ['edit' => $idU], 'Editar', 'btn btn-sec'); ?>
          <?php if (!empty($m['activo'])): ?>
            <form method="post" action="<?= url('medicos/desactivar') ?>" style="display:inline" onsubmit="return confirm('Desactivar medico?')"><?= csrf_field() ?>
              <input type="hidden" name="id" value="<?= $idU ?>">
              <button class="btn btn-danger">Desactivar</button>
            </form>
          <?php else: ?>
            <form method="post" action="<?= url('medicos/activar') ?>" style="display:inline"><?= csrf_field() ?>
              <input type="hidden" name="id" value="<?= $idU ?>">
              <button class="btn">Activar</button>
            </form>
          <?php endif; ?>
        </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>