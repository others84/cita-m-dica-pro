<link rel="stylesheet" href="<?= asset('vendor/event-calendar/event-calendar.min.css') ?>?v=372">

<style>
  .calendar-card {
    min-height: 760px;
    overflow: auto;
  }

  #ec.calendar-box {
    width: 100%;
    height: 700px;
    min-height: 700px;
    background: #ffffff;
    border: 1px solid #BFDFFF;
    border-radius: 8px;
    overflow: hidden;
  }

  #ec .ec {
    height: 100%;
    min-height: 700px;
    --ec-bg-color: #ffffff;
    --ec-text-color: #1E3A5F;
    --ec-event-bg-color: #3E7FB1;
    --ec-event-text-color: #ffffff;
  }

  .calendar-loading,
  .calendar-error {
    height: 100%;
    min-height: 700px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 1rem;
    text-align: center;
    font-weight: 600;
  }

  .calendar-loading {
    color: #3E7FB1;
  }

  .calendar-error {
    flex-direction: column;
    gap: .5rem;
    color: #7f1d1d;
    background: #fdecea;
  }
</style>

<div class="card calendar-card">
  <div id="ec" class="calendar-box" style="height:700px;min-height:700px;width:100%;background:#fff;">
    <div class="calendar-loading">Cargando calendario...</div>
  </div>
</div>

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
      ecEl.innerHTML = '<div class="calendar-error"><strong>No se pudo mostrar el calendario.</strong><span>' + message + '</span></div>';
    }

    function ensureStylesheet() {
      const expectedHref = new URL(localCss, window.location.href).href;
      const exists = Array.from(document.styleSheets).some(function (sheet) {
        return sheet.href === expectedHref;
      });

      if (!exists) {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = localCss;
        document.head.appendChild(link);
      }
    }

    function loadScript(src) {
      return new Promise(function (resolve, reject) {
        const absoluteUrl = new URL(src, window.location.href).href;
        const existing = Array.from(document.scripts).find(function (script) {
          return script.src === absoluteUrl;
        });

        if (existing && window.EventCalendar) {
          resolve();
          return;
        }

        const script = existing || document.createElement('script');
        script.onload = resolve;
        script.onerror = function () {
          reject(new Error('No se pudo cargar: ' + src));
        };

        if (!existing) {
          script.src = src;
          document.head.appendChild(script);
        }
      });
    }

    async function getEventCalendar() {
      if (window.EventCalendar) return window.EventCalendar;

      for (const url of scriptUrls) {
        try {
          await loadScript(url);
          if (window.EventCalendar) return window.EventCalendar;
        } catch (error) {
          console.warn(error.message);
        }
      }

      return null;
    }

    function buildOptions() {
      const today = new Date();
      today.setHours(9, 0, 0, 0);

      function dateAt(daysFromToday, hour) {
        const value = new Date(today);
        value.setDate(value.getDate() + daysFromToday);
        value.setHours(hour, 0, 0, 0);
        return value;
      }

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
        buttonText: {
          today: 'Hoy',
          dayGridMonth: 'Mes',
          timeGridWeek: 'Semana',
          timeGridDay: 'Día'
        },
        events: [
          { id: '1', title: 'Consulta — Juan Pérez', start: dateAt(0, 9), end: dateAt(0, 10) },
          { id: '2', title: 'Revisión — María López', start: dateAt(1, 11), end: dateAt(1, 12) },
          { id: '3', title: 'Control — Pedro Ruiz', start: dateAt(2, 16), end: dateAt(2, 17) }
        ]
      };
    }

    async function initCalendar() {
      const ecEl = document.getElementById('ec');
      if (!ecEl) return;

      ensureStylesheet();

      try {
        const EventCalendarLib = await getEventCalendar();
        if (!EventCalendarLib) {
          showCalendarError('No se encontró window.EventCalendar. Revisa la ruta public/assets/vendor/event-calendar/event-calendar.min.js.');
          return;
        }

        ecEl.innerHTML = '';

        if (typeof EventCalendarLib === 'function') {
          new EventCalendarLib(ecEl, buildOptions());
        } else if (typeof EventCalendarLib.create === 'function') {
          EventCalendarLib.create(ecEl, buildOptions());
        } else if (typeof EventCalendarLib.createCalendar === 'function') {
          EventCalendarLib.createCalendar(ecEl, [], buildOptions());
        } else {
          showCalendarError('La librería cargó, pero no expone un constructor válido.');
          return;
        }

        window.setTimeout(function () {
          if (!ecEl.querySelector('.ec')) {
            showCalendarError('La librería cargó, pero no insertó el calendario dentro de #ec.');
          }
        }, 500);
      } catch (error) {
        showCalendarError(error.message);
      }
    }

    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', initCalendar);
    } else {
      initCalendar();
    }
  })();
</script>