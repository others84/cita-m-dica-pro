<div class="card">
  <div id="ec" style="min-height:700px;"></div>
</div>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@event-calendar/build@3.7.0/dist/event-calendar.min.css">
<script src="https://cdn.jsdelivr.net/npm/@event-calendar/build@3.7.0/dist/event-calendar.min.js"></script>
<script>
  (function () {
    const target = document.getElementById('ec');
    const options = {
      view: 'timeGridWeek',
      locale: 'es',
      height: 700,
      headerToolbar: { start: 'prev,next today', center: 'title', end: 'dayGridMonth,timeGridWeek,timeGridDay' },
      events: [
        { title: 'Cita demo', start: new Date().toISOString().slice(0,10) + ' 10:00', end: new Date().toISOString().slice(0,10) + ' 10:30' }
      ]
    };
    if (typeof EventCalendar.create === 'function') {
      EventCalendar.create(target, options);
    } else {
      new EventCalendar(target, options);
    }
  })();
</script>