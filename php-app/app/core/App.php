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

if (!function_exists('wa_numero')) {
    /** Normaliza un telefono a formato internacional sin signos (default MX 52). */
    function wa_numero(?string $tel): string {
        $d = preg_replace('/\D+/', '', (string)$tel);
        if ($d === '' || $d === null) return '';
        if (strlen($d) === 10) $d = '52' . $d;
        return $d;
    }
}

if (!function_exists('wa_mensaje')) {
    /** Construye el texto del recordatorio de cita para WhatsApp. */
    function wa_mensaje(array $c): string {
        $f = $c['fecha_cita'] instanceof DateTime
            ? $c['fecha_cita']->format('d/m/Y')
            : date('d/m/Y', strtotime(substr((string)$c['fecha_cita'], 0, 10)));
        $hi = $c['hora_inicio'] instanceof DateTime
            ? $c['hora_inicio']->format('H:i')
            : substr((string)$c['hora_inicio'], 0, 5);
        return 'Estimado usuario, su cita en la clinica "' . trim((string)($c['clinica'] ?? '')) . '"'
            . ' con el medico "' . trim((string)($c['medico'] ?? '')) . '"'
            . ' con la especialidad "' . trim((string)($c['especialidad'] ?? '')) . '"'
            . ' el dia "' . $f . '"'
            . ' a la hora "' . $hi . '"'
            . '. Favor de confirmar por este medio';
    }
}

if (!function_exists('wa_link')) {
    /** Devuelve el enlace wa.me con el mensaje de la cita, o '' si no hay telefono. */
    function wa_link(array $c): string {
        $num = wa_numero((string)($c['celular_notif'] ?? ''));
        if ($num === '') return '';
        return 'https://wa.me/' . $num . '?text=' . rawurlencode(wa_mensaje($c));
    }
}

class App {
    public function run(): void {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
        }
        Config::load(__DIR__ . '/../../config/config.properties');

        // Blindaje de URL limpia: ningun dato de negocio puede viajar por la
        // barra de direcciones. Si llega cualquier parametro GET distinto de
        // 'url' (ej. ?f_clinica=3&edit=5), se ignora y se redirige a la ruta
        // limpia. Asi el usuario no puede manipular valores desde la URL.
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET') {
            $extra = $_GET;
            unset($extra['url']);
            if (!empty($extra)) {
                if (class_exists('Database')) {
                    Database::log(sprintf(
                        'URL GET params ignorados uri=%s user=%s params=[%s]',
                        $_SERVER['REQUEST_URI'] ?? '?',
                        $_SESSION['user']['usuario'] ?? 'anonimo',
                        implode(',', array_keys($extra))
                    ));
                }
                $ruta = trim((string)($_GET['url'] ?? ''), '/');
                header('Location: ' . url($ruta));
                return;
            }
        }

        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST' && !csrf_verify()) {
            $uri = $_SERVER['REQUEST_URI'] ?? '?';
            if (class_exists('Database')) {
                Database::log(sprintf(
                    'CSRF INVALIDO uri=%s user=%s ip=%s enviado=%s guardado=%s coincide=%s sid=%s campos=[%s]',
                    $uri,
                    $_SESSION['user']['usuario'] ?? 'anonimo',
                    $_SERVER['REMOTE_ADDR'] ?? '?',
                    empty($_POST['_csrf']) ? 'NO' : 'SI',
                    empty($_SESSION['csrf_token']) ? 'NO' : 'SI',
                    (!empty($_POST['_csrf']) && !empty($_SESSION['csrf_token'])) ? 'NO' : 'N/A',
                    session_id(),
                    implode(',', array_keys($_POST))
                ));
            }
            // Sesion nueva/expirada en el login: no mostrar pantalla de error,
            // regenerar el token y volver al formulario con un aviso.
            if (empty($_SESSION['user'])) {
                csrf_token();
                $_SESSION['flash_error'] = 'Tu sesión expiró. Vuelve a intentarlo.';
                header('Location: ' . url('auth/login'));
                return;
            }
            // Usuario logueado: el token quedo desfasado (pagina cacheada o
            // sesion reciclada). Se emite un token nuevo y se ofrece volver.
            csrf_token();
            http_response_code(419);
            $volver = htmlspecialchars(url(trim((string)($_GET['url'] ?? ''), '/')), ENT_QUOTES);
            echo '<!doctype html><meta charset="utf-8">'
               . '<div style="font-family:system-ui;max-width:520px;margin:3rem auto;padding:1.5rem;'
               . 'border:1px solid #cfe3f5;border-radius:10px;background:#EAF6FF;color:#1E3A5F">'
               . '<h2 style="margin-top:0">Tu sesión se actualizó</h2>'
               . '<p>La página estaba abierta demasiado tiempo y el token de seguridad caducó. '
               . 'Abre de nuevo la pantalla y vuelve a guardar.</p>'
               . '<p><a href="' . $volver . '" style="color:#1E3A5F;font-weight:600">Volver a la pantalla</a></p>'
               . '</div>';
            return;
        }
        $router = new Router();
        $router->dispatch($_GET['url'] ?? '');
    }
}