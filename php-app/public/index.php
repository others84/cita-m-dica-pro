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

// Aislamiento de sesion por sitio (subcarpeta): cuando conviven varias
// copias de la app en el mismo dominio (ej. /live y /demo), cada una debe
// tener su PROPIA cookie de sesion, limitada a su ruta, y su PROPIA carpeta
// de archivos de sesion. De lo contrario comparten el mismo PHPSESSID y el
// inicio de sesion de un sitio "contamina" al otro (token CSRF cruzado,
// usuario de una base de datos en la otra, etc.).
$__scriptName = str_replace('\\', '/', $_SERVER['SCRIPT_NAME'] ?? '');
$__base = rtrim(str_replace('/index.php', '', $__scriptName), '/');
if ($__base === '/') $__base = '';
// Nombre de cookie unico por carpeta: CITASESSID_LIVE, CITASESSID_DEMO, etc.
$__slug = strtoupper(preg_replace('/[^A-Za-z0-9]+/', '_', trim($__base, '/')));
session_name('CITASESSID' . ($__slug !== '' ? '_' . $__slug : ''));
// La cookie solo viaja en las URL de esta subcarpeta.
session_set_cookie_params([
    'lifetime' => 0,
    'path'     => ($__base === '' ? '/' : $__base . '/'),
    'secure'   => (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off'),
    'httponly' => true,
    'samesite' => 'Lax',
]);
// Nota: no se redefine session_save_path. PHP usa su almacenamiento
unset($__scriptName, $__base, $__slug);
session_start();

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