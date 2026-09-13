<?php $controller='citasmanana'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<?php
  $rol = $rol ?? ($_SESSION['user']['rol'] ?? '');
  $manana = $manana ?? date('Y-m-d', strtotime('+1 day'));
  $dias  = ['Sunday'=>'Domingo','Monday'=>'Lunes','Tuesday'=>'Martes','Wednesday'=>'Miércoles','Thursday'=>'Jueves','Friday'=>'Viernes','Saturday'=>'Sábado'];
  $meses = [1=>'enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre'];
  $ts = strtotime($manana);
  $fechaLarga = ($dias[date('l', $ts)] ?? '') . ' ' . date('j', $ts) . ' de ' . ($meses[(int)date('n', $ts)] ?? '') . ' de ' . date('Y', $ts);
  $conTel = 0;
  foreach (($citas ?? []) as $c) { if (wa_link($c) !== '') $conTel++; }
?>
<div class="toolbar">
  <h2 style="margin:0;color:var(--c5)">Citas de mañana &middot; <?= htmlspecialchars($fechaLarga) ?></h2>
  <button class="btn" type="button" id="wa-todos" <?= $conTel === 0 ? 'disabled' : '' ?>>Enviar WhatsApp a todos (<?= (int)$conTel ?>)</button>
</div>
<p style="color:var(--c4);margin:.25rem 0 1rem">
  <?= (int)count($citas ?? []) ?> cita(s) agendada(s) para mañana.
  En el celular, usa el botón WhatsApp de cada renglón: se abre una conversación a la vez.
</p>

<div class="table-responsive">
<table class="data tabla-citas">
  <thead>
    <tr>
      <th>Hora</th><th>Paciente</th><th>Médico</th><th>Especialidad</th>
      <th>Consultorio</th><th>Teléfono</th><th>Notificado</th><th>Acciones</th>
    </tr>
  </thead>
  <tbody>
    <?php if (empty($citas)): ?>
      <tr><td colspan="8" style="text-align:center;padding:1rem;color:var(--c4)">No hay citas agendadas para mañana.</td></tr>
    <?php else: foreach ($citas as $c):
        $hi = $c['hora_inicio'] instanceof DateTime ? $c['hora_inicio']->format('H:i') : substr((string)$c['hora_inicio'],0,5);
        $hf = $c['hora_fin']    instanceof DateTime ? $c['hora_fin']->format('H:i')    : substr((string)$c['hora_fin'],0,5);
        $tel = trim((string)($c['celular_notif'] ?? ''));
        $wa  = wa_link($c);
        $notificado = (int)($c['notificado'] ?? 0) === 1;
    ?>
      <tr>
        <td><?= htmlspecialchars($hi . ' - ' . $hf) ?></td>
        <td><?= htmlspecialchars($c['paciente'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['medico'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['especialidad'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['consultorio'] ?? '') ?></td>
        <td><?= htmlspecialchars($tel !== '' ? $tel : '—') ?></td>
        <td><span class="badge" data-notif="<?= (int)$c['id_CITA'] ?>"><?= $notificado ? 'Sí' : 'No' ?></span></td>
        <td class="acts">
          <?php if ($wa !== ''): ?>
            <a class="btn btn-sec wa-item" target="_blank" rel="noopener"
               data-id="<?= (int)$c['id_CITA'] ?>"
               href="<?= htmlspecialchars($wa, ENT_QUOTES) ?>">WhatsApp</a>
          <?php else: ?>
            <button class="btn btn-sec" type="button" disabled title="El paciente no tiene telefono registrado">Sin teléfono</button>
          <?php endif; ?>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>
</div>

<script>
(function () {
  var URL_MARCAR = <?= json_encode(url('citasmanana/marcar')) ?>;
  var CSRF = <?= json_encode(csrf_token()) ?>;

  function marcar(id) {
    var body = '_csrf=' + encodeURIComponent(CSRF) + '&id=' + encodeURIComponent(id);
    try {
      if (navigator.sendBeacon) {
        var fd = new FormData();
        fd.append('_csrf', CSRF);
        fd.append('id', id);
        navigator.sendBeacon(URL_MARCAR, fd);
      } else {
        fetch(URL_MARCAR, {
          method: 'POST',
          keepalive: true,
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: body
        });
      }
    } catch (e) { /* el envio de WhatsApp no debe interrumpirse */ }
    var b = document.querySelector('[data-notif="' + id + '"]');
    if (b) b.textContent = 'Sí';
  }

  var items = Array.prototype.slice.call(document.querySelectorAll('a.wa-item'));
  items.forEach(function (a) {
    a.addEventListener('click', function () { marcar(a.dataset.id); });
  });

  var esTactil = window.matchMedia && window.matchMedia('(pointer: coarse)').matches;
  var btn = document.getElementById('wa-todos');
  if (!btn) return;
  btn.addEventListener('click', function () {
    if (!items.length) return;
    if (esTactil) {
      alert('En el celular abre las conversaciones una por una con el botón WhatsApp de cada renglón.');
      return;
    }
    if (!confirm('Se abrirá una pestaña de WhatsApp por cada cita (' + items.length + '). Si el navegador lo bloquea, permite las ventanas emergentes de este sitio.')) return;
    items.forEach(function (a, i) {
      setTimeout(function () {
        marcar(a.dataset.id);
        window.open(a.href, '_blank', 'noopener');
      }, i * 1200);
    });
  });
})();
</script>
