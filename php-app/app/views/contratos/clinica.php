<div class="card">
  <p><a class="btn btn-sec" href="<?= url('clinicas') ?>">‹ Volver a clínicas</a></p>
  <p>Al publicar un cambio se crea una nueva versión y <b>todos los usuarios de la clínica deberán aceptarla</b> en su siguiente ingreso.</p>
</div>

<?php foreach (DocumentoLegalModel::TIPOS as $tipo => $label): $d = $docs[$tipo] ?? null; ?>
<div class="card">
  <h3><?= htmlspecialchars($label) ?> <?php if ($d): ?><small style="color:var(--c4)">— versión <?= (int)$d['version'] ?> (<?= htmlspecialchars($d['fecha_creacion']) ?>)</small><?php endif; ?></h3>
  <?php
    $edId = 'edc_' . strtolower($tipo); $edHtml = (string)($d['html'] ?? '');
    $edAction = 'contratos/guardarClinica'; $edTipo = $tipo; $edBoton = 'Publicar nueva versión';
    $edExtra = '<button type="submit" name="desde_plantilla" value="1" class="btn btn-sec" formnovalidate '
             . 'onclick="return confirm(\'¿Reemplazar por la plantilla vigente y publicar nueva versión?\')">Recargar desde plantilla</button>';
    require __DIR__ . '/_editor.php';
  ?>
</div>
<?php endforeach; ?>

<div class="card">
  <h3>Firmas de los usuarios</h3>
  <div class="table-responsive">
  <table class="data">
    <thead><tr><th>Usuario</th><th>Nombre</th><th>Perfil</th><th>Documento</th><th>Versión</th><th>Fecha/hora</th><th>IP</th></tr></thead>
    <tbody>
    <?php if (empty($firmas)): ?>
      <tr><td colspan="7" style="text-align:center;color:var(--c4)">Sin usuarios asignados</td></tr>
    <?php else: foreach ($firmas as $f): ?>
      <tr>
        <td><?= htmlspecialchars($f['usuario']) ?></td>
        <td><?= htmlspecialchars($f['nombre_completo']) ?></td>
        <td><?= htmlspecialchars($f['rol'] ?? '') ?></td>
        <td><?= htmlspecialchars(DocumentoLegalModel::TIPOS[$f['tipo']] ?? $f['tipo']) ?></td>
        <td><?= (int)$f['version'] ?></td>
        <td><?= $f['fecha_firma'] ? htmlspecialchars($f['fecha_firma']) : '<span class="badge off">Pendiente</span>' ?></td>
        <td><?= htmlspecialchars($f['ip'] ?? '') ?></td>
      </tr>
    <?php endforeach; endif; ?>
    </tbody>
  </table>
  </div>
</div>

<?php if (!empty($historial)): ?>
<div class="card">
  <h3>Historial de versiones</h3>
  <?php foreach ($historial as $h): ?>
    <details class="legal-hist">
      <summary><?= htmlspecialchars(DocumentoLegalModel::TIPOS[$h['tipo']] ?? $h['tipo']) ?> v<?= (int)$h['version'] ?> — <?= htmlspecialchars($h['fecha_creacion']) ?><?= !empty($h['vigente']) ? ' (vigente)' : '' ?></summary>
      <div class="legal-doc"><?= $h['html'] ?></div>
    </details>
  <?php endforeach; ?>
</div>
<?php endif; ?>
