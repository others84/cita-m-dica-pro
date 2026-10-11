<?php
require_once __DIR__ . '/Config.php';

class Database {
    private static ?PDO $pdo = null;
    /** Cuando es true no se escribe nada en app.log (ej. monitor de citas). */
    public static bool $silencioso = false;

    public static function pdo(): PDO {
        if (self::$pdo instanceof PDO) return self::$pdo;

        $server   = Config::get('db.instance', 'localhost');
        $port     = Config::get('db.port', '1433');
        $database = Config::get('db.name', 'CitasMedicas');
        $user     = Config::get('db.user', 'citasadmin');
        $pass     = Config::get('db.password', '');

        $serverWithPort = $server . ',' . $port;

        $dsn = 'sqlsrv:Server=' . $serverWithPort
             . ';Database=' . $database
             . ';Encrypt=no;TrustServerCertificate=false';

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
        if (!is_dir($dir)) @mkdir($dir, 0777, true);
        @file_put_contents($dir . '/app.log',
            '[' . date('Y-m-d H:i:s') . '] ' . $msg . PHP_EOL,
            FILE_APPEND);
    }
}