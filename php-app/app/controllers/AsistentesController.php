<?php
require_once __DIR__ . '/../core/Controller.php';

class AsistentesController extends Controller {
    public function index(): void {
        $this->requireLogin(['medico','administrador','admin_sistema']);
        $this->view('asistentes/index', ['title' => 'CRUD Asistentes']);
    }
}