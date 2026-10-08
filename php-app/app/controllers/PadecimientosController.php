<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/PadecimientoModel.php';

/**
 * Catalogo de padecimientos (con precio) de cada medico.
 * Medico: solo los suyos. Administrador de clinica: medicos de sus clinicas.
 */
class PadecimientosController extends Controller {

    private const ROLES = ['medico', 'administrador'];

    public function index(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $medicos = $this->medicosVisibles($ctx);

        $idMedico = $this->stateInt('medico');
        if ($idMedico !== null && !$this->permitido($idMedico, $medicos)) { $idMedico = null; $this->clearState('medico'); }
        if ($idMedico === null && count($medicos) === 1) $idMedico = (int)$medicos[0]['id_USUARIOS'];

        $this->view('padecimientos/index', [
            'title'          => 'Padecimientos',
            'medicos'        => $medicos,
            'idMedico'       => $idMedico,
            'items'          => $idMedico ? PadecimientoModel::porMedico($idMedico) : [],
            'editId'         => (int)($this->input('editar', 0)),
            'rol'            => $ctx['rol'],
            'fClinica'       => $ctx['fClinica'],
            'clinicasFiltro' => $ctx['clinicasFiltro'],
            'clinicas'       => $ctx['clinicasFiltro'],
        ]);
    }

    public function guardar(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $medicos = $this->medicosVisibles($ctx);

        $idMedico = (int)$this->input('id_MEDICO', 0);
        $id       = (int)$this->input('id_PADECIMIENTO', 0);
        $nombre   = trim((string)$this->input('nombre', ''));
        $precio   = (float)str_replace(',', '', (string)$this->input('precio', '0'));
        $activo   = !empty($_POST['activo']) || $id === 0;

        if (!$this->permitido($idMedico, $medicos)) {
            $this->flash('error', 'No tiene permiso para modificar los padecimientos de ese médico.');
            $this->redirect('padecimientos');
        }
        if ($nombre === '' || mb_strlen($nombre) > 150) {
            $this->flash('error', 'Captura el nombre del padecimiento (máximo 150 caracteres).');
            $this->redirect('padecimientos');
        }
        if ($precio < 0 || $precio > 99999999) {
            $this->flash('error', 'El precio no es válido.');
            $this->redirect('padecimientos');
        }
        // Nombre repetido para el mismo medico.
        $lista = PadecimientoModel::porMedico($idMedico);
        foreach ($lista as $p) {
            if ((int)$p['id_PADECIMIENTO'] !== $id && mb_strtolower(trim((string)$p['nombre'])) === mb_strtolower($nombre)) {
                $this->flash('error', 'Ese padecimiento ya existe para este médico.');
                $this->redirect('padecimientos');
            }
        }

        try {
            if ($id > 0) {
                if (!$this->pertenece($id, $lista)) {
                    $this->flash('error', 'No se encontró ese padecimiento.');
                    $this->redirect('padecimientos');
                }
                PadecimientoModel::cambio($id, $nombre, $precio, $activo);
                $this->flash('ok', 'Padecimiento actualizado.');
            } else {
                PadecimientoModel::alta($idMedico, $nombre, $precio);
                $this->flash('ok', 'Padecimiento agregado.');
            }
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo guardar: ' . $e->getMessage());
        }
        Database::log('PADECIMIENTOS guardar medico=' . $idMedico . ' id=' . $id . ' nombre=' . $nombre
            . ' precio=' . $precio . ' usuario=' . ($_SESSION['user']['usuario'] ?? '?'));
        $_SESSION['ui'][$this->stateNs()]['medico'] = $idMedico;
        $this->redirect('padecimientos');
    }

    /** Activa / desactiva (no se borra para conservar el historial de citas). */
    public function activo(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $medicos = $this->medicosVisibles($ctx);
        $idMedico = (int)$this->input('id_MEDICO', 0);
        $id = (int)$this->input('id_PADECIMIENTO', 0);
        if (!$this->permitido($idMedico, $medicos)) {
            $this->flash('error', 'No tiene permiso para modificar los padecimientos de ese médico.');
            $this->redirect('padecimientos');
        }
        foreach (PadecimientoModel::porMedico($idMedico) as $p) {
            if ((int)$p['id_PADECIMIENTO'] === $id) {
                $nuevo = empty($p['activo']);
                try {
                    PadecimientoModel::cambio($id, (string)$p['nombre'], (float)$p['precio'], $nuevo);
                    $this->flash('ok', $nuevo ? 'Padecimiento activado.' : 'Padecimiento desactivado.');
                } catch (Throwable $e) { $this->flash('error', 'No se pudo actualizar: ' . $e->getMessage()); }
                break;
            }
        }
        $_SESSION['ui'][$this->stateNs()]['medico'] = $idMedico;
        $this->redirect('padecimientos');
    }

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

    private function pertenece(int $id, array $lista): bool {
        foreach ($lista as $p) if ((int)$p['id_PADECIMIENTO'] === $id) return true;
        return false;
    }
}
