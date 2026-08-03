<?php
/**
 * Grafico de barras con Chart.js.
 * Requiere: $datos (label => valor). Opcional: $fmtMoneda (bool), $titulo.
 */
include __DIR__ . '/_chartjs.php';
$__cid = 'chart_' . bin2hex(random_bytes(4));
$__labels = array_map('strval', array_keys($datos ?? []));
$__values = array_map('floatval', array_values($datos ?? []));
$__money  = !empty($fmtMoneda);
$__step   = isset($stepY) && $stepY > 0 ? (float)$stepY : null;
?>
<?php if (!empty($titulo)): ?><h3 style="margin:0 0 .75rem;color:var(--c5)"><?= htmlspecialchars($titulo) ?></h3><?php endif; ?>
<?php if (empty($__labels)): ?>
  <p style="color:var(--c4)">Sin datos en el rango seleccionado.</p>
<?php else: ?>
<div style="position:relative;height:340px"><canvas id="<?= $__cid ?>"></canvas></div>
<script>
(function(){
  var money = <?= $__money ? 'true' : 'false' ?>;
  var fmt = function(v){ return money ? '$' + Number(v).toLocaleString('es-MX',{minimumFractionDigits:2,maximumFractionDigits:2}) : Math.round(Number(v)).toLocaleString('es-MX'); };
  new Chart(document.getElementById('<?= $__cid ?>').getContext('2d'), {
    type: 'bar',
    plugins: [{
      id: 'valueLabels',
      afterDatasetsDraw: function(chart){
        var ctx = chart.ctx;
        chart.getDatasetMeta(0).data.forEach(function(bar, i){
          var v = chart.data.datasets[0].data[i];
          ctx.save();
          ctx.fillStyle = '#1E3A5F';
          ctx.font = 'bold 12px sans-serif';
          ctx.textAlign = 'center';
          ctx.textBaseline = 'bottom';
          ctx.fillText(fmt(v), bar.x, bar.y - 4);
          ctx.restore();
        });
      }
    }],
    data: {
      labels: <?= json_encode($__labels, JSON_UNESCAPED_UNICODE) ?>,
      datasets: [{
        label: <?= json_encode($__money ? 'Ingresos' : 'Citas', JSON_UNESCAPED_UNICODE) ?>,
        data: <?= json_encode($__values) ?>,
        backgroundColor: '#2E6DA4',
        hoverBackgroundColor: '#1E3A5F',
        borderRadius: 4,
        maxBarThickness: 56
      }]
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: { callbacks: { label: function(c){ return fmt(c.parsed.y); } } }
      },
      scales: {
        x: { grid: { display: false }, ticks: { color: '#1E3A5F', autoSkip: false, maxRotation: 60, minRotation: 0 } },
        y: { beginAtZero: true, ticks: { color: '#1E3A5F', precision: 0, stepSize: <?= $__step !== null ? json_encode($__step) : '1' ?>, callback: function(v){ return fmt(v); } }, grid: { color: '#EAF6FF' } }
      }
    }
  });
})();
</script>
<?php endif; ?>
