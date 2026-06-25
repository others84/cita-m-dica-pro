<?php
require_once __DIR__ . '/../core/Controller.php';

class AdministradoresController extends Controller {
    public function index(): void {
        $this->requireLogin(['admin_sistema']);
        $this->view('administradores/index', ['title' => 'CRUD Administradores de clínica']);
    }
}