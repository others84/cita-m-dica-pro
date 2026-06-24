<?php $titulo = 'Calendario de citas'; require __DIR__ . '/../layouts/header.php'; ?>
<div class="shell">
  <?php require __DIR__ . '/../layouts/sidebar.php'; ?>
  <main class="main">
    <h1>Calendario de citas</h1>
    <div class="card">
      <div id="ec" style="height:700px"></div>
    </div>
  </main>
</div>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@event-calendar/build@5.7.1/dist/event-calendar.min.css">
<script src="https://cdn.jsdelivr.net/npm/@event-calendar/build@5.7.1/dist/event-calendar.min.js"></script>
<script>
  const hoy = new Date(); hoy.setHours(9,0,0,0);
  const m = (d,h)=>{const x=new Date(hoy);x.setDate(x.getDate()+d);x.setHours(h);return x;};
  EventCalendar.create(document.getElementById('ec'), {
    view: 'timeGridWeek',
    headerToolbar: { start: 'prev,next today', center: 'title', end: 'dayGridMonth,timeGridWeek,timeGridDay' },
    locale: 'es',
    firstDay: 1,
    buttonText: { today:'Hoy', dayGridMonth:'Mes', timeGridWeek:'Semana', timeGridDay:'Día' },
    events: [
      { id:'1', title:'Consulta — Juan Pérez',   start:m(0,9),  end:m(0,10) },
      { id:'2', title:'Revisión — María López',  start:m(1,11), end:m(1,12) },
      { id:'3', title:'Control — Pedro Ruiz',    start:m(2,16), end:m(2,17) },
    ],
  });
</script>
<?php require __DIR__ . '/../layouts/footer.php'; ?>
