<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ReporteModel.php';

class ReportesController extends Controller {
    public function ingresos(): void {
        $this->requireLogin(['medico','administrador','admin_sistema']);
        $rows = [];
        try { $rows = ReporteModel::ingresosPorMedico(); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->view('reportes/ingresos', ['title'=>'Ingresos por medico', 'rows'=>$rows]);
    }
}