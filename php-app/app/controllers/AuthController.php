<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../core/Auth.php';

class AuthController extends Controller {
    public function index(): void { $this->login(); }

    public function login(): void {
        // Si la sesión ya está autenticada (por ejemplo, al abrir otra pestaña),
        // reutilizarla y enviar al usuario directamente a su pantalla inicial.
        if (!empty($_SESSION['user']) && is_array($_SESSION['user'])) {
            $rol = (string)($_SESSION['user']['rol'] ?? '');
            $destino = $rol === 'admin_sistema' ? url('clinicas') : url('calendario');
            header('Location: ' . $destino);
            exit;
        }

        $error = null;
        // Evita que el navegador reutilice una copia cacheada del formulario
        // (una version vieja sin token CSRF provoca "enviado=NO").
        header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
        header('Pragma: no-cache');
        header('Expires: 0');
        if (!empty($_SESSION['flash_error'])) {
            $error = $_SESSION['flash_error'];
            unset($_SESSION['flash_error']);
        }
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $usuario  = trim($_POST['usuario'] ?? '');
            $password = $_POST['password'] ?? '';
            $user = Auth::attempt($usuario, $password);
            if ($user) {
                // Anti session fixation: se emite un identificador de sesion
                // nuevo al autenticar, conservando el token CSRF vigente.
                $csrf = $_SESSION['csrf_token'] ?? null;
                session_regenerate_id(true);
                if ($csrf) { $_SESSION['csrf_token'] = $csrf; }
                $_SESSION['user'] = $user;
                $destino = $user['rol'] === 'admin_sistema' ? url('clinicas') : url('calendario');
                header('Location: ' . $destino);
                exit;
            }
            $error = 'Usuario o contraseña incorrectos';
        }
        require __DIR__ . '/../views/auth/login.php';
    }

    /** Vigencia del enlace de restablecimiento (minutos). */
    private const RESET_MINUTOS = 5;
    /** Maximo de solicitudes por usuario por hora. */
    private const RESET_MAX_HORA = 5;

    /** Pantalla publica: solicitar el enlace para restablecer la contrasena. */
    public function recuperar(): void {
        require_once __DIR__ . '/../models/UsuarioModel.php';
        require_once __DIR__ . '/../models/PasswordResetModel.php';
        require_once __DIR__ . '/../models/ConfigCorreoModel.php';
        require_once __DIR__ . '/../models/LogModel.php';
        require_once __DIR__ . '/../core/Mailer.php';

        $aviso = null; $error = null;
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $usuario = trim((string)($_POST['usuario'] ?? ''));
            $email   = trim((string)($_POST['email'] ?? ''));
            // Respuesta generica: nunca se revela si el usuario o el correo existen.
            $aviso = 'Si los datos coinciden con una cuenta registrada, enviamos un enlace al correo. Revisa tu bandeja de entrada y la carpeta de no deseados.';
            try {
                $u = $this->buscarUsuarioCorreo($usuario, $email);
                if ($u) {
                    $id = (int)$u['id_USUARIOS'];
                    if (PasswordResetModel::solicitudesRecientes($id, 60) >= self::RESET_MAX_HORA) {
                        Database::log('RESET bloqueado por limite usuario=' . $usuario);
                    } else {
                        $token = bin2hex(random_bytes(32));
                        PasswordResetModel::crear($id, $token, self::RESET_MINUTOS, (string)($_SERVER['REMOTE_ADDR'] ?? ''));
                        $this->enviarCorreoReset($u, $token);
                        LogModel::evento('SEGURIDAD', 'recuperar', 'PASSWORD_RESET',
                            'ENVIO ENLACE RESTABLECER: usuario=' . $u['usuario'] . ', correo=' . $email);
                    }
                } else {
                    Database::log('RESET datos no coinciden usuario=' . $usuario);
                }
            } catch (Throwable $e) {
                Database::log('RESET ERR: ' . $e->getMessage());
                $error = 'No fue posible enviar el correo en este momento. Intenta más tarde.';
                $aviso = null;
            }
        }
        require __DIR__ . '/../views/auth/recuperar.php';
    }

    /** Pantalla publica: capturar la nueva contrasena (token en la ruta). */
    public function restablecer(string $tokenUrl = ''): void {
        require_once __DIR__ . '/../models/UsuarioModel.php';
        require_once __DIR__ . '/../models/PasswordResetModel.php';
        require_once __DIR__ . '/../models/LogModel.php';

        $esPost = $_SERVER['REQUEST_METHOD'] === 'POST';
        $token  = $esPost ? (string)($_POST['token'] ?? '') : $tokenUrl;
        $token  = preg_match('/^[a-f0-9]{64}$/', $token) ? $token : '';
        $valido = false; $error = null; $usuario = '';

        $reg = $token === '' ? null : PasswordResetModel::obtener($token);
        if ($reg && (int)$reg['usado'] === 0 && (int)($reg['activo'] ?? 1) === 1
            && strtotime((string)(is_object($reg['fecha_expira']) ? $reg['fecha_expira']->format('Y-m-d H:i:s') : $reg['fecha_expira'])) >= time()) {
            $valido = true;
            $usuario = (string)$reg['usuario'];
        } else {
            $error = 'El enlace expiró o ya fue utilizado. Solicita uno nuevo.';
        }

        if ($esPost && $valido) {
            $nueva = (string)($_POST['nueva'] ?? '');
            $conf  = (string)($_POST['confirmacion'] ?? '');
            if (strlen($nueva) < 8) {
                $error = 'La contraseña debe tener al menos 8 caracteres.';
            } elseif ($nueva !== $conf) {
                $error = 'La confirmación no coincide con la nueva contraseña.';
            } else {
                try {
                    UsuarioModel::cambioPassword((int)$reg['id_USUARIOS'], $nueva);
                    PasswordResetModel::usar((int)$reg['id_PASSWORD_RESET']);
                    LogModel::evento('SEGURIDAD', 'restablecer', 'USUARIOS',
                        'PASSWORD RESTABLECIDO POR CORREO: usuario=' . $usuario);
                    $_SESSION['flash_error'] = 'Tu contraseña fue actualizada. Inicia sesión con la nueva contraseña.';
                    header('Location: ' . url('auth/login'));
                    exit;
                } catch (Throwable $e) {
                    Database::log('RESET guardar ERR: ' . $e->getMessage());
                    $error = 'No fue posible actualizar la contraseña. Intenta de nuevo.';
                }
            }
        }
        require __DIR__ . '/../views/auth/restablecer.php';
    }

    /** Usuario activo cuyo nombre de usuario y correo coinciden exactamente. */
    private function buscarUsuarioCorreo(string $usuario, string $email): ?array {
        if ($usuario === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) return null;
        foreach (UsuarioModel::listar() as $u) {
            if (strcasecmp(trim((string)($u['usuario'] ?? '')), $usuario) !== 0) continue;
            if (strcasecmp(trim((string)($u['email'] ?? '')), $email) !== 0) continue;
            if ((int)($u['activo'] ?? 1) !== 1) continue;
            return $u;
        }
        return null;
    }

    private function enviarCorreoReset(array $u, string $token): void {
        $cfg = ConfigCorreoModel::obtener();
        if (!$cfg || (int)($cfg['activo'] ?? 0) !== 1) {
            throw new Exception('No hay una cuenta de correo configurada en el sistema.');
        }
        $proto  = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
        $host   = (string)($_SERVER['HTTP_HOST'] ?? 'localhost');
        $enlace = $proto . '://' . $host . url('auth/restablecer/' . $token);
        $nombre = htmlspecialchars((string)($u['nombre_completo'] ?? $u['usuario']));
        $html = '<div style="font-family:Arial,Helvetica,sans-serif;color:#1E3A5F">'
              . '<h2>Restablecer contraseña</h2>'
              . '<p>Hola ' . $nombre . ', recibimos una solicitud para restablecer la contraseña de tu cuenta '
              . '<strong>' . htmlspecialchars((string)$u['usuario']) . '</strong>.</p>'
              . '<p><a href="' . htmlspecialchars($enlace, ENT_QUOTES) . '" '
              . 'style="background:#1E3A5F;color:#fff;padding:10px 18px;border-radius:6px;text-decoration:none">Crear nueva contraseña</a></p>'
              . '<p>Este enlace es válido por ' . self::RESET_MINUTOS . ' minutos y solo puede usarse una vez.</p>'
              . '<p>Si no solicitaste el cambio, ignora este mensaje.</p></div>';
        $texto = "Restablecer contraseña\n\nAbre este enlace (válido " . self::RESET_MINUTOS . " minutos): " . $enlace;

        Mailer::enviar([
            'host' => (string)$cfg['host'], 'puerto' => (int)$cfg['puerto'], 'cifrado' => (string)$cfg['cifrado'],
            'usuario' => (string)$cfg['usuario'], 'password' => (string)$cfg['password'],
            'remitente' => (string)$cfg['remitente'], 'remitente_nombre' => (string)$cfg['remitente_nombre'],
        ], (string)$u['email'], 'Restablecer contraseña - Citas Médicas', $html, $texto);
    }

    public function logout(): void {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $p = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000, $p['path'], $p['domain'], $p['secure'], $p['httponly']);
        }
        session_destroy();
        session_start();
        session_regenerate_id(true);
        header('Location: ' . url('auth/login'));
        exit;
    }
}