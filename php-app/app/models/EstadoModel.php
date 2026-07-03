<?php
require_once __DIR__ . '/../core/Model.php';
class EstadoModel extends Model {
    public static function listar(?int $idPais = null): array {
        return self::query('EXEC citas.spRegresaEstados @id_CATALOGO_PAIS=:p', [':p' => $idPais]);
    }
    public static function alta(string $nombre, int $idPais): int {
        return self::executeWithOutput('spAltaEstado', [
            '@nombre'=>$nombre, '@id_CATALOGO_PAIS'=>$idPais, '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, string $nombre, int $idPais): void {
        self::execute('EXEC citas.spCambioEstado @id_CATALOGO_ESTADOS=:id, @nombre=:n, @id_CATALOGO_PAIS=:p, @id_usuario=:u',
            [':id'=>$id, ':n'=>$nombre, ':p'=>$idPais, ':u'=>self::currentUserId()]);
    }
    public static function baja(int $id): void {
        self::execute('EXEC citas.spBajaEstado @id_CATALOGO_ESTADOS=:id, @id_usuario=:u',
            [':id'=>$id, ':u'=>self::currentUserId()]);
    }
}