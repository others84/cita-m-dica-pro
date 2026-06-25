<?php
class Controller {
    protected function view(string $view, array $data = []): void {
        extract($data);
        $viewFile = __DIR__ . '/../views/' . $view . '.php';
        if (!file_exists($viewFile)) {
            echo "Vista no encontrada: $view";
            return;
        }
        require __DIR__ . '/../views/layout/header.php';
        require $viewFile;
        require __DIR__ . '/../views/layout/footer.php';
    }

    protected function requireLogin(array $roles = []): void {
        if (empty($_SESSION['user'])) {
            header('Location: /auth/login');
            exit;
        }
        if (!empty($roles) && !in_array($_SESSION['user']['rol'], $roles, true)) {
            http_response_code(403);
            echo 'Acceso denegado';
            exit;
        }
    }
}