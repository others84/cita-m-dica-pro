<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/RolModel.php';
require_once __DIR__ . '/../models/UsuarioClinicaModel.php';

/**
 * Alta y administracion de usuarios con perfil "asistente".
 * El administrador de clinica solo puede operar sobre las clinicas
 * a las que tiene acceso (resolveClinicaContext / clinicasPermitidas).
 */
class AsistentesController extends Controller {

    /** id_ROLES del perfil "asistente". */
    private function idRolAsistente(): int {
        foreach (RolModel::listar() as $r) {
            $n = strtolower((string)($r['nombre'] ?? ''));
            if (strpos($n, 'asistente') !== false) return (int)$r['id_ROLES'];
        }
        return 0;
    }

    /** Usuarios con perfil asistente de la clinica indicada (activos e inactivos). */
    private function listarAsistentes(?int $idClinica): array {
        $out = [];
        foreach (UsuarioModel::listar() as $u) {
            $rol = strtolower((string)($u['rol'] ?? ''));
            if (strpos($rol, 'asistente') === false) continue;
            if ($idClinica !== null && (int)($u['id_CLINICA'] ?? 0) !== (int)$idClinica) continue;
            $id = (int)($u['id_USUARIOS'] ?? 0);
            if ($id <= 0 || isset($out[$id])) continue;
            $out[$id] = $u;
        }
        $rows = array_values($out);
        usort($rows, fn($a, $b) => strcasecmp((string)($a['nombre_completo'] ?? ''), (string)($b['nombre_completo'] ?? '')));
        return $rows;
    }

    /** True si el asistente pertenece a alguna clinica del administrador actual. */
    private function asistentePermitido(int $idUsuario): bool {
        if ($idUsuario <= 0) return false;
        if (strpos($this->rolDeUsuario($idUsuario), 'asistente') === false) return false;
        $permitidas = $this->clinicasPermitidas();
        if ($permitidas === null) return true; // admin_sistema
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
        $rows = $this->listarAsistentes($fClinica);
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_USUARIOS'] === $editId) { $editRow = $r; break; }

        $clinicasPorAsistente = [];
        foreach ($rows as $r) {
            $idU = (int)($r['id_USUARIOS'] ?? 0);
            if ($idU <= 0) continue;
            $clinicasPorAsistente[$idU] = UsuarioClinicaModel::listarPorUsuario($idU);
        }
        $asignadasIds = [];
        if ($editId && isset($clinicasPorAsistente[$editId])) {
            $asignadasIds = array_map(fn($r) => (int)$r['id_CLINICA'], $clinicasPorAsistente[$editId]);
        }

        $this->view('asistentes/index', [
            'title' => 'Asistentes', 'rows' => $rows,
            'editId' => $editId, 'editRow' => $editRow,
            'clinicas' => ClinicaModel::listar(), 'fClinica' => $fClinica, 'rol' => $rol,
            'clinicasFiltro' => $clinicasFiltro,
            'clinicasPorAsistente' => $clinicasPorAsistente,
            'asignadasIds' => $asignadasIds,
        ]);
    }

