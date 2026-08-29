<?php
require_once __DIR__ . '/../core/Model.php';

/**
 * Horario de atencion por medico (inicio de consultas, comida y termino).
 * Solo limita el agendado desde la pagina publica.
 */
class HorarioMedicoModel extends Model {

    /** Horario usado cuando el medico aun no captura el suyo. */
    public static function porDefecto(): array {
        return [
            'hora_inicio'   => '07:00',
            'comida_inicio' => '',
            'comida_fin'    => '',
            'hora_fin'      => '21:00',
            'default'       => true,
        ];
    }

    private static function normaliza(array $r): array {
        $h = fn($v) => substr((string)($v ?? ''), 0, 5);
        return [
            'hora_inicio'   => $h($r['hora_inicio'])   ?: '07:00',
            'comida_inicio' => $h($r['comida_inicio']),
            'comida_fin'    => $h($r['comida_fin']),
            'hora_fin'      => $h($r['hora_fin'])      ?: '21:00',
            'default'       => false,
        ];
    }

    /** Horario del medico; si no existe (o falla la consulta) regresa el de por defecto. */
    public static function porMedico(int $idMedico): array {
        try {
            $rows = self::query('EXEC citas.spRegresaHorarioMedico @id_USUARIOS=:u', [':u' => $idMedico]);
        } catch (Throwable $e) {
            return self::porDefecto();
        }
        foreach ($rows as $r) {
            if ((int)($r['id_USUARIOS'] ?? 0) === $idMedico) return self::normaliza($r);
        }
        return self::porDefecto();
    }

    /** Todos los horarios capturados, indexados por id_USUARIOS. */
    public static function todos(): array {
        $out = [];
        try { $rows = self::query('EXEC citas.spRegresaHorarioMedico'); }
        catch (Throwable $e) { return []; }
        foreach ($rows as $r) {
            $out[(int)($r['id_USUARIOS'] ?? 0)] = self::normaliza($r);
        }
        return $out;
    }

    public static function guardar(int $idMedico, string $horaInicio, ?string $comidaInicio,
                                   ?string $comidaFin, string $horaFin): void {
        self::execute(
            'EXEC citas.spGuardaHorarioMedico @id_USUARIOS=:u, @hora_inicio=:hi, '
            . '@comida_inicio=:ci, @comida_fin=:cf, @hora_fin=:hf, @id_usuario=:iu',
            [
                ':u'  => $idMedico,
                ':hi' => $horaInicio,
                ':ci' => ($comidaInicio ?: null),
                ':cf' => ($comidaFin ?: null),
                ':hf' => $horaFin,
                ':iu' => self::currentUserId(),
            ]
        );
    }
}
