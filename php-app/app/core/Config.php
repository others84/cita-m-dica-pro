<?php
namespace App\Core;

class Config {
    private static array $values = [];

    public static function load(string $file): void {
        if (!file_exists($file)) {
            throw new \RuntimeException("Config no encontrado: $file");
        }
        foreach (file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
            if (str_starts_with(trim($line), '#')) continue;
            [$k, $v] = array_pad(explode('=', $line, 2), 2, '');
            self::$values[trim($k)] = trim($v);
        }
    }

    public static function get(string $key, $default = null) {
        return self::$values[$key] ?? $default;
    }
}
