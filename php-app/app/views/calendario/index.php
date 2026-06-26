<div class="card">
  <div id="ec" style="height:700px"></div>
</div>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@event-calendar/build@5.7.1/dist/event-calendar.min.css">
<script>
  (function () {
    const ecEl = document.getElementById('ec');
    const assetBase = <?= json_encode(asset('')) ?>;
    const scriptUrls = [
      assetBase + 'vendor/event-calendar/event-calendar.min.js',
      'https://unpkg.com/@event-calendar/build@5.7.1/dist/event-calendar.min.js',
      'https://cdn.jsdelivr.net/npm/@event-calendar/build@5.7.1/dist/event-calendar.min.js'
    ];

    function loadScript(src) {
      return new Promise(function (resolve, reject) {
        const url = new URL(src, window.location.href).href;
        const existing = Array.from(document.scripts).find(function (s) { return s.src === url; });
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
        } catch (e) { console.warn(e.message); }
      }
      return null;
    }

    async function initCalendar() {
      const EC = await getEventCalendar();
      if (!EC) {
        ecEl.innerHTML = '<p>No se pudo cargar el calendario.</p>';
        return;
      }
      const hoy = new Date(); hoy.setHours(9,0,0,0);
      const m = (d,h)=>{const x=new Date(hoy);x.setDate(x.getDate()+d);x.setHours(h);return x;};

      const options = {
        view: 'timeGridWeek',
        headerToolbar: { start: 'prev,next today', center: 'title', end: 'dayGridMonth,timeGridWeek,timeGridDay' },
        locale: 'es',
        firstDay: 1,
        buttonText: { today:'Hoy', dayGridMonth:'Mes', timeGridWeek:'Semana', timeGridDay:'Día' },
        events: [
          { id:'1', title:'Consulta — Juan Pérez',  start:m(0,9),  end:m(0,10) },
          { id:'2', title:'Revisión — María López', start:m(1,11), end:m(1,12) },
          { id:'3', title:'Control — Pedro Ruiz',   start:m(2,16), end:m(2,17) },
        ],
      };

      if (typeof EC.create === 'function') {
        EC.create(ecEl, options);
        return;
      }
      new EC(ecEl, options);
    }

    initCalendar();
  })();
</script>