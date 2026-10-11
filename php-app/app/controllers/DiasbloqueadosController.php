<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/DiaBloqueadoModel.php';

/**
 * Dias bloqueados en la agenda del medico (fechas en las que no da consulta).
 * Solo restringen el agendado desde la pagina publica de citas.
 */
class DiasbloqueadosController extends Controller {

    private const ROLES = ['medico', 'asistente', 'administrador'];

    public function index(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $medicos = $this->medicosVisibles($ctx);

        $idMedico = $this->stateInt('medico');
        if ($idMedico !== null && !$this->permitido($idMedico, $medicos)) { $idMedico = null; $this->clearState('medico'); }
        if ($idMedico === null && count($medicos) === 1) $idMedico = (int)$medicos[0]['id_USUARIOS'];

        $dias = $idMedico ? DiaBloqueadoModel::porMedico($idMedico, date('Y-m-d')) : [];

        $this->view('diasbloqueados/index', [
            'title'          => 'Días bloqueados',
            'medicos'        => $medicos,
            'idMedico'       => $idMedico,
            'dias'           => $dias,
            'rol'            => $ctx['rol'],
            'fClinica'       => $ctx['fClinica'],
            'clinicasFiltro' => $ctx['clinicasFiltro'],
            'clinicas'       => $ctx['clinicasFiltro'],
        ]);
    }

    /** Medicos de la clinica en contexto; el medico solo se ve a si mismo. */
    private function medicosVisibles(array $ctx): array {
        $medicos = [];
        try { $medicos = UsuarioModel::listarMedicos($ctx['fClinica']); } catch (Throwable $e) { $medicos = []; }
        if (($ctx['rol'] ?? '') === 'medico') {
            $yo = (int)($_SESSION['user']['id_USUARIOS'] ?? 0);
            $medicos = array_values(array_filter($medicos, fn($m) => (int)($m['id_USUARIOS'] ?? 0) === $yo));
        }
        return $medicos;
    }

    private function permitido(int $idMedico, array $medicos): bool {
        foreach ($medicos as $m) if ((int)($m['id_USUARIOS'] ?? 0) === $idMedico) return true;
        return false;
    }

    public function guardar(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $medicos = $this->medicosVisibles($ctx);

        $idMedico = (int)$this->input('id_MEDICO', 0);
        $desde    = $this->fecha($this->input('fecha_desde', ''));
        $hasta    = $this->fecha($this->input('fecha_hasta', ''));
        $motivo   = trim((string)$this->input('motivo', ''));
        if (strlen($motivo) > 200) $motivo = substr($motivo, 0, 200);

        if (!$this->permitido($idMedico, $medicos)) {
            $this->flash('error', 'No tiene permiso para modificar los días de ese médico.');
            $this->redirect('diasbloqueados');
        }
        if ($desde === '') {
            $this->flash('error', 'Captura la fecha que quieres bloquear.');
            $this->redirect('diasbloqueados');
        }
        if ($hasta !== '' && strtotime($hasta) < strtotime($desde)) {
            $this->flash('error', 'La fecha final debe ser igual o posterior a la inicial.');
            $this->redirect('diasbloqueados');
        }

        try {
            $n = DiaBloqueadoModel::guardar($idMedico, $desde, ($hasta !== '' ? $hasta : null), $motivo);
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo bloquear el día: ' . $e->getMessage());
            $this->redirect('diasbloqueados');
        }

        $nombre = '';
        foreach ($medicos as $m) if ((int)$m['id_USUARIOS'] === $idMedico) { $nombre = (string)($m['nombre_completo'] ?? ''); break; }
        $this->registrar('el médico "' . $nombre . '" bloqueó ' . $n . ' día(s) desde ' . $desde
            . ($hasta !== '' ? (' hasta ' . $hasta) : '') . ($motivo !== '' ? (' (' . $motivo . ')') : ''));

        $_SESSION['ui'][$this->stateNs()]['medico'] = $idMedico;
        $this->flash('ok', $n === 1 ? 'Día bloqueado.' : ($n . ' días bloqueados.'));
        $this->redirect('diasbloqueados');
    }

    public function eliminar(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $medicos = $this->medicosVisibles($ctx);

        $id = (int)$this->input('id_DIA', 0);
        $idMedico = (int)$this->input('id_MEDICO', 0);
        if ($id <= 0 || !$this->permitido($idMedico, $medicos)) {
            $this->flash('error', 'No tiene permiso para modificar los días de ese médico.');
            $this->redirect('diasbloqueados');
        }
        // El registro debe pertenecer realmente a ese medico.
        $ok = false; $fecha = '';
        foreach (DiaBloqueadoModel::porMedico($idMedico) as $d) {
            if ((int)($d['id_DIA_BLOQUEADO_MEDICO'] ?? 0) === $id) { $ok = true; $fecha = (string)($d['fecha'] ?? ''); break; }
        }
        if (!$ok) {
            $this->flash('error', 'No se encontró ese día bloqueado.');
            $this->redirect('diasbloqueados');
        }

        try { DiaBloqueadoModel::eliminar($id); }
        catch (Throwable $e) {
            $this->flash('error', 'No se pudo liberar el día: ' . $e->getMessage());
            $this->redirect('diasbloqueados');
        }

        $nombre = '';
        foreach ($medicos as $m) if ((int)$m['id_USUARIOS'] === $idMedico) { $nombre = (string)($m['nombre_completo'] ?? ''); break; }
        $this->registrar('el médico "' . $nombre . '" liberó el día: ' . $fecha);

        $_SESSION['ui'][$this->stateNs()]['medico'] = $idMedico;
        $this->flash('ok', 'Día liberado.');
        $this->redirect('diasbloqueados');
    }

    /** Solo app.log: el renglon de citas.LOG lo inserta el SP. */
    private function registrar(string $evento): void {
        if (class_exists('Database')) {
            Database::log($evento . ' | usuario=' . ($_SESSION['user']['usuario'] ?? '?')
                . ' clinica=' . ($_SESSION['f_clinica'] ?? '(n/d)'));
        }
    }

    /** Normaliza una fecha 'YYYY-MM-DD'. Cadena vacia si no es valida. */
    private function fecha($v): string {
        $v = substr(trim((string)$v), 0, 10);
        if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $v)) return '';
        return $v;
    }
}

