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
                if ($err = self::errorPassword($nueva)) throw new Exception($err);
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

    /** Administrador de sistema: aviso por correo de accesos de administradores. */
    public function avisoAcceso(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigAvisoAccesoModel.php';
        $cfg = null;
        try { $cfg = ConfigAvisoAccesoModel::obtener(); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->view('opciones/aviso_acceso', ['title' => 'Aviso de accesos', 'cfg' => $cfg]);
    }

    public function avisoAccesoGuardar(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigAvisoAccesoModel.php';
        try {
            $lista = ConfigAvisoAccesoModel::listaDestinos((string)$this->input('destinos'));
            $asunto = trim((string)$this->input('asunto'));
            $texto = trim(str_replace("\r\n", "\n", (string)$this->input('plantilla')));
            $activo = (int)$this->input('activo') === 1;
            if (!$lista) throw new Exception('Indica al menos un correo destino.');
            foreach ($lista as $c) {
                if (!filter_var($c, FILTER_VALIDATE_EMAIL) || strlen($c) > 120) throw new Exception('El correo "' . $c . '" no es válido.');
            }
            $destinos = implode(', ', $lista);
            if (strlen($destinos) > 500) throw new Exception('La lista de correos es demasiado larga.');
            if ($asunto === '' || mb_strlen($asunto) > 200) throw new Exception('El asunto es obligatorio (máximo 200 caracteres).');
            if ($texto === '' || mb_strlen($texto) > 2000) throw new Exception('El texto es obligatorio (máximo 2000 caracteres).');
            ConfigAvisoAccesoModel::guardar($destinos, $asunto, $texto, $activo);
            $this->flash('ok', 'Aviso de accesos guardado.');
        } catch (Throwable $e) {
            $this->flash('error', $e->getMessage());
        }
        $this->redirect('opciones/avisoAcceso');
    }

    public function avisoAccesoPrueba(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../core/AvisoAcceso.php';
        try {
            $cfg = ConfigAvisoAccesoModel::obtener();
            if (!$cfg) throw new Exception('Primero guarda la configuración del aviso.');
            $destinos = ConfigAvisoAccesoModel::listaDestinos((string)$cfg['destinos']);
            $u = $_SESSION['user'];
            $datos = [
                'USUARIO' => (string)($u['usuario'] ?? ''), 'NOMBRE' => (string)($u['nombre'] ?? ''),
                'ROL' => AvisoAcceso::rolTexto((string)($u['rol'] ?? '')),
                'FECHA' => date('d/m/Y', strtotime((string)$cfg['ahora']) ?: time()),
                'HORA' => date('H:i:s', strtotime((string)$cfg['ahora']) ?: time()),
                'IP' => AvisoAcceso::ipCliente(), 'CLINICA' => '',
            ];
            AvisoAcceso::enviar($destinos,
                '[Prueba] ' . ConfigAvisoAccesoModel::render((string)$cfg['asunto'], $datos),
                ConfigAvisoAccesoModel::render((string)$cfg['plantilla'], $datos));
            $this->flash('ok', 'Aviso de prueba enviado a ' . implode(', ', $destinos) . '.');
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo enviar: ' . $e->getMessage());
        }
        $this->redirect('opciones/avisoAcceso');
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

    /** Administrador de sistema: CAPTCHA y limites por IP de la cita publica. */
    public function antibot(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigAntibotModel.php';
        $cfg = ConfigAntibotModel::obtener();
        $cfg['tiene_secret'] = trim((string)$cfg['secret']) !== '';
        unset($cfg['secret']);
        $this->view('opciones/antibot', ['title' => 'Protección cita pública', 'cfg' => $cfg]);
    }

    public function antibotGuardar(): void {
        $this->requireLogin(['admin_sistema']);
        require_once __DIR__ . '/../models/ConfigAntibotModel.php';
        try {
            $n = function (string $k, int $max) {
                $v = (int)$this->input($k);
                if ($v < 0 || $v > $max) throw new Exception('El límite "' . $k . '" debe estar entre 0 y ' . $max . ' (0 = sin límite).');
                return $v;
            };
            $d = [
                'captcha_activo' => (int)$this->input('captcha_activo') === 1,
                'site_key' => trim((string)$this->input('site_key')),
                'lim_buscar_hora' => $n('lim_buscar_hora', 1000), 'lim_otp_hora' => $n('lim_otp_hora', 1000),
                'lim_paciente_dia' => $n('lim_paciente_dia', 1000), 'lim_cita_dia' => $n('lim_cita_dia', 1000),
                'lim_citas_futuras' => $n('lim_citas_futuras', 50),
            ];
            $secret = trim((string)$this->input('secret'));
            if (strlen($d['site_key']) > 200 || strlen($secret) > 300) throw new Exception('Las claves son demasiado largas.');
            if ($d['captcha_activo']) {
                $actual = ConfigAntibotModel::obtener();
                if ($d['site_key'] === '') throw new Exception('Captura la clave pública (site key) de Turnstile.');
                if ($secret === '' && trim((string)$actual['secret']) === '') throw new Exception('Captura la clave secreta de Turnstile.');
            }
            ConfigAntibotModel::guardar($d, $secret);
            $this->flash('ok', 'Protección de la cita pública guardada.');
        } catch (Throwable $e) {
            $this->flash('error', $e->getMessage());
        }
        $this->redirect('opciones/antibot');
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
            if ($err = self::errorPassword($nueva)) throw new Exception($err);
            if ($nueva !== $conf) throw new Exception('La confirmación no coincide con la nueva contraseña.');
            $permitidos = array_map(fn($u) => (int)$u['id_USUARIOS'], $this->usuariosDeClinicas($ctx));
            if (!in_array($idUsuario, $permitidos, true)) {
                $admin = $_SESSION['user']['usuario'] ?? '?';
                Database::log("PASSWORD RESET DENEGADO id_USUARIOS={$idUsuario} por={$admin}");
                throw new Exception('Solo puedes cambiar la contraseña de asistentes y médicos de tus clínicas.');
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
            // Solo asistentes y medicos; nunca administradores ni el propio usuario.
            if ($id === (int)($_SESSION['user']['id_USUARIOS'] ?? 0)) continue;
            $rolU = mb_strtolower((string)($u['rol'] ?? ''));
            if (strpos($rolU, 'administrador') !== false) continue;
            if (strpos($rolU, 'asistente') === false && strpos($rolU, 'medico') === false && strpos($rolU, 'médico') === false) continue;
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