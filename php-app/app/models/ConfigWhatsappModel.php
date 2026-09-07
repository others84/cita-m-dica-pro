<?php
require_once __DIR__ . '/../core/Model.php';
require_once __DIR__ . '/ConfigCorreoModel.php';

/**
 * Credenciales de WhatsApp Cloud API (Meta). El token permanente se guarda
 * cifrado con AES-256-GCM usando APP_KEY, igual que la contrasena SMTP.
 */
class ConfigWhatsappModel extends Model {

    /** @return array<string,mixed>|null Config con el token ya descifrado. */
    public static function obtener(): ?array {
        $rows = self::query('EXEC citas.spRegresaConfigWhatsapp');
        $row = $rows[0] ?? null;
        if (!$row) return null;
        $row['token'] = ConfigCorreoModel::descifrar((string)($row['token_cifrado'] ?? ''));
        $row['activo'] = (int)($row['activo'] ?? 0);
        return $row;
    }

    /** True cuando hay credenciales completas y la integracion esta activa. */
    public static function disponible(): bool {
        try { $c = self::obtener(); } catch (Throwable $e) { return false; }
        return $c !== null && (int)$c['activo'] === 1
            && trim((string)$c['phone_number_id']) !== '' && trim((string)$c['token']) !== '';
    }

    /** $token vacio conserva el token guardado. */
    public static function guardar(string $phoneNumberId, string $wabaId, string $token, string $apiVersion,
                                   string $plantilla, string $idioma, string $lada, bool $activo): void {
        self::execute(
            'EXEC citas.spGuardaConfigWhatsapp @phone_number_id=:pn, @waba_id=:wa, @token_cifrado=:tk, '
            . '@api_version=:av, @plantilla=:pl, @plantilla_idioma=:pi, @lada_default=:ld, '
            . '@activo=:ac, @id_usuario=:iu',
            [
                ':pn' => $phoneNumberId,
                ':wa' => $wabaId === '' ? null : $wabaId,
                ':tk' => $token === '' ? '' : ConfigCorreoModel::cifrar($token),
                ':av' => $apiVersion,
                ':pl' => $plantilla,
                ':pi' => $idioma,
                ':ld' => $lada,
                ':ac' => $activo ? 1 : 0,
                ':iu' => self::currentUserId(),
            ]
        );
    }
}
