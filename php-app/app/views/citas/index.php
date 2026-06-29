<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)">Citas registradas</h2>
  <a class="btn" href="<?= url('citas/nueva') ?>">+ Agendar cita</a>
</div>

<table class="data">
  <thead>
    <tr>
      <th>ID</th><th>Fecha</th><th>Hora</th><th>Paciente</th><th>Medico</th>
      <th>Especialidad</th><th>Consultorio</th><th>Estado</th><th>Precio</th><th>Acciones</th>
    </tr>
  </thead>
  <tbody>
    <?php if (empty($citas)): ?>
      <tr><td colspan="10" style="text-align:center;padding:1rem;color:var(--c4)">Sin citas en el rango.</td></tr>
    <?php else: foreach ($citas as $c):
        $f  = $c['fecha_cita']  instanceof DateTime ? $c['fecha_cita']->format('Y-m-d')   : substr((string)$c['fecha_cita'],0,10);
        $hi = $c['hora_inicio'] instanceof DateTime ? $c['hora_inicio']->format('H:i')    : substr((string)$c['hora_inicio'],0,5);
        $hf = $c['hora_fin']    instanceof DateTime ? $c['hora_fin']->format('H:i')      : substr((string)$c['hora_fin'],0,5);
    ?>
      <tr>
        <td><?= (int)$c['id_CITA'] ?></td>
        <td><?= htmlspecialchars($f) ?></td>
        <td><?= htmlspecialchars($hi . ' - ' . $hf) ?></td>
        <td><?= htmlspecialchars($c['paciente'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['medico'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['especialidad'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['consultorio'] ?? '') ?></td>
        <td><span class="badge"><?= htmlspecialchars($c['estado'] ?? '') ?></span></td>
        <td>$<?= number_format((float)($c['precio'] ?? 0), 2) ?></td>
        <td class="acts">
          <a class="btn btn-sec" href="<?= url('citas/editar?id=' . (int)$c['id_CITA']) ?>">Editar</a>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>