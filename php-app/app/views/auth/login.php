<?php
$title = 'Iniciar sesión';
// Fallback por si la vista se sirve sin los helpers de App.php cargados.
if (session_status() !== PHP_SESSION_ACTIVE) { session_start(); }
if (empty($_SESSION['csrf_token'])) { $_SESSION['csrf_token'] = bin2hex(random_bytes(32)); }
$csrf = $_SESSION['csrf_token'];
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title><?= htmlspecialchars($title) ?></title>
<link rel="stylesheet" href="<?= asset('css/style.css') ?>">
</head>
<body class="login-body">
  <form class="login-card" method="post" action="<?= url('auth/login') ?>">
    <input type="hidden" name="_csrf" value="<?= htmlspecialchars($csrf, ENT_QUOTES) ?>">
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