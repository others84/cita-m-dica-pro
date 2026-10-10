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
    /** Catalogos globales (paises, estados, municipios, generos, estados de cita): solo admin de sistema. */
    private function guardSistema(): void { $this->requireLogin(['admin_sistema']); }

    /** Clinica a la que pertenece un usuario del sistema (null si no existe). */
    private function clinicaDeUsuario(int $idUsuario): ?int {
        foreach (UsuarioModel::listar() as $u) {
            if ((int)($u['id_USUARIOS'] ?? 0) === $idUsuario) {
                $c = (int)($u['id_CLINICA'] ?? 0);
                return $c > 0 ? $c : null;
            }
        }
        return null;
    }

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
        $this->guardSistema();
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
        $this->guardSistema();
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
        $this->guardSistema();
        try { PaisModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.paises');
        $this->redirect('catalogos/paises');
    }

    /* ---- Generos ---- */
    public function generos(): void {
        $this->guardSistema();
        $editId = $this->stateInt('edit', 'catalogos.generos');
        $rows = GeneroModel::listar();
        $editRow = $this->pickRow($rows, 'id_CATALOGO_GENERO', $editId);
        $this->view('_partials/simple_catalog', [
            'title'=>'Generos','rows'=>$rows,'idField'=>'id_CATALOGO_GENERO',
            'controller'=>'catalogos/generos','editId'=>$editId,'editRow'=>$editRow,
        ]);
    }
    public function generosGuardar(): void {
        $this->guardSistema();
        $id = $this->intOrNull($_POST['id'] ?? null); $n = $this->input('nombre');
        try { if ($id) GeneroModel::cambio($id,$n); else GeneroModel::alta($n); $this->flash('ok','Guardado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->clearState('edit', 'catalogos.generos');
        $this->redirect('catalogos/generos');
    }
    public function generosEliminar(): void {
        $this->guardSistema();
        try { GeneroModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.generos');
        $this->redirect('catalogos/generos');
    }

    /* ---- Estados de cita ---- */
    public function estadosCita(): void {
        $this->guardSistema();
        $editId = $this->stateInt('edit', 'catalogos.estadosCita');
        $rows = EstadoCitaModel::listar();
        $editRow = $this->pickRow($rows, 'id_CATALOGO_ESTADO_CITAS', $editId);
        $this->view('_partials/simple_catalog', [
            'title'=>'Estados de cita','rows'=>$rows,'idField'=>'id_CATALOGO_ESTADO_CITAS',
            'controller'=>'catalogos/estadosCita','editId'=>$editId,'editRow'=>$editRow,
        ]);
    }
    public function estadosCitaGuardar(): void {
        $this->guardSistema();
        $id = $this->intOrNull($_POST['id'] ?? null); $n = $this->input('nombre');
        try { if ($id) EstadoCitaModel::cambio($id,$n); else EstadoCitaModel::alta($n); $this->flash('ok','Guardado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->clearState('edit', 'catalogos.estadosCita');
        $this->redirect('catalogos/estadosCita');
    }
    public function estadosCitaEliminar(): void {
        $this->guardSistema();
        try { EstadoCitaModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.estadosCita');
        $this->redirect('catalogos/estadosCita');
    }

    /* ---- Estados (con pais) ---- */
    public function estados(): void {
        $this->guardSistema();
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
        $this->guardSistema();
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
        $this->guardSistema();
        try { EstadoModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.estados');
        $this->redirect('catalogos/estados');
    }

    /* ---- Municipios (con estado) ---- */
    public function municipios(): void {
        $this->guardSistema();
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
        $this->guardSistema();
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
        $this->guardSistema();
        try { MunicipioModel::baja((int)$this->input('id')); $this->flash('ok','Registro eliminado.'); }
        catch (Throwable $e) { $this->flash('error','No se pudo eliminar: ' . $e->getMessage()); }
        $this->clearState('edit', 'catalogos.municipios');
        $this->redirect('catalogos/municipios');
    }

    /** True si el rol indicado es asistente o medico (unicos permitidos al admin de clinica). */
    private function rolOperativo(string $nombre): bool {
        $n = strtolower($nombre);
        return strpos($n, 'asistente') !== false
            || strpos($n, 'medic') !== false
            || strpos($n, 'médic') !== false;
    }

    /** Roles que el usuario actual puede asignar. */
    private function rolesPermitidos(): array {
        $roles = RolModel::listar();
        if ($this->clinicasPermitidas() === null) return $roles;  // admin_sistema
        return array_values(array_filter(
            $roles,
            fn($r) => $this->rolOperativo((string)($r['nombre'] ?? ''))
        ));
    }

    /* ---- Usuarios de clinica ---- */
    public function usuarios(): void {
        $this->guard();
        $ns = 'catalogos.usuarios';
        $editId = $this->stateInt('edit', $ns);
        $fRol     = $this->stateInt('f_rol', $ns);
        $fClinica = $this->stateInt('f_clinica', $ns);

        $permitidas = $this->clinicasPermitidas();   // null = admin_sistema
        $todos = UsuarioModel::listar();
        if ($permitidas !== null) {
            $todos = array_values(array_filter(
                $todos,
                fn($u) => in_array((int)($u['id_CLINICA'] ?? 0), $permitidas, true)
                    && $this->rolOperativo((string)($u['rol'] ?? ''))
            ));
        }
        $rows = $todos;

        // Filtro por rol.
        if ($fRol !== null) {
            $rows = array_values(array_filter(
                $rows,
                fn($u) => (int)($u['id_ROLES'] ?? 0) === $fRol
            ));
        }
        // Filtro por clinica (0 = todas).
        if ($fClinica !== null && $fClinica !== 0) {
            $rows = array_values(array_filter(
                $rows,
                fn($u) => (int)($u['id_CLINICA'] ?? 0) === $fClinica
            ));
        }

        $editRow=null;
        if ($editId) foreach ($rows as $r) if ((int)$r['id_USUARIOS']===$editId) { $editRow=$r; break; }
        // Si no se encontro en el filtro actual, buscarlo en el listado permitido.
        if ($editId && !$editRow) {
            foreach ($todos as $r) {
                if ((int)$r['id_USUARIOS']===$editId) { $editRow=$r; break; }
            }
        }
        // Solo las clinicas que el usuario tiene permitidas.
        $clinicas = ClinicaModel::listar();
        if ($permitidas !== null) {
            $clinicas = array_values(array_filter(
                $clinicas,
                fn($c) => in_array((int)($c['id_CLINICA'] ?? 0), $permitidas, true)
            ));
        }
        $this->view('catalogos/usuarios', [
            'title'=>'Usuarios','rows'=>$rows,'editId'=>$editId,'editRow'=>$editRow,
            'roles'=>$this->rolesPermitidos(), 'clinicas'=>$clinicas,
            'fRol'=>$fRol, 'fClinica'=>$fClinica,
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
        // El administrador de clinica solo puede asignar roles asistente o medico.
        $rolesOk = array_map(fn($r) => (int)$r['id_ROLES'], $this->rolesPermitidos());
        if (!in_array($idRol, $rolesOk, true)) {
            $this->denegarRecurso('rol', $idRol, $idCli, 'catalogos/usuarios');
            return;
        }
        // El administrador de clinica solo opera sobre sus propias clinicas.
        if (!$this->clinicaPermitida($idCli === null ? null : (int)$idCli)) {
            $this->denegarRecurso('usuario', $id ?? 'nuevo', $idCli, 'catalogos/usuarios');
            return;
        }
        if ($id && !$this->clinicaPermitida($this->clinicaDeUsuario((int)$id))) {
            $this->denegarRecurso('usuario', $id, null, 'catalogos/usuarios');
            return;
        }
        $pass = (string)($pass ?? '');
        $errPass = (!$id || $pass !== '') ? self::errorPassword($pass) : null;
        if ($errPass) { $this->flash('error', $errPass); $this->redirect('catalogos/usuarios'); return; }
        try {
            if ($id) {
                UsuarioModel::cambio($id, $idRol, $idCli, $nombre, $email);
                if (!empty($pass)) UsuarioModel::cambioPassword($id, $pass);
            } else {
                if ($idCli) $this->validaCupoClinica((int)$idCli, $idRol);
                UsuarioModel::alta($idRol, $idCli, $usuario, $pass ?? '', $nombre, $email);
            }
            $this->flash('ok','Usuario guardado.');
        } catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->clearState('edit', 'catalogos.usuarios');
        $this->redirect('catalogos/usuarios');
    }
    public function usuariosActivar(): void {
        $this->guard();
        $idU = (int)$this->input('id');
        if (!$this->clinicaPermitida($this->clinicaDeUsuario($idU))) {
            $this->denegarRecurso('usuario', $idU, null, 'catalogos/usuarios');
            return;
        }
        try {
            require_once __DIR__ . '/../models/UsuarioClinicaModel.php';
            foreach (UsuarioClinicaModel::listarPorUsuario($idU) as $r) {
                $this->validaCupoUsuario((int)$r['id_CLINICA'], $idU);
            }
            UsuarioModel::activa($idU); $this->flash('ok','Activado.');
        }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->clearState('edit', 'catalogos.usuarios');
        $this->redirect('catalogos/usuarios');
    }
    public function usuariosDesactivar(): void {
        $this->guard();
        $idU = (int)$this->input('id');
        if (!$this->clinicaPermitida($this->clinicaDeUsuario($idU))) {
            $this->denegarRecurso('usuario', $idU, null, 'catalogos/usuarios');
            return;
        }
        try { UsuarioModel::desactiva($idU); $this->flash('ok','Desactivado.'); }
        catch (Throwable $e) { $this->flash('error',$e->getMessage()); }
        $this->clearState('edit', 'catalogos.usuarios');
        $this->redirect('catalogos/usuarios');
    }

    public function usuariosEliminar(): void {
        $this->guard();
        $id    = (int)$this->input('id');
        $quien = $_SESSION['user']['usuario'] ?? 'anonimo';
        Database::log("USUARIOS accion=ELIMINAR intento id_USUARIOS={$id} solicitado_por='{$quien}'");
        if (!$this->clinicaPermitida($this->clinicaDeUsuario($id))) {
            $this->denegarRecurso('usuario', $id, null, 'catalogos/usuarios');
            return;
        }
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