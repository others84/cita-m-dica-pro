<?php
/**
 * Configuración global del sitio.
 * Cambia el usuario y la contraseña del administrador aquí.
 * Para generar un nuevo hash de contraseña ejecuta en consola:
 *   php -r "echo password_hash('tu_nueva_contraseña', PASSWORD_DEFAULT);"
 */

// Usuario y contraseña (hash) del panel de administración
define('ADMIN_USER', 'admin');
define('ADMIN_PASS_HASH', '$2y$10$2cMj7gpwNlyiTkH.kdbZn.Nfto/OaFDQneo66KDMS3aqAYc7uoFoS'); // Contraseña por defecto: Clinica2026!

// Ruta absoluta del archivo donde se guarda todo el contenido del sitio
define('CONTENT_FILE', __DIR__ . '/../data/content.php');

// Zona horaria
date_default_timezone_set('America/Mexico_City');

// Sesiones (usadas solo por el panel de administración)
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
