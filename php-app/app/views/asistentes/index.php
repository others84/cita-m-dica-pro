<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)">Asistentes registrados</h2>
  <a class="btn" href="<?= url('catalogos/usuarios') ?>">Administrar usuarios</a>
</div>
<table class="data">
  <thead><tr><th>ID</th><th>Usuario</th><th>Nombre</th><th>Email</th><th>Activo</th></tr></thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="5" style="text-align:center;color:var(--c4);padding:1rem">Sin asistentes</td></tr>
    <?php else: foreach ($rows as $u): ?>
      <tr>
        <td><?= (int)$u['id_USUARIOS'] ?></td>
        <td><?= htmlspecialchars($u['usuario']) ?></td>
        <td><?= htmlspecialchars($u['nombre_completo']) ?></td>
        <td><?= htmlspecialchars($u['email'] ?? '') ?></td>
        <td><span class="badge <?= empty($u['activo'])?'off':'' ?>"><?= empty($u['activo'])?'No':'Si' ?></span></td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>