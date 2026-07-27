<?php
require_once __DIR__ . '/Config.php';
require_once __DIR__ . '/Database.php';
require_once __DIR__ . '/Router.php';
require_once __DIR__ . '/Controller.php';

if (!function_exists('app_base_url')) {
    function app_base_url(): string {
        $scriptName = str_replace('\\', '/', $_SERVER['SCRIPT_NAME'] ?? '');
        $base = rtrim(str_replace('/index.php', '', $scriptName), '/');
        return $base === '/' ? '' : $base;
    }
}

if (!function_exists('url')) {
    function url(string $path = ''): string {
        return app_base_url() . '/' . ltrim($path, '/');
    }
}

if (!function_exists('asset')) {
    function asset(string $path): string {
        return url('assets/' . ltrim($path, '/'));
    }
}

if (!function_exists('csrf_token')) {
    /** Token CSRF de la sesion actual (se genera una vez por sesion). */
    function csrf_token(): string {
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['csrf_token'];
    }
}

if (!function_exists('csrf_field')) {
    /** Campo oculto con el token CSRF; debe ir en TODOS los formularios POST. */
    function csrf_field(): string {
        return '<input type="hidden" name="_csrf" value="' . htmlspecialchars(csrf_token(), ENT_QUOTES) . '">';
    }
}

if (!function_exists('csrf_verify')) {
    /** Valida el token recibido por POST contra el de la sesion. */
    function csrf_verify(): bool {
        $sent = $_POST['_csrf'] ?? '';
        $stored = $_SESSION['csrf_token'] ?? '';
        return is_string($sent) && $stored !== '' && hash_equals($stored, $sent);
    }
}

if (!function_exists('post_button')) {
    /**
     * Renderiza un boton que envia sus datos por POST (no por la URL).
     *
     * @param string      $action  Ruta destino (ej. 'pacientes').
     * @param array       $fields  Campos ocultos [nombre => valor].
     * @param string      $label   Texto del boton.
     * @param string      $class   Clases CSS del boton.
     * @param string|null $confirm Mensaje de confirmacion (opcional).
     */
    function post_button(string $action, array $fields, string $label, string $class = 'btn btn-sec', ?string $confirm = null): void {
        $onsubmit = $confirm
            ? ' onsubmit="return confirm(\'' . htmlspecialchars(str_replace("'", "\\'", $confirm), ENT_QUOTES) . '\');"'
            : '';
        echo '<form method="post" action="' . url($action) . '" style="display:inline"' . $onsubmit . '>';
        echo csrf_field();
        foreach ($fields as $k => $v) {
            echo '<input type="hidden" name="' . htmlspecialchars((string)$k) . '" value="' . htmlspecialchars((string)$v) . '">';
        }
        echo '<button class="' . htmlspecialchars($class) . '" type="submit">' . htmlspecialchars($label) . '</button>';
        echo '</form>';
    }
}

class App {
    public function run(): void {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }
        Config::load(__DIR__ . '/../../config/config.properties');
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST' && !csrf_verify()) {
            $uri = $_SERVER['REQUEST_URI'] ?? '?';
            if (class_exists('Database')) {
                Database::log(sprintf(
                    'CSRF INVALIDO uri=%s user=%s ip=%s enviado=%s guardado=%s sid=%s',
                    $uri,
                    $_SESSION['user']['usuario'] ?? 'anonimo',
                    $_SERVER['REMOTE_ADDR'] ?? '?',
                    empty($_POST['_csrf']) ? 'NO' : 'SI',
                    empty($_SESSION['csrf_token']) ? 'NO' : 'SI',
                    session_id()
                ));
            }
            // Sesion nueva/expirada en el login: no mostrar pantalla de error,
            // regenerar el token y volver al formulario con un aviso.
            if (empty($_SESSION['user'])) {
                csrf_token();
                header('Location: ' . url('auth/login?expirada=1'));
                return;
            }
            http_response_code(419);
            echo 'Sesion expirada o solicitud invalida (CSRF). Recargue la pagina e intente de nuevo.';
            return;
        }
        $router = new Router();
        $router->dispatch($_GET['url'] ?? '');
    }
}