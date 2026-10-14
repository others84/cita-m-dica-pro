<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/UsuarioModel.php';

class AyudaController extends Controller {
    public function index(): void {
        $this->requireLogin();
        $this->view('ayuda/index', ['title' => 'Ayuda']);
    }

    /** POST: marca la bienvenida como vista (CSRF validado globalmente). */
    public function cerrarBienvenida(): void {
        $this->requireLogin();
        header('Content-Type: application/json');
        if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') { http_response_code(405); echo '{"ok":false}'; return; }
        try {
            UsuarioModel::marcarBienvenidaVista((int)($_SESSION['user']['id_USUARIOS'] ?? 0));
        } catch (Throwable $e) { /* si falla, al menos no se repite en esta sesion */ }
        $_SESSION['user']['bienvenida_vista'] = true;
        echo '{"ok":true}';
    }
}
