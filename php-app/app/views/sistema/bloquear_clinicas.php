<table class="data">
  <thead>
    <tr>
      <th>Clinica</th>
      <th>Usuarios</th>
      <th>Pacientes</th>
      <th>Citas</th>
      <th>Estado</th>
      <th style="width:180px">Accion</th>
    </tr>
  </thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="6" style="text-align:center;color:var(--c4);padding:1rem">Sin clinicas</td></tr>
    <?php else: foreach ($rows as $c): ?>
      <tr>
        <td><?= htmlspecialchars($c['nombre']) ?></td>
        <td><?= (int)$c['total_usuarios'] ?></td>
        <td><?= (int)$c['total_pacientes'] ?></td>
        <td><?= (int)$c['total_citas'] ?></td>
        <td><span class="badge <?= empty($c['activo'])?'off':'' ?>"><?= empty($c['activo'])?'Bloqueada':'Activa' ?></span></td>
        <td class="acts">
          <?php if (!empty($c['activo'])): ?>
            <form method="post" action="<?= url('sistema/bloquear') ?>" style="display:inline" onsubmit="return confirm('Bloquear acceso a la clinica?')">
              <input type="hidden" name="id" value="<?= (int)$c['id_CLINICA'] ?>">
              <button class="btn btn-danger">Bloquear</button>
            </form>
          <?php else: ?>
            <form method="post" action="<?= url('sistema/desbloquear') ?>" style="display:inline">
              <input type="hidden" name="id" value="<?= (int)$c['id_CLINICA'] ?>">
              <button class="btn">Desbloquear</button>
            </form>
          <?php endif; ?>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>
