<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/RolModel.php';

class MedicosController extends Controller {
    /** id_ROLES del perfil "medico". */
    private function idRolMedico(): int {
        foreach (RolModel::listar() as $r) {
            $n = strtolower((string)($r['nombre'] ?? ''));
            if (strpos($n, 'medico') !== false || strpos($n, 'médico') !== false) return (int)$r['id_ROLES'];
        }
        return 0;
    }

    /** Usuarios con perfil medico de la clinica indicada (activos e inactivos). */
    private function listarMedicos(?int $idClinica): array {
        $out = [];
        foreach (UsuarioModel::listar() as $u) {
            $rol = strtolower((string)($u['rol'] ?? ''));
            if (strpos($rol, 'medico') === false && strpos($rol, 'médico') === false) continue;
            if ($idClinica !== null && (int)($u['id_CLINICA'] ?? 0) !== (int)$idClinica) continue;
            $id = (int)($u['id_USUARIOS'] ?? 0);
            if ($id <= 0 || isset($out[$id])) continue;
            $out[$id] = $u;
        }
        $rows = array_values($out);
        usort($rows, fn($a, $b) => strcasecmp((string)($a['nombre_completo'] ?? ''), (string)($b['nombre_completo'] ?? '')));
        return $rows;
    }

    public function index(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];
        $editId = $this->stateInt('edit');
        $rows = $this->listarMedicos($fClinica);
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_USUARIOS'] === $editId) { $editRow = $r; break; }
        $this->view('medicos/index', [
            'title' => 'Medicos', 'rows' => $rows,
            'editId' => $editId, 'editRow' => $editRow,
            'clinicas'=>ClinicaModel::listar(), 'fClinica'=>$fClinica, 'rol'=>$rol,
            'clinicasFiltro' => $clinicasFiltro,
        ]);
    }
    public function guardar(): void {
        $this->requireLogin(['administrador']);
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
        $usuario = trim((string)$this->input('usuario', ''));
        $email   = trim((string)$this->input('email', ''));
        $pass    = (string)$this->input('password', '');
        $idRol   = $this->idRolMedico();
        if ($idClinica <= 0 || $nombre === '' || ($id === null && $usuario === '')) {
            Database::log('MEDICO GUARDAR datos incompletos id_CLINICA=' . $idClinica . " nombre='" . $nombre . "' campos=[" . implode(',', array_keys($_POST)) . ']');
            $this->flash('error', 'Selecciona la clinica y captura usuario y nombre completo del medico.');
            $this->redirect('medicos');
        }
        if ($idRol <= 0) { $this->flash('error', 'No existe el perfil "medico" en el catalogo de roles.'); $this->redirect('medicos'); }
        try {
            if ($id) {
                UsuarioModel::cambio($id, $idRol, $idClinica, $nombre, $email);
                if ($pass !== '') UsuarioModel::cambioPassword($id, $pass);
                $this->flash('ok','Actualizado.');
            } else {
                UsuarioModel::alta($idRol, $idClinica, $usuario, $pass, $nombre, $email);
                $this->flash('ok','Medico registrado y asignado a la clinica.');
            }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('medicos');
    }
    public function eliminar(): void {
        $this->requireLogin(['administrador']);
        try { UsuarioModel::baja((int)$this->input('id')); $this->flash('ok','Eliminado.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('medicos');
    }
    public function activar(): void {
        $this->requireLogin(['administrador']);
        $id = (int)$this->input('id');
        try {
            UsuarioModel::activa($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("MEDICO ACTIVADO id_USUARIOS={$id} por usuario='{$usr}'");
            $this->flash('ok','Medico activado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('medicos');
    }
    public function desactivar(): void {
        $this->requireLogin(['administrador']);
        $id = (int)$this->input('id');
        try {
            UsuarioModel::desactiva($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("MEDICO DESACTIVADO id_USUARIOS={$id} por usuario='{$usr}'");
            $this->flash('ok','Medico desactivado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('medicos');
    }
}