<?php
class Controller {
    protected function view(string $view, array $data = []): void {
        extract($data);
        $viewFile = __DIR__ . '/../views/' . $view . '.php';
        if (!file_exists($viewFile)) {
            echo "Vista no encontrada: $view";
            return;
        }
        require __DIR__ . '/../views/layout/header.php';
        require $viewFile;
        require __DIR__ . '/../views/layout/footer.php';
    }

    protected function requireLogin(array $roles = []): void {
        if (empty($_SESSION['user'])) {
            header('Location: ' . url('auth/login'));
            exit;
        }
        if (!empty($roles) && !in_array($_SESSION['user']['rol'], $roles, true)) {
            http_response_code(403);
            echo 'Acceso denegado';
            exit;
        }
    }

    protected function flash(string $type, string $msg): void {
        $_SESSION['flash'][] = ['type' => $type, 'msg' => $msg];
    }

    protected function redirect(string $path): void {
        header('Location: ' . url($path));
        exit;
    }

    protected function input(string $key, $default = null) {
        // Solo POST: los valores nunca deben viajar en la URL.
        $v = $_POST[$key] ?? $default;
        if (is_string($v)) {
            $v = trim($v);
            if ($v === '') return $default;
        }
        return $v;
    }

    protected function intOrNull($v): ?int {
        if ($v === null || $v === '') return null;
        return (int)$v;
    }

    /**
     * Estado de pantalla (filtros, registro en edicion) guardado en sesion.
     * Nunca se lee de la URL: si viene por POST se toma de ahi y se persiste,
     * si no, se recupera el ultimo valor guardado.
     */
    protected function stateNs(?string $ns = null): string {
        if ($ns !== null) return $ns;
        $c = get_class($this);
        return strtolower(preg_replace('/Controller$/', '', $c));
    }

    protected function stateParam(string $key, $default = null, ?string $ns = null) {
        $ns = $this->stateNs($ns);
        if (array_key_exists($key, $_POST)) {
            $v = $_POST[$key];
            if (is_string($v)) $v = trim($v);
            if ($v === '' || $v === null) {
                unset($_SESSION['ui'][$ns][$key]);
                return $default;
            }
            $_SESSION['ui'][$ns][$key] = $v;
            return $v;
        }
        return $_SESSION['ui'][$ns][$key] ?? $default;
    }

    protected function stateInt(string $key, ?string $ns = null): ?int {
        return $this->intOrNull($this->stateParam($key, null, $ns));
    }

    protected function clearState(string $key, ?string $ns = null): void {
        $ns = $this->stateNs($ns);
        unset($_SESSION['ui'][$ns][$key]);
    }

