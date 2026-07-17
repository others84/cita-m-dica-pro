<?php
require_once __DIR__ . '/../core/Model.php';
class MedicoModel extends Model {
    public static function listar(?int $idClinica = null): array {
        return self::query('EXEC citas.spRegresaMedicos @id_CLINICA=:c', [':c'=>$idClinica]);
    }
    public static function alta(int $idClinica, string $nombre): int {
        return self::executeWithOutput('spAltaMedico', [
            '@id_CLINICA'=>$idClinica,
            '@nombre_completo'=>$nombre,
            '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, int $idClinica, string $nombre): void {
        self::execute('EXEC citas.spCambioMedico @id_MEDICO=:id, @id_CLINICA=:c, @nombre_completo=:n, @id_usuario=:u',
            [':id'=>$id, ':c'=>$idClinica, ':n'=>$nombre, ':u'=>self::currentUserId()]);
    }
    public static function baja(int $id): void { self::execute('EXEC citas.spBajaMedico @id_MEDICO=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
    public static function activa(int $id): void {
        self::execute('EXEC citas.spActivaMedico @id_MEDICO=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]);
    }
    public static function desactiva(int $id): void {
        self::execute('EXEC citas.spDesactivaMedico @id_MEDICO=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]);
    }
    public static function obtener(int $id): ?array {
        $rows = self::query('SELECT m.id_MEDICO, m.nombre_completo, m.activo, c.nombre AS clinica
                               FROM citas.MEDICO m JOIN citas.CLINICA c ON c.id_CLINICA=m.id_CLINICA
                              WHERE m.id_MEDICO=:id', [':id'=>$id]);
        return $rows[0] ?? null;
    }
}