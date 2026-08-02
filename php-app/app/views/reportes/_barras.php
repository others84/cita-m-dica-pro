<?php
/**
 * Grafico de barras vertical (solo CSS).
 * Requiere: $datos (label => valor). Opcional: $fmtMoneda (bool), $titulo.
 */
$max = 0.0;
foreach ($datos as $v) { $max = max($max, (float)$v); }
$fmt = function ($v) use ($fmtMoneda) {
    return !empty($fmtMoneda) ? '$' . number_format((float)$v, 2) : number_format((float)$v);
};
?>
<?php if (!empty($titulo)): ?><h3 style="margin:0 0 .75rem;color:var(--c5)"><?= htmlspecialchars($titulo) ?></h3><?php endif; ?>
<?php if (empty($datos)): ?>
  <p style="color:var(--c4)">Sin datos en el rango seleccionado.</p>
<?php else: ?>
<div class="chart-bars">
  <?php foreach ($datos as $lbl => $val):
      $h = $max > 0 ? max(2, round(((float)$val / $max) * 100)) : 2; ?>
    <div class="chart-bar" title="<?= htmlspecialchars((string)$lbl . ': ' . $fmt($val)) ?>">
      <span class="chart-val"><?= htmlspecialchars($fmt($val)) ?></span>
      <div class="chart-col" style="height:<?= $h ?>%"></div>
      <span class="chart-lbl"><?= htmlspecialchars((string)$lbl) ?></span>
    </div>
  <?php endforeach; ?>
</div>
<?php endif; ?>
