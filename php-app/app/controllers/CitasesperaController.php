<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/CitaModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';

/**
 * "Citas en espera": citas marcadas para adelantarse si se libera un espacio.
 * La marca se conserva al moverla; se quita al cancelar, atender o "No asistio".
 */
class CitasesperaController extends Controller {
    private const ROLES = ['asistente', 'medico', 'administrador'];

    public function index(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol'];
        $fClinica = $ctx['fClinica'];
        $ui = $_SESSION['ui']['citasespera'] ?? [];
        $idMedSes = $rol === 'medico' ? (int)($_SESSION['user']['id_USUARIOS'] ?? 0) : null;
        $fMedico = $idMedSes ?: ((int)($ui['medico'] ?? 0) ?: null);

        $citas = []; $medicos = [];
        try {
            $citas = CitaModel::enEspera($fMedico, $fClinica);
            if ($rol !== 'medico') $medicos = UsuarioModel::listarMedicos($fClinica);
        } catch (Throwable $e) {
            $this->flash('error', 'Error al cargar las citas en espera: ' . $e->getMessage());
        }

        // Cita seleccionada para adelantar.
        $sel = null; $libres = [];
        $idSel = (int)($ui['sel'] ?? 0);
        if ($idSel) {
            $c = CitaModel::obtener($idSel);
            if ($c && $this->citaPermitida($c) && CitaModel::estadoActivo($c)) {
                $sel = $c;
                try { $libres = CitaModel::horariosLibres($c); }
                catch (Throwable $e) { $this->flash('error', 'No se pudieron calcular los horarios: ' . $e->getMessage()); }
            } else {
                unset($_SESSION['ui']['citasespera']['sel']);
            }
        }
        // Cita recien movida (para ofrecer el aviso por WhatsApp).
        $movida = null;
        if (!empty($ui['movida'])) {
            $m = CitaModel::obtener((int)$ui['movida']);
            if ($m && $this->citaPermitida($m)) $movida = $m;
            unset($_SESSION['ui']['citasespera']['movida']);
        }

        $this->view('citasespera/index', [
            'title'          => 'Citas en espera',
            'citas'          => $citas,
            'medicos'        => $medicos,
            'fMedico'        => $fMedico,
            'sel'            => $sel,
            'libres'         => $libres,
            'movida'         => $movida,
            'hoy'            => substr(CitaModel::ahoraSql(), 0, 10),
            'clinicas'       => ClinicaModel::listar(),
            'clinicasFiltro' => $ctx['clinicasFiltro'],
            'fClinica'       => $fClinica,
            'rol'            => $rol,
        ]);
    }

    public function filtrar(): void {
        $this->requireLogin(self::ROLES);
        $_SESSION['ui']['citasespera']['medico'] = (int)$this->input('f_medico');
        unset($_SESSION['ui']['citasespera']['sel']);
        $this->redirect('citasespera');
    }

    /** Abre el panel de horarios libres de una cita. */
    public function adelantar(): void {
        $this->requireLogin(self::ROLES);
        $id = (int)$this->input('id');
        $c = $id ? CitaModel::obtener($id) : null;
        if (!$c || !$this->citaPermitida($c)) {
            $this->denegarRecurso('CITA', $id, $c ? (int)($c['id_CLINICA'] ?? 0) : null, 'citasespera');
            return;
        }
        $_SESSION['ui']['citasespera']['sel'] = $id;
        $this->redirect('citasespera');
    }

    public function cerrar(): void {
        $this->requireLogin(self::ROLES);
        unset($_SESSION['ui']['citasespera']['sel']);
        $this->redirect('citasespera');
    }

    /** Quita la cita de la lista de espera sin moverla. */
    public function quitar(): void {
        $this->requireLogin(self::ROLES);
        $id = (int)$this->input('id');
        $c = $id ? CitaModel::obtener($id) : null;
        if (!$c || !$this->citaPermitida($c)) {
            $this->denegarRecurso('CITA', $id, $c ? (int)($c['id_CLINICA'] ?? 0) : null, 'citasespera');
            return;
        }
        try {
            CitaModel::marcaEspera($id, false);
            $this->flash('ok', 'La cita se quitó de la lista de espera.');
        } catch (Throwable $e) { $this->flash('error', 'No se pudo quitar: ' . $e->getMessage()); }
        unset($_SESSION['ui']['citasespera']['sel']);
        $this->redirect('citasespera');
    }

