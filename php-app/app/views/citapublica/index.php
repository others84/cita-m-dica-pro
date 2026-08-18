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
    <h1>Generar cita</h1>
    <p class="subtitle">Sistema de gestion de citas online (SGCO)</p>
  </div>
  <a class="btn" href="<?= url('auth/login') ?>">Iniciar sesion</a>
</header>

<main class="publica-wrap">
  <?php foreach (($flash ?? []) as $f): ?>
    <div class="flash flash-<?= htmlspecialchars($f['type'] ?? 'info') ?>"><?= htmlspecialchars($f['msg'] ?? '') ?></div>
  <?php endforeach; ?>

  <!-- Paso 1: identificacion por celular -->
  <section class="card">
    <h2>1. Identificate</h2>
    <form method="post" action="<?= url('citapublica/buscar') ?>" class="form-grid"><?= csrf_field() ?>
      <label>Celular (10 digitos)
        <input name="telefono" inputmode="numeric" maxlength="20" required value="<?= htmlspecialchars($telefono) ?>">
      </label>
      <div class="form-actions">
        <button class="btn" type="submit">Buscar mis datos</button>
        <a class="btn btn-sec" href="<?= url('citapublica/reiniciar') ?>">Empezar de nuevo</a>
      </div>
    </form>
    <?php if ($paso === 'elige_clinica' && !empty($coincidencias)): ?>
      <p>Encontramos tu registro en varias clinicas. Selecciona en cual deseas atenderte:</p>
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

  <!-- Paso 2: panel clinica -->
  <section class="card">
    <h2>2. Clinica</h2>
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
      <p class="muted">Selecciona una clinica para ver medicos, consultorios y especialidades.</p>
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
          <select name="id_CONSULTORIO" required onchange="this.form.submit()">
            <option value="">-- seleccione --</option>
            <?php foreach ($consultorios as $co): ?>
              <option value="<?= (int)$co['id_CONSULTORIO'] ?>" <?= $idConsultorio === (int)$co['id_CONSULTORIO'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($co['nombre'] ?? '') ?>
              </option>
            <?php endforeach; ?>
          </select>
        </label>
        <label>Especialidad
          <select name="id_CATALOGO_ESPECIALIDAD" required onchange="this.form.submit()">
            <option value="">-- seleccione --</option>
            <?php foreach ($especialidades as $es): ?>
              <option value="<?= (int)$es['id_CATALOGO_ESPECIALIDAD'] ?>" <?= $idEspecialidad === (int)$es['id_CATALOGO_ESPECIALIDAD'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($es['nombre'] ?? '') ?>
              </option>
            <?php endforeach; ?>
          </select>
        </label>
      </form>
    <?php endif; ?>
  </section>

  <!-- Paso 3: calendario del medico -->
  <section class="card calendar-card">
    <h2>3. Agenda del medico</h2>
    <?php if (!$idMedico): ?>
      <p class="muted">Selecciona un medico para ver sus horarios ocupados y elegir el tuyo.</p>
    <?php else: ?>
      <p class="muted">Los bloques en gris ya estan ocupados. Haz clic en un espacio libre para tomar ese horario.</p>
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
      <h2>4. Tus datos</h2>
      <?php if ($soloLectura): ?>
        <p class="muted">Encontramos tu registro; verifica tus datos. Si algo cambio, avisanos en la clinica.</p>
      <?php endif; ?>
      <div class="form-grid">
        <label>Apellido paterno <input name="ap_paterno" required maxlength="60" value="<?= $v('ap_paterno') ?>" <?= $soloLectura ? 'readonly' : '' ?>></label>
        <label>Apellido materno <input name="ap_materno" required maxlength="60" value="<?= $v('ap_materno') ?>" <?= $soloLectura ? 'readonly' : '' ?>></label>
        <label>Nombre(s) <input name="nombre" required maxlength="60" value="<?= $v('nombre') ?>" <?= $soloLectura ? 'readonly' : '' ?>></label>
        <label>Direccion <input name="direccion" required maxlength="150" value="<?= $v('direccion') ?>" <?= $soloLectura ? 'readonly' : '' ?>></label>
        <label>Celular <input name="telefono" required maxlength="20" value="<?= $paciente ? $v('telefono') : htmlspecialchars($telefono) ?>" <?= $soloLectura ? 'readonly' : '' ?>></label>
        <label>Email <input type="email" name="email" required maxlength="120" value="<?= $v('email') ?>" <?= $soloLectura ? 'readonly' : '' ?>></label>
        <label>Fecha nacimiento <input type="date" name="fecha_nacimiento" required value="<?= $v('fecha_nacimiento') ?>" <?= $soloLectura ? 'readonly' : '' ?>></label>
        <label>Genero
          <select name="id_CATALOGO_GENERO" required <?= $soloLectura ? 'disabled' : '' ?>>
            <option value="">--</option>
            <?php foreach ($generos as $g): ?>
              <option value="<?= (int)$g['id_CATALOGO_GENERO'] ?>" <?= (int)($paciente['id_CATALOGO_GENERO'] ?? 0) === (int)$g['id_CATALOGO_GENERO'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($g['nombre']) ?>
              </option>
            <?php endforeach; ?>
          </select>
        </label>
        <label>Pais
          <select id="sel_pais" <?= $soloLectura ? 'disabled' : 'required' ?>>
            <option value="">-- seleccione --</option>
            <?php foreach ($paises as $p): ?>
              <option value="<?= (int)$p['id_CATALOGO_PAIS'] ?>" <?= $selPais === (int)$p['id_CATALOGO_PAIS'] ? 'selected' : '' ?>><?= htmlspecialchars($p['nombre']) ?></option>
            <?php endforeach; ?>
          </select>
        </label>
        <label>Estado
          <select id="sel_estado" <?= $soloLectura ? 'disabled' : 'required' ?>>
            <option value="">-- seleccione --</option>
            <?php foreach ($estados as $e): ?>
              <option value="<?= (int)$e['id_CATALOGO_ESTADOS'] ?>" data-pais="<?= (int)($e['id_CATALOGO_PAIS'] ?? 0) ?>" <?= $selEstado === (int)$e['id_CATALOGO_ESTADOS'] ? 'selected' : '' ?>><?= htmlspecialchars($e['nombre']) ?></option>
            <?php endforeach; ?>
          </select>
        </label>
        <label>Municipio
          <select id="sel_municipio" name="id_CATALOGO_MUNICIPIO" required <?= $soloLectura ? 'disabled' : '' ?>>
            <option value="">-- seleccione --</option>
            <?php foreach ($municipios as $mu): ?>
              <option value="<?= (int)$mu['id_CATALOGO_MUNICIPIO'] ?>" data-estado="<?= (int)($mu['id_CATALOGO_ESTADOS'] ?? 0) ?>" <?= $selMun === (int)$mu['id_CATALOGO_MUNICIPIO'] ? 'selected' : '' ?>><?= htmlspecialchars($mu['nombre']) ?></option>
            <?php endforeach; ?>
          </select>
        </label>
        <label class="col-span">Observaciones
          <textarea name="observaciones" rows="3" maxlength="500" <?= $soloLectura ? 'readonly' : '' ?>><?= $v('observaciones') ?></textarea>
        </label>
        <label class="chk"><input type="checkbox" name="notifica_wa" value="1" <?= !empty($paciente['notifica_wa']) ? 'checked' : '' ?>> Avisarme por WhatsApp</label>
        <label class="chk"><input type="checkbox" name="notifica_email" value="1" <?= !empty($paciente['notifica_email']) ? 'checked' : '' ?>> Avisarme por correo</label>
      </div>
    </section>

    <section class="card">
      <h2>5. Horario</h2>
      <div class="form-grid">
        <label>Fecha <input type="date" id="f_fecha" name="fecha_cita" required min="<?= date('Y-m-d') ?>"></label>
        <label>Hora inicio <input type="time" id="f_hi" name="hora_inicio" required></label>
        <label>Hora fin <input type="time" id="f_hf" name="hora_fin" required></label>
      </div>
      <div class="form-actions">
        <button class="btn btn-primary" type="submit">Agendar</button>
      </div>
    </section>
  </form>
</main>

<script>
window.CITAS_EVENTS = <?= json_encode($eventos ?? [], JSON_HEX_TAG | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE) ?>;
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
  function tomar(start, end) {
    var f = document.getElementById('f_fecha'), hi = document.getElementById('f_hi'), hf = document.getElementById('f_hf');
    if (!f) return;
    var s = start instanceof Date ? start : new Date(start);
    var e = end instanceof Date ? end : new Date(end || (s.getTime() + 30 * 60000));
    f.value = fecha(s); hi.value = hora(s); hf.value = hora(e);
    document.getElementById('form-cita').scrollIntoView({ behavior: 'smooth', block: 'end' });
  }
  function options() {
    return {
      view: 'timeGridWeek', locale: 'es', firstDay: 1, height: '100%',
      slotMinTime: '07:00:00', slotMaxTime: '21:00:00', selectable: true,
      headerToolbar: { start: 'prev,next today', center: 'title', end: 'dayGridMonth,timeGridWeek,timeGridDay' },
      buttonText: { today: 'Hoy', dayGridMonth: 'Mes', timeGridWeek: 'Semana', timeGridDay: 'Dia' },
      events: window.CITAS_EVENTS || [],
      dateClick: function (info) { tomar(info.date); },
      select: function (info) { tomar(info.start, info.end); }
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
