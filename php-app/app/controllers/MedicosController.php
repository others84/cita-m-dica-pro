<?php
namespace App\Controllers;
use App\Core\Controller;
class MedicosController extends Controller {
    public function index(): void { $this->view('admin/medicos'); }
}
