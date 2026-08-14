<?php
require_once __DIR__ . '/../core/Model.php';
class ConsultorioModel extends Model {
    public static function listar(?int $idClinica = null): array {
        $rows = self::query('EXEC citas.spRegresaConsultorios');
        if ($idClinica !== null) {
            $rows = array_values(array_filter($rows, function($r) use ($idClinica) {
                return (int)($r['id_CLINICA'] ?? 0) === $idClinica;
            }));
        }
        return $rows;
    }
    public static function alta(int $idClinica, string $nombre): int {
        return self::executeWithOutput('spAltaConsultorio', [
            '@id_CLINICA'=>$idClinica, '@nombre'=>$nombre, '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, int $idClinica, string $nombre, ?int $idClinicaEsperada = null): void {
        self::execute('EXEC citas.spCambioConsultorio @id_CONSULTORIO=:id, @id_CLINICA=:c, @nombre=:n, @id_usuario=:u, @id_CLINICA_esperada=:ce',
            [':id'=>$id, ':c'=>$idClinica, ':n'=>$nombre, ':u'=>self::currentUserId(), ':ce'=>$idClinicaEsperada]);
    }
    public static function baja(int $id, ?int $idClinicaEsperada = null): void {
        self::execute('EXEC citas.spBajaConsultorio @id_CONSULTORIO=:id, @id_usuario=:u, @id_CLINICA_esperada=:ce',
            [':id'=>$id, ':u'=>self::currentUserId(), ':ce'=>$idClinicaEsperada]);
    }
}