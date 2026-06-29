<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/CitaModel.php';
require_once __DIR__ . '/../models/PacienteModel.php';
require_once __DIR__ . '/../models/MedicoModel.php';
require_once __DIR__ . '/../models/ConsultorioModel.php';
require_once __DIR__ . '/../models/EspecialidadModel.php';
require_once __DIR__ . '/../models/EstadoCitaModel.php';

class CitasController extends Controller {
    public function index(): void {
        $this->requireLogin();
        try {
            $citas = CitaModel::listar(null, date('Y-m-d', strtotime('-30 days')), date('Y-m-d', strtotime('+90 days')));
        } catch (Throwable $e) {
            $this->flash('error', 'Error al cargar citas: ' . $e->getMessage());
            $citas = [];
        }
        $this->view('citas/index', ['title' => 'Citas', 'citas' => $citas]);
    }

    public function nueva(): void { $this->form(); }
    public function editar(): void { $this->form(); }

    private function form(): void {
        $this->requireLogin();
        $editId = $this->intOrNull($_GET['id'] ?? null);
        $editRow = null;
        if ($editId) {
            $rows = CitaModel::listar();
            foreach ($rows as $r) if ((int)$r['id_CITA'] === $editId) { $editRow = $r; break; }
        }
        $this->view('citas/form', [
            'title'         => $editId ? 'Modificar Cita' : 'Agendar Cita',
            'editId'        => $editId,
            'editRow'       => $editRow,
            'pacientes'     => PacienteModel::listar(),
            'medicos'       => MedicoModel::listar(),
            'consultorios'  => ConsultorioModel::listar(),
            'especialidades'=> EspecialidadModel::listar(),
            'estados'       => EstadoCitaModel::listar(),
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
        $this->redirect('citas');
    }

    public function cancelar(): void {
        $this->requireLogin();
        $id = (int)$this->input('id');
        $idEstado = (int)$this->input('id_estado'); // pasar "Cancelada"
        try { CitaModel::cancela($id, $idEstado); $this->flash('ok', 'Cita cancelada.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('citas');
    }
}