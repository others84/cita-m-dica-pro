<?php
require_once __DIR__ . '/../core/Model.php';

class RolModel extends Model {
    public static function listar(): array { return self::query('EXEC citas.spRegresaRoles'); }
    public static function alta(string $nombre, ?string $desc): int {
        return self::executeWithOutput('spAltaRol', [
            '@nombre' => $nombre, '@descripcion' => $desc, '@id_usuario' => self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, string $nombre, ?string $desc): void {
        self::execute('EXEC citas.spCambioRol @id_ROLES=:id, @nombre=:n, @descripcion=:d, @id_usuario=:u',
            [':id'=>$id, ':n'=>$nombre, ':d'=>$desc, ':u'=>self::currentUserId()]);
    }
    public static function baja(int $id): void {
        self::execute('EXEC citas.spBajaRol @id_ROLES=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]);
    }
    public static function activa(int $id): void {
        self::execute('EXEC citas.spActivaRol @id_ROLES=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]);
    }
    public static function desactiva(int $id): void {
        self::execute('EXEC citas.spDesactivaRol @id_ROLES=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]);
    }
}