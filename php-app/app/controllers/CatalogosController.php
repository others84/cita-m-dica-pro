<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/PaisModel.php';
require_once __DIR__ . '/../models/EstadoModel.php';
require_once __DIR__ . '/../models/MunicipioModel.php';
require_once __DIR__ . '/../models/GeneroModel.php';
require_once __DIR__ . '/../models/EstadoCitaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/RolModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class CatalogosController extends Controller {
    private function guard(): void { $this->requireLogin(['administrador','admin_sistema']); }

    /**
     * Busca la fila a editar dentro del listado, tolerando diferencias de tipo
     * o de mayusculas/minusculas en los nombres de columna que devuelve el SP.
     */
    private function pickRow(array $rows, string $idField, ?int $editId): ?array {
        if (!$editId) return null;
        $key = strtolower($idField);
        foreach ($rows as $r) {
            foreach ($r as $col => $val) {
                if (strtolower((string)$col) === $key && (int)$val === $editId) {
                    return $r;
                }
            }
        }
        return null;
    }

    /* ---- Paises ---- */
    public function paises(): void {
        $this->guard();
        $editId = $this->stateInt('edit', 'catalogos.paises');
        $rows = PaisModel::listar();
        $editRow = $this->pickRow($rows, 'id_CATALOGO_PAIS', $editId);
        if ($editId && !$editRow) $editRow = PaisModel::obtener($editId);
        Database::log('CatalogosController::paises editId=' . var_export($editId, true)
            . ' editRow=' . ($editRow ? json_encode($editRow, JSON_UNESCAPED_UNICODE) : 'NULL'));
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
        $this->clearState('edit', 'catalogos.paises');
        $this->redirect('catalogos/paises');
    }
    public function paisesEliminar(): void {
        $this->guard();
        try { PaisModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.paises');
        $this->redirect('catalogos/paises');
    }

    /* ---- Generos ---- */
    public function generos(): void {
        $this->guard();
        $editId = $this->stateInt('edit', 'catalogos.generos');
        $rows = GeneroModel::listar();
        $editRow = $this->pickRow($rows, 'id_CATALOGO_GENERO', $editId);
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
        $this->clearState('edit', 'catalogos.generos');
        $this->redirect('catalogos/generos');
    }
    public function generosEliminar(): void {
        $this->guard();
        try { GeneroModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.generos');
        $this->redirect('catalogos/generos');
    }

    /* ---- Estados de cita ---- */
    public function estadosCita(): void {
        $this->guard();
        $editId = $this->stateInt('edit', 'catalogos.estadosCita');
        $rows = EstadoCitaModel::listar();
        $editRow = $this->pickRow($rows, 'id_CATALOGO_ESTADO_CITAS', $editId);
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
        $this->clearState('edit', 'catalogos.estadosCita');
        $this->redirect('catalogos/estadosCita');
    }
    public function estadosCitaEliminar(): void {
        $this->guard();
        try { EstadoCitaModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.estadosCita');
        $this->redirect('catalogos/estadosCita');
    }

    /* ---- Estados (con pais) ---- */
    public function estados(): void {
        $this->guard();
        $editId = $this->stateInt('edit', 'catalogos.estados');
        $fPais  = $this->stateInt('f_pais', 'catalogos.estados');
        // Al presionar "Editar", el filtro se ajusta al pais del estado.
        if ($editId && isset($_POST['edit'])) {
            foreach (EstadoModel::listar(null) as $e) {
                if ((int)$e['id_CATALOGO_ESTADOS'] === $editId) {
                    $fPais = (int)($e['id_CATALOGO_PAIS'] ?? 0) ?: null;
                    $_SESSION['ui']['catalogos.estados']['f_pais'] = $fPais;
                    break;
                }
            }
        }
        $rows = EstadoModel::listar($fPais); $editRow=null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CATALOGO_ESTADOS']===$editId) { $editRow=$r; break; }
        $this->view('catalogos/estados', [
            'title'=>'Estados','rows'=>$rows,'editId'=>$editId,'editRow'=>$editRow,
            'paises'=>PaisModel::listar(), 'fPais'=>$fPais,
        ]);
    }
    public function estadosGuardar(): void {
        $this->guard();
        $id = $this->intOrNull($_POST['id'] ?? null);
        $n = $this->input('nombre');
        $p = (int)($this->intOrNull($_POST['id_CATALOGO_PAIS'] ?? null)
            ?? $this->stateInt('f_pais', 'catalogos.estados'));
        if ($n === null || !$p) {
            $this->flash('error', 'Selecciona un país en el filtro y captura el nombre del estado.');
            $this->redirect('catalogos/estados');
        }
        try { if ($id) EstadoModel::cambio($id,$n,$p); else EstadoModel::alta($n,$p); $this->flash('ok','Guardado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->clearState('edit', 'catalogos.estados');
        $this->redirect('catalogos/estados');
    }
    public function estadosEliminar(): void {
        $this->guard();
        try { EstadoModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.estados');
        $this->redirect('catalogos/estados');
    }

    /* ---- Municipios (con estado) ---- */
    public function municipios(): void {
        $this->guard();
        $editId  = $this->stateInt('edit', 'catalogos.municipios');
        $fPais   = $this->stateInt('f_pais', 'catalogos.municipios');
        $fEstado = $this->stateInt('f_estado', 'catalogos.municipios');
        // Al presionar "Editar", los filtros se ajustan al pais/estado del municipio.
        if ($editId && isset($_POST['edit'])) {
            foreach (MunicipioModel::listar(null) as $m) {
                if ((int)$m['id_CATALOGO_MUNICIPIO'] === $editId) {
                    $fPais   = (int)($m['id_CATALOGO_PAIS'] ?? 0) ?: null;
                    $fEstado = (int)($m['id_CATALOGO_ESTADOS'] ?? 0) ?: null;
                    $_SESSION['ui']['catalogos.municipios']['f_pais']   = $fPais;
                    $_SESSION['ui']['catalogos.municipios']['f_estado'] = $fEstado;
                    break;
                }
            }
        }
        $estados = EstadoModel::listar($fPais);
        // Si el estado guardado no pertenece al pais seleccionado, se descarta.
        if ($fEstado) {
            $idsEstado = array_map(fn($e) => (int)$e['id_CATALOGO_ESTADOS'], $estados);
            if (!in_array($fEstado, $idsEstado, true)) {
                $fEstado = null;
                $this->clearState('f_estado', 'catalogos.municipios');
            }
        }
        $rows = MunicipioModel::listar($fEstado);
        if ($fPais && !$fEstado) {
            $rows = array_values(array_filter($rows, fn($r) => (int)($r['id_CATALOGO_PAIS'] ?? 0) === $fPais));
        }
        $editRow=null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_CATALOGO_MUNICIPIO']===$editId) { $editRow=$r; break; }
        $this->view('catalogos/municipios', [
            'title'=>'Municipios','rows'=>$rows,'editId'=>$editId,'editRow'=>$editRow,
            'estados'=>$estados,
            'paises'=>PaisModel::listar(),
            'fPais'=>$fPais, 'fEstado'=>$fEstado,
        ]);
    }
    public function municipiosGuardar(): void {
        $this->guard();
        $id = $this->intOrNull($_POST['id'] ?? null);
        $n = $this->input('nombre');
        // El estado se toma del filtro (ya no hay combo en el formulario).
        $e = (int)($this->intOrNull($_POST['id_CATALOGO_ESTADOS'] ?? null)
            ?? $this->stateInt('f_estado', 'catalogos.municipios'));
        if ($n === null || !$e) {
            $this->flash('error', 'Selecciona un estado en el filtro y captura el nombre del municipio.');
            $this->redirect('catalogos/municipios');
        }
        try { if ($id) MunicipioModel::cambio($id,$n,$e); else MunicipioModel::alta($n,$e); $this->flash('ok','Guardado.'); }
        catch (Throwable $ex) { $this->flash('error',$ex->getMessage()); }
        $this->clearState('edit', 'catalogos.municipios');
        $this->redirect('catalogos/municipios');
    }
    public function municipiosEliminar(): void {
        $this->guard();
        try { MunicipioModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.municipios');
        $this->redirect('catalogos/municipios');
    }

    /* ---- Usuarios de clinica ---- */
    public function usuarios(): void {
        $this->guard();
        $editId = $this->stateInt('edit', 'catalogos.usuarios');
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
        $this->clearState('edit', 'catalogos.usuarios');
        $this->redirect('catalogos/usuarios');
    }
    public function usuariosActivar(): void {
        $this->guard();
        try { UsuarioModel::activa((int)$this->input('id')); $this->flash('ok','Activado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->clearState('edit', 'catalogos.usuarios');
        $this->redirect('catalogos/usuarios');
    }
    public function usuariosDesactivar(): void {
        $this->guard();
        try { UsuarioModel::desactiva((int)$this->input('id')); $this->flash('ok','Desactivado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->clearState('edit', 'catalogos.usuarios');
        $this->redirect('catalogos/usuarios');
    }

    public function usuariosEliminar(): void {
        $this->guard();
        $id    = (int)$this->input('id');
        $quien = $_SESSION['user']['usuario'] ?? 'anonimo';
        Database::log("USUARIOS accion=ELIMINAR intento id_USUARIOS={$id} solicitado_por='{$quien}'");
        try {
            UsuarioModel::baja($id);
            Database::log("USUARIOS accion=ELIMINAR resultado=OK id_USUARIOS={$id} solicitado_por='{$quien}'");
            $this->flash('ok','Usuario eliminado.');
        } catch (Throwable $e) {
            Database::log("USUARIOS accion=ELIMINAR resultado=RECHAZADA id_USUARIOS={$id} solicitado_por='{$quien}' motivo=" . $e->getMessage());
            $this->flash('error','No se pudo eliminar: ' . $e->getMessage());
        }
        $this->clearState('edit', 'catalogos.usuarios');
        $this->redirect('catalogos/usuarios');
    }

    /* ---- Respaldo ---- */
    public function respaldo(): void {
        $this->guard();
        $this->view('catalogos/respaldo', ['title'=>'Respaldo de BD']);
    }
}