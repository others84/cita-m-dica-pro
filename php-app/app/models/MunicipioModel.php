<?php
require_once __DIR__ . '/../core/Model.php';
class MunicipioModel extends Model {
    public static function listar(?int $idEstado = null): array {
        return self::query('EXEC citas.spRegresaMunicipios @id_CATALOGO_ESTADOS=:e', [':e' => $idEstado]);
    }
    public static function alta(string $nombre, int $idEstado): int {
        return self::executeWithOutput('spAltaMunicipio', [
            '@nombre'=>$nombre, '@id_CATALOGO_ESTADOS'=>$idEstado, '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, string $nombre, int $idEstado): void {
        self::execute('EXEC citas.spCambioMunicipio @id_CATALOGO_MUNICIPIO=:id, @nombre=:n, @id_CATALOGO_ESTADOS=:e, @id_usuario=:u',
            [':id'=>$id, ':n'=>$nombre, ':e'=>$idEstado, ':u'=>self::currentUserId()]);
    }
}