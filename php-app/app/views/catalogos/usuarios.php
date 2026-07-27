<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar usuario #' . (int)$editId : 'Nuevo usuario' ?></h2>
  <form method="post" action="<?= url('catalogos/usuariosGuardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Usuario
      <input name="usuario" required maxlength="50" value="<?= htmlspecialchars($editRow['usuario'] ?? '') ?>" <?= $editId?'readonly':'' ?>>
    </label>
    <label>Nombre completo <input name="nombre_completo" required value="<?= htmlspecialchars($editRow['nombre_completo'] ?? '') ?>"></label>
    <label>Email <input type="email" name="email" value="<?= htmlspecialchars($editRow['email'] ?? '') ?>"></label>
    <label>Rol
      <select name="id_ROLES" required>
        <?php foreach ($roles as $r): ?>
          <option value="<?= (int)$r['id_ROLES'] ?>" <?= isset($editRow)&&(int)($editRow['id_ROLES']??0)===(int)$r['id_ROLES']?'selected':'' ?>>
            <?= htmlspecialchars($r['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Clinica
      <select name="id_CLINICA">
        <option value="">-- ninguna --</option>
        <?php foreach ($clinicas as $cl): ?>
          <option value="<?= (int)$cl['id_CLINICA'] ?>" <?= isset($editRow)&&(int)($editRow['id_CLINICA']??0)===(int)$cl['id_CLINICA']?'selected':'' ?>>
            <?= htmlspecialchars($cl['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Password <?= $editId ? '(dejar vacio para no cambiar)' : '' ?>
      <input type="password" name="password" <?= $editId?'':'required' ?> minlength="4">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId?'Actualizar':'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url('catalogos/usuarios') ?>">Cancelar</button><?php  endif; ?>
    </div>
  </form>
</div>
<table class="data">
  <thead><tr><th>Usuario</th><th>Nombre</th><th>Rol</th><th>Clinica</th><th>Activo</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php foreach ($rows as $u): ?>
      <tr>
        <td><?= htmlspecialchars($u['usuario']) ?></td>
        <td><?= htmlspecialchars($u['nombre_completo']) ?></td>
        <td><?= htmlspecialchars($u['rol'] ?? '') ?></td>
        <td><?= htmlspecialchars($u['clinica'] ?? '—') ?></td>
        <td><span class="badge <?= empty($u['activo'])?'off':'' ?>"><?= empty($u['activo'])?'No':'Si' ?></span></td>
        <td class="acts">
          <?php post_button('catalogos/usuarios', ['edit' => (int)$u['id_USUARIOS']], 'Editar', 'btn btn-sec'); ?>
          <?php if (!empty($u['activo'])): ?>
            <form method="post" action="<?= url('catalogos/usuariosDesactivar') ?>" style="display:inline"><?= csrf_field() ?>
              <input type="hidden" name="id" value="<?= (int)$u['id_USUARIOS'] ?>"><button class="btn btn-danger">Desactivar</button>
            </form>
          <?php else: ?>
            <form method="post" action="<?= url('catalogos/usuariosActivar') ?>" style="display:inline"><?= csrf_field() ?>
              <input type="hidden" name="id" value="<?= (int)$u['id_USUARIOS'] ?>"><button class="btn">Activar</button>
            </form>
          <?php endif; ?>
        </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>