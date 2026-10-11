<?php
/** Verificacion de Cloudflare Turnstile del lado del servidor. */
class Captcha {
    public static function verificar(string $secret, string $token, string $ip): bool {
        if ($token === '' || $secret === '' || !function_exists('curl_init')) return false;
        $ch = curl_init('https://challenges.cloudflare.com/turnstile/v0/siteverify');
        curl_setopt_array($ch, [
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => http_build_query(['secret' => $secret, 'response' => $token, 'remoteip' => $ip]),
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CONNECTTIMEOUT => 5,
            CURLOPT_TIMEOUT => 8,
        ]);
        $res = curl_exec($ch);
        $err = curl_error($ch);
        curl_close($ch);
        if ($res === false) {
            if (class_exists('Database')) Database::log('CAPTCHA error de conexion: ' . $err);
            return false;
        }
        $j = json_decode((string)$res, true);
        return is_array($j) && !empty($j['success']);
    }
}
