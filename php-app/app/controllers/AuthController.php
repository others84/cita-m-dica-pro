<?php
namespace App\Controllers;

use App\Core\Controller;
use App\Models\Usuario;

class AuthController extends Controller {
    public function login(): void {
        $this->view('auth/login', ['error' => $_GET['error'] ?? null]);
    }

    public function submit(): void {
        $u = $_POST['usuario'] ?? '';
        $p = $_POST['password'] ?? '';
        $user = Usuario::autenticar($u, $p);
        if (!$user) { $this->redirect('/login?error=1'); }
        $_SESSION['user'] = $user;
        $this->redirect('/dashboard');
    }

    public function logout(): void {
        session_destroy();
        $this->redirect('/login');
    }
}
