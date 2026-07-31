<?php
require_once __DIR__ . '/../core/Model.php';
class CitaModel extends Model {
    public static function listar(?int $idMedico = null, ?string $desde = null, ?string $hasta = null, ?int $idClinica = null): array {
        return self::query(
            'EXEC citas.spRegresaCitas @id_MEDICO=:m, @id_CLINICA=:c, @fecha_desde=:d, @fecha_hasta=:h',
            [':m'=>$idMedico, ':c'=>$idClinica, ':d'=>$desde, ':h'=>$hasta]
        );
    }
    public static function alta(array $d): int {
        // (ver obtener() abajo)
        $noop = null;
        return self::executeWithOutput('spAltaCita', [
            '@id_PACIENTE'=>$d['id_PACIENTE'],
            '@fecha_cita'=>$d['fecha_cita'], '@hora_inicio'=>$d['hora_inicio'], '@hora_fin'=>$d['hora_fin'],
            '@id_CATALOGO_ESTADO_CITAS'=>$d['id_CATALOGO_ESTADO_CITAS'],
            '@observaciones'=>$d['observaciones'] ?? '',
            '@notifica_email'=>$d['notifica_email'] ?? 0, '@notifica_wa'=>$d['notifica_wa'] ?? 0,
            '@horas_anticipacion_notif'=>$d['horas_anticipacion_notif'] ?? 24,
            '@precio'=>$d['precio'] ?? 0,
            '@id_MEDICO'=>$d['id_MEDICO'],
            '@id_CATALOGO_ESPECIALIDAD'=>$d['id_CATALOGO_ESPECIALIDAD'],
            '@id_CONSULTORIO'=>$d['id_CONSULTORIO'],
            '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, array $d): void {
        self::execute('EXEC citas.spCambioCita @id_CITA=:id, @id_PACIENTE=:p, @fecha_cita=:f, @hora_inicio=:hi, @hora_fin=:hf, @id_CATALOGO_ESTADO_CITAS=:es, @observaciones=:ob, @notifica_email=:ne, @notifica_wa=:nw, @horas_anticipacion_notif=:ha, @precio=:pr, @id_MEDICO=:m, @id_CATALOGO_ESPECIALIDAD=:e, @id_CONSULTORIO=:co, @id_usuario=:u', [
            ':id'=>$id, ':p'=>$d['id_PACIENTE'], ':f'=>$d['fecha_cita'],
            ':hi'=>$d['hora_inicio'], ':hf'=>$d['hora_fin'],
            ':es'=>$d['id_CATALOGO_ESTADO_CITAS'], ':ob'=>$d['observaciones'] ?? '',
            ':ne'=>$d['notifica_email'] ?? 0, ':nw'=>$d['notifica_wa'] ?? 0,
            ':ha'=>$d['horas_anticipacion_notif'] ?? 24, ':pr'=>$d['precio'] ?? 0,
            ':m'=>$d['id_MEDICO'], ':e'=>$d['id_CATALOGO_ESPECIALIDAD'],
            ':co'=>$d['id_CONSULTORIO'], ':u'=>self::currentUserId(),
        ]);
    }
    public static function cancela(int $id, int $idEstado): void {
        self::execute('EXEC citas.spCancelaCita @id_CITA=:id, @id_CATALOGO_ESTADO_CITAS=:e, @id_usuario=:u',
            [':id'=>$id, ':e'=>$idEstado, ':u'=>self::currentUserId()]);
    }
}