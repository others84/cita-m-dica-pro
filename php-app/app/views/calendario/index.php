<link rel="stylesheet" href="<?= asset('vendor/event-calendar/event-calendar.min.css') ?>?v=372">
<?php $controller='calendario'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>

<?php if (!empty($medicos)): ?>
<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Medico</h3>
  <form method="post" action="<?= url('calendario/filtrar') ?>" class="form-grid"><?= csrf_field() ?>
    <label>Medico
      <select name="f_medico" onchange="this.form.submit()">
        <?php if (count($medicos) > 1): ?>
          <option value="">-- todos --</option>
        <?php endif; ?>
        <?php foreach ($medicos as $m): ?>
          <option value="<?= (int)$m['id_USUARIOS'] ?>" <?= (int)($fMedico ?? 0) === (int)$m['id_USUARIOS'] ? 'selected' : '' ?>>
            <?= htmlspecialchars($m['nombre_completo'] ?? '') ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>
<?php endif; ?>

<?php if (!empty($errorCarga)): ?>
  <div class="flash flash-error">No se pudieron cargar las citas desde la base de datos: <?= htmlspecialchars($errorCarga) ?></div>
<?php endif; ?>

<div class="card calendar-card">
  <div id="ec-contador" class="cal-contador">Citas agendadas: <strong id="ec-contador-num">0</strong></div>
  <div id="ec" class="calendar-box" style="height:700px;min-height:700px;width:100%;background:#fff;">
    <div class="calendar-loading">Cargando calendario...</div>
  </div>
</div>

<div id="cita-modal" style="display:none"></div>

<script>
window.CITAS_EVENTS = <?= json_encode($eventos ?? [], JSON_HEX_TAG | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE) ?>;
</script>

