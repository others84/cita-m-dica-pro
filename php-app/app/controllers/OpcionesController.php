<?php
require_once __DIR__ . '/../core/Controller.php';

class OpcionesController extends Controller {
    public function index(): void { $this->requireLogin(); $this->view('opciones/index', ['title' => 'Opciones']); }
    public function cambiarPassword(): void { $this->requireLogin(); $this->view('opciones/cambiar_password', ['title' => 'Cambiar contraseña']); }
    public function actualizarDatos(): void { $this->requireLogin(); $this->view('opciones/actualizar_datos', ['title' => 'Actualizar datos']); }
}