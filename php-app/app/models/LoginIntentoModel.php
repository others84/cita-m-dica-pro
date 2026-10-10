<?php
require_once __DIR__ . '/../core/Model.php';

/** Control de intentos fallidos de inicio de sesion (bloqueo temporal). */
class LoginIntentoModel extends Model {
    public const MAX_INTENTOS = 5;
    public const MINUTOS_BLOQUEO = 5;

    /** Segundos restantes de bloqueo (0 = libre). */
    public static function segundosBloqueo(string $usuario): int {
        $rows = self::query('EXEC citas.spEstadoLogin @usuario=:u', [':u' => $usuario]);
        return (int)($rows[0]['segundos_restantes'] ?? 0);
    }

    /** Registra un fallo; devuelve true si con este fallo el usuario quedo bloqueado. */
    public static function registrarFallo(string $usuario, string $ip): bool {
        $rows = self::query('EXEC citas.spRegistraLoginFallido @usuario=:u, @ip=:ip, @max=:m, @minutos=:n', [
            ':u' => $usuario, ':ip' => $ip, ':m' => self::MAX_INTENTOS, ':n' => self::MINUTOS_BLOQUEO,
        ]);
        return (int)($rows[0]['bloqueado'] ?? 0) === 1;
    }

    public static function reiniciar(string $usuario): void {
        self::execute('EXEC citas.spReiniciaLogin @usuario=:u', [':u' => $usuario]);
    }
}
