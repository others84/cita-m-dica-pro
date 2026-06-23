<?php $titulo = 'Iniciar sesión'; require __DIR__ . '/../layouts/header.php'; ?>
<div class="login-wrap">
  <form class="login-card" method="post" action="/login/submit">
    <h1>Iniciar sesión</h1>
    <?php if (!empty($error)): ?><div class="error">Usuario o contraseña incorrectos.</div><?php endif; ?>
    <div class="field"><label>Usuario</label><input name="usuario" autocomplete="username" required></div>
    <div class="field"><label>Contraseña</label><input type="password" name="password" autocomplete="current-password" required></div>
    <button type="submit" class="btn">Acceder</button>
  </form>
</div>
<?php require __DIR__ . '/../layouts/footer.php'; ?>
