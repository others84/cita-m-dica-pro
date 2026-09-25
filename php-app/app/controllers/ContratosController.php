<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/DocumentoLegalModel.php';
require_once __DIR__ . '/../models/ClinicaModel.php';

class ContratosController extends Controller {

    /* ---------- Plantillas (Administrador de Sistema) ---------- */
    public function index(): void { $this->plantillas(); }

    public function plantillas(): void {
        $this->requireLogin(['admin_sistema']);
        $this->view('contratos/plantillas', [
            'title' => 'Plantillas legales',
            'plantillas' => DocumentoLegalModel::plantillas(),
        ]);
    }

    public function guardarPlantilla(): void {
        $this->requireLogin(['admin_sistema']);
        $tipo = (string)$this->input('tipo', '');
        try {
            if (!isset(DocumentoLegalModel::TIPOS[$tipo])) throw new RuntimeException('Tipo invalido.');
            $html = (string)($_POST['html'] ?? '');
            if (trim(strip_tags($html)) === '') throw new RuntimeException('El documento no puede estar vacio.');
            DocumentoLegalModel::guardarPlantilla($tipo, $html);
            $this->flash('ok', 'Plantilla guardada.');
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('contratos/plantillas');
    }

    /* ---------- Documentos por clinica (Administrador de Sistema) ---------- */
    public function clinica(): void {
        $this->requireLogin(['admin_sistema']);
        $id = (int)$this->stateParam('id', 0);
        $cl = $id ? ClinicaModel::obtener($id) : null;
        if (!$cl) { $this->flash('error', 'Seleccione una clinica.'); $this->redirect('clinicas'); }
        try { DocumentoLegalModel::asegurar($id); } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->view('contratos/clinica', [
            'title' => 'Contrato y aviso: ' . $cl['nombre'],
            'clinica' => $cl,
            'docs' => DocumentoLegalModel::vigentes($id),
            'historial' => DocumentoLegalModel::historial($id),
            'firmas' => DocumentoLegalModel::firmas($id),
        ]);
    }

    public function guardarClinica(): void {
        $this->requireLogin(['admin_sistema']);
        $id = (int)($_SESSION['ui']['contratos']['id'] ?? 0);
        $tipo = (string)$this->input('tipo', '');
        try {
            if ($id <= 0 || !ClinicaModel::obtener($id)) throw new RuntimeException('Clinica invalida.');
            if (!isset(DocumentoLegalModel::TIPOS[$tipo])) throw new RuntimeException('Tipo invalido.');
            if ($this->input('desde_plantilla')) {
                $pl = DocumentoLegalModel::plantillas();
                $html = (string)($pl[$tipo]['html'] ?? '');
            } else {
                $html = (string)($_POST['html'] ?? '');
            }
            if (trim(strip_tags($html)) === '') throw new RuntimeException('El documento no puede estar vacio.');
            $vig = DocumentoLegalModel::vigentes($id);
            if (isset($vig[$tipo]) && trim((string)$vig[$tipo]['html']) === trim(DocumentoLegalModel::sanitizar($html))) {
                $this->flash('ok', 'Sin cambios; no se publico nueva version.');
            } else {
                DocumentoLegalModel::publicar($id, $tipo, $html);
                $this->flash('ok', 'Nueva version publicada. Los usuarios de la clinica deberan aceptarla al ingresar.');
            }
        } catch (Throwable $e) { $this->flash('error', $e->getMessage()); }
        $this->redirect('contratos/clinica');
    }

    /* ---------- Firma (Asistente, Medico, Administrador de clinica) ---------- */
    public function firmar(): void {
        $this->requireLogin();
        $u = $_SESSION['user'];
        if ($u['rol'] === 'admin_sistema') $this->redirect('clinicas');
        $pend = self::cargarPendientes();
        if (empty($pend)) $this->redirect('calendario');
        $porClinica = [];
        foreach ($pend as $d) {
            $d['html_render'] = DocumentoLegalModel::render((string)$d['html'], self::variables($d, $u));
            $porClinica[(int)$d['id_CLINICA']]['nombre'] = $d['clinica'];
            $porClinica[(int)$d['id_CLINICA']]['docs'][] = $d;
        }
        $this->view('contratos/firmar', ['title' => 'Contrato y aviso de privacidad', 'porClinica' => $porClinica]);
    }

    public function aceptar(): void {
        $this->requireLogin();
        $u = $_SESSION['user'];
        if ($u['rol'] === 'admin_sistema') $this->redirect('clinicas');
        $pend = self::cargarPendientes();
        $acepta = (array)($_POST['acepto'] ?? []);
        foreach ($pend as $d) {
            if (empty($acepta[(int)$d['id_DOCUMENTO_CLINICA']])) {
                $this->flash('error', 'Debe marcar "He leido y acepto" en todos los documentos.');
                $this->redirect('contratos/firmar');
            }
        }
        try {
            $ip = self::ipCliente(); $ua = (string)($_SERVER['HTTP_USER_AGENT'] ?? '');
            foreach ($pend as $d) DocumentoLegalModel::firmar((int)$d['id_DOCUMENTO_CLINICA'], (int)$u['id_USUARIOS'], $ip, $ua);
            Database::log(sprintf('CONTRATOS FIRMADOS usuario="%s" docs=%d ip=%s', $u['usuario'], count($pend), $ip));
            self::cargarPendientes();
            $this->flash('ok', 'Gracias. Documentos aceptados.');
        } catch (Throwable $e) {
            $this->flash('error', $e->getMessage());
            $this->redirect('contratos/firmar');
        }
        $this->redirect('calendario');
    }

    /** Recalcula y guarda en sesion los documentos pendientes del usuario. */
    public static function cargarPendientes(): array {
        $u = $_SESSION['user'] ?? null;
        if (!$u || ($u['rol'] ?? '') === 'admin_sistema') { $_SESSION['contratos_pendientes'] = 0; return []; }
        try {
            foreach ($u['clinicas'] ?? [] as $c) DocumentoLegalModel::asegurar((int)($c['id_CLINICA'] ?? 0));
            $p = DocumentoLegalModel::pendientes((int)$u['id_USUARIOS']);
        } catch (Throwable $e) {
            Database::log('CONTRATOS pendientes ERR: ' . $e->getMessage());
            $p = [];
        }
        $_SESSION['contratos_pendientes'] = count($p);
        return $p;
    }

    private static function variables(array $d, array $u): array {
        $roles = ['administrador' => 'Administrador de clinica', 'medico' => 'Medico', 'asistente' => 'Asistente'];
        return [
            'CLINICA' => $d['clinica'] ?? '', 'DIRECCION' => $d['direccion'] ?? '',
            'EMAIL_CLINICA' => $d['email_clinica'] ?? '', 'TELEFONO_CLINICA' => $d['telefono_clinica'] ?? '',
            'FECHA' => date('d/m/Y'), 'USUARIO' => $u['usuario'] ?? '',
            'NOMBRE_USUARIO' => $u['nombre'] ?? '', 'ROL' => $roles[$u['rol']] ?? ($u['rol_nombre'] ?? ''),
        ];
    }

    /** IP del cliente; X-Forwarded-For solo si TRUSTED_PROXY coincide con REMOTE_ADDR. */
    private static function ipCliente(): string {
        $ip = (string)($_SERVER['REMOTE_ADDR'] ?? '0.0.0.0');
        $proxy = class_exists('Config') && method_exists('Config', 'get') ? (string)(Config::get('TRUSTED_PROXY') ?? '') : '';
        if ($proxy !== '' && $ip === $proxy && !empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $f = trim(explode(',', (string)$_SERVER['HTTP_X_FORWARDED_FOR'])[0]);
            if (filter_var($f, FILTER_VALIDATE_IP)) $ip = $f;
        }
        return $ip;
    }
}
