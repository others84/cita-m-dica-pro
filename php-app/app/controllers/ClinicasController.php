<?php
require_once __DIR__ . '/../core/Controller.php';

class ClinicasController extends Controller {
    public function index(): void {
        $this->requireLogin(['admin_sistema']);
        $this->view('clinicas/index', ['title' => 'CRUD Clínicas']);
    }
}