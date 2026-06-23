<?php
namespace App\Core;

class Controller {
    protected function view(string $path, array $data = []): void {
        extract($data);
        $file = __DIR__ . '/../views/' . $path . '.php';
        if (!file_exists($file)) {
            http_response_code(500);
            echo "Vista no encontrada: $path"; return;
        }
        require $file;
    }

    protected function redirect(string $url): void {
        header("Location: $url"); exit;
    }

    protected function requireRole(array $roles): void {
        if (!isset($_SESSION['user'])) $this->redirect('/login');
        if (!in_array($_SESSION['user']['rol'], $roles, true)) {
            http_response_code(403); echo "Acceso denegado"; exit;
        }
    }
}
