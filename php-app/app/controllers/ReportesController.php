<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ReporteModel.php';
require_once __DIR__ . '/../models/CitaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';

class ReportesController extends Controller {
    public function ingresos(): void {
        $this->requireLogin(['medico','administrador','admin_sistema']);
        $f = $this->filtros('rep_ing_medico');
        $rows = [];
        try { $rows = ReporteModel::ingresosPorMedico($f['fClinica'], $f['ini'], $f['fin']); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        // Grafica: ingresos acumulados (suma de precios) por dia (citas atendidas).
        $serie = [];
        foreach ($this->citasAtendidas($f) as $c) {
            $d = self::fecha($c['fecha_cita']);
            $serie[$d] = ($serie[$d] ?? 0) + (float)($c['precio'] ?? 0);
        }
        ksort($serie);
        // Etiquetas legibles dd/mm para el eje X.
        $grafica = [];
        foreach ($serie as $d => $v) {
            $grafica[date('d/m', strtotime($d))] = $v;
        }
        $this->view('reportes/ingresos', $f + [
            'title'   => 'Ingresos por medico',
            'rows'    => $rows,
            'serie'   => $grafica,
            'total'   => array_sum($serie),
            'destino' => 'reportes/ingresos',
        ]);
    }

    /* ================= Reportes graficos ================= */

    private const ROLES_REP = ['administrador','admin_sistema'];

    /** Filtros comunes: clinica (contexto), medico, fecha inicio/fin (mes vigente por default). */
    private function filtros(string $ns): array {
        $ctx = $this->resolveClinicaContext();
        $ini = (string)$this->stateParam('f_ini', date('Y-m-01'), $ns);
        $fin = (string)$this->stateParam('f_fin', date('Y-m-t'), $ns);
        $med = $this->stateInt('f_medico', $ns);
        $medicos = [];
        try { $medicos = UsuarioModel::listarMedicos($ctx['fClinica']); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $ids = array_map(fn($m) => (int)$m['id_USUARIOS'], $medicos);
        if ($med !== null && !in_array($med, $ids, true)) { $med = null; $this->clearState('f_medico', $ns); }
        return $ctx + ['ini'=>$ini, 'fin'=>$fin, 'medico'=>$med, 'medicos'=>$medicos, 'ns'=>$ns];
    }

    /** Citas atendidas en el rango, ya filtradas por clinica/medico. */
    private function citasAtendidas(array $f): array {
        $rows = [];
        try { $rows = CitaModel::listar($f['medico'], $f['ini'], $f['fin'], $f['fClinica']); }
        catch (Throwable $e) { $this->flash('error', $e->getMessage()); return []; }
        return array_values(array_filter($rows, function ($c) {
            $e = strtolower(trim((string)($c['estado'] ?? '')));
            return $e === 'atendida' || $e === 'atendido';
        }));
    }

    private static function fecha($v): string {
        return $v instanceof DateTime ? $v->format('Y-m-d') : substr((string)$v, 0, 10);
    }

    public function filtrar(): void {
        $this->requireLogin(self::ROLES_REP);
        $destino = (string)$this->input('destino', 'reportes/repIngresos');
        $permitidos = ['reportes/repIngresos','reportes/repAtencion','reportes/repTop10','reportes/repEspecialidad','reportes/ingresos'];
        if (!in_array($destino, $permitidos, true)) $destino = 'reportes/repIngresos';
        $ns = (string)$this->input('ns', 'rep');
        $this->stateParam('f_ini', null, $ns);
        $this->stateParam('f_fin', null, $ns);
        $this->stateParam('f_medico', null, $ns);
        $this->redirect($destino);
    }

    /** Ingresos: suma del costo de las citas atendidas por dia. */
    public function repIngresos(): void {
        $this->requireLogin(self::ROLES_REP);
        $f = $this->filtros('rep_ingresos');
        $serie = [];
        foreach ($this->citasAtendidas($f) as $c) {
            $d = self::fecha($c['fecha_cita']);
            $serie[$d] = ($serie[$d] ?? 0) + (float)($c['precio'] ?? 0);
        }
        ksort($serie);
        $grafica = [];
        foreach ($serie as $d => $v) {
            $grafica[date('d/m', strtotime($d))] = $v;
        }
        $this->view('reportes/rep_ingresos', $f + [
            'title' => 'Ingresos por citas',
            'serie' => $grafica,
            'total' => array_sum($serie),
            'destino' => 'reportes/repIngresos',
        ]);
    }

    /** Citas atendidas por dia. */
    public function repAtencion(): void {
        $this->requireLogin(self::ROLES_REP);
        $f = $this->filtros('rep_atencion');
        $serie = [];
        foreach ($this->citasAtendidas($f) as $c) {
            $d = self::fecha($c['fecha_cita']);
            $serie[$d] = ($serie[$d] ?? 0) + 1;
        }
        arsort($serie);
        $this->view('reportes/rep_atencion', $f + [
            'title' => 'Reporte de atencion',
            'serie' => $serie,
            'total' => array_sum($serie),
            'destino' => 'reportes/repAtencion',
        ]);
    }

    /** Top 10 medicos por citas atendidas y por ingresos. */
    public function repTop10(): void {
        $this->requireLogin(self::ROLES_REP);
        $f = $this->filtros('rep_top10');
        $cant = []; $din = [];
        foreach ($this->citasAtendidas($f) as $c) {
            $m = (string)($c['medico'] ?? '-');
            $cant[$m] = ($cant[$m] ?? 0) + 1;
            $din[$m]  = ($din[$m] ?? 0) + (float)($c['precio'] ?? 0);
        }
        arsort($cant); arsort($din);
        $this->view('reportes/rep_top10', $f + [
            'title'   => 'Top 10 medicos',
            'cant'    => array_slice($cant, 0, 10, true),
            'dinero'  => array_slice($din, 0, 10, true),
            'destino' => 'reportes/repTop10',
        ]);
    }

    /** Porcentaje de citas atendidas por especialidad. */
    public function repEspecialidad(): void {
        $this->requireLogin(self::ROLES_REP);
        $f = $this->filtros('rep_especialidad');
        $serie = [];
        foreach ($this->citasAtendidas($f) as $c) {
            $e = (string)($c['especialidad'] ?? '-');
            $serie[$e] = ($serie[$e] ?? 0) + 1;
        }
        arsort($serie);
        $this->view('reportes/rep_especialidad', $f + [
            'title'   => 'Atencion por especialidad',
            'serie'   => $serie,
            'total'   => array_sum($serie),
            'destino' => 'reportes/repEspecialidad',
        ]);
    }
}