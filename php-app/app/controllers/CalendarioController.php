<?php
namespace App\Controllers;
use App\Core\Controller;
class CalendarioController extends Controller {
    public function index(): void { $this->view('calendario/index'); }
}
