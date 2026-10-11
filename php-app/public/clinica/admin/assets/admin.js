document.addEventListener('DOMContentLoaded', function () {
  // Navegación por pestañas
  var botones = document.querySelectorAll('.tab-btn');
  var paneles = document.querySelectorAll('.tab-panel');
  botones.forEach(function (boton) {
    boton.addEventListener('click', function () {
      botones.forEach(function (b) { b.classList.remove('is-active'); });
      paneles.forEach(function (p) { p.classList.remove('is-active'); });
      boton.classList.add('is-active');
      document.getElementById(boton.dataset.tab).classList.add('is-active');
    });
  });

  // Agregar / quitar servicios dinámicamente
  var lista = document.getElementById('servicios-lista');
  var botonAgregar = document.getElementById('agregar-servicio');
  if (lista && botonAgregar) {
    botonAgregar.addEventListener('click', function () {
      var indice = lista.querySelectorAll('.service-item').length;
      var plantilla = document.getElementById('plantilla-servicio').innerHTML.replace(/__INDEX__/g, indice);
      var div = document.createElement('div');
      div.innerHTML = plantilla;
      lista.appendChild(div.firstElementChild);
    });

    lista.addEventListener('click', function (evento) {
      if (evento.target.classList.contains('remove-service')) {
        var item = evento.target.closest('.service-item');
        // Siempre deja al menos un servicio
        if (lista.querySelectorAll('.service-item').length > 1) {
          item.remove();
        }
      }
    });
  }
});
