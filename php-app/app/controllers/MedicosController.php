<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/RolModel.php';
require_once __DIR__ . '/../models/UsuarioClinicaModel.php';
require_once __DIR__ . '/../models/CitaModel.php';

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

    /**
     * True si el usuario destino es alcanzable por el administrador actual:
     * debe estar asignado (o pertenecer) a alguna de sus clinicas.
     */
    private function medicoPermitido(int $idUsuario): bool {
        if ($idUsuario <= 0) return false;
        $permitidas = $this->clinicasPermitidas();
        if ($permitidas === null) return true;             // admin_sistema
        foreach (UsuarioClinicaModel::listarPorUsuario($idUsuario) as $r) {
            if (in_array((int)($r['id_CLINICA'] ?? 0), $permitidas, true)) return true;
        }
        foreach (UsuarioModel::listar() as $u) {
            if ((int)($u['id_USUARIOS'] ?? 0) === $idUsuario
                && in_array((int)($u['id_CLINICA'] ?? 0), $permitidas, true)) return true;
        }
        return false;
    }

    public function index(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];
        $editId = $this->stateInt('edit');
        $rows = $this->listarMedicos($fClinica);
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_USUARIOS'] === $editId) { $editRow = $r; break; }

        // Clinicas asignadas por medico (se muestran en la tabla inferior).
        $clinicasPorMedico = [];
        foreach ($rows as $r) {
            $idU = (int)($r['id_USUARIOS'] ?? 0);
            if ($idU <= 0) continue;
            $clinicasPorMedico[$idU] = UsuarioClinicaModel::listarPorUsuario($idU);
        }
        $asignadasIds = [];
        if ($editId && isset($clinicasPorMedico[$editId])) {
            $asignadasIds = array_map(fn($r) => (int)$r['id_CLINICA'], $clinicasPorMedico[$editId]);
        }

        $this->view('medicos/index', [
            'title' => 'Medicos', 'rows' => $rows,
            'editId' => $editId, 'editRow' => $editRow,
            'clinicas'=>ClinicaModel::listar(), 'fClinica'=>$fClinica, 'rol'=>$rol,
            'clinicasFiltro' => $clinicasFiltro,
            'clinicasPorMedico' => $clinicasPorMedico,
            'asignadasIds' => $asignadasIds,
        ]);
    }

    /** Asigna una clinica adicional al medico seleccionado. */
    public function asignarClinica(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $ctx['clinicasFiltro']);
        $idMedico  = (int)$this->input('id_MEDICO');
        $idClinica = (int)$this->input('id_CLINICA');
        try {
            if ($idMedico <= 0) throw new RuntimeException('Selecciona un medico.');
            if (!$this->medicoPermitido($idMedico)) {
                throw new RuntimeException('Medico fuera del alcance del administrador.');
            }
            if (!in_array($idClinica, $idsAdmin, true)) {
                throw new RuntimeException('Clinica fuera del alcance del administrador.');
            }
            foreach (UsuarioClinicaModel::listarPorUsuario($idMedico) as $r) {
                if ((int)$r['id_CLINICA'] === $idClinica) {
                    $this->flash('ok', 'La clinica ya estaba asignada.');
                    $_SESSION['ui']['medicos']['edit'] = $idMedico;
                    $this->redirect('medicos');
                    return;
                }
            }
            $this->validaCupoUsuario($idClinica, $idMedico);
            UsuarioClinicaModel::asigna($idMedico, $idClinica);
            $usr = $_SESSION['user']['nombre_completo'] ?? ($_SESSION['user']['usuario'] ?? '?');
            $nomCl = '';
            foreach ($ctx['clinicasFiltro'] as $c) if ((int)$c['id_CLINICA'] === $idClinica) { $nomCl = (string)$c['nombre']; break; }
            Database::log("MEDICO CLINICA ASIGNADA id_USUARIOS={$idMedico} clinica='{$nomCl}' (id={$idClinica}) agregado por='{$usr}'");
            $this->flash('ok', 'Clinica asignada al medico.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $_SESSION['ui']['medicos']['edit'] = $idMedico;
        $this->redirect('medicos');
    }

    /** Cuenta las citas del medico en la clinica indicada (excluye canceladas). */
    private function citasDelMedicoEnClinica(int $idMedico, int $idClinica): int {
        try {
            $rows = CitaModel::listar($idMedico, '2000-01-01', '2100-12-31', $idClinica);
        } catch (Throwable $e) {
            Database::log('MEDICO CLINICA validacion citas ERR: ' . $e->getMessage());
            return 0;
        }
        $n = 0;
        foreach ($rows as $r) {
            if ((int)($r['id_MEDICO'] ?? 0) !== $idMedico) continue;
            $estado = strtolower((string)($r['estado_cita'] ?? $r['estado'] ?? ''));
            if (strpos($estado, 'cancel') !== false) continue;
            $n++;
        }
        return $n;
    }

    /** Remueve una clinica del medico seleccionado. */
    public function removerClinica(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $ctx['clinicasFiltro']);
        $idMedico = (int)$this->input('id_MEDICO');
        $idUC     = (int)$this->input('id_USUARIOS_CLINICA');
        $idClinica= (int)$this->input('id_CLINICA');
        try {
            if (!$this->medicoPermitido($idMedico)) {
                throw new RuntimeException('Medico fuera del alcance del administrador.');
            }
            if (!in_array($idClinica, $idsAdmin, true)) {
                throw new RuntimeException('Clinica fuera del alcance del administrador.');
            }
            $nCitas = $this->citasDelMedicoEnClinica($idMedico, $idClinica);
            if ($nCitas > 0) {
                throw new RuntimeException("No se puede eliminar la clinica: el medico ya tiene {$nCitas} cita(s) agendada(s) en ella.");
            }
            UsuarioClinicaModel::baja($idUC);
            $usr = $_SESSION['user']['nombre_completo'] ?? ($_SESSION['user']['usuario'] ?? '?');
            Database::log("MEDICO CLINICA REMOVIDA id_USUARIOS={$idMedico} clinica_id={$idClinica} por='{$usr}'");
            $this->flash('ok', 'Clinica removida del medico.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $_SESSION['ui']['medicos']['edit'] = $idMedico;
        $this->redirect('medicos');
    }
    public function guardar(): void {
        $this->requireLogin(['administrador']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        if ($id && !$this->medicoPermitido((int)$id)) {
            $this->clearState('edit');
            $this->denegarRecurso('MEDICO', $id, null, 'medicos');
            return;
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
                $this->validaCupoClinica($idClinica, $idRol);
                UsuarioModel::alta($idRol, $idClinica, $usuario, $pass, $nombre, $email);
                $usr = $_SESSION['user']['nombre_completo'] ?? ($_SESSION['user']['usuario'] ?? '?');
                Database::log("MEDICO ALTA usuario='{$usuario}' nombre='{$nombre}' clinica_id={$idClinica} agregado por='{$usr}'");
                $this->flash('ok','Medico registrado y asignado a la clinica.');
            }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('medicos');
    }
    public function eliminar(): void {
        $this->requireLogin(['administrador']);
        $id = (int)$this->input('id');
        if (!$this->medicoPermitido($id)) {
            $this->clearState('edit');
            $this->denegarRecurso('MEDICO', $id, null, 'medicos');
            return;
        }
        try { UsuarioModel::baja($id); $this->flash('ok','Eliminado.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('medicos');
    }
    public function activar(): void {
        $this->requireLogin(['administrador']);
        $id = (int)$this->input('id');
        if (!$this->medicoPermitido($id)) {
            $this->denegarRecurso('MEDICO', $id, null, 'medicos');
            return;
        }
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
        if (!$this->medicoPermitido($id)) {
            $this->denegarRecurso('MEDICO', $id, null, 'medicos');
            return;
        }
        try {
            UsuarioModel::desactiva($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("MEDICO DESACTIVADO id_USUARIOS={$id} por usuario='{$usr}'");
            $this->flash('ok','Medico desactivado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('medicos');
    }
}