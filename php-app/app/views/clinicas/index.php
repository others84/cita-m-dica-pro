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
    <?php $esqSel = (string)($editRow['esquema'] ?? 'SOLO_CLINICA'); ?>
    <label>Esquema
      <select id="cl_esquema" name="esquema" required>
        <?php foreach ($esquemas as $k => $v): ?>
          <option value="<?= htmlspecialchars($k) ?>" <?= $esqSel===$k?'selected':'' ?>><?= htmlspecialchars($v['label']) ?></option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Max. asistentes
      <input type="number" id="cl_max_asis" name="max_asistentes" min="0" max="50" required
             value="<?= (int)($editRow['max_asistentes'] ?? $esquemas[$esqSel]['asistentes']) ?>">
    </label>
    <label>Max. medicos
      <input type="number" id="cl_max_med" name="max_medicos" min="0" max="50" required
             value="<?= (int)($editRow['max_medicos'] ?? $esquemas[$esqSel]['medicos']) ?>">
    </label>
    <label>Max. administradores de clinica
      <input type="number" id="cl_max_adm" name="max_admins" min="0" max="50" required
             value="<?= (int)($editRow['max_admins'] ?? $esquemas[$esqSel]['admins']) ?>">
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

  // Al cambiar de esquema se precargan los limites (siguen siendo editables).
  var DEF = <?= json_encode(array_map(fn($v)=>['a'=>$v['asistentes'],'m'=>$v['medicos'],'d'=>$v['admins']], $esquemas), JSON_UNESCAPED_UNICODE) ?>;
  var esq = document.getElementById('cl_esquema');
  if (esq) esq.addEventListener('change', function(){
    var d = DEF[esq.value]; if (!d) return;
    document.getElementById('cl_max_asis').value = d.a;
    document.getElementById('cl_max_med').value  = d.m;
    document.getElementById('cl_max_adm').value  = d.d;
  });
})();
</script>
<div id="clinicas-tabla">
  <?php require __DIR__ . '/_tabla.php'; ?>
</div>

<script>
(function(){
  var container = document.getElementById('clinicas-tabla');
  var endpoint = '<?= url('clinicas/tabla') ?>';

  function attach(root) {
    root = root || document;
    root.querySelectorAll('.sort-form').forEach(function(f){ f.addEventListener('submit', onAjax); });
    root.querySelectorAll('.page-form').forEach(function(f){ f.addEventListener('submit', onAjax); });
  }

  async function reloadTable(body) {
    if (!container) return;
    container.style.opacity = '0.6';
    try {
      var res = await fetch(endpoint, { method: 'POST', body: body });
      if (!res.ok) throw new Error('Error ' + res.status);
      container.innerHTML = await res.text();
      attach(container);
    } catch (err) {
      console.error('No se pudo actualizar la tabla:', err);
    } finally {
      container.style.opacity = '1';
    }
  }

  function onAjax(e) {
    e.preventDefault();
    reloadTable(new FormData(e.currentTarget));
  }

  attach();
})();
</script>