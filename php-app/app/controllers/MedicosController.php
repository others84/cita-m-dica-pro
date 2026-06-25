<?php
require_once __DIR__ . '/../core/Controller.php';

class MedicosController extends Controller {
    public function index(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $this->view('medicos/index', ['title' => 'CRUD Médicos']);
    }
}