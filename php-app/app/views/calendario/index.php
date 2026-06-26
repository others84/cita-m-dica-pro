<link rel="stylesheet" href="<?= asset('vendor/event-calendar/event-calendar.min.css') ?>?v=372" onerror="this.onerror=null;this.href='https://cdn.jsdelivr.net/npm/@event-calendar/build@3.7.2/event-calendar.min.css';">

<style>
  .calendar-card{min-height:760px;padding:1rem;overflow:auto;background:#fff;border:1px solid #BFDFFF;border-radius:10px}
  #ec{height:700px;min-height:700px;width:100%}
  .calendar-loading,.calendar-error{padding:1rem;border-radius:8px;color:#1E3A5F;background:#EAF6FF;border:1px solid #7FB6E6;margin-bottom:1rem}
  .calendar-error{color:#7f1d1d;background:#fdecea;border-color:#c0392b}
  .calendar-fallback{border:1px solid #BFDFFF;border-radius:10px;overflow:hidden;background:#fff;color:#1E3A5F}
  .calendar-fallback__bar{display:flex;justify-content:space-between;align-items:center;gap:1rem;padding:.75rem 1rem;background:#EAF6FF;border-bottom:1px solid #BFDFFF}
  .calendar-fallback__title{font-weight:700}
  .calendar-fallback__grid{display:grid;grid-template-columns:80px repeat(7,minmax(110px,1fr));min-width:860px}
  .calendar-fallback__cell{min-height:58px;padding:.45rem;border-right:1px solid #BFDFFF;border-bottom:1px solid #BFDFFF;font-size:.85rem}
  .calendar-fallback__head{background:#F8FCFF;font-weight:700;text-align:center}
  .calendar-fallback__time{background:#F8FCFF;color:#3E7FB1;text-align:right}
  .calendar-fallback__event{background:#3E7FB1;color:#fff;border-radius:6px;padding:.35rem;font-size:.8rem}
</style>

<div class="card calendar-card">
  <div id="calendarStatus" class="calendar-loading">Cargando calendario...</div>
  <div id="ec"></div>
  <div id="calendarFallback" class="calendar-fallback" aria-label="Vista básica del calendario">
    <div class="calendar-fallback__bar">
      <span class="calendar-fallback__title">Calendario de citas</span>
      <span>Semana actual</span>
    </div>
    <div class="calendar-fallback__grid">
      <div class="calendar-fallback__cell calendar-fallback__head">Hora</div>
      <div class="calendar-fallback__cell calendar-fallback__head">Dom</div>
      <div class="calendar-fallback__cell calendar-fallback__head">Lun</div>
      <div class="calendar-fallback__cell calendar-fallback__head">Mar</div>
      <div class="calendar-fallback__cell calendar-fallback__head">Mié</div>
      <div class="calendar-fallback__cell calendar-fallback__head">Jue</div>
      <div class="calendar-fallback__cell calendar-fallback__head">Vie</div>
      <div class="calendar-fallback__cell calendar-fallback__head">Sáb</div>
      <?php foreach (['08:00','09:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00'] as $hora): ?>
        <div class="calendar-fallback__cell calendar-fallback__time"><?= $hora ?></div>
        <?php for ($dia = 0; $dia < 7; $dia++): ?>
          <div class="calendar-fallback__cell"><?= ($hora === '10:00' && $dia === 5) ? '<div class="calendar-fallback__event">Cita demo</div>' : '' ?></div>
        <?php endfor; ?>
      <?php endforeach; ?>
    </div>
  </div>
</div>

<script>
  (function () {
    const target = document.getElementById('ec');
    const status = document.getElementById('calendarStatus');
    const fallback = document.getElementById('calendarFallback');
    const localScript = "<?= asset('vendor/event-calendar/event-calendar.min.js') ?>?v=372";
    const cdnScript = 'https://cdn.jsdelivr.net/npm/@event-calendar/build@3.7.2/event-calendar.min.js';
    let loadedFromCdn = false;

    function showCalendarError(message) {
      if (status) {
        status.className = 'calendar-error';
        status.textContent = message;
      }
      if (fallback) fallback.style.display = 'block';
    }

    function loadScript(src, onError) {
      const script = document.createElement('script');
      script.src = src;
      script.onload = function () { initCalendar(src); };
      script.onerror = onError;
      document.body.appendChild(script);
    }

    function initCalendar(source) {
      if (!target || target.dataset.ready === '1') {
        return;
      }

      if (typeof EventCalendar === 'undefined') {
        if (!loadedFromCdn) {
          loadedFromCdn = true;
          loadScript(cdnScript, function () {
            showCalendarError('No se pudo cargar la librería del calendario. Se muestra la vista básica.');
          });
          return;
        }
        showCalendarError('No se pudo cargar la librería del calendario. Se muestra la vista básica.');
        return;
      }

      const today = new Date();
      const start = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 10, 0);
      const end = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 10, 30);

      const options = {
        view: 'timeGridWeek',
        locale: 'es',
        height: 700,
        headerToolbar: {
          start: 'prev,next today',
          center: 'title',
          end: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        events: [
          { title: 'Cita demo', start: start, end: end }
        ]
      };

      try {
        target.innerHTML = '';
        if (typeof EventCalendar === 'function') {
          new EventCalendar(target, options);
        } else if (EventCalendar && typeof EventCalendar.create === 'function') {
          EventCalendar.create(target, options);
        } else {
          showCalendarError('La versión del calendario no es compatible. Se muestra la vista básica.');
          return;
        }

        if (!target.querySelector('.ec')) {
          throw new Error('El calendario no generó contenido visible desde ' + source);
        }

        target.dataset.ready = '1';
        if (status) status.style.display = 'none';
        if (fallback) fallback.style.display = 'none';
      } catch (error) {
        console.error(error);
        if (!loadedFromCdn) {
          loadedFromCdn = true;
          target.innerHTML = '';
          loadScript(cdnScript, function () {
            showCalendarError('No se pudo inicializar el calendario. Se muestra la vista básica.');
          });
          return;
        }
        showCalendarError('No se pudo inicializar el calendario. Se muestra la vista básica.');
      }
    }

    if (!target) {
      return;
    }

    loadScript(localScript, function () {
      loadedFromCdn = true;
      loadScript(cdnScript, function () {
        showCalendarError('No se encontró el archivo del calendario. Revisa public/assets/vendor/event-calendar/. Se muestra la vista básica.');
      });
    });
  })();
</script>