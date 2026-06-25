<?php
class Config {
    private static array $data = [];

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
        return self::$data[$key] ?? $default;
    }
}