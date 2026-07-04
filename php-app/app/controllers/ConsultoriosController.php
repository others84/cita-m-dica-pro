<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ConsultorioModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class ConsultoriosController extends Controller {
    public function index(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $rol      = $_SESSION['user']['rol'] ?? '';
        $userClin = $_SESSION['user']['id_CLINICA'] ?? null;
        $fClinica = $rol === 'admin_sistema'
            ? $this->intOrNull($_GET['f_clinica'] ?? null)
            : ($userClin ? (int)$userClin : null);
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = ConsultorioModel::listar($fClinica);
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CONSULTORIO']===$editId) { $editRow=$r; break; }
        $this->view('consultorios/index', [
            'title'=>'Consultorios','rows'=>$rows,
            'editId'=>$editId,'editRow'=>$editRow,
            'clinicas'=>ClinicaModel::listar(),
            'fClinica'=>$fClinica,'rol'=>$rol,
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        $idClinica = (int)$this->input('id_CLINICA');
        $nombre = $this->input('nombre');
        try {
            if ($id) ConsultorioModel::cambio($id, $idClinica, $nombre);
            else     ConsultorioModel::alta($idClinica, $nombre);
            $this->flash('ok','Guardado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('consultorios');
    }
    public function eliminar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        try { ConsultorioModel::baja((int)$this->input('id')); $this->flash('ok','Eliminado.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('consultorios');
    }
}