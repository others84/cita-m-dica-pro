<?php
namespace App\Core;

use PDO;

class Database {
    private static ?PDO $pdo = null;

    public static function conn(): PDO {
        if (self::$pdo) return self::$pdo;
        $server = Config::get('db.instance');
        $port   = Config::get('db.port', '1433');
        $db     = Config::get('db.name');
        $user   = Config::get('db.user');
        $pass   = Config::get('db.password');
        $dsn    = "sqlsrv:Server=$server,$port;Database=$db;TrustServerCertificate=yes";
        self::$pdo = new PDO($dsn, $user, $pass, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
        return self::$pdo;
    }
}
