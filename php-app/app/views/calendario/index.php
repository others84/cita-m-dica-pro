<link rel="stylesheet" href="<?= asset('vendor/event-calendar/event-calendar.min.css') ?>?v=372" onerror="this.onerror=null;this.href='https://cdn.jsdelivr.net/npm/@event-calendar/build@3.7.2/event-calendar.min.css';">

<style>
  .calendar-card{min-height:760px;padding:1rem;overflow:auto;background:#fff;border:1px solid #BFDFFF;border-radius:10px}
  #ec{height:700px;min-height:700px;width:100%}
  .calendar-loading,.calendar-error{padding:1rem;border-radius:8px;color:#1E3A5F;background:#EAF6FF;border:1px solid #7FB6E6}
  .calendar-error{color:#7f1d1d;background:#fdecea;border-color:#c0392b}
</style>

<div class="card calendar-card">
  <div id="ec"><div class="calendar-loading">Cargando calendario...</div></div>
</div>

<script>
  (function () {
    const target = document.getElementById('ec');
    const localScript = "<?= asset('vendor/event-calendar/event-calendar.min.js') ?>?v=372";
    const cdnScript = 'https://cdn.jsdelivr.net/npm/@event-calendar/build@3.7.2/event-calendar.min.js';

    function showCalendarError(message) {
      if (target) {
        target.innerHTML = '<div class="calendar-error">' + message + '</div>';
      }
    }

    function loadScript(src, onError) {
      const script = document.createElement('script');
      script.src = src;
      script.onload = initCalendar;
      script.onerror = onError;
      document.body.appendChild(script);
    }

    function initCalendar() {
      if (!target || target.dataset.ready === '1') {
        return;
      }

      if (typeof EventCalendar === 'undefined') {
        showCalendarError('No se pudo cargar la librería del calendario.');
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
          showCalendarError('La versión del calendario no es compatible.');
          return;
        }
        target.dataset.ready = '1';
      } catch (error) {
        console.error(error);
        showCalendarError('No se pudo inicializar el calendario.');
      }
    }

    if (!target) {
      return;
    }

    loadScript(localScript, function () {
      loadScript(cdnScript, function () {
        showCalendarError('No se encontró el archivo del calendario. Revisa public/assets/vendor/event-calendar/.');
      });
    });
  })();
</script>