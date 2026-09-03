<?php
$title = 'Nueva contraseña';
if (session_status() !== PHP_SESSION_ACTIVE) { session_start(); }
if (empty($_SESSION['csrf_token'])) { $_SESSION['csrf_token'] = bin2hex(random_bytes(32)); }
$csrf = $_SESSION['csrf_token'];
$token = (string)($token ?? '');
$valido = !empty($valido);
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
    <?php if ($valido): ?>
    <form class="login-card" method="post" action="<?= url('auth/restablecer') ?>">
      <input type="hidden" name="_csrf" value="<?= htmlspecialchars($csrf, ENT_QUOTES) ?>">
      <input type="hidden" name="token" value="<?= htmlspecialchars($token, ENT_QUOTES) ?>">
      <h1>Nueva contraseña</h1>
      <p class="subtitle">Define tu nueva contraseña para el usuario <strong><?= htmlspecialchars((string)($usuario ?? '')) ?></strong>.</p>
      <?php if (!empty($error)): ?><div class="alert"><?= htmlspecialchars($error) ?></div><?php endif; ?>
      <label>Nueva contraseña
        <input type="password" name="nueva" required minlength="8" maxlength="72" autocomplete="new-password" autofocus>
      </label>
      <label>Confirmar contraseña
        <input type="password" name="confirmacion" required minlength="8" maxlength="72" autocomplete="new-password">
      </label>
      <button type="submit">Guardar contraseña</button>
      <p class="login-alt"><a href="<?= url('auth/login') ?>">Cancelar</a></p>
    </form>
    <?php else: ?>
    <div class="login-card">
      <h1>Enlace no válido</h1>
      <p class="subtitle"><?= htmlspecialchars((string)($error ?? 'El enlace expiró o ya fue utilizado. Solicita uno nuevo.')) ?></p>
      <p class="login-alt"><a class="btn" href="<?= url('auth/recuperar') ?>">Solicitar otro enlace</a></p>
    </div>
    <?php endif; ?>
  </main>

  <footer class="login-footer">
    <div class="login-footer-inner"></div>
  </footer>
</div>
</body>
</html>
