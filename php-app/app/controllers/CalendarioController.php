<?php
require_once __DIR__ . '/../core/Controller.php';

require_once __DIR__ . '/../models/CitaModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';

class CalendarioController extends Controller {
    public function index(): void {
        $this->requireLogin();
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];

        $idMedico = $rol === 'medico' ? ((int)($_SESSION['user']['id_USUARIOS'] ?? 0) ?: null) : null;

        // Filtro de medico (solo para roles distintos de medico).
        $medicos = [];
        $fMedico = null;
        if ($rol !== 'medico') {
            try { $medicos = UsuarioModel::listarMedicos($fClinica); } catch (Throwable $e) { $medicos = []; }
            $fMedico = $this->stateInt('f_medico');
            if ($fMedico !== null) {
                $ids = array_map(fn($m) => (int)($m['id_USUARIOS'] ?? 0), $medicos);
                if (!in_array($fMedico, $ids, true)) { $fMedico = null; $this->clearState('f_medico'); }
            }
            // Si solo existe un medico en la clinica seleccionada, se selecciona
            // automaticamente y se elimina la opcion "-- todos --" para que la
            // asistente no pueda elegir a otro medico.
            if (count($medicos) === 1) {
                $fMedico = (int)($medicos[0]['id_USUARIOS'] ?? 0);
            }
            if ($fMedico !== null) $idMedico = $fMedico;
        }

        $desde = date('Y-m-d', strtotime('-30 days'));
        $hasta = date('Y-m-d', strtotime('+90 days'));

        $eventos = [];
        $errorCarga = null;
        try {
            $citas = CitaModel::listar($idMedico, $desde, $hasta, $fClinica);
            if ($idMedico !== null) {
                $citas = array_values(array_filter($citas, fn($c) => (int)($c['id_MEDICO'] ?? 0) === $idMedico));
            }
            foreach ($citas as $c) {
                $estadoNorm = strtolower(trim((string)($c['estado'] ?? '')));
                $estadoNorm = strtr($estadoNorm, ['á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u']);
                if (strpos($estadoNorm, 'agendada') === false) { continue; }
                $fecha = $c['fecha_cita'] instanceof DateTime
                    ? $c['fecha_cita']->format('Y-m-d')
                    : substr((string)$c['fecha_cita'], 0, 10);
                $hi = $c['hora_inicio'] instanceof DateTime
                    ? $c['hora_inicio']->format('H:i:s')
                    : substr((string)$c['hora_inicio'], 0, 8);
                $hf = $c['hora_fin'] instanceof DateTime
                    ? $c['hora_fin']->format('H:i:s')
                    : substr((string)$c['hora_fin'], 0, 8);

                $eventos[] = [
                    'id'    => (string)$c['id_CITA'],
                    'title' => trim($c['paciente'] ?? ''),
                    'start' => $fecha . 'T' . $hi,
                    'end'   => $fecha . 'T' . $hf,
                    'extendedProps' => [
                        'paciente'    => trim($c['paciente'] ?? ''),
                        'medico'      => $c['medico'] ?? '',
                        'especialidad'=> $c['especialidad'] ?? '',
                        'consultorio' => $c['consultorio'] ?? '',
                        'estado'      => $c['estado'] ?? '',
                        'precio'      => $c['precio'] ?? 0,
                        'observaciones_paciente' => $c['observaciones_paciente'] ?? '',
                    ],
                ];
            }
        } catch (Throwable $e) {
            $errorCarga = $e->getMessage();
        }

        $this->view('calendario/index', [
            'title'       => 'Calendario de Citas',
            'eventos'     => $eventos,
            'errorCarga'  => $errorCarga,
            'clinicas'    => ClinicaModel::listar(),
            'fClinica'    => $fClinica,
            'rol'         => $rol,
            'clinicasFiltro' => $clinicasFiltro,
            'medicos'     => $medicos,
            'fMedico'     => $fMedico,
        ]);
    }

    /** Aplica el filtro de medico del calendario. */
    public function filtrar(): void {
        $this->requireLogin();
        $this->stateParam('f_medico', null);
        $this->redirect('calendario');
    }
}
