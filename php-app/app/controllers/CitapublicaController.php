<?php
require_once __DIR__ . '/../core/Controller.php';
require_once __DIR__ . '/../models/ClinicaModel.php';
require_once __DIR__ . '/../models/UsuarioModel.php';
require_once __DIR__ . '/../models/ConsultorioModel.php';
require_once __DIR__ . '/../models/EspecialidadModel.php';
require_once __DIR__ . '/../models/PacienteModel.php';
require_once __DIR__ . '/../models/CitaModel.php';
require_once __DIR__ . '/../models/EstadoCitaModel.php';
require_once __DIR__ . '/../models/GeneroModel.php';
require_once __DIR__ . '/../models/PaisModel.php';
require_once __DIR__ . '/../models/EstadoModel.php';
require_once __DIR__ . '/../models/MunicipioModel.php';
require_once __DIR__ . '/../models/LogModel.php';

/**
 * Pagina publica (sin sesion) para que un paciente agende su cita.
 * Todas las altas se registran con el usuario GENERICO (rol asistente).
 */
class CitapublicaController extends Controller {

    private const NS = 'citapublica';

    /* ---------------- estado en sesion ---------------- */
    private function st(): array { return $_SESSION['ui'][self::NS] ?? []; }
    private function set(string $k, $v): void { $_SESSION['ui'][self::NS][$k] = $v; }
    private function get(string $k, $d = null) { return $_SESSION['ui'][self::NS][$k] ?? $d; }
    private function reset(): void { $_SESSION['ui'][self::NS] = []; }

    /* ---------------- pantalla ---------------- */
    public function index(): void {
        $idClinica = (int)$this->get('id_CLINICA', 0) ?: null;
        $idMedico  = (int)$this->get('id_MEDICO', 0) ?: null;

        $clinicas = [];
        try { $clinicas = array_values(array_filter(ClinicaModel::listar(), fn($c) => (int)($c['activo'] ?? 1) === 1)); }
        catch (Throwable $e) { $this->flash('error', 'No se pudieron cargar las clinicas: ' . $e->getMessage()); }

        $medicos = $consultorios = $especialidades = [];
        if ($idClinica) {
            try { $medicos        = UsuarioModel::listarMedicos($idClinica); } catch (Throwable $e) { $medicos = []; }
            try { $consultorios   = ConsultorioModel::listar($idClinica); }    catch (Throwable $e) { $consultorios = []; }
            try { $especialidades = EspecialidadModel::listar($idClinica); }   catch (Throwable $e) { $especialidades = []; }
        }
        if ($idMedico) {
            $ids = array_map(fn($m) => (int)($m['id_USUARIOS'] ?? 0), $medicos);
            if (!in_array($idMedico, $ids, true)) { $idMedico = null; $this->set('id_MEDICO', 0); }
        }

        // Consultorio y especialidad GENERICO de la clinica (obligatorios en la cita publica).
        $genCons = $idClinica ? $this->buscaGenerico($consultorios, 'id_CONSULTORIO') : null;
        $genEsp  = $idClinica ? $this->buscaGenerico($especialidades, 'id_CATALOGO_ESPECIALIDAD') : null;
        if ($idClinica && !$genCons) $this->flash('error', 'Esta clinica aun no tiene habilitada la cita en linea. Elige otra clinica o llama a la clinica.');
        if ($idClinica && !$genEsp)  $this->flash('error', 'Esta clinica aun no tiene habilitada la cita en linea. Elige otra clinica o llama a la clinica.');
        $this->set('id_CONSULTORIO', $genCons ? (int)$genCons['id'] : 0);
        $this->set('id_CATALOGO_ESPECIALIDAD', $genEsp ? (int)$genEsp['id'] : 0);

        $eventos = $idClinica && $idMedico ? $this->eventosMedico($idMedico, $idClinica) : [];

        $this->render([
            'clinicas'       => $clinicas,
            'medicos'        => $medicos,
            'consultorios'   => $consultorios,
            'especialidades' => $especialidades,
            'idClinica'      => $idClinica,
            'idMedico'       => $idMedico,
            'idConsultorio'  => $genCons ? (int)$genCons['id'] : 0,
            'idEspecialidad' => $genEsp ? (int)$genEsp['id'] : 0,
            'consultorioNom' => $genCons['nombre'] ?? '',
            'especialidadNom'=> $genEsp['nombre'] ?? '',
            'eventos'        => $eventos,
            'paso'           => (string)$this->get('paso', 'buscar'),
            'telefono'       => (string)$this->get('telefono', ''),
            'coincidencias'  => (array)$this->get('coincidencias', []),
            'paciente'       => (array)$this->get('paciente', []),
            'idPaciente'     => (int)$this->get('id_PACIENTE', 0),
            'generos'        => $this->cat(fn() => GeneroModel::listar()),
            'paises'         => $this->cat(fn() => PaisModel::listar()),
            'estados'        => $this->cat(fn() => EstadoModel::listar()),
            'municipios'     => $this->cat(fn() => MunicipioModel::listar()),
        ]);
    }

