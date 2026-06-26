<link rel="stylesheet" href="<?= asset('vendor/event-calendar/event-calendar.min.css') ?>">

<div class="card calendar-card">
  <div id="ec"></div>
</div>

<script src="<?= asset('vendor/event-calendar/event-calendar.min.js') ?>"></script>
<script>
  (function () {
    const target = document.getElementById('ec');
    if (!target) {
      return;
    }

    function showCalendarError(message) {
      target.innerHTML = '<div class="calendar-error">' + message + '</div>';
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
      headerToolbar: { start: 'prev,next today', center: 'title', end: 'dayGridMonth,timeGridWeek,timeGridDay' },
      events: [
        { title: 'Cita demo', start: start, end: end }
      ]
    };

    try {
      if (typeof EventCalendar === 'function') {
        new EventCalendar(target, options);
      } else if (typeof EventCalendar.create === 'function') {
        EventCalendar.create(target, options);
      } else {
        showCalendarError('La versión del calendario no es compatible.');
      }
    } catch (error) {
      showCalendarError('No se pudo inicializar el calendario.');
      console.error(error);
    }
  })();
</script>