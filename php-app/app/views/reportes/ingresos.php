<?php include __DIR__ . '/_filtros.php'; ?>
<div class="card" style="margin-bottom:1rem">
  <div class="toolbar" style="margin-bottom:1rem">
    <h2 style="margin:0;color:var(--c5)">Monto total por medico (<?= htmlspecialchars(date('d/m/Y', strtotime((string)($ini ?? 'now')))) ?> - <?= htmlspecialchars(date('d/m/Y', strtotime((string)($fin ?? 'now')))) ?>)</h2>
    <strong style="color:var(--c5)">Total: $<?= number_format((float)($total ?? 0), 2) ?></strong>
  </div>
  <?php $datos = $serie ?? []; $fmtMoneda = true; $titulo = null; $stepY = 100; include __DIR__ . '/_barras.php'; ?>
</div>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0">Total por medico en el periodo</h2>
  <table class="data">
    <thead><tr><th>Medico</th><th style="text-align:right">Citas</th><th style="text-align:right">Ingreso total</th></tr></thead>
    <tbody>
      <?php $tm = $totMedico ?? []; if (empty($tm)): ?>
        <tr><td colspan="3" style="text-align:center;color:var(--c4);padding:1rem">Sin datos</td></tr>
      <?php else: $gtm=0; foreach ($tm as $r): $gtm += (float)$r['total']; ?>
        <tr>
          <td><?= htmlspecialchars($r['medico']) ?></td>
          <td style="text-align:right"><?= (int)$r['citas'] ?></td>
          <td style="text-align:right">$<?= number_format((float)$r['total'], 2) ?></td>
        </tr>
      <?php endforeach; endif; ?>
    </tbody>
    <?php if (!empty($tm)): ?>
      <tfoot><tr><th colspan="2" style="text-align:right">Total general</th><th style="text-align:right">$<?= number_format($gtm ?? 0, 2) ?></th></tr></tfoot>
    <?php endif; ?>
  </table>
</div>
<div class="card">
  <h2 style="margin-top:0">Ingresos por medico (por dia)</h2>
  <table class="data">
    <thead><tr><th>Fecha</th><th>Medico</th><th style="text-align:right">Citas</th><th style="text-align:right">Total</th></tr></thead>
    <tbody>
      <?php $tot=0; if (empty($rows)): ?>
        <tr><td colspan="4" style="text-align:center;color:var(--c4);padding:1rem">Sin datos</td></tr>
      <?php else: foreach ($rows as $r): $tot += (float)$r['total']; ?>
        <tr>
          <td><?= htmlspecialchars(date('d/m/Y', strtotime((string)$r['periodo']))) ?></td>
          <td><?= htmlspecialchars($r['medico']) ?></td>
          <td style="text-align:right"><?= (int)($r['citas'] ?? 0) ?></td>
          <td style="text-align:right">$<?= number_format((float)$r['total'], 2) ?></td>
        </tr>
      <?php endforeach; endif; ?>
    </tbody>
    <?php if (!empty($rows)): ?>
      <tfoot><tr><th colspan="3" style="text-align:right">Total general</th><th style="text-align:right">$<?= number_format($tot,2) ?></th></tr></tfoot>
    <?php endif; ?>
  </table>
</div>