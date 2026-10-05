<?php
$fn = $editRow['fecha_nacimiento'] ?? '';
if ($fn instanceof DateTime) $fn = $fn->format('Y-m-d');
$fn = $fn ? substr((string)$fn,0,10) : '';
// Valor visible en DD/MM/AAAA para el campo con mascara; el hidden conserva ISO.
$fnDisplay = '';
if ($fn) {
  $partes = explode('-', $fn);
  if (count($partes) === 3) $fnDisplay = $partes[2] . '/' . $partes[1] . '/' . $partes[0];
}
// Mapeos para el cascada Pais -> Estado -> Municipio
$paisPorEstado = [];
foreach ($estados as $e) {
  $paisPorEstado[(int)$e['id_CATALOGO_ESTADOS']] = (int)($e['id_CATALOGO_PAIS'] ?? 0);
}
$estadoPorMun = [];
foreach ($municipios as $mu) {
  $estadoPorMun[(int)$mu['id_CATALOGO_MUNICIPIO']] = (int)($mu['id_CATALOGO_ESTADOS'] ?? 0);
}
$selMun    = isset($editRow) ? (int)($editRow['id_CATALOGO_MUNICIPIO'] ?? 0) : 0;
$selEstado = $selMun ? ($estadoPorMun[$selMun] ?? 0) : 0;
$selPais   = $selEstado ? ($paisPorEstado[$selEstado] ?? 0) : 0;

