<?php
require_once __DIR__ . '/../core/Model.php';
class ClinicaModel extends Model {
    public const ESQUEMAS = [
        'SOLO_CONSULTORIO' => ['label' => 'SOLO-CONSULTORIO', 'asistentes' => 1, 'medicos' => 1, 'admins' => 1],
        'SOLO_CLINICA'     => ['label' => 'SOLO-CLINICA',     'asistentes' => 2, 'medicos' => 5, 'admins' => 1],
    ];

    public static function listar(): array { return self::query('EXEC citas.spRegresaClinicas'); }

    public static function alta(string $nombre, string $direccion, string $email, string $tel, int $idMunicipio,
                                string $esquema = 'SOLO_CLINICA', int $maxAsis = 2, int $maxMed = 5, int $maxAdm = 1): int {
        return self::executeWithOutput('spAltaClinica', [
            '@nombre'=>$nombre, '@direccion'=>$direccion, '@email'=>$email, '@telefono'=>$tel,
            '@id_CATALOGO_MUNICIPIO'=>$idMunicipio,
            '@id_usuario'=>self::currentUserId(),
            '@esquema'=>$esquema, '@max_asistentes'=>$maxAsis, '@max_medicos'=>$maxMed, '@max_admins'=>$maxAdm,
        ]);
    }
    public static function cambio(int $id, string $nombre, string $direccion, string $email, string $tel, int $idMunicipio,
                                  ?string $esquema = null, ?int $maxAsis = null, ?int $maxMed = null, ?int $maxAdm = null): void {
        self::execute('EXEC citas.spCambioClinica @id_CLINICA=:id, @nombre=:n, @direccion=:d, @email=:e, @telefono=:t, '
            . '@id_CATALOGO_MUNICIPIO=:m, @id_usuario=:u, @esquema=:sq, @max_asistentes=:ma, @max_medicos=:mm, @max_admins=:md',
            [':id'=>$id, ':n'=>$nombre, ':d'=>$direccion, ':e'=>$email, ':t'=>$tel, ':m'=>$idMunicipio,
             ':u'=>self::currentUserId(), ':sq'=>$esquema, ':ma'=>$maxAsis, ':mm'=>$maxMed, ':md'=>$maxAdm]);
    }
    public static function baja(int $id): void { self::execute('EXEC citas.spBajaClinica @id_CLINICA=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
    public static function activa(int $id): void {
        self::execute('EXEC citas.spActivaClinica @id_CLINICA=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]);
    }
    public static function desactiva(int $id): void {
        self::execute('EXEC citas.spDesactivaClinica @id_CLINICA=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]);
    }

    /** Devuelve el renglon de la clinica (con esquema y limites) o null. */
    public static function obtener(int $id): ?array {
        foreach (self::listar() as $c) if ((int)$c['id_CLINICA'] === $id) return $c;
        return null;
    }

    /** Clave de limite ('asistentes'|'medicos'|'admins') a partir del nombre del rol. */
    public static function claveRol(string $rolNombre): ?string {
        $r = strtolower($rolNombre);
        if (strpos($r, 'sistema') !== false) return null;
        if (strpos($r, 'asistente') !== false) return 'asistentes';
        if (strpos($r, 'medic') !== false || strpos($r, 'médic') !== false) return 'medicos';
        if (strpos($r, 'administrador') !== false) return 'admins';
        return null;
    }

    /**
     * Usuarios ACTIVOS por tipo asignados a la clinica.
     * @return array{asistentes:int,medicos:int,admins:int}
     */
    public static function conteoUsuarios(int $idClinica): array {
        require_once __DIR__ . '/UsuarioModel.php';
        $out = ['asistentes'=>0, 'medicos'=>0, 'admins'=>0];
        $vistos = [];
        foreach (UsuarioModel::listar() as $u) {
            if ((int)($u['id_CLINICA'] ?? 0) !== $idClinica) continue;
            if ((int)($u['activo'] ?? 1) !== 1) continue;
            $idU = (int)($u['id_USUARIOS'] ?? 0);
            if ($idU <= 0 || isset($vistos[$idU])) continue;
            $vistos[$idU] = true;
            $k = self::claveRol((string)($u['rol'] ?? ''));
            if ($k !== null) $out[$k]++;
        }
        return $out;
    }

    /** @return array{esquema:string,asistentes:int,medicos:int,admins:int} */
    public static function limites(int $idClinica): array {
        $c = self::obtener($idClinica);
        $esq = (string)($c['esquema'] ?? 'SOLO_CLINICA');
        $def = self::ESQUEMAS[$esq] ?? self::ESQUEMAS['SOLO_CLINICA'];
        return [
            'esquema'    => $esq,
            'asistentes' => (int)($c['max_asistentes'] ?? $def['asistentes']),
            'medicos'    => (int)($c['max_medicos']    ?? $def['medicos']),
            'admins'     => (int)($c['max_admins']     ?? $def['admins']),
        ];
    }

    /** true si aun hay cupo para un usuario de ese rol en la clinica. */
    public static function hayCupo(int $idClinica, string $rolNombre, ?int $idUsuarioExcluir = null): bool {
        $k = self::claveRol($rolNombre);
        if ($k === null) return true;
        $lim = self::limites($idClinica);
        $act = self::conteoUsuarios($idClinica)[$k];
        if ($idUsuarioExcluir !== null && self::usuarioAsignadoActivo($idClinica, $idUsuarioExcluir)) $act--;
        return $act < $lim[$k];
    }

    private static function usuarioAsignadoActivo(int $idClinica, int $idUsuario): bool {
        require_once __DIR__ . '/UsuarioModel.php';
        foreach (UsuarioModel::listar() as $u) {
            if ((int)($u['id_USUARIOS'] ?? 0) === $idUsuario
                && (int)($u['id_CLINICA'] ?? 0) === $idClinica
                && (int)($u['activo'] ?? 1) === 1) return true;
        }
        return false;
    }

    /** Lanza RuntimeException con mensaje amigable si no hay cupo. */
    public static function validaCupo(int $idClinica, string $rolNombre, ?int $idUsuarioExcluir = null): void {
        if (self::hayCupo($idClinica, $rolNombre, $idUsuarioExcluir)) return;
        $k   = self::claveRol($rolNombre);
        $lim = self::limites($idClinica);
        $esq = self::ESQUEMAS[$lim['esquema']]['label'] ?? $lim['esquema'];
        throw new RuntimeException(sprintf(
            'La clinica "%s" (esquema %s) ya alcanzo el maximo de %d usuario(s) con perfil %s. '
            . 'Ajuste los limites desde Administrador de Sistema.',
            self::nombre($idClinica), $esq, $lim[$k], $rolNombre
        ));
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