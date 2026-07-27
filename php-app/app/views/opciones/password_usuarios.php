<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0;color:var(--c5)">Cambiar contraseña de un usuario</h2>
  <p style="color:var(--c4);margin-top:0">Solo se muestran los usuarios de las clínicas a las que tienes acceso.</p>
  <form method="post" action="<?= url('opciones/passwordUsuariosGuardar') ?>" class="form-grid">
    <label>Usuario
      <select name="id_USUARIO" required>
        <option value="">-- selecciona --</option>
        <?php foreach ($usuarios as $u): ?>
          <option value="<?= (int)$u['id_USUARIOS'] ?>" <?= isset($usuarioSel) && $usuarioSel && (int)$usuarioSel['id_USUARIOS'] === (int)$u['id_USUARIOS'] ? 'selected' : '' ?>>
            <?= htmlspecialchars($u['usuario']) ?> — <?= htmlspecialchars($u['nombre_completo'] ?? '') ?> (<?= htmlspecialchars($u['rol'] ?? '') ?>)
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Nueva contraseña
      <input type="password" name="nueva" required minlength="4" autocomplete="new-password">
    </label>
    <label>Confirmar nueva contraseña
      <input type="password" name="confirmacion" required minlength="4" autocomplete="new-password">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit" onclick="return confirm('¿Cambiar la contraseña de este usuario?')">Actualizar contraseña</button>
    </div>
  </form>
</div>

<table class="data">
  <thead><tr><th>Usuario</th><th>Nombre</th><th>Rol</th><th>Clínica</th><th>Activo</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php foreach ($usuarios as $u): ?>
      <tr>
        <td><?= htmlspecialchars($u['usuario']) ?></td>
        <td><?= htmlspecialchars($u['nombre_completo'] ?? '') ?></td>
        <td><?= htmlspecialchars($u['rol'] ?? '') ?></td>
        <td><?= htmlspecialchars($u['clinica'] ?? '—') ?></td>
        <td><span class="badge <?= empty($u['activo'])?'off':'' ?>"><?= empty($u['activo'])?'No':'Si' ?></span></td>
        <td class="acts">
          <?php post_button('opciones/passwordUsuarios', ['id_USUARIO' => (int)$u['id_USUARIOS']], 'Cambiar contraseña', 'btn btn-sec'); ?>
        </td>
      </tr>
    <?php endforeach; ?>
    <?php if (empty($usuarios)): ?>
      <tr><td colspan="6">No hay usuarios en tus clínicas.</td></tr>
    <?php endif; ?>
  </tbody>
</table>