<?php
/**
 * Editor visual HTML. Variables: $edId (string), $edHtml (string), $edAction, $edTipo, $edBoton.
 */
$vars = ['@@CLINICA','@@DIRECCION','@@EMAIL_CLINICA','@@TELEFONO_CLINICA','@@FECHA','@@USUARIO','@@NOMBRE_USUARIO','@@ROL'];
?>
<form method="post" action="<?= url($edAction) ?>" class="legal-editor-form" data-editor="<?= htmlspecialchars($edId) ?>">
  <?= csrf_field() ?>
  <input type="hidden" name="tipo" value="<?= htmlspecialchars($edTipo) ?>">
  <input type="hidden" name="html" value="">
  <div class="legal-toolbar" role="toolbar" aria-label="Formato">
    <select data-block aria-label="Estilo de párrafo">
      <option value="p">Párrafo</option><option value="h2">Título</option><option value="h3">Subtítulo</option>
    </select>
    <button type="button" data-cmd="bold" title="Negritas"><b>B</b></button>
    <button type="button" data-cmd="italic" title="Cursiva"><i>I</i></button>
    <button type="button" data-cmd="underline" title="Subrayado"><u>U</u></button>
    <button type="button" data-cmd="insertUnorderedList" title="Lista">• Lista</button>
    <button type="button" data-cmd="insertOrderedList" title="Lista numerada">1. Lista</button>
    <button type="button" data-cmd="justifyLeft" title="Izquierda">⟸</button>
    <button type="button" data-cmd="justifyCenter" title="Centrar">≡</button>
    <button type="button" data-cmd="justifyFull" title="Justificar">☰</button>
    <button type="button" data-link title="Enlace">Enlace</button>
    <button type="button" data-table title="Tabla">Tabla</button>
    <button type="button" data-cmd="insertHorizontalRule" title="Línea">―</button>
    <button type="button" data-cmd="removeFormat" title="Quitar formato">Limpiar</button>
    <select data-var aria-label="Insertar variable">
      <option value="">Insertar variable…</option>
      <?php foreach ($vars as $v): ?><option value="<?= $v ?>"><?= $v ?></option><?php endforeach; ?>
    </select>
    <button type="button" data-source title="Ver HTML">&lt;/&gt; HTML</button>
  </div>
  <div id="<?= htmlspecialchars($edId) ?>" class="legal-edit legal-doc" contenteditable="true"><?= $edHtml ?></div>
  <textarea class="legal-source" hidden aria-label="Código HTML"></textarea>
  <div style="margin-top:.6rem;display:flex;gap:.5rem;flex-wrap:wrap">
    <button type="submit" class="btn"><?= htmlspecialchars($edBoton) ?></button>
    <?php if (!empty($edExtra)) echo $edExtra; ?>
  </div>
</form>
<?php if (empty($GLOBALS['__legalEditorJs'])): $GLOBALS['__legalEditorJs'] = true; ?>
<script>
document.querySelectorAll('.legal-editor-form').forEach(function (f) {
  var ed = document.getElementById(f.dataset.editor), src = f.querySelector('.legal-source'), modoSrc = false;
  function cmd(c, v) { ed.focus(); document.execCommand(c, false, v || null); }
  f.querySelectorAll('[data-cmd]').forEach(function (b) { b.addEventListener('click', function () { cmd(b.dataset.cmd); }); });
  f.querySelector('[data-block]').addEventListener('change', function (e) { cmd('formatBlock', '<' + e.target.value + '>'); });
  f.querySelector('[data-var]').addEventListener('change', function (e) { if (e.target.value) cmd('insertText', e.target.value); e.target.value = ''; });
  f.querySelector('[data-link]').addEventListener('click', function () {
    var u = prompt('Dirección (https://, mailto: o tel:)'); if (u && /^(https?:\/\/|mailto:|tel:)/i.test(u)) cmd('createLink', u);
  });
  f.querySelector('[data-table]').addEventListener('click', function () {
    var r = parseInt(prompt('Filas', '2'), 10) || 2, c = parseInt(prompt('Columnas', '2'), 10) || 2, h = '<table><tbody>';
    for (var i = 0; i < r; i++) { h += '<tr>'; for (var j = 0; j < c; j++) h += '<td>&nbsp;</td>'; h += '</tr>'; }
    cmd('insertHTML', h + '</tbody></table><p></p>');
  });
  f.querySelector('[data-source]').addEventListener('click', function () {
    modoSrc = !modoSrc;
    if (modoSrc) { src.value = ed.innerHTML; src.hidden = false; ed.hidden = true; }
    else { ed.innerHTML = src.value; src.hidden = true; ed.hidden = false; }
  });
  f.addEventListener('submit', function () {
    if (modoSrc) ed.innerHTML = src.value;
    f.querySelector('input[name=html]').value = ed.innerHTML;
  });
});
</script>
<?php endif; ?>
