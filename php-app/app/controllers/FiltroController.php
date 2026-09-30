<?php
require_once __DIR__ . '/../core/Controller.php';

/**
 * Aplica el filtro de clinica y regresa a la pantalla de origen (patron PRG).
 * Todo viaja por POST: el valor se guarda en sesion y la URL queda limpia.
 */
class FiltroController extends Controller {
    /** Pantallas donde se permite el filtro (evita redirecciones arbitrarias). */
    private const DESTINOS = [
        'citas','citasmanana','citasespera','pacientes','calendario','medicos','especialidades','consultorios',
        'clinicas','asistentes','administradores','usuarios_clinica','reportes',
        'dashboard','sistema','catalogos','horarios','diasbloqueados','mensajes',
    ];

    public function clinica(): void {
        $this->requireLogin();
        $rol = $_SESSION['user']['rol'] ?? '';
        $raw = $this->intOrNull($_POST['f_clinica'] ?? null);

        // Los roles distintos de admin_sistema solo pueden elegir clinicas asignadas.
        if ($rol !== 'admin_sistema') {
            $ids = array_map(fn($c) => (int)($c['id_CLINICA'] ?? 0), $_SESSION['user']['clinicas'] ?? []);
            if ($raw === null || !in_array($raw, $ids, true)) {
                $raw = $_SESSION['f_clinica'] ?? ($ids[0] ?? null);
            }
        }
        // 0 = "todas" (solo admin_sistema).
        $_SESSION['f_clinica'] = $raw === null ? 0 : $raw;

        if (class_exists('Database')) {
            Database::log(sprintf(
                'FILTRO.clinica rol=%s user=%s valor=%s destino=%s',
                $rol,
                $_SESSION['user']['usuario'] ?? '?',
                var_export($_SESSION['f_clinica'], true),
                $_POST['destino'] ?? '?'
            ));
        }

        $destino = (string)($_POST['destino'] ?? 'dashboard');
        $destino = trim($destino, '/');
        $base = explode('/', $destino)[0];
        if (!in_array($base, self::DESTINOS, true)) $destino = 'dashboard';
        $this->redirect($destino);
    }
}