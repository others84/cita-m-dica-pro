<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/CitaModel.php';
require_once __DIR__ . '/../models/PacienteModel.php';
require_once __DIR__ . '/../models/MedicoModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/ConsultorioModel.php';
require_once __DIR__ . '/../models/EspecialidadModel.php';
require_once __DIR__ . '/../models/EstadoCitaModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/LogModel.php';

class CitasController extends Controller {
    public function index(): void {
        $this->requireLogin();
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];
        $sesClin = $_SESSION['user']['clinicas'] ?? [];
        $idsSes  = array_map(fn($c) => (int)($c['id_CLINICA'] ?? 0), $sesClin);
        Database::log(sprintf(
            'CITAS.index rol=%s user=%s fClinica=%s sesion_clinicas=[%s]',
            $rol,
            $_SESSION['user']['usuario'] ?? '?',
            var_export($fClinica, true),
            implode(',', $idsSes)
        ));
        try {
            $idMedicoFiltro = $rol === 'medico' ? (int)($_SESSION['user']['id_USUARIOS'] ?? 0) : null;
            $citas = CitaModel::listar($idMedicoFiltro ?: null,
                date('Y-m-d', strtotime('-30 days')),
                date('Y-m-d', strtotime('+90 days')),
                $fClinica);
            if ($rol === 'medico') {
                $idMed = (int)($_SESSION['user']['id_USUARIOS'] ?? 0);
                $citas = array_values(array_filter($citas, fn($c) => (int)($c['id_MEDICO'] ?? 0) === $idMed));
            }
        } catch (Throwable $e) {
            $this->flash('error', 'Error al cargar citas: ' . $e->getMessage());
            $citas = [];
        }

        // --- Filtros de la tabla (fecha y estado) y ordenamiento ---
        $fFecha  = (string)($this->stateParam('f_fecha', '') ?? '');
        $fEstado = $this->stateInt('f_estado');
        $ord     = (string)($this->stateParam('ord', 'fecha') ?? 'fecha');
        $dir     = strtolower((string)($this->stateParam('dir', 'asc') ?? 'asc')) === 'desc' ? 'desc' : 'asc';

        $val = function ($v, string $f) {
            if ($v instanceof DateTime) return $v->format($f);
            return (string)$v;
        };

        if ($fFecha !== '') {
            $citas = array_values(array_filter($citas, function ($c) use ($val, $fFecha) {
                return substr($val($c['fecha_cita'] ?? '', 'Y-m-d'), 0, 10) === $fFecha;
            }));
        }
        if ($fEstado) {
            $citas = array_values(array_filter($citas, function ($c) use ($fEstado) {
                return (int)($c['id_CATALOGO_ESTADO_CITAS'] ?? 0) === $fEstado;
            }));
        }

        $key = function (array $c) use ($ord, $val) {
            switch ($ord) {
                case 'hora':        return substr($val($c['hora_inicio'] ?? '', 'H:i:s'), 0, 8);
                case 'paciente':    return mb_strtolower((string)($c['paciente'] ?? ''));
                case 'medico':      return mb_strtolower((string)($c['medico'] ?? ''));
                case 'especialidad':return mb_strtolower((string)($c['especialidad'] ?? ''));
                case 'consultorio': return mb_strtolower((string)($c['consultorio'] ?? ''));
                case 'fecha':
                default:
                    return substr($val($c['fecha_cita'] ?? '', 'Y-m-d'), 0, 10)
                         . ' ' . substr($val($c['hora_inicio'] ?? '', 'H:i:s'), 0, 8);
            }
        };
        usort($citas, function ($a, $b) use ($key, $dir) {
            $r = strcmp($key($a), $key($b));
            return $dir === 'desc' ? -$r : $r;
        });

        // --- Paginacion: 15 elementos por pagina ---
        $porPagina = 15;
        $total     = count($citas);
        $paginas   = max(1, (int)ceil($total / $porPagina));
        $pag       = (int)($this->stateParam('pag', 1) ?? 1);
        if ($pag < 1) $pag = 1;
        if ($pag > $paginas) { $pag = $paginas; $_SESSION['ui']['citas']['pag'] = $pag; }
        $citas = array_slice($citas, ($pag - 1) * $porPagina, $porPagina);

