<?php
  $p = $paciente ?? [];
  $nom = trim(($p['ap_paterno'] ?? '') . ' ' . ($p['ap_materno'] ?? '') . ' ' . ($p['nombre'] ?? ''));
  $fn = $p['fecha_nacimiento'] ?? '';
  if ($fn instanceof DateTime) $fn = $fn->format('Y-m-d');
  $fn = $fn ? substr((string)$fn, 0, 10) : '';
  $edad = '';
  if ($fn !== '') { try { $edad = (new DateTime($fn))->diff(new DateTime())->y . ' años'; } catch (Throwable $e) {} }
  $norm = fn($s) => strtr(mb_strtolower(trim((string)$s)), ['á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u']);
  $tot = ['atendida'=>0,'cancelada'=>0,'noasistio'=>0,'pendiente'=>0];
  foreach (($citas ?? []) as $c) {
      $e = $norm($c['estado'] ?? '');
      if (strpos($e, 'atendid') !== false) $tot['atendida']++;
      elseif (strpos($e, 'cancelad') !== false) $tot['cancelada']++;
      elseif (strpos($e, 'asisti') !== false) $tot['noasistio']++;
      else $tot['pendiente']++;
  }
  $flecha = ($dir ?? 'asc') === 'asc' ? ' ▲' : ' ▼';
?>
<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)">Historial del paciente</h2>
  <a class="btn btn-sec" href="<?= url($desde === 'citas' ? 'citas' : 'pacientes') ?>">Regresar</a>
</div>

<div class="card hist-paciente">
  <h3 style="margin:0 0 .4rem;color:var(--c5)"><?= htmlspecialchars($nom) ?></h3>
  <div class="hist-datos">
    <span><strong>Teléfono:</strong> <?= htmlspecialchars($p['telefono'] ?? '-') ?></span>
    <span><strong>Fecha de nacimiento:</strong> <?= htmlspecialchars($fn !== '' ? date('d/m/Y', strtotime($fn)) : '-') ?></span>
    <?php if ($edad !== ''): ?><span><strong>Edad:</strong> <?= htmlspecialchars($edad) ?></span><?php endif; ?>
  </div>
  <div class="hist-resumen">
    <div><b><?= count($citas ?? []) ?></b><small>Total</small></div>
    <div><b><?= $tot['atendida'] ?></b><small>Atendidas</small></div>
    <div><b><?= $tot['cancelada'] ?></b><small>Canceladas</small></div>
    <div><b><?= $tot['noasistio'] ?></b><small>No asistió</small></div>
    <div><b><?= $tot['pendiente'] ?></b><small>Pendientes</small></div>
  </div>
</div>

<?php if (!empty($errorCarga)): ?>
  <div class="flash flash-error">No se pudieron cargar las citas: <?= htmlspecialchars($errorCarga) ?></div>
<?php endif; ?>

<div class="table-responsive">
<table class="data tabla-citas">
  <thead>
    <tr>
      <th class="col-ordenada"><?php post_button('pacientes/historialOrden', [], 'Fecha' . $flecha, 'sort-btn'); ?></th>
      <th>Hora</th><th>Medico</th><th>Especialidad</th><th>Consultorio</th><th>Estado</th><th>Precio</th><th>Observaciones</th>
    </tr>
  </thead>
  <tbody>
    <?php if (empty($citas)): ?>
      <tr><td colspan="8" style="text-align:center;padding:1rem;color:var(--c4)">Este paciente no tiene citas registradas.</td></tr>
    <?php else: foreach ($citas as $c):
        $f  = $c['fecha_cita']  instanceof DateTime ? $c['fecha_cita']->format('Y-m-d') : substr((string)$c['fecha_cita'], 0, 10);
        $hi = $c['hora_inicio'] instanceof DateTime ? $c['hora_inicio']->format('H:i')  : substr((string)$c['hora_inicio'], 0, 5);
        $hf = $c['hora_fin']    instanceof DateTime ? $c['hora_fin']->format('H:i')     : substr((string)$c['hora_fin'], 0, 5);
    ?>
      <tr>
        <td><?= htmlspecialchars($f) ?></td>
        <td><?= htmlspecialchars($hi . ' - ' . $hf) ?></td>
        <td><?= htmlspecialchars($c['medico'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['especialidad'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['consultorio'] ?? '') ?></td>
        <td><span class="badge"><?= htmlspecialchars($c['estado'] ?? '') ?></span></td>
        <td>$<?= number_format((float)($c['precio'] ?? 0), 2) ?></td>
        <td style="white-space:pre-wrap"><?= htmlspecialchars(trim((string)($c['observaciones'] ?? ''))) ?></td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>
</div>
