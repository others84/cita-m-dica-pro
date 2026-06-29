<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/RolModel.php';

/**
 * Atajo: lista usuarios con rol "asistente".
 */
class AsistentesController extends Controller {
    public function index(): void {
        $this->requireLogin(['medico','administrador','admin_sistema']);
        $rows = array_values(array_filter(UsuarioModel::listar(), fn($u) => ($u['rol'] ?? '') === 'asistente'));
        $this->view('asistentes/index', ['title'=>'Asistentes','rows'=>$rows]);
    }
}