<?php
require_once __DIR__ . '/../core/Model.php';

/**
 * Dias en los que el medico no da consulta (fechas especificas).
 * Solo limita el agendado desde la pagina publica.
 */
class DiaBloqueadoModel extends Model {

    /** Dias bloqueados del medico. $desde = 'Y-m-d' para ver solo de esa fecha en adelante. */
    public static function porMedico(int $idMedico, ?string $desde = null): array {
        try {
            return self::query(
                'EXEC citas.spRegresaDiasBloqueadosMedico @id_USUARIOS=:u, @desde=:d',
                [':u' => $idMedico, ':d' => ($desde ?: null)]
            );
        } catch (Throwable $e) { return []; }
    }

    /** Solo las fechas ('Y-m-d') bloqueadas del medico, de hoy en adelante. */
    public static function fechasFuturas(int $idMedico): array {
        $out = [];
        foreach (self::porMedico($idMedico, date('Y-m-d')) as $r) {
            $f = $r['fecha'] ?? '';
            if ($f instanceof DateTime) $f = $f->format('Y-m-d');
            $f = substr((string)$f, 0, 10);
            if ($f !== '') $out[] = $f;
        }
        return $out;
    }

    /** True si ese dia esta bloqueado para el medico. */
    public static function bloqueado(int $idMedico, string $fecha): bool {
        foreach (self::porMedico($idMedico, $fecha) as $r) {
            $f = $r['fecha'] ?? '';
            if ($f instanceof DateTime) $f = $f->format('Y-m-d');
            if (substr((string)$f, 0, 10) === $fecha) return true;
        }
        return false;
    }

    /** Guarda un dia (o un rango de dias) bloqueado. Regresa cuantos dias se guardaron. */
    public static function guardar(int $idMedico, string $desde, ?string $hasta, string $motivo): int {
        $ini = strtotime($desde);
        $fin = $hasta ? strtotime($hasta) : $ini;
        if (!$ini || !$fin || $fin < $ini) return 0;
        $n = 0;
        for ($d = $ini; $d <= $fin; $d = strtotime('+1 day', $d)) {
            self::execute(
                'EXEC citas.spGuardaDiaBloqueadoMedico @id_USUARIOS=:u, @fecha=:f, @motivo=:m, @id_usuario=:iu',
                [
                    ':u'  => $idMedico,
                    ':f'  => date('Y-m-d', $d),
                    ':m'  => ($motivo !== '' ? $motivo : null),
                    ':iu' => self::currentUserId(),
                ]
            );
            $n++;
            if ($n > 366) break; // tope de seguridad
        }
        return $n;
    }

    public static function eliminar(int $id): void {
        self::execute(
            'EXEC citas.spBajaDiaBloqueadoMedico @id_DIA_BLOQUEADO_MEDICO=:i, @id_usuario=:iu',
            [':i' => $id, ':iu' => self::currentUserId()]
        );
    }
}

