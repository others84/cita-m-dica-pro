<?php
require_once __DIR__ . '/../core/Model.php';

class UsuarioClinicaModel extends Model {
    /**
     * Regresa las clinicas activas asignadas al usuario.
     * @return array<int,array{id_USUARIOS_CLINICA:int,id_CLINICA:int,nombre:string,activo:int}>
     */
    public static function listarPorUsuario(int $idUsuario): array {
        try {
            return self::query('EXEC citas.spRegresaClinicasUsuario @id_USUARIO=:u', [':u' => $idUsuario]);
        } catch (Throwable $e) {
            Database::log('spRegresaClinicasUsuario ERR: ' . $e->getMessage());
            return [];
        }
    }

    /**
     * Alta de asignacion usuario-clinica. Devuelve id_USUARIOS_CLINICA.
     */
    public static function asigna(int $idUsuario, int $idClinica): int {
        return self::executeWithOutput('spAltaUsuarioClinica', [
            '@id_USUARIOS' => $idUsuario,
            '@id_CLINICA'  => $idClinica,
            '@id_usuario'  => self::currentUserId(),
        ]);
    }

    /**
     * Baja por id_USUARIOS_CLINICA.
     */
    public static function baja(int $idUsuariosClinica): void {
        self::execute('EXEC citas.spBajaUsuarioClinica @id_USUARIOS_CLINICA=:id, @id_usuario=:a',
            [':id' => $idUsuariosClinica, ':a' => self::currentUserId()]);
    }

    /**
     * Helper: baja por par (usuario, clinica) usando el listado.
     */
    public static function remueve(int $idUsuario, int $idClinica): void {
        $rows = self::listarPorUsuario($idUsuario);
        foreach ($rows as $r) {
            if ((int)$r['id_CLINICA'] === $idClinica && isset($r['id_USUARIOS_CLINICA'])) {
                self::baja((int)$r['id_USUARIOS_CLINICA']);
                return;
            }
        }
    }
}