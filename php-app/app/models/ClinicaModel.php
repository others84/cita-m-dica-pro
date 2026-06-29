<?php
require_once __DIR__ . '/../core/Model.php';
class ClinicaModel extends Model {
    public static function listar(): array { return self::query('EXEC citas.spRegresaClinicas'); }
    public static function alta(string $nombre, string $direccion, ?string $email, ?string $tel, string $municipio, int $idEstado): int {
        return self::executeWithOutput('spAltaClinica', [
            '@nombre'=>$nombre, '@direccion'=>$direccion, '@email'=>$email, '@telefono'=>$tel,
            '@municipio'=>$municipio, '@id_CATALOGO_ESTADOS'=>$idEstado,
            '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, string $nombre, string $direccion, ?string $email, ?string $tel, string $municipio, int $idEstado): void {
        self::execute('EXEC citas.spCambioClinica @id_CLINICA=:id, @nombre=:n, @direccion=:d, @email=:e, @telefono=:t, @municipio=:m, @id_CATALOGO_ESTADOS=:es, @id_usuario=:u',
            [':id'=>$id, ':n'=>$nombre, ':d'=>$direccion, ':e'=>$email, ':t'=>$tel, ':m'=>$municipio, ':es'=>$idEstado, ':u'=>self::currentUserId()]);
    }
    public static function baja(int $id): void { self::execute('EXEC citas.spBajaClinica @id_CLINICA=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
    public static function activa(int $id): void { self::execute('EXEC citas.spActivaClinica @id_CLINICA=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
    public static function desactiva(int $id): void { self::execute('EXEC citas.spDesactivaClinica @id_CLINICA=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
}