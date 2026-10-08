<?php
$f  = $editRow['fecha_cita']  ?? '';
$hi = $editRow['hora_inicio'] ?? '';
$hf = $editRow['hora_fin']    ?? '';
if ($f  instanceof DateTime) $f  = $f->format('Y-m-d');
if ($hi instanceof DateTime) $hi = $hi->format('H:i');
if ($hf instanceof DateTime) $hf = $hf->format('H:i');
$f  = $f  ? substr((string)$f,0,10)  : '';
$hi = $hi ? substr((string)$hi,0,5) : '';
$hf = $hf ? substr((string)$hf,0,5) : '';
// Prellenado desde el calendario (solo citas nuevas).
$__pre = empty($editRow) ? ($_SESSION['ui']['citas']['prefill_vista'] ?? null) : null;
if (is_array($__pre)) {
    $f  = (string)($__pre['fecha'] ?? '');
    $hi = (string)($__pre['hora_inicio'] ?? '');
    $hf = (string)($__pre['hora_fin'] ?? '');
}
$__preMed = is_array($__pre) ? (int)($__pre['id_medico'] ?? 0) : 0;
$modo = $modo ?? 'edicion';
$soloCancelar = ($modo === 'cancelar');
$atender = ($modo === 'atender');
$horario = ($modo === 'horario');
$notifEditable = $notifEditable ?? true;   // solo citas agendadas permiten editar notificaciones
if ($horario) $notifEditable = false;
$dis = ($soloCancelar || $atender || $horario) ? ' disabled' : '';
$notifDis = $notifEditable ? '' : ' disabled';
$accion = $soloCancelar ? 'citas/cancelarGuardar' : ($atender ? 'citas/atenderGuardar' : ($horario ? 'citas/horarioGuardar' : 'citas/guardar'));

