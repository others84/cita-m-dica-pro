<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../core/Auth.php';

class AuthController extends Controller {
    public function index(): void { $this->login(); }

    public function login(): void {
        $error = null;
        // Evita que el navegador reutilice una copia cacheada del formulario
        // (una version vieja sin token CSRF provoca "enviado=NO").
        header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
        header('Pragma: no-cache');
        header('Expires: 0');
        if (!empty($_SESSION['flash_error'])) {
            $error = $_SESSION['flash_error'];
            unset($_SESSION['flash_error']);
        }
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $usuario  = trim($_POST['usuario'] ?? '');
            $password = $_POST['password'] ?? '';
            $user = Auth::attempt($usuario, $password);
            if ($user) {
                $_SESSION['user'] = $user;
                $destino = $user['rol'] === 'admin_sistema' ? url('clinicas') : url('calendario');
                header('Location: ' . $destino);
                exit;
            }
            $error = 'Usuario o contraseña incorrectos';
        }
        require __DIR__ . '/../views/auth/login.php';
    }

    public function logout(): void {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $p = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000, $p['path'], $p['domain'], $p['secure'], $p['httponly']);
        }
        session_destroy();
        session_start();
        session_regenerate_id(true);
        header('Location: ' . url('auth/login'));
        exit;
    }
}