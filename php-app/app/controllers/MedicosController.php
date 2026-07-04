<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/MedicoModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class MedicosController extends Controller {
    public function index(): void {
        $this->requireLogin(['medico','administrador','admin_sistema']);
        $rol      = $_SESSION['user']['rol'] ?? '';
        $userClin = $_SESSION['user']['id_CLINICA'] ?? null;
        $fClinica = $rol === 'admin_sistema'
            ? $this->intOrNull($_GET['f_clinica'] ?? null)
            : ($userClin ? (int)$userClin : null);
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = MedicoModel::listar($fClinica);
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_MEDICO']===$editId) { $editRow = $r; break; }
        $this->view('medicos/index', [
            'title' => 'Medicos', 'rows' => $rows,
            'editId' => $editId, 'editRow' => $editRow,
            'clinicas'=>ClinicaModel::listar(), 'fClinica'=>$fClinica, 'rol'=>$rol,
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        $idClinica = (int)$this->input('id_CLINICA');
        $nombre = $this->input('nombre_completo');
        try {
            if ($id) { MedicoModel::cambio($id, $idClinica, $nombre); $this->flash('ok','Actualizado.'); }
            else     { MedicoModel::alta($idClinica, $nombre);        $this->flash('ok','Registrado.'); }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('medicos');
    }
    public function eliminar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        try { MedicoModel::baja((int)$this->input('id')); $this->flash('ok','Eliminado.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('medicos');
    }
}