    /** Localiza el registro llamado GENERICO en un catalogo de la clinica. */
    private function buscaGenerico(array $rows, string $key): ?array {
        foreach ($rows as $r) {
            $n = strtolower(strtr(trim((string)($r['nombre'] ?? '')), ['á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u']));
            if ($n === 'generico') return ['id' => (int)($r[$key] ?? 0), 'nombre' => (string)$r['nombre']];
        }
        return null;
    }


    private function cat(callable $f): array {
        try { return $f(); } catch (Throwable $e) { return []; }
    }

    /** Vista de pagina completa: no usa el layout con menu del sistema. */
    private function render(array $data): void {
        $data['flash'] = $_SESSION['flash'] ?? [];
        unset($_SESSION['flash']);
        extract($data);
        require __DIR__ . '/../views/citapublica/index.php';
    }

    /** Citas agendadas del medico (solo bloques ocupados, sin datos del paciente). */
    private function eventosMedico(int $idMedico, int $idClinica): array {
        $out = [];
        try {
            $citas = CitaModel::listar($idMedico, date('Y-m-d', strtotime('-7 days')),
                                       date('Y-m-d', strtotime('+120 days')), $idClinica);
        } catch (Throwable $e) { return []; }
        foreach ($citas as $c) {
            if ((int)($c['id_MEDICO'] ?? 0) !== $idMedico) continue;
            $estado = strtolower(strtr(trim((string)($c['estado'] ?? '')), ['á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u']));
            if (strpos($estado, 'agendada') === false && strpos($estado, 'confirmada') === false) continue;
            [$f, $hi, $hf] = $this->fechas($c);
            if ($f === '') continue;
            $out[] = ['id'=>(string)$c['id_CITA'], 'title'=>'Ocupado',
                      'start'=>$f.'T'.$hi, 'end'=>$f.'T'.$hf, 'color'=>'#94a3b8'];
        }
        return $out;
    }

    /** Fecha en palabras: "lunes 24 de agosto de 2026". */
    private function fechaLarga(string $ymd): string {
        $t = strtotime($ymd);
        if (!$t) return $ymd;
        $dias  = ['domingo','lunes','martes','miercoles','jueves','viernes','sabado'];
        $meses = ['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre'];
        return $dias[(int)date('w', $t)] . ' ' . (int)date('j', $t) . ' de ' . $meses[(int)date('n', $t) - 1] . ' de ' . date('Y', $t);
    }

    private function fechas(array $c): array {
        $g = function ($v, string $fmt) { return $v instanceof DateTime ? $v->format($fmt) : (string)$v; };
        $f  = substr($g($c['fecha_cita'] ?? '', 'Y-m-d'), 0, 10);
        $hi = substr($g($c['hora_inicio'] ?? '', 'H:i:s'), 0, 8);
        $hf = substr($g($c['hora_fin'] ?? '', 'H:i:s'), 0, 8);
        return [$f, $hi, $hf];
    }

    /* ---------------- paso 1: paciente existente / nuevo ---------------- */

    public function buscar(): void {
        $tel = (string)$this->input('telefono', '');
        $dig = PacienteModel::soloDigitos($tel);
        if (strlen($dig) < 10) {
            $this->flash('error', 'El celular debe tener 10 numeros. Ejemplo: 2221234567.');
            $this->redirect('citapublica');
        }
        $this->reset();
        $this->set('telefono', $tel);
        try { $rows = PacienteModel::buscarPorTelefono($tel); }
        catch (Throwable $e) { $rows = []; $this->flash('error', 'No pudimos buscar tu numero en este momento. Intenta de nuevo en unos minutos.'); }

        if (empty($rows)) {
            $this->set('paso', 'nuevo');
            $this->set('coincidencias', []);
            $this->flash('info', 'No encontramos tu numero. No hay problema: elige tu clinica y llena tus datos abajo.');
            $this->redirect('citapublica');
        }
        $lista = array_map(fn($p) => [
            'id_PACIENTE' => (int)$p['id_PACIENTE'],
            'id_CLINICA'  => (int)$p['id_CLINICA'],
            'clinica'     => (string)($p['clinica'] ?? ''),
        ], $rows);
        $this->set('coincidencias', $lista);
        if (count($lista) === 1) {
            $this->cargarPaciente((int)$lista[0]['id_PACIENTE'], (int)$lista[0]['id_CLINICA']);
            $this->redirect('citapublica');
        }
        $this->set('paso', 'elige_clinica');
        $this->redirect('citapublica');
    }

