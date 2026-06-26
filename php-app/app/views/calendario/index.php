<link rel="stylesheet" href="<?= asset('vendor/event-calendar/event-calendar.min.css') ?>?v=372">

<div class="card calendar-card">
  <div id="ec" class="calendar-box">
    <div class="calendar-loading">Cargando calendario...</div>
  </div>
</div>

<script src="<?= asset('vendor/event-calendar/event-calendar.min.js') ?>?v=372"></script>
<script>
  (function () {
    function showCalendarError(message) {
      const ecEl = document.getElementById('ec');
      if (!ecEl) return;
      ecEl.innerHTML = '<div class="calendar-error">' + message + '</div>';
    }

    function initCalendar() {
      const ecEl = document.getElementById('ec');
      if (!ecEl) return;

      if (typeof EventCalendar !== 'function') {
        showCalendarError('No se cargó la librería EventCalendar. Revisa que exista public/assets/vendor/event-calendar/event-calendar.min.js');
        return;
      }

      const baseDate = new Date();
      baseDate.setHours(9, 0, 0, 0);

      function appointment(daysFromToday, startHour, durationHours) {
        const start = new Date(baseDate);
        start.setDate(start.getDate() + daysFromToday);
        start.setHours(startHour, 0, 0, 0);

        const end = new Date(start);
        end.setHours(start.getHours() + durationHours);

        return { start: start, end: end };
      }

      const cita1 = appointment(0, 9, 1);
      const cita2 = appointment(1, 11, 1);
      const cita3 = appointment(2, 16, 1);

      try {
        new EventCalendar(ecEl, {
          view: 'timeGridWeek',
          locale: 'es',
          firstDay: 1,
          height: '700px',
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
            { id: '1', title: 'Consulta — Juan Pérez', start: cita1.start, end: cita1.end },
            { id: '2', title: 'Revisión — María López', start: cita2.start, end: cita2.end },
            { id: '3', title: 'Control — Pedro Ruiz', start: cita3.start, end: cita3.end }
          ]
        });
      } catch (error) {
        showCalendarError('No se pudo inicializar el calendario: ' + error.message);
      }
    }

    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', initCalendar);
    } else {
      initCalendar();
    }
  })();
</script>