<?php
require_once __DIR__ . '/Database.php';

/**
 * Cliente minimo de WhatsApp Cloud API (Meta) para enviar el codigo de
 * verificacion de la cita publica. Usa cURL contra graph.facebook.com.
 */
class Whatsapp {

    /** Telefono en formato internacional sin signos: 52 + 10 digitos. */
    public static function normaliza(string $telefono, string $lada = '52'): string {
        $d = preg_replace('/\D+/', '', $telefono) ?? '';
        if ($d === '') return '';
        if (strlen($d) === 10) return $lada . $d;
        return $d;
    }

    /**
     * Envia el codigo con una plantilla de autenticacion aprobada.
     * @param array<string,mixed> $cfg Config con token descifrado.
     * @throws Exception si el envio falla.
     */
    public static function enviarCodigo(array $cfg, string $telefono, string $codigo): void {
        $lada = (string)($cfg['lada_default'] ?? '52');
        $para = self::normaliza($telefono, $lada);
        if ($para === '') throw new Exception('El número de WhatsApp no es válido.');

        $payload = [
            'messaging_product' => 'whatsapp',
            'to'                => $para,
            'type'              => 'template',
            'template'          => [
                'name'     => (string)($cfg['plantilla'] ?? 'codigo_verificacion'),
                'language' => ['code' => (string)($cfg['plantilla_idioma'] ?? 'es_MX')],
                'components' => [
                    ['type' => 'body', 'parameters' => [['type' => 'text', 'text' => $codigo]]],
                    ['type' => 'button', 'sub_type' => 'url', 'index' => '0',
                     'parameters' => [['type' => 'text', 'text' => $codigo]]],
                ],
            ],
        ];
        self::post($cfg, $payload);
        Database::log('WHATSAPP codigo enviado a=' . substr($para, -4));
    }

    /** Mensaje de texto simple (solo funciona dentro de la ventana de 24 h). */
    public static function enviarTexto(array $cfg, string $telefono, string $texto): void {
        $para = self::normaliza($telefono, (string)($cfg['lada_default'] ?? '52'));
        if ($para === '') throw new Exception('El número de WhatsApp no es válido.');
        self::post($cfg, [
            'messaging_product' => 'whatsapp',
            'to'                => $para,
            'type'              => 'text',
            'text'              => ['preview_url' => false, 'body' => $texto],
        ]);
        Database::log('WHATSAPP texto enviado a=' . substr($para, -4));
    }

    /** @param array<string,mixed> $cfg */
    private static function post(array $cfg, array $payload): array {
        $phoneId = trim((string)($cfg['phone_number_id'] ?? ''));
        $token   = trim((string)($cfg['token'] ?? ''));
        $ver     = trim((string)($cfg['api_version'] ?? 'v21.0')) ?: 'v21.0';
        if ($phoneId === '' || $token === '') {
            throw new Exception('La configuración de WhatsApp está incompleta.');
        }
        if (!function_exists('curl_init')) {
            throw new Exception('El servidor no tiene habilitada la extensión cURL de PHP.');
        }

        $url = 'https://graph.facebook.com/' . rawurlencode($ver) . '/' . rawurlencode($phoneId) . '/messages';
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_POST           => true,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => 20,
            CURLOPT_CONNECTTIMEOUT => 10,
            CURLOPT_HTTPHEADER     => [
                'Authorization: Bearer ' . $token,
                'Content-Type: application/json',
            ],
            CURLOPT_POSTFIELDS     => json_encode($payload, JSON_UNESCAPED_UNICODE),
        ]);
        $resp = curl_exec($ch);
        $http = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $err  = curl_error($ch);
        curl_close($ch);

        if ($resp === false) throw new Exception('No se pudo conectar con WhatsApp: ' . $err);
        $json = json_decode((string)$resp, true);
        if ($http < 200 || $http >= 300) {
            $msg = (string)($json['error']['message'] ?? ('respuesta ' . $http));
            Database::log('WHATSAPP ERROR http=' . $http . ' msg=' . $msg);
            throw new Exception('WhatsApp respondió: ' . $msg);
        }
        return is_array($json) ? $json : [];
    }
}
