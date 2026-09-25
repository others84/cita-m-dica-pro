<div class="card">
  <p>Antes de continuar, lea y acepte los siguientes documentos. Se registrará la fecha, hora y dirección IP de su aceptación.</p>
</div>
<form method="post" action="<?= url('contratos/aceptar') ?>">
  <?= csrf_field() ?>
  <?php foreach ($porClinica as $cl): ?>
    <h2 class="legal-clinica"><?= htmlspecialchars($cl['nombre']) ?></h2>
    <?php foreach ($cl['docs'] as $d): $id = (int)$d['id_DOCUMENTO_CLINICA']; ?>
      <div class="card">
        <h3><?= htmlspecialchars(DocumentoLegalModel::TIPOS[$d['tipo']] ?? $d['tipo']) ?> <small style="color:var(--c4)">v<?= (int)$d['version'] ?></small></h3>
        <div class="legal-doc legal-read"><?= $d['html_render'] ?></div>
        <label class="legal-check">
          <input type="checkbox" name="acepto[<?= $id ?>]" value="1" required>
          He leído y acepto el <?= htmlspecialchars(mb_strtolower(DocumentoLegalModel::TIPOS[$d['tipo']] ?? '')) ?>
        </label>
      </div>
    <?php endforeach; ?>
  <?php endforeach; ?>
  <div class="card" style="display:flex;gap:.5rem;flex-wrap:wrap">
    <button type="submit" class="btn">Firmar y continuar</button>
    <a class="btn btn-sec" href="<?= url('auth/logout') ?>">Cerrar sesión</a>
  </div>
</form>
