<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/UsuarioClinicaModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class UsuariosClinicaController extends Controller {
    public function index(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $clinicasAdmin = $ctx['clinicasFiltro']; // clinicas asignadas al admin
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $clinicasAdmin);

        $usuarios = UsuarioModel::listar();
        // Excluir admin_sistema y el propio usuario admin_clinica no se filtra.
        $usuarios = array_values(array_filter($usuarios, function ($u) {
            $rol = strtolower((string)($u['rol'] ?? ''));
            return $rol !== 'admin_sistema' && strpos($rol, 'sistema') === false;
        }));

        $idUsuario = $this->intOrNull($_GET['id_USUARIO'] ?? null);
        $usuarioSel = null;
        $asignadas = [];
        $asignadasIds = [];
        if ($idUsuario) {
            foreach ($usuarios as $u) {
                if ((int)$u['id_USUARIOS'] === $idUsuario) { $usuarioSel = $u; break; }
            }
            if ($usuarioSel) {
                $asignadas = UsuarioClinicaModel::listarPorUsuario($idUsuario);
                $asignadasIds = array_map(fn($r) => (int)$r['id_CLINICA'], $asignadas);
            }
        }

        $this->view('usuarios_clinica/index', [
            'title'         => 'Asignar clínicas a usuarios',
            'usuarios'      => $usuarios,
            'clinicasAdmin' => $clinicasAdmin,
            'idsAdmin'      => $idsAdmin,
            'idUsuario'     => $idUsuario,
            'usuarioSel'    => $usuarioSel,
            'asignadas'     => $asignadas,
            'asignadasIds'  => $asignadasIds,
        ]);
    }

    public function asignar(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $ctx['clinicasFiltro']);
        $idUsuario = (int)$this->input('id_USUARIO');
        $idClinica = (int)$this->input('id_CLINICA');
        try {
            if (!in_array($idClinica, $idsAdmin, true)) {
                throw new RuntimeException('Clínica fuera del alcance del administrador.');
            }
            $ya = UsuarioClinicaModel::listarPorUsuario($idUsuario);
            foreach ($ya as $r) {
                if ((int)$r['id_CLINICA'] === $idClinica) {
                    $this->flash('ok', 'La clínica ya estaba asignada.');
                    $this->redirect('usuariosClinica?id_USUARIO=' . $idUsuario);
                    return;
                }
            }
            UsuarioClinicaModel::asigna($idUsuario, $idClinica);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("USUARIO_CLINICA ASIGNADA usuario={$idUsuario} clinica={$idClinica} por={$usr}");
            $this->flash('ok', 'Clínica asignada.');
        } catch (Throwable $e) {
            $this->flash('error', $e->getMessage());
        }
        $this->redirect('usuariosClinica?id_USUARIO=' . $idUsuario);
    }

    public function remover(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $ctx['clinicasFiltro']);
        $idUsuario = (int)$this->input('id_USUARIO');
        $idUsuariosClinica = (int)$this->input('id_USUARIOS_CLINICA');
        $idClinica = (int)$this->input('id_CLINICA');
        try {
            if (!in_array($idClinica, $idsAdmin, true)) {
                throw new RuntimeException('Clínica fuera del alcance del administrador.');
            }
            UsuarioClinicaModel::baja($idUsuariosClinica);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("USUARIO_CLINICA REMOVIDA id_USUARIOS_CLINICA={$idUsuariosClinica} usuario={$idUsuario} clinica={$idClinica} por={$usr}");
            $this->flash('ok', 'Asignación removida.');
        } catch (Throwable $e) {
            $this->flash('error', $e->getMessage());
        }
        $this->redirect('usuariosClinica?id_USUARIO=' . $idUsuario);
    }
}