?>
<?php $controller='citas/nueva'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<div class="card">
  <h2 style="margin-top:0;color:var(--c5)"><?= $soloCancelar ? 'Cancelar cita #' . (int)$editId : ($atender ? 'Atencion de la cita #' . (int)$editId : ($horario ? 'Modificar hora fin de la cita #' . (int)$editId : ($editId ? 'Modificar cita #' . (int)$editId : 'Nueva cita'))) ?></h2>
  <?php if ($soloCancelar): ?>
    <p style="color:var(--c4);margin-top:0">Escriba el motivo de la cancelacion en Observaciones. Los demas campos no se pueden modificar.</p>
  <?php endif; ?>
  <?php if ($horario): ?>
    <p style="color:var(--c4);margin-top:0">Solo puede modificar la hora de finalizacion de la cita.</p>
  <?php endif; ?>

  <?php if ($atender): ?>
    <p style="color:var(--c4);margin-top:0">Revise la informacion de la cita y del paciente. Capture las observaciones y presione "Atendida" para cerrar la consulta.</p>
  <?php endif; ?>
  <form method="post" action="<?= url($accion) ?>" class="form-grid" id="form-cita"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <?php if (empty($editId)): ?><input type="hidden" name="alta_token" value="<?= bin2hex(random_bytes(16)) ?>"><?php endif; ?>

    <label>Paciente
      <select name="id_PACIENTE" id="sel_paciente" required<?= $dis ?>>
        <option value="">-- seleccione --</option>
        <?php foreach ($pacientes as $p):
          $nom = trim(($p['ap_paterno']??'') . ' ' . ($p['ap_materno']??'') . ' ' . ($p['nombre']??'')); ?>
          <option value="<?= (int)$p['id_PACIENTE'] ?>"
                  data-email="<?= htmlspecialchars((string)($p['email'] ?? '')) ?>"
                  data-tel="<?= htmlspecialchars((string)($p['telefono'] ?? '')) ?>"
                  data-obs="<?= htmlspecialchars((string)($p['observaciones'] ?? '')) ?>"
                  data-nemail="<?= !empty($p['notifica_email']) ? '1' : '0' ?>"
                  data-nwa="<?= !empty($p['notifica_wa']) ? '1' : '0' ?>"
                  <?= isset($editRow) && (int)($editRow['id_PACIENTE']??0)===(int)$p['id_PACIENTE'] ? 'selected':'' ?>>
            <?= htmlspecialchars($nom) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>

    <label>Medico
      <select name="id_MEDICO" id="sel_medico" required<?= $dis ?>>
        <option value="">-- seleccione --</option>
        <?php foreach ($medicos as $m):
          $idm = (int)($m['id_USUARIOS'] ?? 0); ?>
          <option value="<?= $idm ?>" <?= (isset($editRow) && (int)($editRow['id_MEDICO']??0)===$idm) || ($__preMed && $__preMed===$idm) ? 'selected':'' ?>>
            <?= htmlspecialchars((string)($m['nombre_completo'] ?? $m['usuario'] ?? '')) ?>
          </option>
        <?php endforeach; ?>
        <?php if (empty($medicos)): ?>
          <option value="" disabled>Sin usuarios con perfil medico en esta clinica</option>
        <?php endif; ?>
      </select>
    </label>

    <label>Consultorio
      <select name="id_CONSULTORIO" required<?= $dis ?>>
        <option value="">-- seleccione --</option>
        <?php foreach ($consultorios as $co): ?>
          <option value="<?= (int)$co['id_CONSULTORIO'] ?>" <?= isset($editRow) && (int)($editRow['id_CONSULTORIO']??0)===(int)$co['id_CONSULTORIO'] ? 'selected':'' ?>>
            <?= htmlspecialchars($co['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>

    <label>Especialidad
      <select name="id_CATALOGO_ESPECIALIDAD" required<?= $dis ?>>
        <option value="">-- seleccione --</option>
        <?php foreach ($especialidades as $e): ?>
          <option value="<?= (int)$e['id_CATALOGO_ESPECIALIDAD'] ?>" <?= isset($editRow) && (int)($editRow['id_CATALOGO_ESPECIALIDAD']??0)===(int)$e['id_CATALOGO_ESPECIALIDAD'] ? 'selected':'' ?>>
            <?= htmlspecialchars($e['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>

    <label>Fecha
      <input type="date" name="fecha_cita" required value="<?= htmlspecialchars($f) ?>"<?= $dis ?>>
    </label>
    <label>Hora inicio
      <input type="time" name="hora_inicio" required value="<?= htmlspecialchars($hi) ?>"<?= $dis ?>>
    </label>
    <label>Hora fin
      <input type="time" name="hora_fin" required value="<?= htmlspecialchars($hf) ?>"<?= $horario ? ' autofocus' : $dis ?>>

    </label>

    <label>Estado
      <select name="id_CATALOGO_ESTADO_CITAS" required<?= $dis ?>>
        <?php foreach ($estados as $es): ?>
          <option value="<?= (int)$es['id_CATALOGO_ESTADO_CITAS'] ?>"
            <?= isset($editRow) && (int)($editRow['id_CATALOGO_ESTADO_CITAS']??0)===(int)$es['id_CATALOGO_ESTADO_CITAS'] ? 'selected':'' ?>>
            <?= htmlspecialchars($es['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>

    <?php $__padDis = ($soloCancelar || $horario); ?>
    <div class="col-span pad-box">
      <span class="pad-titulo">Padecimientos <small style="color:var(--c4)">(opcional; el precio se llena con la suma)</small></span>
      <?php if (!$__padDis): ?><input type="hidden" name="pad_presente" value="1"><?php endif; ?>
      <div id="pad_lista" class="pad-lista"></div>
    </div>
    <script>
    window.PAD_DATA = <?= json_encode([
        'map' => $padMap ?? [],
        'sel' => array_map(fn($r) => ['id' => (int)$r['id_PADECIMIENTO'], 'nombre' => (string)$r['nombre'], 'precio' => (float)$r['precio']], $padSel ?? []),
        'dis' => $__padDis,
    ], JSON_HEX_TAG | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE) ?>;
    </script>

    <label>Precio
      <input type="number" name="precio" id="inp_precio" step="0.01" min="0" required
             value="<?= htmlspecialchars((string)($editRow['precio'] ?? '0.00')) ?>"<?= $atender ? '' : $dis ?>>
      <?php if ($atender): ?><small style="color:var(--c4)">Capture el precio de la consulta antes de marcarla como atendida.</small><?php endif; ?>
    </label>

    <label>Email notificacion
      <input type="email" id="email_notif" name="email_notif" readonly
             value="<?= htmlspecialchars((string)($editRow['email_notif'] ?? '')) ?>">
    </label>
    <label>Celular notificacion (WA)
      <input type="text" id="celular_notif" name="celular_notif" readonly
             value="<?= htmlspecialchars((string)($editRow['celular_notif'] ?? '')) ?>">
    </label>
    <label>Horas anticipacion
      <input type="number" name="horas_anticipacion_notif" min="0" max="240" value="<?= htmlspecialchars((string)($editRow['horas_anticipacion_notif'] ?? 24)) ?>"<?= $dis ?>>
    </label>

    <?php if (!$dis): ?>
    <label class="espera-check">
      <input type="hidden" name="espera_presente" value="1">
      <input type="checkbox" name="en_espera" value="1"<?= !empty($editRow['en_espera']) ? ' checked' : '' ?>>
      En espera de un espacio anterior (avisar si se libera un horario antes)
    </label>
    <?php endif; ?>

    <label style="grid-column:1/-1">Observaciones paciente <small id="obs_paciente_count" style="color:var(--c4,#1E3A5F);font-weight:400">(0/5000)</small>
      <textarea id="obs_paciente" name="observaciones_paciente" rows="3" maxlength="5000"<?= $horario ? ' disabled' : '' ?>><?= htmlspecialchars((string)($editRow['observaciones_paciente'] ?? '')) ?></textarea>
    </label>


    <label>Notificar por email
      <input type="checkbox" id="notif_email_txt" value="1" disabled<?= !empty($editRow['notifica_email']) ? ' checked' : '' ?>>
    </label>
    <label>Notificar por WhatsApp
      <input type="checkbox" id="notif_wa_txt" value="1" disabled<?= !empty($editRow['notifica_wa']) ? ' checked' : '' ?>>
    </label>

    <label style="grid-column:1/-1"><?= $soloCancelar ? 'Observaciones (motivo de cancelacion)' : ($atender ? 'Observaciones de la cita' : 'Observaciones') ?>
      <textarea id="txt_observaciones" name="observaciones" rows="3"<?= $horario ? ' disabled' : '' ?><?= $soloCancelar ? ' required autofocus minlength="5" placeholder="Escriba la razon por la que se cancela la cita (obligatorio)"' : '' ?>><?= htmlspecialchars($editRow['observaciones'] ?? '') ?></textarea>
      <?php if ($soloCancelar): ?><small style="color:#b00020">Obligatorio: capture la razon de la cancelacion.</small><?php endif; ?>
    </label>

    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit"<?= $soloCancelar ? ' onclick="return validaMotivoCancelacion();"' : ($atender ? ' onclick="return confirm(\'\u00bfMarcar esta cita como Atendida?\');"' : '') ?>><?= $soloCancelar ? 'Cancelar cita' : ($atender ? 'Atendida' : ($horario ? 'Guardar hora fin' : ($editId ? 'Actualizar' : 'Agendar'))) ?></button>
      <a class="btn btn-sec" href="<?= url('citas') ?>"><?= ($atender || $horario) ? 'Regresar' : 'Cancelar' ?></a>

    </div>
  </form>
</div>
<div id="cita-guardando" class="modal-backdrop" style="display:none">
  <div class="modal" style="text-align:center;max-width:340px">
    <div class="spinner-cita"></div>
    <h3 style="margin:.6rem 0 .3rem"><?= empty($editId) ? 'Generando la cita...' : 'Guardando los cambios...' ?></h3>
    <p style="margin:0;color:var(--c4)">Espere por favor, no cierre ni recargue la pagina.</p>
  </div>
</div>
<style>
.spinner-cita{width:42px;height:42px;margin:0 auto;border:4px solid var(--c2);border-top-color:var(--c5);border-radius:50%;animation:spinCita .8s linear infinite}
@keyframes spinCita{to{transform:rotate(360deg)}}
</style>
<script>
(function () {
  var f = document.getElementById('form-cita');
  if (!f) return;
  var enviado = false;
  f.addEventListener('submit', function (e) {
    if (e.defaultPrevented) return;
    if (enviado) { e.preventDefault(); return; }
    enviado = true;
    f.querySelectorAll('button[type=submit]').forEach(function (b) { b.disabled = true; });
    document.getElementById('cita-guardando').style.display = 'flex';
  });
  window.addEventListener('pageshow', function (ev) {
    if (ev.persisted) {
      enviado = false;
      document.getElementById('cita-guardando').style.display = 'none';
      f.querySelectorAll('button[type=submit]').forEach(function (b) { b.disabled = false; });
    }
  });
})();
</script>
<?php if ($soloCancelar): ?>
<script>
function validaMotivoCancelacion() {
  var t = document.getElementById('txt_observaciones');
  var v = (t && t.value ? t.value : '').trim();
  if (v.length < 5) {
    alert('Debe capturar la razon de la cancelacion en Observaciones (minimo 5 caracteres).');
    if (t) { t.focus(); }
    return false;
  }
  return confirm('\u00bfCambiar el estatus de esta cita a Cancelada?');
}
</script>
<?php endif; ?>
<script>
(function () {
  var sel = document.getElementById('sel_paciente');
  var em  = document.getElementById('email_notif');
  var tel = document.getElementById('celular_notif');
  var obs = document.getElementById('obs_paciente');
  var nEm = document.getElementById('notif_email_txt');
  var nWa = document.getElementById('notif_wa_txt');
  if (!sel || !em || !tel) return;
  function sync() {
    var o = sel.options[sel.selectedIndex];
    if (!o || !o.value) {
      em.value = ''; tel.value = ''; if (obs) obs.value = '';
      if (nEm) nEm.checked = false; if (nWa) nWa.checked = false;
      return;
    }
    em.value  = o.getAttribute('data-email') || '';
    tel.value = o.getAttribute('data-tel') || '';
    if (obs) obs.value = o.getAttribute('data-obs') || '';
    if (nEm) nEm.checked = o.getAttribute('data-nemail') === '1';
    if (nWa) nWa.checked = o.getAttribute('data-nwa') === '1';
  }
  sel.addEventListener('change', function () { sync(); updCount(); });
  var cnt = document.getElementById('obs_paciente_count');
  function updCount() {
    if (!cnt || !obs) return;
    if (obs.value.length > 5000) obs.value = obs.value.slice(0, 5000);
    cnt.textContent = '(' + obs.value.length + '/5000)';
  }
  if (obs) obs.addEventListener('input', updCount);
  // Solo autocompletar desde el catalogo en citas nuevas; en una cita guardada
  // se respetan las observaciones del paciente tal como quedaron capturadas.
  if (!em.value && !tel.value) sync();
  else {
    var oi = sel.options[sel.selectedIndex];
    if (oi) {
      if (nEm) nEm.checked = oi.getAttribute('data-nemail') === '1';
      if (nWa) nWa.checked = oi.getAttribute('data-nwa') === '1';
    }
  }
  updCount();
})();
</script><script>
(function () {
  var D = window.PAD_DATA || {map:{}, sel:[], dis:false};
  var med = document.getElementById('sel_medico');
  var box = document.getElementById('pad_lista');
  var pr  = document.getElementById('inp_precio');
  if (!med || !box) return;
  var selIds = D.sel.map(function (x) { return x.id; });
  var inicialMed = med.value;
  var manual = selIds.length > 0 || (pr && parseFloat(pr.value || '0') > 0);
  if (pr) pr.addEventListener('input', function () { manual = true; });
  function items() {
    var l = (D.map[med.value] || []).slice();
    if (med.value === inicialMed) {   // incluye los ya elegidos aunque esten inactivos
      D.sel.forEach(function (s) { if (!l.some(function (x) { return x.id === s.id; })) l.push(s); });
    }
    return l;
  }
  function suma() {
    var t = 0;
    box.querySelectorAll('input[type=checkbox]:checked').forEach(function (c) { t += parseFloat(c.getAttribute('data-precio') || '0'); });
    return t;
  }
  function pinta() {
    var l = items();
    box.innerHTML = '';
    if (!med.value) { box.innerHTML = '<span class="pad-vacio">Elige primero un médico.</span>'; return; }
    if (!l.length) { box.innerHTML = '<span class="pad-vacio">Este médico no tiene padecimientos registrados.</span>'; return; }
    l.forEach(function (p) {
      var lb = document.createElement('label'); lb.className = 'chk pad-item';
      var c = document.createElement('input'); c.type = 'checkbox'; c.name = 'padecimientos[]'; c.value = p.id;
      c.setAttribute('data-precio', p.precio); c.checked = selIds.indexOf(p.id) >= 0; c.disabled = !!D.dis;
      c.addEventListener('change', function () {
        selIds = Array.prototype.map.call(box.querySelectorAll('input:checked'), function (x) { return parseInt(x.value, 10); });
        if (!pr || pr.disabled) return;
        var t = suma().toFixed(2);
        if (manual && pr.value !== '' && parseFloat(pr.value) !== parseFloat(t)) {
          if (!confirm('¿Reemplazar el precio capturado ($' + pr.value + ') por la suma de los padecimientos ($' + t + ')?')) return;
        }
        pr.value = t; manual = false;
      });
      lb.appendChild(c);
      lb.appendChild(document.createTextNode(' ' + p.nombre + ' ($' + Number(p.precio).toFixed(2) + ')'));
      box.appendChild(lb);
    });
  }
  med.addEventListener('change', function () { selIds = []; pinta(); });
  pinta();
})();
</script>