<script>
(function () {
  const localCss = <?= json_encode(asset('vendor/event-calendar/event-calendar.min.css') . '?v=372') ?>;
  const scriptUrls = [
    <?= json_encode(asset('vendor/event-calendar/event-calendar.min.js') . '?v=372') ?>,
    'https://unpkg.com/@event-calendar/build@5.7.1/dist/event-calendar.min.js',
    'https://cdn.jsdelivr.net/npm/@event-calendar/build@5.7.1/dist/event-calendar.min.js'
  ];

  function showCalendarError(message) {
    const ecEl = document.getElementById('ec');
    if (!ecEl) return;
    ecEl.innerHTML = '<div class="calendar-error"><strong>No se pudo mostrar el calendario.</strong><br>' + message + '</div>';
  }
  function ensureStylesheet() {
    const href = new URL(localCss, window.location.href).href;
    const exists = Array.from(document.styleSheets).some(s => s.href === href);
    if (!exists) {
      const link = document.createElement('link');
      link.rel = 'stylesheet'; link.href = localCss;
      document.head.appendChild(link);
    }
  }
  function loadScript(src) {
    return new Promise((resolve, reject) => {
      const abs = new URL(src, window.location.href).href;
      const existing = Array.from(document.scripts).find(s => s.src === abs);
      if (existing && window.EventCalendar) { resolve(); return; }
      const s = existing || document.createElement('script');
      s.onload = resolve;
      s.onerror = () => reject(new Error('No se pudo cargar: ' + src));
      if (!existing) { s.src = src; document.head.appendChild(s); }
    });
  }
  async function getEventCalendar() {
    if (window.EventCalendar) return window.EventCalendar;
    for (const u of scriptUrls) {
      try { await loadScript(u); if (window.EventCalendar) return window.EventCalendar; }
      catch (e) { console.warn(e.message); }
    }
    return null;
  }

  function esc(s) {
    return String(s ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  }

  function showModal(info) {
    const p = info.extendedProps || {};
    const html = '' +
      '<div class="modal-backdrop" onclick="if(event.target===this) this.remove()">' +
        '<div class="modal">' +
          '<h3>Detalle de la cita</h3>' +
          '<dl>' +
            '<dt>Paciente</dt><dd>' + esc(p.paciente) + '</dd>' +
            '<dt>Medico</dt><dd>' + esc(p.medico) + '</dd>' +
            '<dt>Especialidad</dt><dd>' + esc(p.especialidad) + '</dd>' +
            '<dt>Consultorio</dt><dd>' + esc(p.consultorio) + '</dd>' +
            '<dt>Estado</dt><dd>' + esc(p.estado) + '</dd>' +
            '<dt>Precio</dt><dd>$ ' + esc(p.precio) + '</dd>' +
            '<dt>Inicio</dt><dd>' + esc(info.start && info.start.toLocaleString ? info.start.toLocaleString() : info.start) + '</dd>' +
            '<dt>Observaciones paciente</dt><dd style="white-space:pre-wrap">' + esc(p.observaciones_paciente || '-') + '</dd>' +
          '</dl>' +
          '<div class="modal-actions"><button type="button" class="btn" onclick="this.closest(\'.modal-backdrop\').remove()">Cerrar</button></div>' +
        '</div>' +
      '</div>';
    const wrap = document.createElement('div');
    wrap.innerHTML = html;
    document.body.appendChild(wrap.firstChild);
  }

  function etiquetaVista(v) {
    if (v === 'timeGridDay') return 'en el dia seleccionado';
    if (v === 'dayGridMonth') return 'en el mes seleccionado';
    return 'en la semana seleccionada';
  }
  function actualizarContador(info) {
    const cont = document.getElementById('ec-contador');
    if (!cont || !info) return;
    const ini = info.start instanceof Date ? info.start : new Date(info.start);
    const fin = info.end   instanceof Date ? info.end   : new Date(info.end);
    const evs = window.CITAS_EVENTS || [];
    let n = 0;
    for (const e of evs) {
      const d = new Date(e.start);
      if (d >= ini && d < fin) n++;
    }
    const vista = (info.view && info.view.type) || '';
    cont.innerHTML = 'Citas agendadas ' + etiquetaVista(vista) + ': <strong>' + n + '</strong>';
  }

  function buildOptions() {
    return {
      view: 'timeGridWeek',
      locale: 'es',
      firstDay: 1,
      height: '100%',
      slotMinTime: '07:00:00',
      slotMaxTime: '21:00:00',
      headerToolbar: {
        start: 'prev,next today',
        center: 'title',
        end: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      buttonText: { today:'Hoy', dayGridMonth:'Mes', timeGridWeek:'Semana', timeGridDay:'Dia' },
      events: window.CITAS_EVENTS || [],
      eventContent: function (info) {
        const p = info.event.extendedProps || {};
        return { html:
          '<div class="ec-event-body">' +
            '<span class="ev-pac">' + esc(p.paciente || info.event.title) + '</span>' +
            (p.medico       ? '<span class="ev-med">Dr. ' + esc(p.medico) + '</span>' : '') +
            (p.especialidad ? '<span class="ev-esp">' + esc(p.especialidad) + '</span>' : '') +
          '</div>'
        };
      },
      eventClick: function (info) {
        showModal({ extendedProps: info.event.extendedProps, start: info.event.start });
      },
      datesSet: function (info) { actualizarContador(info); }
    };
  }

  async function initCalendar() {
    const ecEl = document.getElementById('ec');
    if (!ecEl) return;
    ensureStylesheet();
    try {
      const EC = await getEventCalendar();
      if (!EC) { showCalendarError('No se cargo la libreria EventCalendar.'); return; }
      ecEl.innerHTML = '';
      if (typeof EC === 'function') new EC(ecEl, buildOptions());
      else if (typeof EC.create === 'function') EC.create(ecEl, buildOptions());
      else if (typeof EC.createCalendar === 'function') EC.createCalendar(ecEl, [], buildOptions());
      else showCalendarError('La libreria cargo pero no expone constructor valido.');
    } catch (e) { showCalendarError(e.message); }
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', initCalendar);
  else initCalendar();
})();
</script>
