<?php
require_once __DIR__ . '/../core/Controller.php';

class PacientesController extends Controller {
    public function index(): void {
        $this->requireLogin(['asistente','medico','administrador','admin_sistema']);
        $this->view('pacientes/index', ['title' => 'CRUD Pacientes']);
    }
}