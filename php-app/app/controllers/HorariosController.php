<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/HorarioMedicoModel.php';
require_once __DIR__ . '/../models/LogModel.php';

/**
 * Horario de atencion por medico: hora de inicio de consultas,
 * horario de comida y hora de termino. Solo restringe la cita publica.
 */
class HorariosController extends Controller {

    private const ROLES = ['medico', 'asistente', 'administrador'];

    public function index(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol'];
        $fClinica = $ctx['fClinica'];

        $medicos = [];
        try { $medicos = UsuarioModel::listarMedicos($fClinica); } catch (Throwable $e) { $medicos = []; }
        if ($rol === 'medico') {
            $yo = (int)($_SESSION['user']['id_USUARIOS'] ?? 0);
            $medicos = array_values(array_filter($medicos, fn($m) => (int)($m['id_USUARIOS'] ?? 0) === $yo));
        }

        $horarios = HorarioMedicoModel::todos();
        $rows = [];
        foreach ($medicos as $m) {
            $id = (int)($m['id_USUARIOS'] ?? 0);
            $rows[] = [
                'id_USUARIOS'     => $id,
                'nombre_completo' => (string)($m['nombre_completo'] ?? ''),
                'clinica'         => (string)($m['clinica'] ?? ''),
                'horario'         => $horarios[$id] ?? HorarioMedicoModel::porDefecto(),
            ];
        }

        $editId = $this->stateInt('edit');
        if ($editId !== null && !$this->medicoPermitido($editId, $rows)) { $editId = null; $this->clearState('edit'); }
        $editRow = null;
        foreach ($rows as $r) { if ($r['id_USUARIOS'] === $editId) { $editRow = $r; break; } }

        $this->view('horarios/index', [
            'title'          => 'Horario de atención',
            'rows'           => $rows,
            'editId'         => $editId,
            'editRow'        => $editRow,
            'rol'            => $rol,
            'fClinica'       => $fClinica,
            'clinicasFiltro' => $ctx['clinicasFiltro'],
            'clinicas'       => $ctx['clinicasFiltro'],
        ]);
    }

    /** El medico debe estar en la lista visible del usuario actual. */
    private function medicoPermitido(int $idMedico, array $rows): bool {
        foreach ($rows as $r) if ((int)$r['id_USUARIOS'] === $idMedico) return true;
        return false;
    }

    public function guardar(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol'];

        $idMedico = (int)$this->input('id_MEDICO', 0);
        $hi = $this->hora($this->input('hora_inicio', ''));
        $ci = $this->hora($this->input('comida_inicio', ''));
        $cf = $this->hora($this->input('comida_fin', ''));
        $hf = $this->hora($this->input('hora_fin', ''));

        // Solo se puede editar un medico visible para el usuario actual.
        $medicos = [];
        try { $medicos = UsuarioModel::listarMedicos($ctx['fClinica']); } catch (Throwable $e) { $medicos = []; }
        $nombre = '';
        $ok = false;
        foreach ($medicos as $m) {
            if ((int)($m['id_USUARIOS'] ?? 0) === $idMedico) { $ok = true; $nombre = (string)($m['nombre_completo'] ?? ''); break; }
        }
        if ($rol === 'medico' && $idMedico !== (int)($_SESSION['user']['id_USUARIOS'] ?? 0)) $ok = false;
        if (!$ok) {
            $this->flash('error', 'No tiene permiso para modificar el horario de ese médico.');
            $this->redirect('horarios');
        }

        $err = [];
        if ($hi === '' || $hf === '') $err[] = 'Captura la hora de inicio y la hora de término.';
        if (!$err && strtotime($hf) <= strtotime($hi)) $err[] = 'La hora de término debe ser posterior a la hora de inicio.';
        if (($ci === '') !== ($cf === '')) $err[] = 'Captura el horario de comida completo (inicio y fin) o déjalo vacío.';
        if (!$err && $ci !== '' && $cf !== '') {
            if (strtotime($cf) <= strtotime($ci)) $err[] = 'El fin de la comida debe ser posterior a su inicio.';
            elseif (strtotime($ci) < strtotime($hi) || strtotime($cf) > strtotime($hf))
                $err[] = 'El horario de comida debe estar dentro del horario de atención.';
        }
        if ($err) {
            foreach ($err as $e) $this->flash('error', $e);
            $this->redirect('horarios');
        }

        try {
            HorarioMedicoModel::guardar($idMedico, $hi, $ci, $cf, $hf);
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo guardar el horario: ' . $e->getMessage());
            $this->redirect('horarios');
        }

        $this->registrar($nombre, 'inicio de consultas ' . $hi);
        $this->registrar($nombre, $ci !== '' ? ('comida de ' . $ci . ' a ' . $cf) : 'comida sin definir');
        $this->registrar($nombre, 'fin de consultas ' . $hf);

        $this->flash('ok', 'Horario guardado.');
        $this->clearState('edit');
        $this->redirect('horarios');
    }

    /** Solo app.log: los tres renglones de citas.LOG los inserta el SP spGuardaHorarioMedico. */
    private function registrar(string $medico, string $detalle): void {
        $evento = 'el médico "' . $medico . '" definió el horario: ' . $detalle;
        if (class_exists('Database')) {
            Database::log($evento . ' | usuario=' . ($_SESSION['user']['usuario'] ?? '?')
                . ' clinica=' . ($_SESSION['f_clinica'] ?? '(n/d)'));
        }
    }

    /** Normaliza "HH:MM" (acepta HH:MM:SS). Cadena vacia si no es valida. */
    private function hora($v): string {
        $v = trim((string)$v);
        if (!preg_match('/^(\d{1,2}):(\d{2})/', $v, $m)) return '';
        $h = (int)$m[1]; $mi = (int)$m[2];
        if ($h < 0 || $h > 23 || $mi < 0 || $mi > 59) return '';
        return sprintf('%02d:%02d', $h, $mi);
    }
}
