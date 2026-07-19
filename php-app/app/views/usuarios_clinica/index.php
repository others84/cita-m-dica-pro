<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Seleccionar usuario</h3>
  <form method="get" action="<?= url('usuariosClinica') ?>" class="form-grid">
    <label>Usuario
      <select name="id_USUARIO" onchange="this.form.submit()">
        <option value="">-- seleccione --</option>
        <?php foreach ($usuarios as $u): ?>
          <option value="<?= (int)$u['id_USUARIOS'] ?>" <?= (int)($idUsuario ?? 0)===(int)$u['id_USUARIOS']?'selected':'' ?>>
            <?= htmlspecialchars(($u['nombre_completo'] ?? $u['nombre'] ?? $u['usuario']) . ' (' . ($u['usuario'] ?? '') . ') - ' . ($u['rol'] ?? '')) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>

<?php if ($usuarioSel): ?>
  <div class="card" style="margin-bottom:1rem">
    <h2 style="margin-top:0">Asignar clínica</h2>
    <form method="post" action="<?= url('usuariosClinica/asignar') ?>" class="form-grid">
      <input type="hidden" name="id_USUARIO" value="<?= (int)$usuarioSel['id_USUARIOS'] ?>">
      <label>Clínica
        <select name="id_CLINICA" required>
          <option value="">-- seleccione --</option>
          <?php foreach ($clinicasAdmin as $cl):
              if (in_array((int)$cl['id_CLINICA'], $asignadasIds, true)) continue; ?>
            <option value="<?= (int)$cl['id_CLINICA'] ?>"><?= htmlspecialchars($cl['nombre']) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <div class="form-actions" style="grid-column:1/-1">
        <button class="btn">Asignar</button>
      </div>
    </form>
  </div>

  <h3>Clínicas asignadas a <?= htmlspecialchars($usuarioSel['nombre_completo'] ?? $usuarioSel['usuario']) ?></h3>
  <table class="data">
    <thead><tr><th>Clínica</th><th>Acciones</th></tr></thead>
    <tbody>
      <?php if (empty($asignadas)): ?>
        <tr><td colspan="2">Sin clínicas asignadas.</td></tr>
      <?php else: foreach ($asignadas as $r): ?>
        <tr>
          <td><?= htmlspecialchars($r['nombre']) ?></td>
          <td class="acts">
            <form method="post" action="<?= url('usuariosClinica/remover') ?>" style="display:inline"
                  onsubmit="return confirm('¿Remover el acceso a esta clínica?');">
              <input type="hidden" name="id_USUARIO" value="<?= (int)$usuarioSel['id_USUARIOS'] ?>">
              <input type="hidden" name="id_USUARIOS_CLINICA" value="<?= (int)($r['id_USUARIOS_CLINICA'] ?? 0) ?>">
              <input type="hidden" name="id_CLINICA" value="<?= (int)$r['id_CLINICA'] ?>">
              <button class="btn btn-danger">Remover</button>
            </form>
          </td>
        </tr>
      <?php endforeach; endif; ?>
    </tbody>
  </table>
<?php endif; ?>