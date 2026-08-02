<?php $controller='citas'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<?php
  $rol = $rol ?? ($_SESSION['user']['rol'] ?? '');
  $ord = $ord ?? 'fecha';
  $dir = $dir ?? 'asc';
  $colIndex = ['fecha'=>1,'hora'=>2,'paciente'=>3,'medico'=>4,'especialidad'=>5,'consultorio'=>6];
  $th = function (string $col, string $label) use ($ord, $dir) {
      $flecha = $ord === $col ? ($dir === 'asc' ? ' ▲' : ' ▼') : '';
      $cls = $ord === $col ? ' class="col-ordenada"' : '';
      echo '<th'.$cls.'>';
      post_button('citas/ordenar', ['ord' => $col], $label . $flecha, 'sort-btn');
      echo '</th>';
  };
?>
<?php if ($rol !== 'medico'): ?>
<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Filtros de citas</h3>
  <form method="post" action="<?= url('citas/filtrar') ?>" class="form-grid"><?= csrf_field() ?>
    <label>Fecha
      <input type="date" name="f_fecha" value="<?= htmlspecialchars((string)($fFecha ?? '')) ?>" onchange="this.form.submit()">
    </label>
    <label>Estado de la cita
      <select name="f_estado" onchange="this.form.submit()">
        <option value="">-- todos --</option>
        <?php foreach (($estados ?? []) as $e): ?>
          <option value="<?= (int)$e['id_CATALOGO_ESTADO_CITAS'] ?>" <?= (int)($fEstado ?? 0) === (int)$e['id_CATALOGO_ESTADO_CITAS'] ? 'selected' : '' ?>>
            <?= htmlspecialchars($e['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
  <div style="margin-top:.5rem">
    <?php post_button('citas/filtrar', ['f_fecha' => '', 'f_estado' => ''], 'Limpiar filtros', 'btn btn-sec'); ?>
  </div>
</div>
<?php endif; ?>
<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)">Citas registradas</h2>
  <a class="btn" href="<?= url('citas/nueva') ?>">+ Agendar cita</a>
</div>

<?php $ordClass = isset($colIndex[$ord]) ? ' ord-col-'.$colIndex[$ord] : ''; ?>
<table class="data<?= $ordClass ?>">
  <thead>
    <tr>
      <?php $th('fecha','Fecha'); $th('hora','Hora'); $th('paciente','Paciente'); $th('medico','Medico');
            $th('especialidad','Especialidad'); $th('consultorio','Consultorio'); ?><th>Estado</th><th>Precio</th>
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
        $estadoNom = strtolower(trim((string)($c['estado'] ?? '')));
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
          <?php if (($rol ?? '') === 'medico'): ?>
            <?php if (in_array($estadoNom, ['agendada','agendado'], true)): ?>
              <?php post_button('citas/confirmar', ['id' => (int)$c['id_CITA']], 'Confirmar', 'btn', '¿Confirmar esta cita?'); ?>
            <?php elseif (in_array($estadoNom, ['confirmada','confirmado'], true)): ?>
              <?php post_button('citas/atendida', ['id' => (int)$c['id_CITA']], 'Atendida', 'btn', '¿Marcar esta cita como Atendida?'); ?>
            <?php endif; ?>
          <?php else: ?>
            <?php post_button('citas/editar', ['id' => (int)$c['id_CITA']], 'Editar', 'btn btn-sec'); ?>
            <?php post_button('citas/cancelarForm', ['id' => (int)$c['id_CITA']], 'Cancelada', 'btn btn-sec'); ?>
            <?php post_button('citas/noAsistio', ['id' => (int)$c['id_CITA']], 'No asistió', 'btn btn-sec', '¿Cambiar el estatus de esta cita a "No asistió"?'); ?>
          <?php endif; ?>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>