<div class="card">
  <p>Estas plantillas se copian a cada clínica nueva. Cambiarlas aquí <b>no</b> modifica los documentos que ya tienen las clínicas; para eso use el botón "Contrato y aviso" en la lista de clínicas.</p>
  <p style="color:var(--c4)">Variables disponibles: @@CLINICA, @@DIRECCION, @@EMAIL_CLINICA, @@TELEFONO_CLINICA, @@FECHA, @@USUARIO, @@NOMBRE_USUARIO, @@ROL.</p>
</div>
<?php foreach (DocumentoLegalModel::TIPOS as $tipo => $label): $p = $plantillas[$tipo] ?? null; ?>
<div class="card">
  <h3><?= htmlspecialchars($label) ?></h3>
  <?php if ($p): ?><small style="color:var(--c4)">Última modificación: <?= htmlspecialchars($p['fecha_mod']) ?></small><?php endif; ?>
  <?php
    $edId = 'ed_' . strtolower($tipo); $edHtml = (string)($p['html'] ?? '');
    $edAction = 'contratos/guardarPlantilla'; $edTipo = $tipo; $edBoton = 'Guardar plantilla'; $edExtra = '';
    require __DIR__ . '/_editor.php';
  ?>
</div>
<?php endforeach; ?>
