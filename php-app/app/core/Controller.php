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

    /**
     * Resuelve el contexto de filtro por clinica segun el rol.
     * Retorna ['clinicasFiltro' => array, 'fClinica' => ?int, 'rol' => string].
     *
     * - admin_sistema: puede elegir cualquier clinica (o "todas" => null).
     * - resto de roles: se limitan a las clinicas asignadas en sesion. Si eligen
     *   una valida se respeta; si no, se toma la primera asignada. Nunca pueden
     *   ver datos de una clinica que no tienen asignada.
     */
    protected function resolveClinicaContext(): array {
        $rol = $_SESSION['user']['rol'] ?? '';
        $sessClinicas = $_SESSION['user']['clinicas'] ?? [];
        $userClin = $_SESSION['user']['id_CLINICA'] ?? null;
        $raw = $this->intOrNull($_GET['f_clinica'] ?? null);

        if ($rol === 'admin_sistema') {
            require_once __DIR__ . '/../models/ClinicaModel.php';
            return [
                'clinicasFiltro' => ClinicaModel::listar(),
                'fClinica' => $raw,
                'rol' => $rol,
            ];
        }

        $ids = array_map(fn($c) => (int)$c['id_CLINICA'], $sessClinicas);
        $fClinica = null;
        if ($raw && in_array($raw, $ids, true)) {
            $fClinica = $raw;
        } elseif (!empty($ids)) {
            $fClinica = $ids[0];
        } elseif ($userClin) {
            $fClinica = (int)$userClin;
        }
        return [
            'clinicasFiltro' => $sessClinicas,
            'fClinica' => $fClinica,
            'rol' => $rol,
        ];
    }
}