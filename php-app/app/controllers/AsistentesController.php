<?php
namespace App\Controllers;
use App\Core\Controller;
class AsistentesController extends Controller {
    public function index(): void { $this->view('medico/asistentes'); }
}
