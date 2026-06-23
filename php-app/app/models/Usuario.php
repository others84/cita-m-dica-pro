<?php
namespace App\Models;

use App\Core\Database;

class Usuario {
    public static function autenticar(string $usuario, string $password): ?array {
        $sql = "SELECT u.id_usuario, u.usuario, u.nombre, r.nombre AS rol
                FROM Usuarios u JOIN Roles r ON r.id_rol = u.id_rol
                WHERE u.usuario = ? AND u.password = ? AND u.activo = 1";
        $st = Database::conn()->prepare($sql);
        $st->execute([$usuario, $password]);
        $row = $st->fetch();
        return $row ?: null;
    }
}
