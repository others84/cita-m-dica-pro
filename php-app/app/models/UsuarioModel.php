<?php
require_once __DIR__ . '/../core/Model.php';

class UsuarioModel extends Model {
    public static function login(string $usuario, string $password): ?array {
        $rows = self::query(
            'EXEC citas.spLoginUsuario @usuario=:u, @password=:p',
            [':u' => $usuario, ':p' => $password]
        );
        return $rows[0] ?? null;
    }

    public static function listar(): array {
        return self::query('EXEC citas.spRegresaUsuarios');
    }

    public static function alta(int $idRol, ?int $idClinica, string $usuario, string $password, string $nombre, ?string $email): int {
        return self::executeWithOutput('spAltaUsuario', [
            '@id_ROLES'        => $idRol,
            '@id_CLINICA'      => $idClinica,
            '@usuario'         => $usuario,
            '@password'        => $password,
            '@nombre_completo' => $nombre,
            '@email'           => $email,
            '@id_usuario'      => self::currentUserId(),
        ]);
    }

    public static function cambio(int $id, int $idRol, ?int $idClinica, string $nombre, ?string $email): void {
        self::execute('EXEC citas.spCambioUsuario @id_USUARIOS=:id, @id_ROLES=:r, @id_CLINICA=:c, @nombre_completo=:n, @email=:e, @id_usuario=:u', [
            ':id' => $id, ':r' => $idRol, ':c' => $idClinica, ':n' => $nombre, ':e' => $email, ':u' => self::currentUserId(),
        ]);
    }

    public static function cambioPassword(int $id, string $password): void {
        self::execute('EXEC citas.spCambioPassword @id_USUARIOS=:id, @password=:p, @id_usuario=:u',
            [':id' => $id, ':p' => $password, ':u' => self::currentUserId()]);
    }

    public static function baja(int $id): void {
        self::execute('EXEC citas.spBajaUsuario @id_USUARIOS=:id, @id_usuario=:u', [':id' => $id, ':u' => self::currentUserId()]);
    }
    public static function activa(int $id): void {
        self::execute('EXEC citas.spActivaUsuario @id_USUARIOS=:id, @id_usuario=:u', [':id' => $id, ':u' => self::currentUserId()]);
    }
    public static function desactiva(int $id): void {
        self::execute('EXEC citas.spDesactivaUsuario @id_USUARIOS=:id, @id_usuario=:u', [':id' => $id, ':u' => self::currentUserId()]);
    }
}