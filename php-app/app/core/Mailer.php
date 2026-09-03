<?php
require_once __DIR__ . '/Database.php';

/**
 * Cliente SMTP minimo (sockets) para los avisos del sistema.
 * Soporta SMTP simple, STARTTLS (587) y SMTPS/SSL (465) con AUTH LOGIN.
 */
class Mailer {
    /**
     * @param array{host:string,puerto:int,cifrado:string,usuario:string,password:string,remitente:string,remitente_nombre:string} $cfg
     * @throws Exception si el envio falla.
     */
    public static function enviar(array $cfg, string $para, string $asunto, string $html, string $texto = ''): void {
        $host   = trim((string)($cfg['host'] ?? ''));
        $puerto = (int)($cfg['puerto'] ?? 587);
        $cif    = strtolower((string)($cfg['cifrado'] ?? 'tls'));
        $user   = (string)($cfg['usuario'] ?? '');
        $pass   = (string)($cfg['password'] ?? '');
        $from   = trim((string)($cfg['remitente'] ?? ''));
        $fromNm = trim((string)($cfg['remitente_nombre'] ?? 'Citas Médicas'));

        if ($host === '' || $from === '') throw new Exception('La configuración de correo está incompleta.');
        if (!filter_var($para, FILTER_VALIDATE_EMAIL)) throw new Exception('El correo destino no es válido.');
        if ($texto === '') $texto = trim(strip_tags(str_replace(['<br>', '<br/>', '</p>'], "\n", $html)));

        $esquema = $cif === 'ssl' ? 'ssl://' : '';
        $ctx = stream_context_create(['ssl' => ['verify_peer' => true, 'verify_peer_name' => true]]);
        $errno = 0; $errstr = '';
        $fp = @stream_socket_client($esquema . $host . ':' . $puerto, $errno, $errstr, 15, STREAM_CLIENT_CONNECT, $ctx);
        if (!$fp) throw new Exception('No se pudo conectar al servidor de correo: ' . $errstr);
        stream_set_timeout($fp, 15);

        try {
            self::esperar($fp, 220);
            $ehlo = self::cmd($fp, 'EHLO ' . self::hostnameLocal(), 250);

            if ($cif === 'tls') {
                self::cmd($fp, 'STARTTLS', 220);
                $ok = @stream_socket_enable_crypto($fp, true, STREAM_CRYPTO_METHOD_TLS_CLIENT);
                if (!$ok) throw new Exception('No se pudo iniciar el cifrado TLS.');
                $ehlo = self::cmd($fp, 'EHLO ' . self::hostnameLocal(), 250);
            }

            if ($user !== '') {
                self::cmd($fp, 'AUTH LOGIN', 334);
                self::cmd($fp, base64_encode($user), 334);
                self::cmd($fp, base64_encode($pass), 235);
            }

            self::cmd($fp, 'MAIL FROM:<' . $from . '>', 250);
            self::cmd($fp, 'RCPT TO:<' . $para . '>', 250);
            self::cmd($fp, 'DATA', 354);

            $limite = 'sgco-' . bin2hex(random_bytes(8));
            $cab  = 'From: ' . self::encabezado($fromNm) . ' <' . $from . '>' . "\r\n";
            $cab .= 'To: <' . $para . '>' . "\r\n";
            $cab .= 'Subject: ' . self::encabezado($asunto) . "\r\n";
            $cab .= 'Date: ' . date('r') . "\r\n";
            $cab .= 'MIME-Version: 1.0' . "\r\n";
            $cab .= 'Content-Type: multipart/alternative; boundary="' . $limite . '"' . "\r\n\r\n";

            $cuerpo  = '--' . $limite . "\r\n";
            $cuerpo .= 'Content-Type: text/plain; charset=UTF-8' . "\r\n";
            $cuerpo .= 'Content-Transfer-Encoding: base64' . "\r\n\r\n";
            $cuerpo .= chunk_split(base64_encode($texto)) . "\r\n";
            $cuerpo .= '--' . $limite . "\r\n";
            $cuerpo .= 'Content-Type: text/html; charset=UTF-8' . "\r\n";
            $cuerpo .= 'Content-Transfer-Encoding: base64' . "\r\n\r\n";
            $cuerpo .= chunk_split(base64_encode($html)) . "\r\n";
            $cuerpo .= '--' . $limite . '--' . "\r\n";

            $datos = preg_replace('/^\./m', '..', $cab . $cuerpo);
            fwrite($fp, $datos . "\r\n.\r\n");
            self::esperar($fp, 250);
            @fwrite($fp, "QUIT\r\n");
            Database::log('MAIL enviado a=' . $para . ' asunto=' . $asunto);
        } finally {
            if (is_resource($fp)) @fclose($fp);
        }
    }

    private static function hostnameLocal(): string {
        $h = (string)($_SERVER['SERVER_NAME'] ?? 'localhost');
        return preg_match('/^[A-Za-z0-9.\-]+$/', $h) ? $h : 'localhost';
    }

    /** Codifica encabezados con acentos (RFC 2047). */
    private static function encabezado(string $txt): string {
        $txt = str_replace(["\r", "\n"], ' ', $txt);
        if (preg_match('/^[\x20-\x7E]*$/', $txt)) return $txt;
        return '=?UTF-8?B?' . base64_encode($txt) . '?=';
    }

    private static function cmd($fp, string $linea, int $esperado): string {
        fwrite($fp, $linea . "\r\n");
        return self::esperar($fp, $esperado);
    }

    private static function esperar($fp, int $esperado): string {
        $resp = '';
        while (($linea = fgets($fp, 515)) !== false) {
            $resp .= $linea;
            if (strlen($linea) < 4 || $linea[3] !== '-') break;
        }
        $codigo = (int)substr(trim($resp), 0, 3);
        if ($codigo !== $esperado) {
            throw new Exception('El servidor de correo respondió: ' . trim($resp));
        }
        return $resp;
    }
}
