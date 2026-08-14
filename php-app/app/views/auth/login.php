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
<link rel="icon" type="image/png" href="<?= url('favicon.png') ?>">
<link rel="stylesheet" href="<?= asset('css/temas.css') ?>">
<script>
/* Aplica la apariencia guardada en el dispositivo antes de pintar la pagina. */
(function(){try{
  var d=document.documentElement, g=function(k){return localStorage.getItem(k)||'';};
  var t=g('sgco:tema'), f=g('sgco:fuente'), e=g('sgco:escala');
  if(t) d.setAttribute('data-tema',t);
  if(f) d.setAttribute('data-fuente',f);
  if(e) d.setAttribute('data-escala',e);
}catch(x){}})();
</script>
</head>
<body class="login-body">
  <form class="login-card" method="post" action="<?= url('auth/login') ?>">
    <input type="hidden" name="_csrf" value="<?= htmlspecialchars($csrf, ENT_QUOTES) ?>">
    <img class="login-logo" src="<?= asset('img/logo.png') ?>" alt="Logo SGCO" width="96" height="96">
    <h1>Sistema de gestión de citas online (SGCO)</h1>
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