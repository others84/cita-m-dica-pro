<?php
require_once __DIR__ . '/../core/Controller.php';

require_once __DIR__ . '/../models/CitaModel.php';

class CalendarioController extends Controller {
    public function index(): void {
        $this->requireLogin();
        $user   = $_SESSION['user'];
        $rol    = $user['rol'] ?? '';

        // Si el rol es medico y existe id_USUARIOS->id_MEDICO, podria filtrarse;
        // por ahora se muestran todas las citas en un rango razonable.
        $idMedico = null;
        $desde = date('Y-m-d', strtotime('-30 days'));
        $hasta = date('Y-m-d', strtotime('+90 days'));

        $eventos = [];
        $errorCarga = null;
        try {
            $citas = CitaModel::listar($idMedico, $desde, $hasta);
            foreach ($citas as $c) {
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
        ]);
    }
}