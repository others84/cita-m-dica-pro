<?php $controller='mensajes'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0">Texto de notificación por WhatsApp</h2>
  <p style="margin:.2rem 0 1rem;color:var(--c5)">
    Cada médico tiene su propio texto. Las palabras que empiezan con <strong>@@</strong> se cambian
    automáticamente por los datos de cada cita al enviar el recordatorio.
  </p>

  <?php if ($editRow): ?>
    <form method="post" action="<?= url('mensajes/guardar') ?>" class="form-grid"><?= csrf_field() ?>
      <input type="hidden" name="id_MEDICO" value="<?= (int)$editRow['id_USUARIOS'] ?>">
      <label class="col-span">Médico
        <input type="text" value="<?= htmlspecialchars((string)$editRow['nombre_completo'] . ' — ' . (string)$editRow['clinica']) ?>" readonly>
      </label>

      <div style="grid-column:1/-1">
        <span style="color:var(--c5)">Insertar dato:</span>
        <div class="acts" style="display:flex;flex-wrap:wrap;gap:.35rem;margin:.35rem 0">
          <?php foreach ($variables as $v => $desc): ?>
            <button class="btn btn-sec" type="button" data-var="<?= htmlspecialchars($v, ENT_QUOTES) ?>"
                    title="<?= htmlspecialchars($desc, ENT_QUOTES) ?>"><?= htmlspecialchars($v) ?></button>
          <?php endforeach; ?>
        </div>
      </div>

      <label class="col-span" style="grid-column:1/-1">Texto del mensaje
        <textarea name="plantilla" id="plantilla" rows="5" required
                  maxlength="<?= (int)$maxLen ?>"><?= htmlspecialchars((string)$editRow['plantilla']) ?></textarea>
      </label>

      <div style="grid-column:1/-1">
        <span style="color:var(--c5)">Vista previa (con datos de ejemplo):</span>
        <p id="preview" style="margin:.35rem 0;padding:.6rem;border:1px solid var(--c3);border-radius:6px"></p>
      </div>

      <div class="form-actions" style="grid-column:1/-1">
        <button class="btn">Guardar texto</button>
        <button class="btn btn-sec" type="button" id="restaurar">Usar texto por omisión</button>
        <?php post_button('mensajes', ['edit' => ''], 'Cancelar', 'btn btn-sec'); ?>
      </div>
    </form>
  <?php else: ?>
    <p style="margin:0;color:var(--c5)">Selecciona un médico de la tabla para definir su texto.</p>
  <?php endif; ?>
</div>

<div class="table-responsive">
  <table class="data">
    <thead><tr><th>Médico</th><th>Clínica</th><th>Texto</th><th>Acciones</th></tr></thead>
    <tbody>
      <?php if (empty($rows)): ?>
        <tr><td colspan="4" style="text-align:center;color:var(--c4);padding:1rem">Sin médicos</td></tr>
      <?php else: foreach ($rows as $r): ?>
        <tr>
          <td><?= htmlspecialchars((string)$r['nombre_completo']) ?></td>
          <td><?= htmlspecialchars((string)$r['clinica']) ?></td>
          <td>
            <?= htmlspecialchars((string)$r['plantilla']) ?>
            <?php if (empty($r['personalizado'])): ?>
              <br><span style="color:var(--c5)">(texto por omisión)</span>
            <?php endif; ?>
          </td>
          <td class="acts">
            <?php post_button('mensajes', ['edit' => (int)$r['id_USUARIOS']], empty($r['personalizado']) ? 'Definir' : 'Editar', 'btn btn-sec'); ?>
          </td>
        </tr>
      <?php endforeach; endif; ?>
    </tbody>
  </table>
</div>

<?php if ($editRow): ?>
<script>
(function () {
  var ta = document.getElementById('plantilla');
  var pv = document.getElementById('preview');
  if (!ta) return;
  var DEFAULT = <?= json_encode($porDefecto) ?>;
  var EJEMPLO = {
    '@@ESPECIALIDAD': 'Medicina general',
    '@@CONSULTORIO': 'Consultorio 1',
    '@@PACIENTE': 'María López',
    '@@CLINICA': <?= json_encode((string)$editRow['clinica']) ?>,
    '@@MEDICO': <?= json_encode((string)$editRow['nombre_completo']) ?>,
    '@@FECHA': '15/05/2026',
    '@@HORA': '10:30'
  };

  function pintar() {
    var t = ta.value;
    Object.keys(EJEMPLO).forEach(function (k) {
      t = t.split(k).join(EJEMPLO[k]);
    });
    pv.textContent = t;
  }

  function insertar(txt) {
    var i = ta.selectionStart || 0, j = ta.selectionEnd || 0;
    ta.value = ta.value.slice(0, i) + txt + ta.value.slice(j);
    ta.focus();
    ta.selectionStart = ta.selectionEnd = i + txt.length;
    pintar();
  }

  Array.prototype.forEach.call(document.querySelectorAll('[data-var]'), function (b) {
    b.addEventListener('click', function () { insertar(b.dataset.var); });
  });
  var rest = document.getElementById('restaurar');
  if (rest) rest.addEventListener('click', function () { ta.value = DEFAULT; pintar(); });
  ta.addEventListener('input', pintar);
  pintar();
})();
</script>
<?php endif; ?>

