<?php
/** Pagina publica "Generar cita" (sin sesion de sistema). */
$paisPorEstado = [];
foreach ($estados as $e) { $paisPorEstado[(int)$e['id_CATALOGO_ESTADOS']] = (int)($e['id_CATALOGO_PAIS'] ?? 0); }
$estadoPorMun = [];
foreach ($municipios as $mu) { $estadoPorMun[(int)$mu['id_CATALOGO_MUNICIPIO']] = (int)($mu['id_CATALOGO_ESTADOS'] ?? 0); }
$selMun    = (int)($paciente['id_CATALOGO_MUNICIPIO'] ?? 0);
$selEstado = $selMun ? ($estadoPorMun[$selMun] ?? 0) : 0;
$selPais   = $selEstado ? ($paisPorEstado[$selEstado] ?? 0) : 0;
$v = fn($k) => htmlspecialchars((string)($paciente[$k] ?? ''));
$soloLectura = $idPaciente > 0;
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>Generar cita | SGCO</title>
<meta name="description" content="Agenda tu cita medica en linea eligiendo clinica, medico, especialidad y horario disponible.">
<link rel="stylesheet" href="<?= asset('css/style.css') ?>">
<link rel="stylesheet" href="<?= asset('css/temas.css') ?>">
<link rel="stylesheet" href="<?= asset('vendor/event-calendar/event-calendar.min.css') ?>?v=372">
<link rel="icon" type="image/png" href="<?= url('favicon.png') ?>">
<script>
(function(){try{var d=document.documentElement,g=function(k){return localStorage.getItem(k)||'';};
var t=g('sgco:tema'),f=g('sgco:fuente'),e=g('sgco:escala');
if(t)d.setAttribute('data-tema',t); if(f)d.setAttribute('data-fuente',f); if(e)d.setAttribute('data-escala',e);
}catch(x){}})();
</script>
</head>
<body class="publica-body">
<header class="publica-top">
  <img src="<?= asset('img/logo.png') ?>" alt="Logo SGCO" width="48" height="48">
  <div>
    <h1>Agenda tu cita</h1>
    <p class="subtitle">Sistema de gestion de citas online (SGCO)</p>
  </div>
  <a class="btn" href="<?= url('auth/login') ?>">Iniciar sesion</a>
</header>

<main class="publica-wrap">
  <p class="publica-intro">Son 5 pasos cortos y te tomara unos 3 minutos. Si te equivocas, puedes corregir antes de terminar.</p>

  <?php foreach (($flash ?? []) as $f): ?>
    <div class="flash flash-<?= htmlspecialchars($f['type'] ?? 'info') ?>"><?= htmlspecialchars($f['msg'] ?? '') ?></div>
  <?php endforeach; ?>

  <!-- Paso 1: identificacion por celular -->
  <section class="card">
    <p class="paso-num">Paso 1 de 5</p>
    <h2>Identificate</h2>
    <p class="ayuda">Escribe tu numero de celular a 10 digitos, sin espacios ni guiones. Ejemplo: 2221234567.</p>
    <p class="ayuda">Si ya te has atendido con nosotros, tus datos apareceran solos. Si es tu primera vez, te pediremos algunos datos mas adelante.</p>
    <form method="post" action="<?= url('citapublica/buscar') ?>" class="form-grid"><?= csrf_field() ?>
      <label>Celular (10 digitos)
        <input name="telefono" inputmode="numeric" maxlength="20" required value="<?= htmlspecialchars($telefono) ?>" placeholder="2221234567">
      </label>
      <div class="form-actions">
        <button class="btn" type="submit">Buscar mis datos</button>
        <a class="btn btn-sec" href="<?= url('citapublica/reiniciar') ?>">Agendar cita</a>
      </div>
      <p class="ayuda col-span">Solo buscamos tu numero; no veras datos de otras personas.</p>
    </form>
    <?php if ($paso === 'elige_clinica' && !empty($coincidencias)): ?>
      <p class="ayuda">Tu numero esta en mas de una clinica. Elige a donde quieres ir.</p>
      <form method="post" action="<?= url('citapublica/clinica') ?>" class="form-grid"><?= csrf_field() ?>
        <label>Clinica
          <select name="id_CLINICA" required>
            <option value="">-- seleccione --</option>
            <?php foreach ($coincidencias as $c): ?>
              <option value="<?= (int)$c['id_CLINICA'] ?>"><?= htmlspecialchars($c['clinica']) ?></option>
            <?php endforeach; ?>
          </select>
        </label>
        <div class="form-actions"><button class="btn" type="submit">Continuar</button></div>
      </form>
    <?php endif; ?>
  </section>

