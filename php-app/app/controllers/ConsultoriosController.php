<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ConsultorioModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class ConsultoriosController extends Controller {
    public function index(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];
        $editId = $this->stateInt('edit');
        $rows = ConsultorioModel::listar($fClinica);
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CONSULTORIO']===$editId) { $editRow=$r; break; }
        $this->view('consultorios/index', [
            'title'=>'Consultorios','rows'=>$rows,
            'editId'=>$editId,'editRow'=>$editRow,
            'clinicas'=>ClinicaModel::listar(),
            'fClinica'=>$fClinica,'rol'=>$rol,
            'clinicasFiltro' => $clinicasFiltro,
        ]);
    }
    /** Clinica a la que pertenece el consultorio, o null si no existe. */
    private function clinicaDelConsultorio(int $id): ?int {
        foreach (ConsultorioModel::listar() as $r) {
            if ((int)($r['id_CONSULTORIO'] ?? 0) === $id) return (int)($r['id_CLINICA'] ?? 0);
        }
        return null;
    }

    public function guardar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        if ($id) {
            $cl = $this->clinicaDelConsultorio((int)$id);
            if ($cl === null || !$this->clinicaPermitida($cl)) {
                $this->clearState('edit');
                $this->denegarRecurso('CONSULTORIO', $id, $cl, 'consultorios');
                return;
            }
        }
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
        $nombre = trim((string)$this->input('nombre', ''));
        if ($idClinica <= 0 || $nombre === '') {
            Database::log('CONSULTORIO GUARDAR datos incompletos id_CLINICA=' . $idClinica . " nombre='" . $nombre . "' campos=[" . implode(',', array_keys($_POST)) . ']');
            $this->flash('error', 'Selecciona la clinica y captura el nombre del consultorio.');
            $this->redirect('consultorios');
        }
        try {
            if ($id) ConsultorioModel::cambio($id, $idClinica, $nombre);
            else     ConsultorioModel::alta($idClinica, $nombre);
            $this->flash('ok','Guardado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('consultorios');
    }
    public function eliminar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = (int)$this->input('id');
        $cl = $id ? $this->clinicaDelConsultorio($id) : null;
        if ($cl === null || !$this->clinicaPermitida($cl)) {
            $this->clearState('edit');
            $this->denegarRecurso('CONSULTORIO', $id, $cl, 'consultorios');
            return;
        }
        try { ConsultorioModel::baja($id); $this->flash('ok','Eliminado.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('consultorios');
    }
}