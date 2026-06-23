<?php
namespace App\Controllers;
use App\Core\Controller;
class OpcionesController extends Controller {
    public function password(): void { $this->view('opciones/password'); }
    public function datos():    void { $this->view('opciones/datos'); }
}
