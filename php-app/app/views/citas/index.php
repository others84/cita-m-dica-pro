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
<div class="table-responsive">
<table class="data tabla-citas<?= $ordClass ?>">
  <thead>
    <tr>
      <?php $th('fecha','Fecha'); $th('hora','Hora'); $th('paciente','Paciente'); $th('medico','Medico');
            $th('especialidad','Especialidad'); $th('consultorio','Consultorio'); ?><th>Estado</th><th>Precio</th>
      <th>Observaciones</th><th>Observaciones paciente</th><th>Notificado</th><th>Acciones</th>
    </tr>
  </thead>
  <tbody>
    <?php if (empty($citas)): ?>
      <tr><td colspan="12" style="text-align:center;padding:1rem;color:var(--c4)">Sin citas en el rango.</td></tr>
    <?php else: foreach ($citas as $c):
        $f  = $c['fecha_cita']  instanceof DateTime ? $c['fecha_cita']->format('Y-m-d')   : substr((string)$c['fecha_cita'],0,10);
        $hi = $c['hora_inicio'] instanceof DateTime ? $c['hora_inicio']->format('H:i')    : substr((string)$c['hora_inicio'],0,5);
        $hf = $c['hora_fin']    instanceof DateTime ? $c['hora_fin']->format('H:i')      : substr((string)$c['hora_fin'],0,5);
        $obs = trim((string)($c['observaciones'] ?? ''));
        $obsCorta = mb_strlen($obs) > 40 ? mb_substr($obs, 0, 40) . '...' : $obs;
        $obsPac = trim((string)($c['observaciones_paciente'] ?? ''));
        $obsPacCorta = mb_strlen($obsPac) > 40 ? mb_substr($obsPac, 0, 40) . '...' : $obsPac;
        $estadoNom = strtolower(trim((string)($c['estado'] ?? '')));
        $notificado = (int)($c['notificado'] ?? 0) === 1;
        $porNotificar = CitaModel::enVentanaNotificacion($c);
    ?>
      <tr<?= $porNotificar ? ' class="cita-por-notificar"' : '' ?>>
        <td><?= htmlspecialchars($f) ?></td>
        <td><?= htmlspecialchars($hi . ' - ' . $hf) ?></td>
        <td><?= htmlspecialchars($c['paciente'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['medico'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['especialidad'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['consultorio'] ?? '') ?></td>
        <td><span class="badge"><?= htmlspecialchars($c['estado'] ?? '') ?></span></td>
        <td>$<?= number_format((float)($c['precio'] ?? 0), 2) ?></td>
        <td title="<?= htmlspecialchars($obs) ?>"><?= htmlspecialchars($obsCorta) ?></td>
        <td title="<?= htmlspecialchars($obsPac) ?>"><?= htmlspecialchars($obsPacCorta) ?></td>
        <td><span class="badge"><?= $notificado ? 'Sí' : 'No' ?></span></td>
        <td class="acts">
          <?php $cancelada = in_array($estadoNom, ['cancelada','cancelado'], true); ?>
          <?php $atendida = in_array($estadoNom, ['atendida','atendido'], true); ?>
          <?php $notifWa = (int)($c['notifica_wa'] ?? 0) === 1; ?>
          <?php $notifMail = (int)($c['notifica_email'] ?? 0) === 1; ?>
          <?php $mailPac = trim((string)($c['email_notif'] ?? '')); ?>
          <?php if (!$cancelada && !$atendida && !$notificado && $porNotificar): ?>
            <?php $wa = $notifWa ? wa_link($c) : ''; ?>
            <?php if ($wa !== ''): ?>
              <button class="btn btn-sec" type="button"
                 data-wa="<?= htmlspecialchars($wa, ENT_QUOTES) ?>"
                 onclick="fetch('<?= url('citas/waLog') ?>',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'_csrf=<?= rawurlencode(csrf_token()) ?>&id=<?= (int)$c['id_CITA'] ?>'});window.open(this.dataset.wa,'_blank','noopener');">WhatsApp</button>
            <?php elseif ($notifWa): ?>
              <button class="btn btn-sec" type="button" disabled title="El paciente no tiene telefono registrado">Sin teléfono</button>
            <?php endif; ?>
            <?php $ml = $notifMail ? mail_link($c) : ''; ?>
            <?php if ($ml !== ''): ?>
              <button class="btn btn-sec" type="button"
                 data-mail="<?= htmlspecialchars($ml, ENT_QUOTES) ?>"
                 onclick="fetch('<?= url('citas/emailLog') ?>',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'_csrf=<?= rawurlencode(csrf_token()) ?>&id=<?= (int)$c['id_CITA'] ?>'});window.location.href=this.dataset.mail;">Email</button>
            <?php elseif ($notifMail): ?>
              <button class="btn btn-sec" type="button" disabled title="El paciente no tiene correo registrado">Sin correo</button>
            <?php endif; ?>
            <?php post_button('citas/notificado', ['id' => (int)$c['id_CITA']], 'Notificado', 'btn btn-sec', '¿Marcar esta cita como notificada?'); ?>
          <?php endif; ?>
          <?php if ($cancelada || $atendida): ?>
            <span style="color:var(--c4)">&mdash;</span>
          <?php elseif (($rol ?? '') === 'medico'): ?>
            <?php if (in_array($estadoNom, ['agendada','agendado'], true)): ?>
              <?php post_button('citas/confirmar', ['id' => (int)$c['id_CITA']], 'Confirmar', 'btn', '¿Confirmar esta cita?'); ?>
              <?php post_button('citas/horarioForm', ['id' => (int)$c['id_CITA']], 'Hora fin', 'btn btn-sec'); ?>

            <?php elseif (in_array($estadoNom, ['confirmada','confirmado'], true)): ?>
              <?php post_button('citas/atenderForm', ['id' => (int)$c['id_CITA']], 'Atender', 'btn'); ?>
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
</div>

<?php $paginas = (int)($paginas ?? 1); $pag = (int)($pag ?? 1); ?>
<?php if (($totalCitas ?? 0) > 0): ?>
<div class="pager" style="display:flex;align-items:center;gap:.4rem;flex-wrap:wrap;margin-top:.75rem">
  <span style="color:var(--c4)">
    Página <?= $pag ?> de <?= $paginas ?> · <?= (int)$totalCitas ?> citas
  </span>
  <?php if ($pag > 1): ?>
    <?php post_button('citas/pagina', ['pag' => 1], '«', 'btn btn-sec'); ?>
    <?php post_button('citas/pagina', ['pag' => $pag - 1], '‹', 'btn btn-sec'); ?>
  <?php endif; ?>
  <?php
    $ini = max(1, $pag - 2); $fin = min($paginas, $ini + 4); $ini = max(1, $fin - 4);
    for ($i = $ini; $i <= $fin; $i++) {
        post_button('citas/pagina', ['pag' => $i], (string)$i, $i === $pag ? 'btn' : 'btn btn-sec');
    }
  ?>
  <?php if ($pag < $paginas): ?>
    <?php post_button('citas/pagina', ['pag' => $pag + 1], '›', 'btn btn-sec'); ?>
    <?php post_button('citas/pagina', ['pag' => $paginas], '»', 'btn btn-sec'); ?>
  <?php endif; ?>
</div>
<?php endif; ?>