    /**
     * Resuelve el contexto de filtro por clinica segun el rol.
     * Retorna ['clinicasFiltro' => array, 'fClinica' => ?int, 'rol' => string].
     *
     * - admin_sistema: puede elegir cualquier clinica (o "todas" => null).
     * - resto de roles: se limitan a las clinicas asignadas en sesion. Si eligen
     *   una valida se respeta; si no, se toma la primera asignada. Nunca pueden
     *   ver datos de una clinica que no tienen asignada.
     */
    protected function resolveClinicaContext(): array {
        $rol = $_SESSION['user']['rol'] ?? '';
        $sessClinicas = $_SESSION['user']['clinicas'] ?? [];
        $userClin = $_SESSION['user']['id_CLINICA'] ?? null;
        // El filtro de clinica viaja por POST (nunca por la URL) y se
        // persiste en sesion para conservarse entre navegaciones.
        $posted = array_key_exists('f_clinica', $_POST);
        $raw = $posted ? $this->intOrNull($_POST['f_clinica']) : null;
        $last = isset($_SESSION['f_clinica']) ? (int)$_SESSION['f_clinica'] : 0;
        if ($posted) {
            if ($raw === null) unset($_SESSION['f_clinica']);
            else $_SESSION['f_clinica'] = $raw;
        }

        if (class_exists('Database')) {
            $idsInicio = array_map(fn($c) => (int)($c['id_CLINICA'] ?? 0), $sessClinicas);
            Database::log(sprintf(
                'resolveClinicaContext IN rol=%s user=%s uri=%s post_f_clinica=%s session_f_clinica=%s session_ids=[%s] user_id_CLINICA=%s',
                $rol,
                $_SESSION['user']['usuario'] ?? '?',
                $_SERVER['REQUEST_URI'] ?? '?',
                $posted ? ($raw === null ? 'TODAS' : (string)$raw) : 'NO_POST',
                $last ?: 'NULL',
                implode(',', $idsInicio),
                $userClin === null ? 'NULL' : (string)$userClin
            ));
        }

        if ($rol === 'admin_sistema') {
            // Si no vino por POST, se conserva la ultima seleccion de sesion.
            $fAdmin = $posted ? $raw : ($last ?: null);
            if (class_exists('Database')) {
                Database::log(sprintf(
                    'resolveClinicaContext OUT rol=%s user=%s modo=admin_sistema fClinica=%s',
                    $rol,
                    $_SESSION['user']['usuario'] ?? '?',
                    $fAdmin === null ? 'NULL' : (string)$fAdmin
                ));
            }
            require_once __DIR__ . '/../models/ClinicaModel.php';
            return [
                'clinicasFiltro' => ClinicaModel::listar(),
                'fClinica' => $fAdmin,
                'rol' => $rol,
            ];
        }

        // Safety net: si la sesion no trae clinicas (login antiguo o sesion
        // creada antes de asignar clinicas), refrescamos desde DB.
        if (empty($sessClinicas) && !empty($_SESSION['user']['id_USUARIOS'])) {
            require_once __DIR__ . '/../models/UsuarioClinicaModel.php';
            $sessClinicas = UsuarioClinicaModel::listarPorUsuario((int)$_SESSION['user']['id_USUARIOS']);
            $_SESSION['user']['clinicas'] = $sessClinicas;
            if (class_exists('Database')) {
                $idsRefrescados = array_map(fn($c) => (int)($c['id_CLINICA'] ?? 0), $sessClinicas);
                Database::log(sprintf(
                    'resolveClinicaContext REFRESH user=%s rows=%d ids=[%s]',
                    $_SESSION['user']['usuario'] ?? '?',
                    count($sessClinicas),
                    implode(',', $idsRefrescados)
                ));
            }
        }

        $ids = array_map(fn($c) => (int)$c['id_CLINICA'], $sessClinicas);
        $fClinica = null;
        $motivo = 'sin_clinica';
        if ($raw && in_array($raw, $ids, true)) {
            $fClinica = $raw;
            $motivo = 'get_valido';
        } elseif (!empty($ids)) {
            // Si el usuario intento seleccionar una clinica valida pero por
            // algun motivo no matcheo, respetamos el raw solo si esta en $ids.
            // De lo contrario mantenemos la ultima seleccion valida guardada.
            if ($last && in_array($last, $ids, true)) {
                $fClinica = $last;
                $motivo = 'session_valida';
            } else {
                $fClinica = $ids[0];
                $motivo = $raw ? 'get_no_permitido_default' : 'default_primera';
            }
        } elseif ($userClin) {
            $fClinica = (int)$userClin;
            $motivo = 'user_id_CLINICA';
        }
        // Persistimos la ultima seleccion valida para que se mantenga entre
        // navegaciones aunque el usuario no vuelva a pasar ?f_clinica.
        if ($fClinica) {
            $_SESSION['f_clinica'] = $fClinica;
        }
        if (class_exists('Database')) {
            Database::log(sprintf(
                'resolveClinicaContext OUT rol=%s user=%s ids=[%s] post_f_clinica=%s session_f_clinica_previa=%s fClinica=%s motivo=%s session_f_clinica_final=%s',
                $rol,
                $_SESSION['user']['usuario'] ?? '?',
                implode(',', $ids),
                $posted ? ($raw === null ? 'TODAS' : (string)$raw) : 'NO_POST',
                $last ?: 'NULL',
                $fClinica === null ? 'NULL' : (string)$fClinica,
                $motivo,
                $_SESSION['f_clinica'] ?? 'NULL'
            ));
        }
        return [
            'clinicasFiltro' => $sessClinicas,
            'fClinica' => $fClinica,
            'rol' => $rol,
        ];
    }
}