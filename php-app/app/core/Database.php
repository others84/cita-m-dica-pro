<?php
require_once __DIR__ . '/Config.php';

class Database {
    private static ?PDO $pdo = null;
    /** Cuando es true no se escribe nada en app.log (ej. monitor de citas). */
    public static bool $silencioso = false;

    public static function pdo(): PDO {
        if (self::$pdo instanceof PDO) return self::$pdo;

        $server   = Config::get('db.instance', 'localhost');
        $port     = Config::get('db.port', '14330');
        $database = Config::get('db.name', 'CitasMedicas');
        $user     = Config::get('db.user', 'citasadmin');
        $pass     = Config::get('db.password', '');

        $serverWithPort = $server . ',' . $port;

        $dsn = 'sqlsrv:Server=' . $serverWithPort
             . ';Database=' . $database
             . ';Encrypt=yes;TrustServerCertificate=yes';

        try {
            self::$pdo = new PDO($dsn, $user, $pass, [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
            ]);
        } catch (Throwable $e) {
            self::log('DB connect error: ' . $e->getMessage());
            throw $e;
        }

        return self::$pdo;
    }

    public static function log(string $msg): void {
        if (self::$silencioso) return;
        $dir = __DIR__ . '/../../storage/logs';
        if (!is_dir($dir)) @mkdir($dir, 0755, true);
        $hoy = date('Y-m-d');
        @file_put_contents($dir . '/app-' . $hoy . '.log',
            '[' . date('Y-m-d H:i:s') . '] ' . $msg . PHP_EOL,
            FILE_APPEND);
        self::purgarLogs($dir, $hoy);
    }

    /**
     * Elimina los archivos app-YYYY-MM-DD.log mas antiguos que la retencion
     * configurada (LOG_RETENTION_DAYS, 30 dias por defecto).
     * Solo se ejecuta una vez por dia y por proceso.
     */
    private static ?string $purgaHecha = null;
    private static function purgarLogs(string $dir, string $hoy): void {
        if (self::$purgaHecha === $hoy) return;
        self::$purgaHecha = $hoy;
        $dias = (int)(Config::get('log.retention_days', 30));
        if ($dias <= 0) $dias = 30;
        $limite = time() - ($dias * 86400);
        foreach (glob($dir . '/app-*.log') ?: [] as $f) {
            $mt = @filemtime($f);
            if ($mt !== false && $mt < $limite) @unlink($f);
        }
    }
}
