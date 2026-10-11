document.addEventListener('DOMContentLoaded', function () {
  // Menú móvil
  var toggle = document.querySelector('.nav-toggle');
  var links = document.querySelector('.nav-links');
  if (toggle && links) {
    toggle.addEventListener('click', function () {
      var abierto = links.classList.toggle('is-open');
      toggle.setAttribute('aria-expanded', abierto ? 'true' : 'false');
    });
    links.querySelectorAll('a').forEach(function (enlace) {
      enlace.addEventListener('click', function () {
        links.classList.remove('is-open');
        toggle.setAttribute('aria-expanded', 'false');
      });
    });
  }

  // Resaltado del enlace activo en la barra de navegación
  var secciones = document.querySelectorAll('main [id]');
  var navEnlaces = document.querySelectorAll('.nav-links a[href^="#"]');
  if (secciones.length && navEnlaces.length && 'IntersectionObserver' in window) {
    var observerNav = new IntersectionObserver(function (entradas) {
      entradas.forEach(function (entrada) {
        if (entrada.isIntersecting) {
          navEnlaces.forEach(function (a) { a.classList.remove('is-active'); });
          var activo = document.querySelector('.nav-links a[href="#' + entrada.target.id + '"]');
          if (activo) activo.classList.add('is-active');
        }
      });
    }, { rootMargin: '-40% 0px -50% 0px' });
    secciones.forEach(function (s) { observerNav.observe(s); });
  }

  // Animación de aparición al hacer scroll
  var revelables = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window && revelables.length) {
    var observer = new IntersectionObserver(function (entradas, obs) {
      entradas.forEach(function (entrada) {
        if (entrada.isIntersecting) {
          entrada.target.classList.add('is-visible');
          obs.unobserve(entrada.target);
        }
      });
    }, { threshold: 0.15 });
    revelables.forEach(function (el) { observer.observe(el); });
  } else {
    revelables.forEach(function (el) { el.classList.add('is-visible'); });
  }
});
