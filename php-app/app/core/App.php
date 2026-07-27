<?php
require_once __DIR__ . '/Config.php';
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
        foreach ($fields as $k => $v) {
            echo '<input type="hidden" name="' . htmlspecialchars((string)$k) . '" value="' . htmlspecialchars((string)$v) . '">';
        }
        echo '<button class="' . htmlspecialchars($class) . '" type="submit">' . htmlspecialchars($label) . '</button>';
        echo '</form>';
    }
}

class App {
    public function run(): void {
        Config::load(__DIR__ . '/../../config/config.properties');
        $router = new Router();
        $router->dispatch($_GET['url'] ?? '');
    }
}