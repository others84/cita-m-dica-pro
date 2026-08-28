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
        $listado = ['rows'=>[],'pag'=>1,'paginas'=>1,'totalPacientes'=>0,'porPagina'=>15,'ord'=>'nombre','dir'=>'asc'];
        try {
            $rows = PacienteModel::listar($fClinica);
            if ($editId) foreach ($rows as $r) if ((int)$r['id_PACIENTE'] === $editId) { $editRow = $r; break; }
            $listado = $this->procesarListado($rows);

            if (class_exists('Database')) {
                $idsFiltro = array_map(fn($c) => (int)($c['id_CLINICA'] ?? 0), $clinicasFiltro);
                Database::log(sprintf(
                    'PACIENTES.index rol=%s user=%s post_f_clinica=%s session_f_clinica=%s fClinica=%s clinicasFiltro=[%s] rows=%d editId=%s editFound=%s pag=%d paginas=%d total=%d',
                    $rol,
                    $_SESSION['user']['usuario'] ?? '?',
                    $_POST['f_clinica'] ?? 'NO_POST',
                    $_SESSION['f_clinica'] ?? 'NULL',
                    $fClinica ?? 'NULL',
                    implode(',', $idsFiltro),
                    count($listado['rows']),
                    $editId ?? 'NULL',
                    $editRow ? 'SI' : 'NO',
                    $listado['pag'],
                    $listado['paginas'],
                    $listado['totalPacientes']
                ));
            }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->view('pacientes/index', [
            'title'    => 'Pacientes',
            'rows'     => $listado['rows'],
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
            'pag'        => $listado['pag'],
            'paginas'    => $listado['paginas'],
            'totalPacientes' => $listado['totalPacientes'],
            'porPagina'  => $listado['porPagina'],
            'ord'        => $listado['ord'],
            'dir'        => $listado['dir'],
        ]);
    }

    /**
     * Ordena y pagina el listado de pacientes.
     * Persiste ord/dir/pag en sesion via stateParam.
     */
    private function procesarListado(array $rows): array {
        $ord = (string)($this->stateParam('ord', 'nombre') ?? 'nombre');
        $dir = strtolower((string)($this->stateParam('dir', 'asc') ?? 'asc')) === 'desc' ? 'desc' : 'asc';
        $permitidas = ['nombre', 'fecha_nacimiento', 'pais'];
        if (!in_array($ord, $permitidas, true)) $ord = 'nombre';

        $val = function ($v, string $f) {
            if ($v instanceof DateTime) return $v->format($f);
            return (string)$v;
        };
        $key = function (array $p) use ($ord, $val) {
            switch ($ord) {
                case 'fecha_nacimiento':
                    return substr($val($p['fecha_nacimiento'] ?? '', 'Y-m-d'), 0, 10);
                case 'pais':
                    return mb_strtolower((string)($p['pais'] ?? ''));
                case 'nombre':
                default:
                    return mb_strtolower(
                        trim(($p['ap_paterno'] ?? '') . ' ' . ($p['ap_materno'] ?? '') . ' ' . ($p['nombre'] ?? ''))
                    );
            }
        };
        usort($rows, function ($a, $b) use ($key, $dir) {
            $r = strcmp($key($a), $key($b));
            return $dir === 'desc' ? -$r : $r;
        });

        $porPagina = 15;
        $total     = count($rows);
        $paginas   = max(1, (int)ceil($total / $porPagina));
        $pag       = (int)($this->stateParam('pag', 1) ?? 1);
        if ($pag < 1) $pag = 1;
        if ($pag > $paginas) { $pag = $paginas; $_SESSION['ui']['pacientes']['pag'] = $pag; }
        $rows = array_slice($rows, ($pag - 1) * $porPagina, $porPagina);

        return [
            'rows' => $rows,
            'pag' => $pag,
            'paginas' => $paginas,
            'totalPacientes' => $total,
            'porPagina' => $porPagina,
            'ord' => $ord,
            'dir' => $dir,
        ];
    }

    /** Devuelve solo la tabla de pacientes para actualizaciones AJAX sin refresh. */
    public function tabla(): void {
        $this->requireLogin();
        $ctx = $this->resolveClinicaContext();
        try {
            $rows = PacienteModel::listar($ctx['fClinica']);
            $listado = $this->procesarListado($rows);
        } catch (Throwable $e) {
            http_response_code(500);
            echo htmlspecialchars($e->getMessage());
            return;
        }
        $this->partial('pacientes/_tabla', [
            'rows' => $listado['rows'],
            'pag' => $listado['pag'],
            'paginas' => $listado['paginas'],
            'totalPacientes' => $listado['totalPacientes'],
            'porPagina' => $listado['porPagina'],
            'ord' => $listado['ord'],
            'dir' => $listado['dir'],
        ]);
    }

    /** Cambia la columna/direccion de ordenamiento de la tabla de pacientes. */
    public function ordenar(): void {
        $this->requireLogin();
        $col = (string)($this->input('ord') ?? 'nombre');
        $permitidas = ['nombre', 'fecha_nacimiento', 'pais'];
        if (!in_array($col, $permitidas, true)) $col = 'nombre';
        $actual = (string)($this->stateParam('ord', 'nombre') ?? 'nombre');
        $dir    = strtolower((string)($this->stateParam('dir', 'asc') ?? 'asc'));
        $nuevo  = ($actual === $col && $dir === 'asc') ? 'desc' : 'asc';
        $_SESSION['ui']['pacientes']['ord'] = $col;
        $_SESSION['ui']['pacientes']['dir'] = $nuevo;
        $_SESSION['ui']['pacientes']['pag'] = 1;
        $this->redirect('pacientes');
    }

    /** Cambia la pagina de la tabla de pacientes. */
    public function pagina(): void {
        $this->requireLogin();
        $p = (int)$this->input('pag');
        $_SESSION['ui']['pacientes']['pag'] = $p > 0 ? $p : 1;
        $this->redirect('pacientes');
    }

    public function guardar(): void {
        $this->requireLogin();
        $id = $this->intOrNull($_POST['id'] ?? null);
        $idClinica = (int)$this->input('id_CLINICA');
        $ctx = $this->resolveClinicaContext();
        // IDOR: al editar, el paciente destino debe pertenecer a una clinica
        // autorizada para el usuario (no basta con validar la clinica enviada).
        if ($id) {
            $actual = PacienteModel::obtener((int)$id);
            if (!$actual || !$this->clinicaPermitida((int)($actual['id_CLINICA'] ?? 0))) {
                $this->clearState('edit');
                $this->denegarRecurso('PACIENTE', $id, $actual ? (int)($actual['id_CLINICA'] ?? 0) : null, 'pacientes');
                return;
            }
        }
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
                $cliEsperada = isset($actual) && $actual ? (int)($actual['id_CLINICA'] ?? 0) : null;
                PacienteModel::cambio($id, $idClinica, $apPat, $apMat, $nombre, $direccion, $tel, $email, $fnac, $idGen, $idMun, $observaciones, $notifEmail, $notifWa, $cliEsperada ?: null);
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
        $actual = $id ? PacienteModel::obtener($id) : null;
        if (!$actual || !$this->clinicaPermitida((int)($actual['id_CLINICA'] ?? 0))) {
            $this->clearState('edit');
            $this->denegarRecurso('PACIENTE', $id, $actual ? (int)($actual['id_CLINICA'] ?? 0) : null, 'pacientes');
            return;
        }
        try { PacienteModel::baja($id, ((int)($actual['id_CLINICA'] ?? 0)) ?: null); $this->flash('ok','Paciente eliminado.'); }
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