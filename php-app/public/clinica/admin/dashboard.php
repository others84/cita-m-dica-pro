<?php
require_once __DIR__ . '/../includes/functions.php';
requerir_login();

$contenido = cargar_contenido();
$mensaje = $_SESSION['flash_ok'] ?? '';
unset($_SESSION['flash_ok']);
$token = csrf_token();

$iconos_disponibles = array(
    'consulta'     => 'Consulta general',
    'pediatria'    => 'Pediatría',
    'obstetricia'  => 'Obstetricia',
    'general'      => 'General',
);
?>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Panel de administración</title>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600&family=Work+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../assets/css/style.css">
<link rel="stylesheet" href="assets/admin.css">
</head>
<body class="admin-body">

<div class="admin-topbar">
  <span class="brand">Panel de administración</span>
  <div style="display:flex; align-items:center; gap:18px;">
    <a class="view-site" href="../index.php" target="_blank" rel="noopener">Ver sitio</a>
    <a href="logout.php">Cerrar sesión</a>
  </div>
</div>

<div class="admin-wrap">
  <h1>Contenido del sitio</h1>
  <p>Edita la información que aparece en cada sección. Los cambios se publican de inmediato al guardar.</p>

  <?php if ($mensaje): ?>
    <div class="alert alert-success"><?php echo e($mensaje); ?></div>
  <?php endif; ?>

  <form method="post" action="save.php">
    <input type="hidden" name="csrf_token" value="<?php echo e($token); ?>">

    <div class="tabs">
      <button type="button" class="tab-btn is-active" data-tab="tab-general">Datos generales</button>
      <button type="button" class="tab-btn" data-tab="tab-inicio">Inicio</button>
      <button type="button" class="tab-btn" data-tab="tab-quienes">Quiénes somos</button>
      <button type="button" class="tab-btn" data-tab="tab-servicios">Servicios</button>
      <button type="button" class="tab-btn" data-tab="tab-ubicacion">Ubicación</button>
    </div>

    <!-- DATOS GENERALES -->
    <div id="tab-general" class="tab-panel is-active">
      <div class="field-card">
        <div class="field-row">
          <label for="nombre_clinica">Nombre de la clínica</label>
          <input type="text" id="nombre_clinica" name="sitio[nombre_clinica]" value="<?php echo e($contenido['sitio']['nombre_clinica']); ?>" required>
        </div>
        <div class="two-col">
          <div class="field-row">
            <label for="telefono">Teléfono</label>
            <input type="tel" id="telefono" name="sitio[telefono]" value="<?php echo e($contenido['sitio']['telefono']); ?>" required>
          </div>
          <div class="field-row">
            <label for="email">Correo electrónico</label>
            <input type="email" id="email" name="sitio[email]" value="<?php echo e($contenido['sitio']['email']); ?>" required>
          </div>
        </div>
        <div class="field-row">
          <label for="horario">Horario de atención</label>
          <input type="text" id="horario" name="sitio[horario]" value="<?php echo e($contenido['sitio']['horario']); ?>" required>
        </div>
        <div class="field-row">
          <label for="link_citas">Enlace externo para agendar citas</label>
          <input type="url" id="link_citas" name="sitio[link_citas]" value="<?php echo e($contenido['sitio']['link_citas']); ?>" required>
          <span class="hint">El botón "Agendar cita" del sitio abrirá esta dirección en una pestaña nueva.</span>
        </div>
      </div>
    </div>

    <!-- INICIO -->
    <div id="tab-inicio" class="tab-panel">
      <div class="field-card">
        <div class="field-row">
          <label for="inicio_titulo">Título principal</label>
          <input type="text" id="inicio_titulo" name="inicio[titulo]" value="<?php echo e($contenido['inicio']['titulo']); ?>" required>
        </div>
        <div class="field-row">
          <label for="inicio_subtitulo">Subtítulo</label>
          <textarea id="inicio_subtitulo" name="inicio[subtitulo]" required><?php echo e($contenido['inicio']['subtitulo']); ?></textarea>
        </div>
        <div class="field-row">
          <label for="inicio_boton">Texto del botón de cita</label>
          <input type="text" id="inicio_boton" name="inicio[texto_boton]" value="<?php echo e($contenido['inicio']['texto_boton']); ?>" required>
        </div>
      </div>
    </div>

    <!-- QUIENES SOMOS -->
    <div id="tab-quienes" class="tab-panel">
      <div class="field-card">
        <div class="field-row">
          <label for="qs_titulo">Título de la sección</label>
          <input type="text" id="qs_titulo" name="quienes_somos[titulo]" value="<?php echo e($contenido['quienes_somos']['titulo']); ?>" required>
        </div>
        <div class="two-col">
          <div class="field-row">
            <label for="qs_nombre">Nombre del doctor(a)</label>
            <input type="text" id="qs_nombre" name="quienes_somos[nombre_doctor]" value="<?php echo e($contenido['quienes_somos']['nombre_doctor']); ?>" required>
          </div>
          <div class="field-row">
            <label for="qs_cedula">Cédula profesional</label>
            <input type="text" id="qs_cedula" name="quienes_somos[cedula]" value="<?php echo e($contenido['quienes_somos']['cedula']); ?>">
          </div>
        </div>
        <div class="field-row">
          <label for="qs_especialidad">Especialidad</label>
          <input type="text" id="qs_especialidad" name="quienes_somos[especialidad]" value="<?php echo e($contenido['quienes_somos']['especialidad']); ?>" required>
        </div>
        <div class="field-row">
          <label for="qs_texto">Descripción</label>
          <textarea id="qs_texto" name="quienes_somos[texto]" style="min-height:160px;" required><?php echo e($contenido['quienes_somos']['texto']); ?></textarea>
        </div>
      </div>
    </div>

    <!-- SERVICIOS -->
    <div id="tab-servicios" class="tab-panel">
      <div class="field-card">
        <div id="servicios-lista">
          <?php foreach ($contenido['servicios'] as $i => $servicio): ?>
            <div class="service-item">
              <?php if ($i > 0): ?><button type="button" class="remove-service">Quitar</button><?php endif; ?>
              <div class="field-row">
                <label>Nombre del servicio</label>
                <input type="text" name="servicios[<?php echo $i; ?>][titulo]" value="<?php echo e($servicio['titulo']); ?>" required>
              </div>
              <div class="field-row">
                <label>Descripción</label>
                <textarea name="servicios[<?php echo $i; ?>][descripcion]" required><?php echo e($servicio['descripcion']); ?></textarea>
              </div>
              <div class="field-row">
                <label>Ícono</label>
                <select name="servicios[<?php echo $i; ?>][icono]">
                  <?php foreach ($iconos_disponibles as $clave => $etiqueta): ?>
                    <option value="<?php echo e($clave); ?>" <?php selected($servicio['icono'], $clave); ?>><?php echo e($etiqueta); ?></option>
                  <?php endforeach; ?>
                </select>
              </div>
            </div>
          <?php endforeach; ?>
        </div>
        <button type="button" id="agregar-servicio" class="add-service">+ Agregar servicio</button>
      </div>
    </div>

    <!-- UBICACION -->
    <div id="tab-ubicacion" class="tab-panel">
      <div class="field-card">
        <div class="field-row">
          <label for="ub_titulo">Título de la sección</label>
          <input type="text" id="ub_titulo" name="ubicacion[titulo]" value="<?php echo e($contenido['ubicacion']['titulo']); ?>" required>
        </div>
        <div class="field-row">
          <label for="ub_direccion">Dirección</label>
          <input type="text" id="ub_direccion" name="ubicacion[direccion]" value="<?php echo e($contenido['ubicacion']['direccion']); ?>" required>
        </div>
        <div class="field-row">
          <label for="ub_referencias">Referencias para llegar</label>
          <input type="text" id="ub_referencias" name="ubicacion[referencias]" value="<?php echo e($contenido['ubicacion']['referencias']); ?>">
        </div>
        <div class="field-row">
          <label for="ub_mapa">Enlace del mapa (URL de Google Maps para incrustar)</label>
          <input type="url" id="ub_mapa" name="ubicacion[mapa_embed]" value="<?php echo e($contenido['ubicacion']['mapa_embed']); ?>">
          <span class="hint">En Google Maps: Compartir &rarr; Insertar un mapa &rarr; copia solo la URL que está dentro de src="...".</span>
        </div>
      </div>
    </div>

    <div class="save-bar">
      <button type="submit" class="btn btn-primary">Guardar cambios</button>
    </div>
  </form>
</div>

<!-- Plantilla usada por JavaScript para agregar nuevos servicios -->
<template id="plantilla-servicio">
  <div class="service-item">
    <button type="button" class="remove-service">Quitar</button>
    <div class="field-row">
      <label>Nombre del servicio</label>
      <input type="text" name="servicios[__INDEX__][titulo]" required>
    </div>
    <div class="field-row">
      <label>Descripción</label>
      <textarea name="servicios[__INDEX__][descripcion]" required></textarea>
    </div>
    <div class="field-row">
      <label>Ícono</label>
      <select name="servicios[__INDEX__][icono]">
        <?php foreach ($iconos_disponibles as $clave => $etiqueta): ?>
          <option value="<?php echo e($clave); ?>"><?php echo e($etiqueta); ?></option>
        <?php endforeach; ?>
      </select>
    </div>
  </div>
</template>

<script src="assets/admin.js"></script>
</body>
</html>
