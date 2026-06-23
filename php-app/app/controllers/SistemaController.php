<?php
namespace App\Controllers;
use App\Core\Controller;
class SistemaController extends Controller {
    public function restaurar(): void { $this->view('admin/restaurar'); }
}
