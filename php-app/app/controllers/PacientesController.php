<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/PacienteModel.php';
require_once __DIR__ . '/../models/GeneroModel.php';
require_once __DIR__ . '/../models/MunicipioModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/PaisModel.php';
require_once __DIR__ . '/../models/EstadoModel.php';

class PacientesController extends Controller {
    public function index(): void {
        $this->requireLogin();
        $editId = $this->stateInt('edit');
        $editRow = null;
        $rows = [];
        $ctx = $this->resolveClinicaContext();
        $rol = $ctx['rol']; $fClinica = $ctx['fClinica']; $clinicasFiltro = $ctx['clinicasFiltro'];
        try {
            $rows = PacienteModel::listar($fClinica);
            if ($editId) foreach ($rows as $r) if ((int)$r['id_PACIENTE'] === $editId) { $editRow = $r; break; }
            if (class_exists('Database')) {
                $idsFiltro = array_map(fn($c) => (int)($c['id_CLINICA'] ?? 0), $clinicasFiltro);
                Database::log(sprintf(
                    'PACIENTES.index rol=%s user=%s post_f_clinica=%s session_f_clinica=%s fClinica=%s clinicasFiltro=[%s] rows=%d editId=%s editFound=%s',
                    $rol,
                    $_SESSION['user']['usuario'] ?? '?',
                    $_POST['f_clinica'] ?? 'NO_POST',
                    $_SESSION['f_clinica'] ?? 'NULL',
                    $fClinica ?? 'NULL',
                    implode(',', $idsFiltro),
                    count($rows),
                    $editId ?? 'NULL',
                    $editRow ? 'SI' : 'NO'
                ));
            }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->view('pacientes/index', [
            'title'    => 'Pacientes',
            'rows'     => $rows,
            'editId'   => $editId,
            'editRow'  => $editRow,
            'generos'   => GeneroModel::listar(),
            'municipios'=> MunicipioModel::listar(),
            'clinicas'  => ClinicaModel::listar(),
            'paises'    => PaisModel::listar(),
            'estados'   => EstadoModel::listar(),
            'fClinica'  => $fClinica,
            'rol'       => $rol,
            'clinicasFiltro' => $clinicasFiltro,
        ]);
    }

    public function guardar(): void {
        $this->requireLogin();
        $id = $this->intOrNull($_POST['id'] ?? null);
        $idClinica = (int)$this->input('id_CLINICA');
        $ctx = $this->resolveClinicaContext();
        $idsPermitidos = array_map(fn($c) => (int)($c['id_CLINICA'] ?? 0), $ctx['clinicasFiltro'] ?? []);
        if (($ctx['rol'] ?? '') !== 'admin_sistema' && !empty($idsPermitidos) && !in_array($idClinica, $idsPermitidos, true)) {
            $idClinica = (int)($ctx['fClinica'] ?? 0);
        }
        if ($idClinica <= 0) $idClinica = (int)($ctx['fClinica'] ?? $_SESSION['f_clinica'] ?? 0);
        if ($idClinica <= 0) {
            $this->flash('error', 'Selecciona una clinica en el filtro antes de guardar el paciente.');
            $this->redirect('pacientes');
            return;
        }
        $apPat = trim((string)$this->input('ap_paterno'));
        $apMat = trim((string)$this->input('ap_materno'));
        $nombre = trim((string)$this->input('nombre'));
        $direccion = trim((string)$this->input('direccion'));
        $tel = trim((string)$this->input('telefono'));
        $email = trim((string)$this->input('email'));
        $fnac = trim((string)$this->input('fecha_nacimiento'));
        $idGen = (int)$this->input('id_CATALOGO_GENERO');
        $idMun = (int)$this->input('id_CATALOGO_MUNICIPIO');
        $observaciones = trim((string)$this->input('observaciones'));
        $notifEmail = !empty($_POST['notifica_email']) ? 1 : 0;
        $notifWa    = !empty($_POST['notifica_wa']) ? 1 : 0;

        // Todas las columnas de PACIENTE son NOT NULL y el email tiene CHECK de formato.
        $faltantes = [];
        if ($apPat === '') $faltantes[] = 'apellido paterno';
        if ($apMat === '') $faltantes[] = 'apellido materno';
        if ($nombre === '') $faltantes[] = 'nombre';
        if ($direccion === '') $faltantes[] = 'direccion';
        if ($tel === '') $faltantes[] = 'telefono';
        if ($fnac === '') $faltantes[] = 'fecha de nacimiento';
        if ($idGen <= 0) $faltantes[] = 'genero';
        if ($idMun <= 0) $faltantes[] = 'municipio';
        if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) $faltantes[] = 'email valido';
        if ($faltantes) {
            $msg = 'Faltan datos obligatorios: ' . implode(', ', $faltantes) . '.';
            if (class_exists('Database')) Database::log('PACIENTES.guardar VALIDACION user=' . ($_SESSION['user']['usuario'] ?? '?') . ' ' . $msg);
            $this->flash('error', $msg);
            $this->redirect('pacientes');
            return;
        }
        try {
            if (class_exists('Database')) {
                Database::log(sprintf(
                    'PACIENTES.guardar rol=%s user=%s id=%s post_id_CLINICA=%s fClinica=%s idsPermitidos=[%s] idClinicaFinal=%s',
                    $_SESSION['user']['rol'] ?? '?',
                    $_SESSION['user']['usuario'] ?? '?',
                    $id ?? 'NULL',
                    $_POST['id_CLINICA'] ?? 'NULL',
                    $ctx['fClinica'] ?? 'NULL',
                    implode(',', $idsPermitidos),
                    $idClinica
                ));
            }
            if ($id) {
                PacienteModel::cambio($id, $idClinica, $apPat, $apMat, $nombre, $direccion, $tel, $email, $fnac, $idGen, $idMun, $observaciones, $notifEmail, $notifWa);
                $this->flash('ok', 'Paciente actualizado.');
            } else {
                PacienteModel::alta($idClinica, $apPat, $apMat, $nombre, $direccion, $tel, $email, $fnac, $idGen, $idMun, $observaciones, $notifEmail, $notifWa);
                $this->flash('ok', 'Paciente registrado.');
            }
        } catch (Throwable $e) {
            if (class_exists('Database')) Database::log('PACIENTES.guardar ERROR user=' . ($_SESSION['user']['usuario'] ?? '?') . ' id=' . ($id ?? 'NULL') . ' msg=' . $e->getMessage());
            $this->flash('error', $e->getMessage());
        }
        $this->clearState('edit');
        $this->redirect('pacientes');
    }

    public function eliminar(): void {
        $this->requireLogin();
        $id = (int)$this->input('id');
        try { PacienteModel::baja($id); $this->flash('ok','Paciente eliminado.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $fClinica = (int)($_SESSION['f_clinica'] ?? 0);
        if (class_exists('Database')) {
            Database::log(sprintf(
                'PACIENTES.eliminar user=%s id=%d redirect_f_clinica=%s',
                $_SESSION['user']['usuario'] ?? '?',
                $id,
                $fClinica ?: 'NULL'
            ));
        }
        $this->clearState('edit');
        $this->redirect('pacientes');
    }
}