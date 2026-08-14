<?php include __DIR__ . '/_filtros.php'; ?>
<?php
  include __DIR__ . '/_chartjs.php';
  $tot = (float)($total ?: 0);
  $labels = []; $values = [];
  foreach (($serie ?? []) as $esp => $n) {
      $labels[] = (string)$esp; $values[] = (int)$n;
  }
  $cid = 'pie_' . bin2hex(random_bytes(4));
  $labelsM = []; $valuesM = [];
  foreach (($montos ?? []) as $esp => $m) {
      $labelsM[] = (string)$esp; $valuesM[] = (float)$m;
  }
  $totM = (float)($totalMonto ?? array_sum($valuesM));
  $cidM = 'pie_' . bin2hex(random_bytes(4));
?>
<div class="card">
  <div class="toolbar" style="margin-bottom:1rem">
    <h2 style="margin:0;color:var(--c5)">Porcentaje de citas atendidas por especialidad</h2>
    <strong style="color:var(--c5)">Total: <?= (int)$total ?> citas</strong>
  </div>
  <?php if (empty($labels)): ?>
    <p style="color:var(--c4)">Sin datos en el rango seleccionado.</p>
  <?php else: ?>
  <div style="position:relative;height:380px"><canvas id="<?= $cid ?>"></canvas></div>
  <script>
  (function(){
    var T = window.temaColores();
    var bg = window.temaPaleta(<?= count($values) ?>);
    var total = <?= (float)($tot ?: 1) ?>;
    new Chart(document.getElementById('<?= $cid ?>').getContext('2d'), {
      type: 'pie',
      data: {
        labels: <?= json_encode($labels, JSON_UNESCAPED_UNICODE) ?>,
        datasets: [{ data: <?= json_encode($values) ?>, backgroundColor: bg, borderColor: '#fff', borderWidth: 2 }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        layout: { padding: 8 },
        plugins: {
          legend: { position: 'right', labels: { color: T.c5 } },
          tooltip: { callbacks: { label: function(c){
            var pct = total > 0 ? (c.parsed / total * 100).toFixed(1) : '0.0';
            return c.label + ': ' + c.parsed + ' (' + pct + '%)';
          } } }
        }
      },
      plugins: [{
        id: 'pctLabels',
        afterDatasetsDraw: function(chart){
          var ctx = chart.ctx;
          chart.getDatasetMeta(0).data.forEach(function(arc, i){
            var v = chart.data.datasets[0].data[i];
            if (!v) return;
            var pct = total > 0 ? (v / total * 100).toFixed(1) : '0.0';
            var p = arc.tooltipPosition();
            ctx.save();
            ctx.fillStyle = '#fff';
            ctx.strokeStyle = 'rgba(0,0,0,.45)';
            ctx.lineWidth = 3;
            ctx.font = 'bold 13px sans-serif';
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';
            ctx.strokeText(pct + '%', p.x, p.y);
            ctx.fillText(pct + '%', p.x, p.y);
            ctx.restore();
          });
        }
      }]
    });
  })();
  </script>
  <?php endif; ?>
</div>
<div class="card" style="margin-top:1rem">
  <div class="toolbar" style="margin-bottom:1rem">
    <h2 style="margin:0;color:var(--c5)">Monto total ingresado por especialidad</h2>
    <strong style="color:var(--c5)">Total: $<?= number_format($totM, 2) ?></strong>
  </div>
  <?php if (empty($labelsM)): ?>
    <p style="color:var(--c4)">Sin datos en el rango seleccionado.</p>
  <?php else: ?>
  <div style="position:relative;height:380px"><canvas id="<?= $cidM ?>"></canvas></div>
  <script>
  (function(){
    var T = window.temaColores();
    var bg = window.temaPaleta(<?= count($valuesM) ?>);
    var total = <?= json_encode($totM ?: 1) ?>;
    var money = function(v){ return '$' + Number(v).toLocaleString('es-MX',{minimumFractionDigits:2,maximumFractionDigits:2}); };
    new Chart(document.getElementById('<?= $cidM ?>').getContext('2d'), {
      type: 'pie',
      data: {
        labels: <?= json_encode($labelsM, JSON_UNESCAPED_UNICODE) ?>,
        datasets: [{ data: <?= json_encode($valuesM) ?>, backgroundColor: bg, borderColor: '#fff', borderWidth: 2 }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        layout: { padding: 8 },
        plugins: {
          legend: { position: 'right', labels: { color: T.c5 } },
          tooltip: { callbacks: { label: function(c){
            var pct = total > 0 ? (c.parsed / total * 100).toFixed(1) : '0.0';
            return c.label + ': ' + money(c.parsed) + ' (' + pct + '%)';
          } } }
        }
      },
      plugins: [{
        id: 'montoLabels',
        afterDatasetsDraw: function(chart){
          var ctx = chart.ctx;
          chart.getDatasetMeta(0).data.forEach(function(arc, i){
            var v = chart.data.datasets[0].data[i];
            if (!v) return;
            var p = arc.tooltipPosition();
            ctx.save();
            ctx.fillStyle = '#fff';
            ctx.strokeStyle = 'rgba(0,0,0,.45)';
            ctx.lineWidth = 3;
            ctx.font = 'bold 12px sans-serif';
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';
            ctx.strokeText(money(v), p.x, p.y);
            ctx.fillText(money(v), p.x, p.y);
            ctx.restore();
          });
        }
      }]
    });
  })();
  </script>
  <?php endif; ?>
</div>
