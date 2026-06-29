<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/EstadoModel.php';

class ClinicasController extends Controller {
    public function index(): void {
        $this->requireLogin(['admin_sistema']);
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = ClinicaModel::listar();
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CLINICA']===$editId) { $editRow=$r; break; }
        $this->view('clinicas/index', [
            'title'=>'Clinicas','rows'=>$rows,'editId'=>$editId,'editRow'=>$editRow,
            'estados'=>EstadoModel::listar(),
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        try {
            $n = $this->input('nombre'); $d = $this->input('direccion');
            $e = $this->input('email'); $t = $this->input('telefono');
            $m = $this->input('municipio'); $idEs = (int)$this->input('id_CATALOGO_ESTADOS');
            if ($id) ClinicaModel::cambio($id, $n, $d, $e, $t, $m, $idEs);
            else     ClinicaModel::alta($n, $d, $e, $t, $m, $idEs);
            $this->flash('ok','Guardado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('clinicas');
    }
    public function eliminar(): void {
        $this->requireLogin(['admin_sistema']);
        try { ClinicaModel::baja((int)$this->input('id')); $this->flash('ok','Baja.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('clinicas');
    }
    public function activar(): void {
        $this->requireLogin(['admin_sistema']);
        try { ClinicaModel::activa((int)$this->input('id')); $this->flash('ok','Activada.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('clinicas');
    }
    public function desactivar(): void {
        $this->requireLogin(['admin_sistema']);
        try { ClinicaModel::desactiva((int)$this->input('id')); $this->flash('ok','Desactivada.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('clinicas');
    }
}