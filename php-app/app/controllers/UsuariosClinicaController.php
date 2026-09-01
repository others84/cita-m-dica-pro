<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/UsuarioClinicaModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/RolModel.php';

class UsuariosClinicaController extends Controller {
    public function index(): void {
        $this->requireLogin(['admin_sistema']);
        $ctx = $this->resolveClinicaContext();
        $clinicasAdmin = $ctx['clinicasFiltro']; // clinicas asignadas al admin
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $clinicasAdmin);

        // spRegresaUsuarios devuelve una fila por clinica asignada: se
        // deduplica por id_USUARIOS para que el combo no repita usuarios.
        $todos = [];
        foreach (UsuarioModel::listar() as $u) {
            $rol = strtolower((string)($u['rol'] ?? ''));
            if (strpos($rol, 'sistema') !== false) continue; // no aplica a admin de sistema
            $id = (int)($u['id_USUARIOS'] ?? 0);
            if ($id <= 0 || isset($todos[$id])) continue;
            $todos[$id] = $u;
        }

        // Filtro por rol.
        $roles = RolModel::listar();
        $roles = array_values(array_filter($roles, fn($r) => strpos(strtolower((string)($r['nombre'] ?? '')), 'sistema') === false));
        $idRol = $this->stateInt('f_rol');
        if ($idRol !== null) {
            $existe = false;
            foreach ($roles as $r) { if ((int)$r['id_ROLES'] === $idRol) { $existe = true; break; } }
            if (!$existe) { $idRol = null; $this->clearState('f_rol'); }
        }

        $usuarios = array_values(array_filter(
            $todos,
            fn($u) => $idRol === null || (int)($u['id_ROLES'] ?? 0) === $idRol
        ));

        $idUsuario = $this->stateInt('id_USUARIO');
        // Si el usuario guardado ya no pertenece al rol filtrado, se limpia.
        if ($idUsuario && $idRol !== null && isset($todos[$idUsuario])
            && (int)($todos[$idUsuario]['id_ROLES'] ?? 0) !== $idRol) {
            $idUsuario = null;
            $this->clearState('id_USUARIO');
        }
        $usuarioSel = null;
        $asignadas = [];
        $asignadasIds = [];
        if ($idUsuario) {
            $usuarioSel = $todos[$idUsuario] ?? null;
            if ($usuarioSel) {
                $asignadas = UsuarioClinicaModel::listarPorUsuario($idUsuario);
                $asignadasIds = array_map(fn($r) => (int)$r['id_CLINICA'], $asignadas);
            }
        }

        if (class_exists('Database')) {
            Database::log(sprintf(
                'USUARIOS_CLINICA index rol_filtro=%s id_USUARIO=%s encontrado=%s usuarios=%d asignadas=%d',
                $idRol === null ? 'TODOS' : (string)$idRol,
                $idUsuario === null ? 'NULL' : (string)$idUsuario,
                $usuarioSel ? 'SI' : 'NO',
                count($usuarios),
                count($asignadas)
            ));
        }

        $this->view('usuarios_clinica/index', [
            'title'         => 'Asignar clínicas a usuarios',
            'usuarios'      => $usuarios,
            'roles'         => $roles,
            'idRol'         => $idRol,
            'clinicasAdmin' => $clinicasAdmin,
            'idsAdmin'      => $idsAdmin,
            'idUsuario'     => $idUsuario,
            'usuarioSel'    => $usuarioSel,
            'asignadas'     => $asignadas,
            'asignadasIds'  => $asignadasIds,
        ]);
    }

    public function asignar(): void {
        $this->requireLogin(['admin_sistema']);
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
                    $_SESSION['ui']['usuariosclinica']['id_USUARIO'] = $idUsuario;
                    $this->redirect('usuariosClinica');
                    return;
                }
            }
            $this->validaCupoUsuario($idClinica, $idUsuario);
            UsuarioClinicaModel::asigna($idUsuario, $idClinica);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("USUARIO_CLINICA ASIGNADA usuario={$idUsuario} clinica={$idClinica} por={$usr}");
            $this->flash('ok', 'Clínica asignada.');
        } catch (Throwable $e) {
            $this->flash('error', $e->getMessage());
        }
        $_SESSION['ui']['usuariosclinica']['id_USUARIO'] = $idUsuario;
        $this->redirect('usuariosClinica');
    }

    public function remover(): void {
        $this->requireLogin(['admin_sistema']);
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
        $_SESSION['ui']['usuariosclinica']['id_USUARIO'] = $idUsuario;
        $this->redirect('usuariosClinica');
    }
}