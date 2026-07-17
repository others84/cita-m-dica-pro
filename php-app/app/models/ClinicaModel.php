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
    public static function activa(int $id): void {
        self::execute('EXEC citas.spActivaClinica @id_CLINICA=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]);
    }
    public static function desactiva(int $id): void {
        self::execute('EXEC citas.spDesactivaClinica @id_CLINICA=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]);
    }
    public static function resumen(): array {
        return self::query('EXEC citas.spRegresaClinicasResumen');
    }
    public static function estaActiva(int $id): bool {
        $rows = self::query('SELECT activo FROM citas.CLINICA WHERE id_CLINICA=:id', [':id'=>$id]);
        return !empty($rows) && (int)$rows[0]['activo'] === 1;
    }
    public static function nombre(int $id): string {
        $rows = self::query('SELECT nombre FROM citas.CLINICA WHERE id_CLINICA=:id', [':id'=>$id]);
        return $rows[0]['nombre'] ?? '?';
    }
}