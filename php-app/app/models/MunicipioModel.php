<?php
require_once __DIR__ . '/../core/Model.php';
class MunicipioModel extends Model {
    public static function listar(?int $idEstado = null): array {
        return self::query('EXEC citas.spRegresaMunicipios @id_CATALOGO_ESTADOS=:e', [':e' => $idEstado]);
    }
}