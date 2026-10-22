<?php
require_once __DIR__ . '/Database.php';

/**
 * Cliente de Evolution API (WhatsApp via QR, auto-hospedado en el VPS) para
 * enviar el codigo de verificacion de la cita publica.
 *
 * Reutiliza las columnas de citas.CONFIG_WHATSAPP sin cambios en la BD:
 *   waba_id         -> URL de Evolution API (ej. http://127.0.0.1:8081)
 *   phone_number_id -> nombre de la instancia (ej. clinica)
 *   token           -> API Key de Evolution (cifrada)
 */
class Whatsapp {

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
        if ($para === '') throw new Exception('El número de WhatsApp no es válido.');
        self::post($cfg, ['number' => $para, 'text' => $texto]);
        Database::log('WHATSAPP texto enviado a=' . substr($para, -4));
    }

    /** @param array<string,mixed> $cfg */
    private static function post(array $cfg, array $payload): array {
        $base      = rtrim(trim((string)($cfg['waba_id'] ?? '')), '/') ?: 'http://127.0.0.1:8081';
        $instancia = trim((string)($cfg['phone_number_id'] ?? ''));
        $apiKey    = trim((string)($cfg['token'] ?? ''));
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

        if ($resp === false) throw new Exception('No se pudo conectar con Evolution API: ' . $err);
        $json = json_decode((string)$resp, true);
        if ($http < 200 || $http >= 300) {
            $msg = $json['response']['message'] ?? $json['message'] ?? ('respuesta ' . $http);
            if (is_array($msg)) $msg = json_encode($msg, JSON_UNESCAPED_UNICODE);
            Database::log('WHATSAPP ERROR http=' . $http . ' msg=' . $msg);
            throw new Exception('WhatsApp respondió: ' . $msg);
        }
        return is_array($json) ? $json : [];
    }
}
