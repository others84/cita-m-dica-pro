<?php
require_once __DIR__ . '/../includes/functions.php';
requerir_login();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: dashboard.php');
    exit;
}

if (!csrf_valido($_POST['csrf_token'] ?? '')) {
    die('Solicitud inválida. Regresa al panel e inténtalo de nuevo.');
}

/**
 * Limpia recursivamente espacios sobrantes de cada valor de texto recibido.
 */
function limpiar($valor) {
    if (is_array($valor)) {
        return array_map('limpiar', $valor);
    }
    return trim((string) $valor);
}

$contenido_anterior = cargar_contenido();

$sitio = limpiar($_POST['sitio'] ?? array());
$inicio = limpiar($_POST['inicio'] ?? array());
$quienes_somos = limpiar($_POST['quienes_somos'] ?? array());
$ubicacion = limpiar($_POST['ubicacion'] ?? array());
$servicios_post = limpiar($_POST['servicios'] ?? array());

// Reconstruye la lista de servicios, descartando filas vacías
$iconos_validos = array('consulta', 'pediatria', 'obstetricia', 'general');
$servicios = array();
foreach ($servicios_post as $fila) {
    $titulo = $fila['titulo'] ?? '';
    $descripcion = $fila['descripcion'] ?? '';
    if ($titulo === '' && $descripcion === '') {
        continue;
    }
    $icono = in_array($fila['icono'] ?? '', $iconos_validos, true) ? $fila['icono'] : 'general';
    $servicios[] = array(
        'titulo' => $titulo,
        'descripcion' => $descripcion,
        'icono' => $icono,
    );
}
if (empty($servicios)) {
    $servicios = $contenido_anterior['servicios'];
}

// Validación básica del enlace de citas y del mapa (deben ser URLs si se proporcionan)
if (!empty($sitio['link_citas']) && !filter_var($sitio['link_citas'], FILTER_VALIDATE_URL)) {
    die('El enlace para agendar citas no es una URL válida. Regresa e inténtalo de nuevo.');
}
if (!empty($ubicacion['mapa_embed']) && !filter_var($ubicacion['mapa_embed'], FILTER_VALIDATE_URL)) {
    die('El enlace del mapa no es una URL válida. Regresa e inténtalo de nuevo.');
}

$nuevo_contenido = array(
    'sitio' => array(
        'nombre_clinica' => $sitio['nombre_clinica'] ?? $contenido_anterior['sitio']['nombre_clinica'],
        'telefono'       => $sitio['telefono'] ?? $contenido_anterior['sitio']['telefono'],
        'email'          => $sitio['email'] ?? $contenido_anterior['sitio']['email'],
        'horario'        => $sitio['horario'] ?? $contenido_anterior['sitio']['horario'],
        'link_citas'     => $sitio['link_citas'] ?? $contenido_anterior['sitio']['link_citas'],
    ),
    'inicio' => array(
        'titulo'      => $inicio['titulo'] ?? $contenido_anterior['inicio']['titulo'],
        'subtitulo'   => $inicio['subtitulo'] ?? $contenido_anterior['inicio']['subtitulo'],
        'texto_boton' => $inicio['texto_boton'] ?? $contenido_anterior['inicio']['texto_boton'],
    ),
    'quienes_somos' => array(
        'titulo'        => $quienes_somos['titulo'] ?? $contenido_anterior['quienes_somos']['titulo'],
        'nombre_doctor' => $quienes_somos['nombre_doctor'] ?? $contenido_anterior['quienes_somos']['nombre_doctor'],
        'especialidad'  => $quienes_somos['especialidad'] ?? $contenido_anterior['quienes_somos']['especialidad'],
        'cedula'        => $quienes_somos['cedula'] ?? $contenido_anterior['quienes_somos']['cedula'],
        'texto'         => $quienes_somos['texto'] ?? $contenido_anterior['quienes_somos']['texto'],
    ),
    'ubicacion' => array(
        'titulo'      => $ubicacion['titulo'] ?? $contenido_anterior['ubicacion']['titulo'],
        'direccion'   => $ubicacion['direccion'] ?? $contenido_anterior['ubicacion']['direccion'],
        'referencias' => $ubicacion['referencias'] ?? $contenido_anterior['ubicacion']['referencias'],
        'mapa_embed'  => $ubicacion['mapa_embed'] ?? $contenido_anterior['ubicacion']['mapa_embed'],
    ),
    'servicios' => $servicios,
);

if (guardar_contenido($nuevo_contenido)) {
    $_SESSION['flash_ok'] = 'Los cambios se guardaron correctamente.';
} else {
    $_SESSION['flash_ok'] = 'No se pudo guardar el archivo. Verifica los permisos de escritura de data/content.php.';
}

header('Location: dashboard.php');
exit;
