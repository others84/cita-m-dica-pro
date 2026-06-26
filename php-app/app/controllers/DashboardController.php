<?php
require_once __DIR__ . '/../core/Controller.php';

class DashboardController extends Controller {
    public function index(): void {
        $this->requireLogin();
        $rol = $_SESSION['user']['rol'] ?? '';
        $destino = $rol === 'admin_sistema' ? '/administradores' : '/calendario';
        header('Location: ' . $destino);
        exit;
    }
}