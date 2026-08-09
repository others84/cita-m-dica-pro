<?php
require_once __DIR__ . '/../core/Model.php';

class UsuarioClinicaModel extends Model {
    /**
     * Regresa las clinicas activas asignadas al usuario.
     * @return array<int,array{id_USUARIOS_CLINICA:int,id_CLINICA:int,nombre:string,activo:int}>
     */
    public static function listarPorUsuario(int $idUsuario): array {
        try {
            $rows = self::query('EXEC citas.spRegresaClinicasUsuario @id_USUARIO=:u', [':u' => $idUsuario]);
            Database::log(sprintf(
                'spRegresaClinicasUsuario user=%d rows=%d ids=[%s]',
                $idUsuario, count($rows),
                implode(',', array_map(fn($r) => (int)($r['id_CLINICA'] ?? 0), $rows))
            ));
            return $rows;
        } catch (Throwable $e) {
            Database::log('spRegresaClinicasUsuario ERR: ' . $e->getMessage());
            return [];
        }
    }

    /**
     * Alta de asignacion usuario-clinica. Devuelve id_USUARIOS_CLINICA.
     */
    public static function asigna(int $idUsuario, int $idClinica): int {
        $base = [
            '@id_USUARIOS' => $idUsuario,
            '@id_CLINICA'  => $idClinica,
            '@id_usuario'  => self::currentUserId(),
        ];
        $actor = (string)($_SESSION['user']['nombre_completo'] ?? $_SESSION['user']['usuario'] ?? '');
        try {
            return self::executeWithOutput('spAltaUsuarioClinica', $base + ['@actor' => $actor !== '' ? $actor : null]);
        } catch (Throwable $e) {
            if (strpos($e->getMessage(), 'too many arguments') === false) throw $e;
            return self::executeWithOutput('spAltaUsuarioClinica', $base);
        }
    }

    /**
     * Baja por id_USUARIOS_CLINICA.
     */
    public static function baja(int $idUsuariosClinica): void {
        $actor = (string)($_SESSION['user']['nombre_completo'] ?? $_SESSION['user']['usuario'] ?? '');
        try {
            self::execute('EXEC citas.spBajaUsuarioClinica @id_USUARIOS_CLINICA=:id, @id_usuario=:a, @actor=:n',
                [':id' => $idUsuariosClinica, ':a' => self::currentUserId(), ':n' => $actor !== '' ? $actor : null]);
            return;
        } catch (Throwable $e) {
            if (strpos($e->getMessage(), 'too many arguments') === false) throw $e;
        }
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