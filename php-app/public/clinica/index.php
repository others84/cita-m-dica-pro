<?php
require_once __DIR__ . '/includes/functions.php';
require_once __DIR__ . '/includes/icons.php';

$contenido = cargar_contenido();
require __DIR__ . '/includes/header.php';
?>

<main>

  <!-- ===================== INICIO ===================== -->
  <section id="inicio" class="hero">
    <div class="container">
      <div>
        <span class="eyebrow">Medicina general · Pediatría · Obstetricia</span>
        <h1><?php echo e($contenido['inicio']['titulo']); ?></h1>
        <p class="lead"><?php echo e($contenido['inicio']['subtitulo']); ?></p>
        <div class="hero-actions">
          <a class="btn btn-primary" href="<?php echo e($contenido['sitio']['link_citas']); ?>" target="_blank" rel="noopener">
            <?php echo e($contenido['inicio']['texto_boton']); ?>
          </a>
          <span class="hero-schedule">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></svg>
            <?php echo e($contenido['sitio']['horario']); ?>
          </span>
        </div>
      </div>
      <div class="hero-art">
        <svg viewBox="0 0 24 24" fill="none" stroke="#2F5D50" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round">
          <path d="M12 21s-7-4.35-9.5-8.5C.7 9 2 5 6 5c2 0 3.5 1.2 4 2.5.5-1.3 2-2.5 4-2.5 4 0 5.3 4 3.5 7.5C19 16.65 12 21 12 21z"/>
          <path d="M4 12h3l1.5-3L11 15l1.5-4.5H20" stroke="#CD7F86"/>
        </svg>
      </div>
    </div>
    <div class="container">
      <svg class="pulse-divider" viewBox="0 0 1100 60" preserveAspectRatio="none" aria-hidden="true">
        <path d="M0,30 L280,30 L320,10 L360,50 L400,30 L440,30 L470,15 L500,45 L530,30 L1100,30" />
      </svg>
    </div>
  </section>

  <!-- ===================== QUIENES SOMOS ===================== -->
  <section id="quienes-somos" class="section">
    <div class="container about-grid">
      <div class="about-photo reveal">
        <svg viewBox="0 0 200 240" fill="none" stroke="#2F5D50" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="100" cy="80" r="42"/>
          <path d="M40 220c0-44 27-70 60-70s60 26 60 70"/>
          <path d="M70 62c10 10 50 10 60 0" stroke="#CD7F86"/>
        </svg>
      </div>
      <div class="reveal">
        <span class="eyebrow">Quiénes somos</span>
        <h2><?php echo e($contenido['quienes_somos']['titulo']); ?></h2>
        <p><?php echo nl2br(e($contenido['quienes_somos']['texto'])); ?></p>
        <div class="about-credentials">
          <strong><?php echo e($contenido['quienes_somos']['nombre_doctor']); ?></strong>
          <span><?php echo e($contenido['quienes_somos']['especialidad']); ?></span>
          <span><?php echo e($contenido['quienes_somos']['cedula']); ?></span>
        </div>
      </div>
    </div>
  </section>

  <!-- ===================== SERVICIOS ===================== -->
  <section id="servicios" class="section section-alt">
    <div class="container">
      <div class="section-head center reveal">
        <span class="eyebrow">Lo que ofrecemos</span>
        <h2>Nuestros servicios</h2>
        <p>Atención integral para cada etapa de la vida, de lunes a viernes.</p>
      </div>
      <div class="services-grid">
        <?php foreach ($contenido['servicios'] as $servicio): ?>
          <div class="service-card reveal">
            <div class="service-icon"><?php echo icono_servicio($servicio['icono']); ?></div>
            <h3><?php echo e($servicio['titulo']); ?></h3>
            <p><?php echo e($servicio['descripcion']); ?></p>
          </div>
        <?php endforeach; ?>
      </div>
    </div>
  </section>

  <!-- ===================== UBICACION ===================== -->
  <section id="ubicacion" class="section">
    <div class="container">
      <div class="section-head reveal">
        <span class="eyebrow">Encuéntranos</span>
        <h2><?php echo e($contenido['ubicacion']['titulo']); ?></h2>
      </div>
      <div class="location-grid reveal">
        <div class="location-card">
          <div class="location-item">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21s-6-5.5-6-11a6 6 0 0 1 12 0c0 5.5-6 11-6 11z"/><circle cx="12" cy="10" r="2.4"/></svg>
            <div>
              <h4>Dirección</h4>
              <p><?php echo e($contenido['ubicacion']['direccion']); ?></p>
            </div>
          </div>
          <div class="location-item">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 11l9-8 9 8"/><path d="M5 10v10h14V10"/></svg>
            <div>
              <h4>Cómo llegar</h4>
              <p><?php echo e($contenido['ubicacion']['referencias']); ?></p>
            </div>
          </div>
          <div class="location-item">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 3"/></svg>
            <div>
              <h4>Horario</h4>
              <p><?php echo e($contenido['sitio']['horario']); ?></p>
            </div>
          </div>
          <div class="location-item">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3 19.5 19.5 0 0 1-6-6 19.8 19.8 0 0 1-3-8.7A2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1.9.3 1.8.6 2.7a2 2 0 0 1-.4 2.1L8.1 9.7a16 16 0 0 0 6 6l1.2-1.2a2 2 0 0 1 2.1-.4c.9.3 1.8.5 2.7.6a2 2 0 0 1 1.9 2z"/></svg>
            <div>
              <h4>Teléfono</h4>
              <p><?php echo e($contenido['sitio']['telefono']); ?></p>
            </div>
          </div>
        </div>
        <div class="map-frame">
          <iframe src="<?php echo e($contenido['ubicacion']['mapa_embed']); ?>" loading="lazy" referrerpolicy="no-referrer-when-downgrade" title="Mapa de ubicación de la clínica"></iframe>
        </div>
      </div>
    </div>
  </section>

  <!-- ===================== CTA CITAS ===================== -->
  <section class="section" style="padding-top:0;">
    <div class="container">
      <div class="cta-band reveal">
        <div>
          <h2>¿Listo para tu consulta?</h2>
          <p>Agenda tu cita en línea de forma rápida; te confirmaremos por teléfono o correo.</p>
        </div>
        <a class="btn btn-primary" href="<?php echo e($contenido['sitio']['link_citas']); ?>" target="_blank" rel="noopener"><?php echo e($contenido['inicio']['texto_boton']); ?></a>
      </div>
    </div>
  </section>

</main>

<?php require __DIR__ . '/includes/footer.php'; ?>
