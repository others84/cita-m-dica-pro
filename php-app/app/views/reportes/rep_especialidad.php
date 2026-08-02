<?php include __DIR__ . '/_filtros.php'; ?>
<?php
  include __DIR__ . '/_chartjs.php';
  $colores = ['#1E3A5F','#2E6DA4','#4A9BD1','#7FC3E8','#A8D8F0','#C9E7F7','#5B8DB8','#173049','#93B7D4','#6FA8C9'];
  $tot = (float)($total ?: 0);
  $labels = []; $values = []; $bg = []; $i = 0;
  foreach (($serie ?? []) as $esp => $n) {
      $labels[] = (string)$esp; $values[] = (int)$n; $bg[] = $colores[$i % count($colores)]; $i++;
  }
  $cid = 'pie_' . bin2hex(random_bytes(4));
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
    var total = <?= (float)($tot ?: 1) ?>;
    new Chart(document.getElementById('<?= $cid ?>').getContext('2d'), {
      type: 'pie',
      data: {
        labels: <?= json_encode($labels, JSON_UNESCAPED_UNICODE) ?>,
        datasets: [{ data: <?= json_encode($values) ?>, backgroundColor: <?= json_encode($bg) ?>, borderColor: '#fff', borderWidth: 2 }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: {
          legend: { position: 'right', labels: { color: '#1E3A5F' } },
          tooltip: { callbacks: { label: function(c){
            var pct = total > 0 ? (c.parsed / total * 100).toFixed(1) : '0.0';
            return c.label + ': ' + c.parsed + ' (' + pct + '%)';
          } } }
        }
      }
    });
  })();
  </script>
  <?php endif; ?>
</div>