        $this->view('citas/index', [
            'title'    => 'Citas',
            'citas'    => $citas,
            'clinicas' => ClinicaModel::listar(),
            'fClinica' => $fClinica,
            'rol'      => $rol,
            'clinicasFiltro' => $clinicasFiltro,
            'estados'  => EstadoCitaModel::listar(),
            'fFecha'   => $fFecha,
            'fEstado'  => $fEstado,
            'ord'      => $ord,
            'dir'      => $dir,
            'pag'       => $pag,
            'paginas'   => $paginas,
            'totalCitas'=> $total,
            'porPagina' => $porPagina,
        ]);
    }

    /** Aplica los filtros de fecha/estado de la tabla de citas. */
    public function filtrar(): void {
        $this->requireLogin();
        $this->stateParam('f_fecha', '');
        $this->stateParam('f_estado', null);
        $_SESSION['ui']['citas']['pag'] = 1;
        $this->redirect('citas');
    }

    /** Cambia la pagina de la tabla de citas. */
    public function pagina(): void {
        $this->requireLogin();
        $p = (int)$this->input('pag');
        $_SESSION['ui']['citas']['pag'] = $p > 0 ? $p : 1;
        $this->redirect('citas');
    }

    /** Cambia la columna/direccion de ordenamiento de la tabla de citas. */
    public function ordenar(): void {
        $this->requireLogin();
        $col = (string)($this->input('ord') ?? 'fecha');
        $permitidas = ['fecha', 'hora', 'paciente', 'medico', 'especialidad', 'consultorio'];
        if (!in_array($col, $permitidas, true)) $col = 'fecha';
        $actual = (string)($this->stateParam('ord', 'fecha') ?? 'fecha');
        $dir    = strtolower((string)($this->stateParam('dir', 'asc') ?? 'asc'));
        $nuevo  = ($actual === $col && $dir === 'asc') ? 'desc' : 'asc';
        $_SESSION['ui']['citas']['ord'] = $col;
        $_SESSION['ui']['citas']['dir'] = $nuevo;
        $_SESSION['ui']['citas']['pag'] = 1;
        $this->redirect('citas');
    }

    public function nueva(): void { $this->clearState('id'); $this->form(); }

    /**
     * Monitor de citas: devuelve en JSON cuantas citas ya entraron en su
     * ventana de anticipacion (hora_inicio - horas_anticipacion <= ahora).
     * Se consulta cada minuto desde el menu lateral.
     */
    public function pendientes(): void {
        $this->requireLogin();
        // El monitor corre cada minuto: no debe generar ruido en app.log.
        Database::$silencioso = true;
        header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: no-store');
        $total = 0;
        try {
            $ctx = $this->resolveClinicaContext();
            $rol = $ctx['rol'];
            if ($rol === 'medico') {
                // El medico ve todas sus citas pendientes, sin importar la clinica.
                $idMedico = ((int)($_SESSION['user']['id_USUARIOS'] ?? 0)) ?: null;
                $total = count(CitaModel::porNotificar($idMedico, null));
            } elseif ($rol === 'administrador') {
                // El administrador de clinica suma las pendientes de todas
                // las clinicas a las que tiene acceso.
                $ids = array_values(array_unique(array_filter(array_map(
                    fn($c) => (int)($c['id_CLINICA'] ?? 0),
                    $_SESSION['user']['clinicas'] ?? []
                ))));
                if (empty($ids) && !empty($ctx['fClinica'])) $ids = [(int)$ctx['fClinica']];
                foreach ($ids as $idc) {
                    $total += count(CitaModel::porNotificar(null, $idc));
                }
            } else {
                $total = count(CitaModel::porNotificar(null, $ctx['fClinica']));
            }
        } catch (Throwable $e) {
            // Silenciado a proposito: el monitor no escribe en app.log.
        }
        echo json_encode(['total' => $total, 'ts' => time()]);
        exit;
    }

    public function editar(): void { $this->form(); }
    /** Muestra la cita en solo lectura para capturar el motivo de cancelacion. */
    public function cancelarForm(): void { $this->form('cancelar'); }
    /** Ventana de atencion: el medico revisa la cita y la marca como Atendida. */
    public function atenderForm(): void {
        // Momento real de inicio de la consulta (clic en "Atender").
        $id = $this->stateInt('id');
        if ($id && empty($_SESSION['atencion_inicio'][$id])) {
            $_SESSION['atencion_inicio'][$id] = CitaModel::ahoraSql();
        }
        $this->form('atender');
    }
    /** El medico ajusta la hora de finalizacion (solo citas agendadas y futuras). */
    public function horarioForm(): void {
        $this->requireLogin();
        $id = $this->stateInt('id');
        $c  = $id ? CitaModel::obtener($id) : null;
        if ($c && !$this->horaFinModificable($c)) {
            $this->flash('error', 'Ya no se puede modificar la hora fin de esta cita.');
            $this->clearState('id');
            $this->redirect('citas');
            return;
        }
        $this->form('horario');
    }

    /** La hora fin solo se modifica en citas con fecha posterior a hoy. */
    private function horaFinModificable(array $c): bool {
        $f = $c['fecha_cita'] ?? '';
        $f = $f instanceof DateTime ? $f->format('Y-m-d') : substr((string)$f, 0, 10);
        return $f > substr(CitaModel::ahoraSql(), 0, 10);
    }


    private function form(string $modo = 'edicion'): void {
        $this->requireLogin();
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];
        $editId = $this->stateInt('id');
        $editRow = null;
        $notifEditable = true;
        if ($editId) {
            $editRow = CitaModel::obtener($editId);
            if ($editRow && !$this->citaPermitida($editRow)) {
                $this->clearState('id');
                $this->denegarRecurso('CITA', $editId, (int)($editRow['id_CLINICA'] ?? 0), 'citas');
                return;
            }
            if ($editRow) {
                $est = mb_strtolower(trim((string)($editRow['estado'] ?? '')));
                if (in_array($est, ['cancelada', 'cancelado'], true)) {
                    $this->flash('error', 'La cita esta cancelada y no puede modificarse.');
                    $this->clearState('id');
                    $this->redirect('citas');
                    return;
                }
                // Solo en edicion y con estado agendada se permite modificar las
                // opciones de notificacion (email/WhatsApp). En confirmar, atender
                // o cancelar quedan deshabilitadas.
                $notifEditable = ($modo === 'edicion') && (strpos($est, 'agendad') !== false);
                // El contexto se fija a la clinica de la cita para que los
                // catalogos contengan los valores guardados.
                $cl = (int)($editRow['id_CLINICA'] ?? 0);
                if ($cl > 0) $fClinica = $cl;
            } else {
                $this->flash('error', 'No se encontro la cita seleccionada.');
            }
        } else {
            $notifEditable = ($modo === 'edicion');
        }
        // Solo estados activos; en alta se limita a "Agendada".
        $estados = EstadoCitaModel::listar();
        if (!$editId) {
            $agendada = array_values(array_filter($estados, function ($e) {
                $n = strtolower(trim((string)($e['nombre'] ?? '')));
                return $n === 'agendada' || $n === 'agendado';
            }));
            if (!empty($agendada)) $estados = $agendada;
        }
        $this->view('citas/form', [
            'title'         => $editId ? 'Modificar Cita' : 'Agendar Cita',
            'editId'        => $editId,
            'editRow'       => $editRow,
            'modo'          => $modo,
            'notifEditable' => $notifEditable,
            'pacientes'     => PacienteModel::listar($fClinica),
            'medicos'       => UsuarioModel::listarMedicos($fClinica),
            'consultorios'  => ConsultorioModel::listar($fClinica),
            'especialidades'=> EspecialidadModel::listar($fClinica),
            'estados'       => $estados,
            'clinicas'      => ClinicaModel::listar(),
            'clinicasFiltro'=> $clinicasFiltro,
            'fClinica'      => $fClinica,
            'rol'           => $rol,
        ]);
    }

    /** Guarda unicamente la hora de finalizacion (citas agendadas). */
    public function horarioGuardar(): void {
        $this->requireLogin();
        $id = (int)$this->input('id');
        $hf = substr((string)$this->input('hora_fin'), 0, 5);
        $c  = $id ? CitaModel::obtener($id) : null;
        if (!$c || !$this->citaPermitida($c)) {
            $this->clearState('id');
            $this->denegarRecurso('CITA', $id, $c ? (int)($c['id_CLINICA'] ?? 0) : null, 'citas');
            return;
        }
        if (!$this->horaFinModificable($c)) {
            $this->flash('error', 'Ya no se puede modificar la hora fin de esta cita.');
            $this->clearState('id');
            $this->redirect('citas');
            return;
        }
        $est = mb_strtolower(trim((string)($c['estado'] ?? '')));
        if (strpos($est, 'agendad') === false) {
            $this->flash('error', 'Solo se puede modificar la hora fin de citas agendadas.');
            $this->clearState('id');
            $this->redirect('citas');
            return;
        }
        $g  = fn($v, $f) => $v instanceof DateTime ? $v->format($f) : (string)$v;
        $fe = substr($g($c['fecha_cita'] ?? '', 'Y-m-d'), 0, 10);
        $hi = substr($g($c['hora_inicio'] ?? '', 'H:i:s'), 0, 5);
        if (!preg_match('/^\d{2}:\d{2}$/', $hf) || strtotime($fe . ' ' . $hf) <= strtotime($fe . ' ' . $hi)) {
            $this->flash('error', 'La hora fin debe ser mayor a la hora de inicio.');
            $this->redirect('citas/horarioForm');
            return;
        }
        try {
            CitaModel::cambio($id, [
                'id_PACIENTE'              => (int)$c['id_PACIENTE'],
                'id_MEDICO'                => (int)$c['id_MEDICO'],
                'id_CONSULTORIO'           => (int)$c['id_CONSULTORIO'],
                'id_CATALOGO_ESPECIALIDAD' => (int)$c['id_CATALOGO_ESPECIALIDAD'],
                'fecha_cita'               => $fe,
                'hora_inicio'              => $hi . ':00',
                'hora_fin'                 => $hf . ':00',
                'id_CATALOGO_ESTADO_CITAS' => (int)$c['id_CATALOGO_ESTADO_CITAS'],
                'observaciones'            => (string)($c['observaciones'] ?? ''),
                'horas_anticipacion_notif' => (int)($c['horas_anticipacion_notif'] ?? 24),
                'precio'                   => (float)($c['precio'] ?? 0),
            ]);
            Database::log('CITA HORA FIN MODIFICADA id_CITA=' . $id . ' hora_fin=' . $hf
                . ' usuario=' . (string)($_SESSION['user']['usuario'] ?? '?')
                . ' clinica=' . (string)($c['clinica'] ?? ''));
            $this->flash('ok', 'Hora de finalizacion actualizada.');
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo actualizar la hora fin: ' . $e->getMessage());
        }
        $this->clearState('id');
        $this->redirect('citas');
    }

    public function guardar(): void {

        $this->requireLogin();
        $id = $this->intOrNull($_POST['id'] ?? null);
        $data = [
            'id_PACIENTE'              => (int)$this->input('id_PACIENTE'),
            'id_MEDICO'                => (int)$this->input('id_MEDICO'),
            'id_CONSULTORIO'           => (int)$this->input('id_CONSULTORIO'),
            'id_CATALOGO_ESPECIALIDAD' => (int)$this->input('id_CATALOGO_ESPECIALIDAD'),
            'fecha_cita'               => $this->input('fecha_cita'),
            'hora_inicio'              => $this->input('hora_inicio') . ':00',
            'hora_fin'                 => $this->input('hora_fin') . ':00',
            'id_CATALOGO_ESTADO_CITAS' => (int)$this->input('id_CATALOGO_ESTADO_CITAS'),
            'observaciones'            => $this->input('observaciones'),
            'horas_anticipacion_notif' => (int)($this->input('horas_anticipacion_notif') ?? 24),
            'precio'                   => (float)($this->input('precio') ?? 0),
        ];
        // Validar que el paciente pertenezca a una clinica autorizada (IDOR).
        $pac = $data['id_PACIENTE'] > 0 ? PacienteModel::obtener((int)$data['id_PACIENTE']) : null;
        if (!$pac || !$this->clinicaPermitida((int)($pac['id_CLINICA'] ?? 0))) {
            $this->clearState('id');
            $this->denegarRecurso('PACIENTE', $data['id_PACIENTE'], $pac ? (int)($pac['id_CLINICA'] ?? 0) : null, 'citas');
            return;
        }
        // Las preferencias de notificacion viven unicamente en el PACIENTE.
        try {

            if ($id) {
                $prev = CitaModel::obtener($id);
                if (!$prev || !$this->citaPermitida($prev)) {
                    $this->clearState('id');
                    $this->denegarRecurso('CITA', $id, $prev ? (int)($prev['id_CLINICA'] ?? 0) : null, 'citas');
                    return;
                }
                $estPrev = mb_strtolower(trim((string)($prev['estado'] ?? '')));
                if (in_array($estPrev, ['cancelada', 'cancelado'], true)) {
                    $this->flash('error', 'La cita esta cancelada y no puede modificarse.');
                    $this->clearState('id');
                    $this->redirect('citas');
                    return;
                }
                CitaModel::cambio($id, $data);
                $this->flash('ok', 'Cita actualizada.');
                $antes = (string)($prev['estado'] ?? '');
                $nuevo = $this->nombreEstado((int)$data['id_CATALOGO_ESTADO_CITAS']);
                if ($nuevo !== '' && strcasecmp($antes, $nuevo) !== 0) {
                    $this->registraLogEstado($id, $antes, $nuevo, (int)($prev['id_CLINICA'] ?? 0));
                }
            } else {
                $nuevoId = CitaModel::alta($data);
                $this->flash('ok', 'Cita agendada.');
                $nuevo = $this->nombreEstado((int)$data['id_CATALOGO_ESTADO_CITAS']);
                $ctxAlta = $this->resolveClinicaContext();
                $this->registraLogEstado((int)$nuevoId, null, $nuevo !== '' ? $nuevo : 'Agendada',
                    (int)($ctxAlta['fClinica'] ?? 0));
            }
            // Actualizar observaciones del paciente ya validado.
            $obsPaciente = (string)($this->input('observaciones_paciente') ?? '');
            PacienteModel::cambioObservaciones((int)$pac['id_PACIENTE'], $obsPaciente);

        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo guardar: ' . $e->getMessage());
        }
        $this->clearState('id');
        $this->redirect('citas');
    }

    public function cancelar(): void {
        $this->requireLogin();
        $id = (int)$this->input('id');
        $idEstado = (int)$this->input('id_estado'); // pasar "Cancelada"
        $cita = $id ? CitaModel::obtener($id) : null;
        if (!$cita || !$this->citaPermitida($cita)) {
            $this->clearState('id');
            $this->denegarRecurso('CITA', $id, $cita ? (int)($cita['id_CLINICA'] ?? 0) : null, 'citas');
            return;
        }
        try { CitaModel::cancela($id, $idEstado); $this->flash('ok', 'Cita cancelada.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('id');
        $this->redirect('citas');
    }

    /** Guarda la cancelacion con el motivo capturado en observaciones. */
    public function cancelarGuardar(): void {
        $this->requireLogin();
        $id  = (int)$this->input('id');
        $obs = (string)($this->input('observaciones') ?? '');
        if (mb_strlen(trim($obs)) < 5) {
            $this->flash('error', 'Debe capturar la razon de la cancelacion en Observaciones (minimo 5 caracteres).');
            $this->redirect('citas/cancelarForm');
            return;
        }
        $this->cambiaEstado($id, ['cancelada', 'cancelado'], 'Cita cancelada.', $obs);
    }

    /** Marca la cita como "No asistio". */
    public function noAsistio(): void {
        $this->requireLogin();
        $this->cambiaEstado((int)$this->input('id'), ['no asistio', 'no asistió', 'no asistio.', 'noasistio'], 'Cita marcada como No asistio.');
    }

    /** El medico marca la cita como atendida. */
    public function atendida(): void {
        $this->requireLogin();
        $this->cambiaEstado((int)$this->input('id'), ['atendida', 'atendido'], 'Cita marcada como Atendida.');
    }

    /** El medico confirma la cita. */
    public function confirmar(): void {
        $this->requireLogin();
        $id = (int)$this->input('id');
        // Tras confirmar se abre la ventana de la cita para su atencion.
        $this->cambiaEstado($id, ['confirmada', 'confirmado'], 'Cita confirmada.', null, 'citas/atenderForm', true);
    }

    /**
     * Guarda las observaciones capturadas en la ventana de atencion y
     * cambia el estatus de Confirmada a Atendida.
     */
    public function atenderGuardar(): void {
        $this->requireLogin();
        $id  = (int)$this->input('id');
        $obs = (string)($this->input('observaciones') ?? '');
        $pIn = $this->input('precio');
        $precio = ($pIn === null || $pIn === '') ? null : (float)$pIn;
        if ($precio !== null && $precio < 0) $precio = 0.0;
        try {
            $c = $id ? CitaModel::obtener($id) : null;
            if ($c && !$this->citaPermitida($c)) {
                $this->clearState('id');
                $this->denegarRecurso('CITA', $id, (int)($c['id_CLINICA'] ?? 0), 'citas');
                return;
            }
            if ($c) {
                PacienteModel::cambioObservaciones(
                    (int)$c['id_PACIENTE'],
                    (string)($this->input('observaciones_paciente') ?? '')
                );
            }
        } catch (Throwable $e) {
            Database::log('CITAS.atenderGuardar obs paciente ERR: ' . $e->getMessage());
        }
        // Horas reales: inicio = clic en "Atender", fin = clic en "Atendida".
        try {
            $est = isset($c) && $c ? mb_strtolower(trim((string)($c['estado'] ?? ''))) : '';
            if ($c && strpos($est, 'confirmad') !== false) {
                $fin = CitaModel::ahoraSql();
                $ini = (string)($_SESSION['atencion_inicio'][$id] ?? '');
                if (!preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}/', $ini)
                    || substr($ini, 0, 10) !== substr($fin, 0, 10)
                    || substr($ini, 11, 5) >= substr($fin, 11, 5)) {
                    // Sin inicio valido: fin menos 1 minuto (mismo dia).
                    $t = strtotime($fin) - 60;
                    $ini = date('Y-m-d', $t) === substr($fin, 0, 10) ? date('Y-m-d H:i:s', $t) : substr($fin, 0, 10) . ' 00:00:00';
                    if (substr($fin, 11, 5) === '00:00') $fin = substr($fin, 0, 11) . '00:01:00';
                }
                $fe = substr($ini, 0, 10);
                $hi = substr($ini, 11, 5);
                $hf = substr($fin, 11, 5);
                CitaModel::cambio($id, [
                    'id_PACIENTE'              => (int)$c['id_PACIENTE'],
                    'id_MEDICO'                => (int)$c['id_MEDICO'],
                    'id_CONSULTORIO'           => (int)$c['id_CONSULTORIO'],
                    'id_CATALOGO_ESPECIALIDAD' => (int)$c['id_CATALOGO_ESPECIALIDAD'],
                    'fecha_cita'               => $fe,
                    'hora_inicio'              => $hi . ':00',
                    'hora_fin'                 => $hf . ':00',
                    'id_CATALOGO_ESTADO_CITAS' => (int)$c['id_CATALOGO_ESTADO_CITAS'],
                    'observaciones'            => (string)($c['observaciones'] ?? ''),
                    'horas_anticipacion_notif' => (int)($c['horas_anticipacion_notif'] ?? 24),
                    'precio'                   => (float)($precio ?? ($c['precio'] ?? 0)),
                ]);
                Database::log('CITA HORAS REALES id_CITA=' . $id . ' fecha=' . $fe
                    . ' inicio=' . $hi . ' fin=' . $hf
                    . ' usuario=' . (string)($_SESSION['user']['usuario'] ?? '?'));
            }
            unset($_SESSION['atencion_inicio'][$id]);
        } catch (Throwable $e) {
            Database::log('CITAS.atenderGuardar obs paciente ERR: ' . $e->getMessage());
        }
        $this->cambiaEstado($id, ['atendida', 'atendido'], 'Cita marcada como Atendida.', $obs, 'citas', false, $precio);
    }

    /** Marca la cita como notificada. */
    public function notificado(): void {
        $this->requireLogin();
        $id = (int)$this->input('id');
        $this->notificadoReal($id);
    }

    /** Registra en app.log que se genero el enlace de WhatsApp para una cita. */
    public function waLog(): void {
        $this->requireLogin();
        // (registro del enlace de WhatsApp)
        $id = (int)$this->input('id');
        try {
            $c = $id ? CitaModel::obtener($id) : null;
            if ($c && !$this->citaPermitida($c)) {
                Database::log('ACCESO DENEGADO recurso=CITA id=' . $id
                    . ' usuario=' . (string)($_SESSION['user']['usuario'] ?? '?'));
                http_response_code(403);
                header('Content-Type: application/json');
                echo json_encode(['ok' => false, 'error' => 'forbidden']);
                exit;
            }
            if ($c) {
                Database::log('WHATSAPP ENLACE GENERADO id_CITA=' . $id
                    . ' usuario=' . (string)($_SESSION['user']['usuario'] ?? '?')
                    . ' paciente=' . trim((string)($c['paciente'] ?? '(n/d)'))
                    . ' clinica=' . trim((string)($c['clinica'] ?? '(n/d)'))
                    . ' celular=' . wa_numero((string)($c['celular_notif'] ?? '')));
            }
        } catch (Throwable $e) {
            Database::log('CITAS.waLog ERR: ' . $e->getMessage());
        }
        header('Content-Type: application/json');
        echo json_encode(['ok' => true]);
        exit;
    }

    /** Registra en app.log que se abrio el cliente de correo local para una cita. */
    public function emailLog(): void {
        $this->requireLogin();
        $id = (int)$this->input('id');
        try {
            $c = $id ? CitaModel::obtener($id) : null;
            if ($c && !$this->citaPermitida($c)) {
                Database::log('ACCESO DENEGADO recurso=CITA id=' . $id
                    . ' usuario=' . (string)($_SESSION['user']['usuario'] ?? '?'));
                http_response_code(403);
                header('Content-Type: application/json');
                echo json_encode(['ok' => false, 'error' => 'forbidden']);
                exit;
            }
            if ($c) {
                Database::log('EMAIL CLIENTE LOCAL ABIERTO id_CITA=' . $id
                    . ' usuario=' . (string)($_SESSION['user']['usuario'] ?? '?')
                    . ' paciente=' . trim((string)($c['paciente'] ?? '(n/d)'))
                    . ' clinica=' . trim((string)($c['clinica'] ?? '(n/d)'))
                    . ' email=' . trim((string)($c['email_notif'] ?? '')));
            }
        } catch (Throwable $e) {
            Database::log('CITAS.emailLog ERR: ' . $e->getMessage());
        }
        header('Content-Type: application/json');
        echo json_encode(['ok' => true]);
        exit;
    }

    /** Marca la cita como notificada (implementacion). */
    private function notificadoReal(int $id): void {
        try {
            $c = $id ? CitaModel::obtener($id) : null;
            if ($c && !$this->citaPermitida($c)) {
                $this->clearState('id');
                $this->denegarRecurso('CITA', $id, (int)($c['id_CLINICA'] ?? 0), 'citas');
                return;
            }
            if (!$c) throw new RuntimeException('No se encontro la cita.');
            $usuario = (string)($_SESSION['user']['usuario'] ?? '?');
            CitaModel::notifica($id, $usuario);
            Database::log('CITA NOTIFICADA id_CITA=' . $id
                . ' usuario=' . $usuario
                . ' id_usuario=' . (int)($_SESSION['user']['id_USUARIOS'] ?? 0)
                . ' paciente=' . trim((string)($c['paciente'] ?? '(n/d)'))
                . ' id_PACIENTE=' . (int)($c['id_PACIENTE'] ?? 0)
                . ' clinica=' . trim((string)($c['clinica'] ?? '(n/d)'))
                . ' id_CLINICA=' . (int)($c['id_CLINICA'] ?? 0)
                . ' consultorio=' . trim((string)($c['consultorio'] ?? '(n/d)'))
                . ' id_CONSULTORIO=' . (int)($c['id_CONSULTORIO'] ?? 0));
            $this->flash('ok', 'Cita marcada como notificada.');
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo marcar como notificada: ' . $e->getMessage());
        }
        $this->clearState('id');
        $this->redirect('citas');
    }

    /** Cambia el estado de una cita conservando el resto de los datos. */
    private function cambiaEstado(int $id, array $nombresEstado, string $okMsg, ?string $observaciones = null,
                                  string $redirect = 'citas', bool $conservaId = false, ?float $precio = null): void {
        $c = null;
        try {
            $c = $id ? CitaModel::obtener($id) : null;
            if ($c && !$this->citaPermitida($c)) {
                $this->clearState('id');
                $this->denegarRecurso('CITA', $id, (int)($c['id_CLINICA'] ?? 0), 'citas');
                return;
            }
            if (!$c) throw new RuntimeException('No se encontro la cita.');
            $actual = mb_strtolower(trim((string)($c['estado'] ?? '')));
            if (in_array($actual, ['cancelada', 'cancelado'], true)) {
                throw new RuntimeException('La cita esta cancelada y no puede modificarse.');
            }
            $idEstado = 0;
            foreach (EstadoCitaModel::listar() as $e) {
                $n = strtolower(trim((string)($e['nombre'] ?? '')));
                if (in_array($n, $nombresEstado, true)) { $idEstado = (int)$e['id_CATALOGO_ESTADO_CITAS']; break; }
            }
            if (!$idEstado) throw new RuntimeException('No existe el estado requerido en el catalogo de estados de cita.');
            $fmt = function ($v, string $f) {
                if ($v instanceof DateTime) return $v->format($f);
                return (string)$v;
            };
            CitaModel::cambio($id, [
                'id_PACIENTE'              => (int)$c['id_PACIENTE'],
                'id_MEDICO'                => (int)$c['id_MEDICO'],
                'id_CONSULTORIO'           => (int)$c['id_CONSULTORIO'],
                'id_CATALOGO_ESPECIALIDAD' => (int)$c['id_CATALOGO_ESPECIALIDAD'],
                'fecha_cita'               => substr($fmt($c['fecha_cita'], 'Y-m-d'), 0, 10),
                'hora_inicio'              => substr($fmt($c['hora_inicio'], 'H:i:s'), 0, 8),
                'hora_fin'                 => substr($fmt($c['hora_fin'], 'H:i:s'), 0, 8),
                'id_CATALOGO_ESTADO_CITAS' => $idEstado,
                'observaciones'            => $observaciones !== null ? $observaciones : (string)($c['observaciones'] ?? ''),
                'horas_anticipacion_notif' => (int)($c['horas_anticipacion_notif'] ?? 24),
                'precio'                   => $precio !== null ? $precio : (float)($c['precio'] ?? 0),
            ]);
            $this->registraLogEstado(
                $id,
                (string)($c['estado'] ?? ''),
                $this->nombreEstado($idEstado),
                (int)($c['id_CLINICA'] ?? 0),
                $c
            );
            $this->flash('ok', $okMsg);
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo actualizar la cita: ' . $e->getMessage());
            $redirect = 'citas';
            $conservaId = false;
        }
        if ($conservaId && $id) {
            $_SESSION['ui'][$this->stateNs()]['id'] = $id;
        } else {
            $this->clearState('id');
        }
        $this->redirect($redirect);
    }

    /**
     * Verifica que la cita pertenezca a una clinica autorizada para el usuario
     * y, si el rol es medico, que sea una de sus propias citas (anti-IDOR).
     */
    private function citaPermitida(?array $c): bool {
        if (!$c) return false;
        if (!$this->clinicaPermitida((int)($c['id_CLINICA'] ?? 0))) return false;
        if (($_SESSION['user']['rol'] ?? '') === 'medico') {
            return (int)($c['id_MEDICO'] ?? 0) === (int)($_SESSION['user']['id_USUARIOS'] ?? 0);
        }
        return true;
    }

    /** Regresa el nombre del estado de cita a partir de su id. */
    private function nombreEstado(int $idEstado): string {
        foreach (EstadoCitaModel::listar() as $e) {
            if ((int)($e['id_CATALOGO_ESTADO_CITAS'] ?? 0) === $idEstado) {
                return trim((string)($e['nombre'] ?? ''));
            }
        }
        return '';
    }

    /** Registra el cambio de estatus en citas.LOG y en app.log. */
    private function registraLogEstado(int $idCita, ?string $antes, string $nuevo, int $idClinica, ?array $cita = null): void {
        $nombreClinica = '';
        foreach (ClinicaModel::listar() as $cl) {
            if ((int)($cl['id_CLINICA'] ?? 0) === $idClinica) {
                $nombreClinica = trim((string)($cl['nombre'] ?? ''));
                break;
            }
        }
        if ($nombreClinica === '' && $cita) $nombreClinica = trim((string)($cita['clinica'] ?? ''));
        $usuario = (string)($_SESSION['user']['usuario'] ?? '?');
        $linea = $this->eventoLog($idCita, $antes, $nuevo,
            $nombreClinica !== '' ? $nombreClinica : '(n/d)', $idClinica, $usuario,
            (int)($_SESSION['user']['id_USUARIOS'] ?? 0), $cita);
        try {
            $n = mb_strtolower(trim($nuevo));
            $esAtendida = in_array($n, ['atendida', 'atendido'], true);
            LogModel::estadoCita(
                $idCita, $antes, $nuevo, $idClinica ?: null,
                $nombreClinica !== '' ? $nombreClinica : null, $usuario,
                $esAtendida && $cita ? (string)($cita['medico'] ?? '') : null,
                $esAtendida && $cita ? (string)($cita['paciente'] ?? '') : null,
                $esAtendida && $cita ? (string)($cita['especialidad'] ?? '') : null,
                $esAtendida && $cita ? (string)($cita['consultorio'] ?? '') : null
            );
            Database::log($linea . ' | LOG BD=OK');
        } catch (Throwable $e) {
            Database::log($linea . ' | LOG BD=ERROR: ' . $e->getMessage());
        }
    }

    /** Construye el mensaje de evento con el mismo formato que citas.LOG. */
    private function eventoLog(int $idCita, ?string $antes, string $nuevo, string $clinica,
                               int $idClinica, string $usuario, int $idUsuario, ?array $cita = null): string {
        $n = mb_strtolower(trim($nuevo));
        if ($antes === null || trim($antes) === '') {
            $prefijo = 'ALTA CITA';
        } elseif (in_array($n, ['atendida', 'atendido'], true)) {
            return 'CITA ATENDIDA'
                . ' medico=' . trim((string)($cita['medico'] ?? '(n/d)'))
                . ' paciente=' . trim((string)($cita['paciente'] ?? '(n/d)'))
                . ' clinica=' . $clinica
                . ' especialidad=' . trim((string)($cita['especialidad'] ?? '(n/d)'))
                . ' consultorio=' . trim((string)($cita['consultorio'] ?? '(n/d)'))
                . ' id_CITA=' . $idCita
                . ' usuario=' . $usuario
                . ' id_usuario=' . $idUsuario;
        } elseif (in_array($n, ['cancelada', 'cancelado'], true)) {
            return 'CITA CANCELADA clinica=' . $clinica
                . ' id_CLINICA=' . $idClinica
                . ' usuario=' . $usuario
                . ' id_usuario=' . $idUsuario
                . ' id_CITA=' . $idCita;
        } elseif (in_array($n, ['confirmada', 'confirmado'], true)) {
            $prefijo = 'CITA CONFIRMADA';
        } elseif (in_array($n, ['no asistio', 'no asistió', 'noasistio'], true)) {
            $prefijo = 'CITA NO ASISTIO';
        } elseif (in_array($n, ['agendada', 'agendado'], true)) {
            $prefijo = 'CITA AGENDADA';
        } else {
            $prefijo = 'CAMBIO ESTATUS CITA';
        }
        $partes = $prefijo . ' id_CITA=' . $idCita;
        if ($prefijo !== 'ALTA CITA') {
            $partes .= ' estado_anterior=' . $antes;
        }
        return $partes . ' estado_nuevo=' . $nuevo
            . ' clinica=' . $clinica
            . ' id_CLINICA=' . $idClinica
            . ' usuario=' . $usuario
            . ' id_usuario=' . $idUsuario;
    }
}