    /** Fuerza el alta de un paciente nuevo (boton "Soy paciente nuevo"). */
    public function nuevo(): void {
        $tel = (string)$this->get('telefono', '');
        $this->reset();
        $this->set('telefono', $tel);
        $this->set('paso', 'nuevo');
        $this->redirect('citapublica');
    }

    /** Selecciona clinica: para paciente existente carga sus datos. */
    public function clinica(): void {
        $id = (int)$this->input('id_CLINICA', 0);
        if ($id <= 0) { $this->redirect('citapublica'); }
        $this->set('id_CLINICA', $id);
        $this->set('id_MEDICO', 0);
        $this->set('id_CONSULTORIO', 0);
        $this->set('id_CATALOGO_ESPECIALIDAD', 0);
        foreach ((array)$this->get('coincidencias', []) as $c) {
            if ((int)$c['id_CLINICA'] === $id) {
                $this->cargarPaciente((int)$c['id_PACIENTE'], $id);
                $this->redirect('citapublica');
            }
        }
        $this->set('paso', 'nuevo');
        $this->set('id_PACIENTE', 0);
        $this->set('paciente', []);
        $this->redirect('citapublica');
    }

    private function cargarPaciente(int $idPaciente, int $idClinica): void {
        $row = null;
        try { $row = PacienteModel::obtener($idPaciente); } catch (Throwable $e) { $row = null; }
        if (!$row) { $this->set('paso', 'nuevo'); return; }
        $fn = $row['fecha_nacimiento'] ?? '';
        if ($fn instanceof DateTime) $fn = $fn->format('Y-m-d');
        $this->set('id_CLINICA', $idClinica);
        $this->set('id_PACIENTE', $idPaciente);
        $this->set('paciente', [
            'ap_paterno' => (string)($row['ap_paterno'] ?? ''),
            'ap_materno' => (string)($row['ap_materno'] ?? ''),
            'nombre'     => (string)($row['nombre'] ?? ''),
            'direccion'  => (string)($row['direccion'] ?? ''),
            'telefono'   => (string)($row['telefono'] ?? ''),
            'email'      => (string)($row['email'] ?? ''),
            'fecha_nacimiento' => substr((string)$fn, 0, 10),
            'id_CATALOGO_GENERO'    => (int)($row['id_CATALOGO_GENERO'] ?? 0),
            'id_CATALOGO_MUNICIPIO' => (int)($row['id_CATALOGO_MUNICIPIO'] ?? 0),
            'observaciones'  => (string)($row['observaciones'] ?? ''),
            'notifica_email' => (int)($row['notifica_email'] ?? 0),
            'notifica_wa'    => (int)($row['notifica_wa'] ?? 0),
        ]);
        $this->set('paso', 'cita');
    }

    /* ---------------- paso 2: medico / consultorio / especialidad ---------------- */

    public function seleccion(): void {
        foreach (['id_MEDICO', 'id_CONSULTORIO', 'id_CATALOGO_ESPECIALIDAD'] as $k) {
            if (array_key_exists($k, $_POST)) $this->set($k, (int)$_POST[$k]);
        }
        $this->redirect('citapublica');
    }

    /* ---------------- paso 3: agendar ---------------- */

