<?php
require_once __DIR__ . '/../models/UsuarioModel.php';

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
        return [
            'id_USUARIOS'     => (int)($u['id_USUARIOS'] ?? 0),
            'usuario'         => $u['usuario'] ?? $usuario,
            'nombre'          => $u['nombre_completo'] ?? $usuario,
            'email'           => $u['email'] ?? null,
            'id_ROLES'        => (int)($u['id_ROLES'] ?? 0),
            'rol'             => $u['rol'] ?? '',
            'id_CLINICA'      => isset($u['id_CLINICA']) ? (int)$u['id_CLINICA'] : null,
        ];
    }
}