<?php
require_once __DIR__ . '/../core/Model.php';
class EspecialidadModel extends Model {
    public static function listar(?int $idClinica = null): array {
        return self::query('EXEC citas.spRegresaEspecialidades @id_CLINICA=:c', [':c'=>$idClinica]);
    }
    public static function alta(string $nombre): int {
        return self::executeWithOutput('spAltaEspecialidad', ['@nombre'=>$nombre, '@id_usuario'=>self::currentUserId()]);
    }
    public static function cambio(int $id, string $nombre): void {
        self::execute('EXEC citas.spCambioEspecialidad @id_CATALOGO_ESPECIALIDAD=:id, @nombre=:n, @id_usuario=:u',
            [':id'=>$id, ':n'=>$nombre, ':u'=>self::currentUserId()]);
    }
}