<div class="card">
  <p>Elige la paleta de colores y la tipografía del sistema. Los cambios se
     aplican al instante y se guardan en este dispositivo, de modo que se
     conservan la próxima vez que inicies sesión.</p>

  <h3 style="margin-bottom:.25rem">Paleta de colores</h3>
  <div class="tema-grid" id="temas">
    <?php
    $paletas = [
      ''           => ['Predeterminada (actual)', ['#EAF6FF','#BFDFFF','#7FB6E6','#3E7FB1','#1E3A5F']],
      'esmeralda'  => ['Esmeralda',               ['#EAF7F1','#BFE8D6','#6FC79E','#2E8B62','#144736']],
      'amatista'   => ['Amatista',                ['#F3EEFB','#DCCBF3','#A985DF','#6D45B0','#3A1F63']],
      'atardecer'  => ['Atardecer',               ['#FFF2E8','#FFD9BE','#F2A472','#C96A2E','#6E3312']],
      'grafito'    => ['Grafito',                 ['#EFF1F4','#D3D8E0','#8B95A5','#4A5567','#1C2330']],
    ];
    foreach ($paletas as $id => [$nombre, $cols]): ?>
      <button type="button" class="tema-card" data-tema="<?= htmlspecialchars($id) ?>">
        <h4><?= htmlspecialchars($nombre) ?></h4>
        <div class="tema-swatches">
          <?php foreach ($cols as $c): ?><span style="background:<?= htmlspecialchars($c) ?>"></span><?php endforeach; ?>
        </div>
      </button>
    <?php endforeach; ?>
  </div>

  <div class="form-grid" style="margin-top:1.5rem">
    <label>Tipo de letra
      <select id="fuente">
        <option value="">Predeterminada</option>
        <option value="sistema">Sistema (Segoe UI / Roboto)</option>
        <option value="serif">Serif (Georgia)</option>
        <option value="redondeada">Redondeada (Trebuchet)</option>
        <option value="condensada">Condensada (Arial Narrow)</option>
        <option value="mono">Monoespaciada</option>
      </select>
    </label>
    <label>Tamaño de letra
      <select id="escala">
        <option value="">Predeterminado</option>
        <option value="chica">Chico</option>
        <option value="normal">Normal</option>
        <option value="grande">Grande</option>
      </select>
    </label>
  </div>

  <div class="form-actions">
    <button type="button" class="btn btn-sec" id="restablecer">Restablecer</button>
  </div>
  <p id="tema-aviso" class="flash flash-ok" style="display:none">Apariencia guardada en este dispositivo.</p>
</div>

<script>
(function(){
  var d = document.documentElement;
  var K = { tema:'sgco:tema', fuente:'sgco:fuente', escala:'sgco:escala' };
  var aviso = document.getElementById('tema-aviso');
  var fuente = document.getElementById('fuente');
  var escala = document.getElementById('escala');

  function get(k){ try { return localStorage.getItem(k) || ''; } catch(e){ return ''; } }
  function set(k,v){ try { v ? localStorage.setItem(k,v) : localStorage.removeItem(k); } catch(e){} }
  function attr(name, v){ v ? d.setAttribute(name, v) : d.removeAttribute(name); }
  function notificar(){
    aviso.style.display = 'block';
    clearTimeout(notificar.t);
    notificar.t = setTimeout(function(){ aviso.style.display = 'none'; }, 2000);
  }
  function marcar(){
    var act = get(K.tema);
    document.querySelectorAll('#temas .tema-card').forEach(function(b){
      b.classList.toggle('sel', (b.dataset.tema || '') === act);
    });
  }

  document.querySelectorAll('#temas .tema-card').forEach(function(b){
    b.addEventListener('click', function(){
      var v = b.dataset.tema || '';
      set(K.tema, v); attr('data-tema', v); marcar(); notificar();
    });
  });
  fuente.addEventListener('change', function(){ set(K.fuente, fuente.value); attr('data-fuente', fuente.value); notificar(); });
  escala.addEventListener('change', function(){ set(K.escala, escala.value); attr('data-escala', escala.value); notificar(); });
  document.getElementById('restablecer').addEventListener('click', function(){
    set(K.tema,''); set(K.fuente,''); set(K.escala,'');
    attr('data-tema',''); attr('data-fuente',''); attr('data-escala','');
    fuente.value = ''; escala.value = ''; marcar(); notificar();
  });

  fuente.value = get(K.fuente);
  escala.value = get(K.escala);
  marcar();
})();
</script>
