<?php
require_once __DIR__ . '/AvisoAcceso.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/UsuarioClinicaModel.php';
require_once __DIR__ . '/../models/ConfigAvisoAccesoModel.php';

/** Avisa por correo cuando un usuario queda bloqueado por intentos fallidos. Nunca lanza excepciones. */
class AvisoBloqueo {
    public static function notificar(string $usuario, string $ip, int $minutos): void {
        try {
            $filas = [];
            foreach (UsuarioModel::listar() as $u) {
                if (strcasecmp(trim((string)($u['usuario'] ?? '')), $usuario) === 0) $filas[] = $u;
            }
            if (!$filas) return; // usuario inexistente: no se avisa a nadie
            $obj = $filas[0];
            $idObj = (int)($obj['id_USUARIOS'] ?? 0);
            $rolObj = strtolower((string)($obj['rol'] ?? ''));

            $clinicasObj = array_map(fn($c) => (int)$c['id_CLINICA'], UsuarioClinicaModel::listarPorUsuario($idObj));
            foreach ($filas as $f) if (!empty($f['id_CLINICA'])) $clinicasObj[] = (int)$f['id_CLINICA'];
            $clinicasObj = array_values(array_unique($clinicasObj));

            // Administradores de clinica de esas clinicas, con correo.
            $destinos = [];
            $vistos = [];
            foreach (UsuarioModel::listar() as $u) {
                $id = (int)($u['id_USUARIOS'] ?? 0);
                if ($id <= 0 || $id === $idObj || isset($vistos[$id])) continue;
                $rol = strtolower((string)($u['rol'] ?? ''));
                if (strpos($rol, 'clinica') === false && strpos($rol, 'clínica') === false) continue;
                if ((int)($u['activo'] ?? 1) !== 1) continue;
                $vistos[$id] = true;
                $email = trim((string)($u['email'] ?? ''));
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) continue;
                $ids = array_map(fn($c) => (int)$c['id_CLINICA'], UsuarioClinicaModel::listarPorUsuario($id));
                if (!empty($u['id_CLINICA'])) $ids[] = (int)$u['id_CLINICA'];
                if (array_intersect($ids, $clinicasObj)) $destinos[strtolower($email)] = $email;
            }
            // Si el bloqueado es administrador, tambien al correo de "Aviso de accesos".
            if (strpos($rolObj, 'administrador') !== false) {
                $cfg = ConfigAvisoAccesoModel::obtener();
                if ($cfg && (int)($cfg['activo'] ?? 0) === 1) {
                    foreach (ConfigAvisoAccesoModel::listaDestinos((string)$cfg['destinos']) as $d) $destinos[strtolower($d)] = $d;
                }
            }
            if (!$destinos) {
                Database::log("AvisoBloqueo sin destinos usuario={$usuario}");
                return;
            }
            $asunto = 'Usuario bloqueado por intentos fallidos - ' . $usuario;
            $texto = "El usuario {$usuario} (" . ($obj['nombre_completo'] ?? '') . ", " . ($obj['rol'] ?? '') . ")"
                   . " quedó bloqueado {$minutos} minutos por " . LoginIntentoModel::MAX_INTENTOS . " intentos fallidos de acceso.\n"
                   . "Fecha: " . date('d/m/Y') . "\nHora: " . date('H:i:s') . "\nIP: {$ip}\n\n"
                   . "Si no reconoces esta actividad, revisa la cuenta y cambia la contraseña.";
            AvisoAcceso::enviar(array_values($destinos), $asunto, $texto);
            Database::log("AvisoBloqueo enviado usuario={$usuario} destinos=" . implode(',', $destinos));
        } catch (Throwable $e) {
            Database::log('AvisoBloqueo ERR: ' . $e->getMessage());
        }
    }
}
