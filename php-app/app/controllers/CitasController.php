<?php
require_once __DIR__ . '/../core/Controller.php';

class CitasController extends Controller {
    public function index(): void {
        $this->requireLogin(['asistente','medico','administrador','admin_sistema']);
        $this->view('citas/index', ['title' => 'CRUD Citas']);
    }
}