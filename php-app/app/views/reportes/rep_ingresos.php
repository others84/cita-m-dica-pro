<?php include __DIR__ . '/_filtros.php'; ?>
<div class="card">
  <div class="toolbar" style="margin-bottom:1rem">
    <h2 style="margin:0;color:var(--c5)">Citas atendidas por dia</h2>
    <strong style="color:var(--c5)">Total: <?= (int)$total ?> citas</strong>
  </div>
  <?php $datos = $serie; $fmtMoneda = false; $titulo = null; include __DIR__ . '/_barras.php'; ?>
</div>
