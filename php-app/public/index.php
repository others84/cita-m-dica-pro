<?php
declare(strict_types=1);

// Sesion de larga duracion: los formularios extensos (alta de paciente,
// alta de cita) pueden tardar varios minutos en llenarse. Con el valor por
// defecto (24 min) la sesion se recicla, se pierde el token y el POST
// terminaba en "Sesion expirada o solicitud invalida (CSRF)".
@ini_set('session.gc_maxlifetime', '28800');   // 8 horas
@ini_set('session.cookie_lifetime', '0');      // hasta cerrar el navegador
@ini_set('session.use_strict_mode', '1');
$sessPath = session_save_path();
if ($sessPath === '' || !is_writable($sessPath)) {
    $tmp = sys_get_temp_dir() . '/citas_sessions';
    if (!is_dir($tmp)) @mkdir($tmp, 0700, true);
    if (is_dir($tmp) && is_writable($tmp)) session_save_path($tmp);
}
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