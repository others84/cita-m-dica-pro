<?php
require_once __DIR__ . '/../core/Model.php';
class MedicoModel extends Model {
    public static function listar(?int $idClinica = null): array {
        return self::query('EXEC citas.spRegresaMedicos @id_CLINICA=:c', [':c'=>$idClinica]);
    }
    public static function alta(string $nombre): int {
        return self::executeWithOutput('spAltaMedico', ['@nombre_completo'=>$nombre, '@id_usuario'=>self::currentUserId()]);
    }
    public static function cambio(int $id, string $nombre): void {
        self::execute('EXEC citas.spCambioMedico @id_MEDICO=:id, @nombre_completo=:n, @id_usuario=:u',
            [':id'=>$id, ':n'=>$nombre, ':u'=>self::currentUserId()]);
    }
    public static function baja(int $id): void { self::execute('EXEC citas.spBajaMedico @id_MEDICO=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
}