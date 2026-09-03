<?php
require_once __DIR__ . '/../core/Model.php';

class PasswordResetModel extends Model {
    /** Token en claro que se manda por correo; en la base solo se guarda su hash. */
    public static function crear(int $idUsuario, string $tokenPlano, int $minutos, string $ip): void {
        self::execute('EXEC citas.spAltaPasswordReset @id_USUARIOS=:u, @token_hash=:t, @minutos=:m, @ip=:ip, @id_usuario=:a', [
            ':u' => $idUsuario, ':t' => self::hash($tokenPlano), ':m' => $minutos, ':ip' => $ip, ':a' => 0,
        ]);
    }

    public static function obtener(string $tokenPlano): ?array {
        $rows = self::query('EXEC citas.spRegresaPasswordReset @token_hash=:t', [':t' => self::hash($tokenPlano)]);
        return $rows[0] ?? null;
    }

    public static function usar(int $idReset): void {
        self::execute('EXEC citas.spUsaPasswordReset @id_PASSWORD_RESET=:i, @id_usuario=:a', [':i' => $idReset, ':a' => 0]);
    }

    /** Solicitudes hechas por el usuario en los ultimos $minutos. */
    public static function solicitudesRecientes(int $idUsuario, int $minutos): int {
        $rows = self::query('EXEC citas.spCuentaPasswordReset @id_USUARIOS=:u, @minutos=:m', [':u' => $idUsuario, ':m' => $minutos]);
        return (int)($rows[0]['total'] ?? 0);
    }

    public static function hash(string $token): string {
        return hash('sha256', $token);
    }
}
