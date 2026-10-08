<?php
require_once __DIR__ . '/../core/Model.php';

/** Padecimientos que atiende cada medico, con su precio. */
class PadecimientoModel extends Model {

    public static function porMedico(int $idMedico, bool $soloActivos = false): array {
        if ($idMedico <= 0) return [];
        try {
            return self::query('EXEC citas.spRegresaPadecimientos @id_MEDICO=:m, @solo_activos=:a',
                [':m' => $idMedico, ':a' => $soloActivos ? 1 : 0]);
        } catch (Throwable $e) { return []; }
    }

    /** Activos de varios medicos: [id_medico => [ {id, nombre, precio}, ... ]]. */
    public static function activosPorMedicos(array $medicos): array {
        $out = [];
        foreach ($medicos as $m) {
            $id = (int)($m['id_USUARIOS'] ?? 0);
            if ($id <= 0) continue;
            foreach (self::porMedico($id, true) as $p) {
                $out[$id][] = ['id' => (int)$p['id_PADECIMIENTO'], 'nombre' => (string)$p['nombre'], 'precio' => (float)$p['precio']];
            }
        }
        return $out;
    }

    public static function alta(int $idMedico, string $nombre, float $precio): int {
        return self::executeWithOutput('spAltaPadecimiento', [
            'id_MEDICO' => $idMedico, 'nombre' => $nombre, 'precio' => $precio, 'id_usuario' => self::currentUserId(),
        ]);
    }

    public static function cambio(int $id, string $nombre, float $precio, bool $activo): void {
        self::execute('EXEC citas.spCambioPadecimiento @id_PADECIMIENTO=:i, @nombre=:n, @precio=:p, @activo=:a, @id_usuario=:u',
            [':i' => $id, ':n' => $nombre, ':p' => $precio, ':a' => $activo ? 1 : 0, ':u' => self::currentUserId()]);
    }

    /** Reemplaza los padecimientos de la cita (solo acepta los del medico de la cita). */
    public static function guardarEnCita(int $idCita, array $ids): void {
        $ids = array_values(array_unique(array_filter(array_map('intval', $ids), fn($v) => $v > 0)));
        self::execute('EXEC citas.spGuardaPadecimientosCita @id_CITA=:c, @ids=:i, @id_usuario=:u',
            [':c' => $idCita, ':i' => implode(',', $ids), ':u' => self::currentUserId()]);
    }

    public static function deCita(int $idCita): array {
        try { return self::query('EXEC citas.spRegresaPadecimientosCita @id_CITA=:c', [':c' => $idCita]); }
        catch (Throwable $e) { return []; }
    }

    /** [id_CITA => "A, B"] para listados. */
    public static function textoPorCita(?int $idMedico = null): array {
        $out = [];
        try {
            foreach (self::query('EXEC citas.spRegresaPadecimientosCitas @id_MEDICO=:m', [':m' => $idMedico]) as $r) {
                $out[(int)$r['id_CITA']] = (string)$r['padecimientos'];
            }
        } catch (Throwable $e) {}
        return $out;
    }

    /** Suma de precios de los ids indicados que pertenecen al medico. */
    public static function suma(int $idMedico, array $ids): float {
        $ids = array_map('intval', $ids);
        $t = 0.0;
        foreach (self::porMedico($idMedico, false) as $p) {
            if (in_array((int)$p['id_PADECIMIENTO'], $ids, true)) $t += (float)$p['precio'];
        }
        return $t;
    }
}