<?php $mostrarResto = in_array($paso, ['nuevo', 'cita'], true); ?>
<?php if ($mostrarResto): ?>
  <!-- Paso 2: panel clinica -->
  <section class="card">
    <p class="paso-num">Paso 2 de 5</p>
    <h2>Elige clinica y medico</h2>
    <p class="ayuda">Elige la clinica a la que quieres ir y despues el medico con el que deseas atenderte.</p>
    <form method="post" action="<?= url('citapublica/clinica') ?>" class="form-grid"><?= csrf_field() ?>
      <label>Clinica
        <select name="id_CLINICA" required onchange="this.form.submit()">
          <option value="">-- seleccione --</option>
          <?php foreach ($clinicas as $c): ?>
            <option value="<?= (int)$c['id_CLINICA'] ?>" <?= $idClinica === (int)$c['id_CLINICA'] ? 'selected' : '' ?>>
              <?= htmlspecialchars($c['nombre']) ?>
            </option>
          <?php endforeach; ?>
        </select>
      </label>
    </form>

    <?php if (!$idClinica): ?>
      <p class="ayuda">Primero elige tu clinica; enseguida apareceran los medicos que atienden ahi.</p>
    <?php else: ?>
      <form method="post" action="<?= url('citapublica/seleccion') ?>" class="form-grid"><?= csrf_field() ?>
        <label>Medico
          <select name="id_MEDICO" required onchange="this.form.submit()">
            <option value="">-- seleccione --</option>
            <?php foreach ($medicos as $m): ?>
              <option value="<?= (int)$m['id_USUARIOS'] ?>" <?= $idMedico === (int)$m['id_USUARIOS'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($m['nombre_completo'] ?? '') ?>
              </option>
            <?php endforeach; ?>
          </select>
        </label>
        <label>Consultorio
          <input type="text" value="<?= htmlspecialchars($consultorioNom ?: 'No disponible') ?>" readonly>
        </label>
        <label>Especialidad
          <input type="text" value="<?= htmlspecialchars($especialidadNom ?: 'No disponible') ?>" readonly>
        </label>
        <p class="ayuda col-span">El consultorio y la especialidad se llenan solos. No tienes que hacer nada aqui.</p>
      </form>
    <?php endif; ?>
  </section>


  <!-- Paso 3: calendario del medico -->
  <section class="card calendar-card">
    <p class="paso-num">Paso 3 de 5</p>
    <h2>Elige el dia y la hora</h2>
    <?php if (!$idMedico): ?>
      <p class="ayuda">Primero elige un medico arriba para ver sus horarios.</p>
    <?php else: ?>
      <p class="ayuda">Aqui ves los horarios del medico. Los espacios en gris ya estan ocupados por otra persona.</p>
      <p class="ayuda">Toca un espacio en blanco del dia que quieras. La fecha y la hora se escribiran solas mas abajo. Solo puedes elegir horas completas (por ejemplo 11:00) y tu consulta dura 1 hora.</p>
      <div id="ec" class="calendar-box" style="height:640px;min-height:640px;width:100%;background:#fff">
        <div class="calendar-loading">Cargando calendario...</div>
      </div>
    <?php endif; ?>
  </section>

  <form method="post" action="<?= url('citapublica/agendar') ?>" id="form-cita"><?= csrf_field() ?>
    <input type="hidden" name="id_MEDICO" value="<?= $idMedico ?: '' ?>">
    <input type="hidden" name="id_CONSULTORIO" value="<?= $idConsultorio ?: '' ?>">
    <input type="hidden" name="id_CATALOGO_ESPECIALIDAD" value="<?= $idEspecialidad ?: '' ?>">

    <section class="card">
      <p class="paso-num">Paso 4 de 5</p>
      <h2>Tus datos</h2>
      <?php if ($soloLectura): ?>
        <p class="ayuda">Estos son los datos que tenemos tuyos. Revisalos; si algo cambio, avisanos al llegar a la clinica.</p>
      <?php else: ?>
        <p class="ayuda">Llena tus datos para que el medico te identifique el dia de tu cita.</p>
      <?php endif; ?>
      <div class="form-grid">
        <label>Apellido paterno <input name="ap_paterno" required maxlength="60" value="<?= $v('ap_paterno') ?>" <?= $soloLectura ? 'readonly' : '' ?>>
          <span class="ayuda">El apellido de tu papa.</span></label>
        <label>Apellido materno <input name="ap_materno" required maxlength="60" value="<?= $v('ap_materno') ?>" <?= $soloLectura ? 'readonly' : '' ?>>
          <span class="ayuda">El apellido de tu mama.</span></label>
        <label>Nombre(s) <input name="nombre" required maxlength="60" value="<?= $v('nombre') ?>" <?= $soloLectura ? 'readonly' : '' ?>>
          <span class="ayuda">Como aparece en tu identificacion.</span></label>
        <label>Direccion <input name="direccion" required maxlength="150" value="<?= $v('direccion') ?>" <?= $soloLectura ? 'readonly' : '' ?>>
          <span class="ayuda">Calle, numero y colonia.</span></label>
        <label>Celular <input name="telefono" required maxlength="20" value="<?= $paciente ? $v('telefono') : htmlspecialchars($telefono) ?>" <?= $soloLectura ? 'readonly' : '' ?>>
          <span class="ayuda">10 numeros, sin espacios. Ejemplo: 2221234567.</span></label>
        <label>Email <input type="email" name="email" required maxlength="120" value="<?= $v('email') ?>" <?= $soloLectura ? 'readonly' : '' ?>>
          <span class="ayuda">Tu correo, como nombre@correo.com. Si no tienes, pide ayuda en la clinica.</span></label>
        <label>Fecha nacimiento <input type="date" name="fecha_nacimiento" required value="<?= $v('fecha_nacimiento') ?>" <?= $soloLectura ? 'readonly' : '' ?>>
          <span class="ayuda">Dia, mes y ano en que naciste.</span></label>
        <label>Genero
          <select name="id_CATALOGO_GENERO" required <?= $soloLectura ? 'disabled' : '' ?>>
            <option value="">--</option>
            <?php foreach ($generos as $g): ?>
              <option value="<?= (int)$g['id_CATALOGO_GENERO'] ?>" <?= (int)($paciente['id_CATALOGO_GENERO'] ?? 0) === (int)$g['id_CATALOGO_GENERO'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($g['nombre']) ?>
              </option>
            <?php endforeach; ?>
          </select>
          <span class="ayuda">Elige mujer u hombre.</span>
        </label>
        <label>Pais
          <select id="sel_pais" <?= $soloLectura ? 'disabled' : 'required' ?>>
            <option value="">-- seleccione --</option>
            <?php foreach ($paises as $p): ?>
              <option value="<?= (int)$p['id_CATALOGO_PAIS'] ?>" <?= $selPais === (int)$p['id_CATALOGO_PAIS'] ? 'selected' : '' ?>><?= htmlspecialchars($p['nombre']) ?></option>
            <?php endforeach; ?>
          </select>
          <span class="ayuda">Elige primero el pais; despues apareceran los estados.</span>
        </label>
        <label>Estado
          <select id="sel_estado" <?= $soloLectura ? 'disabled' : 'required' ?>>
            <option value="">-- seleccione --</option>
            <?php foreach ($estados as $e): ?>
              <option value="<?= (int)$e['id_CATALOGO_ESTADOS'] ?>" data-pais="<?= (int)($e['id_CATALOGO_PAIS'] ?? 0) ?>" <?= $selEstado === (int)$e['id_CATALOGO_ESTADOS'] ? 'selected' : '' ?>><?= htmlspecialchars($e['nombre']) ?></option>
            <?php endforeach; ?>
          </select>
          <span class="ayuda">Por ejemplo: Puebla.</span>
        </label>
        <label>Municipio
          <select id="sel_municipio" name="id_CATALOGO_MUNICIPIO" required <?= $soloLectura ? 'disabled' : '' ?>>
            <option value="">-- seleccione --</option>
            <?php foreach ($municipios as $mu): ?>
              <option value="<?= (int)$mu['id_CATALOGO_MUNICIPIO'] ?>" data-estado="<?= (int)($mu['id_CATALOGO_ESTADOS'] ?? 0) ?>" <?= $selMun === (int)$mu['id_CATALOGO_MUNICIPIO'] ? 'selected' : '' ?>><?= htmlspecialchars($mu['nombre']) ?></option>
            <?php endforeach; ?>
          </select>
          <span class="ayuda">La ciudad o pueblo donde vives.</span>
        </label>
        <label class="col-span">Observaciones de la cita - motivo de la consulta
          <textarea name="observaciones_cita" rows="3" maxlength="500" placeholder="Ejemplo: revision anual"><?= htmlspecialchars((string)($obsCita ?? '')) ?></textarea>
          <span class="ayuda">Cuentanos en pocas palabras por que quieres esta consulta. Ejemplo: "revision anual" o "dolor desde hace una semana". Lo que escribas solo lo ve tu medico.</span>
        </label>

        <p class="ayuda col-span">Marca como quieres que te recordemos tu cita:</p>
        <label class="chk"><input type="checkbox" name="notifica_wa" value="1" <?= !empty($paciente['notifica_wa']) ? 'checked' : '' ?>> Avisarme por WhatsApp</label>
        <label class="chk"><input type="checkbox" name="notifica_email" value="1" <?= !empty($paciente['notifica_email']) ? 'checked' : '' ?>> Avisarme por correo</label>
      </div>
    </section>

    <section class="card">
      <p class="paso-num">Paso 5 de 5</p>
      <h2>Revisa y confirma</h2>
      <p class="ayuda">Revisa que la fecha y la hora sean las que elegiste en el calendario.</p>
      <div class="form-grid">
        <label>Fecha <input type="date" id="f_fecha" name="fecha_cita" required min="<?= date('Y-m-d') ?>"></label>
        <label>Hora inicio <input type="time" id="f_hi" name="hora_inicio" step="3600" required>
          <span class="ayuda">Solo horas completas: 11:00, 12:00, etc.</span></label>
        <input type="hidden" id="f_hf" name="hora_fin">
      </div>

      <p class="resumen-cita" id="resumen-cita">Aun no eliges dia y hora. Toca un espacio en blanco del calendario.</p>

      <div class="form-actions">
        <button class="btn btn-primary" type="submit">Confirmar mi cita</button>
      </div>
    </section>
  </form>
<?php endif; ?>
</main>


<?php
$medNom = '';
foreach (($medicos ?? []) as $m) { if ((int)($m['id_USUARIOS'] ?? 0) === (int)$idMedico) { $medNom = (string)($m['nombre_completo'] ?? ''); break; } }
$cliNom = '';
foreach (($clinicas ?? []) as $c) { if ((int)($c['id_CLINICA'] ?? 0) === (int)$idClinica) { $cliNom = (string)($c['nombre'] ?? ''); break; } }
?>
<script>
window.CITAS_EVENTS = <?= json_encode($eventos ?? [], JSON_HEX_TAG | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE) ?>;
window.CITA_INFO = <?= json_encode(['medico' => $medNom, 'clinica' => $cliNom], JSON_HEX_TAG | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE) ?>;
</script>
<script>
(function () {
  /* Cascada Pais -> Estado -> Municipio */
  var pais = document.getElementById('sel_pais'),
      est  = document.getElementById('sel_estado'),
      mun  = document.getElementById('sel_municipio');
  function filtra(sel, attr, val) {
    if (!sel) return;
    Array.prototype.forEach.call(sel.options, function (o) {
      if (!o.value) return;
      var ok = !val || o.getAttribute(attr) === String(val);
      o.hidden = !ok; o.disabled = !ok;
      if (!ok && o.selected) sel.value = '';
    });
  }
  function sync() { filtra(est, 'data-pais', pais && pais.value); filtra(mun, 'data-estado', est && est.value); }
  if (pais) pais.addEventListener('change', function () { if (est) est.value = ''; if (mun) mun.value = ''; sync(); });
  if (est)  est.addEventListener('change', function () { if (mun) mun.value = ''; sync(); });
  sync();

  /* Solo horas completas: se recortan los minutos y la cita dura 1 hora. */
  var DIAS = ['domingo','lunes','martes','miercoles','jueves','viernes','sabado'];
  var MESES = ['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre'];
  function enPunto(v) {
    var p = (v || '').split(':');
    if (p.length < 2) return '';
    var h = parseInt(p[0], 10);
    if (isNaN(h) || h < 0 || h > 23) return '';
    return ('0' + h).slice(-2) + ':00';
  }
  function masUnaHora(v) {
    var p = (v || '').split(':');
    if (p.length < 2) return '';
    var h = (parseInt(p[0], 10) + 1) % 24;
    return ('0' + h).slice(-2) + ':00';
  }
  function resumen() {
    var box = document.getElementById('resumen-cita');
    if (!box) return;
    var f = document.getElementById('f_fecha'), hi = document.getElementById('f_hi');
    if (!f || !f.value || !hi || !hi.value) {
      box.textContent = 'Aun no eliges dia y hora. Toca un espacio en blanco del calendario.';
      box.classList.remove('ok');
      return;
    }
    var p = f.value.split('-');
    var d = new Date(parseInt(p[0], 10), parseInt(p[1], 10) - 1, parseInt(p[2], 10));
    var ini = enPunto(hi.value);
    var txt = 'Tu cita: ' + DIAS[d.getDay()] + ' ' + d.getDate() + ' de ' + MESES[d.getMonth()] +
              ' de ' + d.getFullYear() + ' de ' + ini + ' a ' + masUnaHora(ini) + ' hrs';
    var info = window.CITA_INFO || {};
    if (info.medico) txt += ', con ' + info.medico;
    if (info.clinica) txt += ', en ' + info.clinica;
    box.textContent = txt + '.';
    box.classList.add('ok');
  }
  (function () {
    var hi = document.getElementById('f_hi'), hf = document.getElementById('f_hf'),
        fe = document.getElementById('f_fecha'), frm = document.getElementById('form-cita');
    if (!hi || !hf) return;
    function calc() {
      var ini = enPunto(hi.value);
      if (!ini) { hf.value = ''; return; }
      hi.value = ini;
      hf.value = masUnaHora(ini);
    }
    hi.addEventListener('change', function () { calc(); resumen(); });
    if (fe) fe.addEventListener('change', resumen);
    if (frm) frm.addEventListener('submit', function () { calc(); });
    calc();
    resumen();
  })();

  /* Calendario del medico */
  var ecEl = document.getElementById('ec');
  if (!ecEl) return;

  var scriptUrls = [
    <?= json_encode(asset('vendor/event-calendar/event-calendar.min.js') . '?v=372') ?>,
    'https://unpkg.com/@event-calendar/build@5.7.1/dist/event-calendar.min.js',
    'https://cdn.jsdelivr.net/npm/@event-calendar/build@5.7.1/dist/event-calendar.min.js'
  ];
  function loadScript(src) {
    return new Promise(function (resolve, reject) {
      var s = document.createElement('script');
      s.src = src; s.onload = resolve; s.onerror = function () { reject(new Error('No se pudo cargar ' + src)); };
      document.head.appendChild(s);
    });
  }
  function pad(n) { return (n < 10 ? '0' : '') + n; }
  function fecha(d) { return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }
  function hora(d) { return pad(d.getHours()) + ':' + pad(d.getMinutes()); }
  function tomar(start) {
    var f = document.getElementById('f_fecha'), hi = document.getElementById('f_hi'), hf = document.getElementById('f_hf');
    if (!f) return;
    var s = start instanceof Date ? start : new Date(start);
    s.setMinutes(0, 0, 0);
    if (!permitido(s)) return;
    var e = new Date(s.getTime() + 60 * 60000);
    f.value = fecha(s); hi.value = hora(s); hf.value = hora(e);
    resumen();
    var box = document.getElementById('resumen-cita');
    (box || document.getElementById('form-cita')).scrollIntoView({ behavior: 'smooth', block: 'center' });
  }



  var HOR = window.HORARIO_MEDICO || { hora_inicio: '07:00', hora_fin: '21:00', comida_inicio: '', comida_fin: '' };
  function min(v) { var p = (v || '0:0').split(':'); return parseInt(p[0], 10) * 60 + parseInt(p[1] || '0', 10); }
  /* Rechaza dias y horas fuera del horario de atencion del medico. */
  function permitido(s) {
    var d = s.getDay();
    if (d === 0 || d === 6) { alert('Solo puedes agendar de lunes a viernes.'); return false; }
    var ini = s.getHours() * 60, fin = ini + 60;
    if (ini < min(HOR.hora_inicio) || fin > min(HOR.hora_fin)) {
      alert('El medico atiende de ' + HOR.hora_inicio + ' a ' + HOR.hora_fin + '.'); return false;
    }
    if (HOR.comida_inicio && HOR.comida_fin && ini < min(HOR.comida_fin) && min(HOR.comida_inicio) < fin) {
      alert('Ese horario es la hora de comida del medico (' + HOR.comida_inicio + ' a ' + HOR.comida_fin + ').'); return false;
    }
    return true;
  }

  function options() {
    return {
      view: 'timeGridWeek', locale: 'es', firstDay: 1, height: '100%',
      slotMinTime: HOR.hora_inicio + ':00', slotMaxTime: HOR.hora_fin + ':00', selectable: true,
      hiddenDays: [0, 6],
      slotDuration: '01:00:00', slotLabelInterval: '01:00:00', snapDuration: '01:00:00',
      headerToolbar: { start: 'prev,next today', center: 'title', end: 'dayGridMonth,timeGridWeek,timeGridDay' },
      buttonText: { today: 'Hoy', dayGridMonth: 'Mes', timeGridWeek: 'Semana', timeGridDay: 'Dia' },
      events: window.CITAS_EVENTS || [],
      dateClick: function (info) { tomar(info.date); },
      select: function (info) { tomar(info.start); }
    };
  }
  (async function () {
    try {
      for (var i = 0; i < scriptUrls.length && !window.EventCalendar; i++) {
        try { await loadScript(scriptUrls[i]); } catch (e) { console.warn(e.message); }
      }
      var EC = window.EventCalendar;
      if (!EC) { ecEl.innerHTML = '<div class="calendar-error">No se pudo cargar el calendario.</div>'; return; }
      ecEl.innerHTML = '';
      if (typeof EC === 'function') new EC(ecEl, options());
      else if (typeof EC.create === 'function') EC.create(ecEl, options());
      else if (typeof EC.createCalendar === 'function') EC.createCalendar(ecEl, [], options());
    } catch (e) { ecEl.innerHTML = '<div class="calendar-error">' + e.message + '</div>'; }
  })();
})();
</script>
</body>
</html>
