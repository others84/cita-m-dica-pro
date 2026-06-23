<?php
namespace App\Controllers;
use App\Core\Controller;
class CitasController extends Controller {
    public function agendar():   void { $this->view('citas/agendar'); }
    public function modificar(): void { $this->view('citas/modificar'); }
    public function cancelar():  void { $this->view('citas/cancelar'); }
}
