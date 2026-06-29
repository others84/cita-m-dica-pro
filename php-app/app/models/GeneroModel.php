<?php
require_once __DIR__ . '/../core/Model.php';
class GeneroModel extends Model {
    public static function listar(): array { return self::query('EXEC citas.spRegresaGeneros'); }
    public static function alta(string $nombre): int {
        return self::executeWithOutput('spAltaGenero', ['@nombre'=>$nombre, '@id_usuario'=>self::currentUserId()]);
    }
    public static function cambio(int $id, string $nombre): void {
        self::execute('EXEC citas.spCambioGenero @id_CATALOGO_GENERO=:id, @nombre=:n, @id_usuario=:u',
            [':id'=>$id, ':n'=>$nombre, ':u'=>self::currentUserId()]);
    }
}