<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/MedicoModel.php';

class MedicosController extends Controller {
    public function index(): void {
        $this->requireLogin(['medico','administrador','admin_sistema']);
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = MedicoModel::listar();
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_MEDICO']===$editId) { $editRow = $r; break; }
        $this->view('medicos/index', [
            'title' => 'Medicos', 'rows' => $rows,
            'editId' => $editId, 'editRow' => $editRow,
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        $nombre = $this->input('nombre_completo');
        try {
            if ($id) { MedicoModel::cambio($id, $nombre); $this->flash('ok','Actualizado.'); }
            else     { MedicoModel::alta($nombre);        $this->flash('ok','Registrado.'); }
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