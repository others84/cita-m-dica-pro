<?php
require_once __DIR__ . '/../core/Model.php';
class PacienteModel extends Model {
    public static function listar(?int $idClinica = null): array {
        return self::query('EXEC citas.spRegresaPacientes @id_CLINICA=:c', [':c'=>$idClinica]);
    }
    private static function nz($v) { $v = is_string($v) ? trim($v) : $v; return ($v === '' || $v === null) ? null : $v; }
    public static function alta(int $idClinica, string $apPat, string $apMat, string $nombre, string $direccion, string $tel, string $email, string $fechaNac, ?int $idGenero, int $idMunicipio): int {
        return self::executeWithOutput('spAltaPaciente', [
            '@id_CLINICA'=>$idClinica, '@ap_paterno'=>$apPat, '@ap_materno'=>self::nz($apMat), '@nombre'=>$nombre,
            '@direccion'=>self::nz($direccion), '@telefono'=>self::nz($tel), '@email'=>self::nz($email), '@fecha_nacimiento'=>self::nz($fechaNac),
            '@id_CATALOGO_GENERO'=>$idGenero ?: null, '@id_CATALOGO_MUNICIPIO'=>$idMunicipio,
            '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, int $idClinica, string $apPat, string $apMat, string $nombre, string $direccion, string $tel, string $email, string $fechaNac, ?int $idGenero, int $idMunicipio): void {
        self::execute('EXEC citas.spCambioPaciente @id_PACIENTE=:id, @id_CLINICA=:c, @ap_paterno=:ap, @ap_materno=:am, @nombre=:n, @direccion=:d, @telefono=:t, @email=:e, @fecha_nacimiento=:f, @id_CATALOGO_GENERO=:g, @id_CATALOGO_MUNICIPIO=:m, @id_usuario=:u', [
            ':id'=>$id, ':c'=>$idClinica, ':ap'=>$apPat, ':am'=>self::nz($apMat), ':n'=>$nombre,
            ':d'=>self::nz($direccion), ':t'=>self::nz($tel), ':e'=>self::nz($email), ':f'=>self::nz($fechaNac), ':g'=>$idGenero ?: null,
            ':m'=>$idMunicipio, ':u'=>self::currentUserId(),
        ]);
    }
    public static function baja(int $id): void { self::execute('EXEC citas.spBajaPaciente @id_PACIENTE=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
}