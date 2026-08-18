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
             . ';Encrypt=yes;TrustServerCertificate=yes';

        $opciones = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ];
        // La codificacion UTF-8 solo existe si la extension pdo_sqlsrv esta
        // cargada; en otros drivers la constante no esta definida.
        if (defined('PDO::SQLSRV_ATTR_ENCODING') && defined('PDO::SQLSRV_ENCODING_UTF8')) {
            $opciones[constant('PDO::SQLSRV_ATTR_ENCODING')] = constant('PDO::SQLSRV_ENCODING_UTF8');
        }

        if (!in_array('sqlsrv', PDO::getAvailableDrivers(), true)) {
            $msg = 'El driver pdo_sqlsrv no esta habilitado en PHP. '
                 . 'Instale/active php_pdo_sqlsrv y php_sqlsrv (extension=...) y reinicie el servidor web. '
                 . 'Drivers disponibles: ' . implode(', ', PDO::getAvailableDrivers());
            self::log('DB config error: ' . $msg);
            throw new RuntimeException($msg);
        }

        try {
            self::$pdo = new PDO($dsn, $user, $pass, $opciones);
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