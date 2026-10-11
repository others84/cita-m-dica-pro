<?php
declare(strict_types=1);

// Algunos hostings no tienen la extension mbstring habilitada.
require_once __DIR__ . '/../app/core/mbstring_polyfill.php';

// Sesion de larga duracion: los formularios extensos (alta de paciente,
// alta de cita) pueden tardar varios minutos en llenarse. Con el valor por
// defecto (24 min) la sesion se recicla, se pierde el token y el POST
// terminaba en "Sesion expirada o solicitud invalida (CSRF)".
@ini_set('session.gc_maxlifetime', '28800');   // 8 horas
@ini_set('session.cookie_lifetime', '0');      // hasta cerrar el navegador
@ini_set('session.use_strict_mode', '1');

// Bitacora de diagnostico propia del sitio (storage/logs dentro de la app).
// Registra errores fatales y el estado de la sesion para poder ver por que
// un sitio devuelve error 500 aunque Apache/PHP-FPM no muestren nada.
$__logDir = __DIR__ . '/../storage/logs';
if (!is_dir($__logDir)) @mkdir($__logDir, 0775, true);
function __diag_log(string $msg): void {
    $f = __DIR__ . '/../storage/logs/diagnostico-' . date('Y-m-d') . '.log';
    @file_put_contents($f, '[' . date('Y-m-d H:i:s') . '] ' . $msg . PHP_EOL, FILE_APPEND);
}
register_shutdown_function(function () {
    $e = error_get_last();
    if ($e && in_array($e['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR, E_USER_ERROR], true)) {
        __diag_log('FATAL ' . $e['message'] . ' en ' . $e['file'] . ':' . $e['line']
            . ' uri=' . ($_SERVER['REQUEST_URI'] ?? ''));
    }
});

// Aislamiento de sesion por sitio (subcarpeta): cuando conviven varias
// copias de la app en el mismo dominio (ej. /live y /demo), cada una tiene
// su PROPIA cookie (CITASESSID_LIVE, CITASESSID_DEMO), limitada a su ruta,
// y su PROPIA carpeta de sesiones dentro de la app: storage/sessions.
// Esa carpeta esta dentro de la ruta permitida por open_basedir y en la
// misma carpeta donde PHP ya puede escribir las bitacoras, por eso funciona
// igual en live y en demo sin depender de /tmp ni de /var/lib/php/sessions.
$__scriptName = str_replace('\\', '/', $_SERVER['SCRIPT_NAME'] ?? '');
$__base = rtrim(str_replace('/index.php', '', $__scriptName), '/');
if ($__base === '/') $__base = '';
$__slug = strtoupper(preg_replace('/[^A-Za-z0-9]+/', '_', trim($__base, '/')));
session_name('CITASESSID' . ($__slug !== '' ? '_' . $__slug : ''));
session_set_cookie_params([
    'lifetime' => 0,
    'path'     => ($__base === '' ? '/' : $__base . '/'),
    'secure'   => (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off'),
    'httponly' => true,
    'samesite' => 'Lax',
]);
$__sessDir = __DIR__ . '/../storage/sessions';
if (!is_dir($__sessDir)) @mkdir($__sessDir, 0770, true);
$__sessDirReal = realpath($__sessDir) ?: $__sessDir;
$__sessOk = is_dir($__sessDirReal) && is_writable($__sessDirReal);
if ($__sessOk) {
    session_save_path($__sessDirReal);
}
$__started = @session_start();
$__savePath = session_save_path();
if (!$__started || !$__sessOk) {
    __diag_log('SESION problema: started=' . ($__started ? 'SI' : 'NO')
        . ' carpeta_app=' . $__sessDirReal . ' escribible=' . ($__sessOk ? 'SI' : 'NO')
        . ' save_path=' . $__savePath
        . ' save_path_escribible=' . (is_writable($__savePath ?: '/nonexistent') ? 'SI' : 'NO')
        . ' open_basedir=' . ini_get('open_basedir')
        . ' usuario=' . (function_exists('posix_geteuid') ? (posix_getpwuid(posix_geteuid())['name'] ?? '?') : get_current_user())
        . ' err=' . (error_get_last()['message'] ?? ''));
}
// Limpieza ocasional de sesiones vencidas (1 de cada 100 peticiones),
// porque la limpieza del sistema de Ubuntu solo revisa su carpeta propia.
if ($__sessOk && mt_rand(1, 100) === 1) {
    $__lim = time() - 28800;
    foreach ((array)@glob($__sessDirReal . '/sess_*') as $__f) {
        if (@filemtime($__f) < $__lim) @unlink($__f);
    }
}
unset($__scriptName, $__base, $__slug, $__sessDir, $__sessDirReal, $__sessOk, $__started, $__savePath, $__logDir);

function app_base_url(): string {
    $scriptName = str_replace('\\', '/', $_SERVER['SCRIPT_NAME'] ?? '');
    $base = rtrim(str_replace('/index.php', '', $scriptName), '/');
    return $base === '/' ? '' : $base;
}

function url(string $path = ''): string {
    return app_base_url() . '/' . ltrim($path, '/');
}

function asset(string $path): string {
    return url('assets/' . ltrim($path, '/'));
}

require_once __DIR__ . '/../app/core/App.php';

$app = new App();
$app->run();