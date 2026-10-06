<?php
require_once __DIR__ . '/../core/Model.php';
class CitaModel extends Model {
    public static function listar(?int $idMedico = null, ?string $desde = null, ?string $hasta = null, ?int $idClinica = null): array {
        $rows = self::query(
            'EXEC citas.spRegresaCitas @id_MEDICO=:m, @id_CLINICA=:c, @fecha_desde=:d, @fecha_hasta=:h',
            [':m'=>$idMedico, ':c'=>$idClinica, ':d'=>$desde, ':h'=>$hasta]
        );
        $mapa = self::esperaMap();
        foreach ($rows as &$r) {
            $id = (int)($r['id_CITA'] ?? 0);
            $r['en_espera'] = isset($mapa[$id]) ? 1 : 0;
            $r['fecha_en_espera'] = $mapa[$id] ?? null;
        }
        unset($r);
        return $rows;
    }

    /** [id_CITA => 'Y-m-d H:i:s'] de las citas marcadas en espera (vacio si falta el parche). */
    public static function esperaMap(): array {
        $out = [];
        try {
            foreach (self::query('EXEC citas.spRegresaCitasEspera') as $r) {
                $f = $r['fecha_en_espera'] ?? '';
                if ($f instanceof DateTime) $f = $f->format('Y-m-d H:i:s');
                $out[(int)$r['id_CITA']] = substr((string)$f, 0, 19);
            }
        } catch (Throwable $e) { /* parche aun no aplicado */ }
        return $out;
    }

    /** Marca (1) o quita (0) la cita de la lista de espera. */
    public static function marcaEspera(int $id, bool $enEspera): void {
        self::execute('EXEC citas.spMarcaCitaEspera @id_CITA=:id, @en_espera=:e, @id_usuario=:u',
            [':id'=>$id, ':e'=>$enEspera ? 1 : 0, ':u'=>self::currentUserId()]);
    }

    /** Estado activo (agendada / confirmada). */
    public static function estadoActivo(array $c): bool {
        $e = strtr(mb_strtolower(trim((string)($c['estado'] ?? ''))), ['á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u']);
        return strpos($e, 'agendad') !== false || strpos($e, 'confirmad') !== false;
    }

    /** Citas en espera, activas y a futuro; ordenadas por quien lo pidio primero. */
    public static function enEspera(?int $idMedico = null, ?int $idClinica = null): array {
        $hoy = substr(self::ahoraSql(), 0, 10);
        $rows = self::listar($idMedico, $hoy, date('Y-m-d', strtotime('+365 days')), $idClinica);
        $rows = array_values(array_filter($rows, function ($c) use ($idMedico) {
            if ((int)($c['en_espera'] ?? 0) !== 1 || !self::estadoActivo($c)) return false;
            return $idMedico === null || (int)($c['id_MEDICO'] ?? 0) === $idMedico;
        }));
        usort($rows, fn($a, $b) => strcmp((string)$a['fecha_en_espera'], (string)$b['fecha_en_espera']));
        return $rows;
    }

