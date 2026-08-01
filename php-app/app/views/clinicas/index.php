<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0"><?= $editId ? 'Editar clinica' : 'Nueva clinica' ?></h2>
  <form method="post" action="<?= url('clinicas/guardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Nombre <input name="nombre" required value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>"></label>
    <label>Direccion <input name="direccion" required value="<?= htmlspecialchars($editRow['direccion'] ?? '') ?>"></label>
    <label>Email <input type="email" name="email" value="<?= htmlspecialchars($editRow['email'] ?? '') ?>"></label>
    <label>Telefono <input name="telefono" value="<?= htmlspecialchars($editRow['telefono'] ?? '') ?>"></label>
    <?php
      $selMun = (int)($editRow['id_CATALOGO_MUNICIPIO'] ?? 0);
      $selEst = 0; $selPais = 0;
      foreach ($municipios as $mu) {
        if ((int)$mu['id_CATALOGO_MUNICIPIO'] === $selMun) {
          $selEst = (int)$mu['id_CATALOGO_ESTADOS']; $selPais = (int)$mu['id_CATALOGO_PAIS']; break;
        }
      }
    ?>
    <label>Pais
      <select id="cl_pais" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($paises as $p): ?>
          <option value="<?= (int)$p['id_CATALOGO_PAIS'] ?>" <?= $selPais===(int)$p['id_CATALOGO_PAIS']?'selected':'' ?>><?= htmlspecialchars($p['nombre']) ?></option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Estado
      <select id="cl_estado" required>
        <option value="">-- seleccione --</option>
      </select>
    </label>
    <label>Municipio
      <select id="cl_municipio" name="id_CATALOGO_MUNICIPIO" required>
        <option value="">-- seleccione --</option>
      </select>
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url('clinicas') ?>">Cancelar</button><?php  endif; ?>
    </div>
  </form>
</div>
<script>
(function(){
  var ESTADOS = <?= json_encode(array_map(fn($e)=>['id'=>(int)$e['id_CATALOGO_ESTADOS'],'nombre'=>$e['nombre'],'pais'=>(int)$e['id_CATALOGO_PAIS']], $estados), JSON_UNESCAPED_UNICODE) ?>;
  var MUNICIPIOS = <?= json_encode(array_map(fn($m)=>['id'=>(int)$m['id_CATALOGO_MUNICIPIO'],'nombre'=>$m['nombre'],'estado'=>(int)$m['id_CATALOGO_ESTADOS']], $municipios), JSON_UNESCAPED_UNICODE) ?>;
  var SEL_EST = <?= (int)$selEst ?>, SEL_MUN = <?= (int)$selMun ?>;
  var pais = document.getElementById('cl_pais'),
      est  = document.getElementById('cl_estado'),
      mun  = document.getElementById('cl_municipio');
  function fill(sel, items, selected){
    sel.innerHTML = '<option value="">-- seleccione --</option>';
    items.forEach(function(it){
      var o = document.createElement('option');
      o.value = it.id; o.textContent = it.nombre;
      if (Number(selected) === it.id) o.selected = true;
      sel.appendChild(o);
    });
  }
  function loadEstados(selected){
    var p = Number(pais.value)||0;
    fill(est, ESTADOS.filter(function(e){ return e.pais === p; }), selected);
  }
  function loadMunicipios(selected){
    var e = Number(est.value)||0;
    fill(mun, MUNICIPIOS.filter(function(m){ return m.estado === e; }), selected);
  }
  pais.addEventListener('change', function(){ loadEstados(0); loadMunicipios(0); });
  est.addEventListener('change', function(){ loadMunicipios(0); });
  loadEstados(SEL_EST); loadMunicipios(SEL_MUN);
})();
</script>
<table class="data">
  <thead><tr><th>Nombre</th><th>Pais</th><th>Estado</th><th>Municipio</th><th>Telefono</th><th>Activa</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php foreach ($rows as $c): ?>
      <tr>
        <td><?= htmlspecialchars($c['nombre']) ?></td>
        <td><?= htmlspecialchars($c['pais'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['estado'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['municipio'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['telefono'] ?? '') ?></td>
        <td><span class="badge <?= empty($c['activo'])?'off':'' ?>"><?= empty($c['activo']) ? 'No' : 'Si' ?></span></td>
        <td class="acts">
          <?php post_button('clinicas', ['edit' => (int)$c['id_CLINICA']], 'Editar', 'btn btn-sec'); ?>
          <?php if (!empty($c['activo'])): ?>
            <form method="post" action="<?= url('clinicas/desactivar') ?>" style="display:inline"><?= csrf_field() ?>
              <input type="hidden" name="id" value="<?= (int)$c['id_CLINICA'] ?>"><button class="btn btn-danger">Desactivar</button>
            </form>
          <?php else: ?>
            <form method="post" action="<?= url('clinicas/activar') ?>" style="display:inline"><?= csrf_field() ?>
              <input type="hidden" name="id" value="<?= (int)$c['id_CLINICA'] ?>"><button class="btn">Activar</button>
            </form>
          <?php endif; ?>
        </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>