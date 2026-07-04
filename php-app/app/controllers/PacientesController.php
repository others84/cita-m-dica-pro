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
        $fPais   = $this->intOrNull($_GET['f_pais']      ?? null);
        $fEstado = $this->intOrNull($_GET['f_estado']    ?? null);
        $fMun    = $this->intOrNull($_GET['f_municipio'] ?? null);
        try {
            $rows = PacienteModel::listar();
            if ($fPais || $fEstado || $fMun) {
                $rows = array_values(array_filter($rows, function ($r) use ($fPais, $fEstado, $fMun) {
                    if ($fPais   && (int)($r['id_CATALOGO_PAIS']      ?? 0) !== $fPais)   return false;
                    if ($fEstado && (int)($r['id_CATALOGO_ESTADOS']   ?? 0) !== $fEstado) return false;
                    if ($fMun    && (int)($r['id_CATALOGO_MUNICIPIO'] ?? 0) !== $fMun)    return false;
                    return true;
                }));
            }
            if ($editId) foreach ($rows as $r) if ((int)$r['id_PACIENTE'] === $editId) { $editRow = $r; break; }
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
            'fPais'     => $fPais,
            'fEstado'   => $fEstado,
            'fMunicipio'=> $fMun,
        ]);
    }

    public function guardar(): void {
        $this->requireLogin();
        $id = $this->intOrNull($_POST['id'] ?? null);
        $idClinica = (int)$this->input('id_CLINICA');
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
            if ($id) {
                PacienteModel::cambio($id, $idClinica, $apPat, $apMat, $nombre, $direccion, $tel, $email, $fnac, $idGen, $idMun);
                $this->flash('ok', 'Paciente actualizado.');
            } else {
                PacienteModel::alta($idClinica, $apPat, $apMat, $nombre, $direccion, $tel, $email, $fnac, $idGen, $idMun);
                $this->flash('ok', 'Paciente registrado.');
            }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('pacientes');
    }

    public function eliminar(): void {
        $this->requireLogin();
        $id = (int)$this->input('id');
        try { PacienteModel::baja($id); $this->flash('ok','Paciente eliminado.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('pacientes');
    }
}