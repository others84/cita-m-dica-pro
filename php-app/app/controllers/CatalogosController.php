<?php
require_once __DIR__ . '/../core/Controller.php';

class CatalogosController extends Controller {
    public function index(): void { $this->requireLogin(['administrador','admin_sistema']); $this->view('catalogos/index', ['title' => 'Catálogos']); }
    public function paises(): void { $this->requireLogin(['administrador','admin_sistema']); $this->view('catalogos/paises', ['title' => 'CRUD Países']); }
    public function estados(): void { $this->requireLogin(['administrador','admin_sistema']); $this->view('catalogos/estados', ['title' => 'CRUD Estados']); }
    public function generos(): void { $this->requireLogin(['administrador','admin_sistema']); $this->view('catalogos/generos', ['title' => 'CRUD Géneros']); }
    public function usuarios(): void { $this->requireLogin(['administrador','admin_sistema']); $this->view('catalogos/usuarios', ['title' => 'CRUD Usuarios de clínica']); }
    public function estadosCita(): void { $this->requireLogin(['administrador','admin_sistema']); $this->view('catalogos/estados_cita', ['title' => 'CRUD Estado de citas']); }
    public function respaldo(): void { $this->requireLogin(['administrador','admin_sistema']); $this->view('catalogos/respaldo', ['title' => 'Respaldo de base de datos']); }
}