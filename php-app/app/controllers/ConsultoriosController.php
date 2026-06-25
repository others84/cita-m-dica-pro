<?php
require_once __DIR__ . '/../core/Controller.php';

class ConsultoriosController extends Controller {
    public function index(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $this->view('consultorios/index', ['title' => 'CRUD Consultorios']);
    }
}