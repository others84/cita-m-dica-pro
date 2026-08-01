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
            $citas = CitaModel::listar(null,
                date('Y-m-d', strtotime('-30 days')),
                date('Y-m-d', strtotime('+90 days')),
                $fClinica);
        } catch (Throwable $e) {
            $this->flash('error', 'Error al cargar citas: ' . $e->getMessage());
            $citas = [];
        }
        $this->view('citas/index', [
            'title'    => 'Citas',
            'citas'    => $citas,
            'clinicas' => ClinicaModel::listar(),
            'fClinica' => $fClinica,
            'rol'      => $rol,
            'clinicasFiltro' => $clinicasFiltro,
        ]);
    }

    public function nueva(): void { $this->clearState('id'); $this->form(); }
    public function editar(): void { $this->form(); }

    private function form(): void {
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
}