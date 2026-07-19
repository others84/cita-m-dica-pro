<?php
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioClinicaModel.php';

class Auth {
    /**
     * Autentica contra citas.spLoginUsuario.
     * Devuelve el arreglo a guardar en sesion o null.
     */
    public static function attempt(string $usuario, string $password): ?array {
        try {
            $u = UsuarioModel::login($usuario, $password);
        } catch (Throwable $e) {
            Database::log('Auth error: ' . $e->getMessage());
            return null;
        }
        if (!$u) return null;
        $rolNombre = (string)($u['rol'] ?? '');
        $idClinica = isset($u['id_CLINICA']) ? (int)$u['id_CLINICA'] : null;
        // Bloqueo por clinica: si la clinica del usuario esta desactivada, negar acceso
        // (no aplica al administrador de sistema).
        if ($idClinica && $rolNombre !== 'Administrador de sistema') {
            try {
                if (!ClinicaModel::estaActiva($idClinica)) {
                    Database::log("LOGIN BLOQUEADO usuario='{$usuario}' clinica_id={$idClinica} (clinica bloqueada)");
                    return null;
                }
            } catch (Throwable $e) {
                Database::log('Auth clinic check error: ' . $e->getMessage());
            }
        }
        // Normaliza el nombre del rol que regresa el SP a un codigo corto
        // estable usado por los controladores (admin_sistema, administrador,
        // medico, asistente).
        $map = [
            'Administrador de sistema' => 'admin_sistema',
            'Administrador de clinica' => 'administrador',
            'Administrador de clínica' => 'administrador',
            'Medico'                   => 'medico',
            'Médico'                   => 'medico',
            'Asistente'                => 'asistente',
        ];
        $rolCodigo = $map[$rolNombre] ?? strtolower(str_replace(' ', '_', $rolNombre));
        $idUsuario = (int)($u['id_USUARIOS'] ?? 0);
        $clinicas = [];
        if ($rolCodigo !== 'admin_sistema' && $idUsuario > 0) {
            $clinicas = UsuarioClinicaModel::listarPorUsuario($idUsuario);
            Database::log(sprintf(
                'Auth.login usuario=%s id_USUARIOS=%d rol=%s clinicas_asignadas=%d ids=[%s]',
                $usuario, $idUsuario, $rolCodigo, count($clinicas),
                implode(',', array_map(fn($c) => (int)($c['id_CLINICA'] ?? 0), $clinicas))
            ));
            // Fallback: si por alguna razon no hay asignaciones, usar la clinica propia
            if (empty($clinicas) && $idClinica) {
                try {
                    foreach (ClinicaModel::listar() as $cl) {
                        if ((int)$cl['id_CLINICA'] === $idClinica) {
                            $clinicas = [['id_CLINICA' => $idClinica, 'nombre' => $cl['nombre'], 'activo' => 1]];
                            break;
                        }
                    }
                } catch (Throwable $e) { /* ignore */ }
            }
        }
        return [
            'id_USUARIOS'     => (int)($u['id_USUARIOS'] ?? 0),
            'usuario'         => $u['usuario'] ?? $usuario,
            'nombre'          => $u['nombre_completo'] ?? $usuario,
            'email'           => $u['email'] ?? null,
            'id_ROLES'        => (int)($u['id_ROLES'] ?? 0),
            'rol'             => $rolCodigo,
            'rol_nombre'      => $rolNombre,
            'id_CLINICA'      => $idClinica,
            'clinicas'        => $clinicas,
        ];
    }
}