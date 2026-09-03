<?php
$title = 'Recuperar contraseña';
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
<div class="login-shell">
  <header class="login-header">
    <div class="login-header-inner">
      <img class="login-header-logo" src="<?= asset('img/logo.png') ?>" alt="Logo SGCO" width="40" height="40">
    </div>
  </header>

  <main class="login-main">
    <form class="login-card" method="post" action="<?= url('auth/recuperar') ?>">
      <input type="hidden" name="_csrf" value="<?= htmlspecialchars($csrf, ENT_QUOTES) ?>">
      <h1>Recuperar contraseña</h1>
      <p class="subtitle">Escribe tu usuario y el correo registrado en el sistema. Te enviaremos un enlace válido por 5 minutos.</p>
      <?php if (!empty($aviso)): ?><div class="alert alert-ok"><?= htmlspecialchars($aviso) ?></div><?php endif; ?>
      <?php if (!empty($error)): ?><div class="alert"><?= htmlspecialchars($error) ?></div><?php endif; ?>
      <label>Usuario
        <input type="text" name="usuario" maxlength="40" required autofocus>
      </label>
      <label>Correo electrónico
        <input type="email" name="email" maxlength="120" required>
      </label>
      <button type="submit">Enviar enlace</button>
      <p class="login-alt"><a href="<?= url('auth/login') ?>">Volver a iniciar sesión</a></p>
    </form>
  </main>

  <footer class="login-footer">
    <div class="login-footer-inner"></div>
  </footer>
</div>
</body>
</html>
