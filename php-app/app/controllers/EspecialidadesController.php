<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/EspecialidadModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class EspecialidadesController extends Controller {
    public function index(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $rol      = $_SESSION['user']['rol'] ?? '';
        $userClin = $_SESSION['user']['id_CLINICA'] ?? null;
        $fClinica = $rol === 'admin_sistema'
            ? $this->intOrNull($_GET['f_clinica'] ?? null)
            : ($userClin ? (int)$userClin : null);
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = EspecialidadModel::listar($fClinica);
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CATALOGO_ESPECIALIDAD']===$editId) { $editRow=$r; break; }
        $this->view('_partials/simple_catalog', [
            'title'=>'Especialidades','rows'=>$rows,'idField'=>'id_CATALOGO_ESPECIALIDAD',
            'controller'=>'especialidades','editId'=>$editId,'editRow'=>$editRow,
            'clinicas'=>ClinicaModel::listar(), 'fClinica'=>$fClinica, 'rol'=>$rol,
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        $nombre = $this->input('nombre');
        try {
            if ($id) EspecialidadModel::cambio($id, $nombre); else EspecialidadModel::alta($nombre);
            $this->flash('ok','Guardado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('especialidades');
    }
}