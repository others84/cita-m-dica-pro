<?php
require_once __DIR__ . '/Database.php';

/**
 * Cliente de Evolution API (WhatsApp via QR, auto-hospedado en el VPS) para
 * enviar el codigo de verificacion de la cita publica.
 *
 * Lee api_url, instancia y api_key de CONFIG_WHATSAPP_EVOLUTION.
 */
class Whatsapp {

    public static function validarConfiguracion(string $base, string $instancia, string $apiKey, string $lada): void {
        $url = parse_url($base);
        if (strlen($base) > 500 || preg_match('/[\s\x00-\x1F\x7F]/', $base)
            || !is_array($url) || !in_array($url['scheme'] ?? '', ['http', 'https'], true)
            || empty($url['host']) || isset($url['user']) || isset($url['pass'])
            || isset($url['query']) || isset($url['fragment'])) {
            throw new Exception('La URL de Evolution API debe ser http:// o https://, sin usuario, contraseña ni parámetros (máximo 500 caracteres).');
        }
        if (!preg_match('/^[A-Za-z0-9_\-]{1,60}$/', $instancia)) {
            throw new Exception('La instancia solo admite letras, números, guion y guion bajo (máximo 60 caracteres).');
        }
        if (strlen($apiKey) > 1000 || preg_match('/[\x00-\x20\x7F]/', $apiKey)) {
            throw new Exception('La API Key no debe contener espacios ni superar 1000 caracteres.');
        }
        if (!preg_match('/^[1-9][0-9]{0,4}$/', $lada)) throw new Exception('La lada debe tener entre 1 y 5 dígitos.');
    }

    /** Telefono en formato internacional sin signos: 52 + 10 digitos. */
    public static function normaliza(string $telefono, string $lada = '52'): string {
        $d = preg_replace('/\D+/', '', $telefono) ?? '';
        if ($d === '') return '';
        if (strlen($d) === 10) return $lada . $d;
        return $d;
    }

    /** @param array<string,mixed> $cfg */
    public static function enviarCodigo(array $cfg, string $telefono, string $codigo): void {
        $texto = 'SGCO Citas: tu código de verificación es ' . $codigo
               . '. Es válido por 10 minutos. No lo compartas con nadie.';
        self::enviarTexto($cfg, $telefono, $texto);
        Database::log('WHATSAPP codigo enviado');
    }

    /** @param array<string,mixed> $cfg */
    public static function enviarTexto(array $cfg, string $telefono, string $texto): void {
        $para = self::normaliza($telefono, (string)($cfg['lada_default'] ?? '52'));
        if (!preg_match('/^[1-9][0-9]{9,14}$/', $para)) throw new Exception('El número de WhatsApp no es válido.');
        self::post($cfg, ['number' => $para, 'text' => $texto]);
        Database::log('WHATSAPP texto enviado a=' . substr($para, -4));
    }

    /** @param array<string,mixed> $cfg */
    private static function post(array $cfg, array $payload): array {
        $base      = rtrim(trim((string)($cfg['api_url'] ?? '')), '/');
        $instancia = trim((string)($cfg['instancia'] ?? ''));
        $apiKey    = trim((string)($cfg['api_key'] ?? ''));
        self::validarConfiguracion($base, $instancia, $apiKey, (string)($cfg['lada_default'] ?? '52'));
        if ($instancia === '' || $apiKey === '') {
            throw new Exception('La configuración de WhatsApp está incompleta.');
        }
        if (!function_exists('curl_init')) {
            throw new Exception('El servidor no tiene habilitada la extensión cURL de PHP.');
        }

        $url = $base . '/message/sendText/' . rawurlencode($instancia);
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_POST           => true,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => 20,
            CURLOPT_CONNECTTIMEOUT => 10,
            CURLOPT_HTTPHEADER     => ['apikey: ' . $apiKey, 'Content-Type: application/json'],
            CURLOPT_POSTFIELDS     => json_encode($payload, JSON_UNESCAPED_UNICODE),
        ]);
        $resp = curl_exec($ch);
        $http = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $err  = curl_error($ch);
        curl_close($ch);

        if ($resp === false) throw new Exception('No se pudo conectar con Evolution API. Revisa el servicio y la URL configurada.');
        $json = json_decode((string)$resp, true);
        if ($http < 200 || $http >= 300) {
            Database::log('WHATSAPP ERROR http=' . $http);
            throw new Exception('Evolution API rechazó el envío (HTTP ' . $http . '). Revisa la API Key y que la instancia esté conectada.');
        }
        return is_array($json) ? $json : [];
    }
}
