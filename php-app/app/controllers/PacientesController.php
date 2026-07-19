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
        $editId = $this->intOrNull($_GET['edit'] ?? null);
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
                    'PACIENTES.index rol=%s user=%s get_f_clinica=%s session_f_clinica=%s fClinica=%s clinicasFiltro=[%s] rows=%d editId=%s editFound=%s',
                    $rol,
                    $_SESSION['user']['usuario'] ?? '?',
                    $_GET['f_clinica'] ?? 'NULL',
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
        $apPat = (string)$this->input('ap_paterno');
        $apMat = (string)$this->input('ap_materno');
        $nombre = (string)$this->input('nombre');
        $direccion = (string)$this->input('direccion');
        $tel = (string)$this->input('telefono');
        $email = (string)$this->input('email');
        $fnac = (string)$this->input('fecha_nacimiento');
        $idGen = (int)$this->input('id_CATALOGO_GENERO');
        $idMun = (int)$this->input('id_CATALOGO_MUNICIPIO');
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
                PacienteModel::cambio($id, $idClinica, $apPat, $apMat, $nombre, $direccion, $tel, $email, $fnac, $idGen, $idMun);
                $this->flash('ok', 'Paciente actualizado.');
            } else {
                PacienteModel::alta($idClinica, $apPat, $apMat, $nombre, $direccion, $tel, $email, $fnac, $idGen, $idMun);
                $this->flash('ok', 'Paciente registrado.');
            }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('pacientes' . ($idClinica ? '?f_clinica=' . $idClinica : ''));
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
        $this->redirect('pacientes' . ($fClinica ? '?f_clinica=' . $fClinica : ''));
    }
}