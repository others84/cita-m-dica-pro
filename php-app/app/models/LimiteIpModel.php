<?php
require_once __DIR__ . '/../core/Model.php';

/** Conteo de acciones por IP en la pagina publica. */
class LimiteIpModel extends Model {

    /** IP del cliente. Solo usa X-Forwarded-For si TRUSTED_PROXY coincide con REMOTE_ADDR. */
    public static function ip(): string {
        $remote = (string)($_SERVER['REMOTE_ADDR'] ?? '0.0.0.0');
        $proxies = array_filter(array_map('trim', explode(',', (string)(getenv('TRUSTED_PROXY') ?: ''))));
        if ($proxies && in_array($remote, $proxies, true) && !empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $first = trim(explode(',', (string)$_SERVER['HTTP_X_FORWARDED_FOR'])[0]);
            if (filter_var($first, FILTER_VALIDATE_IP)) return $first;
        }
        return substr($remote, 0, 45);
    }

    /** Si falla la BD no bloquea (devuelve 0) pero lo registra. */
    public static function cuenta(string $ip, string $accion, int $minutos): int {
        try {
            $r = self::query('EXEC citas.spCuentaLimiteIp @ip=:i, @accion=:a, @minutos=:m',
                             [':i' => $ip, ':a' => $accion, ':m' => $minutos]);
            return (int)($r[0]['total'] ?? 0);
        } catch (Throwable $e) {
            Database::log('LIMITE IP cuenta ERR: ' . $e->getMessage());
            return 0;
        }
    }

    public static function registra(string $ip, string $accion): void {
        try { self::execute('EXEC citas.spRegistraLimiteIp @ip=:i, @accion=:a', [':i' => $ip, ':a' => $accion]); }
        catch (Throwable $e) { Database::log('LIMITE IP registra ERR: ' . $e->getMessage()); }
    }

    public static function citasFuturas(string $telefono, int $idMedico): int {
        $d = preg_replace('/\D+/', '', $telefono) ?? '';
        if (strlen($d) > 10) $d = substr($d, -10);
        if ($d === '' || $idMedico <= 0) return 0;
        try {
            $r = self::query('EXEC citas.spCuentaCitasFuturasTelefono @telefono=:t, @id_MEDICO=:m',
                             [':t' => $d, ':m' => $idMedico]);
            return (int)($r[0]['total'] ?? 0);
        } catch (Throwable $e) {
            Database::log('LIMITE citas futuras ERR: ' . $e->getMessage());
            return 0;
        }
    }
}
