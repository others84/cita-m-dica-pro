<?php
require_once __DIR__ . '/../core/Controller.php';

class CalendarioController extends Controller {
    public function index(): void {
        $this->requireLogin();
        $this->view('calendario/index', ['title' => 'Calendario de Citas']);
    }
}