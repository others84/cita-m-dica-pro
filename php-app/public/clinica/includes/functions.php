<?php
require_once __DIR__ . '/config.php';

/**
 * Escapa texto para mostrarlo de forma segura en HTML.
 */
function e($texto) {
    return htmlspecialchars((string) $texto, ENT_QUOTES, 'UTF-8');
}

/**
 * Carga el contenido del sitio desde data/content.php
 */
function cargar_contenido() {
    if (!file_exists(CONTENT_FILE)) {
        die('No se encontró el archivo de contenido.');
    }
    return require CONTENT_FILE;
}

/**
 * Guarda el arreglo de contenido en data/content.php, sobrescribiendo el archivo.
 * Devuelve true si se guardó correctamente.
 */
function guardar_contenido(array $datos) {
    $codigo = "<?php\n"
        . "/**\n"
        . " * Contenido del sitio.\n"
        . " * Última actualización: " . date('Y-m-d H:i:s') . "\n"
        . " * Generado automáticamente por el panel de administración.\n"
        . " */\n\n"
        . "return " . var_export($datos, true) . ";\n";

    $temporal = CONTENT_FILE . '.tmp';
    if (file_put_contents($temporal, $codigo) === false) {
        return false;
    }
    return rename($temporal, CONTENT_FILE);
}

/**
 * Verifica si hay una sesión de administrador activa.
 */
function admin_autenticado() {
    return !empty($_SESSION['admin_logueado']) && $_SESSION['admin_logueado'] === true;
}

/**
 * Obliga a iniciar sesión antes de continuar; si no hay sesión, redirige al login.
 */
function requerir_login() {
    if (!admin_autenticado()) {
        header('Location: login.php');
        exit;
    }
}

/**
 * Imprime el atributo selected="selected" cuando dos valores coinciden.
 * Se usa en los <select> del panel de administración.
 */
function selected($valor, $comparar) {
    if ((string) $valor === (string) $comparar) {
        echo 'selected';
    }
}

/**
 * Genera y valida un token CSRF simple para los formularios del admin.
 */
function csrf_token() {
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function csrf_valido($token) {
    return !empty($_SESSION['csrf_token']) && is_string($token) && hash_equals($_SESSION['csrf_token'], $token);
}
