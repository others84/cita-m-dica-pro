<?php
require_once __DIR__ . '/../core/Model.php';
class ClinicaModel extends Model {
    public static function listar(): array { return self::query('EXEC citas.spRegresaClinicas'); }
    public static function alta(string $nombre, string $direccion, string $email, string $tel, int $idMunicipio): int {
        return self::executeWithOutput('spAltaClinica', [
            '@nombre'=>$nombre, '@direccion'=>$direccion, '@email'=>$email, '@telefono'=>$tel,
            '@id_CATALOGO_MUNICIPIO'=>$idMunicipio,
            '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, string $nombre, string $direccion, string $email, string $tel, int $idMunicipio): void {
        self::execute('EXEC citas.spCambioClinica @id_CLINICA=:id, @nombre=:n, @direccion=:d, @email=:e, @telefono=:t, @id_CATALOGO_MUNICIPIO=:m, @id_usuario=:u',
            [':id'=>$id, ':n'=>$nombre, ':d'=>$direccion, ':e'=>$email, ':t'=>$tel, ':m'=>$idMunicipio, ':u'=>self::currentUserId()]);
    }
    public static function baja(int $id): void { self::execute('EXEC citas.spBajaClinica @id_CLINICA=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
}