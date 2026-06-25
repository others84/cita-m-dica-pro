<?php
require_once __DIR__ . '/Config.php';
require_once __DIR__ . '/Router.php';
require_once __DIR__ . '/Controller.php';

class App {
    public function run(): void {
        Config::load(__DIR__ . '/../../config/config.properties');
        $router = new Router();
        $router->dispatch($_GET['url'] ?? '');
    }
}