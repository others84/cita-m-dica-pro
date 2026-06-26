<?php
declare(strict_types=1);

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