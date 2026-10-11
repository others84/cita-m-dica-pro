<?php
require_once __DIR__ . '/../core/Model.php';
require_once __DIR__ . '/ConfigCorreoModel.php';

/** Configuracion anti-bots de la cita publica (CAPTCHA Turnstile y limites por IP). */
class ConfigAntibotModel extends Model {

    public const DEFAULTS = [
        'captcha_activo' => 0, 'site_key' => '', 'secret' => '',
        'lim_buscar_hora' => 20, 'lim_otp_hora' => 10,
        'lim_paciente_dia' => 3, 'lim_cita_dia' => 5, 'lim_citas_futuras' => 2,
    ];

    private static ?array $cache = null;

    /** Siempre devuelve un arreglo (defaults si la tabla no existe). */
    public static function obtener(): array {
        if (self::$cache !== null) return self::$cache;
        $cfg = self::DEFAULTS;
        try {
            $row = self::query('EXEC citas.spRegresaConfigAntibot')[0] ?? null;
            if ($row) {
                foreach ($cfg as $k => $v) if (array_key_exists($k, $row) && $row[$k] !== null) $cfg[$k] = $row[$k];
                $cfg['secret'] = ConfigCorreoModel::descifrar((string)($row['secret_cifrado'] ?? ''));
            }
        } catch (Throwable $e) {
            Database::log('ANTIBOT config no disponible (usa defaults): ' . $e->getMessage());
        }
        foreach (['captcha_activo','lim_buscar_hora','lim_otp_hora','lim_paciente_dia','lim_cita_dia','lim_citas_futuras'] as $k) {
            $cfg[$k] = (int)$cfg[$k];
        }
        return self::$cache = $cfg;
    }

    /** True si el CAPTCHA esta activo y con ambas claves. */
    public static function captchaActivo(): bool {
        $c = self::obtener();
        return $c['captcha_activo'] === 1 && trim((string)$c['site_key']) !== '' && trim((string)$c['secret']) !== '';
    }

    /** $secret vacio conserva el guardado. */
    public static function guardar(array $d, string $secret): void {
        self::execute(
            'EXEC citas.spGuardaConfigAntibot @captcha_activo=:a, @site_key=:sk, @secret_cifrado=:sc, '
            . '@lim_buscar_hora=:lb, @lim_otp_hora=:lo, @lim_paciente_dia=:lp, @lim_cita_dia=:lc, '
            . '@lim_citas_futuras=:lf, @id_usuario=:u',
            [':a' => $d['captcha_activo'] ? 1 : 0, ':sk' => $d['site_key'],
             ':sc' => $secret === '' ? '' : ConfigCorreoModel::cifrar($secret),
             ':lb' => $d['lim_buscar_hora'], ':lo' => $d['lim_otp_hora'],
             ':lp' => $d['lim_paciente_dia'], ':lc' => $d['lim_cita_dia'],
             ':lf' => $d['lim_citas_futuras'], ':u' => self::currentUserId()]
        );
        self::$cache = null;
    }
}
