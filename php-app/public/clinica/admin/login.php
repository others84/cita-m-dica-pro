<?php
require_once __DIR__ . '/../includes/functions.php';

if (admin_autenticado()) {
    header('Location: dashboard.php');
    exit;
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usuario = $_POST['usuario'] ?? '';
    $clave = $_POST['clave'] ?? '';

    if (hash_equals(ADMIN_USER, $usuario) && password_verify($clave, ADMIN_PASS_HASH)) {
        // Evita fijación de sesión al iniciar sesión correctamente
        session_regenerate_id(true);
        $_SESSION['admin_logueado'] = true;
        header('Location: dashboard.php');
        exit;
    }
    $error = 'Usuario o contraseña incorrectos.';
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Acceso administrador</title>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600&family=Work+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../assets/css/style.css">
<link rel="stylesheet" href="assets/admin.css">
</head>
<body class="admin-body">
  <div class="login-box">
    <h1>Panel de administración</h1>
    <p class="login-sub">Inicia sesión para editar el contenido del sitio.</p>
    <?php if ($error): ?>
      <div class="alert alert-error"><?php echo e($error); ?></div>
    <?php endif; ?>
    <form method="post" novalidate>
      <label for="usuario">Usuario</label>
      <input type="text" id="usuario" name="usuario" autocomplete="username" required>

      <label for="clave">Contraseña</label>
      <input type="password" id="clave" name="clave" autocomplete="current-password" required>

      <button type="submit" class="btn btn-primary" style="width:100%; justify-content:center; margin-top:8px;">Entrar</button>
    </form>
    <a class="login-back" href="../index.php">&larr; Volver al sitio</a>
  </div>
</body>
</html>
