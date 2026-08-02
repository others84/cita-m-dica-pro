<?php
require_once __DIR__ . '/../core/Model.php';

class LogModel extends Model {
    /** Registra en citas.LOG el cambio de estatus de una cita. */
    public static function estadoCita(int $idCita, ?string $estadoAnterior, string $estadoNuevo,
                                      ?int $idClinica, ?string $clinica, ?string $usuario): void {
        self::execute(
            'EXEC citas.spLogEstadoCita @id_CITA=:c, @estado_anterior=:ea, @estado_nuevo=:en, '
            . '@id_CLINICA=:cl, @clinica=:cn, @usuario=:us, @id_usuario=:u',
            [
                ':c'  => $idCita,
                ':ea' => $estadoAnterior,
                ':en' => $estadoNuevo,
                ':cl' => $idClinica,
                ':cn' => $clinica,
                ':us' => $usuario,
                ':u'  => self::currentUserId(),
            ]
        );
    }
}
