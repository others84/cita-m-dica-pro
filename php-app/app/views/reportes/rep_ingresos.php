<?php include __DIR__ . '/_filtros.php'; ?>
<div class="card">
  <div class="toolbar" style="margin-bottom:1rem">
    <h2 style="margin:0;color:var(--c5)">Ingresos por dia (citas atendidas)</h2>
    <strong style="color:var(--c5)">Total: $<?= number_format((float)$total, 2) ?></strong>
  </div>
  <?php $datos = $serie; $fmtMoneda = true; $titulo = null; include __DIR__ . '/_barras.php'; ?>
</div>
