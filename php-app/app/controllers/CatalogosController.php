<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/PaisModel.php';
require_once __DIR__ . '/../models/EstadoModel.php';
require_once __DIR__ . '/../models/GeneroModel.php';
require_once __DIR__ . '/../models/EstadoCitaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/RolModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class CatalogosController extends Controller {
    private function guard(): void { $this->requireLogin(['administrador','admin_sistema']); }

    /* ---- Paises ---- */
    public function paises(): void {
        $this->guard();
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = PaisModel::listar(); $editRow=null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CATALOGO_PAIS']===$editId) { $editRow=$r; break; }
        $this->view('_partials/simple_catalog', [
            'title'=>'Paises','rows'=>$rows,'idField'=>'id_CATALOGO_PAIS',
            'controller'=>'catalogos/paises','editId'=>$editId,'editRow'=>$editRow,
        ]);
    }
    public function paisesGuardar(): void {
        $this->guard();
        $id = $this->intOrNull($_POST['id'] ?? null); $n = $this->input('nombre');
        Database::log("CatalogosController::paisesGuardar POST id=" . var_export($id, true) . " nombre=" . var_export($n, true));
        try {
            if ($id) PaisModel::cambio($id, (string)$n);
            else     PaisModel::alta((string)$n);
            $this->flash('ok','Guardado.');
        } catch (Throwable $e) {
            Database::log('CatalogosController::paisesGuardar EXC ' . $e->getMessage());
            $this->flash('error',$e->getMessage());
        }
        $this->redirect('catalogos/paises');
    }

    /* ---- Generos ---- */
    public function generos(): void {
        $this->guard();
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = GeneroModel::listar(); $editRow=null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CATALOGO_GENERO']===$editId) { $editRow=$r; break; }
        $this->view('_partials/simple_catalog', [
            'title'=>'Generos','rows'=>$rows,'idField'=>'id_CATALOGO_GENERO',
            'controller'=>'catalogos/generos','editId'=>$editId,'editRow'=>$editRow,
        ]);
    }
    public function generosGuardar(): void {
        $this->guard();
        $id = $this->intOrNull($_POST['id'] ?? null); $n = $this->input('nombre');
        try { if ($id) GeneroModel::cambio($id,$n); else GeneroModel::alta($n); $this->flash('ok','Guardado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->redirect('catalogos/generos');
    }

    /* ---- Estados de cita ---- */
    public function estadosCita(): void {
        $this->guard();
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = EstadoCitaModel::listar(); $editRow=null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CATALOGO_ESTADO_CITAS']===$editId) { $editRow=$r; break; }
        $this->view('_partials/simple_catalog', [
            'title'=>'Estados de cita','rows'=>$rows,'idField'=>'id_CATALOGO_ESTADO_CITAS',
            'controller'=>'catalogos/estadosCita','editId'=>$editId,'editRow'=>$editRow,
        ]);
    }
    public function estadosCitaGuardar(): void {
        $this->guard();
        $id = $this->intOrNull($_POST['id'] ?? null); $n = $this->input('nombre');
        try { if ($id) EstadoCitaModel::cambio($id,$n); else EstadoCitaModel::alta($n); $this->flash('ok','Guardado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->redirect('catalogos/estadosCita');
    }

    /* ---- Estados (con pais) ---- */
    public function estados(): void {
        $this->guard();
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = EstadoModel::listar(); $editRow=null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CATALOGO_ESTADOS']===$editId) { $editRow=$r; break; }
        $this->view('catalogos/estados', [
            'title'=>'Estados','rows'=>$rows,'editId'=>$editId,'editRow'=>$editRow,
            'paises'=>PaisModel::listar(),
        ]);
    }
    public function estadosGuardar(): void {
        $this->guard();
        $id = $this->intOrNull($_POST['id'] ?? null);
        $n = $this->input('nombre'); $p = (int)$this->input('id_CATALOGO_PAIS');
        try { if ($id) EstadoModel::cambio($id,$n,$p); else EstadoModel::alta($n,$p); $this->flash('ok','Guardado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->redirect('catalogos/estados');
    }

    /* ---- Usuarios de clinica ---- */
    public function usuarios(): void {
        $this->guard();
        $editId = $this->intOrNull($_GET['edit'] ?? null);
        $rows = UsuarioModel::listar(); $editRow=null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_USUARIOS']===$editId) { $editRow=$r; break; }
        $this->view('catalogos/usuarios', [
            'title'=>'Usuarios','rows'=>$rows,'editId'=>$editId,'editRow'=>$editRow,
            'roles'=>RolModel::listar(), 'clinicas'=>ClinicaModel::listar(),
        ]);
    }
    public function usuariosGuardar(): void {
        $this->guard();
        $id = $this->intOrNull($_POST['id'] ?? null);
        $idRol = (int)$this->input('id_ROLES');
        $idCli = $this->intOrNull($this->input('id_CLINICA'));
        $usuario = $this->input('usuario');
        $nombre  = $this->input('nombre_completo');
        $email   = $this->input('email');
        $pass    = $this->input('password');
        try {
            if ($id) {
                UsuarioModel::cambio($id, $idRol, $idCli, $nombre, $email);
                if (!empty($pass)) UsuarioModel::cambioPassword($id, $pass);
            } else {
                UsuarioModel::alta($idRol, $idCli, $usuario, $pass ?? '', $nombre, $email);
            }
            $this->flash('ok','Usuario guardado.');
        } catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->redirect('catalogos/usuarios');
    }
    public function usuariosActivar(): void {
        $this->guard();
        try { UsuarioModel::activa((int)$this->input('id')); $this->flash('ok','Activado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->redirect('catalogos/usuarios');
    }
    public function usuariosDesactivar(): void {
        $this->guard();
        try { UsuarioModel::desactiva((int)$this->input('id')); $this->flash('ok','Desactivado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->redirect('catalogos/usuarios');
    }

    /* ---- Respaldo ---- */
    public function respaldo(): void {
        $this->guard();
        $this->view('catalogos/respaldo', ['title'=>'Respaldo de BD']);
    }
}