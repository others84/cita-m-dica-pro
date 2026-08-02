<?php include __DIR__ . '/_filtros.php'; ?>
<?php
  $colores = ['#1E3A5F','#2E6DA4','#4A9BD1','#7FC3E8','#A8D8F0','#C9E7F7','#5B8DB8','#173049','#93B7D4','#EAF6FF'];
  $tot = (float)($total ?: 0);
  $acum = 0.0; $segs = []; $i = 0;
  foreach ($serie as $esp => $n) {
      $pct = $tot > 0 ? ((float)$n / $tot) * 100 : 0;
      $segs[] = ['esp'=>$esp,'n'=>(int)$n,'pct'=>$pct,'ini'=>$acum,'fin'=>$acum+$pct,'color'=>$colores[$i % count($colores)]];
      $acum += $pct; $i++;
  }
  $stops = [];
  foreach ($segs as $s) { $stops[] = $s['color'].' '.round($s['ini'],2).'% '.round($s['fin'],2).'%'; }
?>
<div class="card">
  <div class="toolbar" style="margin-bottom:1rem">
    <h2 style="margin:0;color:var(--c5)">Porcentaje de citas atendidas por especialidad</h2>
    <strong style="color:var(--c5)">Total: <?= (int)$total ?> citas</strong>
  </div>
  <?php if (empty($segs)): ?>
    <p style="color:var(--c4)">Sin datos en el rango seleccionado.</p>
  <?php else: ?>
  <div class="rep-pie-wrap">
    <div class="rep-pie" style="background:conic-gradient(<?= htmlspecialchars(implode(',', $stops)) ?>)"></div>
    <table class="data" style="max-width:520px">
      <thead><tr><th>Especialidad</th><th style="text-align:right">Citas</th><th style="text-align:right">%</th></tr></thead>
      <tbody>
        <?php foreach ($segs as $s): ?>
          <tr>
            <td><span class="rep-dot" style="background:<?= htmlspecialchars($s['color']) ?>"></span><?= htmlspecialchars((string)$s['esp']) ?></td>
            <td style="text-align:right"><?= $s['n'] ?></td>
            <td style="text-align:right"><?= number_format($s['pct'], 1) ?>%</td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
  <?php endif; ?>
</div>