// Comparacion de nombres sin acentos ni mayusculas (para valores por defecto).
$normaliza = function ($t) {
  $t = strtr((string)$t, [
    'Á'=>'A','É'=>'E','Í'=>'I','Ó'=>'O','Ú'=>'U','Ü'=>'U','Ñ'=>'N',
    'á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u','ü'=>'u','ñ'=>'n',
  ]);
  return strtolower(trim($t));
};
// Paciente nuevo: Genero "Femenino" y Pais "Mexico" preseleccionados.
$selGenero = isset($editRow) ? (int)($editRow['id_CATALOGO_GENERO'] ?? 0) : 0;
if (!isset($editRow)) {
  foreach ($generos as $g) {
    if ($normaliza($g['nombre'] ?? '') === 'femenino') { $selGenero = (int)$g['id_CATALOGO_GENERO']; break; }
  }
}
// Pais "Mexico" preseleccionado siempre que no venga un municipio que indique otro.
if (!$selPais) {
  foreach ($paises as $p) {
    if ($normaliza($p['nombre'] ?? '') === 'mexico') { $selPais = (int)$p['id_CATALOGO_PAIS']; break; }
  }
}
?>
<?php $controller='pacientes'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<?php if (class_exists('Database')) {
  Database::log(sprintf(
    'PACIENTES.view rol=%s user=%s fClinica=%s hiddenClinicaNuevo=%s post_f_clinica=%s session_f_clinica=%s',
    $rol ?? '?',
    $_SESSION['user']['usuario'] ?? '?',
    $fClinica ?? 'NULL',
    (int)($editRow['id_CLINICA'] ?? $fClinica ?? 0),
    $_POST['f_clinica'] ?? 'NO_POST',
    $_SESSION['f_clinica'] ?? 'NULL'
  ));
} ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0;color:var(--c5)"><?= $editId ? 'Modificar paciente' : 'Nuevo paciente' ?></h2>
  <form method="post" action="<?= url('pacientes/guardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <?php $clinicaForm = (int)($editRow['id_CLINICA'] ?? $fClinica ?? 0); ?>
    <input type="hidden" name="id_CLINICA" value="<?= $clinicaForm ?>">
    <?php if ($clinicaForm <= 0): ?>
      <p style="grid-column:1/-1;color:#b00">Selecciona una clinica en el apartado "Filtro" para poder registrar pacientes.</p>
    <?php endif; ?>
    <label>Apellido paterno <input name="ap_paterno" required value="<?= htmlspecialchars($editRow['ap_paterno'] ?? '') ?>"></label>
    <label>Apellido materno <input name="ap_materno" required value="<?= htmlspecialchars($editRow['ap_materno'] ?? '') ?>"></label>
    <label>Nombre(s) <input name="nombre" required value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>"></label>
    <label>Direccion <input name="direccion" required value="<?= htmlspecialchars($editRow['direccion'] ?? '') ?>"></label>
    <label>Telefono <input name="telefono" required value="<?= htmlspecialchars($editRow['telefono'] ?? '') ?>"></label>
    <label>Email (opcional) <input type="email" name="email" value="<?= htmlspecialchars($editRow['email'] ?? '') ?>"></label>
    <label>Fecha nacimiento
      <input type="text" id="fnac_mask" name="fecha_nacimiento_display" inputmode="numeric" maxlength="10" placeholder="DD/MM/AAAA" pattern="\d{2}/\d{2}/\d{4}" autocomplete="off" required value="<?= htmlspecialchars($fnDisplay) ?>">
      <input type="hidden" name="fecha_nacimiento" value="<?= htmlspecialchars($fn) ?>">
    </label>
    <label>Genero
      <select name="id_CATALOGO_GENERO" required>
        <option value="">--</option>
        <?php foreach ($generos as $g): ?>
          <option value="<?= (int)$g['id_CATALOGO_GENERO'] ?>" <?= $selGenero===(int)$g['id_CATALOGO_GENERO']?'selected':'' ?>>
            <?= htmlspecialchars($g['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Pais
      <select id="sel_pais" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($paises as $p): ?>
          <option value="<?= (int)$p['id_CATALOGO_PAIS'] ?>" <?= $selPais===(int)$p['id_CATALOGO_PAIS']?'selected':'' ?>>
            <?= htmlspecialchars($p['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Estado (opcional)
      <select id="sel_estado">
        <option value="">-- seleccione --</option>
      </select>
    </label>
    <label>Municipio (opcional)
      <select id="sel_municipio" name="id_CATALOGO_MUNICIPIO">
        <option value="">-- seleccione --</option>
      </select>
    </label>
    <label style="grid-column:1/-1">Observaciones
      <textarea name="observaciones" rows="3" maxlength="500"><?= htmlspecialchars((string)($editRow['observaciones'] ?? '')) ?></textarea>
    </label>
    <label class="chk">
      <input type="checkbox" name="notifica_email" value="1" <?= !empty($editRow['notifica_email']) ? 'checked' : '' ?>>
      Enviar notificación por correo
    </label>
    <label class="chk">
      <input type="checkbox" name="notifica_wa" value="1" <?= !empty($editRow['notifica_wa']) ? 'checked' : '' ?>>
      Enviar notificación por WhatsApp
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit" <?= $clinicaForm <= 0 ? 'disabled' : '' ?>><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url('pacientes') ?>">Cancelar</button><?php  endif; ?>
    </div>
  </form>
</div>

<script>
(function(){
  var ESTADOS = <?= json_encode(array_map(function($e){
    return ['id'=>(int)$e['id_CATALOGO_ESTADOS'],'nombre'=>$e['nombre'],'pais'=>(int)($e['id_CATALOGO_PAIS']??0)];
  }, $estados)) ?>;
  var MUNIS = <?= json_encode(array_map(function($m){
    return ['id'=>(int)$m['id_CATALOGO_MUNICIPIO'],'nombre'=>$m['nombre'],'estado'=>(int)($m['id_CATALOGO_ESTADOS']??0)];
  }, $municipios)) ?>;
  var selPais = <?= (int)$selPais ?>, selEstado = <?= (int)$selEstado ?>, selMun = <?= (int)$selMun ?>;
  var pa = document.getElementById('sel_pais'),
      es = document.getElementById('sel_estado'),
      mu = document.getElementById('sel_municipio');
  function fillEstados(){
    var pid = parseInt(pa.value||0,10);
    es.innerHTML = '<option value="">-- seleccione --</option>';
    ESTADOS.filter(function(e){return e.pais===pid;}).forEach(function(e){
      var o = new Option(e.nombre, e.id);
      if (e.id===selEstado) o.selected = true;
      es.appendChild(o);
    });
    fillMunis();
  }
  function fillMunis(){
    var eid = parseInt(es.value||0,10);
    mu.innerHTML = '<option value="">-- seleccione --</option>';
    MUNIS.filter(function(m){return m.estado===eid;}).forEach(function(m){
      var o = new Option(m.nombre, m.id);
      if (m.id===selMun) o.selected = true;
      mu.appendChild(o);
    });
  }
  pa.addEventListener('change', function(){ selEstado=0; selMun=0; fillEstados(); });
  es.addEventListener('change', function(){ selMun=0; fillMunis(); });
  if (selPais) fillEstados(); // pre-carga en modo edicion
})();
</script>

<script>
// Mascara manual DD/MM/AAAA para la fecha de nacimiento.
// El campo visible no se envia al servidor; un hidden conserva ISO (YYYY-MM-DD)
// que es el formato que esperan spAltaPaciente / spCambioPaciente.
(function(){
  var input = document.getElementById('fnac_mask');
  if (!input) return;
  var hidden = input.form ? input.form.querySelector('input[name="fecha_nacimiento"]') : null;
  if (!hidden) hidden = document.querySelector('input[name="fecha_nacimiento"]');
  var anioActual = new Date().getFullYear();

  function soloDigitos(v){ return (v || '').replace(/\D+/g, ''); }

  function aplicarMascara(v){
    var d = soloDigitos(v).slice(0, 8);
    if (d.length > 4) return d.slice(0,2) + '/' + d.slice(2,4) + '/' + d.slice(4);
    if (d.length > 2) return d.slice(0,2) + '/' + d.slice(2);
    return d;
  }

  function validaFecha(v){
    var m = /^(\d{2})\/(\d{2})\/(\d{4})$/.exec(v || '');
    if (!m) return false;
    var dd = parseInt(m[1],10), mm = parseInt(m[2],10), aaaa = parseInt(m[3],10);
    if (mm < 1 || mm > 12) return false;
    if (dd < 1 || dd > 31) return false;
    if (aaaa < 1900 || aaaa > anioActual) return false;
    var dt = new Date(aaaa, mm - 1, dd);
    if (dt.getFullYear() !== aaaa || dt.getMonth() !== mm - 1 || dt.getDate() !== dd) return false;
    return true;
  }

  function sincronizaHidden(){
    hidden.value = validaFecha(input.value)
      ? input.value.slice(6,10) + '-' + input.value.slice(3,5) + '-' + input.value.slice(0,2)
      : '';
  }

  input.addEventListener('input', function(){
    var antes = input.value;
    var cur = input.selectionStart;
    if (cur == null) cur = antes.length;
    var alFinal = cur >= antes.length;
    // Cuenta los digitos a la izquierda del cursor (las barras no cuentan).
    var nDig = soloDigitos(antes.slice(0, cur)).length;
    var novo = aplicarMascara(antes);
    if (novo !== antes) input.value = novo;
    var pos;
    if (alFinal) {
      pos = novo.length;
    } else {
      pos = 0;
      var vistos = 0;
      while (pos < novo.length && vistos < nDig) {
        if (/\d/.test(novo.charAt(pos))) vistos++;
        pos++;
      }
    }
    var fija = function(){ try { input.setSelectionRange(pos, pos); } catch(e){} };
    fija();
    // Android/Gboard puede sobrescribir el cursor; se reaplica tras el pintado.
    if (window.requestAnimationFrame) requestAnimationFrame(fija); else setTimeout(fija, 0);
    sincronizaHidden();
  });

  input.addEventListener('focus', function(){
    if (input.value === '') {
      try { input.setSelectionRange(0, 0); } catch(e){}
    }
  });

  if (input.form) input.form.addEventListener('submit', sincronizaHidden);
  sincronizaHidden(); // precarga el hidden en modo edicion
})();
</script>

<div id="pacientes-tabla">
  <?php require __DIR__ . '/_tabla.php'; ?>
</div>

<script>
(function(){
  var container = document.getElementById('pacientes-tabla');
  var endpoint = '<?= url('pacientes/tabla') ?>';

  function attach(root) {
    root = root || document;
    root.querySelectorAll('.sort-form').forEach(function(form){
      form.addEventListener('submit', onSort);
    });
    root.querySelectorAll('.page-form').forEach(function(form){
      form.addEventListener('submit', onPage);
    });
  }

  async function reloadTable(body) {
    if (!container) return;
    container.style.opacity = '0.6';
    try {
      var res = await fetch(endpoint, { method: 'POST', body: body });
      if (!res.ok) throw new Error('Error ' + res.status);
      var html = await res.text();
      container.innerHTML = html;
      attach(container);
    } catch (err) {
      console.error('No se pudo actualizar la tabla:', err);
    } finally {
      container.style.opacity = '1';
    }
  }

  function onSort(e) {
    e.preventDefault();
    var form = e.currentTarget;
    var fd = new FormData(form);
    reloadTable(fd);
  }

  function onPage(e) {
    e.preventDefault();
    var form = e.currentTarget;
    var fd = new FormData(form);
    reloadTable(fd);
  }

  attach();
})();
</script>