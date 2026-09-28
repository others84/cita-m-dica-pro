<?php
require_once __DIR__ . '/../core/Model.php';

/** Configuracion del aviso por correo de accesos de administradores. */
class ConfigAvisoAccesoModel extends Model {
    public const VARIABLES = ['@@USUARIO', '@@NOMBRE', '@@ROL', '@@FECHA', '@@HORA', '@@IP', '@@CLINICA'];

    public static function porDefecto(): string {
        return 'Aviso de acceso: el usuario @@USUARIO (@@NOMBRE), rol @@ROL, ingresó al sistema el @@FECHA a las @@HORA desde la IP @@IP.';
    }

    public static function asuntoDefecto(): string {
        return 'Acceso al sistema: @@USUARIO';
    }

    /** @return array<string,mixed>|null */
    public static function obtener(): ?array {
        $rows = self::query('EXEC citas.spRegresaConfigAvisoAcceso');
        return $rows[0] ?? null;
    }

    public static function guardar(string $destinos, string $asunto, string $plantilla, bool $activo): void {
        self::execute(
            'EXEC citas.spGuardaConfigAvisoAcceso @destinos=:d, @asunto=:a, @plantilla=:p, @activo=:ac, @id_usuario=:u',
            [':d' => $destinos, ':a' => $asunto, ':p' => $plantilla, ':ac' => $activo ? 1 : 0, ':u' => self::currentUserId()]
        );
    }

    /** @return string[] correos validos */
    public static function listaDestinos(string $destinos): array {
        $out = [];
        foreach (preg_split('/[,;\s]+/', $destinos) ?: [] as $c) {
            $c = trim($c);
            if ($c !== '') $out[] = $c;
        }
        return array_values(array_unique($out));
    }

    /** Sustituye variables @@ (texto plano, sin escapar). */
    public static function render(string $plantilla, array $datos): string {
        $map = [];
        foreach (self::VARIABLES as $v) $map[$v] = (string)($datos[substr($v, 2)] ?? '');
        return strtr($plantilla, $map);
    }
}
