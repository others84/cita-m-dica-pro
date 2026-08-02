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
        ]);
    }

    /** Aplica los filtros de fecha/estado de la tabla de citas. */
    public function filtrar(): void {
        $this->requireLogin();
        $this->stateParam('f_fecha', '');
        $this->stateParam('f_estado', null);
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
        $this->redirect('citas');
    }

    public function nueva(): void { $this->clearState('id'); $this->form(); }
    public function editar(): void { $this->form(); }
    /** Muestra la cita en solo lectura para capturar el motivo de cancelacion. */
    public function cancelarForm(): void { $this->form('cancelar'); }

    private function form(string $modo = 'edicion'): void {
        $this->requireLogin();
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];
        $editId = $this->stateInt('id');
        $editRow = null;
        if ($editId) {
            $editRow = CitaModel::obtener($editId);
            if ($editRow) {
                // El contexto se fija a la clinica de la cita para que los
                // catalogos contengan los valores guardados.
                $cl = (int)($editRow['id_CLINICA'] ?? 0);
                if ($cl > 0) $fClinica = $cl;
            } else {
                $this->flash('error', 'No se encontro la cita seleccionada.');
            }
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
            'notifica_email'           => isset($_POST['notifica_email']) ? 1 : 0,
            'notifica_wa'              => isset($_POST['notifica_wa']) ? 1 : 0,
            'horas_anticipacion_notif' => (int)($this->input('horas_anticipacion_notif') ?? 24),
            'precio'                   => (float)($this->input('precio') ?? 0),
        ];
        try {
            if ($id) { CitaModel::cambio($id, $data); $this->flash('ok', 'Cita actualizada.'); }
            else     { CitaModel::alta($data);        $this->flash('ok', 'Cita agendada.'); }
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
        $this->cambiaEstado((int)$this->input('id'), ['confirmada', 'confirmado'], 'Cita confirmada.');
    }

    /** Cambia el estado de una cita conservando el resto de los datos. */
    private function cambiaEstado(int $id, array $nombresEstado, string $okMsg, ?string $observaciones = null): void {
        try {
            $c = $id ? CitaModel::obtener($id) : null;
            if (!$c) throw new RuntimeException('No se encontro la cita.');
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
                'notifica_email'           => (int)($c['notifica_email'] ?? 0),
                'notifica_wa'              => (int)($c['notifica_wa'] ?? 0),
                'horas_anticipacion_notif' => (int)($c['horas_anticipacion_notif'] ?? 24),
                'precio'                   => (float)($c['precio'] ?? 0),
            ]);
            Database::log(sprintf('CITAS.cambiaEstado id=%d estado=%d user=%s', $id, $idEstado, $_SESSION['user']['usuario'] ?? '?'));
            $this->flash('ok', $okMsg);
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo actualizar la cita: ' . $e->getMessage());
        }
        $this->clearState('id');
        $this->redirect('citas');
    }
}