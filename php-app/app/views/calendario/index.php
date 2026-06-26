<link rel="stylesheet" href="/assets/vendor/event-calendar/event-calendar.min.css">

<div class="card calendar-card">
  <div id="ec"></div>
</div>

<script src="/assets/vendor/event-calendar/event-calendar.min.js"></script>
<script>
  (function () {
    const target = document.getElementById('ec');
    if (!target || typeof EventCalendar === 'undefined') {
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

    new EventCalendar(target, options);
  })();
</script>