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

    /** Administrador de sistema: cuenta de correo emisora del sistema. */
    public function correo(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigCorreoModel.php';
        $cfg = null;
        try { $cfg = ConfigCorreoModel::obtener(); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        if (is_array($cfg)) unset($cfg['password'], $cfg['password_cifrada']);
        $this->view('opciones/correo', ['title' => 'Configuración de correo', 'cfg' => $cfg]);
    }

    public function correoGuardar(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigCorreoModel.php';
        try {
            $host = trim((string)$this->input('host'));
            $puerto = (int)$this->input('puerto');
            $cifrado = strtolower((string)$this->input('cifrado'));
            $usuario = trim((string)$this->input('usuario'));
            $password = (string)$this->input('password');
            $remitente = trim((string)$this->input('remitente'));
            $remNombre = trim((string)$this->input('remitente_nombre'));
            $activo = (int)$this->input('activo') === 1;

            if ($host === '') throw new Exception('Indica el servidor SMTP.');
            if ($puerto < 1 || $puerto > 65535) throw new Exception('El puerto no es válido.');
            if (!in_array($cifrado, ['ninguno', 'tls', 'ssl'], true)) throw new Exception('El tipo de cifrado no es válido.');
            if (!filter_var($remitente, FILTER_VALIDATE_EMAIL)) throw new Exception('El correo remitente no es válido.');
            if ($remNombre === '') throw new Exception('Indica el nombre del remitente.');

            ConfigCorreoModel::guardar($host, $puerto, $cifrado, $usuario, $password, $remitente, $remNombre, $activo);
            $this->flash('ok', 'Configuración de correo guardada.');
        } catch (Throwable $e) {
            $this->flash('error', $e->getMessage());
        }
        $this->redirect('opciones/correo');
    }

    public function correoPrueba(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigCorreoModel.php';
        require_once __DIR__ . '/../core/Mailer.php';
        $destino = trim((string)$this->input('destino'));
        try {
            if (!filter_var($destino, FILTER_VALIDATE_EMAIL)) throw new Exception('El correo destino no es válido.');
            $cfg = ConfigCorreoModel::obtener();
            if (!$cfg) throw new Exception('Primero guarda la configuración de correo.');
            Mailer::enviar([
                'host' => (string)$cfg['host'], 'puerto' => (int)$cfg['puerto'], 'cifrado' => (string)$cfg['cifrado'],
                'usuario' => (string)$cfg['usuario'], 'password' => (string)$cfg['password'],
                'remitente' => (string)$cfg['remitente'], 'remitente_nombre' => (string)$cfg['remitente_nombre'],
            ], $destino, 'Prueba de correo - Citas Médicas',
               '<p>Este es un correo de prueba enviado desde el sistema de citas médicas.</p>');
            $this->flash('ok', 'Correo de prueba enviado a ' . $destino . '.');
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo enviar: ' . $e->getMessage());
        }
        $this->redirect('opciones/correo');
    }

    /** Administrador de sistema: credenciales de WhatsApp Cloud API. */
    public function whatsapp(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigWhatsappModel.php';
        $cfg = null;
        try { $cfg = ConfigWhatsappModel::obtener(); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        if (is_array($cfg)) unset($cfg['token'], $cfg['token_cifrado']);
        $this->view('opciones/whatsapp', ['title' => 'Configuración de WhatsApp', 'cfg' => $cfg]);
    }

    public function whatsappGuardar(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigWhatsappModel.php';
        try {
            $phoneId = trim((string)$this->input('phone_number_id'));
            $waba    = trim((string)$this->input('waba_id'));
            $token   = trim((string)$this->input('token'));
            $ver     = trim((string)$this->input('api_version')) ?: 'v21.0';
            $plant   = trim((string)$this->input('plantilla'));
            $idioma  = trim((string)$this->input('plantilla_idioma')) ?: 'es_MX';
            $lada    = preg_replace('/\D+/', '', (string)$this->input('lada_default')) ?: '52';
            $activo  = (int)$this->input('activo') === 1;

            if (!preg_match('/^\d{5,30}$/', $phoneId)) throw new Exception('El Phone Number ID debe ser numérico.');
            if ($waba !== '' && !preg_match('/^\d{5,30}$/', $waba)) throw new Exception('El WABA ID debe ser numérico.');
            if (!preg_match('/^v\d+\.\d+$/', $ver)) throw new Exception('La versión de la API debe tener el formato v21.0.');
            if ($plant === '') throw new Exception('Indica el nombre de la plantilla del código.');

            $actual = null;
            try { $actual = ConfigWhatsappModel::obtener(); } catch (Throwable $e) { $actual = null; }
            if ($token === '' && ($actual === null || trim((string)$actual['token']) === '')) {
                throw new Exception('Captura el token de acceso permanente de Meta.');
            }

            ConfigWhatsappModel::guardar($phoneId, $waba, $token, $ver, $plant, $idioma, $lada, $activo);
            $this->flash('ok', 'Configuración de WhatsApp guardada.');
        } catch (Throwable $e) {
            $this->flash('error', $e->getMessage());
        }
        $this->redirect('opciones/whatsapp');
    }

    public function whatsappPrueba(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigWhatsappModel.php';
        require_once __DIR__ . '/../core/Whatsapp.php';
        $destino = trim((string)$this->input('destino'));
        try {
            if (strlen(preg_replace('/\D+/', '', $destino) ?? '') < 10) {
                throw new Exception('El número debe tener al menos 10 dígitos.');
            }
            $cfg = ConfigWhatsappModel::obtener();
            if (!$cfg) throw new Exception('Primero guarda la configuración de WhatsApp.');
            Whatsapp::enviarCodigo($cfg, $destino, str_pad((string)random_int(0, 9999), 4, '0', STR_PAD_LEFT));
            $this->flash('ok', 'Mensaje de prueba enviado a ' . $destino . '.');
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo enviar: ' . $e->getMessage());
        }
        $this->redirect('opciones/whatsapp');
    }

    /** Apariencia: paleta de colores y tipografia (se guarda en el dispositivo). */
    public function apariencia(): void {
        $this->requireLogin();
        $this->view('opciones/apariencia', ['title' => 'Apariencia']);
    }

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
     * Usuarios pertenecientes a las clinicas del administrador de clinica
     * (incluido el mismo admin). Los administradores de sistema y los
     * usuarios de clinicas ajenas NO se muestran.
     */
    private function usuariosDeClinicas(array $ctx): array {
        $idsAdmin = array_map(fn($c) => (int)$c['id_CLINICA'], $ctx['clinicasFiltro'] ?? []);
        if (empty($idsAdmin)) return [];
        $out = [];
        $vistos = [];
        foreach (UsuarioModel::listar() as $u) {
            $id = (int)($u['id_USUARIOS'] ?? 0);
            if ($id <= 0 || isset($vistos[$id])) continue;
            $vistos[$id] = true;
            // Clinicas del usuario: las asignadas via USUARIOS_CLINICA y, si
            // trae id_CLINICA en su registro, tambien esa.
            $ids = array_map(fn($r) => (int)$r['id_CLINICA'], UsuarioClinicaModel::listarPorUsuario($id));
            if (!empty($u['id_CLINICA'])) $ids[] = (int)$u['id_CLINICA'];
            if (!array_intersect($ids, $idsAdmin)) continue; // no pertenece a sus clinicas
            $out[] = $u;
        }
        return $out;
    }
}