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
    /** Clinica a la que pertenece la especialidad, o null si no existe. */
    private function clinicaDeEspecialidad(int $id): ?int {
        foreach (EspecialidadModel::listar() as $r) {
            if ((int)($r['id_CATALOGO_ESPECIALIDAD'] ?? 0) === $id) return (int)($r['id_CLINICA'] ?? 0);
        }
        return null;
    }

    public function guardar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        if ($id) {
            $cl = $this->clinicaDeEspecialidad((int)$id);
            if ($cl === null || !$this->clinicaPermitida($cl)) {
                $this->clearState('edit');
                $this->denegarRecurso('ESPECIALIDAD', $id, $cl, 'especialidades');
                return;
            }
        }
        $nombre = trim((string)$this->input('nombre', ''));
        $idClinica = (int)$this->input('id_CLINICA', 0);
        if ($idClinica <= 0) {
            // Fallback: la clinica del filtro en sesion o la del usuario.
            $idClinica = (int)($_SESSION['f_clinica'] ?? 0);
            if ($idClinica <= 0) {
                $asignadas = $_SESSION['user']['clinicas'] ?? [];
                if (count($asignadas) === 1) $idClinica = (int)($asignadas[0]['id_CLINICA'] ?? 0);
            }
            if ($idClinica <= 0) $idClinica = (int)($_SESSION['user']['id_CLINICA'] ?? 0);
        }
        if ($idClinica <= 0 || $nombre === '') {
            Database::log('ESPECIALIDAD GUARDAR datos incompletos id_CLINICA=' . $idClinica . " nombre='" . $nombre . "' campos=[" . implode(',', array_keys($_POST)) . ']');
            $this->flash('error', 'Selecciona la clinica y captura el nombre de la especialidad.');
            $this->redirect('especialidades');
        }
        try {
            if ($id) EspecialidadModel::cambio($id, $nombre, $idClinica, isset($cl) && $cl ? (int)$cl : null);
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