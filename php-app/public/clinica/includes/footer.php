<footer class="footer">
  <div class="container">
    <div>
      <h4><?php echo e($contenido['sitio']['nombre_clinica']); ?></h4>
      <p><?php echo e($contenido['quienes_somos']['especialidad']); ?></p>
    </div>
    <div>
      <h4>Contacto</h4>
      <p><a href="tel:<?php echo e(preg_replace('/\s+/', '', $contenido['sitio']['telefono'])); ?>"><?php echo e($contenido['sitio']['telefono']); ?></a></p>
      <p><a href="mailto:<?php echo e($contenido['sitio']['email']); ?>"><?php echo e($contenido['sitio']['email']); ?></a></p>
    </div>
    <div>
      <h4>Horario de atención</h4>
      <p><?php echo e($contenido['sitio']['horario']); ?></p>
    </div>
  </div>
  <div class="container footer-bottom">
    <span>&copy; <?php echo date('Y'); ?> <?php echo e($contenido['sitio']['nombre_clinica']); ?>. Todos los derechos reservados.</span>
    <a href="admin/login.php">Acceso administrador</a>
  </div>
</footer>

<script src="assets/js/main.js"></script>
</body>
</html>
