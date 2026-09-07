<?php
require_once __DIR__ . '/../core/Model.php';
require_once __DIR__ . '/../core/Config.php';

/**
 * Codigos de verificacion (OTP) para la pagina publica de citas.
 * El codigo NUNCA se guarda en claro: solo su hash SHA-256 con sal (APP_KEY).
 */
class OtpCitaPublicaModel extends Model {

    public const MINUTOS_VIGENCIA = 10;
    public const MAX_INTENTOS     = 5;
    public const MAX_ENVIOS_HORA  = 5;

    /** Normaliza el telefono a sus ultimos 10 digitos (llave del OTP). */
    public static function clave(string $telefono): string {
        $d = preg_replace('/\D+/', '', $telefono) ?? '';
        return strlen($d) > 10 ? substr($d, -10) : $d;
    }

    private static function hash(string $telefono, string $codigo): string {
        $sal = (string)(Config::get('APP_KEY') ?? getenv('APP_KEY') ?: 'sgco');
        return hash('sha256', $sal . '|' . self::clave($telefono) . '|' . $codigo);
    }

    /** Genera un codigo de 4 digitos, lo guarda como hash y lo devuelve. */
    public static function generar(string $telefono, string $canal, ?string $ip = null): string {
        $codigo = str_pad((string)random_int(0, 9999), 4, '0', STR_PAD_LEFT);
        self::execute(
            'EXEC citas.spAltaOtpCitaPublica @telefono=:t, @codigo_hash=:h, @canal=:c, @minutos=:m, @ip=:i',
            [':t' => self::clave($telefono), ':h' => self::hash($telefono, $codigo),
             ':c' => $canal, ':m' => self::MINUTOS_VIGENCIA, ':i' => $ip]
        );
        return $codigo;
    }

    /** Envios hechos en la ultima hora para ese telefono. */
    public static function enviosRecientes(string $telefono): int {
        $rows = self::query('EXEC citas.spCuentaOtpCitaPublica @telefono=:t, @minutos=60',
                            [':t' => self::clave($telefono)]);
        return (int)($rows[0]['total'] ?? 0);
    }

    /**
     * Valida el codigo capturado.
     * @return array{ok:bool,motivo:string} motivo: ok|sin_codigo|expirado|intentos|incorrecto
     */
    public static function validar(string $telefono, string $codigo): array {
        $rows = self::query('EXEC citas.spRegresaOtpCitaPublica @telefono=:t', [':t' => self::clave($telefono)]);
        $row = $rows[0] ?? null;
        if (!$row) return ['ok' => false, 'motivo' => 'sin_codigo'];

        $exp = $row['fecha_expira'] ?? null;
        $expTs = $exp instanceof DateTime ? $exp->getTimestamp() : strtotime((string)$exp);
        if ($expTs !== false && $expTs < time()) {
            self::consumir((int)$row['id_OTP_CITA_PUBLICA']);
            return ['ok' => false, 'motivo' => 'expirado'];
        }
        if ((int)$row['intentos'] >= self::MAX_INTENTOS) {
            self::consumir((int)$row['id_OTP_CITA_PUBLICA']);
            return ['ok' => false, 'motivo' => 'intentos'];
        }
        if (hash_equals((string)$row['codigo_hash'], self::hash($telefono, $codigo))) {
            self::consumir((int)$row['id_OTP_CITA_PUBLICA']);
            return ['ok' => true, 'motivo' => 'ok'];
        }
        $intentos = self::intento((int)$row['id_OTP_CITA_PUBLICA']);
        if ($intentos >= self::MAX_INTENTOS) {
            self::consumir((int)$row['id_OTP_CITA_PUBLICA']);
            return ['ok' => false, 'motivo' => 'intentos'];
        }
        return ['ok' => false, 'motivo' => 'incorrecto'];
    }

    private static function intento(int $id): int {
        $rows = self::query('EXEC citas.spIntentoOtpCitaPublica @id_OTP_CITA_PUBLICA=:i', [':i' => $id]);
        return (int)($rows[0]['intentos'] ?? 0);
    }

    private static function consumir(int $id): void {
        self::execute('EXEC citas.spUsaOtpCitaPublica @id_OTP_CITA_PUBLICA=:i', [':i' => $id]);
    }
}
