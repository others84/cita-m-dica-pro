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

    if (typeof EventCalendar === 'undefined') {
      target.innerHTML = '<div class="calendar-error">No se pudo cargar la librería del calendario.</div>';
      return;
    }

    const options = {
      view: 'timeGridWeek',
      locale: 'es',
      height: 700,
      headerToolbar: { start: 'prev,next today', center: 'title', end: 'dayGridMonth,timeGridWeek,timeGridDay' },
      events: [
        { title: 'Cita demo', start: new Date().toISOString().slice(0, 10) + ' 10:00', end: new Date().toISOString().slice(0, 10) + ' 10:30' }
      ]
    };

    try {
      new EventCalendar(target, options);
    } catch (error) {
      target.innerHTML = '<div class="calendar-error">No se pudo inicializar el calendario.</div>';
      console.error(error);
    }
  })();
</script>