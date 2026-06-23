<?php
namespace App\Controllers;
use App\Core\Controller;
class RolesController extends Controller {
    public function index(): void { $this->view('admin/roles'); }
}
