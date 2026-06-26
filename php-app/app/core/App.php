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

class App {
    public function run(): void {
        Config::load(__DIR__ . '/../../config/config.properties');
        $router = new Router();
        $router->dispatch($_GET['url'] ?? '');
    }
}