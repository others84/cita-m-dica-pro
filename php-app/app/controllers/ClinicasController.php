<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/MunicipioModel.php';
require_once __DIR__ . '/../models/EstadoModel.php';
require_once __DIR__ . '/../models/PaisModel.php';

class ClinicasController extends Controller {
    private const COLUMNAS_ORDEN = ['nombre', 'pais', 'estado'];

    public function index(): void {
        $this->requireLogin(['admin_sistema']);
        $editId = $this->stateInt('edit');
        $rows = $this->filas();
        $editRow = null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CLINICA']===$editId) { $editRow=$r; break; }
        $listado = $this->procesarListado($rows);
        $this->view('clinicas/index', [
            'title'=>'Clinicas','rows'=>$listado['rows'],'editId'=>$editId,'editRow'=>$editRow,
            'municipios'=>MunicipioModel::listar(),
            'estados'=>EstadoModel::listar(),
            'paises'=>PaisModel::listar(),
            'esquemas'=>ClinicaModel::ESQUEMAS,
            'pag'=>$listado['pag'],'paginas'=>$listado['paginas'],
            'totalClinicas'=>$listado['totalClinicas'],'porPagina'=>$listado['porPagina'],
            'ord'=>$listado['ord'],'dir'=>$listado['dir'],
        ]);
    }

    /** Listado de clinicas enriquecido con estado/pais del municipio. */
    private function filas(): array {
        $rows = ClinicaModel::listar();
        $mapMun = [];
        foreach (MunicipioModel::listar() as $mu) $mapMun[(int)$mu['id_CATALOGO_MUNICIPIO']] = $mu;
        foreach ($rows as $i => $r) {
            $mu = $mapMun[(int)($r['id_CATALOGO_MUNICIPIO'] ?? 0)] ?? null;
            $rows[$i]['municipio'] = $r['municipio'] ?? ($mu['nombre'] ?? '');
            $rows[$i]['estado'] = $mu['estado'] ?? '';
            $rows[$i]['pais']   = $mu['pais'] ?? '';
        }
        return $rows;
    }

    /** Ordena (nombre/pais/estado) y pagina a 15 elementos. */
    private function procesarListado(array $rows): array {
        $ord = (string)($this->stateParam('ord', 'nombre') ?? 'nombre');
        $dir = strtolower((string)($this->stateParam('dir', 'asc') ?? 'asc')) === 'desc' ? 'desc' : 'asc';
        if (!in_array($ord, self::COLUMNAS_ORDEN, true)) $ord = 'nombre';

        usort($rows, function ($a, $b) use ($ord, $dir) {
            $r = strcmp(mb_strtolower((string)($a[$ord] ?? '')), mb_strtolower((string)($b[$ord] ?? '')));
            return $dir === 'desc' ? -$r : $r;
        });

        $porPagina = 15;
        $total     = count($rows);
        $paginas   = max(1, (int)ceil($total / $porPagina));
        $pag       = (int)($this->stateParam('pag', 1) ?? 1);
        if ($pag < 1) $pag = 1;
        if ($pag > $paginas) { $pag = $paginas; $_SESSION['ui']['clinicas']['pag'] = $pag; }

        return [
            'rows' => array_slice($rows, ($pag - 1) * $porPagina, $porPagina),
            'pag' => $pag, 'paginas' => $paginas,
            'totalClinicas' => $total, 'porPagina' => $porPagina,
            'ord' => $ord, 'dir' => $dir,
        ];
    }

    /** Direccion resultante al pulsar una columna. */
    private function alternarDireccion(string $col): string {
        $actual = (string)($this->stateParam('ord', 'nombre') ?? 'nombre');
        $dir    = strtolower((string)($this->stateParam('dir', 'asc') ?? 'asc'));
        return ($actual === $col && $dir === 'asc') ? 'desc' : 'asc';
    }

