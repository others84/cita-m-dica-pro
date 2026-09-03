<?php
require_once __DIR__ . '/../core/Model.php';
require_once __DIR__ . '/../core/Config.php';

/**
 * Cuenta de correo emisora del sistema. La contrasena SMTP se guarda
 * cifrada con AES-256-GCM usando APP_KEY (definida en .env).
 */
class ConfigCorreoModel extends Model {
    /** @return array<string,mixed>|null Config con la contrasena ya descifrada. */
    public static function obtener(): ?array {
        $rows = self::query('EXEC citas.spRegresaConfigCorreo');
        $row = $rows[0] ?? null;
        if (!$row) return null;
        $row['password'] = self::descifrar((string)($row['password_cifrada'] ?? ''));
        $row['puerto'] = (int)($row['puerto'] ?? 587);
        return $row;
    }

    /** $password vacio conserva la contrasena guardada. */
    public static function guardar(string $host, int $puerto, string $cifrado, string $usuario,
                                   string $password, string $remitente, string $remitenteNombre, bool $activo): void {
        self::execute(
            'EXEC citas.spGuardaConfigCorreo @host=:h, @puerto=:p, @cifrado=:c, @usuario=:u, '
            . '@password_cifrada=:pw, @remitente=:r, @remitente_nombre=:rn, @activo=:a, @id_usuario=:iu',
            [
                ':h' => $host, ':p' => $puerto, ':c' => $cifrado, ':u' => $usuario,
                ':pw' => $password === '' ? '' : self::cifrar($password),
                ':r' => $remitente, ':rn' => $remitenteNombre,
                ':a' => $activo ? 1 : 0, ':iu' => self::currentUserId(),
            ]
        );
    }

    private static function llave(): string {
        $k = (string)(Config::get('APP_KEY') ?? '');
        if ($k === '') $k = (string)(getenv('APP_KEY') ?: '');
        if ($k === '') throw new Exception('Falta APP_KEY en el archivo .env para cifrar la contraseña de correo.');
        return hash('sha256', $k, true);
    }

    public static function cifrar(string $texto): string {
        $iv = random_bytes(12);
        $tag = '';
        $ct = openssl_encrypt($texto, 'aes-256-gcm', self::llave(), OPENSSL_RAW_DATA, $iv, $tag);
        if ($ct === false) throw new Exception('No se pudo cifrar la contraseña de correo.');
        return base64_encode($iv . $tag . $ct);
    }

    public static function descifrar(string $dato): string {
        if ($dato === '') return '';
        $raw = base64_decode($dato, true);
        if ($raw === false || strlen($raw) < 29) return '';
        $iv = substr($raw, 0, 12);
        $tag = substr($raw, 12, 16);
        $ct = substr($raw, 28);
        $out = openssl_decrypt($ct, 'aes-256-gcm', self::llave(), OPENSSL_RAW_DATA, $iv, $tag);
        return $out === false ? '' : $out;
    }
}
