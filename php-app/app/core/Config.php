<?php
class Config {
    private static array $data = [];
    /** Mapa clave de properties -> variable de entorno equivalente. */
    private const ENV_MAP = [
        'db.instance' => 'DB_INSTANCE',
        'db.name'     => 'DB_NAME',
        'db.user'     => 'DB_USER',
        'db.password' => 'DB_PASSWORD',
        'db.port'     => 'DB_PORT',
    ];

    /**
     * Carga un archivo .env (KEY=VALOR por linea) a las variables de entorno.
     * No sobreescribe variables ya definidas por el servidor.
     */
    public static function loadEnv(string $file): void {
        if (!is_file($file) || !is_readable($file)) return;
        foreach (file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
            $line = trim($line);
            if ($line === '' || str_starts_with($line, '#')) continue;
            [$k, $v] = array_pad(explode('=', $line, 2), 2, '');
            $k = trim($k);
            $v = trim($v);
            if ($k === '') continue;
            // Permite comillas alrededor del valor.
            if (strlen($v) >= 2 && (($v[0] === '"' && $v[-1] === '"') || ($v[0] === "'" && $v[-1] === "'"))) {
                $v = substr($v, 1, -1);
            }
            if (getenv($k) === false && !isset($_ENV[$k]) && !isset($_SERVER[$k])) {
                putenv($k . '=' . $v);
                $_ENV[$k] = $v;
            }
        }
    }

    /** Lee una variable de entorno desde cualquiera de las fuentes disponibles. */
    private static function env(string $name) {
        $v = $_ENV[$name] ?? $_SERVER[$name] ?? getenv($name);
        return ($v === false || $v === null || $v === '') ? null : $v;
    }

    public static function load(string $file): void {
        if (!file_exists($file)) return;
        foreach (file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
            $line = trim($line);
            if ($line === '' || str_starts_with($line, '#')) continue;
            [$k, $v] = array_pad(explode('=', $line, 2), 2, '');
            self::$data[trim($k)] = trim($v);
        }
    }

    public static function get(string $key, $default = null) {
        // 1) Variable de entorno equivalente (produccion / .env)
        $envName = self::ENV_MAP[$key] ?? strtoupper(str_replace('.', '_', $key));
        $env = self::env($envName);
        if ($env !== null) return $env;
        // 2) Archivo config.properties (respaldo local)
        return self::$data[$key] ?? $default;
    }
}