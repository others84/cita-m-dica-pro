<?php
class Auth {
    // Datos de prueba (mock). Reemplazar por consulta a BD más adelante.
    private static array $users = [
        'asistente'   => ['password' => 'asistente1',   'rol' => 'asistente',     'nombre' => 'Maria Fernanda Canales'],
        'medico'      => ['password' => 'medico1',      'rol' => 'medico',        'nombre' => 'Estefano Lopez Hamill'],
        'admin'       => ['password' => 'admin1',       'rol' => 'administrador', 'nombre' => 'Juan Lopez'],
        'adminMaster' => ['password' => 'adminMaster1', 'rol' => 'admin_sistema', 'nombre' => 'Victor Puig Morales'],
    ];

    public static function attempt(string $usuario, string $password): ?array {
        if (!isset(self::$users[$usuario])) return null;
        $u = self::$users[$usuario];
        if ($u['password'] !== $password) return null;
        return [
            'usuario' => $usuario,
            'nombre'  => $u['nombre'],
            'rol'     => $u['rol'],
        ];
    }
}