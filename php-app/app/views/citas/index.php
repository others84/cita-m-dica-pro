<?php $controller='citas'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)">Citas registradas</h2>
  <a class="btn" href="<?= url('citas/nueva') ?>">+ Agendar cita</a>
</div>

<table class="data">
  <thead>
    <tr>
      <th>Fecha</th><th>Hora</th><th>Paciente</th><th>Medico</th>
      <th>Especialidad</th><th>Consultorio</th><th>Estado</th><th>Precio</th>
      <th>Observaciones</th><th>Acciones</th>
    </tr>
  </thead>
  <tbody>
    <?php if (empty($citas)): ?>
      <tr><td colspan="10" style="text-align:center;padding:1rem;color:var(--c4)">Sin citas en el rango.</td></tr>
    <?php else: foreach ($citas as $c):
        $f  = $c['fecha_cita']  instanceof DateTime ? $c['fecha_cita']->format('Y-m-d')   : substr((string)$c['fecha_cita'],0,10);
        $hi = $c['hora_inicio'] instanceof DateTime ? $c['hora_inicio']->format('H:i')    : substr((string)$c['hora_inicio'],0,5);
        $hf = $c['hora_fin']    instanceof DateTime ? $c['hora_fin']->format('H:i')      : substr((string)$c['hora_fin'],0,5);
        $obs = trim((string)($c['observaciones'] ?? ''));
        $obsCorta = mb_strlen($obs) > 40 ? mb_substr($obs, 0, 40) . '...' : $obs;
    ?>
      <tr>
        <td><?= htmlspecialchars($f) ?></td>
        <td><?= htmlspecialchars($hi . ' - ' . $hf) ?></td>
        <td><?= htmlspecialchars($c['paciente'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['medico'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['especialidad'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['consultorio'] ?? '') ?></td>
        <td><span class="badge"><?= htmlspecialchars($c['estado'] ?? '') ?></span></td>
        <td>$<?= number_format((float)($c['precio'] ?? 0), 2) ?></td>
        <td title="<?= htmlspecialchars($obs) ?>"><?= htmlspecialchars($obsCorta) ?></td>
        <td class="acts">
          <?php post_button('citas/editar', ['id' => (int)$c['id_CITA']], 'Editar', 'btn btn-sec'); ?>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>