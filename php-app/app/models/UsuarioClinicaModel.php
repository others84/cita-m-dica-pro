<?php
require_once __DIR__ . '/../core/Model.php';

class UsuarioClinicaModel extends Model {
    /**
     * Regresa las clinicas activas asignadas al usuario.
     * @return array<int,array{id_CLINICA:int,nombre:string,activo:int}>
     */
    public static function listarPorUsuario(int $idUsuario): array {
        try {
            return self::query('EXEC citas.spRegresaClinicasUsuario @id_USUARIO=:u', [':u' => $idUsuario]);
        } catch (Throwable $e) {
            Database::log('spRegresaClinicasUsuario ERR: ' . $e->getMessage());
            return [];
        }
    }

    public static function asigna(int $idUsuario, int $idClinica): void {
        self::execute('EXEC citas.spAsignaUsuarioClinica @id_USUARIO=:u, @id_CLINICA=:c, @id_usuario=:a',
            [':u' => $idUsuario, ':c' => $idClinica, ':a' => self::currentUserId()]);
    }

    public static function remueve(int $idUsuario, int $idClinica): void {
        self::execute('EXEC citas.spRemueveUsuarioClinica @id_USUARIO=:u, @id_CLINICA=:c, @id_usuario=:a',
            [':u' => $idUsuario, ':c' => $idClinica, ':a' => self::currentUserId()]);
    }
}