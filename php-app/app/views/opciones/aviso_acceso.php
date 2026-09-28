<?php
$__dest = (string)($cfg['destinos'] ?? '');
$__asunto = (string)($cfg['asunto'] ?? ConfigAvisoAccesoModel::asuntoDefecto());
$__texto = (string)($cfg['plantilla'] ?? ConfigAvisoAccesoModel::porDefecto());
$__activo = (int)($cfg['activo'] ?? 1);
?>
<div class="card" style="max-width:760px">
  <h2 style="margin-top:0;color:var(--c5)">Aviso de accesos</h2>
  <p style="color:var(--c4);margin-top:0">Cada vez que un Administrador de clínica o Administrador de sistema entre al sistema, se enviará este aviso a los correos indicados. Se usa la cuenta de "Configuración de correo".</p>
  <form method="post" action="<?= url('opciones/avisoAccesoGuardar') ?>" class="form-grid"><?= csrf_field() ?>
    <label style="grid-column:1/-1">Correo(s) destino (separados por coma)
      <input type="text" name="destinos" maxlength="500" required value="<?= htmlspecialchars($__dest) ?>" placeholder="seguridad@midominio.com, director@midominio.com">
    </label>
    <label>Activo
      <select name="activo">
        <option value="1"<?= $__activo === 1 ? ' selected' : '' ?>>Sí</option>
        <option value="0"<?= $__activo === 0 ? ' selected' : '' ?>>No</option>
      </select>
    </label>
    <label style="grid-column:1/-1">Asunto
      <input type="text" name="asunto" id="av-asunto" maxlength="200" required value="<?= htmlspecialchars($__asunto) ?>">
    </label>
    <div style="grid-column:1/-1">
      <div style="margin-bottom:.4rem;color:var(--c4)">Variables (clic para insertar en el texto):</div>
      <?php foreach (ConfigAvisoAccesoModel::VARIABLES as $v): ?>
        <button type="button" class="btn btn-sec av-var" data-var="<?= $v ?>" style="margin:0 .3rem .3rem 0"><?= $v ?></button>
      <?php endforeach; ?>
    </div>
    <label style="grid-column:1/-1">Texto del aviso
      <textarea name="plantilla" id="av-texto" rows="6" maxlength="2000" required><?= htmlspecialchars($__texto) ?></textarea>
    </label>
    <div style="grid-column:1/-1">
      <strong>Vista previa</strong>
      <div class="card" style="margin-top:.4rem;background:var(--c1)">
        <div id="av-prev-asunto" style="font-weight:700;margin-bottom:.4rem"></div>
        <div id="av-prev" style="white-space:pre-wrap"></div>
      </div>
    </div>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit">Guardar</button>
    </div>
  </form>
</div>

<div class="card" style="max-width:760px;margin-top:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Probar envío</h3>
  <form method="post" action="<?= url('opciones/avisoAccesoPrueba') ?>" class="form-grid"><?= csrf_field() ?>
    <p style="grid-column:1/-1;margin:0;color:var(--c4)">Envía el aviso guardado, con tus datos, a los correos destino.</p>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn btn-sec" type="submit">Enviar prueba</button>
    </div>
  </form>
</div>

<script>
(function () {
  var ej = {'@@USUARIO':'jperez','@@NOMBRE':'Juan Pérez','@@ROL':'Administrador de clínica','@@FECHA':'28/09/2026','@@HORA':'11:42:05','@@IP':'201.140.10.25','@@CLINICA':'Clínica Centro'};
  var t = document.getElementById('av-texto'), a = document.getElementById('av-asunto');
  function r(s) { return s.replace(/@@[A-Z]+/g, function (m) { return ej.hasOwnProperty(m) ? ej[m] : m; }); }
  function prev() {
    document.getElementById('av-prev').textContent = r(t.value);
    document.getElementById('av-prev-asunto').textContent = r(a.value);
  }
  document.querySelectorAll('.av-var').forEach(function (b) {
    b.addEventListener('click', function () {
      var s = t.selectionStart || 0, e = t.selectionEnd || 0;
      t.value = t.value.slice(0, s) + b.dataset.var + t.value.slice(e);
      t.focus(); t.selectionStart = t.selectionEnd = s + b.dataset.var.length; prev();
    });
  });
  t.addEventListener('input', prev); a.addEventListener('input', prev); prev();
})();
</script>
