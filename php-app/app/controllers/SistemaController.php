<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class SistemaController extends Controller {
    public function index(): void { $this->requireLogin(['admin_sistema']); $this->view('sistema/index', ['title' => 'Sistema']); }
    public function bloquearClinicas(): void {
        $this->requireLogin(['admin_sistema']);
        $rows = ClinicaModel::resumen();
        $this->view('sistema/bloquear_clinicas', ['title' => 'Bloquear acceso a clinicas', 'rows'=>$rows]);
    }
    public function bloquear(): void {
        $this->requireLogin(['admin_sistema']);
        $id = (int)($_POST['id'] ?? 0);
        try {
            $nombre = ClinicaModel::nombre($id);
            ClinicaModel::desactiva($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("CLINICA BLOQUEADA id={$id} nombre='{$nombre}' por usuario='{$usr}'");
            $this->flash('ok','Clinica bloqueada.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('sistema/bloquearClinicas');
    }
    public function desbloquear(): void {
        $this->requireLogin(['admin_sistema']);
        $id = (int)($_POST['id'] ?? 0);
        try {
            $nombre = ClinicaModel::nombre($id);
            ClinicaModel::activa($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("CLINICA DESBLOQUEADA id={$id} nombre='{$nombre}' por usuario='{$usr}'");
            $this->flash('ok','Clinica desbloqueada.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('sistema/bloquearClinicas');
    }
}