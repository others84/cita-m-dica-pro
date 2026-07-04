<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/UsuarioModel.php';

class OpcionesController extends Controller {
    public function index(): void { $this->requireLogin(); $this->view('opciones/index', ['title' => 'Opciones']); }
    public function cambiarPassword(): void {
        $this->requireLogin();
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $actual = (string)$this->input('actual');
            $nueva  = (string)$this->input('nueva');
            $conf   = (string)$this->input('confirmacion');
            $user   = $_SESSION['user'];
            try {
                if ($nueva === '' || strlen($nueva) < 4) throw new Exception('La nueva contraseña debe tener al menos 4 caracteres.');
                if ($nueva !== $conf) throw new Exception('La confirmación no coincide con la nueva contraseña.');
                $ok = UsuarioModel::login($user['usuario'], $actual);
                if (!$ok) throw new Exception('La contraseña actual es incorrecta.');
                UsuarioModel::cambioPassword((int)$user['id_USUARIOS'], $nueva);
                $this->flash('ok','Contraseña actualizada correctamente.');
            } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
            $this->redirect('opciones/cambiarPassword');
        }
        $this->view('opciones/cambiar_password', ['title' => 'Cambiar contraseña']);
    }
    public function actualizarDatos(): void { $this->requireLogin(); $this->view('opciones/actualizar_datos', ['title' => 'Actualizar datos']); }
}