    public function guardar(): void {
        $this->requireLogin(['administrador']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        if ($id && !$this->asistentePermitido((int)$id)) {
            $this->clearState('edit');
            $this->denegarRecurso('ASISTENTE', $id, null, 'asistentes');
            return;
        }
        $idClinica = (int)$this->input('id_CLINICA', 0);
        if ($idClinica <= 0) {
            $idClinica = (int)($_SESSION['f_clinica'] ?? 0);
            if ($idClinica <= 0) {
                $asignadas = $_SESSION['user']['clinicas'] ?? [];
                if (count($asignadas) === 1) $idClinica = (int)($asignadas[0]['id_CLINICA'] ?? 0);
            }
            if ($idClinica <= 0) $idClinica = (int)($_SESSION['user']['id_CLINICA'] ?? 0);
        }
        $permitidas = $this->clinicasPermitidas();
        if ($permitidas !== null && !in_array($idClinica, $permitidas, true)) {
            $this->flash('error', 'Clinica fuera del alcance del administrador.');
            $this->redirect('asistentes');
        }
        $nombre  = trim((string)$this->input('nombre_completo', ''));
        $usuario = trim((string)$this->input('usuario', ''));
        $email   = trim((string)$this->input('email', ''));
        $pass    = (string)$this->input('password', '');
        $idRol   = $this->idRolAsistente();
        if ($idClinica <= 0 || $nombre === '' || ($id === null && $usuario === '')) {
            $this->flash('error', 'Selecciona la clinica y captura usuario y nombre completo del asistente.');
            $this->redirect('asistentes');
        }
        if ($idRol <= 0) { $this->flash('error', 'No existe el perfil "asistente" en el catalogo de roles.'); $this->redirect('asistentes'); }
        $errPass = ($id === null || $pass !== '') ? self::errorPassword($pass) : null;
        if ($errPass) { $this->flash('error', $errPass); $this->redirect('asistentes'); return; }
        try {
            if ($id) {
                UsuarioModel::cambio($id, $idRol, $idClinica, $nombre, $email);
                if ($pass !== '') UsuarioModel::cambioPassword($id, $pass);
                $this->flash('ok', 'Actualizado.');
            } else {
                $this->validaCupoClinica($idClinica, $idRol);
                UsuarioModel::alta($idRol, $idClinica, $usuario, $pass, $nombre, $email);
                $usr = $_SESSION['user']['nombre_completo'] ?? ($_SESSION['user']['usuario'] ?? '?');
                Database::log("ASISTENTE ALTA usuario='{$usuario}' nombre='{$nombre}' clinica_id={$idClinica} agregado por='{$usr}'");
                $this->flash('ok', 'Asistente registrado y asignado a la clinica.');
            }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('asistentes');
    }

    public function asignarClinica(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $ctx['clinicasFiltro']);
        $idAsistente = (int)$this->input('id_ASISTENTE');
        $idClinica   = (int)$this->input('id_CLINICA');
        try {
            if ($idAsistente <= 0) throw new RuntimeException('Selecciona un asistente.');
            if (!$this->asistentePermitido($idAsistente)) throw new RuntimeException('Asistente fuera del alcance del administrador.');
            if (!in_array($idClinica, $idsAdmin, true)) throw new RuntimeException('Clinica fuera del alcance del administrador.');
            foreach (UsuarioClinicaModel::listarPorUsuario($idAsistente) as $r) {
                if ((int)$r['id_CLINICA'] === $idClinica) {
                    $this->flash('ok', 'La clinica ya estaba asignada.');
                    $_SESSION['ui']['asistentes']['edit'] = $idAsistente;
                    $this->redirect('asistentes');
                    return;
                }
            }
            $this->validaCupoUsuario($idClinica, $idAsistente);
            UsuarioClinicaModel::asigna($idAsistente, $idClinica);
            $usr = $_SESSION['user']['nombre_completo'] ?? ($_SESSION['user']['usuario'] ?? '?');
            $nomCl = '';
            foreach ($ctx['clinicasFiltro'] as $c) if ((int)$c['id_CLINICA'] === $idClinica) { $nomCl = (string)$c['nombre']; break; }
            Database::log("ASISTENTE CLINICA ASIGNADA id_USUARIOS={$idAsistente} clinica='{$nomCl}' (id={$idClinica}) agregado por='{$usr}'");
            $this->flash('ok', 'Clinica asignada al asistente.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $_SESSION['ui']['asistentes']['edit'] = $idAsistente;
        $this->redirect('asistentes');
    }

    public function removerClinica(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $ctx['clinicasFiltro']);
        $idAsistente = (int)$this->input('id_ASISTENTE');
        $idUC        = (int)$this->input('id_USUARIOS_CLINICA');
        $idClinica   = (int)$this->input('id_CLINICA');
        try {
            if (!$this->asistentePermitido($idAsistente)) throw new RuntimeException('Asistente fuera del alcance del administrador.');
            if (!in_array($idClinica, $idsAdmin, true)) throw new RuntimeException('Clinica fuera del alcance del administrador.');
            if (!$this->asignacionDeUsuario($idAsistente, $idUC, $idClinica)) {
                Database::log("ASISTENTE CLINICA REMOVER DENEGADO id_USUARIOS_CLINICA={$idUC} id_USUARIOS={$idAsistente} clinica_id={$idClinica}");
                throw new RuntimeException('La asignación no corresponde a este asistente.');
            }
            UsuarioClinicaModel::baja($idUC);
            $usr = $_SESSION['user']['nombre_completo'] ?? ($_SESSION['user']['usuario'] ?? '?');
            Database::log("ASISTENTE CLINICA REMOVIDA id_USUARIOS={$idAsistente} clinica_id={$idClinica} por='{$usr}'");
            $this->flash('ok', 'Clinica removida del asistente.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $_SESSION['ui']['asistentes']['edit'] = $idAsistente;
        $this->redirect('asistentes');
    }

    public function activar(): void {
        $this->requireLogin(['administrador']);
        $id = (int)$this->input('id');
        if (!$this->asistentePermitido($id)) { $this->denegarRecurso('ASISTENTE', $id, null, 'asistentes'); return; }
        try {
            UsuarioModel::activa($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("ASISTENTE ACTIVADO id_USUARIOS={$id} por usuario='{$usr}'");
            $this->flash('ok', 'Asistente activado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('asistentes');
    }

    public function desactivar(): void {
        $this->requireLogin(['administrador']);
        $id = (int)$this->input('id');
        if (!$this->asistentePermitido($id)) { $this->denegarRecurso('ASISTENTE', $id, null, 'asistentes'); return; }
        try {
            UsuarioModel::desactiva($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("ASISTENTE DESACTIVADO id_USUARIOS={$id} por usuario='{$usr}'");
            $this->flash('ok', 'Asistente desactivado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('asistentes');
    }
}
