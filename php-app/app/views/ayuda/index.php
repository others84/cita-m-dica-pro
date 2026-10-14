<?php
require __DIR__ . '/_contenido.php';
$__g = $AYUDA[$rol] ?? $AYUDA['asistente'];
?>
<div class="card ayuda">
  <p class="ayuda-intro">Guía para el rol <strong><?= htmlspecialchars($__g['nombre']) ?></strong>. Abre una sección para ver los pasos.</p>
  <?php foreach ($__g['secciones'] as $s): [$id, $tit, $ruta, $pasos] = $s; ?>
    <details class="ayuda-sec" id="<?= htmlspecialchars($id) ?>">
      <summary><?= htmlspecialchars($tit) ?></summary>
      <ol>
        <?php foreach ($pasos as $p): ?><li><?= htmlspecialchars($p) ?></li><?php endforeach; ?>
      </ol>
      <a class="btn" href="<?= url($ruta) ?>">Ir a la pantalla</a>
    </details>
  <?php endforeach; ?>
</div>
<script>
(function(){var h=location.hash.slice(1);if(!h)return;var d=document.getElementById(h);if(d){d.open=true;d.scrollIntoView({block:'start'});}})();
</script>