    /**
     * Horarios libres del medico desde ahora hasta antes de la cita dada,
     * con la misma duracion. Regresa ['Y-m-d' => ['HH:MM', ...]].
     */
    public static function horariosLibres(array $c, int $maxDias = 60): array {
        require_once __DIR__ . '/HorarioMedicoModel.php';
        require_once __DIR__ . '/DiaBloqueadoModel.php';
        $fmt = fn($v, string $f) => $v instanceof DateTime ? $v->format($f) : (string)$v;
        $idMed = (int)$c['id_MEDICO'];
        $fCita = substr($fmt($c['fecha_cita'], 'Y-m-d'), 0, 10);
        $hiCita = substr($fmt($c['hora_inicio'], 'H:i'), 0, 5);
        $hfCita = substr($fmt($c['hora_fin'], 'H:i'), 0, 5);
        $min = fn(string $h) => (int)substr($h, 0, 2) * 60 + (int)substr($h, 3, 2);
        $dur = max(15, $min($hfCita) - $min($hiCita));
        $inicioCita = strtotime($fCita . ' ' . $hiCita);

        $ahora = self::ahoraSql();
        $hoy = substr($ahora, 0, 10);
        $ahoraTs = strtotime($ahora);
        $hasta = min($fCita, date('Y-m-d', strtotime($hoy . " +$maxDias days")));

        $h = HorarioMedicoModel::porMedico($idMed);
        $hIni = $min($h['hora_inicio']); $hFin = $min($h['hora_fin']);
        $cIni = $h['comida_inicio'] !== '' ? $min($h['comida_inicio']) : null;
        $cFin = $h['comida_fin'] !== '' ? $min($h['comida_fin']) : null;
        $bloq = array_flip(DiaBloqueadoModel::fechasFuturas($idMed));

        // Citas ocupadas del medico en el rango.
        $ocup = [];
        foreach (self::listar($idMed, $hoy, $hasta, null) as $o) {
            if ((int)($o['id_MEDICO'] ?? 0) !== $idMed || (int)$o['id_CITA'] === (int)$c['id_CITA']) continue;
            if (!self::estadoActivo($o)) continue;
            $of = substr($fmt($o['fecha_cita'], 'Y-m-d'), 0, 10);
            $ocup[$of][] = [$min(substr($fmt($o['hora_inicio'], 'H:i'), 0, 5)), $min(substr($fmt($o['hora_fin'], 'H:i'), 0, 5))];
        }

        $out = [];
        for ($d = strtotime($hoy); date('Y-m-d', $d) <= $hasta; $d = strtotime('+1 day', $d)) {
            $dia = date('Y-m-d', $d);
            if (isset($bloq[$dia])) continue;
            for ($t = $hIni; $t + $dur <= $hFin; $t += 30) {
                $ts = strtotime($dia) + $t * 60;
                if ($ts <= $ahoraTs || $ts >= $inicioCita) continue;
                if ($cIni !== null && $cFin !== null && $t < $cFin && $t + $dur > $cIni) continue;
                $libre = true;
                foreach ($ocup[$dia] ?? [] as [$a, $b]) {
                    if ($t < $b && $t + $dur > $a) { $libre = false; break; }
                }
                if ($libre) $out[$dia][] = sprintf('%02d:%02d', intdiv($t, 60), $t % 60);
            }
        }
        return $out;
    }
    public static function alta(array $d): int {
        return self::executeWithOutput('spAltaCita', [
            '@id_PACIENTE'=>$d['id_PACIENTE'],
            '@fecha_cita'=>$d['fecha_cita'], '@hora_inicio'=>$d['hora_inicio'], '@hora_fin'=>$d['hora_fin'],
            '@id_CATALOGO_ESTADO_CITAS'=>$d['id_CATALOGO_ESTADO_CITAS'],
            '@observaciones'=>$d['observaciones'] ?? '',
            '@horas_anticipacion_notif'=>$d['horas_anticipacion_notif'] ?? 24,
            '@precio'=>$d['precio'] ?? 0,
            '@id_MEDICO'=>$d['id_MEDICO'],
            '@id_CATALOGO_ESPECIALIDAD'=>$d['id_CATALOGO_ESPECIALIDAD'],
            '@id_CONSULTORIO'=>$d['id_CONSULTORIO'],
            '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, array $d): void {
        self::execute('EXEC citas.spCambioCita @id_CITA=:id, @id_PACIENTE=:p, @fecha_cita=:f, @hora_inicio=:hi, @hora_fin=:hf, @id_CATALOGO_ESTADO_CITAS=:es, @observaciones=:ob, @horas_anticipacion_notif=:ha, @precio=:pr, @id_MEDICO=:m, @id_CATALOGO_ESPECIALIDAD=:e, @id_CONSULTORIO=:co, @id_usuario=:u', [
            ':id'=>$id, ':p'=>$d['id_PACIENTE'], ':f'=>$d['fecha_cita'],
            ':hi'=>$d['hora_inicio'], ':hf'=>$d['hora_fin'],
            ':es'=>$d['id_CATALOGO_ESTADO_CITAS'], ':ob'=>$d['observaciones'] ?? '',
            ':ha'=>$d['horas_anticipacion_notif'] ?? 24, ':pr'=>$d['precio'] ?? 0,
            ':m'=>$d['id_MEDICO'], ':e'=>$d['id_CATALOGO_ESPECIALIDAD'],
            ':co'=>$d['id_CONSULTORIO'], ':u'=>self::currentUserId(),
        ]);
    }
    /** Borrado definitivo de la cita (spBajaCita). */
    public static function baja(int $id): void {
        self::execute('EXEC citas.spBajaCita @id_CITA=:id, @id_usuario=:u',
            [':id'=>$id, ':u'=>self::currentUserId()]);
    }
    public static function cancela(int $id, int $idEstado): void {
        self::execute('EXEC citas.spCancelaCita @id_CITA=:id, @id_CATALOGO_ESTADO_CITAS=:e, @id_usuario=:u',
            [':id'=>$id, ':e'=>$idEstado, ':u'=>self::currentUserId()]);
    }
    /** Marca la cita como notificada (notificado = 1). */
    public static function notifica(int $id, ?string $usuario = null): void {
        try {
            self::execute('EXEC citas.spNotificaCita @id_CITA=:id, @id_usuario=:u, @usuario=:us',
                [':id'=>$id, ':u'=>self::currentUserId(), ':us'=>$usuario]);
        } catch (Throwable $e) {
            // La base aun tiene la version anterior del SP (sin @usuario): reintenta.
            if (strpos($e->getMessage(), 'too many arguments') === false) throw $e;
            self::execute('EXEC citas.spNotificaCita @id_CITA=:id, @id_usuario=:u',
                [':id'=>$id, ':u'=>self::currentUserId()]);
        }
    }
    /** Fecha/hora actual de SQL Server ('Y-m-d H:i:s'); si falla usa el reloj de PHP. */
    public static function ahoraSql(): string {
        try {
            $r = self::query("SELECT CONVERT(varchar(19), GETDATE(), 120) AS ahora");
            $v = (string)($r[0]['ahora'] ?? '');
            if (preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/', $v)) return $v;
        } catch (Throwable $e) { /* respaldo */ }
        return date('Y-m-d H:i:s');
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
        // Mismo rango que la tabla de "Citas registradas" para que el contador
        // del menu coincida exactamente con las filas resaltadas.
        $desde = date('Y-m-d', strtotime('-30 days'));
        $hasta = date('Y-m-d', strtotime('+90 days'));
        $rows = self::listar($idMedico, $desde, $hasta, $idClinica);
        if ($idMedico !== null) {
            $rows = array_values(array_filter($rows, fn($c) => (int)($c['id_MEDICO'] ?? 0) === $idMedico));
        }
        return array_values(array_filter($rows, fn($c) => self::enVentanaNotificacion($c)));
    }
}