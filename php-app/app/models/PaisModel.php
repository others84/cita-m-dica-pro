<?php
require_once __DIR__ . '/../core/Model.php';
class PaisModel extends Model {
    public static function listar(): array {
        Database::log('PaisModel::listar -> EXEC citas.spRegresaPaises');
        return self::query('EXEC citas.spRegresaPaises');
    }
    public static function alta(string $nombre): int {
        $uid = self::currentUserId();
        Database::log("PaisModel::alta INICIO nombre='{$nombre}' id_usuario={$uid}");
        try {
            $id = self::executeWithOutput('spAltaPais', ['@nombre'=>$nombre, '@id_usuario'=>$uid]);
            Database::log("PaisModel::alta OK id_nuevo={$id}");
            return $id;
        } catch (Throwable $e) {
            Database::log('PaisModel::alta ERROR ' . $e->getMessage());
            throw $e;
        }
    }
    public static function cambio(int $id, string $nombre): void {
        $uid = self::currentUserId();
        Database::log("PaisModel::cambio INICIO id={$id} nombre='{$nombre}' id_usuario={$uid}");
        try {
            self::execute('EXEC citas.spCambioPais @id_CATALOGO_PAIS=:id, @nombre=:n, @id_usuario=:u',
                [':id'=>$id, ':n'=>$nombre, ':u'=>$uid]);
            Database::log("PaisModel::cambio OK id={$id}");
        } catch (Throwable $e) {
            Database::log('PaisModel::cambio ERROR ' . $e->getMessage());
            throw $e;
        }
    }
    public static function baja(int $id): void {
        self::execute('EXEC citas.spBajaPais @id_CATALOGO_PAIS=:id, @id_usuario=:u',
            [':id'=>$id, ':u'=>self::currentUserId()]);
    }
}