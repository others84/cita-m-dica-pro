<?php
require_once __DIR__ . '/../core/Model.php';
class EspecialidadModel extends Model {
    public static function listar(?int $idClinica = null): array {
        return self::query('EXEC citas.spRegresaEspecialidades @id_CLINICA=:c', [':c'=>$idClinica]);
    }
    public static function alta(string $nombre, int $idClinica): int {
        return self::executeWithOutput('spAltaEspecialidad', [
            '@nombre'=>$nombre, '@id_CLINICA'=>$idClinica, '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, string $nombre, int $idClinica, ?int $idClinicaEsperada = null): void {
        self::execute('EXEC citas.spCambioEspecialidad @id_CATALOGO_ESPECIALIDAD=:id, @nombre=:n, @id_CLINICA=:c, @id_usuario=:u, @id_CLINICA_esperada=:ce',
            [':id'=>$id, ':n'=>$nombre, ':c'=>$idClinica, ':u'=>self::currentUserId(), ':ce'=>$idClinicaEsperada]);
    }
}