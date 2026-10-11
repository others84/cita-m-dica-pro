<?php
require_once __DIR__ . '/../core/Model.php';

/**
 * Texto de notificacion de WhatsApp por medico. Las variables se escriben
 * con el prefijo @@ (@@CLINICA, @@MEDICO, @@PACIENTE, @@ESPECIALIDAD,
 * @@CONSULTORIO, @@FECHA, @@HORA) y se sustituyen al enviar el mensaje.
 */
class MensajeMedicoModel extends Model {

    public const MAX = 1000;

    /** Variables permitidas (orden de sustitucion: las mas largas primero). */
    public static function variables(): array {
        return [
            '@@ESPECIALIDAD' => 'Especialidad de la cita',
            '@@CONSULTORIO'  => 'Consultorio asignado',
            '@@PACIENTE'     => 'Nombre del paciente',
            '@@CLINICA'      => 'Nombre de la clínica',
            '@@MEDICO'       => 'Nombre del médico',
            '@@FECHA'        => 'Fecha de la cita (dd/mm/aaaa)',
            '@@HORA'         => 'Hora de inicio (hh:mm)',
        ];
    }

    /** Texto usado cuando el medico aun no define el suyo. */
    public static function porDefecto(): string {
        return 'Estimado @@PACIENTE, su cita en la clinica @@CLINICA con el medico @@MEDICO'
             . ' con la especialidad @@ESPECIALIDAD el dia @@FECHA a la hora @@HORA.'
             . ' Favor de confirmar por este medio';
    }

    /** Texto del medico; si no existe (o falla la consulta) regresa el de por defecto. */
    public static function porMedico(int $idMedico): string {
        if ($idMedico <= 0) return self::porDefecto();
        try {
            $rows = self::query('EXEC citas.spRegresaMensajeMedico @id_USUARIOS=:u', [':u' => $idMedico]);
        } catch (Throwable $e) {
            return self::porDefecto();
        }
        foreach ($rows as $r) {
            $t = trim((string)($r['plantilla'] ?? ''));
            if ((int)($r['id_USUARIOS'] ?? 0) === $idMedico && $t !== '') return $t;
        }
        return self::porDefecto();
    }

    /** Todos los textos capturados, indexados por id_USUARIOS. */
    public static function todos(): array {
        $out = [];
        try { $rows = self::query('EXEC citas.spRegresaMensajeMedico'); }
        catch (Throwable $e) { return []; }
        foreach ($rows as $r) {
            $t = trim((string)($r['plantilla'] ?? ''));
            if ($t !== '') $out[(int)($r['id_USUARIOS'] ?? 0)] = $t;
        }
        return $out;
    }

    public static function guardar(int $idMedico, string $plantilla): void {
        self::execute(
            'EXEC citas.spGuardaMensajeMedico @id_USUARIOS=:u, @plantilla=:p, @id_usuario=:iu',
            [
                ':u'  => $idMedico,
                ':p'  => mb_substr(trim($plantilla), 0, self::MAX),
                ':iu' => self::currentUserId(),
            ]
        );
    }

    /**
     * Sustituye las variables @@ con los datos de la cita.
     * Las variables no reconocidas se dejan tal cual.
     * @param array<string,mixed> $c Renglon de cita.
     */
    public static function aplicar(string $plantilla, array $c): string {
        $f = $c['fecha_cita'] instanceof DateTime
            ? $c['fecha_cita']->format('d/m/Y')
            : date('d/m/Y', strtotime(substr((string)($c['fecha_cita'] ?? ''), 0, 10)) ?: time());
        $hi = $c['hora_inicio'] instanceof DateTime
            ? $c['hora_inicio']->format('H:i')
            : substr((string)($c['hora_inicio'] ?? ''), 0, 5);

        $map = [
            '@@ESPECIALIDAD' => trim((string)($c['especialidad'] ?? '')),
            '@@CONSULTORIO'  => trim((string)($c['consultorio'] ?? '')),
            '@@PACIENTE'     => trim((string)($c['paciente'] ?? '')),
            '@@CLINICA'      => trim((string)($c['clinica'] ?? '')),
            '@@MEDICO'       => trim((string)($c['medico'] ?? '')),
            '@@FECHA'        => $f,
            '@@HORA'         => $hi,
        ];
        return strtr($plantilla, $map);
    }
}

