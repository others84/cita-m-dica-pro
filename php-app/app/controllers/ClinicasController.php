<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/MunicipioModel.php';
require_once __DIR__ . '/../models/EstadoModel.php';
require_once __DIR__ . '/../models/PaisModel.php';

class ClinicasController extends Controller {
    public function index(): void {
        $this->requireLogin(['admin_sistema']);
        $editId = $this->stateInt('edit');
        $rows = ClinicaModel::listar();
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CLINICA']===$editId) { $editRow=$r; break; }
        $municipios = MunicipioModel::listar();
        // Mapa municipio -> estado/pais para enriquecer el listado (sin tocar la BD).
        $mapMun = [];
        foreach ($municipios as $mu) $mapMun[(int)$mu['id_CATALOGO_MUNICIPIO']] = $mu;
        foreach ($rows as $i => $r) {
            $mu = $mapMun[(int)($r['id_CATALOGO_MUNICIPIO'] ?? 0)] ?? null;
            $rows[$i]['municipio'] = $r['municipio'] ?? ($mu['nombre'] ?? '');
            $rows[$i]['estado'] = $mu['estado'] ?? '';
            $rows[$i]['pais']   = $mu['pais'] ?? '';
        }
        $this->view('clinicas/index', [
            'title'=>'Clinicas','rows'=>$rows,'editId'=>$editId,'editRow'=>$editRow,
            'municipios'=>$municipios,
            'estados'=>EstadoModel::listar(),
            'paises'=>PaisModel::listar(),
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        try {
            $n = $this->input('nombre'); $d = $this->input('direccion');
            $e = (string)$this->input('email'); $t = (string)$this->input('telefono');
            $idMun = (int)$this->input('id_CATALOGO_MUNICIPIO');
            if ($id) ClinicaModel::cambio($id, $n, $d, $e, $t, $idMun);
            else     ClinicaModel::alta($n, $d, $e, $t, $idMun);
            $this->flash('ok','Guardado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('clinicas');
    }
    public function eliminar(): void {
        $this->requireLogin(['admin_sistema']);
        try { ClinicaModel::baja((int)$this->input('id')); $this->flash('ok','Baja.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('clinicas');
    }
    public function activar(): void {
        $this->requireLogin(['admin_sistema']);
        $id = (int)$this->input('id');
        try {
            $nombre = ClinicaModel::nombre($id);
            ClinicaModel::activa($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("CLINICA ACTIVADA id={$id} nombre='{$nombre}' por usuario='{$usr}'");
            $this->flash('ok','Clinica activada.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('clinicas');
    }
    public function desactivar(): void {
        $this->requireLogin(['admin_sistema']);
        $id = (int)$this->input('id');
        try {
            $nombre = ClinicaModel::nombre($id);
            ClinicaModel::desactiva($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("CLINICA DESACTIVADA id={$id} nombre='{$nombre}' por usuario='{$usr}'");
            $this->flash('ok','Clinica desactivada.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('clinicas');
    }
}