    public function agendar(): void {
        $idClinica = (int)$this->get('id_CLINICA', 0);
        if ($idClinica <= 0) { $this->flash('error', 'Falta elegir tu clinica en el paso 2.'); $this->redirect('citapublica'); }

        // Usuario GENERICO: obligatorio para poder registrar.
        $gen = null;
        try { $gen = UsuarioModel::generico(); } catch (Throwable $e) { $gen = null; }
        $clinicaNom = '';
        try { $clinicaNom = ClinicaModel::nombre($idClinica); } catch (Throwable $e) {}
        if (!$gen || (!empty($gen['clinicas']) && !in_array($idClinica, $gen['clinicas'], true))) {
            $msg = !$gen
                ? 'No existe el usuario GENERICO activo en el sistema; no es posible registrar la cita.'
                : 'El usuario GENERICO no esta asignado a la clinica ' . $clinicaNom . '; no es posible registrar la cita.';
            Database::log('CITA PUBLICA ERROR: ' . $msg . ' id_CLINICA=' . $idClinica);
            $this->ev('CITA', 'CITA',
                'ERROR CITA PUBLICA usuario=GENERICO id_CLINICA=' . $idClinica . ' clinica=' . $clinicaNom . ' detalle=' . $msg);
            $this->flash('error', 'No pudimos agendar tu cita en esta clinica. Por favor llama a la clinica para que te apoyen.');
            $this->redirect('citapublica');
        }

        $idMedico       = (int)$this->input('id_MEDICO', 0);
        $fecha          = (string)$this->input('fecha_cita', '');
        $hi             = (string)$this->input('hora_inicio', '');
        // Cita publica: solo horas completas. Se recortan los minutos y la cita dura 1 hora.
        $hf             = '';
        if (preg_match('/^(\d{1,2}):\d{2}/', $hi, $mm)) {
            $h  = (int)$mm[1];
            if ($h >= 0 && $h <= 23) {
                $hi = sprintf('%02d:00', $h);
                $hf = sprintf('%02d:00', $h + 1);
            } else { $hi = ''; }
        } else { $hi = ''; }

        // Consultorio y especialidad SIEMPRE GENERICO (tomados de la BD).
        $genCons = $genEsp = null;
        try { $genCons = $this->buscaGenerico(ConsultorioModel::listar($idClinica), 'id_CONSULTORIO'); } catch (Throwable $e) {}
        try { $genEsp  = $this->buscaGenerico(EspecialidadModel::listar($idClinica), 'id_CATALOGO_ESPECIALIDAD'); } catch (Throwable $e) {}
        if (!$genCons || !$genEsp) {
            $msg = !$genCons
                ? 'No existe el consultorio GENERICO en la clinica seleccionada; no es posible registrar la cita.'
                : 'No existe la especialidad GENERICO en la clinica seleccionada; no es posible registrar la cita.';
            Database::log('CITA PUBLICA ERROR: ' . $msg . ' id_CLINICA=' . $idClinica);
            $this->ev('CITA', 'CITA', 'ERROR CITA PUBLICA id_CLINICA=' . $idClinica . ' clinica=' . $clinicaNom . ' detalle=' . $msg);
            $this->flash('error', 'No pudimos agendar tu cita en esta clinica. Por favor llama a la clinica para que te apoyen.');
            $this->redirect('citapublica');
        }
        $idConsultorio  = (int)$genCons['id'];
        $idEspecialidad = (int)$genEsp['id'];

        $this->set('id_MEDICO', $idMedico);
        $this->set('id_CONSULTORIO', $idConsultorio);
        $this->set('id_CATALOGO_ESPECIALIDAD', $idEspecialidad);

        $err = [];
        if ($idMedico <= 0)       $err[] = 'Falta elegir al medico. Selecciona uno en el paso 2.';
        if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $fecha)) $err[] = 'Aun no eliges dia. Toca un espacio en blanco del calendario.';
        if (!preg_match('/^\d{2}:\d{2}/', $hi) || !preg_match('/^\d{2}:\d{2}/', $hf)) $err[] = 'Aun no eliges horario. Toca un espacio en blanco del calendario.';
        if (!$err && strtotime($fecha . ' ' . $hf) <= strtotime($fecha . ' ' . $hi)) $err[] = 'La hora de termino debe ser despues de la hora de inicio.';
        if (!$err && strtotime($fecha . ' ' . $hi) < time()) $err[] = 'Ese dia y hora ya pasaron. Elige un horario proximo en el calendario.';

        // Pertenencia a la clinica seleccionada.
        $medicoNom = '';
        if (!$err) {
            try {
                $ok = false;
                foreach (UsuarioModel::listarMedicos($idClinica) as $r) {
                    if ((int)($r['id_USUARIOS'] ?? 0) === $idMedico) {
                        $ok = true; $medicoNom = (string)($r['nombre_completo'] ?? ''); break;
                    }
                }
                if (!$ok) $err[] = 'Ese medico no atiende en la clinica que elegiste. Elige otro medico.';
            } catch (Throwable $e) { $err[] = 'No pudimos comprobar tus datos en este momento. Intenta de nuevo en unos minutos.'; }
        }


        // Traslape con las citas del medico.
        if (!$err) {
            $ini = strtotime($fecha . ' ' . $hi); $fin = strtotime($fecha . ' ' . $hf);
            try {
                foreach (CitaModel::listar($idMedico, $fecha, $fecha, $idClinica) as $c) {
                    if ((int)($c['id_MEDICO'] ?? 0) !== $idMedico) continue;
                    $estado = strtolower(strtr(trim((string)($c['estado'] ?? '')), ['á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u']));
                    if (strpos($estado, 'agendada') === false && strpos($estado, 'confirmada') === false) continue;
                    [$f2, $h2i, $h2f] = $this->fechas($c);
                    if ($f2 !== $fecha) continue;
                    if ($ini < strtotime($f2 . ' ' . $h2f) && strtotime($f2 . ' ' . $h2i) < $fin) {
                        $err[] = 'Ese horario ya lo tomo otra persona. Elige otro espacio en blanco del calendario.'; break;
                    }
                }
            } catch (Throwable $e) { /* si falla la consulta, la BD valida al insertar */ }
        }

        // Datos del paciente.
        $idPaciente = (int)$this->get('id_PACIENTE', 0);
        $p = [
            'ap_paterno' => (string)$this->input('ap_paterno', ''),
            'ap_materno' => (string)$this->input('ap_materno', ''),
            'nombre'     => (string)$this->input('nombre', ''),
            'direccion'  => (string)$this->input('direccion', ''),
            'telefono'   => (string)$this->input('telefono', ''),
            'email'      => (string)$this->input('email', ''),
            'fecha_nacimiento' => (string)$this->input('fecha_nacimiento', ''),
            'id_CATALOGO_GENERO'    => (int)$this->input('id_CATALOGO_GENERO', 0),
            'id_CATALOGO_MUNICIPIO' => (int)$this->input('id_CATALOGO_MUNICIPIO', 0),
            'observaciones'  => (string)$this->input('observaciones', ''),
            'notifica_email' => !empty($_POST['notifica_email']) ? 1 : 0,
            'notifica_wa'    => !empty($_POST['notifica_wa']) ? 1 : 0,
        ];
        $this->set('paciente', $p);
        if ($idPaciente <= 0) {
            foreach (['ap_paterno'=>'apellido paterno','ap_materno'=>'apellido materno','nombre'=>'nombre(s)',
                      'direccion'=>'direccion','telefono'=>'celular','fecha_nacimiento'=>'fecha de nacimiento'] as $k => $lbl) {
                if (trim((string)$p[$k]) === '') $err[] = 'Falta tu ' . $lbl . '. Escribelo para continuar.';
            }
            if (!filter_var($p['email'], FILTER_VALIDATE_EMAIL)) $err[] = 'Revisa tu correo. Debe ser como: nombre@correo.com';
            if ($p['id_CATALOGO_GENERO'] <= 0)    $err[] = 'Falta elegir tu sexo en la lista.';
            if ($p['id_CATALOGO_MUNICIPIO'] <= 0) $err[] = 'Falta tu lugar: elige primero el pais, luego el estado y al final el municipio.';
        }
        if (mb_strlen($p['observaciones']) > 500) $err[] = 'El motivo de tu consulta es muy largo. Escribelo en 500 letras o menos.';

        if ($err) {
            foreach (array_unique($err) as $m) $this->flash('error', $m);
            $this->redirect('citapublica');
        }

        // Estado "Agendada".
        $idEstado = 0;
        try {
            foreach (EstadoCitaModel::listar() as $e) {
                $n = strtolower(strtr(trim((string)($e['nombre'] ?? '')), ['á'=>'a','é'=>'e','í'=>'i','ó'=>'o','ú'=>'u']));
                if (strpos($n, 'agendada') !== false || strpos($n, 'agendado') !== false) {
                    $idEstado = (int)$e['id_CATALOGO_ESTADO_CITAS']; break;
                }
            }
        } catch (Throwable $e) {}
        if ($idEstado <= 0) { $this->flash('error', 'No pudimos agendar en este momento. Intenta mas tarde o llama a la clinica.'); $this->redirect('citapublica'); }

        // A partir de aqui, todo se guarda como el usuario GENERICO.
        Model::usarUsuario((int)$gen['id_USUARIOS']);
        try {
            if ($idPaciente <= 0) {
                $idPaciente = PacienteModel::alta($idClinica, $p['ap_paterno'], $p['ap_materno'], $p['nombre'],
                    $p['direccion'], $p['telefono'], $p['email'], $p['fecha_nacimiento'],
                    $p['id_CATALOGO_GENERO'], $p['id_CATALOGO_MUNICIPIO'], $p['observaciones'],
                    $p['notifica_email'], $p['notifica_wa']);
                if ($idPaciente <= 0) throw new RuntimeException('No se pudo registrar el paciente.');
                $this->set('id_PACIENTE', $idPaciente);
                $this->ev('PACIENTE', 'PACIENTE',
                    'ALTA PACIENTE PUBLICA id_PACIENTE=' . $idPaciente . ' clinica=' . $clinicaNom .
                    ' id_CLINICA=' . $idClinica . ' usuario=GENERICO');
                Database::log('CITA PUBLICA alta paciente id=' . $idPaciente . ' clinica=' . $clinicaNom);
            }

            $idCita = CitaModel::alta([
                'id_PACIENTE' => $idPaciente,
                'fecha_cita'  => $fecha,
                'hora_inicio' => substr($hi, 0, 5) . ':00',
                'hora_fin'    => substr($hf, 0, 5) . ':00',
                'id_CATALOGO_ESTADO_CITAS' => $idEstado,
                'observaciones' => $p['observaciones'],
                'horas_anticipacion_notif' => 24,
                'precio' => 0,
                'id_MEDICO' => $idMedico,
                'id_CATALOGO_ESPECIALIDAD' => $idEspecialidad,
                'id_CONSULTORIO' => $idConsultorio,
            ]);

            try { LogModel::estadoCita($idCita, null, 'Agendada', $idClinica, $clinicaNom, 'GENERICO'); }
            catch (Throwable $e) { Database::log('CITA PUBLICA log estado ERR: ' . $e->getMessage()); }
            $this->ev('CITA', 'CITA',
                'ALTA CITA PUBLICA id_CITA=' . $idCita . ' id_PACIENTE=' . $idPaciente .
                ' id_MEDICO=' . $idMedico . ' clinica=' . $clinicaNom . ' fecha=' . $fecha . ' hora=' . substr($hi, 0, 5) .
                ' usuario=GENERICO');
            Database::log('CITA PUBLICA alta cita id=' . $idCita . ' clinica=' . $clinicaNom .
                ' medico=' . $idMedico . ' paciente=' . $idPaciente . ' fecha=' . $fecha . ' ' . substr($hi, 0, 5));
            $this->flash('ok', 'Listo. Tu cita quedo agendada para el ' . $this->fechaLarga($fecha) .
                ' a las ' . substr($hi, 0, 5) . ' hrs' .
                ($medicoNom !== '' ? ' con ' . $medicoNom : '') .
                ($clinicaNom !== '' ? ' en ' . $clinicaNom : '') .
                '. Llega 10 minutos antes. Si no puedes asistir, avisa a la clinica.');
            // Deja la pantalla como recien abierta para poder generar otra cita.
            $this->reset();

        } catch (Throwable $e) {
            Database::log('CITA PUBLICA ERROR alta: ' . $e->getMessage());
            $this->ev('CITA', 'CITA', 'ERROR ALTA CITA PUBLICA clinica=' . $clinicaNom . ' detalle=' . $e->getMessage());
            $this->flash('error', 'No pudimos guardar tu cita. Revisa tus datos e intenta otra vez; si sigue igual, llama a la clinica.');
        } finally {
            Model::usarUsuario(null);
        }
        $this->redirect('citapublica');
    }

    /** Log tolerante: si el modelo/SP no existe, solo escribe en app.log. */
    private function ev(string $modulo, string $tabla, string $evento): void {
        try {
            if (method_exists('LogModel', 'evento')) {
                LogModel::evento($modulo, 'CitapublicaController::agendar', $tabla, $evento);
                return;
            }
        } catch (Throwable $e) {
            Database::log('CITA PUBLICA log ERR: ' . $e->getMessage());
        }
        Database::log('[' . $modulo . '] ' . $evento);
    }

    /** Empieza de nuevo (otro paciente). */
    public function reiniciar(): void {
        $this->reset();
        $this->redirect('citapublica');
    }
}
