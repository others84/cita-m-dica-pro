<?php
class Router {
    public function dispatch(string $url): void {
        $url = trim($url, '/');
        $parts = $url === '' ? [] : explode('/', $url);

        $controllerName = !empty($parts[0]) ? ucfirst($parts[0]) . 'Controller' : 'AuthController';
        $action = $parts[1] ?? 'index';
        $params = array_slice($parts, 2);

        $file = __DIR__ . '/../controllers/' . $controllerName . '.php';
        if (!file_exists($file)) {
            http_response_code(404);
            echo "Controlador no encontrado: $controllerName";
            return;
        }

        require_once $file;
        $controller = new $controllerName();

        if (!method_exists($controller, $action)) {
            http_response_code(404);
            echo "Acción no encontrada: $action";
            return;
        }

        call_user_func_array([$controller, $action], $params);
    }
}