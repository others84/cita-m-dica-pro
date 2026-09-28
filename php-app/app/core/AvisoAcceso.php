<?php
require_once __DIR__ . '/../models/ConfigAvisoAccesoModel.php';
require_once __DIR__ . '/../models/ConfigCorreoModel.php';
require_once __DIR__ . '/../models/LogModel.php';
require_once __DIR__ . '/Mailer.php';

/** Envia por correo el aviso de acceso de administradores. Nunca bloquea el login. */
class AvisoAcceso {
    public const ROLES = ['admin_sistema', 'administrador'];

    public static function rolTexto(string $rol): string {
        return $rol === 'admin_sistema' ? 'Administrador de sistema'
            : ($rol === 'administrador' ? 'Administrador de clínica' : $rol);
    }

    public static function ipCliente(): string {
        $ip = (string)($_SERVER['REMOTE_ADDR'] ?? '0.0.0.0');
        $proxy = class_exists('Config') ? (string)(Config::get('TRUSTED_PROXY') ?? '') : '';
        if ($proxy !== '' && $ip === $proxy && !empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $f = trim(explode(',', (string)$_SERVER['HTTP_X_FORWARDED_FOR'])[0]);
            if (filter_var($f, FILTER_VALIDATE_IP)) $ip = $f;
        }
        return $ip;
    }

    /** Envia el mensaje a los destinos; lanza excepcion si falla. */
    public static function enviar(array $destinos, string $asunto, string $texto): void {
        $cfg = ConfigCorreoModel::obtener();
        if (!$cfg || (int)($cfg['activo'] ?? 0) !== 1) throw new Exception('La cuenta de correo del sistema no está configurada o está inactiva.');
        $smtp = [
            'host' => (string)$cfg['host'], 'puerto' => (int)$cfg['puerto'], 'cifrado' => (string)$cfg['cifrado'],
            'usuario' => (string)$cfg['usuario'], 'password' => (string)$cfg['password'],
            'remitente' => (string)$cfg['remitente'], 'remitente_nombre' => (string)$cfg['remitente_nombre'],
        ];
        $html = '<p>' . nl2br(htmlspecialchars($texto, ENT_QUOTES, 'UTF-8')) . '</p>';
        foreach ($destinos as $d) Mailer::enviar($smtp, $d, $asunto, $html, $texto);
    }

    public static function notificar(array $user): void {
        $rol = (string)($user['rol'] ?? '');
        if (!in_array($rol, self::ROLES, true)) return;
        try {
            $cfg = ConfigAvisoAccesoModel::obtener();
            if (!$cfg || (int)$cfg['activo'] !== 1) return;
            $destinos = ConfigAvisoAccesoModel::listaDestinos((string)$cfg['destinos']);
            if (!$destinos) return;

            $ahora = (string)($cfg['ahora'] ?? '') ?: date('Y-m-d H:i:s');
            $ts = strtotime($ahora) ?: time();
            $clinicas = '';
            if ($rol === 'administrador') {
                require_once __DIR__ . '/../models/UsuarioClinicaModel.php';
                $n = [];
                foreach (UsuarioClinicaModel::listarPorUsuario((int)($user['id_USUARIOS'] ?? 0)) as $c) {
                    $n[] = (string)($c['nombre'] ?? $c['nombre_clinica'] ?? '');
                }
                $clinicas = implode(', ', array_filter($n));
            }
            $ip = self::ipCliente();
            $datos = [
                'USUARIO' => (string)($user['usuario'] ?? ''), 'NOMBRE' => (string)($user['nombre'] ?? ''),
                'ROL' => self::rolTexto($rol), 'FECHA' => date('d/m/Y', $ts), 'HORA' => date('H:i:s', $ts),
                'IP' => $ip, 'CLINICA' => $clinicas,
            ];
            $asunto = ConfigAvisoAccesoModel::render((string)$cfg['asunto'], $datos);
            $texto = ConfigAvisoAccesoModel::render((string)$cfg['plantilla'], $datos);
            self::enviar($destinos, $asunto, $texto);
            LogModel::evento('SEGURIDAD', 'AvisoAcceso', 'CONFIG_AVISO_ACCESO',
                'AVISO ACCESO ENVIADO: usuario=' . $datos['USUARIO'] . ', ip=' . $ip . ', destinos=' . implode(',', $destinos));
        } catch (Throwable $e) {
            Database::log('AvisoAcceso ERR: ' . $e->getMessage());
            LogModel::evento('SEGURIDAD', 'AvisoAcceso', 'CONFIG_AVISO_ACCESO',
                'AVISO ACCESO FALLO: usuario=' . (string)($user['usuario'] ?? '') . ', error=' . $e->getMessage());
        }
    }
}
