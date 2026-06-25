<?php
require_once __DIR__ . '/../core/Controller.php';

class EspecialidadesController extends Controller {
    public function index(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $this->view('especialidades/index', ['title' => 'CRUD Especialidades']);
    }
}