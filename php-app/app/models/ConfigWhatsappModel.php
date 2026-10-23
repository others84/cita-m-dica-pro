<?php
require_once __DIR__ . '/../core/Model.php';
require_once __DIR__ . '/ConfigCorreoModel.php';

/**
 * Configuracion exclusiva de Evolution API, separada de los datos de Meta.
 * La API Key se cifra con AES-256-GCM usando APP_KEY.
 */
class ConfigWhatsappModel extends Model {

    /** @return array<string,mixed>|null Config con la API Key ya descifrada. */
    public static function obtener(): ?array {
        $rows = self::query('EXEC citas.spRegresaConfigWhatsappEvolution');
        $row = $rows[0] ?? null;
        if (!$row) return null;
        $row['api_key'] = ConfigCorreoModel::descifrar((string)($row['api_key_cifrada'] ?? ''));
        $row['activo'] = (int)($row['activo'] ?? 0);
        return $row;
    }

    /** True cuando hay credenciales completas y la integracion esta activa. */
    public static function disponible(): bool {
        try { $c = self::obtener(); } catch (Throwable $e) { return false; }
        return $c !== null && (int)$c['activo'] === 1
            && trim((string)$c['api_url']) !== '' && trim((string)$c['instancia']) !== ''
            && trim((string)$c['api_key']) !== '';
    }

    /** API Key vacia conserva la clave guardada. */
    public static function guardar(string $apiUrl, string $instancia, string $apiKey, string $lada, bool $activo): void {
        self::execute(
            'EXEC citas.spGuardaConfigWhatsappEvolution @api_url=:url, @instancia=:ins, @api_key_cifrada=:key, '
            . '@lada_default=:ld, '
            . '@activo=:ac, @id_usuario=:iu',
            [
                ':url' => $apiUrl,
                ':ins' => $instancia,
                ':key' => $apiKey === '' ? '' : ConfigCorreoModel::cifrar($apiKey),
                ':ld' => $lada,
                ':ac' => $activo ? 1 : 0,
                ':iu' => self::currentUserId(),
            ]
        );
    }
}
