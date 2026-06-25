<?php
require_once __DIR__ . '/../core/Controller.php';

class SistemaController extends Controller {
    public function index(): void { $this->requireLogin(['admin_sistema']); $this->view('sistema/index', ['title' => 'Sistema']); }
    public function bloquearClinicas(): void { $this->requireLogin(['admin_sistema']); $this->view('sistema/bloquear_clinicas', ['title' => 'Bloquear acceso a clínicas']); }
}