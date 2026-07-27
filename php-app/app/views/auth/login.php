<?php $title = 'Iniciar sesión'; ?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title><?= htmlspecialchars($title) ?></title>
<link rel="stylesheet" href="<?= asset('css/style.css') ?>">
</head>
<body class="login-body">
  <form class="login-card" method="post" action="<?= url('auth/login') ?>"><?= csrf_field() ?>
    <h1>Citas Médicas</h1>
    <p class="subtitle">Inicia sesión</p>
    <?php if (!empty($error)): ?><div class="alert"><?= htmlspecialchars($error) ?></div><?php endif; ?>
    <label>Usuario
      <input type="text" name="usuario" required autofocus>
    </label>
    <label>Contraseña
      <input type="password" name="password" required>
    </label>
    <button type="submit">Acceder</button>
  </form>
</body>
</html>