    /** Mueve la cita al horario elegido (misma duracion, medico, consultorio y precio). */
    public function mover(): void {
        $this->requireLogin(self::ROLES);
        $id = (int)$this->input('id');
        $slot = (string)$this->input('slot'); // 'Y-m-d H:i'
        $c = $id ? CitaModel::obtener($id) : null;
        if (!$c || !$this->citaPermitida($c)) {
            $this->denegarRecurso('CITA', $id, $c ? (int)($c['id_CLINICA'] ?? 0) : null, 'citasespera');
            return;
        }
        try {
            if (!CitaModel::estadoActivo($c)) throw new RuntimeException('La cita ya no está agendada ni confirmada.');
            if (!preg_match('/^(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2})$/', $slot, $m)) throw new RuntimeException('Seleccione un horario.');
            [$_, $fecha, $hora] = $m;
            // Revalidar que el horario siga libre.
            $libres = CitaModel::horariosLibres($c);
            if (!in_array($hora, $libres[$fecha] ?? [], true)) {
                throw new RuntimeException('Ese horario ya no está disponible. Elija otro.');
            }
            $fmt = fn($v, string $f) => $v instanceof DateTime ? $v->format($f) : (string)$v;
            $fAnt = substr($fmt($c['fecha_cita'], 'Y-m-d'), 0, 10);
            $hiAnt = substr($fmt($c['hora_inicio'], 'H:i'), 0, 5);
            $hfAnt = substr($fmt($c['hora_fin'], 'H:i'), 0, 5);
            $dur = (strtotime("2000-01-01 $hfAnt") - strtotime("2000-01-01 $hiAnt")) ?: 1800;
            $hf = date('H:i', strtotime("2000-01-01 $hora") + $dur);
            CitaModel::cambio($id, [
                'id_PACIENTE'              => (int)$c['id_PACIENTE'],
                'id_MEDICO'                => (int)$c['id_MEDICO'],
                'id_CONSULTORIO'           => (int)$c['id_CONSULTORIO'],
                'id_CATALOGO_ESPECIALIDAD' => (int)$c['id_CATALOGO_ESPECIALIDAD'],
                'fecha_cita'               => $fecha,
                'hora_inicio'              => $hora . ':00',
                'hora_fin'                 => $hf . ':00',
                'id_CATALOGO_ESTADO_CITAS' => (int)$c['id_CATALOGO_ESTADO_CITAS'],
                'observaciones'            => (string)($c['observaciones'] ?? ''),
                'horas_anticipacion_notif' => (int)($c['horas_anticipacion_notif'] ?? 24),
                'precio'                   => (float)($c['precio'] ?? 0),
            ]);
            $sigue = (string)$this->input('en_espera') === '1';
            if (!$sigue) CitaModel::marcaEspera($id, false);
            Database::log('CITA ADELANTADA id_CITA=' . $id
                . ' antes=' . $fAnt . ' ' . $hiAnt . ' ahora=' . $fecha . ' ' . $hora
                . ' en_espera=' . ($sigue ? '1' : '0')
                . ' usuario=' . (string)($_SESSION['user']['usuario'] ?? '?'));
            $this->flash('ok', 'Cita movida al ' . date('d/m/Y', strtotime($fecha)) . ' a las ' . $hora
                . ($sigue ? '. Sigue en espera por si se libera otro espacio antes.' : '. Ya no aparecerá en la lista de espera.'));
            unset($_SESSION['ui']['citasespera']['sel']);
            $_SESSION['ui']['citasespera']['movida'] = $id;
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo mover la cita: ' . $e->getMessage());
        }
        $this->redirect('citasespera');
    }

    private function citaPermitida(?array $c): bool {
        if (!$c) return false;
        if (!$this->clinicaPermitida((int)($c['id_CLINICA'] ?? 0))) return false;
        if (($_SESSION['user']['rol'] ?? '') === 'medico') {
            return (int)($c['id_MEDICO'] ?? 0) === (int)($_SESSION['user']['id_USUARIOS'] ?? 0);
        }
        return true;
    }
}
