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
            'esquemas'=>ClinicaModel::ESQUEMAS,
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        try {
            $n = $this->input('nombre'); $d = $this->input('direccion');
            $e = (string)$this->input('email'); $t = (string)$this->input('telefono');
            $idMun = (int)$this->input('id_CATALOGO_MUNICIPIO');

            $esquema = (string)$this->input('esquema', 'SOLO_CLINICA');
            if (!isset(ClinicaModel::ESQUEMAS[$esquema])) $esquema = 'SOLO_CLINICA';
            $def  = ClinicaModel::ESQUEMAS[$esquema];
            $maxA = $this->limite($this->input('max_asistentes'), $def['asistentes']);
            $maxM = $this->limite($this->input('max_medicos'), $def['medicos']);
            $maxD = $this->limite($this->input('max_admins'), $def['admins']);

            if ($id) ClinicaModel::cambio($id, $n, $d, $e, $t, $idMun, $esquema, $maxA, $maxM, $maxD);
            else     $id = ClinicaModel::alta($n, $d, $e, $t, $idMun, $esquema, $maxA, $maxM, $maxD);

            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log(sprintf(
                'CLINICA GUARDADA id=%d nombre="%s" esquema=%s max_asistentes=%d max_medicos=%d max_admins=%d por usuario="%s"',
                (int)$id, (string)$n, $esquema, $maxA, $maxM, $maxD, $usr
            ));
            $this->flash('ok','Guardado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('clinicas');
    }

    /** Normaliza un limite capturado (0..50); usa el default del esquema si viene vacio. */
    private function limite($valor, int $default): int {
        if ($valor === null || $valor === '') return $default;
        $n = (int)$valor;
        if ($n < 0) $n = 0;
        if ($n > 50) $n = 50;
        return $n;
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