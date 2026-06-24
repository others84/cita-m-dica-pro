<?php
$titulo = 'Calendario de citas';
$publicPath = rtrim(str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? '')), '/');
$assetBase = ($publicPath === '' || $publicPath === '/') ? '' : $publicPath;
require __DIR__ . '/../layouts/header.php';
?>
<div class="shell">
  <?php require __DIR__ . '/../layouts/sidebar.php'; ?>
  <main class="main">
    <h1>Calendario de citas</h1>
    <div class="card">
      <div id="ec" style="height:700px"></div>
    </div>
  </main>
</div>

<link rel="stylesheet" href="<?= htmlspecialchars($assetBase, ENT_QUOTES, 'UTF-8') ?>/assets/vendor/event-calendar/event-calendar.min.css">
<script>
  (function () {
    const ecEl = document.getElementById('ec');
    const assetBase = <?= json_encode($assetBase) ?>;
    const scriptUrls = [
      assetBase + '/assets/vendor/event-calendar/event-calendar.min.js',
      'https://unpkg.com/@event-calendar/build@5.7.1/dist/event-calendar.min.js',
      'https://cdn.jsdelivr.net/npm/@event-calendar/build@5.7.1/dist/event-calendar.min.js'
    ];

    function loadScript(src) {
      return new Promise(function (resolve, reject) {
        const url = new URL(src, window.location.href).href;
        const existing = Array.from(document.scripts).find(function (script) {
          return script.src === url;
        });

        if (existing) {
          existing.addEventListener('load', resolve, { once: true });
          existing.addEventListener('error', reject, { once: true });
          return;
        }

        const script = document.createElement('script');
        script.src = src;
        script.onload = resolve;
        script.onerror = function () { reject(new Error('No se pudo cargar ' + src)); };
        document.head.appendChild(script);
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

    async function initCalendar() {
      const EventCalendarLib = await getEventCalendar();
      if (!EventCalendarLib) {
        ecEl.innerHTML = '<p>No se pudo cargar el calendario. Verifica que exista <code>' + assetBase + '/assets/vendor/event-calendar/event-calendar.min.js</code>.</p>';
        console.error('EventCalendar no se cargó desde ninguna ruta:', scriptUrls);
        return;
      }

      const hoy = new Date(); hoy.setHours(9,0,0,0);
      const m = (d,h)=>{const x=new Date(hoy);x.setDate(x.getDate()+d);x.setHours(h);return x;};

      EventCalendarLib.create(ecEl, {
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
    }

    initCalendar();
  })();
</script>
<?php require __DIR__ . '/../layouts/footer.php'; ?>
