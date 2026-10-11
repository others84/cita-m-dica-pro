<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/MensajeMedicoModel.php';

/**
 * Texto de notificacion de WhatsApp por medico. Cada medico tiene su propio
 * mensaje con variables @@ que se sustituyen al enviar el recordatorio.
 * El medico SIEMPRE debe pertenecer a una clinica permitida para el usuario.
 */
class MensajesController extends Controller {

    private const ROLES = ['medico', 'asistente', 'administrador'];

    public function index(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $rows = $this->medicosVisibles($ctx);

        $editId = $this->stateInt('edit');
        if ($editId !== null && !$this->visible($editId, $rows)) { $editId = null; $this->clearState('edit'); }
        $editRow = null;
        foreach ($rows as $r) { if ($r['id_USUARIOS'] === $editId) { $editRow = $r; break; } }

        $this->view('mensajes/index', [
            'title'          => 'Texto de notificación',
            'rows'           => $rows,
            'editId'         => $editId,
            'editRow'        => $editRow,
            'variables'      => MensajeMedicoModel::variables(),
            'porDefecto'     => MensajeMedicoModel::porDefecto(),
            'maxLen'         => MensajeMedicoModel::MAX,
            'rol'            => $ctx['rol'],
            'fClinica'       => $ctx['fClinica'],
            'clinicasFiltro' => $ctx['clinicasFiltro'],
            'clinicas'       => $ctx['clinicasFiltro'],
        ]);
    }

    public function guardar(): void {
        $this->requireLogin(self::ROLES);
        $ctx = $this->resolveClinicaContext();
        $rows = $this->medicosVisibles($ctx);

        $idMedico = (int)$this->input('id_MEDICO', 0);
        $texto    = trim((string)$this->input('plantilla', ''));

        if (!$this->visible($idMedico, $rows)) {
            if (class_exists('Database')) {
                Database::log('ACCESO DENEGADO recurso=MENSAJE_MEDICO id=' . $idMedico
                    . ' origen=mensajes usuario=' . (string)($_SESSION['user']['usuario'] ?? '?'));
            }
            $this->flash('error', 'No tiene permiso para modificar el texto de ese médico.');
            $this->redirect('mensajes');
        }

        if ($texto === '') {
            $this->flash('error', 'Captura el texto de notificación.');
            $this->redirect('mensajes');
        }
        if (mb_strlen($texto) > MensajeMedicoModel::MAX) {
            $this->flash('error', 'El texto no puede exceder ' . MensajeMedicoModel::MAX . ' caracteres.');
            $this->redirect('mensajes');
        }

        $nombre = '';
        foreach ($rows as $r) { if ($r['id_USUARIOS'] === $idMedico) { $nombre = (string)$r['nombre_completo']; break; } }

        try {
            MensajeMedicoModel::guardar($idMedico, $texto);
        } catch (Throwable $e) {
            $this->flash('error', 'No se pudo guardar el texto: ' . $e->getMessage());
            $this->redirect('mensajes');
        }

        if (class_exists('Database')) {
            Database::log('TEXTO NOTIFICACION definido medico="' . $nombre . '"'
                . ' usuario=' . (string)($_SESSION['user']['usuario'] ?? '?')
                . ' clinica=' . (string)($_SESSION['f_clinica'] ?? '(n/d)')
                . ' texto=' . mb_substr($texto, 0, 300));
        }

        $this->flash('ok', 'Texto de notificación guardado.');
        $this->clearState('edit');
        $this->redirect('mensajes');
    }

    /**
     * Medicos que el usuario puede ver: solo los de las clinicas permitidas.
     * Un medico sin clinica nunca aparece. Si el rol es medico, solo el mismo.
     * @return array<int,array<string,mixed>>
     */
    private function medicosVisibles(array $ctx): array {
        $medicos = [];
        try { $medicos = UsuarioModel::listarMedicos($ctx['fClinica']); } catch (Throwable $e) { $medicos = []; }

        if (($ctx['rol'] ?? '') === 'medico') {
            $yo = (int)($_SESSION['user']['id_USUARIOS'] ?? 0);
            $medicos = array_values(array_filter($medicos, fn($m) => (int)($m['id_USUARIOS'] ?? 0) === $yo));
        }

        $textos = MensajeMedicoModel::todos();
        $rows = [];
        foreach ($medicos as $m) {
            $id = (int)($m['id_USUARIOS'] ?? 0);
            if ($id <= 0) continue;
            // El medico SIEMPRE debe pertenecer a una clinica.
            $clinica = trim((string)($m['clinica'] ?? ''));
            if ($clinica === '' && (int)($m['id_CLINICA'] ?? 0) <= 0) continue;
            $rows[] = [
                'id_USUARIOS'     => $id,
                'nombre_completo' => (string)($m['nombre_completo'] ?? ''),
                'clinica'         => $clinica,
                'plantilla'       => $textos[$id] ?? MensajeMedicoModel::porDefecto(),
                'personalizado'   => isset($textos[$id]),
            ];
        }
        return $rows;
    }

    /** @param array<int,array<string,mixed>> $rows */
    private function visible(int $idMedico, array $rows): bool {
        if ($idMedico <= 0) return false;
        foreach ($rows as $r) if ((int)$r['id_USUARIOS'] === $idMedico) return true;
        return false;
    }
}

