<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/EspecialidadModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class EspecialidadesController extends Controller {
    public function index(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];
        $userClin = $_SESSION['user']['id_CLINICA'] ?? null;
        $editId = $this->stateInt('edit');
        $rows = EspecialidadModel::listar($fClinica);
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CATALOGO_ESPECIALIDAD']===$editId) { $editRow=$r; break; }
        $this->view('especialidades/index', [
            'title'=>'Especialidades','rows'=>$rows,
            'editId'=>$editId,'editRow'=>$editRow,
            'clinicas'=>ClinicaModel::listar(), 'fClinica'=>$fClinica, 'rol'=>$rol,
            'userClin'=>$userClin,
            'clinicasFiltro' => $clinicasFiltro,
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        $nombre = $this->input('nombre');
        $rol      = $_SESSION['user']['rol'] ?? '';
        $userClin = $_SESSION['user']['id_CLINICA'] ?? null;
        $idClinica = $rol === 'admin_sistema'
            ? (int)$this->input('id_CLINICA')
            : (int)($userClin ?? 0);
        try {
            if ($idClinica <= 0) throw new RuntimeException('Seleccione una clinica.');
            if ($id) EspecialidadModel::cambio($id, $nombre, $idClinica);
            else     EspecialidadModel::alta($nombre, $idClinica);
            $cliNombre = '?';
            foreach (ClinicaModel::listar() as $cl) if ((int)$cl['id_CLINICA']===$idClinica) { $cliNombre=$cl['nombre']; break; }
            $usr = $_SESSION['user']['usuario'] ?? '?';
            $accion = $id ? 'CAMBIO' : 'ALTA';
            Database::log("ESPECIALIDAD {$accion} nombre='{$nombre}' clinica='{$cliNombre}' por usuario='{$usr}'");
            $this->flash('ok','Guardado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('especialidades');
    }
}