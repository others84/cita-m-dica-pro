<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../core/Auth.php';

class AuthController extends Controller {
    public function index(): void { $this->login(); }

    public function login(): void {
        $error = null;
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $usuario  = trim($_POST['usuario'] ?? '');
            $password = $_POST['password'] ?? '';
            $user = Auth::attempt($usuario, $password);
            if ($user) {
                $_SESSION['user'] = $user;
                $destino = $user['rol'] === 'admin_sistema' ? '/administradores' : '/calendario';
                header('Location: ' . $destino);
                exit;
            }
            $error = 'Usuario o contraseña incorrectos';
        }
        require __DIR__ . '/../views/auth/login.php';
    }

    public function logout(): void {
        session_destroy();
        header('Location: /auth/login');
        exit;
    }
}