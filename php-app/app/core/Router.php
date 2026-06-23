<?php
namespace App\Core;

class Router {
    /** rutas: 'controller/action' => [Controller::class, 'method', [roles]] */
    private static array $routes = [
        ''                       => ['App\Controllers\AuthController', 'login', []],
        'login'                  => ['App\Controllers\AuthController', 'login', []],
        'login/submit'           => ['App\Controllers\AuthController', 'submit', []],
        'logout'                 => ['App\Controllers\AuthController', 'logout', []],

        'dashboard'              => ['App\Controllers\DashboardController', 'index', ['asistente','medico','administrador']],

        'citas/agendar'          => ['App\Controllers\CitasController', 'agendar',  ['asistente','medico','administrador']],
        'citas/modificar'        => ['App\Controllers\CitasController', 'modificar',['asistente','medico','administrador']],
        'citas/cancelar'         => ['App\Controllers\CitasController', 'cancelar', ['asistente','medico','administrador']],

        'calendario'             => ['App\Controllers\CalendarioController', 'index', ['asistente','medico','administrador']],

        'opciones/password'      => ['App\Controllers\OpcionesController', 'password', ['asistente','medico','administrador']],
        'opciones/datos'         => ['App\Controllers\OpcionesController', 'datos',    ['asistente','medico','administrador']],

        'asistentes'             => ['App\Controllers\AsistentesController', 'index', ['medico','administrador']],
        'reportes/ingresos'      => ['App\Controllers\ReportesController',  'ingresos', ['medico','administrador']],

        'medicos'                => ['App\Controllers\MedicosController', 'index', ['administrador']],
        'restaurar'              => ['App\Controllers\SistemaController', 'restaurar', ['administrador']],
        'roles'                  => ['App\Controllers\RolesController', 'index', ['administrador']],
    ];

    public static function dispatch(): void {
        $url = trim($_GET['url'] ?? '', '/');
        if (!isset(self::$routes[$url])) { http_response_code(404); echo "404"; return; }
        [$class, $method, $roles] = self::$routes[$url];
        $ctrl = new $class();
        if ($roles) $ctrl->requireRole = $roles;
        if (!empty($roles)) {
            if (!isset($_SESSION['user'])) { header('Location: /login'); exit; }
            if (!in_array($_SESSION['user']['rol'], $roles, true)) { http_response_code(403); echo "Acceso denegado"; exit; }
        }
        $ctrl->$method();
    }
}
