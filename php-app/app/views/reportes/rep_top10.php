<?php include __DIR__ . '/_filtros.php'; ?>
<div class="rep-grid2">
  <div class="card">
    <?php $datos = $cant; $fmtMoneda = false; $titulo = 'Top 10 por citas atendidas'; include __DIR__ . '/_barras.php'; ?>
  </div>
  <div class="card">
    <?php $datos = $dinero; $fmtMoneda = true; $titulo = 'Top 10 por ingresos'; include __DIR__ . '/_barras.php'; ?>
  </div>
</div>
