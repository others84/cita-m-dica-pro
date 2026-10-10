<div class="card" style="max-width:520px">
  <h2 style="margin-top:0;color:var(--c5)">Cambiar contraseña</h2>
  <p style="color:var(--c4);margin-top:0">Actualiza la contraseña del usuario conectado.</p>
  <form method="post" action="<?= url('opciones/cambiarPassword') ?>" class="form-grid"><?= csrf_field() ?>
    <label>Contraseña actual
      <input type="password" name="actual" required autocomplete="current-password">
    </label>
    <label>Nueva contraseña
      <input type="password" name="nueva" required minlength="8" pattern="(?=.*[A-Za-zÁÉÍÓÚáéíóúÑñ])(?=.*\d).{8,}" title="Mínimo 8 caracteres, con al menos una letra y un número" autocomplete="new-password">
    </label>
    <label>Confirmar nueva contraseña
      <input type="password" name="confirmacion" required minlength="8" pattern="(?=.*[A-Za-zÁÉÍÓÚáéíóúÑñ])(?=.*\d).{8,}" title="Mínimo 8 caracteres, con al menos una letra y un número" autocomplete="new-password">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit">Actualizar contraseña</button>
    </div>
  </form>
</div>