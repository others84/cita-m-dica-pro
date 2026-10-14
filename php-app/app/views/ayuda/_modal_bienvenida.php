<?php
require __DIR__ . '/_contenido.php';
$__g = $AYUDA[$rol] ?? $AYUDA['asistente'];
?>
<div class="ayuda-modal" id="ayuda-bienvenida" role="dialog" aria-modal="true" aria-labelledby="ayuda-bv-tit">
  <div class="ayuda-modal-box">
    <h2 id="ayuda-bv-tit">Bienvenido(a), <?= htmlspecialchars($user['nombre']) ?></h2>
    <p>Estos son los primeros pasos como <strong><?= htmlspecialchars($__g['nombre']) ?></strong>:</p>
    <ol>
      <?php foreach ($__g['bienvenida'] as $p): ?><li><?= htmlspecialchars($p) ?></li><?php endforeach; ?>
    </ol>
    <p class="muted">Puedes volver a esta guía cuando quieras desde la opción "Ayuda" del menú.</p>
    <div class="ayuda-modal-acc">
      <button type="button" class="btn" data-bv="<?= url('ayuda') ?>">Ver la guía completa</button>
      <button type="button" class="btn btn-primary" data-bv="">Entendido</button>
    </div>
  </div>
</div>
<script>
(function(){
  var m=document.getElementById('ayuda-bienvenida');
  m.querySelectorAll('[data-bv]').forEach(function(b){
    b.addEventListener('click',function(){
      var ir=b.getAttribute('data-bv');
      fetch(<?= json_encode(url('ayuda/cerrarBienvenida')) ?>,{method:'POST',credentials:'same-origin',
        headers:{'Content-Type':'application/x-www-form-urlencoded'},
        body:'_csrf=<?= rawurlencode(csrf_token()) ?>'}).finally(function(){
          m.remove(); if(ir) location.href=ir;
        });
    });
  });
})();
</script>
