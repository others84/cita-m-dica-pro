<?php
namespace App\Core;

require_once __DIR__ . '/Config.php';
require_once __DIR__ . '/Database.php';
require_once __DIR__ . '/Controller.php';
require_once __DIR__ . '/Router.php';

spl_autoload_register(function ($class) {
    $prefix = 'App\\';
    if (!str_starts_with($class, $prefix)) return;
    $rel = str_replace('\\', '/', substr($class, strlen($prefix)));
    $file = __DIR__ . '/../' . lcfirst($rel) . '.php';
    if (file_exists($file)) require $file;
});

class App {
    public static function run(): void {
        session_start();
        Config::load(__DIR__ . '/../../config/config.properties');
        Router::dispatch();
    }
}
