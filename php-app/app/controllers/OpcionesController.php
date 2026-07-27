<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/UsuarioClinicaModel.php';

class OpcionesController extends Controller {
    public function index(): void { $this->requireLogin(); $this->view('opciones/index', ['title' => 'Opciones']); }
    public function cambiarPassword(): void {
        $this->requireLogin();
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $actual = (string)$this->input('actual');
            $nueva  = (string)$this->input('nueva');
            $conf   = (string)$this->input('confirmacion');
            $user   = $_SESSION['user'];
            try {
                if ($nueva === '' || strlen($nueva) < 4) throw new Exception('La nueva contraseña debe tener al menos 4 caracteres.');
                if ($nueva !== $conf) throw new Exception('La confirmación no coincide con la nueva contraseña.');
                $ok = UsuarioModel::login($user['usuario'], $actual);
                if (!$ok) throw new Exception('La contraseña actual es incorrecta.');
                UsuarioModel::cambioPassword((int)$user['id_USUARIOS'], $nueva);
                $this->flash('ok','Contraseña actualizada correctamente.');
            } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
            $this->redirect('opciones/cambiarPassword');
        }
        $this->view('opciones/cambiar_password', ['title' => 'Cambiar contraseña']);
    }
    public function actualizarDatos(): void { $this->requireLogin(); $this->view('opciones/actualizar_datos', ['title' => 'Actualizar datos']); }

    /**
     * Administrador de clinica: cambia la contrasena de cualquier usuario
     * que pertenezca a las clinicas a las que tiene acceso.
     */
    public function passwordUsuarios(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $usuarios = $this->usuariosDeClinicas($ctx);
        $idSel = $this->stateInt('id_USUARIO');
        $usuarioSel = null;
        foreach ($usuarios as $u) {
            if ($idSel && (int)$u['id_USUARIOS'] === $idSel) { $usuarioSel = $u; break; }
        }
        $this->view('opciones/password_usuarios', [
            'title'      => 'Cambiar contraseña de usuarios',
            'usuarios'   => $usuarios,
            'usuarioSel' => $usuarioSel,
            'fClinica'   => $ctx['fClinica'] ?? null,
            'clinicasFiltro' => $ctx['clinicasFiltro'] ?? [],
        ]);
    }

    public function passwordUsuariosGuardar(): void {
        $this->requireLogin(['administrador']);
        $ctx = $this->resolveClinicaContext();
        $idUsuario = (int)$this->input('id_USUARIO');
        $nueva = (string)$this->input('nueva');
        $conf  = (string)$this->input('confirmacion');
        try {
            if ($idUsuario <= 0) throw new Exception('Selecciona un usuario.');
            if (strlen($nueva) < 4) throw new Exception('La nueva contraseña debe tener al menos 4 caracteres.');
            if ($nueva !== $conf) throw new Exception('La confirmación no coincide con la nueva contraseña.');
            $permitidos = array_map(fn($u) => (int)$u['id_USUARIOS'], $this->usuariosDeClinicas($ctx));
            if (!in_array($idUsuario, $permitidos, true)) {
                throw new Exception('El usuario no pertenece a tus clínicas.');
            }
            UsuarioModel::cambioPassword($idUsuario, $nueva);
            $admin = $_SESSION['user']['usuario'] ?? '?';
            Database::log("PASSWORD RESET id_USUARIOS={$idUsuario} por={$admin}");
            $this->flash('ok', 'Contraseña actualizada correctamente.');
        } catch (Throwable $e) {
            $this->flash('error', $e->getMessage());
        }
        $this->clearState('id_USUARIO');
        $this->redirect('opciones/passwordUsuarios');
    }

    /**
     * Usuarios pertenecientes a las clinicas del admin, mas los
     * administradores de sistema (que no estan ligados a una clinica).
     */
    private function usuariosDeClinicas(array $ctx): array {
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $ctx['clinicasFiltro'] ?? []);
        $yo = (int)($_SESSION['user']['id_USUARIOS'] ?? 0);
        $out = [];
        foreach (UsuarioModel::listar() as $u) {
            $rol = strtolower((string)($u['rol'] ?? ''));
            if ((int)$u['id_USUARIOS'] === $yo) continue;
            if (strpos($rol, 'sistema') !== false) { $out[] = $u; continue; }
            $ids = array_map(fn($r) => (int)$r['id_CLINICA'], UsuarioClinicaModel::listarPorUsuario((int)$u['id_USUARIOS']));
            if (!empty($u['id_CLINICA'])) $ids[] = (int)$u['id_CLINICA'];
            if (array_intersect($ids, $idsAdmin)) $out[] = $u;
        }
        return $out;
    }
}