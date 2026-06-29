<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/EspecialidadModel.php';

class EspecialidadesController extends Controller {
    public function index(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = EspecialidadModel::listar();
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CATALOGO_ESPECIALIDAD']===$editId) { $editRow=$r; break; }
        $this->view('_partials/simple_catalog', [
            'title'=>'Especialidades','rows'=>$rows,'idField'=>'id_CATALOGO_ESPECIALIDAD',
            'controller'=>'especialidades','editId'=>$editId,'editRow'=>$editRow,
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