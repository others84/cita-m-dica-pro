<?php
require_once __DIR__ . '/../core/Controller.php';

class ReportesController extends Controller {
    public function index(): void { $this->requireLogin(['medico','administrador','admin_sistema']); $this->view('reportes/index', ['title' => 'Reportes']); }
    public function ingresos(): void { $this->requireLogin(['medico','administrador','admin_sistema']); $this->view('reportes/ingresos', ['title' => 'Reporte de Ingresos']); }
}