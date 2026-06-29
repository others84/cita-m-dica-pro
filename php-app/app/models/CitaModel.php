<?php
require_once __DIR__ . '/../core/Model.php';
class CitaModel extends Model {
    public static function listar(?int $idMedico = null, ?string $desde = null, ?string $hasta = null): array {
        return self::query(
            'EXEC citas.spRegresaCitas @id_MEDICO=:m, @fecha_desde=:d, @fecha_hasta=:h',
            [':m'=>$idMedico, ':d'=>$desde, ':h'=>$hasta]
        );
    }
    public static function alta(array $d): int {
        return self::executeWithOutput('spAltaCita', [
            '@id_PACIENTE'=>$d['id_PACIENTE'], '@id_MEDICO'=>$d['id_MEDICO'],
            '@id_CONSULTORIO'=>$d['id_CONSULTORIO'], '@id_CATALOGO_ESPECIALIDAD'=>$d['id_CATALOGO_ESPECIALIDAD'],
            '@fecha_cita'=>$d['fecha_cita'], '@hora_inicio'=>$d['hora_inicio'], '@hora_fin'=>$d['hora_fin'],
            '@id_CATALOGO_ESTADO_CITAS'=>$d['id_CATALOGO_ESTADO_CITAS'],
            '@observaciones'=>$d['observaciones'] ?? null,
            '@notifica_email'=>$d['notifica_email'] ?? 0, '@notifica_wa'=>$d['notifica_wa'] ?? 0,
            '@email_notif'=>$d['email_notif'] ?? null, '@celular_notif'=>$d['celular_notif'] ?? null,
            '@horas_anticipacion_notif'=>$d['horas_anticipacion_notif'] ?? 24,
            '@precio'=>$d['precio'] ?? 0,
            '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, array $d): void {
        self::execute('EXEC citas.spCambioCita @id_CITA=:id, @id_PACIENTE=:p, @id_MEDICO=:m, @id_CONSULTORIO=:co, @id_CATALOGO_ESPECIALIDAD=:e, @fecha_cita=:f, @hora_inicio=:hi, @hora_fin=:hf, @id_CATALOGO_ESTADO_CITAS=:es, @observaciones=:ob, @notifica_email=:ne, @notifica_wa=:nw, @email_notif=:em, @celular_notif=:cel, @horas_anticipacion_notif=:ha, @precio=:pr, @id_usuario=:u', [
            ':id'=>$id, ':p'=>$d['id_PACIENTE'], ':m'=>$d['id_MEDICO'], ':co'=>$d['id_CONSULTORIO'],
            ':e'=>$d['id_CATALOGO_ESPECIALIDAD'], ':f'=>$d['fecha_cita'], ':hi'=>$d['hora_inicio'], ':hf'=>$d['hora_fin'],
            ':es'=>$d['id_CATALOGO_ESTADO_CITAS'], ':ob'=>$d['observaciones'] ?? null,
            ':ne'=>$d['notifica_email'] ?? 0, ':nw'=>$d['notifica_wa'] ?? 0,
            ':em'=>$d['email_notif'] ?? null, ':cel'=>$d['celular_notif'] ?? null,
            ':ha'=>$d['horas_anticipacion_notif'] ?? 24, ':pr'=>$d['precio'] ?? 0,
            ':u'=>self::currentUserId(),
        ]);
    }
    public static function cancela(int $id, int $idEstado): void {
        self::execute('EXEC citas.spCancelaCita @id_CITA=:id, @id_CATALOGO_ESTADO_CITAS=:e, @id_usuario=:u',
            [':id'=>$id, ':e'=>$idEstado, ':u'=>self::currentUserId()]);
    }
}