<?php
require_once __DIR__ . '/../core/Model.php';
class PacienteModel extends Model {
    public static function listar(?int $idClinica = null): array {
        return self::query('EXEC citas.spRegresaPacientes @id_CLINICA=:c', [':c'=>$idClinica]);
    }
    public static function alta(int $idClinica, string $apPat, string $apMat, string $nombre, string $direccion, string $tel, string $email, string $fechaNac, int $idGenero, int $idMunicipio): int {
        return self::executeWithOutput('spAltaPaciente', [
            '@id_CLINICA'=>$idClinica, '@ap_paterno'=>$apPat, '@ap_materno'=>$apMat, '@nombre'=>$nombre,
            '@direccion'=>$direccion, '@telefono'=>$tel, '@email'=>$email, '@fecha_nacimiento'=>$fechaNac,
            '@id_CATALOGO_GENERO'=>$idGenero, '@id_CATALOGO_MUNICIPIO'=>$idMunicipio,
            '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, int $idClinica, string $apPat, string $apMat, string $nombre, string $direccion, string $tel, string $email, string $fechaNac, int $idGenero, int $idMunicipio): void {
        self::execute('EXEC citas.spCambioPaciente @id_PACIENTE=:id, @id_CLINICA=:c, @ap_paterno=:ap, @ap_materno=:am, @nombre=:n, @direccion=:d, @telefono=:t, @email=:e, @fecha_nacimiento=:f, @id_CATALOGO_GENERO=:g, @id_CATALOGO_MUNICIPIO=:m, @id_usuario=:u', [
            ':id'=>$id, ':c'=>$idClinica, ':ap'=>$apPat, ':am'=>$apMat, ':n'=>$nombre,
            ':d'=>$direccion, ':t'=>$tel, ':e'=>$email, ':f'=>$fechaNac, ':g'=>$idGenero,
            ':m'=>$idMunicipio, ':u'=>self::currentUserId(),
        ]);
    }
    public static function baja(int $id): void { self::execute('EXEC citas.spBajaPaciente @id_PACIENTE=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
}