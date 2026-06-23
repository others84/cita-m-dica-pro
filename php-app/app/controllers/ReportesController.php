<?php
namespace App\Controllers;
use App\Core\Controller;
class ReportesController extends Controller {
    public function ingresos(): void { $this->view('reportes/ingresos'); }
}
