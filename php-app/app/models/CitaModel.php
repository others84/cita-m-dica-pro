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
    /** Marca la cita como notificada (notificado = 1). */
    public static function notifica(int $id, ?string $usuario = null): void {
        self::execute('EXEC citas.spNotificaCita @id_CITA=:id, @id_usuario=:u, @usuario=:us',
            [':id'=>$id, ':u'=>self::currentUserId(), ':us'=>$usuario]);
    }
    /** Regresa una cita puntual (sin filtro de clinica ni de fechas). */
    public static function obtener(int $id): ?array {
        foreach (self::listar() as $r) {
            if ((int)($r['id_CITA'] ?? 0) === $id) return $r;
        }
        return null;
    }

    /**
     * Indica si la cita ya entro en su ventana de anticipacion:
     * (hora_inicio - horas_anticipacion) <= ahora <= hora_inicio,
     * la cita sigue agendada y todavia no se ha notificado.
     */
    public static function enVentanaNotificacion(array $c, ?int $ahora = null): bool {
        if ((int)($c['notificado'] ?? 0) === 1) return false;
        $estado = strtolower(trim((string)($c['estado'] ?? '')));
        $estado = strtr($estado, ['á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u']);
        if (strpos($estado, 'agendada') === false && strpos($estado, 'agendado') === false) return false;

        $f  = $c['fecha_cita']  instanceof DateTime ? $c['fecha_cita']->format('Y-m-d')  : substr((string)$c['fecha_cita'], 0, 10);
        $hi = $c['hora_inicio'] instanceof DateTime ? $c['hora_inicio']->format('H:i:s') : substr((string)$c['hora_inicio'], 0, 8);
        if ($f === '' || $hi === '') return false;
        $inicio = strtotime($f . ' ' . $hi);
        if ($inicio === false) return false;

        $horas = (int)($c['horas_anticipacion_notif'] ?? 0);
        if ($horas <= 0) $horas = 24;
        // (fecha+hora de inicio) - horas de anticipacion <= hora del sistema
        $desde = $inicio - ($horas * 3600);
        $ahora = $ahora ?? time();
        return $desde <= $ahora;
    }

    /** Citas (de la clinica/medico dados) que ya estan en su ventana de notificacion. */
    public static function porNotificar(?int $idMedico = null, ?int $idClinica = null): array {
        $desde = date('Y-m-d', strtotime('-1 day'));
        $hasta = date('Y-m-d', strtotime('+30 days'));
        $rows = self::listar($idMedico, $desde, $hasta, $idClinica);
        if ($idMedico !== null) {
            $rows = array_values(array_filter($rows, fn($c) => (int)($c['id_MEDICO'] ?? 0) === $idMedico));
        }
        return array_values(array_filter($rows, fn($c) => self::enVentanaNotificacion($c)));
    }
}