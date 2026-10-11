<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/CitaModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

/**
 * "Citas mañana": listado de las citas AGENDADAS del dia siguiente con envio
 * de recordatorio por WhatsApp (enlaces wa.me, sin costo).
 * Solo para los roles asistente y medico.
 */
class CitasmananaController extends Controller {

    public function index(): void {
        $this->requireLogin(['asistente', 'medico']);
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol'];
        $fClinica = $ctx['fClinica'];
        $manana = date('Y-m-d', strtotime('+1 day'));

        try {
            $idMedicoFiltro = $rol === 'medico' ? ((int)($_SESSION['user']['id_USUARIOS'] ?? 0) ?: null) : null;
            $citas = CitaModel::listar($idMedicoFiltro, $manana, $manana, $fClinica);
            if ($rol === 'medico') {
                $idMed = (int)($_SESSION['user']['id_USUARIOS'] ?? 0);
                $citas = array_values(array_filter($citas, fn($c) => (int)($c['id_MEDICO'] ?? 0) === $idMed));
            }
        } catch (Throwable $e) {
            $this->flash('error', 'Error al cargar las citas de mañana: ' . $e->getMessage());
            $citas = [];
        }

        // Solo del dia siguiente y en estatus "Agendada".
        $fmt = fn($v, string $f) => $v instanceof DateTime ? $v->format($f) : (string)$v;
        $citas = array_values(array_filter($citas, function ($c) use ($fmt, $manana) {
            if (substr($fmt($c['fecha_cita'] ?? '', 'Y-m-d'), 0, 10) !== $manana) return false;
            $est = mb_strtolower(trim((string)($c['estado'] ?? '')));
            $est = strtr($est, ['á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u']);
            return strpos($est, 'agendad') !== false;
        }));

        usort($citas, function ($a, $b) use ($fmt) {
            return strcmp(
                substr($fmt($a['hora_inicio'] ?? '', 'H:i:s'), 0, 8),
                substr($fmt($b['hora_inicio'] ?? '', 'H:i:s'), 0, 8)
            );
        });

        $this->view('citasmanana/index', [
            'title'          => 'Citas mañana',
            'citas'          => $citas,
            'manana'         => $manana,
            'clinicas'       => ClinicaModel::listar(),
            'clinicasFiltro' => $ctx['clinicasFiltro'],
            'fClinica'       => $fClinica,
            'rol'            => $rol,
        ]);
    }

    /**
     * Registra el envio del recordatorio y marca la cita como notificada.
     * Responde JSON (se llama con fetch desde la vista).
     */
    public function marcar(): void {
        $this->requireLogin(['asistente', 'medico']);
        header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: no-store');
        $id = (int)$this->input('id');
        try {
            $c = $id ? CitaModel::obtener($id) : null;
            if (!$c || !$this->citaPermitida($c)) {
                Database::log('ACCESO DENEGADO recurso=CITA id=' . $id
                    . ' origen=citasmanana usuario=' . (string)($_SESSION['user']['usuario'] ?? '?'));
                http_response_code(403);
                echo json_encode(['ok' => false, 'error' => 'forbidden']);
                exit;
            }
            $usuario = (string)($_SESSION['user']['usuario'] ?? '?');
            Database::log('WHATSAPP ENLACE GENERADO id_CITA=' . $id
                . ' origen=CITAS MANANA'
                . ' usuario=' . $usuario
                . ' paciente=' . trim((string)($c['paciente'] ?? '(n/d)'))
                . ' clinica=' . trim((string)($c['clinica'] ?? '(n/d)'))
                . ' celular=' . wa_numero((string)($c['celular_notif'] ?? '')));
            if ((int)($c['notificado'] ?? 0) !== 1) {
                CitaModel::notifica($id, $usuario);
                Database::log('CITA NOTIFICADA id_CITA=' . $id
                    . ' origen=CITAS MANANA'
                    . ' usuario=' . $usuario
                    . ' id_usuario=' . (int)($_SESSION['user']['id_USUARIOS'] ?? 0)
                    . ' paciente=' . trim((string)($c['paciente'] ?? '(n/d)'))
                    . ' clinica=' . trim((string)($c['clinica'] ?? '(n/d)')));
            }
        } catch (Throwable $e) {
            Database::log('CITASMANANA.marcar ERR: ' . $e->getMessage());
            echo json_encode(['ok' => false, 'error' => 'error']);
            exit;
        }
        echo json_encode(['ok' => true]);
        exit;
    }

    /** La cita debe ser de una clinica autorizada y, si es medico, suya. */
    private function citaPermitida(?array $c): bool {
        if (!$c) return false;
        if (!$this->clinicaPermitida((int)($c['id_CLINICA'] ?? 0))) return false;
        if (($_SESSION['user']['rol'] ?? '') === 'medico') {
            return (int)($c['id_MEDICO'] ?? 0) === (int)($_SESSION['user']['id_USUARIOS'] ?? 0);
        }
        return true;
    }
}

