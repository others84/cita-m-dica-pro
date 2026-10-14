<?php
require_once __DIR__ . '/../core/Model.php';

class UsuarioModel extends Model {
    public static function login(string $usuario, string $password): ?array {
        try {
            $pdo  = Database::pdo();
            $stmt = $pdo->prepare('{call citas.spLoginUsuario(?, ?)}');
            $stmt->bindValue(1, $usuario, PDO::PARAM_STR);
            $stmt->bindValue(2, $password, PDO::PARAM_STR);
            $stmt->execute();
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            Database::log('login intento usuario=' . $usuario . ' resultado=' . ($row ? 'OK' : 'NO_MATCH'));
            return $row ?: null;
        } catch (Throwable $e) {
            Database::log('login EXC usuario=' . $usuario . ' err=' . $e->getMessage());
            throw $e;
        }
    }

    /** true si el usuario ya cerro la ventana de bienvenida (o si el parche aun no existe). */
    public static function bienvenidaVista(int $id): bool {
        try {
            $r = self::query('EXEC citas.spBienvenidaVista @id_USUARIOS=:id', [':id' => $id]);
            return !empty($r[0]['vista']);
        } catch (Throwable $e) {
            return true;
        }
    }

    public static function marcarBienvenidaVista(int $id): void {
        self::execute('EXEC citas.spMarcarBienvenidaVista @id_USUARIOS=:id', [':id' => $id]);
    }

    public static function listar(): array {
        return self::query('EXEC citas.spRegresaUsuarios');
    }

    /**
     * Usuarios activos con perfil "medico" asignados a la clinica indicada.
     * Se deduplica por id_USUARIOS (spRegresaUsuarios devuelve una fila por clinica).
     * @return array<int,array<string,mixed>>
     */
    public static function listarMedicos(?int $idClinica = null): array {
        $out = [];
        foreach (self::listar() as $u) {
            $rol = strtolower((string)($u['rol'] ?? ''));
            if (strpos($rol, 'medico') === false && strpos($rol, 'médico') === false) continue;
            if ((int)($u['activo'] ?? 1) !== 1) continue;
            if ($idClinica !== null && (int)($u['id_CLINICA'] ?? 0) !== (int)$idClinica) continue;
            $id = (int)($u['id_USUARIOS'] ?? 0);
            if ($id <= 0 || isset($out[$id])) continue;
            $out[$id] = $u;
        }
        $rows = array_values($out);
        usort($rows, fn($a, $b) => strcasecmp((string)($a['nombre_completo'] ?? ''), (string)($b['nombre_completo'] ?? '')));
        return $rows;
    }

    public static function alta(int $idRol, ?int $idClinica, string $usuario, string $password, string $nombre, string $email): int {
        $idNuevo = self::executeWithOutput('spAltaUsuario', [
            '@id_ROLES'        => $idRol,
            '@usuario'         => $usuario,
            '@password'        => $password,
            '@nombre_completo' => $nombre,
            '@email'           => $email,
            '@id_usuario'      => self::currentUserId(),
        ]);
        if ($idClinica) {
            self::executeWithOutput('spAltaUsuarioClinica', [
                '@id_USUARIOS' => $idNuevo,
                '@id_CLINICA'  => $idClinica,
                '@id_usuario'  => self::currentUserId(),
            ]);
        }
        return $idNuevo;
    }

    public static function cambio(int $id, int $idRol, ?int $idClinica, string $nombre, string $email): void {
        self::execute('EXEC citas.spCambioUsuario @id_USUARIOS=:id, @id_ROLES=:r, @nombre_completo=:n, @email=:e, @id_usuario=:u', [
            ':id' => $id, ':r' => $idRol, ':n' => $nombre, ':e' => $email, ':u' => self::currentUserId(),
        ]);
        // La relacion con clinica se mantiene via spAltaUsuarioClinica / spBajaUsuarioClinica.
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

    /**
     * Usuario GENERICO (rol asistente) usado por la pagina publica de citas.
     * Devuelve ['id_USUARIOS'=>int,'usuario'=>string,'clinicas'=>int[]] o null.
     */
    public static function generico(): ?array {
        $id = 0; $nombre = 'GENERICO'; $clinicas = []; $rol = '';
        foreach (self::listar() as $u) {
            if (strcasecmp(trim((string)($u['usuario'] ?? '')), 'GENERICO') !== 0) continue;
            if ((int)($u['activo'] ?? 1) !== 1) continue;
            $id  = (int)($u['id_USUARIOS'] ?? 0);
            $rol = strtolower((string)($u['rol'] ?? ''));
            $nombre = (string)($u['nombre_completo'] ?? 'GENERICO');
            $cl = (int)($u['id_CLINICA'] ?? 0);
            if ($cl > 0) $clinicas[$cl] = $cl;
        }
        if ($id <= 0) return null;
        return ['id_USUARIOS'=>$id, 'usuario'=>'GENERICO', 'nombre'=>$nombre, 'rol'=>$rol, 'clinicas'=>array_values($clinicas)];
    }
}
