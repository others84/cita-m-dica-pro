<?php
require_once __DIR__ . '/../core/Model.php';
class ConsultorioModel extends Model {
    public static function listar(?int $idClinica = null): array {
        return self::query('EXEC citas.spRegresaConsultorios @id_CLINICA=:c', [':c'=>$idClinica]);
    }
    public static function alta(int $idClinica, string $nombre): int {
        return self::executeWithOutput('spAltaConsultorio', [
            '@id_CLINICA'=>$idClinica, '@nombre'=>$nombre, '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, int $idClinica, string $nombre): void {
        self::execute('EXEC citas.spCambioConsultorio @id_CONSULTORIO=:id, @id_CLINICA=:c, @nombre=:n, @id_usuario=:u',
            [':id'=>$id, ':c'=>$idClinica, ':n'=>$nombre, ':u'=>self::currentUserId()]);
    }
    public static function baja(int $id): void { self::execute('EXEC citas.spBajaConsultorio @id_CONSULTORIO=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
}