<?php $controller='citasespera'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<?php
  $rol = $rol ?? ($_SESSION['user']['rol'] ?? '');
  $fmt = fn($v, string $f, int $n) => $v instanceof DateTime ? $v->format($f) : substr((string)$v, 0, $n);
  $dfmt = fn(string $ymd) => $ymd !== '' ? date('d/m/Y', strtotime($ymd)) : '';
  $dias = ['Sun'=>'Dom','Mon'=>'Lun','Tue'=>'Mar','Wed'=>'Mié','Thu'=>'Jue','Fri'=>'Vie','Sat'=>'Sáb'];
?>

<?php if (!empty($medicos)): ?>
<div class="card" style="margin-bottom:1rem">
  <form method="post" action="<?= url('citasespera/filtrar') ?>" class="form-grid"><?= csrf_field() ?>
    <label>Médico
      <select name="f_medico" onchange="this.form.submit()">
        <option value="">-- todos --</option>
        <?php foreach ($medicos as $m): ?>
          <option value="<?= (int)$m['id_USUARIOS'] ?>" <?= (int)($fMedico ?? 0) === (int)$m['id_USUARIOS'] ? 'selected' : '' ?>>
            <?= htmlspecialchars($m['nombre_completo'] ?? '') ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>
<?php endif; ?>

<?php if (!empty($movida)): $wa = wa_link($movida); ?>
<div class="card espera-aviso">
  <strong>Avise al paciente <?= htmlspecialchars((string)($movida['paciente'] ?? '')) ?> de su nueva fecha.</strong>
  <?php if ($wa !== ''): ?>
    <a class="btn" href="<?= htmlspecialchars($wa) ?>" target="_blank" rel="noopener">Enviar WhatsApp</a>
  <?php else: ?>
    <span style="color:var(--c4)">El paciente no tiene teléfono registrado.</span>
  <?php endif; ?>
</div>
<?php endif; ?>

<?php if (!empty($sel)):
  $sf = $fmt($sel['fecha_cita'], 'Y-m-d', 10); $shi = $fmt($sel['hora_inicio'], 'H:i', 5); ?>
<div class="card espera-panel">
  <div class="toolbar" style="margin-bottom:.5rem">
    <h3 style="margin:0;color:var(--c5)">Adelantar cita de <?= htmlspecialchars((string)($sel['paciente'] ?? '')) ?></h3>
    <?php post_button('citasespera/cerrar', [], 'Cerrar', 'btn btn-sec'); ?>
  </div>
  <p style="margin-top:0;color:var(--c4)">
    Fecha actual: <strong><?= htmlspecialchars($dfmt($sf) . ' ' . $shi) ?></strong> · Dr. <?= htmlspecialchars((string)($sel['medico'] ?? '')) ?>.
    Elija un horario libre anterior:
  </p>
  <?php if (empty($libres)): ?>
    <p class="flash flash-info">No hay horarios libres antes de la fecha actual de la cita.</p>
  <?php else: ?>
    <form method="post" action="<?= url('citasespera/mover') ?>"><?= csrf_field() ?>
      <input type="hidden" name="id" value="<?= (int)$sel['id_CITA'] ?>">
      <div class="espera-dias">
        <?php foreach ($libres as $dia => $horas): $ts = strtotime($dia); ?>
          <div class="espera-dia">
            <div class="espera-dia-tit"><?= htmlspecialchars(($dias[date('D', $ts)] ?? '') . ' ' . date('d/m', $ts)) ?></div>
            <div class="espera-horas">
              <?php foreach ($horas as $h): ?>
                <label class="espera-slot"><input type="radio" name="slot" value="<?= htmlspecialchars($dia . ' ' . $h) ?>" required><span><?= htmlspecialchars($h) ?></span></label>
              <?php endforeach; ?>
            </div>
          </div>
        <?php endforeach; ?>
      </div>
      <label class="espera-check" style="display:flex;align-items:center;gap:.5rem;margin-top:.75rem">
        <input type="checkbox" name="en_espera" value="1" checked>
        En espera de un espacio anterior (desmarque si ya no se va a mover más)
      </label>
      <div class="form-actions" style="margin-top:.75rem">
        <button class="btn" type="submit" onclick="return confirm('¿Mover la cita al horario elegido?');">Mover cita</button>
      </div>
    </form>
  <?php endif; ?>
</div>
<?php endif; ?>

<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)">Citas en espera</h2>
</div>
<p style="color:var(--c4);margin:.25rem 0 1rem">Pacientes que quieren adelantar su cita si se libera un espacio. Aparece primero quien lo pidió antes.</p>

<div class="table-responsive">
<table class="data tabla-citas">
  <thead>
    <tr><th>En espera desde</th><th>Paciente</th><th>Teléfono</th><th>Médico</th><th>Especialidad</th><th>Fecha actual</th><th>Se puede adelantar</th><th>Acciones</th></tr>
  </thead>
  <tbody>
    <?php if (empty($citas)): ?>
      <tr><td colspan="8" style="text-align:center;padding:1rem;color:var(--c4)">No hay citas en espera.</td></tr>
    <?php else: foreach ($citas as $c):
      $f = $fmt($c['fecha_cita'], 'Y-m-d', 10);
      $hi = $fmt($c['hora_inicio'], 'H:i', 5); $hf = $fmt($c['hora_fin'], 'H:i', 5);
      $diasAd = max(0, (int)floor((strtotime($f) - strtotime($hoy)) / 86400));
      $desde = (string)($c['fecha_en_espera'] ?? '');
    ?>
      <tr<?= !empty($sel) && (int)$sel['id_CITA'] === (int)$c['id_CITA'] ? ' class="cita-por-notificar"' : '' ?>>
        <td><?= htmlspecialchars($desde !== '' ? date('d/m/Y', strtotime($desde)) : '') ?></td>
        <td><?= htmlspecialchars((string)($c['paciente'] ?? '')) ?></td>
        <td><?= htmlspecialchars((string)($c['celular_notif'] ?? '')) ?></td>
        <td><?= htmlspecialchars((string)($c['medico'] ?? '')) ?></td>
        <td><?= htmlspecialchars((string)($c['especialidad'] ?? '')) ?></td>
        <td><?= htmlspecialchars($dfmt($f) . ' ' . $hi . ' - ' . $hf) ?></td>
        <td><?= $diasAd ?> día(s)</td>
        <td class="acts">
          <?php post_button('citasespera/adelantar', ['id' => (int)$c['id_CITA']], 'Adelantar', 'btn'); ?>
          <?php post_button('citasespera/quitar', ['id' => (int)$c['id_CITA']], 'Quitar de espera', 'btn btn-sec', '¿Quitar esta cita de la lista de espera?'); ?>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>
</div>
