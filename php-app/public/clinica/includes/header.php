<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><?php echo e($contenido['sitio']['nombre_clinica']); ?></title>
<meta name="description" content="<?php echo e($contenido['inicio']['subtitulo']); ?>">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Work+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

<nav class="nav">
  <div class="container">
    <a href="#inicio" class="nav-brand">
      <svg viewBox="0 0 24 24" fill="none" stroke="#2F5D50" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <path d="M12 21s-7-4.35-9.5-8.5C.7 9 2 5 6 5c2 0 3.5 1.2 4 2.5.5-1.3 2-2.5 4-2.5 4 0 5.3 4 3.5 7.5C19 16.65 12 21 12 21z"/>
      </svg>
      <span><?php echo e($contenido['sitio']['nombre_clinica']); ?></span>
    </a>
    <button class="nav-toggle" aria-label="Abrir menú" aria-expanded="false">
      <span></span><span></span><span></span>
    </button>
    <ul class="nav-links">
      <li><a href="#inicio">Inicio</a></li>
      <li><a href="#quienes-somos">Quiénes somos</a></li>
      <li><a href="#servicios">Servicios</a></li>
      <li><a href="#ubicacion">Ubicación</a></li>
      <li class="nav-cta">
        <a class="btn btn-primary" href="<?php echo e($contenido['sitio']['link_citas']); ?>" target="_blank" rel="noopener">Agendar cita</a>
      </li>
    </ul>
  </div>
</nav>