    /** Solo la tabla, para actualizaciones AJAX sin refresh. */
    public function tabla(): void {
        $this->requireLogin(['admin_sistema']);
        try {
            $col = (string)($this->input('ord') ?? '');
            if ($col !== '' && in_array($col, self::COLUMNAS_ORDEN, true)) {
                $_SESSION['ui']['clinicas']['ord'] = $col;
                $_SESSION['ui']['clinicas']['dir'] = $this->alternarDireccion($col);
                $_SESSION['ui']['clinicas']['pag'] = 1;
            }
            $listado = $this->procesarListado($this->filas());
        } catch (Throwable $e) {
            http_response_code(500);
            echo htmlspecialchars($e->getMessage());
            return;
        }
        $this->partial('clinicas/_tabla', $listado + ['esquemas'=>ClinicaModel::ESQUEMAS]);
    }

    public function ordenar(): void {
        $this->requireLogin(['admin_sistema']);
        $col = (string)($this->input('ord') ?? 'nombre');
        if (!in_array($col, self::COLUMNAS_ORDEN, true)) $col = 'nombre';
        $_SESSION['ui']['clinicas']['ord'] = $col;
        $_SESSION['ui']['clinicas']['dir'] = $this->alternarDireccion($col);
        $_SESSION['ui']['clinicas']['pag'] = 1;
        $this->redirect('clinicas');
    }

    public function pagina(): void {
        $this->requireLogin(['admin_sistema']);
        $p = (int)$this->input('pag');
        $_SESSION['ui']['clinicas']['pag'] = $p > 0 ? $p : 1;
        $this->redirect('clinicas');
    }

    public function guardar(): void {
        $this->requireLogin(['admin_sistema']);
        $id = $this->intOrNull($_POST['id'] ?? null);
        try {
            $n = $this->input('nombre'); $d = $this->input('direccion');
            $e = (string)$this->input('email'); $t = (string)$this->input('telefono');
            $idMun = (int)$this->input('id_CATALOGO_MUNICIPIO');

            $esquema = (string)$this->input('esquema', 'SOLO_CLINICA');
            if (!isset(ClinicaModel::ESQUEMAS[$esquema])) $esquema = 'SOLO_CLINICA';
            $def  = ClinicaModel::ESQUEMAS[$esquema];
            $maxA = $this->limite($this->input('max_asistentes'), $def['asistentes']);
            $maxM = $this->limite($this->input('max_medicos'), $def['medicos']);
            $maxD = $this->limite($this->input('max_admins'), $def['admins']);

            if ($id) ClinicaModel::cambio($id, $n, $d, $e, $t, $idMun, $esquema, $maxA, $maxM, $maxD);
            else     $id = ClinicaModel::alta($n, $d, $e, $t, $idMun, $esquema, $maxA, $maxM, $maxD);

            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log(sprintf(
                'CLINICA GUARDADA id=%d nombre="%s" esquema=%s max_asistentes=%d max_medicos=%d max_admins=%d por usuario="%s"',
                (int)$id, (string)$n, $esquema, $maxA, $maxM, $maxD, $usr
            ));
            $this->flash('ok','Guardado.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('clinicas');
    }

    /** Normaliza un limite capturado (0..50); usa el default del esquema si viene vacio. */
    private function limite($valor, int $default): int {
        if ($valor === null || $valor === '') return $default;
        $n = (int)$valor;
        if ($n < 0) $n = 0;
        if ($n > 50) $n = 50;
        return $n;
    }

    public function eliminar(): void {
        $this->requireLogin(['admin_sistema']);
        try { ClinicaModel::baja((int)$this->input('id')); $this->flash('ok','Baja.'); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->clearState('edit');
        $this->redirect('clinicas');
    }
    public function activar(): void {
        $this->requireLogin(['admin_sistema']);
        $id = (int)$this->input('id');
        try {
            $nombre = ClinicaModel::nombre($id);
            ClinicaModel::activa($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("CLINICA ACTIVADA id={$id} nombre='{$nombre}' por usuario='{$usr}'");
            $this->flash('ok','Clinica activada.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('clinicas');
    }
    public function desactivar(): void {
        $this->requireLogin(['admin_sistema']);
        $id = (int)$this->input('id');
        try {
            $nombre = ClinicaModel::nombre($id);
            ClinicaModel::desactiva($id);
            $usr = $_SESSION['user']['usuario'] ?? '?';
            Database::log("CLINICA DESACTIVADA id={$id} nombre='{$nombre}' por usuario='{$usr}'");
            $this->flash('ok','Clinica desactivada.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('clinicas');
    }
}