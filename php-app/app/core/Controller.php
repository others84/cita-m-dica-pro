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
            header('Location: ' . url('auth/login'));
            exit;
        }
        if (!empty($roles) && !in_array($_SESSION['user']['rol'], $roles, true)) {
            http_response_code(403);
            echo 'Acceso denegado';
            exit;
        }
    }

    protected function flash(string $type, string $msg): void {
        $_SESSION['flash'][] = ['type' => $type, 'msg' => $msg];
    }

    protected function redirect(string $path): void {
        header('Location: ' . url($path));
        exit;
    }

    protected function input(string $key, $default = null) {
        $v = $_POST[$key] ?? $_GET[$key] ?? $default;
        if (is_string($v)) {
            $v = trim($v);
            if ($v === '') return $default;
        }
        return $v;
    }

    protected function intOrNull($v): ?int {
        if ($v === null || $v === '') return null;
        return (int)$v;
    }
}