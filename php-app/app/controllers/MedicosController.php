<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/MedicoModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class MedicosController extends Controller {
    public function index(): void {
        $this->requireLogin(['medico','administrador','admin_sistema']);
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];
        $editId = $this->stateInt('edit');
        $rows = MedicoModel::listar($fClinica);
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_MEDICO']===$editId) { $editRow = $r; break; }
        $this->view('medicos/index', [
            'title' => 'Medicos', 'rows' => $rows,
            'editId' => $editId, 'editRow' => $editRow,
            'clinicas'=>ClinicaModel::listar(), 'fClinica'=>$fClinica, 'rol'=>$rol,
            'clinicasFiltro' => $clinicasFiltro,
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
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
        $nombre = trim((string)$this->input('nombre_completo', ''));
        if ($idClinica <= 0 || $nombre === '') {
            Database::log('MEDICO GUARDAR datos incompletos id_CLINICA=' . $idClinica . " nombre='" . $nombre . "' campos=[" . implode(',', array_keys($_POST)) . ']');
            $this->flash('error', 'Selecciona la clinica y captura el nombre completo del medico.');
            $this->redirect('medicos');
        }
        try {
            if ($id) { MedicoModel::cambio($id, $idClinica, $nombre); $this->flash('ok','Actualizado.'); }
            else     { MedicoModel::alta($idClinica, $nombre);        $this->flash('ok','Registrado.'); }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('medicos');
    }
    public function eliminar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        try { MedicoModel::baja((int)$this->input('id')); $this->flash('ok','Eliminado.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('medicos');
    }
    public function activar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = (int)$this->input('id');
        try {
            $info = MedicoModel::obtener($id);
            MedicoModel::activa($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("MEDICO ACTIVADO id={$id} nombre='".($info['nombre_completo'] ?? '?')."' clinica='".($info['clinica'] ?? '?')."' por usuario='{$usr}'");
            $this->flash('ok','Medico activado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('medicos');
    }
    public function desactivar(): void {
        $this->requireLogin(['administrador','admin_sistema']);
        $id = (int)$this->input('id');
        try {
            $info = MedicoModel::obtener($id);
            MedicoModel::desactiva($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("MEDICO DESACTIVADO id={$id} nombre='".($info['nombre_completo'] ?? '?')."' clinica='".($info['clinica'] ?? '?')."' por usuario='{$usr}'");
            $this->flash('ok','Medico desactivado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('medicos');
    }
}