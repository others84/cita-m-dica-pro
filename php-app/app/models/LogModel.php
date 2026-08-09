<?php
require_once __DIR__ . '/../core/Model.php';

class LogModel extends Model {
    /** Registra en citas.LOG el cambio de estatus de una cita. */
    public static function estadoCita(int $idCita, ?string $estadoAnterior, string $estadoNuevo,
                                      ?int $idClinica, ?string $clinica, ?string $usuario,
                                      ?string $medico = null, ?string $paciente = null,
                                      ?string $especialidad = null, ?string $consultorio = null): void {
        $base = [
            ':c'  => $idCita,
            ':ea' => $estadoAnterior,
            ':en' => $estadoNuevo,
            ':cl' => $idClinica,
            ':cn' => $clinica,
            ':us' => $usuario,
            ':u'  => self::currentUserId(),
        ];
        try {
            self::execute(
                'EXEC citas.spLogEstadoCita @id_CITA=:c, @estado_anterior=:ea, @estado_nuevo=:en, '
                . '@id_CLINICA=:cl, @clinica=:cn, @usuario=:us, @medico=:me, @paciente=:pa, '
                . '@especialidad=:es, @consultorio=:co, @id_usuario=:u',
                $base + [':me' => $medico, ':pa' => $paciente, ':es' => $especialidad, ':co' => $consultorio]
            );
            return;
        } catch (Throwable $e) {
            // La base aun tiene la version anterior del SP: reintenta sin los extras.
            if (strpos($e->getMessage(), 'too many arguments') === false) throw $e;
        }
        self::execute(
            'EXEC citas.spLogEstadoCita @id_CITA=:c, @estado_anterior=:ea, @estado_nuevo=:en, '
            . '@id_CLINICA=:cl, @clinica=:cn, @usuario=:us, @id_usuario=:u',
            $base
        );
    }
}
